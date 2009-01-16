Return-Path: <linux-kernel-owner+w=401wt.eu-S937427AbZAPTXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937427AbZAPTXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933438AbZAPTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:23:13 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:23075 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbZAPTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:23:12 -0500
Message-ID: <4970DE4A.8030900@caviumnetworks.com>
Date: Fri, 16 Jan 2009 11:21:46 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090116152721.GA6994@havoc.gtf.org> <20090116093101.6d77b69b.akpm@linux-foundation.org>
In-Reply-To: <20090116093101.6d77b69b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 19:21:46.0192 (UTC) FILETIME=[ABFA4D00:01C9780F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 16 Jan 2009 10:27:21 -0500 Jeff Garzik <jeff@garzik.org> wrote:

>> +/**
>> + * Convert nanosecond based time to setting used in the
>> + * boot bus timing register, based on timing multiple
>> + */
> 
> There are comments in this file which use the kerneldoc token, but
> which aren't in kerneldoc format.
> 

I will endeavor to improve it.

>> +static unsigned int ns_to_tim_reg(unsigned int tim_mult, unsigned int nsecs)
>> +{
>> +	unsigned int val;
>> +
>> +	/*
>> +	 * Compute # of eclock periods to get desired duration in
>> +	 * nanoseconds.
>> +	 */
>> +	val = DIV_ROUND_UP(nsecs * (octeon_get_clock_rate() / 1000000),
>> +			  1000 * tim_mult);
>> +
>> +	return val;
>> +}
>>
> 
> There's great potential for overflows here, but I couldn't be bothered
> picking through it.  Are we sure that it's watertight?
> 

We are calculating timing register values, there will not be overflow
given that the delays are all under 1000nS and the clock rate will
never be greater than 10GHz.


> There's a 64-bit divide in there.  Will it link on 32-bit platforms?

It might not...

> 
> Or is this all 64-bit-only code?
> 

... but we are currently only supporting 64 bit kernels.


> wtf is an octeon anyway?  (greps).  Some MIPS thing.

Multicore MIPS64 SOC.

> I guess it's 64-bit-only.

Current, yes.  See above.

[...]
>> +/**
>> + * Called after libata determines the needed PIO mode. This
>> + * function programs the Octeon bootbus regions to support the
>> + * timing requirements of the PIO mode.
>> + *
>> + * @ap:     ATA port information
>> + * @dev:    ATA device
>> + */
> 
> That's getting more kerneldoccy, but isn't there yet.

As with the others, I will try to improve it.

[...]
>> +	T = (int)(2000000000000LL / octeon_get_clock_rate());
> 
> 64/64 divide.
> 

As with the case above, it works as only 64 bit kernel supported.

[...]
>> +static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
>> +{
>> +	u16 blob;
>> +	/* The base of the registers is at ioaddr.data_addr. */
>> +	void __iomem *base = ap->ioaddr.data_addr;
>> +
>> +	blob = __raw_readw(base + 0xc);
> 
> why __raw?
> 

readw() does byte swapping, we don't want that, hence the __raw.

[...]
>> +
>> +	cf_port = (struct octeon_cf_port *)ap->private_data;
> 
> Unneeded, undesirable cast of void* (multiple instances).
> 

I will fix it.


[...]
>>
>> +static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
>> +{
>> +	struct ata_host *host = dev_instance;
>> +	struct octeon_cf_port *cf_port;
>> +	int i;
>> +	unsigned int handled = 0;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&host->lock, flags);
> 
> Would spin_lock() suffice here?

I have to think about that one.



Thanks for looking at it,
David daney

