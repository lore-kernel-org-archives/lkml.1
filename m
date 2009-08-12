Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbZHLMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbZHLMr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZHLMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:47:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:22988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZHLMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:47:57 -0400
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
To: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: [RFC][PATCH] swap: send callback when swap slot is freed
Date: Wed, 12 Aug 2009 18:17:48 +0530
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-217.2.3.fc11.x86_64; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908121817.48501.ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Re-sending since I didn't get any reply last time)

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

This patch is simply a quick hack but it works (tested on x86 and x64).
Can anyone please suggest a cleaner and proper way to do this? Any
feedback would be really helpful. Thanks.


Links:
[1] http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

 include/linux/swap.h |   14 ++++++++++++++
 init/Kconfig         |    9 +++++++++
 mm/swapfile.c        |   20 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7c15334..483d0b9 100644
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
@@ -155,6 +158,9 @@ struct swap_info_struct {
 	unsigned int max;
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
+#ifdef CONFIG_SWAP_FREE_NOTIFY
+	swap_free_notify_fn *swap_free_notify_fn;
+#endif
 };
 
 struct swap_list_t {
@@ -297,6 +303,14 @@ extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
+#ifdef CONFIG_SWAP_FREE_NOTIFY
+extern void set_swap_free_notify(unsigned, swap_free_notify_fn *);
+#else
+void set_swap_free_notify(unsigned, swap_free_notify_fn *)
+{
+}
+#endif
+
 /* linux/mm/thrash.c */
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
diff --git a/init/Kconfig b/init/Kconfig
index 3f7e609..b0112c6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -176,6 +176,15 @@ config SWAP
 	  used to provide more virtual memory than the actual RAM present
 	  in your computer.  If unsure say Y.
 
+config SWAP_FREE_NOTIFY
+	bool "Enable swap free notification"
+	depends on SWAP
+	default y
+	help
+	  This causes swap subsystem to send a callback to swap device when
+	  a swap block becomes free. This is useful in cases such as when
+	  compressed RAM device is used as swap disk.
+
 config SYSVIPC
 	bool "System V IPC"
 	---help---
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8ffdc0d..25bacfd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -552,6 +552,22 @@ out:
 	return NULL;
 }
 
+#ifdef CONFIG_SWAP_FREE_NOTIFY
+/*
+ * Sets callback for event when swap_map[offset] == 0
+ * i.e. page at this swap offset is not longer used.
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
+#endif
+
 static int swap_entry_free(struct swap_info_struct *p,
 			   swp_entry_t ent, int cache)
 {
@@ -583,6 +599,10 @@ static int swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
+#ifdef CONFIG_SWAP_FREE_NOTIFY
+		if (p->swap_free_notify_fn)
+			p->swap_free_notify_fn(p->bdev, offset);
+#endif
 	}
 	if (!swap_count(count))
 		mem_cgroup_uncharge_swap(ent);

