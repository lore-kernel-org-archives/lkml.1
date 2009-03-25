Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbZCYKwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbZCYKwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZCYKwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:52:35 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:44027 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZCYKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:52:34 -0400
Date: Wed, 25 Mar 2009 11:48:37 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325104837.GA18389@roarinelk.homelinux.net>
References: <20090323092802.GA30122@roarinelk.homelinux.net> <20090324210138.71029c2c@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324210138.71029c2c@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre, Jens,

On Tue, Mar 24, 2009 at 09:01:38PM +0100, Pierre Ossman wrote:
> On Mon, 23 Mar 2009 10:28:02 +0100
> Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> 
> > Hello Pierre,
> > 
> > Since about 2.6.28-rc1, I hit the following BUG_ON() in mmc/core.c
> > (line 155):
> > 
> >         if (mrq->data) {
> >                 BUG_ON(mrq->data->blksz > host->max_blk_size);
> > >>>>>>>>>       BUG_ON(mrq->data->blocks > host->max_blk_count);  <<<<<<
> >                 BUG_ON(mrq->data->blocks * mrq->data->blksz >
> >                         host->max_req_size);
> > 
> > It's easy to reproduce; just set your favorite host controllers'
> > mmc->max_blk_cnt to 1 (or anything smaller than 4).  As far as I can
> > tell it was introduced with some block layer changes before 2.6.28-rc1
> > was released.
> > 
> 
> Ouch. Have you determined that it is the block layer that isn't
> respecting its settings? If so, the we probably need to notify Jens
> Axboe.

(Added Jens to CC).

Yes, it seems the block layer doesn't honor the one-sector request made
in drivers/mmc/card/queue.c:187 (and 161).  The debug log says:

mmc0: new SD card at address aaaa
blk_queue_max_sectors: set to minimum 8
mmc0: starting CMD16 arg 00000200 flags 00000095
mmc0: req done (CMD16): 0: 00000900 00000000 00000000 00000000
mmcblk0: mmc0:aaaa SD01G 968 MiB
 mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 000000b5
mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
mmc0:     CMD12 arg 00000000 flags 0000049d
------------[ cut here ]------------
kernel BUG at /mnt/work/sh7760/kernel/linux-2.6.git/drivers/mmc/core/core.c:155!


This "blk_queue_max_sectors: set to minimum 8" is what's haunting my
mmc host driver (hardware has enormous problems doing multiblock writes,
hence the limitation to a single block per request).

Thanks!
	Manuel Lauss
