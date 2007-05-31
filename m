Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbXEaSNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbXEaSNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXEaSND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:13:03 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33880 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305AbXEaSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:13:01 -0400
Date: Thu, 31 May 2007 14:04:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/3] syslet demos - AIO file reading
Message-ID: <20070531180430.GA9787@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aio-read uses the async_exec mechanism to queue reads of pages of a
file.  As completions come in, new reads are queued until all pages in
the file have requests queued or finished.  When that has happened, it
just waits for the remaining completions to come in.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 Makefile   |    6 ++-
 aio-read.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+), 2 deletions(-)

Index: async-test-v5/Makefile
===================================================================
--- async-test-v5.orig/Makefile	2007-05-31 13:28:42.000000000 -0400
+++ async-test-v5/Makefile	2007-05-31 13:46:14.000000000 -0400
@@ -1,5 +1,4 @@
-
-all: hello syslet-test threadlet-test evserver_threadlet evserver_epoll evserver_epoll_threadlet
+all: hello syslet-test threadlet-test evserver_threadlet evserver_epoll evserver_epoll_threadlet aio-read
 	@echo version: async
 
 clean:
@@ -15,3 +14,6 @@ evserver_threadlet: evserver_threadlet.c
 	gcc -O2 -g -Wall -o evserver_threadlet evserver_threadlet.c -fomit-frame-pointer
 evserver_epoll_threadlet: evserver_epoll_threadlet.c syslet.h sys.h threadlet.h Makefile
 	gcc -O2 -g -Wall -o evserver_epoll_threadlet evserver_epoll_threadlet.c -fomit-frame-pointer
+
+aio-read: aio-read.c syslet.h sys.h Makefile
+	gcc -O2 -g -Wall -o aio-read aio-read.c -fomit-frame-pointer
Index: async-test-v5/aio-read.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ async-test-v5/aio-read.c	2007-05-31 13:31:00.000000000 -0400
@@ -0,0 +1,114 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/fcntl.h>
+#include <sys/stat.h>
+#include "sys.h"
+
+/*
+ * Set up a syslet atom:
+ */
+static void
+init_atom(struct syslet_uatom *atom, int nr,
+	  void *arg_ptr0, void *arg_ptr1, void *arg_ptr2,
+	  void *arg_ptr3, void *arg_ptr4, void *arg_ptr5,
+	  void *ret_ptr, unsigned long flags, struct syslet_uatom *next)
+{
+	atom->nr = nr;
+	atom->arg_ptr[0] = (u64)(unsigned long)arg_ptr0;
+	atom->arg_ptr[1] = (u64)(unsigned long)arg_ptr1;
+	atom->arg_ptr[2] = (u64)(unsigned long)arg_ptr2;
+	atom->arg_ptr[3] = (u64)(unsigned long)arg_ptr3;
+	atom->arg_ptr[4] = (u64)(unsigned long)arg_ptr4;
+	atom->arg_ptr[5] = (u64)(unsigned long)arg_ptr5;
+	atom->ret_ptr = (u64)(unsigned long)ret_ptr;
+	atom->flags = flags;
+	atom->next = (u64)(unsigned long)next;
+}
+
+#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
+
+static int collect_status()
+{
+	int n = 0;
+
+	sys_async_wait(1, async_head.user_ring_idx, &async_head);
+	while(completion_ring[async_head.user_ring_idx] != 0){
+		completion_ring[async_head.user_ring_idx++] = 0;
+		async_head.user_ring_idx %= ARRAY_SIZE(completion_ring);
+		n++;
+	}
+
+	return n;
+}
+
+int main(int argc, char *argv[])
+{
+	struct syslet_uatom *atoms, *done;
+	struct stat stbuf;
+	char *file, *buf;
+	int fd, err, npages, i, len, async, sync;
+
+	if(argc < 2){
+		fprintf(stderr, "Usage : aio-read file\n");
+		exit(1);
+	}
+
+	file = argv[1];
+	fd = open(file, O_RDONLY);
+	if(fd < 0){
+		perror("open");
+		exit(1);
+	}
+
+	err = fstat(fd, &stbuf);
+	if(err < 0){
+		perror("stat");
+		exit(1);
+	}
+
+	buf = malloc(stbuf.st_size);
+	if(buf == NULL){
+		perror("malloc");
+		exit(1);
+	}
+
+	len = getpagesize();
+	npages = (stbuf.st_size + len - 1) / len;
+	atoms = malloc(npages * sizeof(struct syslet_uatom));
+	if(atoms == NULL){
+		perror("malloc atoms");
+		exit(1);
+	}
+
+	async_head_init();
+	async = 0;
+	sync = 0;
+	for(i = 0; i < npages; i++){
+		char *ptr = &buf[i * len];
+		init_atom(&atoms[i], __NR_sys_read, &fd, &ptr, &len,
+			  NULL, NULL, NULL, NULL, 0, NULL);
+		if(async_head.new_thread_stack == 0)
+			async_head.new_thread_stack = thread_stack_alloc();
+		done = sys_async_exec(&atoms[i], &async_head);
+		if(done == &atoms[i]){
+			sync++;
+			continue;
+		}
+		else if(done < 0)
+			perror("sys_async_exec");
+
+		async++;
+		if(async < ARRAY_SIZE(completion_ring))
+			continue;
+
+		async -= collect_status();
+	}
+
+	while(async)
+		async -= collect_status();
+
+	return 0;
+}
