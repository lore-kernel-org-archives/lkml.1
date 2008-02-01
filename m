Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYBAPVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYBAPVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYBAPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:21:45 -0500
Received: from styx.suse.cz ([82.119.242.94]:34229 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754114AbYBAPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:21:44 -0500
From: David Sterba <dsterba@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Date: Fri, 1 Feb 2008 16:21:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
References: <20080128171929.GA3906@ds.suse.cz> <20080130134046.GB5139@elf.ucw.cz>
In-Reply-To: <20080130134046.GB5139@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011621.27239.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > +/* DCR bits */
> > +#define DCR_RXDONE      ((unsigned short) 0x1)
> > +#define DCR_TXDONE      ((unsigned short) 0x2)
> > +#define DCR_RXRESET     ((unsigned short) 0x4)
> > +#define DCR_TXRESET     ((unsigned short) 0x8)
>
> Are those casts neccessary?

No, removed.

> > +/* I/O ports and bit definitions for version 2 of the hardware */
> > +
> > +struct MEMCCR {
> > +	unsigned short PCCOR;		/* Configuration Option Register */
> > +	unsigned short PCCSR;		/* Configuration and Status Register */
> > +	unsigned short PCPRR;		/* Pin Replacemant Register */
> > +	unsigned short PCSCR;		/* Socket and Copy Register */
> > +	unsigned short PCESR;		/* Extendend Status Register */
> > +	unsigned short PCIOB;		/* I/O Base Register */
> > +};
>
> Could we get better names? PCIOB is cryptic, pci_io_base is pretty
> good.

Ok, changed to eg. reg_config_and_status.

> > +/* Signals from DTE */
> > +enum ComCtrl_DTESignal {
> > +	ComCtrl_RTS = 0,
> > +	ComCtrl_DTR = 1
> > +};
>
> CamelCaseIsEvil.

Converted to underscores.

>
> > +static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
> > +						  struct ipw_hardware *hw)
> > +{
> > +	unsigned short irqn;
> > +	unsigned short ack;
> > +
> > +	irqn = inw(hw->base_port + IOIR);
> > +
> > +	/* Check if card is present */
> > +	if (irqn == (unsigned short) 0xFFFF) {
> > +		if (++hw->bad_interrupt_count >= 100) {
> > +			/*
> > +			 * It is necessary to disable the interrupt at this
> > +			 * point, or the kernel hangs, interrupting repeatedly
> > +			 * forever.
> > +			 */
> > +			hw->irq = irq;
> > +			hw->removed = 1;
> > +			disable_irq_nosync(irq);
> > +			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
> > +					": Mr. Fluffy is not happy!\n");
> > +		}
> > +		return IRQ_HANDLED;
>
> Not sure how this is supposed to work. If you assume unshared
> interrupts, it should be possible to return something and make core
> care.
>
> If you are assuming shared interrupts, either you should disable on
> first 0xFFFF (are you sure cast is needed, btw?), or not at all,
> because it could be the other device sedning you 100 of those...
>
> ...so which one is it?

Shared. It'll check if device has interrupt pending, else exit.

> Is some locking needed around *hw?

Some items are set during initial phase and read only afterwards. This don't 
need to be protected. Nevetheless, I've found some missing locking around 
tx_ready and rx_ready which might cause bugs (eg. hangs).

>
> > +int ipwireless_send_packet(struct ipw_hardware *hw, unsigned int
> > channel_idx, +			    unsigned char *data, unsigned int length,
> > +			    void (*callback) (void *cb, unsigned int length),
> > +			    void *callback_data)
> > +{
> > +	struct ipw_tx_packet *packet;
> > +
> > +	packet = alloc_data_packet(length,
> > +			       (unsigned char) (channel_idx + 1),
> > +			       TL_PROTOCOLID_COM_DATA);
> > +	if (!packet)
> > +		return -1;
>
> -ENOMEM would be more usual calling convention.

Done.

>
> > +struct ipw_setup_get_version_query_packet {
> > +	struct ipw_tx_packet header;
> > +	struct TlSetupGetVersionQry body;
> > +};
>
> MoreEvilCamelCase.

Converted.

> > +static int config_ipwireless(struct ipw_dev *ipw)
> > +{
> > +	struct pcmcia_device *link = ipw->link;
> > +	int ret;
> > +	config_info_t conf;
> > +	tuple_t tuple;
> > +	unsigned short buf[64];
> > +	cisparse_t parse;
> > +	unsigned short cor_value;
> > +	win_req_t reqAM;
> > +	win_req_t reqCM;
>
> Hiding structs BehindTypedefsIsEvil.

Unfortunatelly PCMCIA subsystem is full of these and all drivers use them. 
I'll stay consistent for now.

Updated patch v4 will follow.

dave
