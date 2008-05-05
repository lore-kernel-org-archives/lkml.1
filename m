Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYEEDqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYEEDqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbYEEDn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:43:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYEEDnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:43:00 -0400
Date: Sun, 4 May 2008 23:42:46 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805050342.m453gkgB029853@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/18] flag parameters: NONBLOCK in signalfd
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the SFD_NONBLOCK flag to signalfd4.  The
additional changes needed are minimal thanks to the previous preparation.

The following test must be adjusted for architectures other than x86 and
x86-64 and in case the syscall numbers changed.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_signalfd4
# ifdef __x86_64__
#  define __NR_signalfd4 289
# elif defined __i386__
#  define __NR_signalfd4 327
# else
#  error "need __NR_signalfd4"
# endif
#endif

#define SFD_NONBLOCK (1 << 1)

int
main (void)
{
  sigset_t ss;
  sigemptyset (&ss);
  sigaddset (&ss, SIGUSR1);
  int fd = syscall (__NR_signalfd4, -1, &ss, 8, 0);
  if (fd == -1)
    {
      puts ("signalfd4(0) failed");
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
      puts ("signalfd4(0) set non-blocking mode");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_signalfd4, -1, &ss, 8, SFD_NONBLOCK);
  if (fd == -1)
    {
      puts ("signalfd4(SFD_NONBLOCK) failed");
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
      puts ("signalfd4(SFD_NONBLOCK) does not set non-blocking mode");
      return 1;
    }
  close (fd);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 fs/signalfd.c            |    1 +
 include/linux/signalfd.h |    1 +
 2 files changed, 2 insertions(+)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 6197256..a73333b 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -208,6 +208,7 @@ static const struct file_operations signalfd_fops = {
 
 static const struct flags_rmap signalfd_file_flags_remap[] = {
 	{ SFD_CLOEXEC, O_CLOEXEC },
+	{ SFD_NONBLOCK, O_NONBLOCK }
 };
 
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask,
diff --git a/include/linux/signalfd.h b/include/linux/signalfd.h
index ea037f2..98a749a 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -11,6 +11,7 @@
 
 /* Flags for signalfd4.  */
 #define SFD_CLOEXEC (1 << 0)
+#define SFD_NONBLOCK (1 << 1)
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
