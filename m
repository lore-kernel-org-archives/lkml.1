Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125Ab0AEDUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0AEDUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577Ab0AEDUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:20:40 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:41546 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0AEDUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:20:39 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] [mmotm] Add swap slot free callback to block_device_operations
Date: Tue,  5 Jan 2010 08:48:33 +0530
Message-Id: <1262661514-4148-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback is required when RAM based devices are
used as swap disks. One such device is ramzswap[1] which
is used as compressed in-memory swap disk. For such
devices, we need a callback as soon as a swap slot is no
longer used to allow freeing memory allocated for this
slot. Without this callback, stale data can quickly
accumulate in memory defeating the whole purpose of
such devices.

Another user of this callback will be "preswap" as
introduced by "Transcendent Memory" patches:
http://lwn.net/Articles/367286/
(I intend to integrade preswap with ramzswap).

[1] ramzswap: http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/blkdev.h |    1 +
 mm/swapfile.c          |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 784a919..14b95a3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1295,6 +1295,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..0c373bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -574,6 +574,7 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 
 	/* free if no reference */
 	if (!usage) {
+		struct gendisk *disk = p->bdev->bd_disk;
 		if (offset < p->lowest_bit)
 			p->lowest_bit = offset;
 		if (offset > p->highest_bit)
@@ -583,6 +584,8 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (disk->fops->swap_slot_free_notify)
+			disk->fops->swap_slot_free_notify(p->bdev, offset);
 	}
 
 	return usage;
-- 
1.6.2.5

