Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbZDCNRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbZDCNRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZDCNRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:17:05 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50098 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZDCNRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KsNitbB0IEODL70JqOJ+kQkf0inZLOzao4VJ4EXZf1YUTt2l0r020T4q87GVfnmcek
         awNW+b16pDsLpv5pRQiS6+D9Tohm4iCNXlUezR64AHxx13oAU3iQFYblSCHG2J6fb17F
         MuolS+HD34uv4tRVM3ObnhLmaZtIP91bcxTVY=
MIME-Version: 1.0
In-Reply-To: <20090403122654.GA19451@elte.hu>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu>
	 <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu>
	 <49D5FE42.5080100@redhat.com> <20090403122654.GA19451@elte.hu>
Date: Fri, 3 Apr 2009 15:16:58 +0200
Message-ID: <19f34abd0904030616v56d66a11u7ee6054502f2922@mail.gmail.com>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/3 Ingo Molnar <mingo@elte.hu>:
>
> * Avi Kivity <avi@redhat.com> wrote:
>
>> Ingo Molnar wrote:
>>>> kvm has three requirements not needed by kprobes:
>>>> - it wants to execute instructions, not just decode them, including
>>>>   generating faults where appropriate
>>>> - it is performance critical
>>>> - it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously
>>>>
>>>> If an arch/x86/ decoder/emulator gives me these I'll gladly switch
>>>> to it.  x86_emulate.c is high on my list of most disliked code.
>>>>
>>>
>>> Well, this has to be driven from the KVM side as the kprobes use
>>> will only be for decoding so if it's modified from the kprobes
>>> side the KVM-only functionality might regress.
>>>
>>> So ... we can do the library decoder for kprobes purposes, and
>>> someone versed in the KVM emulator can then combine the two.
>>
>> Problem is, anyone versed in the kvm emulator will want to run as
>> far away from this work as possible.
>
> Are you suggesting that the KVM emulator should never have been
> merged in the first place? ;-)
>
> Anyway, we'll make sure the kprobes/library decoder is as clean as
> possible - so it ought to be hackable and extensible without the
> risk of permanent brain damage. Mmiotrace and kmemcheck has decoding
> smarts too, and i think the sw-breakpoint injection code of KGDB
> could use it as well - so there's broader utility in all this.

(Sorry in advance for jumping in -- my post may be irrelevant)

For the record, kmemcheck requirements for an instruction decoder are these:

For any instruction with memory operands, we need to know which are
the operands (so for movl %eax, (%ebx) we need to combine the
instruction with a struct pt_regs to get the actual address
dereferenced, i.e. the contents of %ebx), and their sizes (for movzbl,
the source operand is 8 bits, destination operand is 32 bits). For
things like movsb, we need to be able to get both %esi and %edi.

mmiotrace additionally needs to know what the actual values
read/written were, for instructions that read/write to memory (again,
combined with a struct pt_regs).

Maybe this doesn't really say much, since this is what a generic
instruction decoder would be able to do anyway. But kmemcheck and
mmiotrace both have very special-purpose decoders. I don't really know
what other decoders look like, but what I would wish for is this: Some
macros for iterating the operands, where each operand has a type (e.g.
input (for reads), output (for writes), target (for jumps), immediate
address, immediate value, etc.), a size (in bits), and a way to
evaluate the operand. So eval(op, regs) for op=%eax, it will return
regs->eax; for op=4(%eax), it will return regs->eax + 4; for op=4 it
will return 4, etc.

Both kmemcheck and mmiotrace could gain SMP support with instruction
emulation, though it is strictly not necessary. In that case, though,
we would not want to emulate fault handling, etc. (i.e. the fault
should always be generated by the CPU itself).

Please do put me on Cc for future discussions, though.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
