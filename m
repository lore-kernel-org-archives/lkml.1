Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZCLLUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZCLLUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZCLLUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:20:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34213 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbZCLLUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:20:38 -0400
Message-Id: <49B8FE3C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 11:21:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Alexander van Heukelum" <heukelum@fastmail.fm>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix unwind annotations in entry_64.S
References: <49B8F2DF.76E4.0078.0@novell.com>
 <20090312104834.GA30204@elte.hu>
In-Reply-To: <20090312104834.GA30204@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 12.03.09 11:48 >>>
>* Jan Beulich <jbeulich@novell.com> wrote:
>>  	.macro XCPT_FRAME start=1 offset=0
>> -	INTR_FRAME \start, RIP+\offset-ORIG_RAX
>> -	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
>> +	INTR_FRAME \start, __stringify(RIP+\offset-ORIG_RAX)
>>  	.endm
>>  
>>  /*
>>   * frame that enables calling into C.
>>   */
>>  	.macro PARTIAL_FRAME start=1 offset=0
>> -	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
>> +	.if \start >= 0
>> +	XCPT_FRAME \start, __stringify(ORIG_RAX+\offset-ARGOFFSET)
>> +	.endif
>
>So we pass in a stringified parameter from PARTIAL_FRAME to 
>XCPT_FRAME and then we stringify it again?

Yes and no. You have to realize that __stringify() is a C preprocessor
operation, while the rest is assembler macro expansion (which strips the
quotes again, as they're just used to identify how much of the argument
string applies to the respective macro parameter. I've seen rather ugly
and difficult to diagnose problems with the assembler without doing this
(in the code before this patch they happened to work out of pure luck,
and dependent on undocumented gas internals).

>> -	movq_cfi rdi, RDI+16-ARGOFFSET
>> -	movq_cfi rsi, RSI+16-ARGOFFSET
>> -	movq_cfi rdx, RDX+16-ARGOFFSET
>> -	movq_cfi rcx, RCX+16-ARGOFFSET
>> -	movq_cfi rax, RAX+16-ARGOFFSET
>> -	movq_cfi  r8,  R8+16-ARGOFFSET
>> -	movq_cfi  r9,  R9+16-ARGOFFSET
>> -	movq_cfi r10, R10+16-ARGOFFSET
>> -	movq_cfi r11, R11+16-ARGOFFSET
>> +	movq %rdi, RDI+16-ARGOFFSET(%rsp)
>> +	movq %rsi, RSI+16-ARGOFFSET(%rsp)
>> +	movq %rdx, RDX+16-ARGOFFSET(%rsp)
>> +	movq %rcx, RCX+16-ARGOFFSET(%rsp)
>> +	movq_cfi rax, __stringify(RAX+16-ARGOFFSET)
>> +	movq  %r8,  R8+16-ARGOFFSET(%rsp)
>> +	movq  %r9,  R9+16-ARGOFFSET(%rsp)
>> +	movq %r10, R10+16-ARGOFFSET(%rsp)
>> +	movq_cfi r11, __stringify(R11+16-ARGOFFSET)
>
>Hm, we used to have annotations for those arguments too, now 
>they are gone.

It is pointless to annotate those, as the function doesn't modify them.

>>  	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
>> +	CFI_DEF_CFA_REGISTER rbp
>> +	CFI_ADJUST_CFA_OFFSET -8
>
>This open-codes CFI annotations again - please introduce a 
>helper instead.

That seems pretty pointless, as what is being done here is very unlikely to
be done anywhere else again.

>> -	popq_cfi %rax			/* move return address... */
>> +	popq %rax			/* move return address... */
>
>No annotation needed?

No. The annotation was actually wrong (because rsp is no longer the frame
pointer here). This is one of the aspects of unwind annotations which make
me think that trying to abstract out too much is actually hurting.

>>  	mov %gs:pda_irqstackptr,%rsp
>> -	EMPTY_FRAME 0
>> -	pushq_cfi %rbp			/* backlink for unwinder */
>> -	pushq_cfi %rax			/* ... to the new stack */
>> +	pushq %rbp			/* backlink for unwinder */
>> +	pushq %rax			/* ... to the new stack */
>
>Ditto?

Exactly.

>>  ENTRY(save_rest)
>> -	PARTIAL_FRAME 1 REST_SKIP+8
>> +	CFI_STARTPROC
>>  	movq 5*8+16(%rsp), %r11	/* save return address */
>> -	movq_cfi rbx, RBX+16
>> -	movq_cfi rbp, RBP+16
>> -	movq_cfi r12, R12+16
>> -	movq_cfi r13, R13+16
>> -	movq_cfi r14, R14+16
>> -	movq_cfi r15, R15+16
>> +	movq %rbx, RBX+16(%rsp)
>> +	movq %rbp, RBP+16(%rsp)
>> +	movq %r12, R12+16(%rsp)
>> +	movq %r13, R13+16(%rsp)
>> +	movq %r14, R14+16(%rsp)
>> +	movq %r15, R15+16(%rsp)
>
>Same here?

No. Here it is again that the function doesn't modify these registers, and
hence there's no reason to annotate the spills.

>>  	CFI_ADJUST_CFA_OFFSET REST_SKIP
>>  	call save_rest
>> -	DEFAULT_FRAME 0 8		/* offset 8: return address */
>> +	DEFAULT_FRAME -2 8		/* offset 8: return address */
>>  	leaq 8(%rsp), \arg	/* pt_regs pointer */
>
>Open-coded CFI annotation again.

Where is there anything open-coded here. It just changes the first macro
argument.

>I havent checked the rest of the patch but it shows similar 
>patters.
>
>The thing is, this patch is completely unacceptable - it just 
>reintroduces the same ugly crufty CFI code we used to have 
>there.

Hiding things behind macros where it makes sense is fine, but there are
limits to this imo. Not the least because this macro-ization prevents actual
consolidation (in many places, rather than annotating individual instructions,
the annotations as written out to the object file could actually be
compacted by placing the annotations after e.g. a group of registers had
been spilled - reducing size and parsing overhead from whoever reads the
.eh_frame section).

>The current annotations might be completely broken but at least 
>they _look_ structured and attempt to bring some order into the 
>CFI annotations chaos.

There was no chaos. Everything was working fine (and was understandable
to someone familiar with CFI annotations). The chaos got introduced with
the improperly annotated code. To me (and to our kernel, which makes
actual use of the annotations) this is a clear regression that shouldn't even
haven been allowed in. I'm just trying to pick up the pieces others put on
the ground.

>There's really just two options here:
>
>- You either submit clean, gradual patches that fix the problems 
>  and explain what is done and why, and documents the annotation
>  rules and makes CFI annotations maintainable,

I think the patch is as clean as it can be. It's debatable whether splitting
it up would be possible - perhaps very few hunks could be broken out
and submitted individually, but the bulk of it has to stay together as it's
dependent stuff.

>- Or we'll remove all CFI annotations from all x86 assembly
>  files and wait for future, clean patches.

Oh yes, thanks for offering this as an option. Wasn't it you who always
wanted reliable stack traces? This would get us even further away from
that goal. Besides being forced to maintain the unwinder out-of-tree,
we'd then also need to maintain the annotations in this manner. This very
much reminds me of Linus' attitude of considering Open Source more
open to some people than to others.

Jan
