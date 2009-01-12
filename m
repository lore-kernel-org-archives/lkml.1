Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZALKOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZALKOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZALKNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:13:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:46012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZALKNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:13:50 -0500
Date: Mon, 12 Jan 2009 10:16:01 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] async: fix __lowest_in_progress()
Message-ID: <20090112101601.7cec05d5@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24bafdeb8a42e2e43a1928ca72159e6ff90cfe85 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 11 Jan 2009 15:35:01 +0000
Subject: [PATCH] async: fix __lowest_in_progress()

At 37000 feet somewhere near Greenland I woke up from a half-sleep with the 
realisation that __lowest_in_progress() is buggy. After landing I checked 
and there were indeed 2 problems with it; this patch fixes both:
* The order of the list checks was wrong
* The locking was not correct.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/async.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index f286e9f..608b32b 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -90,12 +90,12 @@ extern int initcall_debug;
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
-	if (!list_empty(&async_pending)) {
-		entry = list_first_entry(&async_pending,
+	if (!list_empty(running)) {
+		entry = list_first_entry(running,
 			struct async_entry, list);
 		return entry->cookie;
-	} else if (!list_empty(running)) {
-		entry = list_first_entry(running,
+	} else if (!list_empty(&async_pending)) {
+		entry = list_first_entry(&async_pending,
 			struct async_entry, list);
 		return entry->cookie;
 	} else {
@@ -104,6 +104,17 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
 	}
 
 }
+
+static async_cookie_t  lowest_in_progress(struct list_head *running)
+{
+	unsigned long flags;
+	async_cookie_t ret;
+
+	spin_lock_irqsave(&async_lock, flags);
+	ret = __lowest_in_progress(running);
+	spin_unlock_irqrestore(&async_lock, flags);
+	return ret;
+}
 /*
  * pick the first pending entry and run it
  */
@@ -229,7 +240,7 @@ void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *r
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, __lowest_in_progress(running) >= cookie);
+	wait_event(async_done, lowest_in_progress(running) >= cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
