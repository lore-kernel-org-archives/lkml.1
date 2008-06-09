Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYFIPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYFIPq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYFIPqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:46:50 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:58891 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214AbYFIPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:46:49 -0400
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
	blk_lookup_devt()/prepare_namespace()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Neil Brown <neilb@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
References: <20080609080312.GA32458@elte.hu>
	 <20080609020623.b6727f2b.akpm@linux-foundation.org>
	 <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com>
	 <20080609133426.GB20194@cs181133002.pp.htv.fi>
	 <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
	 <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com>
	 <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
	 <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 17:46:53 +0200
Message-Id: <1213026413.14898.5.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 08:29 -0700, Linus Torvalds wrote:
> On Mon, 9 Jun 2008, Cornelia Huck wrote:
> > 
> > Does this crash happen with the conversion to the class iterator
> > functions (should be in linux-next) as well? They take the class
> > mutex...
> 
> I really don't think it's the locking, although I do agree that the 
> locking looks bogus _too_.
> 
> I suspect that the problem is even simpler than that. On the 
> "block_class.devices" list we can have two types of devices: the ones that 
> have been added by the block/genhd.c code (disks: dev->type "disk_type"), 
> and the ones that are added by the class layer for partitions (partitions: 
> dev.type "part_type").
> 
> And *all* the block/genhd.c loops over that device list look like this:
> 
> 	list_for_each_entry(dev, &block_class.devices, node) {
> 		if (dev->type != &disk_type)
> 			continue;
> 		sgp = dev_to_disk(dev);
> 		...
> 
> because you cannot do that "dev_to_disk()" on a partition entry (it won't 
> have a container of type gendisk, it will be of type hd_struct).
> 
> Well, all except one. Guess which one..
> 
> So I suspect that (a) yes, we need to fix the locking, but (b) the fix for 
> this particular bug is probably the trivial one appended.
> 
> And yes, this bug was introduced by commit 30f2f0eb4b ("block: do_mounts - 
> accept root=<non-existant partition>"), so the alternative is to revert it 
> entirely. Kay? 

Yeah, the patch looks fine. That could be the reason.

I think we should keep the patch, as it fixed a different issue, and it
seems the bug was there even before the patch - the function was just
not called 3 times, so even more unlikely to trigger it.

Thanks,
Kay

