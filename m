Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYDVQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYDVQTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYDVQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:19:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYDVQTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:19:30 -0400
Message-ID: <480E0FCF.1030704@redhat.com>
Date: Tue, 22 Apr 2008 12:18:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Adrian Bunk <bunk@kernel.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi>	 <480D1B14.7070806@redhat.com> <1208869770.7115.265.camel@twins>
In-Reply-To: <1208869770.7115.265.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thank you for the patch,

Peter Zijlstra wrote:
> So the below makes it work - but I'm not getting this code; at the time
> I wrote that stuff I CC'ed each and every kprobe maintainer listed in
> the usual places but got no reposonse - can some please explain this
> stuff to me?

Sure, I came to the same decision. It is enough to remove unnecessary
trace_hardirqs_fixup_flags() from post_kprobe_handler. pt_regs->flags is
just a variable on stack -- not effective flags in that time. So we don't
need to change thread's hardirq flag.

> Are the saved flags only for the TF bit or are they made in full effect
> later (and if so, where) ?

The saved flags is for TF and IF bits.
Actually, kprobes does following:

---
do_int3()
 kprobe_exceptions_notify()
  kprobe_handler()
   prepare_singlestep() : save regs->flags, set TF and clear IF on regs->flags
"iret" : pop regs->flags image to EFLAGS reg.

<single step an instruction>

do_debug()
 kprobe_exceptions_notify()
  post_kprobe_handler() : restore regs->flags (clearing TF and restoring IF)
"iret" : pop regs->flags image to EFLAGS reg.
---

While executing a single step, EFLAGS is different from the original EFLAGS.
However, it will be recovered soon by post_kprobe_handler.
NOTE: if the single-stepping instruction is a pushf, kprobes writes saved
     EFLAGS to the top of stack.

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I tested it on x86-64/i386.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 34a5912..fe71e64 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -865,7 +865,6 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
>  
>         resume_execution(cur, regs, kcb);
>         regs->flags |= kcb->kprobe_saved_flags;
> -       trace_hardirqs_fixup_flags(regs->flags);
>  
>         /* Restore back the original saved kprobes variables and continue. */
>         if (kcb->kprobe_status == KPROBE_REENTER) {
> 
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

