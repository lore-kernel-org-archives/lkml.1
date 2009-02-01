Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZBASyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZBASyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 13:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBASyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 13:54:41 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:43444 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZBASyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 13:54:40 -0500
Date: Sun, 1 Feb 2009 19:54:35 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: Driver for CB710/720 memory card reader (MMC part) - v3
Message-ID: <20090201185435.GA9165@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl> <20080909091800.37eccc0f@mjolnir.drzeus.cx> <20080909090613.GA22158@rere.qmqm.pl> <20080911201307.GA31730@rere.qmqm.pl> <20080912234302.GA19230@rere.qmqm.pl> <20080920130006.69d50cbb@mjolnir.drzeus.cx> <20080925062924.GA32105@rere.qmqm.pl> <20081004215122.0626cd7b@mjolnir.drzeus.cx> <20081029141146.GA17741@rere.qmqm.pl> <20081114220658.38f0645c@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081114220658.38f0645c@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Sorry for a long delay with my reply.

On Fri, Nov 14, 2008 at 10:06:58PM +0100, Pierre Ossman wrote:
> On Wed, 29 Oct 2008 15:11:47 +0100
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> > Here is the driver for CB710 SD/MMC reader updated to recently released
> > kernel version 2.6.27. The code is divided into PCI device driver
> > (wrapped that registers three platform devices) and MMC reader driver.
> > This idea was taken from TIFM driver.
> > 
> > Changes from v2:
> >  - return EINVAL for unsupported data transfer sizes
> >  - use sg_mapping_iter for PIO from/to scatterlist
> >  - add slot release function and prevent kobject leak on device registration's
> >    error path
> > 
> > If this code looks reasonably good, then I'll post patches against the
> > real kernel tree. The file distribution plan is:
> It looks more or less good to go. I have some small notes, and you
> probably need to poke some scatterlist folks to okay those changes
> (should probably be a separate patch).

There's no entry in MAINTAINERS list, but I assume it's Jens Axboe as he's
in the copyright section in scatterlist.c.

> > +/* slot port accessors - in case it turns out inX() is all that is needed */
> > +#define CB710_PORT_ACCESSORS(t) \
> > +static inline void cb710_write_port_##t(struct cb710_slot *slot,	\
> > +	unsigned port, u##t value)					\
> > +{									\
> > +	iowrite##t(value, slot->iobase + port);				\
> > +}									\
> > +									\
> > +static inline u##t cb710_read_port_##t(struct cb710_slot *slot,		\
> > +	unsigned port)							\
> > +{									\
> > +	return ioread##t(slot->iobase + port);				\
> > +}									\
> > +									\
> > +static inline void cb710_modify_port_##t(struct cb710_slot *slot,	\
> > +	unsigned port, u##t set, u##t clear)				\
> > +{									\
> > +	iowrite##t(							\
> > +		(ioread##t(slot->iobase + port) & ~clear)|set,		\
> > +		slot->iobase + port);					\
> > +}
> > +
> > +CB710_PORT_ACCESSORS(8)
> > +CB710_PORT_ACCESSORS(16)
> > +CB710_PORT_ACCESSORS(32)
> This is clearer than what you had before, but I still think you should
> consider using the kernel functions directly.

The really useful one here is cb710_modify_port_*(), read/write are for
consistency. I'd prefer to keep those wrappers because they help to eliminate
some noise from register access logic in the driver.

> > +/* helper functions */
> > +
> > +static inline void cb710_set_irq_handler(struct cb710_slot *slot,
> > +	cb710_irq_handler_t handler)
> > +{
> > +	rcu_assign_pointer(slot->irq_handler, handler);
> > +	synchronize_rcu();	/* sync to IRQ handler */
> > +}
> Why RCU:s? This smells of premature optimisation.

I thought this as the easiest way to assure that on return from
cb710_set_irq_handler() there's no interrupt handler running using the
old slot->irq_handler value.

> > +/* per-MMC-reader structure */
> > +struct cb710_mmc_reader {
> > +	struct tasklet_struct finish_req_tasklet;
> > +	struct mmc_request *mrq;
> > +	spinlock_t irq_lock;
> > +	unsigned char last_power_mode;
> > +#ifdef VERBOSE_DEBUG
> > +	spinlock_t serialization_lock;
> > +	unsigned char active_req, active_ios;
> > +#endif
> > +};
> I couldn't find VERBOSE_DEBUG defined somewhere. For ease of use with
> future testers, you should connect it to some Kconfig option.

This is mostly related to veryfying some assumptions on the MMC core
infrastructure. I can remove this altogether if the calls to driver
->request() and ->set_ios() are really guaranteed to be serialized.

> > +static int cb710_suspend(struct pci_dev *pdev, pm_message_t state)
> > +{
> > +	pci_save_state(pdev);
> > +	pci_disable_device(pdev);
> > +	if (state.event & PM_EVENT_SLEEP)
> > +		pci_set_power_state(pdev, PCI_D3cold);
> > +	return 0;
> > +}
> > +
> > +static int cb710_resume(struct pci_dev *pdev)
> > +{
> > +	pci_set_power_state(pdev, PCI_D0);
> > +	pci_restore_state(pdev);
> > +	return pcim_enable_device(pdev);
> > +}
> Free/restore interrupt?

Hmm. I checked couple random drivers in kernel tree and none (including
MMC host drivers) are touching interrupt allocation in suspend/resume.

> > +#if 0
> > +	/* original driver set bit 14 for MMC/SD application
> > +	 * commands. There's no difference 'on the wire' and
> > +	 * it apparently works without it anyway.
> > +	 */
> > +	if (flags & MMC_CMD_IS_APPCMD)
> > +		cb_flags |= 0x4000;
> > +#endif
> As this code is just useless, please clean it out before you submit the
> driver.

Will turn this into pure comment - just to remember.

> > +	mmc->ops = &cb710_mmc_host;
> > +	mmc->f_max = val;
> > +	mmc->f_min = val >> cb710_clock_divider_log2[CB710_MAX_DIVIDER_IDX];
> > +	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34|MMC_VDD_34_35;
> Since you can't change the voltage, this seems wrong. My guess is that
> the MMC_VDD_34_35 define should go.

That's what the original driver advertises. I can't verify the exact
voltage that is supplied to the card, so I'll assume that's 3.3V and
remove MMC_VDD_34_35 as you suggest.

> > +static int __devexit cb710_mmc_exit(struct platform_device *pdev)
> > +{
> > +	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
> > +	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
> > +	struct cb710_mmc_reader *reader = mmc_priv(mmc);
> > +
> > +	mmc_remove_host(mmc);
> > +
> > +	/* XXX what if IRQ arrives now? */
> 
> Most drivers handle this by sticking their head in the sand, but the
> proper way is probably to disable the card insertions interrupt before
> mmc_remove_host().
> (and there should be no other unsolicited interrupts)

Will try.

Best Regards,
Micha³ Miros³aw

