Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZDXOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZDXOLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZDXOLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:11:13 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40426 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZDXOLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I1qOH0iV6B4W2JsI5iu0pOW5DNbuY0IFOeVyvawk0LKWbNFME9e0gHsp2ZSiVd7tOY
         T2Qn7FVYiWMSZMqSO0qGUtS0GW7IfOxvsorta41GjZxfmBuxCzgDVEsRKLHT9bJ7VT72
         aSO+YiCF8FKXSdpp6FpBWk8vyK5UwrR5reSRk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu>
	 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
	 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
	 <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
	 <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
Date: Fri, 24 Apr 2009 16:11:10 +0200
Message-ID: <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Hugh Dickins <hugh@veritas.com>:
> On Fri, 24 Apr 2009, Dmitry Adamushko wrote:
>> 2009/4/23 Hugh Dickins <hugh@veritas.com>:
>> >
>> > I guess your mutex Synchronization works out, but are interrupts
>> > still disabled around the critical wrmsr()s, wherever they're getting
>> > called from?
>>
>> Yes, *msr() calls are only done from functions that are now being
>> called via smp_call_function_single(). The later seems to always do it
>> with disabled interrupts. The only exception is mc_sysdev_resume()
>> calling  ->apply_microcode() directly but this one in turn is always
>> called with disabled interrupts.
>>
>> But now that you mentioned it I wonder if we may actually need a
>> spinlock there... can we have multi-threaded cpus/cores with (all |
>> some) shared msr registers?
>
> Good thinking, yes we can and do, unless I'm misinterpreting the
> evidence.  Though P4 Xeon and Atom startup messages give the opposite
> impression, claiming to update all cpus from lower revision, more
> careful tests starting from "maxcpus=1" and then "echo 1 >online"
> (which, unless you've fiddled around putting the microcode_ctl'ed
> microcode.dat into /lib/firmware/intel-ucode/wherever, isn't able
> to update at online time on Intel) shows that the later onlined
> siblings already have the updated microcode applied to their
> previously onlined siblings.  Which isn't surprising, but I'd
> been lulled into thinking the opposite by the startup sequence.

Ah, stupid me :-/ These differences in behavior during the startup and
the later update reveal a real bug in my patch.

this part:

mutex_lock(&microcode_mutex);
error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
mutex_unlock(&microcode_mutex);

sysdev_driver_register() calls mc_sysdev_driver's ->add() (which is
mc_sysdev_add()) for each cpu in a loop. Obviously, "microcode_mutex"
can't help to serialize these calls, oops. A very obvious thing but I
missed it.

>
> Please add "HT versus not" to my earlier list of confusions.
>
> microcode_mutex still covers most cases: is it the case of onlining
> two threads at the same time that slips through?  Is that permitted
> at the outer level?

If the threads are onlined with cpu_up() then it should be ok - no
concurrent cpu_up()s are allowed. I'll check it out.

> Though even if it is, I'd feel safest to have
> the spin_lock_irqsaves back (or if not, comment to say why not needed).

I'll verify regarding the initialization of HT threads (I'd imagine
that it's indeed via cpu_up(), at the very least for the sake of
consistency as they pretend to be 'normal' cpus to upper layers, e.g.
can be offline/online-ed).

I'm also thinking if the synchronization with "microcode_mutex" is way
too strong/restrictive in this case. Perhaps we actually can add some
parallelism here (with spinlocks in arch-specific parts only where
necessary).

On the other hand, I think that we can optimize cases when a few cpus
are being updated one after another (upon modprobe microcode or
writing into /dev/microcode).

Assumption: most of the CPUs (maybe with an exception of the boot-cpu
when its ucode is updated by BIOS) upgrade from revisions A to B,
where A and B are the same for all of them (well, at least B -- the
most recent one [*]).

Then why bother loading/traversing firmware (or traversing .dat files)
for each of them?

[*] btw., are all CPUs on SMP systems similar wrt model, stepping?

Even if not, we could do some caching so that if cpu-2 asks for
intel-ucode/06-0f-0a and we know that cpu-1 has just done the same and
still has a proper ucode in its buffer, then we just make a copy.


>
> Hugh
>

-- 
Best regards,
Dmitry Adamushko
