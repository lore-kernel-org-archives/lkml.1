Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbXGZIVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbXGZIVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXGZIV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:21:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:34739 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbXGZIVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:21:23 -0400
X-IronPort-AV: i="4.16,583,1175486400"; 
   d="scan'208"; a="35708463:sNHT36858801"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [GIT PULL try#2] Blackfin update
Date: Thu, 26 Jul 2007 09:21:19 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0CEDAC00@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL try#2] Blackfin update
Thread-Index: AcfPSwPfTz2Pd4QjTfKAjpz9DHOU0QAEJaHA
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: <bryan.wu@analog.com>, "Joe Perches" <joe@perches.com>,
       <michael.hennerich@analog.com>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Jul 2007 08:21:21.0221 (UTC) FILETIME=[F2968F50:01C7CF5D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Joe,

>Hi Joe, please reply to all of this email, because some developers need
>to consider your review.
>
>Hi Michael, how do you think of Joe's idea as below.
>
>Thanks,
>Best Regards,
>- Bryan Wu
>
>On Wed, 2007-07-25 at 09:46 -0700, Joe Perches wrote:
>> On Wed, 2007-07-25 at 23:26 +0800, Bryan Wu wrote:
>> > diff --git a/arch/blackfin/kernel/bfin_gpio.c
>> > b/arch/blackfin/kernel/bfin_gpio.c
>> > index bafcfa5..979cf79 100644
>> > --- a/arch/blackfin/kernel/bfin_gpio.c
>> > +++ b/arch/blackfin/kernel/bfin_gpio.c
>> > @@ -143,22 +148,100 @@ inline int check_gpio(unsigned short gpio)
>>
>> []
>>
>> > +#ifdef BF537_FAMILY
>> > +
>> > +#define PMUX_LUT_RES		0
>> > +#define PMUX_LUT_OFFSET		1
>> > +#define PMUX_LUT_ENTRIES	41
>> > +#define PMUX_LUT_SIZE		2
>> > +
>> > +static unsigned short
port_mux_lut[PMUX_LUT_ENTRIES][PMUX_LUT_SIZE] =
>{
>> > +	{P_PPI0_D13, 11}, {P_PPI0_D14, 11}, {P_PPI0_D15, 11},
>> > +	{P_SPORT1_TFS, 11}, {P_SPORT1_TSCLK, 11}, {P_SPORT1_DTPRI, 11},
>> > +	{P_PPI0_D10, 10}, {P_PPI0_D11, 10}, {P_PPI0_D12, 10},
>> > +	{P_SPORT1_RSCLK, 10}, {P_SPORT1_RFS, 10}, {P_SPORT1_DRPRI, 10},
>> > +	{P_PPI0_D8, 9}, {P_PPI0_D9, 9}, {P_SPORT1_DRSEC, 9},
>> > +	{P_SPORT1_DTSEC, 9}, {P_TMR2, 8}, {P_PPI0_FS3, 8}, {P_TMR3, 7},
>> > +	{P_SPI0_SSEL4, 7}, {P_TMR4, 6}, {P_SPI0_SSEL5, 6}, {P_TMR5, 5},
>> > +	{P_SPI0_SSEL6, 5}, {P_UART1_RX, 4}, {P_UART1_TX, 4}, {P_TMR6,
4},
>> > +	{P_TMR7, 4}, {P_UART0_RX, 3}, {P_UART0_TX, 3}, {P_DMAR0, 3},
>> > +	{P_DMAR1, 3}, {P_SPORT0_DTSEC, 1}, {P_SPORT0_DRSEC, 1},
>> > +	{P_CAN0_RX, 1}, {P_CAN0_TX, 1}, {P_SPI0_SSEL7, 1},
>> > +	{P_SPORT0_TFS, 0}, {P_SPORT0_DTPRI, 0}, {P_SPI0_SSEL2, 0},
>> > +	{P_SPI0_SSEL3, 0}
>> > +};
>>
>> Wouldn't this be better as a struct?
>>
>> struct PMUX_LUT {
>> 	unsigned short res;
>> 	unsigned short offset;
>> }
>>
>> struct PMUX_LUT port_mux_lut = {
>> 	{.res = P_PPI0_D13, .offset = 11},
>> 	{.res = P_PPi0_D14, .offset = 11},
>> etc?
>> 	};
>>

Sure - makes much more sense  

>> > +
>> > +static void portmux_setup(unsigned short per, unsigned short
>> > function)
>> > +{
>> > +	u16 y, muxreg, offset;
>>
>> Shouldn't y be int?

Not necessarily.
Y is the loop counter which counts up to PMUX_LUT_ENTRIES.
I preferably use 16bit variables for loop counters in case I know they
would never overflow.

Reason why I'm doing this is because, Blackfin features zero overhead
hardware loops. Unfortunately the loop counter register is only 16-bit.
Gcc will turn this into slightly better code.  

>>
>> > @@ -179,22 +262,15 @@ static void default_gpio(unsigned short gpio)
>> >
>> >  static int __init bfin_gpio_init(void)
>> >  {
>> > -	int i;
>> > -
>> > -	printk(KERN_INFO "Blackfin GPIO Controller\n");
>> >
>> > -	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE)
>> > -		reserved_map[gpio_bank(i)] = 0;
>> > +	str_ident = kzalloc(RESOURCE_LABEL_SIZE * 256, GFP_KERNEL);
>>
>> 256?

Just a number on top of my head (one page of memory), that fits current
and future needs. I guess we should better turn this into a define.

>>
>> perhaps better to use kcalloc(RESOURCE_LABEL_SIZE, 256, GFP_KERNEL)
>> and reference str_ident as an array of char* instead of the
>> multiplies in set_label, get_label and cmp_label?
>>
>> > +	if (!str_ident)
>> > +		return -ENOMEM;
>>

Sure - much nicer to read.

>> cheers,  Joe

Thanks for the feedback!

Regards, Michael
