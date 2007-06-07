Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbXFGQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbXFGQE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbXFGQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:04:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:12023 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXFGQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R94zqA9jyk0dezdbeGAENDtHfgGqPgYgodSA/x6oeort5FCjGl0DGOlIumHIvpjBjXb/RI77D69j3KkcdgVCiQX/7igQ1L8NM95lEmcK03/G+s/sK5sggNcEoRQ+islGq7p+U9pcvzvDBzxwnE+VDFYcT/D8wYaHRxXE2x/Cz/4=
Message-ID: <a781481a0706070904n3b937119ia9e9dc0810d177c4@mail.gmail.com>
Date: Thu, 7 Jun 2007 21:34:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [patch] Let smp_call_function_single return -EBUSY.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, randy.dunlap@oracle.com,
       paulus@samba.org, benh@kernel.crashing.org,
       "David Miller" <davem@davemloft.net>, "Alan Cox" <alan@redhat.com>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/14/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> All architectures that have an implementation of smp_call_function_single
> let it return -EBUSY if it is asked to execute func on the current cpu.
> Therefore the UP version must always return -EBUSY.

This logic is flawed, IMO. There is clearly a difference between trying to
send an IPI interrupt to oneself (which is what smp_call_function_single
on the current CPU could be thought to mean), and trying to send an IPI
interrupt to a processor that doesn't even exist (i.e. the case for both
smp_call_function() and smp_call_function_single() on !SMP). There are
other issues too ...

On 5/14/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> This of course raises another question: it is not clear in which context
> the smp_call_function* functions are supposed to be called. Should it be
> with preemption disabled or is preemption enabled allowed as well?
> If calling with preemption enabled is allowed then the powerpc implementation
> is broken, since smp_processor_id() as well as num_online_cpus() may change
> while they are accessed.

and

On 5/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> erk, I see your point.  If a caller is calling this with preemption enabled
> then the current thread might at any time migrate onto the target CPU,
> causing the smp_call_function_single() attempt to fail.  So the effects of
> that call are basically a random crapshoot.
>
> Often but not always, any code which is hanging onto a variable called
> "cpu" while preemption enabled is buggy.
>
> So yes, I'd say that from a sanity-of-implementation POV and for general
> defensiveness, we should require that the called of
> smp_call_function_single() has disabled preemption.

Right, preemption must clearly be disabled. I have no experience with
non-x86 arch's, but i386 and x86_64 escape these issues due to the
call_lock spinlock or get_cpu()/put_cpu() pair, as discussed on the
other thread.

On 5/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> smp_call_function_single() is a mess.

There is a lot of inter-arch inconsistency, yes, but as far as the
semantics of smp_call_function() and smp_call_function_single() is
concerned, my understanding is simply what is documented in the
comments: we use smp_call_function when we wish to run given function
on _all_ *other* CPUs, and use smp_call_function_single when we wish
to run given function on _specified_ *other* CPU.

> - it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
>   call the darn function if cpu==smp_processor_id().
...
On 5/15/07, Andi Kleen <ak@suse.de> wrote:
> I always wondered that too.

This changes smp_call_function() semantics, does it not? Also, (stating
the obvious), we could simply /call/ the given function to run it on
current CPU. All the IPI infrastructure exists precisely for the case
when we want to run something on some _other_ CPU, doing otherwise
could horribly break things ...

A hypothetical example is when we wish to make another CPU halt (say
the passed function contains a "for (;;) ;") and then we wish to proceed
with some further work in-current-thread / on-current-CPU itself. If
we've jumped to target CPU by the time of execution of the call, and
then proceed to just execute the darn function as proposed ... and all
hell breaks loose.

I would strongly recommend not changing current semantics of both the
smp_call_function{_single} functions. [ Please do let me know if / where
I'm wrong, otherwise. ]

> - it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
>   call the darn function if CONFIG_SMP=n.
...
On 5/15/07, Andi Kleen <ak@suse.de> wrote:
> Yes.

Same reasoning as above?

> - it's unclear to me why smp_call_function_single(cpu, ...) isn't called
>   smp_call_function_on(cpu, ...)

I'm fine with this proposed name change.

> - the x86_64 version doesn't return -EBUSY: it returns zero.  Despite its
>   claim "Retrurns 0 on success, else a negative status code.".

Needs to be fixed, clearly. I'll submit a patch for the same, shortly.

> - i386 _does_ return -EBUSY.

Which might be a reasonable thing to do if we've realized the target CPU
has somehow become the current CPU itself (after flagging a BUG / WARN
I would add). But like said earlier, this is not quite comparable to the
!SMP situation where the target CPU doesn't exist at all. I still feel both
of these should go BUG / WARNING on !SMP. The caller seems to have
gone wrong in logic somewhere, so we might as well flag it? [ For a
slightly more comparable case, we can refer to what powerpc does on
!cpu_online(target_cpu) and return -EINVAL; as suggested in my patch? ]

[ Clarifying / adding to smp_call_function{_single} semantics so that
various arch's can follow these without inconsistencies / mess. ]

On 5/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> - May be called with preemption enabled.  The implementation must take
>   care of that.

Agreed.

> - May not be called under local_irq_disable() for the usual reasons.

Agreed. We might also add what David Miller suggested earlier:
smp_call_function{_single} are illegal from _any_ asynchronous context,
such as hardirq, softirq, etc. [ s390 might need to be allowed to go
lax here, it contains a driver that needs to call these from softirq,
I think. ]

> - Will run the callback function under local_irq_disable() (this is
>   unimportant at present, but if we decide to later change it to run the
>   callback even on !SMP builds, we'll need to take care of that like we did
>   in on_each_cpu())

on_each_cpu() is a different case, IMHO. The single processor in UP does
belong to the "each" CPUs of a system. Same can't be said about the
smp_call_function* for UP ...

Satyam
