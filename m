Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZHYVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZHYVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHYVha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:37:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43029 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZHYVh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:37:29 -0400
To: David Dillow <dave@thedillows.org>
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?Q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
References: <200903041828.49972.m.bueker@berlin.de>
	<1242001754.4093.12.camel@obelisk.thedillows.org>
	<200905112248.44868.mb@bu3sch.de> <200905112310.08534.mb@bu3sch.de>
	<1242077392.3716.15.camel@lap75545.ornl.gov>
	<4A09DC3E.2080807@googlemail.com>
	<1242268709.4979.7.camel@obelisk.thedillows.org>
	<4A0C6504.8000704@googlemail.com>
	<1242328457.32579.12.camel@lap75545.ornl.gov>
	<4A0C7443.1010000@googlemail.com>
	<1243042174.3580.23.camel@obelisk.thedillows.org>
	<m1skfkrik2.fsf@fess.ebiederm.org>
	<1250895567.23419.1.camel@obelisk.thedillows.org>
	<1250897657.23419.5.camel@obelisk.thedillows.org>
	<m1iqggf4rf.fsf@fess.ebiederm.org> <m18whcf3w2.fsf@fess.ebiederm.org>
	<1250973787.3582.14.camel@obelisk.thedillows.org>
	<m1r5v0ogvw.fsf@fess.ebiederm.org>
	<1251169150.4023.11.camel@obelisk.thedillows.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 25 Aug 2009 14:37:28 -0700
In-Reply-To: <1251169150.4023.11.camel@obelisk.thedillows.org> (David Dillow's message of "Mon\, 24 Aug 2009 22\:59\:10 -0400")
Message-ID: <m1ljl77exz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: dave@thedillows.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, m.bueker@berlin.de, rsantos@grupopie.com, romieu@fr.zoreil.com, mb@bu3sch.de, michael.riepe@googlemail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> writes:

> On Mon, 2009-08-24 at 17:51 -0700, Eric W. Biederman wrote:
>> When I decode the bits in status they are TxOK, RxOK and TxDescUnavail so it looks
>> there is some bidirectional communication going on.
>> 
>> Do we really want to loop when those bits are set?
>
> Maybe not when only those bits are set, but I worry that we would trade
> one race for another where we stop getting interrupts from the card.
>
>> Perhaps we want to remove them from rtl_cfg_infos for the part?
>
> Then you'd never get an interrupt for them in the first place, I think.
>
> I'm not real happy with the interrupt handling in the driver; it makes a
> certain amount of sense to split the MSI vs non-MSI interrupt cases out.
> It also means another pass through re-auditing things against the vendor
> driver. That's more work than I'm able to commit to at the moment.
>
> I've not been able to reproduce it locally on my r8169d, running for ~30
> minutes straight at full speed. I've not tried running it in UP, though.
> Perhaps I can do that tomorrow.
>
> Here's a possible patch to mask the NAPI events while we're running in
> NAPI mode. I'm not sure it is going to help, since the intr_mask was
> 0xffff when you hit the loop guard, so I left it in for now.

Ok.  I now get what your patch was trying to do and that does look like
a reasonable test.  

I prefer:
while ((status != 0xffff) && (status & tp->intr_mask))

The presence of TxDescUnavail suggests as is usually the case
that the interrupt status bits are independent of which interrupts
are actually enabled to fire.

I will take a moment and give that a try.

I still like the idea of masking everything having poll do all
of the work and then unmasking everything.  That seems a little less
fragile to me.

Eric

> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index b82780d..12755b7 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -3556,6 +3556,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  	void __iomem *ioaddr = tp->mmio_addr;
>  	int handled = 0;
>  	int status;
> +	int count = 0;
>  
>  	/* loop handling interrupts until we have no new ones or
>  	 * we hit a invalid/hotplug case.
> @@ -3564,6 +3565,15 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  	while (status && status != 0xffff) {
>  		handled = 1;
>  
> +		if (count++ > 100) {
> +			printk_once("r8169 screaming irq status %08x "
> +				"mask %08x event %08x napi %08x\n",
> +				status, tp->intr_mask, tp->intr_event,
> +				tp->napi_event);
> +			break;
> +		}
> +
> +
>  		/* Handle all of the error cases first. These will reset
>  		 * the chip, so just exit the loop.
>  		 */
> @@ -3613,6 +3623,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>  		RTL_W16(IntrStatus,
>  			(status & RxFIFOOver) ? (status | RxOverflow) : status);
>  		status = RTL_R16(IntrStatus);
> +		status &= tp->intr_mask;
>  	}
>  
>  	return IRQ_RETVAL(handled);
