Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYK0Nll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYK0Nll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYK0Nlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:41:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYK0Nla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:41:30 -0500
Date: Thu, 27 Nov 2008 14:41:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081127134121.GA22736@elte.hu>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126201054.GB2624@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Andi Kleen - Wed, Nov 26, 2008 at 09:04:33PM +0100]
> | gorcunov@gmail.com writes:
> | > --- a/arch/x86/kernel/entry_64.S
> | > +++ b/arch/x86/kernel/entry_64.S
> | > @@ -379,7 +379,10 @@ ENTRY(ret_from_fork)
> | >  	GET_THREAD_INFO(%rcx)
> | >  	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
> | >  	CFI_REMEMBER_STATE
> | > -	jnz rff_trace
> | > +	jz rff_action
> | > +	movq %rsp,%rdi
> | > +	call syscall_trace_leave
> | > +	GET_THREAD_INFO(%rcx)
> | 
> | The uncommon path is supposed to be out of line. I don't think
> | the CPU will like that.
> | 
> | -Andi
> | 
> | >  rff_action:
> | 
> | -- 
> | ak@linux.intel.com
> | 
> 
> Aha! Thanks Andi for review.

Unfortunately that review got you off the right track ...

The principle you applied was good: entry_64.S is murky, and we want 
to simplify the current overcomplicated assembly code flow spaghetti 
there.

Note that if you take a closer look at rff_trace/rff_action 
ret_from_fork code here, you'll realize that it does all the wrong 
things: for example it checks the TIF flag - while later on jumping 
back to the ret-from-syscall path - duplicating the check needlessly.

But it gets worse than that: checking for _TIF_SYSCALL_TRACE is 
completely unnecessary here because we clear that flag for every 
freshly forked task. So the whole "tracing" code here, for which there 
is this "out of line jump optimization" is in reality completely dead 
code in the ptrace case...

Could you test something like the patch attached below, which cleans 
up this code and applies the code reduction and speedup? Warning: 
completely untested! Please check that things like strace -f and gdb 
attaching to forked tasks still works fine. (it should by all means)

Thanks,

	Ingo

---
 arch/x86/kernel/entry_64.S |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -366,34 +366,35 @@ ENTRY(save_paranoid)
 END(save_paranoid)
 
 /*
- * A newly forked process directly context switches into this.
+ * A newly forked process directly context switches into this address.
+ *
+ * rdi: prev task we switched from
  */
-/* rdi:	prev */
 ENTRY(ret_from_fork)
 	DEFAULT_FRAME
+
 	push kernel_eflags(%rip)
 	CFI_ADJUST_CFA_OFFSET 8
-	popf				# reset kernel eflags
+	popf					# reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET -8
-	call schedule_tail
+
+	call schedule_tail			# rdi: 'prev' task parameter
+
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
+
 	CFI_REMEMBER_STATE
-	jnz rff_trace
-rff_action:
 	RESTORE_REST
-	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
+
+	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
 	je   int_ret_from_sys_call
-	testl $_TIF_IA32,TI_flags(%rcx)
+
+	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
+
 	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
-	jmp ret_from_sys_call
+	jmp ret_from_sys_call			# go to the SYSRET fastpath
+
 	CFI_RESTORE_STATE
-rff_trace:
-	movq %rsp,%rdi
-	call syscall_trace_leave
-	GET_THREAD_INFO(%rcx)
-	jmp rff_action
 	CFI_ENDPROC
 END(ret_from_fork)
 
