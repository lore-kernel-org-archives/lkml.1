Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZAKBJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZAKBJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZAKBI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:08:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZAKBI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:08:56 -0500
Date: Sun, 11 Jan 2009 02:08:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable sized
Message-ID: <20090111010831.GD12885@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223819.033438000@polaris-admin.engr.sgi.com> <20090110225229.GE17917@elte.hu> <49692A50.7010402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49692A50.7010402@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Impact: reduce memory usage.
> >>
> >> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
> >> memory usage bump when NR_CPUS bumped from 128 to 4096:
> >>
> >>      8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
> >>
> >> This is only when CONFIG_SPARSE_IRQS=y.
> >>
> >> Signed-off-by: Mike Travis <travis@sgi.com>
> >> ---
> >>  kernel/irq/handle.c |    9 ++++++---
> >>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
> >> +++ linux-2.6-for-ingo/kernel/irq/handle.c
> >> @@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
> >>  	}
> >>  };
> >>  
> >> -/* FIXME: use bootmem alloc ...*/
> >> -static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> >> +static unsigned int *kstat_irqs_legacy;
> >>  
> >>  int __init early_irq_init(void)
> >>  {
> >> @@ -146,9 +145,13 @@ int __init early_irq_init(void)
> >>  	/* allocate irq_desc_ptrs array based on nr_irqs */
> >>  	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
> >>  
> >> +	/* allocate based on nr_cpu_ids */
> >> +	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
> >> +					  sizeof(int));
> >> +
> >>  	for (i = 0; i < legacy_count; i++) {
> >>  		desc[i].irq = i;
> >> -		desc[i].kstat_irqs = kstat_irqs_legacy[i];
> >> +		desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;
> >>  		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
> >>  		init_alloc_desc_masks(&desc[i], 0, true);
> >>  		irq_desc_ptrs[i] = desc + i;
> > 
> > btw., while at it - dont we want to upgrade this to a 'long' (in a 
> > separate commit)? Having more than 4 billion irqs after bootup is easily 
> > possible.
> > 
> > 	Ingo
> 
> Yes, I can do that.  There are two places where it allocated, both for
> legacy and dynamically added desc's.
> 
> You want basically this, yes?

yes - but please also check all that places that use it.

	Ingo
