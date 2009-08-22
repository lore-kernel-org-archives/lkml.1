Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbZHVAZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbZHVAZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbZHVAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:25:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37162 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbZHVAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:25:04 -0400
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
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 21 Aug 2009 17:24:58 -0700
In-Reply-To: <1250897657.23419.5.camel@obelisk.thedillows.org> (David Dillow's message of "Fri\, 21 Aug 2009 19\:34\:17 -0400")
Message-ID: <m1iqggr8yt.fsf@fess.ebiederm.org>
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

> On Fri, 2009-08-21 at 18:59 -0400, David Dillow wrote:
>> On Fri, 2009-08-21 at 13:57 -0700, Eric W. Biederman wrote:
>> > David Dillow <dave@thedillows.org> writes:
>> > I have what at first glance looks like a problem caused by this
>> > patch.  For the last month since upgrading one of my machines from
>> > 2.6.28 to 2.6.30 it has been becomming inaccessible from the
>> > network and I have a few:
>> > 
>> > NETDEV WATCHDOG: eth0 (r8169): transmit timed out
>> > 
>> > in my logs and a lot soft lockups that always have rtl8169_interrupt
>> > as the thing that is running.   I suspect your patch has introduced
>> > a near infinite loop in the interrupt handler and is causing these
>> > soft lockups.
>> > 
>> > Any ideas?
>> 
>> I would be surprised, but I suppose it is not out of the realm of
>> possibility. Can you send me a full dmesg, please?
>
> Re-looking at the code, I'd guess that some IRQ status line is getting
> stuck high, but I don't see why -- we should acknowledge all outstanding
> interrupts each time through the loop, whether we care about them or
> not.
>
> Could reproduce a problem with the following patch applied, and send the
> full dmesg, please?

Will do.  This looks like a good way to test my hypothesis thanks.
I can't quite reproduce this problem so it may be a few days before
I know.

Eric


> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index b82780d..46cb05a 100644
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
