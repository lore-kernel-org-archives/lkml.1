Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZLISbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZLISbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZLISbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:31:36 -0500
Received: from claw.goop.org ([74.207.240.146]:60059 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbZLISbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:31:36 -0500
Message-ID: <4B1FED0D.7060003@goop.org>
Date: Wed, 09 Dec 2009 10:31:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu>
In-Reply-To: <20091209073632.GD8187@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/09 23:36, Ingo Molnar wrote:
> Jeremy, mind sending a patch that updates this code to use the less
> obfuscated 32-bit version, not the 64-bit version? (a delta patch
> against tip:master would be nice, as there's a fair amount of testing in
> the unification change itself already, which we dont want to discard.)
>    

How does this look?

git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git fix-iopl

From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
Date: Wed, 9 Dec 2009 10:26:59 -0800
Subject: [PATCH] x86: Make sys_iopl use passed-in pt_regs

Rather than using task_pt_regs, use the pt_regs * passed into the syscall.
The ABI differences are handled in small 32/64-bit specific functions,
and everything else is handled in the common do_iopl().

Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 5336ce2..70497f0 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -33,11 +33,11 @@ long sys_rt_sigreturn(struct pt_regs *);
  asmlinkage int sys_set_thread_area(struct user_desc __user *);
  asmlinkage int sys_get_thread_area(struct user_desc __user *);

-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int);
-
  /* X86_32 only */
  #ifdef CONFIG_X86_32
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(struct pt_regs *);
+
  /* kernel/process_32.c */
  int sys_clone(struct pt_regs *);
  int sys_execve(struct pt_regs *);
@@ -71,6 +71,9 @@ int sys_vm86(struct pt_regs *);

  /* X86_64 only */

+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
  /* kernel/process_64.c */
  asmlinkage long sys_clone(unsigned long, unsigned long,
  			  void __user *, void __user *,
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index bad4f22..ac3cf88 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -105,6 +105,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
   */
  static int do_iopl(unsigned int level, struct pt_regs *regs)
  {
+	struct thread_struct *t =&current->thread;
  	unsigned int old = (regs->flags>>  12)&  3;

  	if (level>  3)
@@ -116,21 +117,20 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
  	}
  	regs->flags = (regs->flags&  ~X86_EFLAGS_IOPL) | (level<<  12);

+	t->iopl = level<<  12;
+	set_iopl_mask(t->iopl);
+
  	return 0;
  }

-asmlinkage long sys_iopl(unsigned int level)
+#ifdef CONFIG_X86_64
+asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
  {
-	struct thread_struct *t =&current->thread;
-	struct pt_regs *regs = task_pt_regs(current);
-	int rc;
-
-	rc = do_iopl(level, regs);
-	if (rc<  0)
-		goto out;
-
-	t->iopl = level<<  12;
-	set_iopl_mask(t->iopl);
-out:
-	return rc;
+	return do_iopl(level, regs);
+}
+#else
+asmlinkage long sys_iopl(struct pt_regs *regs)
+{
+	return do_iopl(regs->bx, regs);
  }
+#endif


