Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZLCVJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZLCVJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZLCVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:09:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZLCVJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:09:25 -0500
Date: Thu, 3 Dec 2009 22:09:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/paravirt for v2.6.33
Message-ID: <20091203210913.GA24351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-paravirt-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-paravirt-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (1):
      x86: unify sys_iopl


 arch/x86/include/asm/syscalls.h |    8 +++-----
 arch/x86/kernel/ioport.c        |   11 ++---------
 2 files changed, 5 insertions(+), 14 deletions(-)

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
