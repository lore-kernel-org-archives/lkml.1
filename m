Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968056Ab0B0JLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:11:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968044Ab0B0JK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:10:59 -0500
Date: Sat, 27 Feb 2010 10:10:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs()
 again
Message-ID: <20100227091043.GA31794@elte.hu>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
 <4B881097.1050505@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B881097.1050505@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 02/26/2010 02:26 AM, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4
> > Gitweb:     http://git.kernel.org/tip/f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri, 26 Feb 2010 11:17:16 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 26 Feb 2010 11:17:16 +0100
> > 
> > x86: apic: Fix mismerge, add arch_probe_nr_irqs() again
> > 
> > Merge commit aef55d4922 mis-merged io_apic.c so we lost the
> > arch_probe_nr_irqs() method.
> > 
> > This caused subtle boot breakages (udev confusion likely
> > due to missing drivers) with certain configs.
> > 
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > LKML-Reference: <20100207210250.GB8256@jenkins.home.ifup.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/apic/io_apic.c |   22 ++++++++++++++++++++++
> >  1 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 527390c..c13ab8f 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -3874,6 +3874,28 @@ void __init probe_nr_irqs_gsi(void)
> >  	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
> >  }
> >  
> > +#ifdef CONFIG_SPARSE_IRQ
> > +int __init arch_probe_nr_irqs(void)
> > +{
> > +	int nr;
> > +
> > +	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
> > +		nr_irqs = NR_VECTORS * nr_cpu_ids;
> > +
> > +	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
> > +#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
> > +	/*
> > +	 * for MSI and HT dyn irq
> > +	 */
> > +	nr += nr_irqs_gsi * 16;
> > +#endif
> > +	if (nr < nr_irqs)
> > +		nr_irqs = nr;
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> >  static int __io_apic_set_pci_routing(struct device *dev, int irq,
> >  				struct io_apic_irq_attr *irq_attr)
> >  {
> 
> for x86, with radix tree based irq_to_desc(),
> removing arch_probe_nr_irqs is intentional. so we get more irq that could be used.
> 
> wonder if the udev for some of your test system have irq number limitation?

was ancient udev: udev-095-17.fc6.

	Ingo
