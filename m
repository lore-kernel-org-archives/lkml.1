Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYFIPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYFIPl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYFIPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:41:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYFIPlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:41:17 -0400
Date: Mon, 9 Jun 2008 17:38:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
	blk_lookup_devt()/prepare_namespace()
Message-ID: <20080609153856.GA5149@elte.hu>
References: <20080609080312.GA32458@elte.hu> <20080609020623.b6727f2b.akpm@linux-foundation.org> <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com> <20080609133426.GB20194@cs181133002.pp.htv.fi> <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com> <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com> <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com> <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

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
> "block_class.devices" list we can have two types of devices: the ones 
> that have been added by the block/genhd.c code (disks: dev->type 
> "disk_type"), and the ones that are added by the class layer for 
> partitions (partitions: dev.type "part_type").
> 
> And *all* the block/genhd.c loops over that device list look like this:
> 
> 	list_for_each_entry(dev, &block_class.devices, node) {
> 		if (dev->type != &disk_type)
> 			continue;
> 		sgp = dev_to_disk(dev);
> 		...
> 
> because you cannot do that "dev_to_disk()" on a partition entry (it 
> won't have a container of type gendisk, it will be of type hd_struct).
> 
> Well, all except one. Guess which one..
> 
> So I suspect that (a) yes, we need to fix the locking, but (b) the fix for 
> this particular bug is probably the trivial one appended.
> 
> And yes, this bug was introduced by commit 30f2f0eb4b ("block: 
> do_mounts - accept root=<non-existant partition>"), so the alternative 
> is to revert it entirely. Kay?

ah. I suspect that explains the sporadic nature as well: normally there 
is 'some' object at the list address, just with an invalid type.

The invalid type only gets visible as a hard crash if due to PAGEALLOC 
the structure sizes and kmalloc/slab details cause the invalid access to 
go to a not yet allocated page. (and then it crashes there)

And that in itself is a rather unlikely and fragile condition (it might 
even depend on timings of various allocations), that's why the bug wasnt 
really reproducible deterministically.

	Ingo
