Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXLPSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXLPSbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXLPSbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:31:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31328 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbXLPSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:31:23 -0500
Message-Id: <20071216181740.985565217@mvista.com>
References: <20071216181736.609241472@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 00:00:02 -0800
Subject: [PATCH 2/2] [RESEND] driver base: memory: semaphore to mutex
References: <20071216181705.714358296@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=base-memory-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/base/memory.c  |    7 ++++---
 include/linux/memory.h |    5 ++---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.23/drivers/base/memory.c
===================================================================
--- linux-2.6.23.orig/drivers/base/memory.c
+++ linux-2.6.23/drivers/base/memory.c
@@ -20,6 +20,7 @@
 #include <linux/kobject.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
@@ -220,7 +221,7 @@ static int memory_block_change_state(str
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
-	down(&mem->state_sem);
+	mutex_lock(&mem->state_mutex);
 
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
@@ -232,7 +233,7 @@ static int memory_block_change_state(str
 		mem->state = to_state;
 
 out:
-	up(&mem->state_sem);
+	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
@@ -357,7 +358,7 @@ static int add_memory_block(unsigned lon
 
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
-	init_MUTEX(&mem->state_sem);
+	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
 	ret = register_memory(mem, section, NULL);
Index: linux-2.6.23/include/linux/memory.h
===================================================================
--- linux-2.6.23.orig/include/linux/memory.h
+++ linux-2.6.23/include/linux/memory.h
@@ -18,8 +18,7 @@
 #include <linux/sysdev.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
-
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 struct memory_block {
 	unsigned long phys_index;
@@ -30,7 +29,7 @@ struct memory_block {
 	 * created long after the critical areas during
 	 * initialization.
 	 */
-	struct semaphore state_sem;
+	struct mutex state_mutex;
 	int phys_device;		/* to which fru does this belong? */
 	void *hw;			/* optional pointer to fw/hw data */
 	int (*phys_callback)(struct memory_block *);
Index: linux-2.6.23/mm/memory_hotplug.c
===================================================================
--- linux-2.6.23.orig/mm/memory_hotplug.c
+++ linux-2.6.23/mm/memory_hotplug.c
@@ -209,7 +209,7 @@ int online_pages(unsigned long pfn, unsi
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
-	 * memory_block->state_sem.
+	 * memory_block->state_mutex.
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 	pgdat_resize_lock(zone->zone_pgdat, &flags);

-- 
