Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZEKOwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZEKOwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZEKOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:52:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZEKOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:52:09 -0400
Date: Mon, 11 May 2009 16:51:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM] Add support for Pause Filtering to AMD SVM
Message-ID: <20090511145159.GA737@elte.hu>
References: <200905050909.58583.mark.langsdorf@amd.com> <1242052724.11251.274.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242052724.11251.274.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-05-05 at 09:09 -0500, Mark Langsdorf wrote:
> > commit 6f15c833f56267baf5abdd0fbc90a81489573053
> > Author: Mark Langsdorf <mlangsdo@wshpnow.amd.com>
> > Date:   Mon May 4 15:02:38 2009 -0500
> > 
> >     New AMD processors will support the Pause Filter Feature.
> >     This feature creates a new field in the VMCB called Pause
> >     Filter Count.  If Pause Filter Count is greater than 0 and
> >     ntercepting PAUSEs is enabled, the processor will increment
> >     an internal counter when a PAUSE instruction occurs instead
> >     of intercepting.  When the internal counter reaches the
> >     Pause Filter Count value, a PAUSE intercept will occur.
> >     
> >     This feature can be used to detect contended spinlocks,
> >     especially when the lock holding VCPU is not scheduled.
> >     Rescheduling another VCPU prevents the VCPU seeking the
> >     lock from wasting its quantum by spinning idly.
> >     
> >     Experimental results show that most spinlocks are held
> >     for less than 1000 PAUSE cycles or more than a few
> >     thousand.  Default the Pause Filter Counter to 3000 to
> >     detect the contended spinlocks.
> >     
> >     Processor support for this feature is indicated by a CPUID
> >     bit.
> >     
> >     On a 24 core system running 4 guests each with 16 VCPUs,
> >     this patch improved overall performance of each guest's
> >     32 job kernbench by approximately 1%.  Further performance
> >     improvement may be possible with a more sophisticated
> >     yield algorithm.
> 
> Isn't a much better solution to the spinlock problem a usable 
> monitor-wait implementation?
> 
> If we implement virt spinlocks using monitor-wait they don't spin 
> but simply wait in place, the HV could then decide to run someone 
> else.
> 
> This is the HV equivalent to futexes.
> 
> The only problem with this is that the current hardware has horrid 
> mwait wakeup latencies. If this were (much) improved you don't 
> need such ugly yield hacks like this.

I've considered MWAIT, but its really hard on the hw side:

the hardware would have to generate a 'wakeup', meaning it either 
has to trap out, or has to send an irq.

Trapping out is only possible on the release-the-lock side - which 
is usually on the wrong physical CPU, and it also happens _too late_ 
- such monitor/wait thingies are usually based on MESI cache, and 
the originating CPU does not wait for everything to happen.

An irq (on the target CPU that notices the cacheline flush) is more 
feasible, but it is several thousand cycles to begin with.

Irqs/vectors are a lot harder to add in general as well, and incur a 
cost of several years of CPU-design-cycle latency. Furthermore, the 
bits around MESI updates are _very_ sensitive codepaths of the CPU, 
while REP; NOP is a slowpath to begin with.

But ... especially as SMT techniques spread, something like that 
will have to happen as well - but it will take years. Meanwhile, 
this particular CPU feature is there, it's fairly intuitive (plus a 
VM exit doesnt really change the CPU's behavior materially, so a lot 
easier to validate and get OS support for), so we could use it.

	Ingo
