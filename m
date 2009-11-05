Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZKEFgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZKEFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZKEFgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:36:00 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48705 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZKEFf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:35:59 -0500
Date: Wed, 4 Nov 2009 21:36:55 -0800
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com
Subject: [v11][PATCH 1/9] Factor out code to allocate pidmap page
Message-ID: <20091105053655.GA16142@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105053053.GA11289@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [v11][PATCH 1/9] Factor out code to allocate pidmap page

To simplify alloc_pidmap(), move code to allocate a pid map page to a
separate function.

Changelog[v3]:
	- Earlier version of patchset called alloc_pidmap_page() from two
	  places. But now its called from only one place. Even so, moving
	  this code out into a separate function simplifies alloc_pidmap().
Changelog[v2]:
	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
	  -ENOMEM on error instead of -1.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/pid.c |   45 ++++++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..7d4bb6e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,9 +122,35 @@ static void free_pidmap(struct upid *upid)
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
@@ -134,21 +160,10 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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

