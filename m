Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZIGVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZIGVJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZIGVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:09:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53340 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZIGVJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:09:31 -0400
Date: Mon, 7 Sep 2009 14:13:58 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: [RFC][v5][PATCH 1/8]: Factor out code to allocate pidmap page
Message-ID: <20090907211358.GA6685@us.ibm.com>
References: <20090907211302.GA5892@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907211302.GA5892@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v5][PATCH 1/8]: Factor out code to allocate pidmap page

To simplify alloc_pidmap(), move code to allocate a pid map page to a
separate function.

Changelog[v3]:
	- Earlier version of patchset called alloc_pidmap_page() from two
	  places. But now its called from only one place. Even so, moving
	  this code out into a separate function simplifies alloc_pidmap().
Changelog[v2]:
	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
	  -ENOMEM on error instead of -1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/pid.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-07 13:08:50.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-07 13:11:30.000000000 -0700
@@ -122,9 +122,35 @@
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
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int rc;
 	struct pidmap *map;
 
 	pid = last + 1;
@@ -134,21 +160,10 @@
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
