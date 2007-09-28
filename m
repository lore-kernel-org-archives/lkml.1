Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbXI1RfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbXI1RfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXI1RfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:35:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXI1RfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:35:04 -0400
Date: Fri, 28 Sep 2007 13:34:29 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: F_DUPFD_CLOEXEC implementation
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more small change to extend the availability of creation of
file descriptors with FD_CLOEXEC set.  Adding a new command to
fcntl() requires no new system call and the overall impact on
code size if minimal.

If this patch gets accepted we will also add this change to the
next revision of the POSIX spec.

To test the patch, use the following little program.  Adjust the
value of F_DUPFD_CLOEXEC appropriately.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef F_DUPFD_CLOEXEC
# define F_DUPFD_CLOEXEC 12
#endif

int
main (int argc, char *argv[])
{
  if  (argc > 1)
    {
      if (fcntl (3, F_GETFD) == 0)
	{
	  puts ("descriptor not closed");
	  exit (1);
	}
      if (errno != EBADF)
	{
	  puts ("error not EBADF");
	  exit (1);
	}

      exit (0);
    }
  int fd = fcntl (STDOUT_FILENO, F_DUPFD_CLOEXEC, 0);
  if (fd == -1 && errno == EINVAL)
    {
      puts ("F_DUPFD_CLOEXEC not supported");
      return 0;
    }
  if (fd != 3)
    {
      puts ("program called with descriptors other than 0,1,2");
      return 1;
    }

  execl ("/proc/self/exe", "/proc/self/exe", "1", NULL);
  puts ("execl failed");
  return 1;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 78b2ff0..c9db73f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -110,7 +110,7 @@ out:
 	return error;
 }
 
-static int dupfd(struct file *file, unsigned int start)
+static int dupfd(struct file *file, unsigned int start, int cloexec)
 {
 	struct files_struct * files = current->files;
 	struct fdtable *fdt;
@@ -122,7 +122,10 @@ static int dupfd(struct file *file, unsigned int start)
 		/* locate_fd() may have expanded fdtable, load the ptr */
 		fdt = files_fdtable(files);
 		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
+		if (cloexec)
+			FD_SET(fd, fdt->close_on_exec);
+		else
+			FD_CLR(fd, fdt->close_on_exec);
 		spin_unlock(&files->file_lock);
 		fd_install(fd, file);
 	} else {
@@ -195,7 +198,7 @@ asmlinkage long sys_dup(unsigned int fildes)
 	struct file * file = fget(fildes);
 
 	if (file)
-		ret = dupfd(file, 0);
+		ret = dupfd(file, 0, 0);
 	return ret;
 }
 
@@ -319,8 +322,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 
 	switch (cmd) {
 	case F_DUPFD:
+	case F_DUPFD_CLOEXEC:
 		get_file(filp);
-		err = dupfd(filp, arg);
+		err = dupfd(filp, arg, cmd == F_DUPFD_CLOEXEC);
 		break;
 	case F_GETFD:
 		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index b847741..b01408a 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -73,6 +73,9 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#ifndef F_DUPFD_CLOEXEC
+#define F_DUPFD_CLOEXEC	12
+#endif
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
