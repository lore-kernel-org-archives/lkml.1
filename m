Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbXGGQZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbXGGQZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbXGGQZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:25:33 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:37350 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXGGQZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:25:32 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Eric W Biederman <ebiederm@xmission.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Sat, 07 Jul 2007 22:17:22 +0530
Message-Id: <20070707164722.1356.52206.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH -rc7][resend] kthread: Silence bogus section mismatch warning
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This:

WARNING: kernel/built-in.o(.text+0x16910): Section mismatch:
reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')

comes because kernel/kthread.c:kthreadd() is not __init but calls
kthreadd_setup() which is __init. But this is ok, because kthreadd_setup()
is only ever called at init time, and then kthreadd() proceeds into its
"for (;;)" loop. We could mark kthreadd __init_refok, but kthreadd_setup()
with just one callsite and 4 lines in it (it's been that small since
10ab825bdef8df51) doesn't need to be a separate function at all -- so let's
just move those four lines at beginning of kthreadd() itself.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

First discussed in http://lkml.org/lkml/2007/6/26/274,
and I keep getting this with:

|$ ld -V
|GNU ld version 2.17
|  Supported emulations:
|   elf_i386
|   i386linux
|   elf_x86_64

|$ gcc -v
|Reading specs from /usr/lib/gcc/i386-pc-linux-gnu/3.4.4/specs
|Configured with: /var/tmp/portage/gcc-3.4.4-r1/work/gcc-3.4.4/configure
|--prefix=/usr --bindir=/usr/i386-pc-linux-gnu/gcc-bin/3.4.4
|--with-gxx-include-dir=/usr/lib/gcc/i386-pc-linux-gnu/3.4.4/include/g++-v3
|--host=i386-pc-linux-gnu --build=i386-pc-linux-gnu --disable-altivec
|--enable-nls --without-included-gettext --with-system-zlib --disable-checking
|--disable-werror --disable-libunwind-exceptions --disable-multilib
|--disable-libgcj --enable-languages=c,c++,f77 --enable-shared
|--enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu
|Thread model: posix
|gcc version 3.4.4 (Gentoo 3.4.4-r1, ssp-3.4.4-1.0, pie-8.7.8)

 kernel/kthread.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

---

diff -ruNp a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c	2007-06-26 06:33:08.000000000 +0530
+++ b/kernel/kthread.c	2007-06-27 02:57:46.000000000 +0530
@@ -214,23 +214,15 @@ int kthread_stop(struct task_struct *k)
 }
 EXPORT_SYMBOL(kthread_stop);
 
-
-static __init void kthreadd_setup(void)
+int kthreadd(void *unused)
 {
 	struct task_struct *tsk = current;
 
+	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
-
 	ignore_signals(tsk);
-
 	set_user_nice(tsk, -5);
 	set_cpus_allowed(tsk, CPU_MASK_ALL);
-}
-
-int kthreadd(void *unused)
-{
-	/* Setup a clean context for our children to inherit. */
-	kthreadd_setup();
 
 	current->flags |= PF_NOFREEZE;
 
