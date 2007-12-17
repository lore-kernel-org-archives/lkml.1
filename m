Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXLQTZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXLQTZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLQTZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:25:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbXLQTZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:25:27 -0500
Message-ID: <4766CCD0.3030300@redhat.com>
Date: Mon, 17 Dec 2007 14:24:00 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 0/6] (yet another) kprobes x86 code unification	and
 boosters
References: <47669E87.1010506@redhat.com> <20071217163342.GA10495@elte.hu>
In-Reply-To: <20071217163342.GA10495@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hello all,
>>
>> I developed a series of patches which unifies kprobes code on x86 and 
>> introduces boosters on x86-64. These patches can be applied to 
>> 2.6.24-rc4-mm1.
>>
>> The purpose of this patchset is unifying kprobes_[32|64].[c|h] to 
>> kprobes.[c|h] for simplifying code maintenance.
>>
>> I know these patches are conflicting with Harvey's patch. We need to 
>> solve that.
> 
> your series fixes the 64-bit crash that i was seeing, so i've picked it 
> up. Please work it out with Harvey which cleanups of him are not 
> included yet.

Absolutely sure.
I compared my patch and Harvey's.
These directions are almost same.

Harvey, I have found some differences and I'd like to fix that with you.
I think following comments and style cleanups in your patch are good to me.

> @@ -156,7 +157,7 @@ twobyte_has_modrm[256 / sizeof(unsigned long)] = {
>  #undef RF
>  
>  /* insert a jmp code */
> -static __always_inline void set_jmp_op(void *from, void *to)
> +static inline void set_jmp_op(void *from, void *to)
>  {
>  	struct __arch_jmp_op {
>  		char op;
> @@ -170,7 +171,7 @@ static __always_inline void set_jmp_op(void *from, void *to)
>  /*
>   * returns non-zero if opcodes can be boosted.
>   */
> -static __always_inline int can_boost(kprobe_opcode_t *opcodes)
> +static inline int can_boost(kprobe_opcode_t *opcodes)
>  {
>  	kprobe_opcode_t opcode;
>  	kprobe_opcode_t *orig_opcodes = opcodes;


> @@ -734,7 +740,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
>  	regs->flags |= kcb->kprobe_saved_flags;
>  	trace_hardirqs_fixup_flags(regs->flags);
>  
> -	/*Restore back the original saved kprobes variables and continue. */
> +	/* Restore the original saved kprobes variables and continue. */
>  	if (kcb->kprobe_status == KPROBE_REENTER) {
>  		restore_previous_kprobe(kcb);
>  		goto out;
> @@ -860,7 +866,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
>  	addr = (unsigned long)(kcb->jprobe_saved_sp);
>  
>  	/*
> -	 * TBD: As Linus pointed out, gcc assumes that the callee
> +	 * As Linus pointed out, gcc assumes that the callee
>  	 * owns the argument space and could overwrite it, e.g.
>  	 * tailcall optimization. So, to be absolutely safe
>  	 * we also save and restore enough stack bytes to cover

And also, if you can unify x86/mm/extable_*.c and introduce fixup_exception() to 64-bit,
it is very helpful to remove ifdefs from kprobe_fault_handler().

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

