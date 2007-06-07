Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXFGRFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXFGRFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXFGRFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:05:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:47635 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXFGRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ULmgxgzAcPutVq0WdVJ2duYyVtiAOJ1BmmL+Mu1srRqQM6CuaHd7uoEWQL2TSo5JXFHe8sGIEf0kXaNwY7qCm2uxW25wd0E0rUJFAYb4xschvNS0uPxet7sQl2uDkRobBcGFmjtNlczoJ66VtJCtWL7AruBRq8y2XjVrMW9ain8=
Message-ID: <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:24:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Cc: "Jan Glauber" <jan.glauber@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       ak@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
In-Reply-To: <20070607162743.GA9433@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208203210.GB9798@osiris.ibm.com>
	 <20070208.124328.88477956.davem@davemloft.net>
	 <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
	 <1171025838.5349.14.camel@localhost.localdomain>
	 <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
	 <20070607162743.GA9433@osiris.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On 6/7/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > Replacing the _bh variants and making smp_call_function{_single}
> > illegal from all contexts but process is fine for x86_64, as we
> > don't really have any driver that needs to use this from softirq
> > context in the x86_64 tree. This means it becomes dissimilar to
> > s390, but similar to powerpc, mips, alpha, sparc64 semantics.
> > I'll prepare and submit a patch for the same, shortly.
>
> Calling an smp_call_* function from any context but process context is
> a bug. We didn't notice this initially when we used smp_call_function
> from softirq context... until we deadlocked ;)
> So s390 is the same as any other architecture wrt this.

I'll fix the necessary patch for x86_64, in that case.

> > I don't see any CPU hotplug / preemption disabling issues here.
> > Note that both smp_call_function() and smp_call_function_single()
> > on x86_64 acquire the call_lock spinlock before using cpu_online_map
> > via num_online_cpus(). And spin_lock() does preempt_disable() on both
> > SMP and !SMP, so we're safe. [ But we're not explicitly disabling
> > preemption and depending on spin_lock() instead, so a comment would
> > be in order? ]
>
> Calling smp_call_function_single() with preemption enabled is pointless.
> You might be scheduled on the cpu you want to send an IPI to and get
> -EBUSY as return... If cpu hotplug is enabled the target cpu might even
> be gone when smp_call_function_single() gets executed.

Exactly. I was only mentioning that the smp_call_function*
of x86{_64} were safe anyway (but the smp_processor_id()
that would've preceded it need not have been, of course).

> Avi Kivity has already a patch which introduces an on_cpu() function which
> looks quite like on_each_cpu(). That way you don't have to open code this
> stuff over and over again:
>
> preempt_disable();
> if (cpu == smp_processor_id())
>         func();
> else
>         smp_call_function_single(...);
> preempt_enable();
>
> There are already quite a few of these around.

Indeed -- this was doubly problematic because the un-safeness
was because of smp_processor_id() as well as the (eventual)
access of cpu_online_map (via smp_call_function() ->
num_online_cpus()) ... thanks for letting me know about this.

Satyam
