Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZJBOhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZJBOhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZJBOhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:37:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:51359 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZJBOhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:37:16 -0400
X-IronPort-AV: E=Sophos;i="4.44,494,1249272000"; 
   d="scan'208";a="7119768"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 MultifunctionLCDBacklight and Keypad Input Device Driver
Date: Fri, 2 Oct 2009 15:37:15 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E33B2B6@limkexm3.ad.analog.com>
In-Reply-To: <20091002142725.GC11133@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 MultifunctionLCDBacklight and Keypad Input Device Driver
thread-index: AcpDbIJeGNl5SSxMRuiieKPusKtNmAAAGGXA
References: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com> <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com> <20091002142725.GC11133@sirena.org.uk>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Samuel Ortiz" <sameo@linux.intel.com>,
       "Mike Frysinger" <vapier@gentoo.org>, <tglx@linutronix.de>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Oct 2009 14:37:19.0570 (UTC) FILETIME=[D877B320:01CA436D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: Friday, October 02, 2009 4:27 PM
>To: Hennerich, Michael
>Cc: Samuel Ortiz; Mike Frysinger; tglx@linutronix.de;
uclinux-dist-devel@blackfin.uclinux.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520
MultifunctionLCDBacklight and Keypad Input
>Device Driver
>
>On Fri, Oct 02, 2009 at 02:48:27PM +0100, Hennerich, Michael wrote:
>
>> Well the threaded irq handlers are no option here, since we use a
Level
>> Sensitive Interrupt.
>> The work queue here is to schedule the main irq handler outside
hardirq
>> context.
>> I2C can't we invoked form none sleepy context, so we can't clear the
>> interrupt.
>> This will cause that we execute the hardirq over and over again,
>> preventing the irq thread to be run.
>
>> The threaded irqs with its current implementation also doesn't allow
me
>> to disable the irq in the hardirq handler.
>
>This should all work perfectly fine.  If you don't supply a hard IRQ
>handler then the genirq infrastructure will disable the IRQ and
schedule
>the threaded handler, reenabling the IRQ when the threaded handler
>finishes.  The threaded handler runs in a non-atomic context so it can
>happily access I2C devices.

Hi Mark,

I saw your patch: mfd: Convert WM8350 to use request_threaded_irq()

And was wondering how this ever worked.
I'm using: Linux release 2.6.31.1-ADI-2010R1-pre-svn7535, build #10835
Fri Oct 2 14:48:19 CEST 2009

int request_threaded_irq(unsigned int irq, irq_handler_t handler,
			 irq_handler_t thread_fn, unsigned long
irqflags,
			 const char *devname, void *dev_id)
{
--- snip ---

	if (!handler)
		return -EINVAL;

}

So I guess your patch won't work on 2.6.31

>
>> There have been some discussions about this on lkml recently.
>> Until there is a way to workaround this issue
(handle_level_oneshot_irq,
>> etc.),
>> I like to stick with:
>
>> >>> +	disable_irq_nosync(irq);
>> >>> +	schedule_work(&chip->irq_work);
>
>This is essentially what a threaded IRQ handler does with current
>mainline.  There were issues in 2.6.31 but I believe all Thomas' fixes
>have been merged now.

Do you know when they merged?
They are not in latest staple 2.6.31.1.

Best regards,
Michael


