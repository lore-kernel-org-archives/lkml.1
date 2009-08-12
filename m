Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZHLOh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZHLOh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZHLOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:37:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:27467 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZHLOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:37:58 -0400
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
Date: Wed, 12 Aug 2009 20:07:43 +0530
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-217.2.3.fc11.x86_64; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] swap: send callback when swap slot is freed
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122007.43522.ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we have "swap discard" mechanism which sends a discard bio request
when we find a free cluster during scan_swap_map(). This callback can come a
long time after swap slots are actually freed.

This delay in callback is a great problem when (compressed) RAM [1] is used
as a swap device. So, this change adds a callback which is called as
soon as a swap slot becomes free. For above mentioned case of swapping
over compressed RAM device, this is very useful since we can immediately
free memory allocated for this swap page.

This callback does not replace swap discard support. It is called with
swap_lock held, so it is meant to trigger action that finishes quickly.
However, swap discard is an I/O request and can be used for taking longer
actions.

Links:
[1] http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

 include/linux/swap.h |    5 +++++
 mm/swapfile.c        |   16 ++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7c15334..4cbe3c4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/blkdev.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -20,6 +21,8 @@ struct bio;
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0
 
+typedef void (swap_free_notify_fn) (struct block_device *, unsigned long);
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
@@ -155,6 +158,7 @@ struct swap_info_struct {
 	unsigned int max;
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
+	swap_free_notify_fn *swap_free_notify_fn;
 };
 
 struct swap_list_t {
@@ -295,6 +299,7 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
+extern void set_swap_free_notify(unsigned, swap_free_notify_fn *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8ffdc0d..aa95fc7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -552,6 +552,20 @@ out:
 	return NULL;
 }
 
+/*
+ * Sets callback for event when swap_map[offset] == 0
+ * i.e. page at this swap offset is no longer used.
+ */
+void set_swap_free_notify(unsigned type, swap_free_notify_fn *notify_fn)
+{
+	struct swap_info_struct *sis;
+	sis = get_swap_info_struct(type);
+	BUG_ON(!sis);
+	sis->swap_free_notify_fn = notify_fn;
+	return;
+}
+EXPORT_SYMBOL(set_swap_free_notify);
+
 static int swap_entry_free(struct swap_info_struct *p,
 			   swp_entry_t ent, int cache)
 {
@@ -583,6 +597,8 @@ static int swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		if (p->swap_free_notify_fn)
+			p->swap_free_notify_fn(p->bdev, offset);
 	}
 	if (!swap_count(count))
 		mem_cgroup_uncharge_swap(ent);
