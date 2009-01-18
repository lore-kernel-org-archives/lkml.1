Return-Path: <linux-kernel-owner+w=401wt.eu-S934137AbZARPb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbZARPb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbZARPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:30:12 -0500
Received: from mail-ew0-f12.google.com ([209.85.219.12]:43630 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765091AbZARPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gR0xsmjah2Q3zbTuGeiT1dAz6xMaT27XrLtCjeobpzb6lJOqVX1ICqEsX+3T0R2M6r
         M4x2m7PBnAIpY0g7vcNYYJcGWVjk+I9ahCOV9m65tXah7tTYsAMJfsFTO2ZRIYPwwHY7
         rxi3t2kRsyFqt3DVfwUzxVGv+yeIEsHLEcmf8=
Date: Sun, 18 Jan 2009 16:32:21 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Jens Axboe <axboe@suse.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] splice: fix deadlock
Message-ID: <20090118153221.GA20980@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8e1d58b03b47d937bc5e53d902bac6e690709034 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 18 Jan 2009 16:07:29 +0100
Subject: [PATCH] splice: fix deadlock

splice from a file or socket needs to lock both the file/socket and the
pipe inodes. pipe_wait() unlocks only the pipe lock, regardless of the
order in which they were taken.

This patch adds an additional (optional) argument to pipe_wait(); if
specified, pipe_wait() will unlock and reacquire both inode locks.

It fixes the lockup that occurs with the test-case below, but please
review carefully. Consider this patch a proposal rather than a fix.

 #define _GNU_SOURCE

 #include <sys/socket.h>
 #include <sys/types.h>

 #include <fcntl.h>
 #include <errno.h>
 #include <pthread.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>

 static int sock_fd[2];
 static int pipe_fd[2];

 #define N 16384

 static void *do_write(void *unused)
 {
 	unsigned int i;

 	for (i = 0; i < N; ++i)
 		write(pipe_fd[1], "x", 1);

 	return NULL;
 }

 static void *do_read(void *unused)
 {
 	unsigned int i;
 	char c;

 	for (i = 0; i < N; ++i)
 		read(sock_fd[0], &c, 1);

 	return NULL;
 }

 static void *do_splice(void *unused)
 {
 	unsigned int i;

 	for (i = 0; i < N; ++i)
 		splice(pipe_fd[0], NULL, sock_fd[1], NULL, 1, 0);

 	return NULL;
 }

 int main(int argc, char *argv[])
 {
 	pthread_t writer;
 	pthread_t reader;
 	pthread_t splicer[2];

 	while (1) {
 		if (socketpair(AF_UNIX, SOCK_STREAM, 0, sock_fd) == -1)
 			exit(EXIT_FAILURE);

 		if (pipe(pipe_fd) == -1)
 			exit(EXIT_FAILURE);

 		pthread_create(&writer, NULL, &do_write, NULL);
 		pthread_create(&reader, NULL, &do_read, NULL);
 		pthread_create(&splicer[0], NULL, &do_splice, NULL);
 		pthread_create(&splicer[1], NULL, &do_splice, NULL);

 		pthread_join(writer, NULL);
 		pthread_join(reader, NULL);
 		pthread_join(splicer[0], NULL);
 		pthread_join(splicer[1], NULL);

 		printf("failed to deadlock, retrying...\n");
 	}

 	return EXIT_SUCCESS;
 }

Cc: Jens Axboe <axboe@suse.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 fs/fifo.c                 |    2 +-
 fs/pipe.c                 |   19 +++++++++++--------
 fs/splice.c               |    8 ++++----
 include/linux/pipe_fs_i.h |    4 ++--
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/fifo.c b/fs/fifo.c
index f8f97b8..bd2bfc6 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -20,7 +20,7 @@ static void wait_for_partner(struct inode* inode, unsigned int *cnt)
 	int cur = *cnt;	
 
 	while (cur == *cnt) {
-		pipe_wait(inode->i_pipe);
+		pipe_wait(inode->i_pipe, NULL);
 		if (signal_pending(current))
 			break;
 	}
diff --git a/fs/pipe.c b/fs/pipe.c
index 3a48ba5..eb7b893 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -37,8 +37,13 @@
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe)
+/*
+ * Drop the inode semaphore and wait for a pipe event, atomically.
+ *
+ * inode2 specifies another inode lock to drop. May be NULL if no such other
+ * inode exists.
+ */
+void pipe_wait(struct pipe_inode_info *pipe, struct inode *inode2)
 {
 	DEFINE_WAIT(wait);
 
@@ -47,12 +52,10 @@ void pipe_wait(struct pipe_inode_info *pipe)
 	 * is considered a noninteractive wait:
 	 */
 	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	inode_double_unlock(pipe->inode, inode2);
 	schedule();
 	finish_wait(&pipe->wait, &wait);
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	inode_double_lock(pipe->inode, inode2);
 }
 
 static int
@@ -377,7 +380,7 @@ redo:
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 		}
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 	}
 	mutex_unlock(&inode->i_mutex);
 
@@ -550,7 +553,7 @@ redo2:
 			do_wakeup = 0;
 		}
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 out:
diff --git a/fs/splice.c b/fs/splice.c
index 4ed0ba4..e79e906 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -240,7 +240,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		}
 
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 
@@ -690,7 +690,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 			do_wakeup = 0;
 		}
 
-		pipe_wait(pipe);
+		pipe_wait(pipe, sd->u.file->f_mapping->host);
 	}
 
 	if (do_wakeup) {
@@ -1523,7 +1523,7 @@ static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 				break;
 			}
 		}
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 	}
 
 	mutex_unlock(&pipe->inode->i_mutex);
@@ -1563,7 +1563,7 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			break;
 		}
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 8e41202..be2d399 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -134,8 +134,8 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe);
+/* Drop the inode semaphore(s) and wait for a pipe event, atomically */
+void pipe_wait(struct pipe_inode_info *pipe, struct inode *inode2);
 
 struct pipe_inode_info * alloc_pipe_info(struct inode * inode);
 void free_pipe_info(struct inode * inode);
-- 
1.5.6.6

