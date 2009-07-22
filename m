Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZGVKNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZGVKNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZGVKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:13:34 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:40236 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbZGVKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:51 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [RFC v17][PATCH 11/60] pids 1/7: Factor out code to allocate pidmap page
Date: Wed, 22 Jul 2009 05:59:33 -0400
Message-Id: <1248256822-23416-12-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

To implement support for clone_with_pids() system call we would
need to allocate pidmap page in more than one place. Move this
code to a new function alloc_pidmap_page().

Changelog[v2]:
	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
	  -ENOMEM on error instead of -1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/pid.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 31310b5..f618096 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,9 +122,34 @@ static void free_pidmap(struct upid *upid)
 	atomic_inc(&map->nr_free);
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	void *page;
+
+	if (likely(map->page))
+		return 0;
+
+	page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	/*
+	 * Free the page if someone raced with us installing it:
+	 */
+	spin_lock_irq(&pidmap_lock);
+	if (map->page)
+		kfree(page);
+	else
+		map->page = page;
+	spin_unlock_irq(&pidmap_lock);
+
+	if (unlikely(!map->page))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, rc, offset, max_scan, pid, last = pid_ns->last_pid;
 	struct pidmap *map;
 
 	pid = last + 1;
@@ -134,21 +159,10 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (map->page)
-				kfree(page);
-			else
-				map->page = page;
-			spin_unlock_irq(&pidmap_lock);
-			if (unlikely(!map->page))
-				break;
-		}
+		rc = alloc_pidmap_page(map);
+		if (rc)
+			break;
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
-- 
1.6.0.4

