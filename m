Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0CEKXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:23:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65017 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0CEKXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:23:13 -0500
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:53:12 +0530
Message-ID: <d760cf2d1003050223v794fd20bwf6b05595b139a4fc@mail.gmail.com>
Subject: [PATCH 1/3] Send callback when a swap slot is freed
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback is required when RAM based devices are used as swap disks.
One such device is ramzswap[1] which is used as compressed in-memory swap
disk.  For such devices, we need a callback as soon as a swap slot is no
longer used to allow freeing memory allocated for this slot.  Without this
callback, stale data can quickly accumulate in memory defeating the whole
purpose of such devices.

Another user of this callback will be "preswap" as introduced by
"Transcendent Memory" patches: http://lwn.net/Articles/367286/

(I intend to integrade preswap with ramzswap).

[1] ramzswap: http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/swap.h |    4 ++++
 mm/swapfile.c        |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a2602a8..77ced03 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -20,6 +20,8 @@ struct bio;
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0

+typedef void (swap_free_notify_fn)(struct file *, unsigned long);
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
@@ -182,6 +184,7 @@ struct swap_info_struct {
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
+	swap_free_notify_fn *swap_free_notify_fn;
 };

 struct swap_list_t {
@@ -329,6 +332,7 @@ extern sector_t map_swap_page(struct page *,
struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
+extern void set_swap_free_notify(int, swap_free_notify_fn *);
 struct backing_dev_info;

 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..82f5a50 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -536,6 +536,23 @@ out:
 	return NULL;
 }

+/*
+ * Sets callback for event when swap_map[offset] == 0
+ * i.e. page at this swap offset is no longer used.
+ */
+void set_swap_free_notify(int type, swap_free_notify_fn *notify_fn)
+{
+	struct swap_info_struct *sis;
+
+	spin_lock(&swap_lock);
+	sis = swap_info[type];
+	sis->swap_free_notify_fn = notify_fn;
+	spin_unlock(&swap_lock);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(set_swap_free_notify);
+
 static unsigned char swap_entry_free(struct swap_info_struct *p,
 				     swp_entry_t entry, unsigned char usage)
 {
@@ -583,6 +600,8 @@ static unsigned char swap_entry_free(struct
swap_info_struct *p,
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (p->swap_free_notify_fn)
+			p->swap_free_notify_fn(p->swap_file, offset);
 	}

 	return usage;
-- 
1.6.2.5
