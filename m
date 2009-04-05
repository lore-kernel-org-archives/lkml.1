Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZDEThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZDEThl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757129AbZDEThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:37:23 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64106 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118AbZDEThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=NtcaqgHINIARxMrrtwA3z5WxGo+t5lOc/k94HPjm67lvtC29wT232AZNr0SE3aYseV
         b++41GrE6Wa7ydf/+M5EIAmSiMZvAaNu2t/B5OGoqfdLXCo2t4eJXmJHNnYdNsEPnGfk
         iz9sUWDGdY1eZNCz5y5QBvIRTpYSKun3w8x+s=
Date: Sun, 5 Apr 2009 22:37:10 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090405223710.49299b9a@daedalus.pq.iki.fi>
In-Reply-To: <49D61489.9020406@redhat.com>
References: <49D4F4B5.9040107@redhat.com>
	<20090403112639.GC31399@elte.hu>
	<49D5F80B.7000305@redhat.com>
	<20090403121202.GI31399@elte.hu>
	<49D5FE42.5080100@redhat.com>
	<20090403122654.GA19451@elte.hu>
	<19f34abd0904030616v56d66a11u7ee6054502f2922@mail.gmail.com>
	<49D61489.9020406@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Apr 2009 09:52:09 -0400
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Vegard Nossum wrote:
> > 2009/4/3 Ingo Molnar <mingo@elte.hu>:
> >> * Avi Kivity <avi@redhat.com> wrote:
> >>
> >>> Ingo Molnar wrote:
> >>>>> kvm has three requirements not needed by kprobes:
> >>>>> - it wants to execute instructions, not just decode them, including
> >>>>>   generating faults where appropriate
> >>>>> - it is performance critical
> >>>>> - it needs to support 16-bit, 32-bit, and 64-bit instructions simultaneously
> >>>>>
> >>>>> If an arch/x86/ decoder/emulator gives me these I'll gladly switch
> >>>>> to it.  x86_emulate.c is high on my list of most disliked code.
> >>>>>
> >>>> Well, this has to be driven from the KVM side as the kprobes use
> >>>> will only be for decoding so if it's modified from the kprobes
> >>>> side the KVM-only functionality might regress.
> >>>>
> >>>> So ... we can do the library decoder for kprobes purposes, and
> >>>> someone versed in the KVM emulator can then combine the two.
> >>> Problem is, anyone versed in the kvm emulator will want to run as
> >>> far away from this work as possible.
> >> Are you suggesting that the KVM emulator should never have been
> >> merged in the first place? ;-)
> >>
> >> Anyway, we'll make sure the kprobes/library decoder is as clean as
> >> possible - so it ought to be hackable and extensible without the
> >> risk of permanent brain damage. Mmiotrace and kmemcheck has decoding
> >> smarts too, and i think the sw-breakpoint injection code of KGDB
> >> could use it as well - so there's broader utility in all this.
> > 
> > (Sorry in advance for jumping in -- my post may be irrelevant)
> 
> Thank you for clarify your needs :-)
> 
> > For the record, kmemcheck requirements for an instruction decoder are these:
> > 
> > For any instruction with memory operands, we need to know which are
> > the operands (so for movl %eax, (%ebx) we need to combine the
> > instruction with a struct pt_regs to get the actual address
> > dereferenced, i.e. the contents of %ebx), and their sizes (for movzbl,
> > the source operand is 8 bits, destination operand is 32 bits). For
> > things like movsb, we need to be able to get both %esi and %edi.
> 
> New decoder can give you the value of mod/rm(insn.modrm), operand size
> (insn.opnd_bytes), and immediate size (insn.immediate.nbytes)
> To get which register is used, you can decode modrm with MODRM_*()
> macros.
> 
> > mmiotrace additionally needs to know what the actual values
> > read/written were, for instructions that read/write to memory (again,
> > combined with a struct pt_regs).
> 
> The decoder doesn't use any locks/shared memory, so you can
> use it in interrupt context, with pt_regs.
> 
> > Maybe this doesn't really say much, since this is what a generic
> > instruction decoder would be able to do anyway. But kmemcheck and
> > mmiotrace both have very special-purpose decoders. I don't really know
> > what other decoders look like, but what I would wish for is this: Some
> > macros for iterating the operands, where each operand has a type (e.g.
> > input (for reads), output (for writes), target (for jumps), immediate
> > address, immediate value, etc.), a size (in bits), and a way to
> > evaluate the operand. So eval(op, regs) for op=%eax, it will return
> > regs->eax; for op=4(%eax), it will return regs->eax + 4; for op=4 it
> > will return 4, etc.
> 
> Hmm, it's an interesting idea. I think operand classifying can be done by
> evaluating opcode and mod/rm.
> 
> > Both kmemcheck and mmiotrace could gain SMP support with instruction
> > emulation, though it is strictly not necessary. In that case, though,
> > we would not want to emulate fault handling, etc. (i.e. the fault
> > should always be generated by the CPU itself).

Not just emulation but address diversion, i.e. modifying the operation
(not the text) before executing it. Mmiotrace could do something like
this:
1. a blob calls ioremap
2. mmiotrace maps the MMIO area privately
3. the blob receives a dummy map from ioremap, that will generate
page fault
4. the blob accesses the dummy map and raises a page fault
5. pf handler detects the dummy map
6. mmiotrace pf handler emulates the instruction and replaces the
dummy address with the real MMIO address.
7. mmiotrace records the operation and the datum
8. go to step 4, or whatever

This means mmiotrace would not have to fiddle with the page
tables and page presence bits like it does now. As said, this
would make mmiotrace SMP-proof, and also eliminate the die notifier
(used for the instruction single stepping trap).

IMO a big step from a hack to a tool. Getting rid of the custom
instruction parser in mmiotrace would be a good step in itself.

Avi Kivity noted, that the KVM emulator does almost everything. Does
it allow also address diversion?

I haven't looked at the KVM emulator since something like 2.6.25 or
so, and I probably don't have time to work with it anyway, but
I am very interested to hear how things evolve.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
