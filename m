Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZI2V5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZI2V5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZI2V5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:57:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:49468 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI2V5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:57:41 -0400
X-IronPort-AV: E=Sophos;i="4.44,475,1249272000"; 
   d="scan'208";a="5114760"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
Subject: RE: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Sep 2009 22:57:41 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E2331E9@limkexm3.ad.analog.com>
In-Reply-To: <20090929141939.b051fe74.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
thread-index: AcpBSqS1bOUv8HKuSg6SMS2cShcTSgAAM0vA
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org><1253682664-27040-1-git-send-email-vapier@gentoo.org> <20090929141939.b051fe74.akpm@linux-foundation.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier@gentoo.org>
CC: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>, <cooloney@kernel.org>
X-OriginalArrivalTime: 29 Sep 2009 21:57:44.0223 (UTC) FILETIME=[DF8C82F0:01CA414F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andrew Morton [mailto:akpm@linux-foundation.org]
ject: Re: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad
Input Device Driver
>
>On Wed, 23 Sep 2009 01:11:04 -0400
>Mike Frysinger <vapier@gentoo.org> wrote:
>
>> +static void adp5520_irq_work(struct work_struct *work)
>> +{
>> +	struct adp5520_chip *chip =
>> +		container_of(work, struct adp5520_chip, irq_work);
>> +	unsigned int events;
>> +	uint8_t reg_val;
>> +	int ret;
>> +
>> +	ret = __adp5520_read(chip->client, MODE_STATUS, &reg_val);
>> +	if (ret)
>> +		goto out;
>> +
>> +	events =  reg_val & (OVP_INT | CMPR_INT | GPI_INT | KR_INT |
KP_INT);
>> +
>> +	blocking_notifier_call_chain(&chip->notifier_list, events,
NULL);
>> +	/* ACK, Sticky bits are W1C */
>> +	__adp5520_ack_bits(chip->client, MODE_STATUS, events);
>> +
>> +out:
>> +	enable_irq(chip->client->irq);
>> +}
>> +
>> +static irqreturn_t adp5520_irq_handler(int irq, void *data)
>> +{
>> +	struct adp5520_chip *chip = data;
>> +
>> +	disable_irq_nosync(irq);
>> +	schedule_work(&chip->irq_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>
>Disabling interrutps for an arbitrarily long period of time is pretty
>nasty.  Especially if some poor innocent device is trying to share that
>irq (can this happen?).
>
>Is there no other way?

Well - incredible slow peripherals such as I2C can't be directly
serviced from non-sleepy context such as IRQ - in case someone wants to
use level sensitive IRQs - disabling the interrupt source until serviced
used to be the common way. Typically work queues are serviced in the
shadow of the IRQ caused the Interrupt. Shared IRQs are in addition
somehow OR'ed with each other. So it really doesn't matter, if another
device asserts a SHARED IRQ; 1 OR 1 = 1  - the kernel just needs to make
sure    
that IRQs are serviced until absence... (While in return the device
caused the IRQ de-asserts its signal to the host)

This driver targets mostly embedded devices, they typically feature
dedicated interrupt channels for each Interrupt source.   

>(can this happen?)

I don't think so 

-Michael

 
