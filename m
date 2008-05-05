Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYEEDoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYEEDoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYEEDnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:43:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbYEEDmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:42:55 -0400
Date: Sun, 4 May 2008 23:42:46 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805050342.m453gkae029859@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 16/18] flag parameters: NONBLOCK in timerfd_create
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TFD_NONBLOCK flag to timerfd_create.  The
additional changes needed are minimal thanks to the previous preparation.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_timerfd_create
# ifdef __x86_64__
#  define __NR_timerfd_create 283
# elif defined __i386__
#  define __NR_timerfd_create 322
# else
#  error "need __NR_timerfd_create"
# endif
#endif

#define TFD_NONBLOCK (1 << 1)

int
main (void)
{
  int fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, 0);
  if (fd == -1)
    {
      puts ("timerfd_create(0) failed");
      return 1;
    }
  int fl = fcntl (fd, F_GETFL);
  if (fl == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if (fl & O_NONBLOCK)
    {
      puts ("timerfd_create(0) set non-blocking mode");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_timerfd_create, CLOCK_REALTIME, TFD_NONBLOCK);
  if (fd == -1)
    {
      puts ("timerfd_create(TFD_NONBLOCK) failed");
      return 1;
    }
  fl = fcntl (fd, F_GETFL);
  if (fl == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if ((fl & O_NONBLOCK) == 0)
    {
      puts ("timerfd_create(TFD_NONBLOCK) set non-blocking mode");
      return 1;
    }
  close (fd);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 fs/timerfd.c            |    1 +
 include/linux/timerfd.h |    1 +
 2 files changed, 2 insertions(+)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/fs/timerfd.c b/fs/timerfd.c
index d87d354..f998991 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -182,6 +182,7 @@ static struct file *timerfd_fget(int fd)
 
 static const struct flags_rmap timerfd_file_flags_remap[] = {
 	{ TFD_CLOEXEC, O_CLOEXEC },
+	{ TFD_NONBLOCK, O_NONBLOCK }
 };
 
 asmlinkage long sys_timerfd_create(int clockid, int flags)
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index cf2b10d..c2fb04e 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -13,6 +13,7 @@
 
 /* Flags for timerfd_create.  */
 #define TFD_CLOEXEC (1 << 0)
+#define TFD_NONBLOCK (1 << 1)
 
 
 #endif /* _LINUX_TIMERFD_H */
