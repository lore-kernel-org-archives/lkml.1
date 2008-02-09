Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYBIP4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYBIP4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYBIPz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:55:57 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:34096 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYBIPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=c0wuZXnkjmSTZuOWqNOUvgQGGfK7t5g5ThvgJkO4pxLwLjncLeLs47KO0JLoVY267VbUHYcYfc4M0X9O82zsOeWZsQkpq1Bmir5ijH0v3NcenHZTUih+Br0eFrJrPbsq4HwH6SlC2Uhq6vxI2RrLqLl0vTv5CN4Yptsb1mFi3Jc=
Message-ID: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com>
Date: Sun, 10 Feb 2008 00:55:54 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [sample] mem_notify v6: usage example
Cc: kosaki.motohiro@jp.fujitsu.com, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Jon Masters" <jonathan@jonmasters.org>, "Zan Lynx" <zlynx@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f52375eb7243644f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is usage example of /dev/mem_notify.

Daniel Spang create original version.
kosaki add fasync related code.


Signed-off-by: Daniel Spang <daniel.spang@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 Documentation/mem_notify.c |  120 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

Index: b/Documentation/mem_notify.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/Documentation/mem_notify.c	2008-02-10 00:44:00.000000000 +0900
@@ -0,0 +1,120 @@
+/*
+ * Allocate 10 MB each second. Exit on notification.
+ */
+
+#define _GNU_SOURCE
+
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <poll.h>
+#include <pthread.h>
+#include <errno.h>
+#include <signal.h>
+
+int count = 0;
+int size = 10;
+
+void *do_alloc()
+{
+        for(;;) {
+                int *buffer;
+                buffer = mmap(NULL,  size*1024*1024,
+                              PROT_READ | PROT_WRITE,
+                              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+                if (buffer == MAP_FAILED) {
+                        perror("mmap");
+                        exit(EXIT_FAILURE);
+                }
+                memset(buffer, 1 , size*1024*1024);
+
+                printf("-");
+                fflush(stdout);
+
+                count++;
+                sleep(1);
+        }
+}
+
+int wait_for_notification(struct pollfd *pfd)
+{
+        int ret;
+        read(pfd->fd, 0, 0);
+        ret = poll(pfd, 1, -1);              /* wake up when low memory */
+        if (ret == -1 && errno != EINTR) {
+                perror("poll");
+                exit(EXIT_FAILURE);
+        }
+        return ret;
+}
+
+void do_free()
+{
+	int fd;
+	struct pollfd pfd;
+
+        fd = open("/dev/mem_notify", O_RDONLY);
+        if (fd == -1) {
+                perror("open");
+                exit(EXIT_FAILURE);
+        }
+
+	pfd.fd = fd;
+        pfd.events = POLLIN;
+        for(;;)
+                if (wait_for_notification(&pfd) > 0) {
+                        printf("\nGot notification, allocated %d MB\n",
+                               size * count);
+                        exit(EXIT_SUCCESS);
+                }
+}
+
+void do_free_signal()
+{
+	int fd;
+	int flags;
+
+        fd = open("/dev/mem_notify", O_RDONLY);
+        if (fd == -1) {
+                perror("open");
+                exit(EXIT_FAILURE);
+        }
+
+	fcntl(fd, F_SETOWN, getpid());
+	fcntl(fd, F_SETSIG, SIGUSR1);
+
+	flags = fcntl(fd, F_GETFL);
+	fcntl(fd, F_SETFL, flags|FASYNC); /* when low memory, receive SIGUSR1 */
+
+	for(;;)
+		sleep(1);
+}
+
+
+void daniel_exit(int signo)
+{
+	printf("\nGot notification %d, allocated %d MB\n",
+	       signo, size * count);
+	exit(EXIT_SUCCESS);
+
+}
+
+int main(int argc, char *argv[])
+{
+        pthread_t allocator;
+
+	if(argc == 2 && (strcmp(argv[1], "-sig") == 0)) {
+		printf("run signal mode\n");
+		signal(SIGUSR1, daniel_exit);
+		pthread_create(&allocator, NULL, do_alloc, NULL);
+		do_free_signal();
+	} else {
+		printf("run poll mode\n");
+		pthread_create(&allocator, NULL, do_alloc, NULL);
+		do_free();
+	}
+	return 0;
+}
