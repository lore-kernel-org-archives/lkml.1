Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZG3Wtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZG3Wtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZG3Wtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:49:31 -0400
Received: from chip2og101.obsmtp.com ([64.18.13.51]:51111 "HELO
	chip2og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752406AbZG3Wta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:49:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/1] [ARM] ep93xx clockevent support
Date: Thu, 30 Jul 2009 18:49:28 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901B77380@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901B77371@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [ARM] ep93xx clockevent support
Thread-Index: AcoKtfDPeJvW/43qTk6vhRgkIsJwSgGq/eEgAADdtbA=
References: <1248253786-18993-2-git-send-email-b33fc0d3@gentoo.org><1248257565-11333-1-git-send-email-b33fc0d3@gentoo.org> <BD79186B4FD85F4B8E60E381CAEE190901B77371@mi8nycmail19.Mi8.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ahmed Ammar" <b33fc0d3@gentoo.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Ahmed Ammar" <aammar@edge-techno.com>
X-OriginalArrivalTime: 30 Jul 2009 22:49:29.0979 (UTC) FILETIME=[FF8684B0:01CA1167]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 30, 2009 3:18 PM, H Hartley Sweeten wrote:
>> From: Ahmed Ammar <aammar@edge-techno.com>
>> 
>> Based on previous work by Thomas Gleixner.
>> 
>> Signed-off-by: Ahmed Ammar <aammar@edge-techno.com>
>
> Hmm..  With kernel 2.6.30.2 this does not build.  See below.

Oops..  My bad.  One of the issues was my fault...

[snip]

>>  static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
>>  {
>> -	__raw_writel(1, EP93XX_TIMER1_CLEAR);
>> -	while ((signed long)
>> -		(__raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time)
>> -						>= TIMER4_TICKS_PER_JIFFY) {
>> -		last_jiffy_time += TIMER4_TICKS_PER_JIFFY;
>> -		timer_tick();
>> -	}
>> -
>> +	struct clock_event_device *evt = dev_id;
>> + 	__raw_writel(EP93XX_TC_CLEAR, EP93XX_TIMER1_CLEAR);
>> +	evt->event_handler(evt);
>
> Here I get "error: dereferencing pointer to incomplete type" 

I added a typo that caused this... ;-)

[snip]

>> -	setup_irq(IRQ_EP93XX_TIMER1, &ep93xx_timer_irq);
>> +cycle_t ep93xx_get_cycles(void)
>> +{
>> +	return __raw_readl(EP93XX_TIMER4_VALUE_LOW);
>>  }
>>  
>> -static unsigned long ep93xx_gettimeoffset(void)
>> +static struct clocksource clocksource_ep93xx = {
>> +	.name		= "ep93xx_timer4",
>> +	.rating		= 200,
>> +	.read		= ep93xx_get_cycles,
>
> Here I get "warning: initialization from incompatible pointer type"

This one is real.

The read callback is supposed to be:

	cycle_t (*read)(struct clocksource *cs);

You need to fix the ep93xx_get_cycles() function and the call below.

>> +	.mask		= 0xFFFFFFFF,
>> +	.shift		= 20,
>> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>> +};
>> +
>> +/*
>> + * Returns current time from boot in nsecs. It's OK for this to wrap
>> + * around for now, as it's just a relative time stamp.
>> + */
>> +unsigned long long sched_clock(void)
>>  {
>> -	int offset;
>> +	return cyc2ns(&clocksource_ep93xx, ep93xx_get_cycles());

Here.

Regards,
Hartley
