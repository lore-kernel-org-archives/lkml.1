Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbZEMDUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbZEMDUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbZEMDRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:17:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:46777 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760040AbZEMDRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:17:38 -0400
Date: Wed, 13 May 2009 12:17:39 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Matthew Wilcox <willy@linux.intel.com>, tony.luck@intel.com
Subject: Re: [Xen-devel] [PATCH 03/10] Xen: Rename the balloon lock
Message-ID: <20090513031739.GG22497%yamahata@valinux.co.jp>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org> <1242164891-3859-4-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242164891-3859-4-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 02:48:04PM -0700, Jeremy Fitzhardinge wrote:
> From: Alex Nixon <alex.nixon@citrix.com>
> 
> * xen_create_contiguous_region needs access to the balloon lock to
>   ensure memory doesn't change under its feet, so expose the balloon
>   lock
> * Change the name of the lock to xen_reservation_lock, to imply it's
>   now less-specific usage.
> 
> [Impact: cleanup ]
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/mmu.c             |    7 +++++++
>  drivers/xen/balloon.c          |   15 ++++-----------
>  include/xen/interface/memory.h |    8 ++++++++
>  3 files changed, 19 insertions(+), 11 deletions(-)


Are you suggesting that ia64/xen should define its own
xen_reservation_lock?
Then, can you replace the patch with the following one?

The difference from the original is only the hunk in
arch/ia64/xen/hypervisor.c.
Although it is easy to fix it by ia64 specific patch, I prefer
not to break from the first place.

thanks,

--

From: Alex Nixon <alex.nixon@citrix.com>

* xen_create_contiguous_region needs access to the balloon lock to
  ensure memory doesn't change under its feet, so expose the balloon
  lock
* Change the name of the lock to xen_reservation_lock, to imply it's
  now less-specific usage.

[Impact: cleanup ]
Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/ia64/xen/hypervisor.c     |    7 +++++++
 arch/x86/xen/mmu.c             |    7 +++++++
 drivers/xen/balloon.c          |   15 ++++-----------
 include/xen/interface/memory.h |    8 ++++++++
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/xen/hypervisor.c b/arch/ia64/xen/hypervisor.c
index cac4d97..481fbae 100644
--- a/arch/ia64/xen/hypervisor.c
+++ b/arch/ia64/xen/hypervisor.c
@@ -39,6 +39,13 @@ EXPORT_SYMBOL(xen_domain_type);
 
 EXPORT_SYMBOL(__hypercall);
 
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+DEFINE_SPINLOCK(xen_reservation_lock);
+
 /* Stolen from arch/x86/xen/enlighten.c */
 /*
  * Flag to determine whether vcpu info placement is available on all
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e25a78e..360e546 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -65,6 +65,13 @@
 
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
index af36ead..29c2f58 100644
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
@@ -142,4 +144,10 @@ struct xen_translate_gpfn_list {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
+/*
+ * Prevent the balloon driver from changing the memory reservation
+ * during a driver critical region.
+ */
+extern spinlock_t xen_reservation_lock;
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.6.0.2




-- 
yamahata
