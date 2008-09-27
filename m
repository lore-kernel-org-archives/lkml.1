Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYI0Tos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYI0Tos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYI0Toj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:44:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYI0Toj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:44:39 -0400
Date: Sat, 27 Sep 2008 21:44:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus,
	or just to this cpu?
Message-ID: <20080927194424.GG18619@elte.hu>
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu> <m18wthna2f.fsf@frodo.ebiederm.org> <48DA8806.4060405@goop.org> <m1d4itl4ni.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4itl4ni.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> > I found handle_percpu_irq() which addresses my concerns.  It doesn't
> > attempt to mask the interrupt, takes no locks, and doesn't set or test
> > IRQ_INPROGRESS in desc->status, so it will scale perfectly across
> > multiple cpus.  It makes no changes to the desc structure, so there
> > isn't even any cacheline bouncing.
> 
> kstat_irqs.  Is arguably part of the irq structure.
> And kstat_irqs is a major pain in my book.
> 
> And for a rare event you have a cacheline read.
> I don't think we are quite there yet but we really want to allocate
> irq_desc on the right NUMA node in a multi socket system, to reduce
> the cache miss times.

note that we already do _almost_ that in tip/irq/sparseirq. dyn_array[] 
will extend itself in a NUMA-aware fashion. (normal device irq_desc 
entries will be allocated via kmalloc)

what would be needed is to deallocate/reallocate irq_desc when the IRQ 
affinity is changed? (i.e. when a device is migrated to a specific NUMA 
node)

> Is it a big deal?  Probably not.  But I think it would be a bad idea 
> to increasingly use infrastructure that will make it hard to optimize 
> the code.
> 
> Especially since the common case in high performance drivers is going 
> to be, individually routable irq sources.  Having one queue per cpu 
> and one irq per queue.  Which sounds like the same case you have.

agreed - the kstat_irqs cacheline bounce would show up in Xen benchmarks 
i'm sure.

	Ingo
