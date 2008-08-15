Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYHOIvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYHOIvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYHOIvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:51:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYHOIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:51:37 -0400
Date: Fri, 15 Aug 2008 10:51:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Message-ID: <20080815085120.GA18748@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com> <20080815082735.GC4776@elte.hu> <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 1:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >>       fix the 32bit with bigsmp
> >>       fix 64 bit with irq migration
> >>       ordering functions in io_apic_xx.c
> >>
> >>
> >> to do:
> >>     merge io_apic_xx.c
> >
> > applied to tip/irq/sparseirq - thanks Yinghai, great work!
> >
> > What do you think about Eric's abstraction suggestion, that irq_desc's
> > structure should be hidden from all but kernel/irq/* code. I think
> > that's a sane suggestion. We do it in mm/slab.c too: no external code
> > knows the structure of 'struct kmem_cache'.
> 
> current arch code use irq_desc directly..., if need to irq_desc to 
> them, need to provide set_irq(..., ...)

that's ok - we can do include/linux/irq_desc.h that isnt generally 
included by drivers via interrupt.h. Then later on we can eliminate that 
include file altogether.

here's the current field usage histogram:

      3 desc->action
      3 desc->depth
      9 desc->affinity
     15 desc->chip
     22 desc->status

desc->status: mostly IRQ_MOVE_PENDING related. irq-balancing code should 
be abstracted into kernel/irq/* perhaps?

desc->action / desc->depth / desc->action: i dont think those should be 
accessed by genirq arch irq code.

desc->chip: there's a get_irq_chip() method already. irq_chip is 
something that obviously is known to architecture code - it's the irq 
controller 'driver' that the architecture code provides.

	Ingo
