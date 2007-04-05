Return-Path: <linux-kernel-owner+w=401wt.eu-S1767299AbXDEUkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767299AbXDEUkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767301AbXDEUkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:40:35 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:47205 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767299AbXDEUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:40:33 -0400
Subject: [PATCH] Lguest launcher, child starving parent
From: Steven Rostedt <rostedt@goodmis.org>
To: virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 16:40:20 -0400
Message-Id: <1175805620.24675.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber noticed long delays between hitting a key, and seeing data come
up on the virtual console.  Looking into this, I found that the
wake_parent routine that reads from all devices was actually starving
out the parent after sending the parent a signal to wake up.

The thing is, the child which takes the console input is recognized by
the scheduler as an interactive process.  The parent, doesn't do so
much, so it is recognized more as a CPU hog. So the child easily gets a
higher priority than the parent.

So when the child receives data from the console, it sends a signal to
the parent and then does another select.  The problem is that the select
doesn't actually read from the device, and will return immediately since
their is still data pending until it is read.  But it's the parent that
reads the data.  So the child actually starves the parent from reading
the data by spinning and waiting for it to read the data.

The fix I implemented was to have the child wait for a response from the
parent before going on. Since there was already communication between
the parent and child via a pipe, I used that. This time, the data
returned by the pipe is either everything went fine (fd == -1) or the
device should be ignored (fd >= 0).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-lguest/Documentation/lguest/lguest.c
===================================================================
--- linux-2.6-lguest.orig/Documentation/lguest/lguest.c	2007-04-05 16:13:08.000000000 -0400
+++ linux-2.6-lguest/Documentation/lguest/lguest.c	2007-04-05 16:16:31.000000000 -0400
@@ -328,15 +328,15 @@ static void wake_parent(int pipefd, stru
 
 	for (;;) {
 		fd_set rfds = devices->infds;
+		int ignorefd;
 
 		select(devices->max_infd+1, &rfds, NULL, NULL, NULL);
-		if (FD_ISSET(pipefd, &rfds)) {
-			int ignorefd;
-			if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
-				exit(0);
-			FD_CLR(ignorefd, &devices->infds);
-		}
 		kill(getppid(), SIGUSR1);
+		/* wait for parent response */
+		if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
+			exit(0);
+		if (ignorefd >= 0)
+			FD_CLR(ignorefd, &devices->infds);
 	}
 }
 
@@ -594,6 +594,7 @@ static void handle_output(int fd, unsign
 static void handle_input(int fd, int childfd, struct device_list *devices)
 {
 	struct timeval poll = { .tv_sec = 0, .tv_usec = 0 };
+	int fdok = -1;
 
 	for (;;) {
 		struct device *i;
@@ -608,7 +609,9 @@ static void handle_input(int fd, int chi
 					FD_CLR(i->fd, &devices->infds);
 					/* Tell child to ignore it too... */
 					write(childfd, &i->fd, sizeof(i->fd));
-				}
+				} else
+					/* Tell child to continue */
+					write(childfd, &fdok, sizeof(fdok));
 			}
 		}
 	}


