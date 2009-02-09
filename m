Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZBIIiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZBIIiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZBIIhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:37:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZBIIhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:37:51 -0500
Date: Mon, 9 Feb 2009 09:37:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
Message-ID: <20090209083739.GB15517@elte.hu>
References: <498CB0B7.8030009@kernel.org> <20090206140005.44b4bb50.akpm@linux-foundation.org> <498CB4DC.2010108@kernel.org> <498D3D15.5090005@kernel.org> <20090207002610.73ff7e6d.akpm@linux-foundation.org> <86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com> <20090207010619.daededa3.akpm@linux-foundation.org> <20090209081124.GB24420@elte.hu> <20090209001903.89548108.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209001903.89548108.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 9 Feb 2009 09:11:24 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Sat, 7 Feb 2009 01:01:03 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
> > > 
> > > > 
> > > > add kzalloc_node_safe()?
> > > 
> > > I cannot find that function.
> > 
> > His suggestion is to provide that allocator variant.
> > 
> 
> Oh.
> 
> It isn't possible to write a kzalloc_node_safe(GFP_ATOMIC).  Or at
> least, we've never worked out a way.
> 
> Maybe I'm confused again.

Indeed - duh - more morning tea needed.

Yinghai, why are those allocations GFP_ATOMIC to begin with? These:

earth4:~/tip> grep GFP_ATOMIC kernel/irq/*.c
kernel/irq/handle.c:	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
kernel/irq/handle.c:	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
kernel/irq/manage.c:	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);

Should all be GFP_KERNEL. Wherever they are within a spinlocked section the code 
should be restructured. All descriptor data structures should be preallocated at 
__setup_irq() time. If we ever need to allocate dynamically later on, in the middle 
of some difficult codepath that's a structure bug in the code.

and this one:

kernel/irq/numa_migrate.c:	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);

should fail the migration silently if GFP_ATOMIC returns NULL.

	Ingo
