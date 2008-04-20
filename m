Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYDTKmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYDTKmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbYDTKkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56266 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbYDTKkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/36] driver core: memory: semaphore to mutex
Date: Sun, 20 Apr 2008 03:45:38 -0700
Message-Id: <1208688366-9252-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c  |    7 ++++---
 include/linux/memory.h |    5 ++---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7ae413f..1f3801a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -20,6 +20,7 @@
 #include <linux/kobject.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
@@ -205,7 +206,7 @@ static int memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
-	down(&mem->state_sem);
+	mutex_lock(&mem->state_mutex);
 
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
@@ -217,7 +218,7 @@ static int memory_block_change_state(struct memory_block *mem,
 		mem->state = to_state;
 
 out:
-	up(&mem->state_sem);
+	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
@@ -341,7 +342,7 @@ static int add_memory_block(unsigned long node_id, struct mem_section *section,
 
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
-	init_MUTEX(&mem->state_sem);
+	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
 	ret = register_memory(mem, section, NULL);
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 33f0ff0..f80e0e3 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
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
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7469c50..0fb3302 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -208,7 +208,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
-	 * memory_block->state_sem.
+	 * memory_block->state_mutex.
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
-- 
1.5.4.5

