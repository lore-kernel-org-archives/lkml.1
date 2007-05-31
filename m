Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXEaSJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXEaSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXEaSJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:09:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979AbXEaSJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:09:22 -0400
Date: Thu, 31 May 2007 14:09:15 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Introduce O_CLOEXEC (take >2)
Cc: akpm@linux-foundation.org, mingo@elte.hu, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've brought this topic up before but didn't provide a patch.  Well, here
we go again, this time with a patch.  I even throw in a test program.

The problem is as follows: in multi-threaded code (or more correctly: all
code using clone() with CLONE_FILES) we have a race when exec'ing.

   thread #1                       thread #2

   fd=open()

                                   fork + exec

  fcntl(fd,F_SETFD,FD_CLOEXEC)

In some applications this can happen frequently.  Take a web browser.  One
thread opens a file and another thread starts, say, an external PDF viewer.
The result can even be a security issue if that open file descriptor refers
to a sensitive file and the external program can somehow be tricked into
using that descriptor.

Just adding O_CLOEXEC support to open() doesn't solve the whole set of
problems.  There are other ways to create file descriptors (socket,
epoll_create, Unix domain socket transfer, etc).  These can and should
be addressed separately though.  open() is such an easy case that it makes
not much sense putting the fix off.

The test program:

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#ifndef O_CLOEXEC
# define O_CLOEXEC 02000000
#endif

int
main (int argc, char *argv[])
{
  int fd;
  if (argc > 1)
    {
      fd = atol (argv[1]);
      printf ("child: fd = %d\n", fd);
      if (fcntl (fd, F_GETFD) == 0 || errno != EBADF)
        {
          puts ("file descriptor valid in child");
          return 1;
        }
      return 0;
    }

  fd = open ("/proc/self/exe", O_RDONLY | O_CLOEXEC);
  printf ("in parent: new fd = %d\n", fd);
  char buf[20];
  snprintf (buf, sizeof (buf), "%d", fd);
  execl ("/proc/self/exe", argv[0], buf, NULL);
  puts ("execl failed");
  return 1;
}



Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/open.c b/fs/open.c
index 0d515d1..e6991c1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -855,7 +855,7 @@ EXPORT_SYMBOL(dentry_open);
 /*
  * Find an empty file descriptor entry, and mark it busy.
  */
-int get_unused_fd(void)
+static int get_unused_fd_flags(int flags)
 {
 	struct files_struct * files = current->files;
 	int fd, error;
@@ -891,7 +891,10 @@ repeat:
 	}
 
 	FD_SET(fd, fdt->open_fds);
-	FD_CLR(fd, fdt->close_on_exec);
+	if (flags & O_CLOEXEC)
+		FD_SET(fd, fdt->close_on_exec);
+	else
+		FD_CLR(fd, fdt->close_on_exec);
 	files->next_fd = fd + 1;
 #if 1
 	/* Sanity check */
@@ -907,6 +910,11 @@ out:
 	return error;
 }
 
+int get_unused_fd(void)
+{
+	return get_unused_fd_flags(0);
+}
+
 EXPORT_SYMBOL(get_unused_fd);
 
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
@@ -959,7 +967,7 @@ long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
-		fd = get_unused_fd();
+		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
 			struct file *f = do_filp_open(dfd, tmp, flags, mode);
 			if (IS_ERR(f)) {
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index c154b9d..b847741 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -48,6 +48,9 @@
 #ifndef O_NOATIME
 #define O_NOATIME	01000000
 #endif
+#ifndef O_CLOEXEC
+#define O_CLOEXEC	02000000	/* set close_on_exec */
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
