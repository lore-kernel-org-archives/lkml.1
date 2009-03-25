Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZCYLES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZCYLES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZCYLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:04:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33058 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZCYLED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:04:03 -0400
Date: Wed, 25 Mar 2009 12:04:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325110401.GM27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net> <20090324210138.71029c2c@mjolnir.ossman.eu> <20090325104837.GA18389@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325104837.GA18389@roarinelk.homelinux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Manuel Lauss wrote:
> Hello Pierre, Jens,
> 
> On Tue, Mar 24, 2009 at 09:01:38PM +0100, Pierre Ossman wrote:
> > On Mon, 23 Mar 2009 10:28:02 +0100
> > Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> > 
> > > Hello Pierre,
> > > 
> > > Since about 2.6.28-rc1, I hit the following BUG_ON() in mmc/core.c
> > > (line 155):
> > > 
> > >         if (mrq->data) {
> > >                 BUG_ON(mrq->data->blksz > host->max_blk_size);
> > > >>>>>>>>>       BUG_ON(mrq->data->blocks > host->max_blk_count);  <<<<<<
> > >                 BUG_ON(mrq->data->blocks * mrq->data->blksz >
> > >                         host->max_req_size);
> > > 
> > > It's easy to reproduce; just set your favorite host controllers'
> > > mmc->max_blk_cnt to 1 (or anything smaller than 4).  As far as I can
> > > tell it was introduced with some block layer changes before 2.6.28-rc1
> > > was released.
> > > 
> > 
> > Ouch. Have you determined that it is the block layer that isn't
> > respecting its settings? If so, the we probably need to notify Jens
> > Axboe.
> 
> (Added Jens to CC).
> 
> Yes, it seems the block layer doesn't honor the one-sector request made
> in drivers/mmc/card/queue.c:187 (and 161).  The debug log says:
> 
> mmc0: new SD card at address aaaa
> blk_queue_max_sectors: set to minimum 8
> mmc0: starting CMD16 arg 00000200 flags 00000095
> mmc0: req done (CMD16): 0: 00000900 00000000 00000000 00000000
> mmcblk0: mmc0:aaaa SD01G 968 MiB
>  mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 000000b5
> mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> mmc0:     CMD12 arg 00000000 flags 0000049d
> ------------[ cut here ]------------
> kernel BUG at /mnt/work/sh7760/kernel/linux-2.6.git/drivers/mmc/core/core.c:155!
> 
> 
> This "blk_queue_max_sectors: set to minimum 8" is what's haunting my
> mmc host driver (hardware has enormous problems doing multiblock writes,
> hence the limitation to a single block per request).

Well, as the warning tells you, it's not supported. But that doesn't
mean you can't do single sector transfers and complete the IO when you
have done all of them.

-- 
Jens Axboe

