Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYA3Nko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYA3Nko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbYA3Nkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:40:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58292 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755110AbYA3Nka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:40:30 -0500
Date: Wed, 30 Jan 2008 14:40:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Sterba <dsterba@suse.cz>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-ID: <20080130134046.GB5139@elf.ucw.cz>
References: <20080128171929.GA3906@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128171929.GA3906@ds.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> +/* I/O ports and bit definitions for version 1 of the hardware */
> +
> +/* IER bits*/
> +#define IER_RXENABLED   ((unsigned short) 0x1)
> +#define IER_TXENABLED   ((unsigned short) 0x2)
> +
> +/* ISR bits */
> +#define IR_RXINTR       ((unsigned short) 0x1)
> +#define IR_TXINTR       ((unsigned short) 0x2)
> +
> +/* DCR bits */
> +#define DCR_RXDONE      ((unsigned short) 0x1)
> +#define DCR_TXDONE      ((unsigned short) 0x2)
> +#define DCR_RXRESET     ((unsigned short) 0x4)
> +#define DCR_TXRESET     ((unsigned short) 0x8)

Are those casts neccessary?

> +/* I/O ports and bit definitions for version 2 of the hardware */
> +
> +struct MEMCCR {
> +	unsigned short PCCOR;		/* Configuration Option Register */
> +	unsigned short PCCSR;		/* Configuration and Status Register */
> +	unsigned short PCPRR;		/* Pin Replacemant Register */
> +	unsigned short PCSCR;		/* Socket and Copy Register */
> +	unsigned short PCESR;		/* Extendend Status Register */
> +	unsigned short PCIOB;		/* I/O Base Register */
> +};

Could we get better names? PCIOB is cryptic, pci_io_base is pretty
good.

> +/* Signals from DTE */
> +enum ComCtrl_DTESignal {
> +	ComCtrl_RTS = 0,
> +	ComCtrl_DTR = 1
> +};

CamelCaseIsEvil.


> +static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
> +						  struct ipw_hardware *hw)
> +{
> +	unsigned short irqn;
> +	unsigned short ack;
> +
> +	irqn = inw(hw->base_port + IOIR);
> +
> +	/* Check if card is present */
> +	if (irqn == (unsigned short) 0xFFFF) {
> +		if (++hw->bad_interrupt_count >= 100) {
> +			/*
> +			 * It is necessary to disable the interrupt at this
> +			 * point, or the kernel hangs, interrupting repeatedly
> +			 * forever.
> +			 */
> +			hw->irq = irq;
> +			hw->removed = 1;
> +			disable_irq_nosync(irq);
> +			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
> +					": Mr. Fluffy is not happy!\n");
> +		}
> +		return IRQ_HANDLED;

Not sure how this is supposed to work. If you assume unshared
interrupts, it should be possible to return something and make core
care.

If you are assuming shared interrupts, either you should disable on
first 0xFFFF (are you sure cast is needed, btw?), or not at all,
because it could be the other device sedning you 100 of those...

...so which one is it?

Is some locking needed around *hw?

> +int ipwireless_send_packet(struct ipw_hardware *hw, unsigned int channel_idx,
> +			    unsigned char *data, unsigned int length,
> +			    void (*callback) (void *cb, unsigned int length),
> +			    void *callback_data)
> +{
> +	struct ipw_tx_packet *packet;
> +
> +	packet = alloc_data_packet(length,
> +			       (unsigned char) (channel_idx + 1),
> +			       TL_PROTOCOLID_COM_DATA);
> +	if (!packet)
> +		return -1;

-ENOMEM would be more usual calling convention.

> +struct ipw_setup_get_version_query_packet {
> +	struct ipw_tx_packet header;
> +	struct TlSetupGetVersionQry body;
> +};

MoreEvilCamelCase.

> +static int config_ipwireless(struct ipw_dev *ipw)
> +{
> +	struct pcmcia_device *link = ipw->link;
> +	int ret;
> +	config_info_t conf;
> +	tuple_t tuple;
> +	unsigned short buf[64];
> +	cisparse_t parse;
> +	unsigned short cor_value;
> +	win_req_t reqAM;
> +	win_req_t reqCM;

Hiding structs BehindTypedefsIsEvil.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
