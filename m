Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXJ0LvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXJ0LvC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXJ0Luy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:50:54 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56130 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXJ0Lux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:50:53 -0400
Date: Sat, 27 Oct 2007 13:50:47 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071027114508.4218.29756.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] kernel: Convert to generic boolean-functions
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>

---

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6cd8c44..70f4dc9 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -175,7 +175,7 @@ extern void relay_subbufs_consumed(struct rchan *chan,
 				   unsigned int cpu,
 				   size_t consumed);
 extern void relay_reset(struct rchan *chan);
-extern int relay_buf_full(struct rchan_buf *buf);
+extern bool relay_buf_full(struct rchan_buf *buf);
 
 extern size_t relay_switch_subbuf(struct rchan_buf *buf,
 				  size_t length);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 917aba1..1c36103 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -357,16 +357,16 @@ static int save_image(struct swap_map_handle *handle,
 /**
  *	enough_swap - Make sure we have enough swap to save the image.
  *
- *	Returns TRUE or FALSE after checking the total amount of swap
+ *	Returns 'true' or 'false' after checking the total amount of swap
  *	space avaiable from the resume partition.
  */
 
-static int enough_swap(unsigned int nr_pages)
+static bool enough_swap(unsigned int nr_pages)
 {
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
 	pr_debug("swsusp: free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	return free_swap > (nr_pages + PAGES_FOR_IO);
 }
 
 /**
diff --git a/kernel/profile.c b/kernel/profile.c
index 631b75c..fca98ba 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -125,11 +125,11 @@ void profile_task_exit(struct task_struct * task)
 	blocking_notifier_call_chain(&task_exit_notifier, 0, task);
 }
  
-int profile_handoff_task(struct task_struct * task)
+bool profile_handoff_task(struct task_struct * task)
 {
 	int ret;
 	ret = atomic_notifier_call_chain(&task_free_notifier, 0, task);
-	return (ret == NOTIFY_OK) ? 1 : 0;
+	return ret == NOTIFY_OK;
 }
 
 void profile_munmap(unsigned long addr)
diff --git a/kernel/relay.c b/kernel/relay.c
index 61134eb..d0f940e 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -221,23 +221,23 @@ static void relay_remove_buf(struct kref *kref)
  *	relay_buf_empty - boolean, is the channel buffer empty?
  *	@buf: channel buffer
  *
- *	Returns 1 if the buffer is empty, 0 otherwise.
+ *	Returns 'true' if the buffer is empty, 'false' otherwise.
  */
-static int relay_buf_empty(struct rchan_buf *buf)
+static bool relay_buf_empty(struct rchan_buf *buf)
 {
-	return (buf->subbufs_produced - buf->subbufs_consumed) ? 0 : 1;
+	return (buf->subbufs_produced - buf->subbufs_consumed) == 0;
 }
 
 /**
  *	relay_buf_full - boolean, is the channel buffer full?
  *	@buf: channel buffer
  *
- *	Returns 1 if the buffer is full, 0 otherwise.
+ *	Returns 'true' if the buffer is full, 'false' otherwise.
  */
-int relay_buf_full(struct rchan_buf *buf)
+bool relay_buf_full(struct rchan_buf *buf)
 {
 	size_t ready = buf->subbufs_produced - buf->subbufs_consumed;
-	return (ready >= buf->chan->n_subbufs) ? 1 : 0;
+	return ready >= buf->chan->n_subbufs;
 }
 EXPORT_SYMBOL_GPL(relay_buf_full);
 
