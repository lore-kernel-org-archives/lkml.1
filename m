Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0CEKYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:24:17 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:53927 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0CEKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:24:15 -0500
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:54:14 +0530
Message-ID: <d760cf2d1003050224g2d66001aude0f1af21b91e38@mail.gmail.com>
Subject: [PATCH 2/3] Add notifiers for swapon and swapoff events
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

This is required for ramzswap module which implements RAM based block
devices to be used as swap disks. These devices require a notification
on these events to function properly.

Currently, I'm not sure if any of these event notifiers have any other
users. However, adding ramzswap specific hooks instead of this generic
approach resulted in a bad/hacky code.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/swap.h |   12 ++++++++-
 mm/swapfile.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 77ced03..1791377 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -12,8 +12,6 @@
 #include <asm/atomic.h>
 #include <asm/page.h>

-struct notifier_block;
-
 struct bio;

 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
@@ -152,6 +150,11 @@ enum {
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };

+enum swap_event {
+	SWAP_EVENT_SWAPON,
+	SWAP_EVENT_SWAPOFF,
+};
+
 #define SWAP_CLUSTER_MAX 32

 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
@@ -182,6 +185,7 @@ struct swap_info_struct {
 	struct swap_extent *curr_swap_extent;
 	struct swap_extent first_swap_extent;
 	struct block_device *bdev;	/* swap device or bdev of swap file */
+	struct atomic_notifier_head slot_free_notify_list;
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
 	swap_free_notify_fn *swap_free_notify_fn;
@@ -333,6 +337,10 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 extern void set_swap_free_notify(int, swap_free_notify_fn *);
+extern int register_swap_event_notifier(struct notifier_block *nb,
+			enum swap_event event, unsigned long val);
+extern int unregister_swap_event_notifier(struct notifier_block *nb,
+			enum swap_event event, unsigned long val);
 struct backing_dev_info;

 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 82f5a50..7b34945 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,6 +57,8 @@ static struct swap_list_t swap_list = {-1, -1};
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];

 static DEFINE_MUTEX(swapon_mutex);
+static BLOCKING_NOTIFIER_HEAD(swapon_notify_list);
+static BLOCKING_NOTIFIER_HEAD(swapoff_notify_list);

 static inline unsigned char swap_count(unsigned char ent)
 {
@@ -1628,6 +1630,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	p->flags = 0;
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapoff_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
 	/* Destroy swap account informatin */
@@ -2042,6 +2045,7 @@ SYSCALL_DEFINE2(swapon, const char __user *,
specialfile, int, swap_flags)
 	else
 		swap_info[prev]->next = type;
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapon_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
 	goto out;
@@ -2465,3 +2469,58 @@ static void
free_swap_count_continuations(struct swap_info_struct *si)
 		}
 	}
 }
+
+static struct blocking_notifier_head *
+swap_get_notifier_head(enum swap_event event)
+{
+	struct blocking_notifier_head *nh;
+
+	switch (event) {
+	case SWAP_EVENT_SWAPON:
+		nh = &swapon_notify_list;
+		break;
+
+	case SWAP_EVENT_SWAPOFF:
+		nh = &swapoff_notify_list;
+		break;
+
+	default:
+		pr_err("Invalid swap event: %d\n", event);
+		nh = NULL;
+	};
+
+	return nh;
+}
+
+int register_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event, unsigned long val)
+{
+	int ret;
+	struct blocking_notifier_head *nh;
+
+	nh = swap_get_notifier_head(event);
+	if (nh)
+		ret = blocking_notifier_chain_register(nh, nb);
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_swap_event_notifier);
+
+int unregister_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event, unsigned long val)
+{
+	int ret;
+	struct blocking_notifier_head *nh;
+
+	nh = swap_get_notifier_head(event);
+	if (nh)
+		ret = blocking_notifier_chain_unregister(nh, nb);
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_swap_event_notifier);
+
-- 
1.6.2.5
