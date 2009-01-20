Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZATG3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZATG3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZATG3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:29:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:48598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZATG3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:29:23 -0500
Message-ID: <49756F3E.6050304@gawab.com>
Date: Mon, 19 Jan 2009 22:29:18 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.C4F.Q9QdJB@chimera>
In-Reply-To: <2QN7KFic7LG.A.C4F.Q9QdJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12505
> Subject		: 2.6.29-rc1 Firefox crashing on page load
> Submitter	: Justin Madru <jdm64@gawab.com>
> Date		: 2009-01-16 20:56 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> Handled-By	: Justin P. Mattock <justinmattock@gmail.com>
>
>
>
>   
Yes, still a regression sofar, but I've bisected it and checked it with 
a revert of the bad commit.
The revert does fix the bug, but we've yet to figure out why, or come up 
with a patch.

commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date:   Fri Dec 5 17:17:09 2008 -0800

   x86: signal: change type of paramter for sys_rt_sigreturn()

   Impact: cleanup on 32-bit

   Peter pointed this parameter can be changed.

   Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
   Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 f5fba48247ff200092c38a54e334f495917229d5 
b901159897e5d85e0dc2a0c9d904d9a73c1d58a2 M      arch

   arch/x86/include/asm/syscalls.h
   arch/x86/kernel/signal.c

diff --git a/arch/x86/include/asm/syscalls.h 
b/arch/x86/include/asm/syscalls.h
index 87803da..3a5252c 100644 (file)
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -33,7 +33,7 @@ asmlinkage int sys_sigaction(int, const struct 
old_sigaction __user *,
                            struct old_sigaction __user *);
asmlinkage int sys_sigaltstack(unsigned long);
asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(struct pt_regs);

/* kernel/ioport.c */
asmlinkage long sys_iopl(unsigned long);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b1f4d34..b1cc6da 100644 (file)
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -642,11 +642,9 @@ badframe:
}

#ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
{
-       struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-       return do_rt_sigreturn(regs);
+       return do_rt_sigreturn(&regs);
}
#else /* !CONFIG_X86_32 */
asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)

Justin Madru
