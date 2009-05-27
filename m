Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbZE0HZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbZE0HZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbZE0HYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:24:50 -0400
Received: from claw.goop.org ([74.207.240.146]:33539 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762047AbZE0HYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:24:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/10] Xen: Rename the balloon lock
Date: Wed, 27 May 2009 00:24:35 -0700
Message-Id: <1243409082-21349-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

* xen_create_contiguous_region needs access to the balloon lock to
  ensure memory doesn't change under its feet, so expose the balloon
  lock
* Change the name of the lock to xen_reservation_lock, to imply it's
  now less-specific usage.

[ Impact: cleanup ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c             |    7 +++++++
 drivers/xen/balloon.c          |   15 ++++-----------
 include/xen/interface/memory.h |    8 ++++++++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 370e1b8..9cee943 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -67,6 +67,13 @@
 
 #define MMU_UPDATE_HISTO	30
 
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+DEFINE_SPINLOCK(xen_reservation_lock);
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct {
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..46a8b39 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -84,13 +84,6 @@ static struct sys_device balloon_sysdev;
 
 static int register_balloon(struct sys_device *sysdev);
 
-/*
- * Protects atomic reservation decrease/increase against concurrent increases.
- * Also protects non-atomic updates of current_pages and driver_pages, and
- * balloon lists.
- */
-static DEFINE_SPINLOCK(balloon_lock);
-
 static struct balloon_stats balloon_stats;
 
 /* We increase/decrease in batches which fit in a page */
@@ -209,7 +202,7 @@ static int increase_reservation(unsigned long nr_pages)
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
@@ -267,7 +260,7 @@ static int increase_reservation(unsigned long nr_pages)
 	totalram_pages = balloon_stats.current_pages;
 
  out:
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return 0;
 }
@@ -312,7 +305,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	kmap_flush_unused();
 	flush_tlb_all();
 
-	spin_lock_irqsave(&balloon_lock, flags);
+	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	/* No more mappings: invalidate P2M and add to balloon. */
 	for (i = 0; i < nr_pages; i++) {
@@ -329,7 +322,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	balloon_stats.current_pages -= nr_pages;
 	totalram_pages = balloon_stats.current_pages;
 
-	spin_unlock_irqrestore(&balloon_lock, flags);
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
 	return need_sleep;
 }
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index f548f7c..9ddf473 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -9,6 +9,8 @@
 #ifndef __XEN_PUBLIC_MEMORY_H__
 #define __XEN_PUBLIC_MEMORY_H__
 
+#include <linux/spinlock.h>
+
 /*
  * Increase or decrease the specified domain's memory reservation. Returns a
  * -ve errcode on failure, or the # extents successfully allocated or freed.
@@ -184,4 +186,10 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
  */
 #define XENMEM_machine_memory_map   10
 
+/*
+ * Prevent the balloon driver from changing the memory reservation
+ * during a driver critical region.
+ */
+extern spinlock_t xen_reservation_lock;
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.6.0.6

