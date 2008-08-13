Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYHMR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYHMR4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYHMR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:56:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:33209 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHMR4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Ikzo5sNnhv8BUThT7VtSm7GCYIMr2rHhYoEy32TdvwmtDO43hhJY6F9QnStO7GiGtq
         Pvl3KBCraiX8djCsv3W4POgpMdHedAaVpIzHRhOvtRxLDGtSnco2JWpOdhsJGEYDfWu9
         EzzAXRKYTFBDoGJuXJ9J5GU22CntfPdlnQ1pE=
Message-ID: <4f3ee3290808131056jd29d68cr9c6d17285ac64257@mail.gmail.com>
Date: Wed, 13 Aug 2008 19:56:12 +0200
From: cboulte@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] /proc/self/maps doesn't display the real file offset
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 kernel on i386 platform.

http://bugzilla.kernel.org/show_bug.cgi?id=11318

In function show_map (file: fs/proc/task_mmu.c), if vma->vm_pgoff >
2^20 than (vma->vm_pgoff << PAGE_SIZE) is greater than 2^32 (with
PAGE_SIZE equal to 4096 (i.e. 2^12). The next seq_printf use an
unsigned long for the conversion of (vma->vm_pgoff << PAGE_SIZE), as a
result the offset value displayed in /proc/self/maps is truncated if
the page offset is greater than 2^20.

A test that show this issue:

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define PAGE_SIZE (getpagesize())

#if __i386__
#   define U64_STR "%llx"
#elif __x86_64
#   define U64_STR "%lx"
#else
#   error "Architecture Unsupported"
#endif

int main(int argc, char *argv[])
{
	int fd;
	char *addr;
	off64_t offset = 0x10000000;
	char *filename = "/dev/zero";

	fd = open(filename, O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	offset *= 0x10;
	printf("offset = " U64_STR "\n", offset);

	addr = (char*)mmap64(NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd,
			     offset);
	if ((void*)addr == MAP_FAILED) {
		perror("mmap64");
		return 1;
	}

	{
		FILE *fmaps;
		char *line = NULL;
		size_t len = 0;
		ssize_t read;
		size_t filename_len = strlen(filename);

		fmaps = fopen("/proc/self/maps", "r");
		if (!fmaps) {
			perror("fopen");
			return 1;
		}
		while ((read = getline(&line, &len, fmaps)) != -1) {
			if ((read > filename_len + 1)
			    && (strncmp(&line[read - filename_len - 1], filename,
filename_len) == 0))
				printf("%s", line);
		}

		if (line)
			free(line);

		fclose(fmaps);
	}

	close(fd);
	return 0;
}

Signed-off-by: Clement Calmels <cboulte@gmail.com>
---
 fs/proc/nommu.c    |    4 ++--
 fs/proc/task_mmu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.26/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.26.orig/fs/proc/task_mmu.c
+++ linux-2.6.26/fs/proc/task_mmu.c
@@ -219,14 +219,14 @@ static int show_map(struct seq_file *m,
 		ino = inode->i_ino;
 	}

-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			vma->vm_start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			vma->vm_pgoff << PAGE_SHIFT,
+		        ((loff_t) vma->vm_pgoff) << PAGE_SHIFT,
 			MAJOR(dev), MINOR(dev), ino, &len);

 	/*
Index: linux-2.6.26/fs/proc/nommu.c
===================================================================
--- linux-2.6.26.orig/fs/proc/nommu.c
+++ linux-2.6.26/fs/proc/nommu.c
@@ -52,14 +52,14 @@ int nommu_vma_show(struct seq_file *m, s
 	}

 	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 		   vma->vm_start,
 		   vma->vm_end,
 		   flags & VM_READ ? 'r' : '-',
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   vma->vm_pgoff << PAGE_SHIFT,
+		   ((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
 		   MAJOR(dev), MINOR(dev), ino, &len);

 	if (file) {
