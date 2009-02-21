Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZBUMqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZBUMqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 07:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZBUMqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 07:46:10 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51430 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZBUMqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 07:46:09 -0500
Date: Sat, 21 Feb 2009 13:46:03 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: Driver for CB710/720 memory card reader (MMC part) - v3
Message-ID: <20090221134603.6bc3c385@mjolnir.ossman.eu>
In-Reply-To: <20090201185435.GA9165@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl>
	<20080909091800.37eccc0f@mjolnir.drzeus.cx>
	<20080909090613.GA22158@rere.qmqm.pl>
	<20080911201307.GA31730@rere.qmqm.pl>
	<20080912234302.GA19230@rere.qmqm.pl>
	<20080920130006.69d50cbb@mjolnir.drzeus.cx>
	<20080925062924.GA32105@rere.qmqm.pl>
	<20081004215122.0626cd7b@mjolnir.drzeus.cx>
	<20081029141146.GA17741@rere.qmqm.pl>
	<20081114220658.38f0645c@mjolnir.drzeus.cx>
	<20090201185435.GA9165@rere.qmqm.pl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009 19:54:35 +0100
Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:

> > > +/* helper functions */
> > > +
> > > +static inline void cb710_set_irq_handler(struct cb710_slot *slot,
> > > +	cb710_irq_handler_t handler)
> > > +{
> > > +	rcu_assign_pointer(slot->irq_handler, handler);
> > > +	synchronize_rcu();	/* sync to IRQ handler */
> > > +}
> > Why RCU:s? This smells of premature optimisation.
> 
> I thought this as the easiest way to assure that on return from
> cb710_set_irq_handler() there's no interrupt handler running using the
> old slot->irq_handler value.
> 

A spinlock will suffice fine for that.

> > > +/* per-MMC-reader structure */
> > > +struct cb710_mmc_reader {
> > > +	struct tasklet_struct finish_req_tasklet;
> > > +	struct mmc_request *mrq;
> > > +	spinlock_t irq_lock;
> > > +	unsigned char last_power_mode;
> > > +#ifdef VERBOSE_DEBUG
> > > +	spinlock_t serialization_lock;
> > > +	unsigned char active_req, active_ios;
> > > +#endif
> > > +};
> > I couldn't find VERBOSE_DEBUG defined somewhere. For ease of use with
> > future testers, you should connect it to some Kconfig option.
> 
> This is mostly related to veryfying some assumptions on the MMC core
> infrastructure. I can remove this altogether if the calls to driver
> ->request() and ->set_ios() are really guaranteed to be serialized.
> 

They are. Changing device settings during an ongoing request is very
undefined.

> > > +static int cb710_resume(struct pci_dev *pdev)
> > > +{
> > > +	pci_set_power_state(pdev, PCI_D0);
> > > +	pci_restore_state(pdev);
> > > +	return pcim_enable_device(pdev);
> > > +}
> > Free/restore interrupt?
> 
> Hmm. I checked couple random drivers in kernel tree and none (including
> MMC host drivers) are touching interrupt allocation in suspend/resume.
> 

Check sdhci.c, it frees the irq and re-requests it during suspend. This
is generally needed when you share interrupts as you need to avoid
trying to handle interrupts before your device has been resumed.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
