Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbXGSUT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbXGSUT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbXGSUTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:19:09 -0400
Received: from ns.suse.de ([195.135.220.2]:56879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbXGSUTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:19:05 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal>
	<200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jul 2007 23:14:03 +0200
In-Reply-To: <20070719173502.GB12955@Krystal>
Message-ID: <p73d4yow0ys.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> * Andi Kleen (ak@suse.de) wrote:
> > 
> > > Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
> > > by byte changing pieces of instructions non atomically and doing
> > > non-Intel's errata friendly XMC. You are really looking for trouble
> > > there :) Two distinct errors can occur: 
> > 
> > In this case it is ok because this only happens when transitioning
> > from 1 CPU to 2 CPUs or vice versa and in both cases the other CPUs
> > are essentially stopped.
> > 
> 
> I agree that it's ok with SMP, but another problem arises: it's not only
> a matter of being protected from SMP access, but also a matter of
> reentrancy wrt interrupt handlers.
> 
> i.e.: if, as we are patching nops non atomically, we have a non maskable
> interrupt coming which calls get_cycles_sync() which uses the

Hmm, i didn't think NMI handlers called that. e.g. nmi watchdog just
uses jiffies.

get_cycles_sync patching happens only relatively early at boot, so oprofile
cannot be running yet.

> I see that IRQs are disabled in alternative_instructions(), but it does
> not protect against NMIs, which could come at a very inappropriate
> moment. MCE and SMIs would potentially cause the same kind of trouble.
> 
> So unless you can guarantee that any code from NMI handler won't call
> basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
> it won't execute an illegal instruction. Also, the option of temporarily
> disabling the NMI for the duration of the update simply adds unwanted
> latency to the NMI handler which could be unacceptable in some setups.

Ok it's a fair point.  But how would you address it ?

Even if we IPIed the other CPUs NMIs or MCEs could still happen.

BTW Jeremy, have you ever considered that problem with paravirt ops
patching? 

> 
> Another potential problem comes from preemption: if a thread is
> preempted in the middle of the instructions you are modifying, let's say
> we originally have 4 * 1 byte instructions that we replace with 1 * 4
> byte instruction, a thread could iret in the middle of the new
> instruction when it will be scheduled again, thus executing an illegal
> instruction. This problem could be overcomed by putting the threads in
> the freezer. See the djprobe project for details about this.

This cannot happen for the current code: 
- full alternative patching happen only at boot when the other CPUs
are not running
- smp lock patching only ever changes a single byte (lock prefix) of
a single instruction
- kprobes only ever change a single byte

For the immediate value patching it also cannot happen because
you'll never modify multiple instructions and all immediate values
can be changed atomically. 



> In the end, I think the safest solution would be to limit ourselves to
> one of these 2 solutions:
> - If the update can be done atomically and leaves the site in a coherent
>   state after each atomic modification, while keeping the same
>   instruction size, it could be done on the spot.
> - If not, care should be taken to first do a copy of the code to modify
>   into a "bypass", making sure that instructions can be relocated, so
>   that any context that would try to execute the site during the
>   modification would execute a breakpoint which would execute the bypass
>   while we modify the instructions.

kprobes does that, but to write the break point it uses text_poke() 
with my patch.

> Because of the tricks that must be done to do code modification on a
> live system (as explained above), I don't think it makes sense to
> provide a falsely-safe infrastructure that would allow code modification
> in a non-atomic manner.

Hmm, perhaps it would make sense to add a comment warning about
the limitations of the current text_poke. Can you supply one?

-Andi
