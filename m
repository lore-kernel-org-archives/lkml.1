Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYFIRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYFIRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYFIRRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:17:08 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:21126 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYFIRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:17:05 -0400
Date: Mon, 9 Jun 2008 19:15:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
Message-ID: <20080609191521.1a56b6a6@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0806090858310.3473@woody.linux-foundation.org>
References: <20080609080312.GA32458@elte.hu>
	<20080609020623.b6727f2b.akpm@linux-foundation.org>
	<19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	<20080609133426.GB20194@cs181133002.pp.htv.fi>
	<19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
	<19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
	<20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
	<20080609153856.GA5149@elte.hu>
	<alpine.LFD.1.10.0806090858310.3473@woody.linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 09:15:40 -0700 (PDT),
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And this is all still ignoring the locking issue, of course. It would be 
> trivial to just remove the block_class_lock, and change
> 
> 	mutex_[un]lock(&block_class_lock);
> 
> into
> 
> 	down|up(&block_class.sem);
> 
> except for _one_ case, which is
> 
> 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
> 
> which really wants a mutex, not a sempahore.
> 
> So to fix that, we'd need to make the class->sem be a mutex, and pass that 
> in. Which is probably a good change too, but makes the whole thing much 
> bigger.

The driver core changes in -next convert class->sem to
class->p->class_mutex, which makes it non-accessible to drivers.
Most of the locking is easily done through converting to the class
iterator functions, but there are some cases where this is not going to
work:

- The {register,unregister}_blkdev() functions, which don't directly
involve the class.
- The iterators for /proc/partitions, which take the lock in
part_start() and give it up again in part_stop().

Maybe we need a possibilty for a driver to lock a class from outside?
