Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYFIQSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYFIQSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYFIQSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:18:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209AbYFIQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:18:29 -0400
Date: Mon, 9 Jun 2008 09:15:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
In-Reply-To: <20080609153856.GA5149@elte.hu>
Message-ID: <alpine.LFD.1.10.0806090858310.3473@woody.linux-foundation.org>
References: <20080609080312.GA32458@elte.hu> <20080609020623.b6727f2b.akpm@linux-foundation.org> <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com> <20080609133426.GB20194@cs181133002.pp.htv.fi> <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com>
 <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com> <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com> <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org> <20080609153856.GA5149@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jun 2008, Ingo Molnar wrote:
> 
> ah. I suspect that explains the sporadic nature as well: normally there 
> is 'some' object at the list address, just with an invalid type.

Yes. It could cause two kinds of problems:

 - it might end up returning the wrong 'dev_t'. This is unlikely, since we 
   only have two cases: the working whole-disk case, and the case where we 
   find a partition.

   But if we find a partition, we'd still get the right dev_t *most* of 
   the time, because we'd first get called with "part=0", and then we have 

	if (part < disk->minors)
		devt = MKDEV(MAJOR(dev->devt),
			MINOR(dev->devt) + part);
	break;

   where we would only fail if that conditional statement would be untrue 
   (and then we'd incorrectly return MKDEV(0,0)). Otherwise, 'devt' ends 
   up being correct anyway.

   So one effect of this bug would be that it would use the random 
   "disk->minors" value to either return the right devt, or return one 
   that is all zeroes. But if we return the all-zeroes case, then 
   init/do_mounts.c will just try again, this time with the numbers 
   removed, and now it wouldn't hit the "strcmp()" on any partition, and 
   the next time around it would find a disk and work again.

   So this is a bug, but it's one that essentially is hidden by the 
   caller.

 - The other alternative is that the bogus "disk->minors" thing would 
   cause a page fault. This would only happen if the partition allocation 
   was the first thing in a page, and the previous page was unused, and 
   you had DEBUG_PAGEALLOC enabled.

   This is obviously the case you saw.

My trivial fix makes it ignore partitions entirely.

We *could* (and perhaps should) do something slightly more involved 
instead, which actually uses a partition if it's there). Like this. That 
would avoid my one nagging worry (that some clever usage makes partitions 
with a different numbering or without a base block device).

And this is all still ignoring the locking issue, of course. It would be 
trivial to just remove the block_class_lock, and change

	mutex_[un]lock(&block_class_lock);

into

	down|up(&block_class.sem);

except for _one_ case, which is

	bdev_map = kobj_map_init(base_probe, &block_class_lock);

which really wants a mutex, not a sempahore.

So to fix that, we'd need to make the class->sem be a mutex, and pass that 
in. Which is probably a good change too, but makes the whole thing much 
bigger.

		Linus

---
 block/genhd.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 129ad93..101530e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -661,11 +661,15 @@ dev_t blk_lookup_devt(const char *name, int part)
 	mutex_lock(&block_class_lock);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (strcmp(dev->bus_id, name) == 0) {
-			struct gendisk *disk = dev_to_disk(dev);
-
-			if (part < disk->minors)
-				devt = MKDEV(MAJOR(dev->devt),
-					     MINOR(dev->devt) + part);
+			if (dev->type == &disk_type) {
+				struct gendisk *disk = dev_to_disk(dev);
+				if (part >= disk->minors)
+					continue;
+			} else {
+				if (part)
+					continue;
+			}
+			devt = dev->devt + part;
 			break;
 		}
 	}
