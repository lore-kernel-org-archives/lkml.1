Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYIQKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYIQKk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYIQKkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:40:21 -0400
Received: from www.tglx.de ([62.245.132.106]:40040 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYIQKkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:40:20 -0400
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] uio: add automata sercos3 pci card support
From: John Ogness <john.ogness@linutronix.de>
References: <86d4j4z9xi.fsf@johno-ibook.fn.ogness.net>
	<86d4j3f9vs.fsf@johno-ibook.fn.ogness.net>
	<20080917094802.GA3034@local>
Date: Wed, 17 Sep 2008 12:40:10 +0200
In-Reply-To: <20080917094802.GA3034@local> (Hans J. Koch's message of "Wed\, 17 Sep 2008 11\:48\:04 +0200")
Message-ID: <8663ovf439.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-09-17, Hans J. Koch <hjk@linutronix.de> wrote:
>> +/* this function assumes ier0_cache_lock is locked! */
>> +static void sercos3_disable_interrupts(struct uio_info *info,
>> +				       struct sercos3_priv *priv)
>> +{
>> +	void __iomem *ier0 = info->mem[3].internal_addr + IER0_OFFSET;
>> +	u32 tmp = ioread32(ier0);
>> +
>> +	if (tmp) {
>
> Is that needed?

I check the value here for 2 reasons:

1. If the interrupts are already disabled, there is no need to perform
   an iowrite32().

2. If the interrupts are already disabled, we do not want to overwrite
   the ier0_cache with a 0.

Be aware that sercos3_disable_interrupts() can also be called via
sercos3_irqcontrol(). The official driver would never do this, but
maybe someone else would? (Your review of PATCHv1 insisted that
sercos3_irqcontrol() supports disabling the interrupt.) I don't want
to risk enabled interrupts getting lost (i.e. not being re-enabled
later).

>> +		/* store previously enabled interrupts */
>> +		priv->ier0_cache |= tmp;
>
> This doesn't match the comment. Why |= and not a simple assignment?

Here I was concerned that interrupts are being disabled but the
ier0_cache isn't empty. This situation would occur if the
userspace-driver manually enabled some interrupts before handling
pending interrupts.

Normally this would not happen, but since UIO-drivers deal with
context switches to userspace, I decided that it could be possible. So
I decided to |= the bitmask instead of overwriting it to prevent
enabled interrupts from getting lost.

I can change the comment to read:
        /* add enabled interrupts to cache */

>> +
>> +		/* disable interrupts */
>> +		iowrite32(0, ier0);
>> +	}
>> +}

[...]

>> +static irqreturn_t sercos3_handler(int irq, struct uio_info *info)
>> +{
>> +	struct sercos3_priv *priv = info->priv;
>> +	void __iomem *isr0 = info->mem[3].internal_addr + ISR0_OFFSET;
>> +
>> +	if (!ioread32(isr0))
>> +		return IRQ_NONE;
>
> If that card has an irq status and an irq enable register, you have
> to check both. The status bit could be set, but the irq is not
> enabled, in which case you have to return IRQ_NONE. Should look
> something like this:
>
> 	if (!(ier & isr))
> 		return IRQ_NONE;
>
> This assumes the enable and corresponding status bits are in the
> same bit position in the registers.

They are in the same bit position. For PATCHv3 I will change to code
to be:

        if (!(ioread32(isr0) & ioread32(ier0)))
                return IRQ_NONE;

>> +	spin_lock(&priv->ier0_cache_lock);
>> +	sercos3_disable_interrupts(info, priv);
>> +	spin_unlock(&priv->ier0_cache_lock);
>> +
>> +	return IRQ_HANDLED;
>> +}
