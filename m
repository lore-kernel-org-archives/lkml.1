Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbYFIPdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbYFIPdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYFIPdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:33:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbYFIPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:33:38 -0400
Date: Mon, 9 Jun 2008 08:29:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
In-Reply-To: <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org>
References: <20080609080312.GA32458@elte.hu> <20080609020623.b6727f2b.akpm@linux-foundation.org> <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com> <20080609133426.GB20194@cs181133002.pp.htv.fi> <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
 <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com> <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Cornelia Huck wrote:
> 
> Does this crash happen with the conversion to the class iterator
> functions (should be in linux-next) as well? They take the class
> mutex...

I really don't think it's the locking, although I do agree that the 
locking looks bogus _too_.

I suspect that the problem is even simpler than that. On the 
"block_class.devices" list we can have two types of devices: the ones that 
have been added by the block/genhd.c code (disks: dev->type "disk_type"), 
and the ones that are added by the class layer for partitions (partitions: 
dev.type "part_type").

And *all* the block/genhd.c loops over that device list look like this:

	list_for_each_entry(dev, &block_class.devices, node) {
		if (dev->type != &disk_type)
			continue;
		sgp = dev_to_disk(dev);
		...

because you cannot do that "dev_to_disk()" on a partition entry (it won't 
have a container of type gendisk, it will be of type hd_struct).

Well, all except one. Guess which one..

So I suspect that (a) yes, we need to fix the locking, but (b) the fix for 
this particular bug is probably the trivial one appended.

And yes, this bug was introduced by commit 30f2f0eb4b ("block: do_mounts - 
accept root=<non-existant partition>"), so the alternative is to revert it 
entirely. Kay? 

		Linus

---
 block/genhd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 129ad93..b922d48 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -660,6 +660,8 @@ dev_t blk_lookup_devt(const char *name, int part)
 
 	mutex_lock(&block_class_lock);
 	list_for_each_entry(dev, &block_class.devices, node) {
+		if (dev->type != &disk_type)
+			continue;
 		if (strcmp(dev->bus_id, name) == 0) {
 			struct gendisk *disk = dev_to_disk(dev);
 
