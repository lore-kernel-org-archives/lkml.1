Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLaEKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLaEKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZLaEKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:10:33 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:34137 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZLaEKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:10:32 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] [mmotm v2] Add notifiers for various swap events
Date: Thu, 31 Dec 2009 09:38:37 +0530
Message-Id: <1262232518-2841-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events:
 - Swapon
 - Swapoff
 - When a swap slot is freed

This is required for ramzswap module which implements RAM based block
devices to be used as swap disks. These devices require a notification
on these events to function properly.

Currently, I'm not sure if any of these event notifiers have any other
users. However, adding ramzswap specific hooks instead of this generic
approach resulted in a bad/hacky code with too many 'ifdef CONFIG_RAMZSWAP'
spread all over the core kernel code.

For SWAP_EVENT_SLOT_FREE, callbacks are made under swap_lock. Currently, this
is not a problem since ramzswap is the only user and the callback it registers
can be safely made under this lock. However, if this event finds more users,
we might have to work on reducing contention on this lock (per-swap lock?).

v2: added comment before swap slot free notifier call to clarify that
ramzswap is currently the only user of this notifier.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/swap.h |   13 ++++++++-
 mm/swapfile.c        |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a2602a8..43e6a96 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -12,8 +12,6 @@
 #include <asm/atomic.h>
 #include <asm/page.h>
 
-struct notifier_block;
-
 struct bio;
 
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
@@ -150,6 +148,12 @@ enum {
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
 
+enum swap_event {
+	SWAP_EVENT_SWAPON,
+	SWAP_EVENT_SWAPOFF,
+	SWAP_EVENT_SLOT_FREE,
+};
+
 #define SWAP_CLUSTER_MAX 32
 
 #define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
@@ -180,6 +184,7 @@ struct swap_info_struct {
 	struct swap_extent *curr_swap_extent;
 	struct swap_extent first_swap_extent;
 	struct block_device *bdev;	/* swap device or bdev of swap file */
+	struct atomic_notifier_head slot_free_notify_list;
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
 };
@@ -329,6 +334,10 @@ extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
+extern int register_swap_event_notifier(struct notifier_block *nb,
+			enum swap_event event, unsigned long val);
+extern int unregister_swap_event_notifier(struct notifier_block *nb,
+			enum swap_event event, unsigned long val);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c0585b..354bc9d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,6 +57,8 @@ static struct swap_list_t swap_list = {-1, -1};
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static DEFINE_MUTEX(swapon_mutex);
+static BLOCKING_NOTIFIER_HEAD(swapon_notify_list);
+static BLOCKING_NOTIFIER_HEAD(swapoff_notify_list);
 
 static inline unsigned char swap_count(unsigned char ent)
 {
@@ -583,6 +585,9 @@ static unsigned char swap_entry_free(struct swap_info_struct *p,
 			swap_list.next = p->type;
 		nr_swap_pages++;
 		p->inuse_pages--;
+		/* Currently, ramzswap is the only user of this notifier */
+		atomic_notifier_call_chain(&p->slot_free_notify_list,
+					offset, p->swap_file);
 	}
 
 	return usage;
@@ -1609,6 +1614,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	p->flags = 0;
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapoff_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	vfree(swap_map);
 	/* Destroy swap account informatin */
@@ -2022,7 +2028,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		swap_list.head = swap_list.next = type;
 	else
 		swap_info[prev]->next = type;
+	ATOMIC_INIT_NOTIFIER_HEAD(&p->slot_free_notify_list);
 	spin_unlock(&swap_lock);
+	blocking_notifier_call_chain(&swapon_notify_list, type, swap_file);
 	mutex_unlock(&swapon_mutex);
 	error = 0;
 	goto out;
@@ -2446,3 +2454,62 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
 		}
 	}
 }
+
+
+int register_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event, unsigned long val)
+{
+	switch (event) {
+	case SWAP_EVENT_SWAPON:
+		return blocking_notifier_chain_register(
+					&swapon_notify_list, nb);
+	case SWAP_EVENT_SWAPOFF:
+		return blocking_notifier_chain_register(
+					&swapoff_notify_list, nb);
+	case SWAP_EVENT_SLOT_FREE:
+		{
+		struct swap_info_struct *sis;
+
+		if (val > nr_swapfiles)
+			goto out;
+		sis = swap_info[val];
+		return atomic_notifier_chain_register(
+				&sis->slot_free_notify_list, nb);
+		}
+	default:
+		pr_err("Invalid swap event: %d\n", event);
+	};
+
+out:
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(register_swap_event_notifier);
+
+int unregister_swap_event_notifier(struct notifier_block *nb,
+				enum swap_event event, unsigned long val)
+{
+	switch (event) {
+	case SWAP_EVENT_SWAPON:
+		return blocking_notifier_chain_unregister(
+					&swapon_notify_list, nb);
+	case SWAP_EVENT_SWAPOFF:
+		return blocking_notifier_chain_unregister(
+					&swapoff_notify_list, nb);
+	case SWAP_EVENT_SLOT_FREE:
+		{
+		struct swap_info_struct *sis;
+
+		if (val > nr_swapfiles)
+			goto out;
+		sis = swap_info[val];
+		return atomic_notifier_chain_unregister(
+				&sis->slot_free_notify_list, nb);
+		}
+	default:
+		pr_err("Invalid swap event: %d\n", event);
+	};
+
+out:
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(unregister_swap_event_notifier);
-- 
1.6.2.5

