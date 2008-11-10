Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYKJJkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYKJJkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYKJJko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:40:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYKJJkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:40:43 -0500
Date: Mon, 10 Nov 2008 10:40:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Message-ID: <20081110094033.GL22392@elte.hu>
References: <20081106101715.GA4022@elte.hu> <4913B45C.1000009@kernel.org> <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Andrew, please see the early_kzalloc() reference below)

* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Nov 8, 2008 at 11:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > General impression: very nice patch!
> >
> > A lot of the structural problems have been addressed: the descriptor
> > lookup is now hashed, the dynarray stuff got cleaned up / eliminated,
> > the irq_desc->chip_data binding is very nice as well.
> >
> > (And the patch needs to be split up like it was in the past, once all
> > review feedback has been seen and addressed.)
> >
> >> +config HAVE_SPARSE_IRQ
> >> +     bool
> >> +     default y
> >
> > i think it should be made user-configurable - at least initially. It
> > should not cause extra complications, right?
> 
> io_apic.c will get more complicated.

yes, with such constructs:

+#ifdef CONFIG_SPARSE_IRQ
+       struct irq_desc *desc;
+
+	/* first time to refer irq_cfg, so with new */
+       desc = irq_to_desc_alloc_cpu(irq, cpu);
+	cfg = desc->chip_data;
+#else
+       cfg = irq_cfg(irq);
+#endif

please introduce a proper helper that eliminates such complications. 
Any reason why chip_data could not be used in the !SPARSE_IRQ case? 
irq_cfg_alloc() perhaps?

> >> + if (irq < NR_IRQS_LEGACY) {
> >
> > please s/NR_IRQS_LEGACY/NR_IRQS_X86_LEGACY - this is never used
> > outside of x86 code.
> 
> will use that in kernel/irq/handle.c too, because dyn_array is dumped.

ah, i missed that. Okay - lets keep NR_IRQS_LEGACY then.

> >> @@ -987,6 +988,8 @@ void __init mem_init(void)
> >>
> >>       set_highmem_pages_init();
> >>
> >> +     after_bootmem = 1;
> >
> > this hack can go away once we have a proper percpu_alloc() that can be
> > used early enough.
> 
> where is that fancy patch? current percpu_alloc(), will keep big 
> pointer in array..., instead of put that pointer in percpu_area
> 
> 64bit has that after_bootmem already.

or at least introduce a "bootmem agnostic" allocator instead of 
open-coding the after_bootmem flag.

Something like:

  early_kzalloc()

?

Andrew, any preferences?

	Ingo
