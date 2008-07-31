Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYGaWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYGaWm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYGaWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:42:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbYGaWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:42:19 -0400
Date: Fri, 1 Aug 2008 00:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function
	call IPIs
Message-ID: <20080731224202.GB22426@elte.hu>
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu> <48923B7A.3020805@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48923B7A.3020805@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> So this _has_ to be approached defensively. It _should_ work, and i'm 
>> all in favor of utilizing hardware resources more fully, but it's an 
>> entirely new mode of operation for the hardware. I think a Kconfig 
>> option (which defaults to off), and a boot option to disable it would 
>> be nice, so that we can introduce this gently, at least initially. 
>> Then when we see that it's 100% trouble-free we can flip around the 
>> default.
>
> As Andi pointed out, this is more or less functionally identical to 
> the code I ripped out of tlb_64.c, so this mode of operation has had 
> lots of exposure on the 64-bit side.  Because the number of queues is 
> a CONFIG variable, it would be relatively easy to make it a real 
> config option, and/or use different numbers for 32 and 64-bit.  
> Choosing 1 as the number of queues will make it behave exactly as the 
> current code does.
>
> I'm not really familiar with all the ins and outs of apic bugs.  
> What's the issue you're concerned about?

Yes on the 64-bit side we've had NUM_INVALIDATE_TLB_VECTORS (==8) for a 
long time, but note that 64-bit is obviously for more modern CPUs. What 
i'm mindful about (i'm not _that_ worried) are fragile APICs and unknown 
erratas.

The other issue is that the concurrency pattern changes somewhat and 
becomes more agressive. The existing 64-bit special-purpose TLB flush 
code uses in essence synchronous waiting for that specific IPI that 
belongs to that CPU, it sends the IPI then waits for the acknowledgement 
by polling the flush mask:

        send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);

        while (!cpus_empty(f->flush_cpumask))
                cpu_relax();

while with generic IPIs we could have asynchronous IPIs as well.

So with the TLB flush code there's never any true "multiple outstanding 
IPIs" scenario for the same IPI, for 8 CPUs and fewer. (which is the 
predominant majority of existing hardware)

> It also occurred to me that it might be more interesting to 
> parameterise the queues - and the mapping of cpus->queues - in a more 
> topology-aware way than simply NQUEUES=NCPUS/x, queue=cpuid % NQUEUES.  
> But I haven't given it much thought.

i'd suggest we keep it at the current simple modulo rule.

	Ingo
