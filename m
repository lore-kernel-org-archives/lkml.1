Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZCXXZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZCXXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZCXXZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:25:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZCXXZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:25:10 -0400
Message-ID: <49C96BFE.9020709@redhat.com>
Date: Tue, 24 Mar 2009 19:25:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com, tglx@linutronix.de,
       systemtap@sources.redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kprobes] x86: kretprobe-booster interrupt	emulation
 code fix
References: <49C7995C.2010601@redhat.com> <tip-b9dad0d2955db059cd92c81c37ddcbef0abc8bf8@git.kernel.org> <20090324131359.GA13210@elte.hu> <20090324144657.GH3891@in.ibm.com>
In-Reply-To: <20090324144657.GH3891@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Tue, Mar 24, 2009 at 02:13:59PM +0100, Ingo Molnar wrote:
>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>>  	regs->ip = trampoline_address;
>>>  	regs->orig_ax = ~0UL;
>>> +	regs->gs = 0;
>> hm, this wont build on 32-bit.
> 
> I guess you meant 64 bit. Yes I see that it fails to build on x86_64.
> 
> Regards,
> Bharata.

Thanks, here I updated my patch.
---

Fix interrupt emulation code in kretprobe-booster according to
pt_regs update (es/ds change and gs adding).

This issue has been reported on systemtap-bugzilla:
http://sources.redhat.com/bugzilla/show_bug.cgi?id=9965

On a -tip kernel on x86_32, kretprobe_example (from samples) triggers the
following backtrace when its retprobing a class of functions that cause a
copy_from/to_user().

 BUG: sleeping function called from invalid context at mm/memory.c:3196
 in_atomic(): 0, irqs_disabled(): 1, pid: 2286, name: cat
 1 lock held by cat/2286:
 #0:  (&p->lock){+.+.+.}, at: [<c04b4eb1>] seq_read+0x35/0x31d
 irq event stamp: 1613
 hardirqs last  enabled at (1613): [<c06b5914>] _spin_unlock_irqrestore+0x3c/0x48
 hardirqs last disabled at (1612): [<c06b5a7f>] _spin_lock_irqsave+0x1a/0x3f
 softirqs last  enabled at (1610): [<c04348c5>] __do_softirq+0x164/0x183
 softirqs last disabled at (1603): [<c0404d2c>] do_softirq+0x68/0xc8
 Pid: 2286, comm: cat Not tainted 2.6.29-rc8-tip-acde #1
 Call Trace:
  [<c0429017>] __might_sleep+0xde/0xe3
  [<c048c6e1>] might_fault+0x1f/0x80
  [<c0535b87>] copy_to_user+0x2f/0x106
  [<c04b5120>] seq_read+0x2a4/0x31d
  [<c04d4882>] proc_reg_read+0x6a/0x84
  [<c04b4e7c>] ? seq_read+0x0/0x31d
  [<c04d4882>] ? proc_reg_read+0x6a/0x84
  [<c04d4818>] ? proc_reg_read+0x0/0x84
  [<c04a1f73>] vfs_read+0x90/0xef
  [<c04a208b>] sys_read+0x4e/0x75
  [<c044d338>] ? trace_hardirqs_on_caller+0x11d/0x141
  [<c0402fc4>] sysenter_do_call+0x12/0x38
  [<c0402fc4>] ? sysenter_do_call+0x12/0x38

Steps to recreate:
 1. put kretprobe on meminfo_proc_show.
 2. cat /proc/meminfo
 3. Your dmesg should have the above trace.

Problem doesn't happen with 2.6.29-rc8.

This is a kretprobe booster bug on x86_32. Commit ccbeed3a modifies the
pt_regs, the kretprobe_trampoline() part of the kretprobe booster needs to be
updated to handle the gs register.

changes from v1:
 - Don't set regs->gs if CONFIG_X86_64=y.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/kernel/kprobes.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 55b9461..7b5169d 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -638,13 +638,13 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 #else
 			"	pushf\n"
 			/*
-			 * Skip cs, ip, orig_ax.
+			 * Skip cs, ip, orig_ax and gs.
 			 * trampoline_handler() will plug in these values
 			 */
-			"	subl $12, %esp\n"
+			"	subl $16, %esp\n"
 			"	pushl %fs\n"
-			"	pushl %ds\n"
 			"	pushl %es\n"
+			"	pushl %ds\n"
 			"	pushl %eax\n"
 			"	pushl %ebp\n"
 			"	pushl %edi\n"
@@ -655,10 +655,10 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	movl %esp, %eax\n"
 			"	call trampoline_handler\n"
 			/* Move flags to cs */
-			"	movl 52(%esp), %edx\n"
-			"	movl %edx, 48(%esp)\n"
+			"	movl 56(%esp), %edx\n"
+			"	movl %edx, 52(%esp)\n"
 			/* Replace saved flags with true return address. */
-			"	movl %eax, 52(%esp)\n"
+			"	movl %eax, 56(%esp)\n"
 			"	popl %ebx\n"
 			"	popl %ecx\n"
 			"	popl %edx\n"
@@ -666,8 +666,8 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	popl %edi\n"
 			"	popl %ebp\n"
 			"	popl %eax\n"
-			/* Skip ip, orig_ax, es, ds, fs */
-			"	addl $20, %esp\n"
+			/* Skip ds, es, fs, gs, orig_ax and ip */
+			"	addl $24, %esp\n"
 			"	popf\n"
 #endif
 			"	ret\n");
@@ -691,6 +691,7 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	regs->cs = __KERNEL_CS;
 #else
 	regs->cs = __KERNEL_CS | get_kernel_rpl();
+	regs->gs = 0;
 #endif
 	regs->ip = trampoline_address;
 	regs->orig_ax = ~0UL;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

