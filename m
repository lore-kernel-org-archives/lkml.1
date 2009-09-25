Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZIYWFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZIYWFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZIYWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:05:53 -0400
Received: from claw.goop.org ([74.207.240.146]:52515 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZIYWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:05:52 -0400
Message-ID: <4ABD3EC2.1020104@goop.org>
Date: Fri, 25 Sep 2009 15:05:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86: unify sys_iopl
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The x86-64 implementation of iopl was buggy because it never ended up calling
set_iopl_mask().  This had no effect on native sys_iopl (because set_iopl_mask
is normally no-op on 64-bit), but it ended up never calling the pvop, which caused
iopl to have no effect on 64-bit Xen guests.

The two functions are needlessly different anyway.  This patch just unifies them
into a single function which is mostly derived from the 32-bit version.

Thanks,
	J

The following changes since commit c44c9ec0f38b939b3200436e3aa95c1aa83c41c7:
  Jeremy Fitzhardinge (1):
        x86: split NX setup into separate file to limit unstack-protected code

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git bugfix

Jeremy Fitzhardinge (1):
      x86: unify sys_iopl

 arch/x86/include/asm/syscalls.h |    8 +++-----
 arch/x86/kernel/ioport.c        |   11 ++---------
 2 files changed, 5 insertions(+), 14 deletions(-)

>From 8dbb1d168eb8be6bf43d123fdfb3ba3b03762e62 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 23 Sep 2009 16:35:24 -0700
Subject: [PATCH] x86: unify sys_iopl

The 32 and 64-bit versions of sys_iopl were needlessly different:
 - The 32-bit version ignored its function argument and directly
   fetched the parameter from struct regs, presumably code dating
   from the neolithic era.
 - The 64-bit version never called set_iopl_mask().  Usually this
   is a no-op for 64-bit, but it is also a pvop, which meant that
   that iopl never worked for 64-bit guests under Xen.
 - Both versions use the archaic style of getting pt_regs passed
   to them.  We can get the current pt_regs with task_pt_regs, which
   avoids worrying about the fine details of stack layout.

We can use the body of the 32-bit function with a few small
adjustments to the function definition.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 372b76e..5336ce2 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -33,11 +33,11 @@ long sys_rt_sigreturn(struct pt_regs *);
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
-/* X86_32 only */
-#ifdef CONFIG_X86_32
 /* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
+asmlinkage long sys_iopl(unsigned int);
 
+/* X86_32 only */
+#ifdef CONFIG_X86_32
 /* kernel/process_32.c */
 int sys_clone(struct pt_regs *);
 int sys_execve(struct pt_regs *);
@@ -70,8 +70,6 @@ int sys_vm86(struct pt_regs *);
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
 
 /* kernel/process_64.c */
 asmlinkage long sys_clone(unsigned long, unsigned long,
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 99c4d30..bad4f22 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -119,11 +119,10 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
 	return 0;
 }
 
-#ifdef CONFIG_X86_32
-long sys_iopl(struct pt_regs *regs)
+asmlinkage long sys_iopl(unsigned int level)
 {
-	unsigned int level = regs->bx;
 	struct thread_struct *t = &current->thread;
+	struct pt_regs *regs = task_pt_regs(current);
 	int rc;
 
 	rc = do_iopl(level, regs);
@@ -135,9 +134,3 @@ long sys_iopl(struct pt_regs *regs)
 out:
 	return rc;
 }
-#else
-asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
-{
-	return do_iopl(level, regs);
-}
-#endif


