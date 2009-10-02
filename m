Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZJBNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZJBNs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZJBNs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:48:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:55933 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbZJBNs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:48:26 -0400
X-IronPort-AV: E=Sophos;i="4.44,494,1249272000"; 
   d="scan'208";a="7117514"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction LCDBacklight and Keypad Input Device Driver
Date: Fri, 2 Oct 2009 14:48:27 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction LCDBacklight and Keypad Input Device Driver
thread-index: AcpCoKkp7zT02K+cSQWdTYujkjhMDwAl7YWQAAqMDsA=
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org><1253682664-27040-1-git-send-email-vapier@gentoo.org><20091001140948.GD10199@sortiz.org> <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       "Mike Frysinger" <vapier@gentoo.org>, <tglx@linutronix.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Oct 2009 13:48:29.0704 (UTC) FILETIME=[0621A080:01CA4367]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: uclinux-dist-devel-bounces@blackfin.uclinux.org
[mailto:uclinux-dist-devel-
>bounces@blackfin.uclinux.org] On Behalf Of Hennerich, Michael
>Device Driver
>
>Hi Samuel,
>
>>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>>Hi Mike,
>>
>>Some comments on this patch:
>>
>>On Wed, Sep 23, 2009 at 01:11:04AM -0400, Mike Frysinger wrote:
>>> +static irqreturn_t adp5520_irq_handler(int irq, void *data)
>>> +{
>>> +	struct adp5520_chip *chip = data;
>>> +
>>> +	disable_irq_nosync(irq);
>>> +	schedule_work(&chip->irq_work);
>>Have you considered using a threaded irq handler here ?
>
>The Linux version I developed this driver on didn't feature threaded
irq
>handlers.
>But thanks I'm going to take a look here.

Hi Samuel,

Well the threaded irq handlers are no option here, since we use a Level
Sensitive Interrupt. 
The work queue here is to schedule the main irq handler outside hardirq
context.
I2C can't we invoked form none sleepy context, so we can't clear the
interrupt. 
This will cause that we execute the hardirq over and over again,
preventing the irq thread to be run.

The threaded irqs with its current implementation also doesn't allow me
to disable the irq in the hardirq handler.

There have been some discussions about this on lkml recently.
Until there is a way to workaround this issue (handle_level_oneshot_irq,
etc.),
I like to stick with: 

>>> +	disable_irq_nosync(irq);
>>> +	schedule_work(&chip->irq_work);

Best regards,
Michael

