Return-Path: <linux-kernel-owner+w=401wt.eu-S935121AbXLPSFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121AbXLPSFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934515AbXLPSFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:05:43 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:32253 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1765954AbXLPSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:05:41 -0500
X-Trace: 659758951-mk-filter-3.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.89.91
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HANb3ZEdRAVlb/2dsb2JhbACBV5AAlkU
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20071216095019.GA12184@linux-sh.org>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
	 <20071216095019.GA12184@linux-sh.org>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 18:05:13 +0000
Message-Id: <1197828313.6254.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-16 at 18:50 +0900, Paul Mundt wrote:

> > +static int gdrom_readdisk_dma(int block, int block_cnt, char *buffer)
> > +{
> > +	int err;
> > +	struct packet_command *read_command;
> > +	/* release the spin lock but check later
> > + 	 * we're not in the middle of some dma */
> > +	spin_unlock(&gdrom_lock);
> 
> The locking strategy here is a bit interesting, has spinlock debugging
> tossed any profanities to your console?
> 

No, no errors reported.

I think I've been careful - I release the lock because we're doing
things like allocating memory and then sleeping on the queue.

But I also need to check various registers so that (a) we don't try to
do a second DMA until the hardware is ready and (b) we properly
serialize access to the device by two different threads of execution.

Seems to work.

Though I have an issue with the AICA driver: as it just locks out all
other DMA when doing its own DMA, it is causing the GD Rom driver to
miss some reads (as the interrupts are locked between the DMA being
requested and the interrupt returning afaics). It's not terminal by any
means, but it can be annoying!

/ # /mpg123 -g 25 /mnt/01-Come\ together.mp3 
High Performance MPEG 1.0/2.0/2.5 Audio Player for Layer 1, 2 and 3.
Version 0.59r-gpl (2005/04/08). Copyright 1995-2005 by The Mpg123
Project.
Uses code from various people, see 'AUTHORS' for full list.
This software comes with ABSOLUTELY NO WARRANTY. For details, see 
the enclosed file COPYING for license information (GPL).

Directory: /mnt/
Playing MPEG stream from 01-Come together.mp3 ...
Junk at the beginning 49443303
MPEG 1.0 layer III, 192 kbit/s, 44100 Hz joint-stereo
[  168.794478] irq 11, desc: 8c2723dc, depth: 1, count: 0, unhandled: 0
[  168.800318] ->handle_irq():  8c048580, handle_bad_irq+0x0/0x2c0
[  168.806404] ->chip(): 8c2768c4, no_irq_chip+0x0/0x40
[  168.811522] ->action(): 00000000
[  168.814846]   IRQ_DISABLED set
[  168.817992] unexpected IRQ trap at vector 0b
[  173.548850] irq 11, desc: 8c2723dc, depth: 1, count: 0, unhandled: 0
[  173.554691] ->handle_irq():  8c048580, handle_bad_irq+0x0/0x2c0
[  173.560777] ->chip(): 8c2768c4, no_irq_chip+0x0/0x40
[  173.565895] ->action(): 00000000
[  173.569219]   IRQ_DISABLED set


