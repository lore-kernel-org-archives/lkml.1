Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYA3Wh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYA3Wh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYA3WhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:37:20 -0500
Received: from fep02.xtra.co.nz ([210.54.141.244]:34808 "EHLO fep02.xtra.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbYA3WhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:37:17 -0500
Message-ID: <47A0EC3A.1040502@symmetric.co.nz>
Date: Thu, 31 Jan 2008 10:29:30 +1300
From: "Stephen Blackheath [to Foxconn]" <stephen@symmetric.co.nz>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: David Sterba <dsterba@suse.cz>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
References: <20080128171929.GA3906@ds.suse.cz> <20080130134046.GB5139@elf.ucw.cz>
In-Reply-To: <20080130134046.GB5139@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel & all,


Pavel Machek wrote:

>> +/* I/O ports and bit definitions for version 2 of the hardware */
>> +
>> +struct MEMCCR {
>> +	unsigned short PCCOR;		/* Configuration Option Register */
>> +	unsigned short PCCSR;		/* Configuration and Status Register */
>> +	unsigned short PCPRR;		/* Pin Replacemant Register */
>> +	unsigned short PCSCR;		/* Socket and Copy Register */
>> +	unsigned short PCESR;		/* Extendend Status Register */
>> +	unsigned short PCIOB;		/* I/O Base Register */
>> +};
>>     
>
> Could we get better names? PCIOB is cryptic, pci_io_base is pretty
> good.
>
>   
We should keep these names because they are part of the interface
between host and card defined by the manufacturer.
>> +static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
>> +						  struct ipw_hardware *hw)
>> +{
>> +	unsigned short irqn;
>> +	unsigned short ack;
>> +
>> +	irqn = inw(hw->base_port + IOIR);
>> +
>> +	/* Check if card is present */
>> +	if (irqn == (unsigned short) 0xFFFF) {
>> +		if (++hw->bad_interrupt_count >= 100) {
>> +			/*
>> +			 * It is necessary to disable the interrupt at this
>> +			 * point, or the kernel hangs, interrupting repeatedly
>> +			 * forever.
>> +			 */
>> +			hw->irq = irq;
>> +			hw->removed = 1;
>> +			disable_irq_nosync(irq);
>> +			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
>> +					": Mr. Fluffy is not happy!\n");
>> +		}
>> +		return IRQ_HANDLED;
>>     
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
>   
This code is obsolete (a workaround to an embedded system bug) and
should be removed - sorry I didn't step on it earlier.  It can removed
with minimal risk of destabilizing the driver.  It should look like this:

static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
ipw_hardware_t *hw)
{
        u_short irqn;
        u_short ack;

        irqn = inw(hw->base_port + IOIR);

        if (irqn == (u_short) 0xFFFF)
                return IRQ_NONE;
        else if (irqn != 0) {
                ack = 0;
                /* Transmit complete. */
                if (irqn & IR_TXINTR) {
                        hw->tx_ready++;
                        ack |= IR_TXINTR;
                }

                /* Received data */
                if (irqn & IR_RXINTR) {
                        ack |= IR_RXINTR;
                        hw->rx_ready++;
                }
                if (ack != 0) {
                        outw(ack, hw->base_port + IOIR);

                        /* Perform the I/O retrieval in a tasklet,
because the ppp_generic
                           may be called from a tasklet, but not from a
hardware interrupt. */
                        if (!hw->tasklet_pending) {
                                hw->tasklet_pending = 1;
                                tasklet_schedule(&hw->tasklet);
                        }
                }
                return IRQ_HANDLED;
        } else
                return IRQ_NONE;

}

The v2_v3 handler should not have it either, and should start like this:

static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
ipw_hardware_t *hw)
{
    int tx = 0;
    int rx = 0;
    int rx_repeat = 0;
    int b_try_MemTX_OLD;
    do {
        u_short memtx = ioread16(hw->MemTX);
        u_short memtx_serial;
        u_short memrxdone = ioread16(&hw->memInfReg->MemRXDone);

        b_try_MemTX_OLD = 0;

        /* check whether the interrupt was generated by ipwireless card */
        if (!(memtx & MEMTX_TX) && !(memrxdone & MEMRX_RX_DONE))
            return IRQ_NONE;

        /* See if the card is physically present. Note that while it is
         * powering up, it appears not to be present. */
        if (ioread32(&hw->memInfReg->MemCardPresent) !=
CARD_PRESENT_VALUE) {
            u_short csr = ioread16(&hw->memCCR->PCCSR);
            csr &= 0xfffd;
            iowrite16(csr, &hw->memCCR->PCCSR);
            return IRQ_HANDLED;
        }

> Is some locking needed around *hw?
>   
I don't think so, but I'm happy to be corrected.


Steve


