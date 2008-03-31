Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYCaKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYCaKLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYCaKLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:11:36 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48868 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754534AbYCaKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:11:35 -0400
Date: Mon, 31 Mar 2008 19:11:34 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 10/12] xen: replace callers of alloc_vm_area()/free_vm_area() with xen_ prefixed one.
Message-ID: <20080331101134.GJ17609%yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp> <1206704418191-git-send-email-yamahata@valinux.co.jp> <47ED55BB.6050101@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED55BB.6050101@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:31:55PM -0700, Jeremy Fitzhardinge wrote:
> This change looks fine overall, but asm/xen/hypervisor.h seems to be 
> turning into a bit of a dumping-ground.  I wonder if we can't come up 
> with a better-named header...

How about include/asm/xen/grant_table.h?
xen_{alloc, free}_vm_area() are used for allocate/free grant table
mappable area. So they are grant table related operations.

changes from the previsous one:
- move the declarations from asm/xen/hypervisor.h into
  asm/xen/grant_table.h

>From 4c36bb857fda0f4ddaad5ccf07da83d2e15881f5 Mon Sep 17 00:00:00 2001
From: Isaku Yamahata <yamahata@valinux.co.jp>
Date: Mon, 31 Mar 2008 19:03:43 -0700
Subject: [PATCH 010/113] xen: replace callers of alloc_vm_area()/free_vm_area() with xen_ prefixed one.

Don't use alloc_vm_area()/free_vm_area() directly, instead define
xen_alloc_vm_area()/xen_free_vm_area() and use them.

alloc_vm_area()/free_vm_area() are used to allocate/free area which
are for grant table mapping. Xen/x86 grant table is based on virtual
address so that alloc_vm_area()/free_vm_area() are suitable.
On the other hand Xen/ia64 (and Xen/powerpc) grant table is based on
pseudo physical address (guest physical address) so that allocation
should be done differently.
The original version of xenified Linux/IA64 have its own
allocate_vm_area()/free_vm_area() definitions which don't allocate vm area
contradictory to those names.
Now vanilla Linux already has its definitions so that it's impossible
to have IA64 definitions of allocate_vm_area()/free_vm_area().
Instead introduce xen_allocate_vm_area()/xen_free_vm_area() and use them.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/grant-table.c          |    2 +-
 drivers/xen/xenbus/xenbus_client.c |    6 +++---
 include/asm-x86/xen/grant_table.h  |    7 +++++++
 include/xen/grant_table.h          |    1 +
 4 files changed, 12 insertions(+), 4 deletions(-)
 create mode 100644 include/asm-x86/xen/grant_table.h

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 95016fd..9fcde20 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -478,7 +478,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	if (shared == NULL) {
 		struct vm_struct *area;
-		area = alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
+		area = xen_alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
 		BUG_ON(area == NULL);
 		shared = area->addr;
 	}
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 9fd2f70..0f86b0f 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -399,7 +399,7 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
 
 	*vaddr = NULL;
 
-	area = alloc_vm_area(PAGE_SIZE);
+	area = xen_alloc_vm_area(PAGE_SIZE);
 	if (!area)
 		return -ENOMEM;
 
@@ -409,7 +409,7 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
 		BUG();
 
 	if (op.status != GNTST_okay) {
-		free_vm_area(area);
+		xen_free_vm_area(area);
 		xenbus_dev_fatal(dev, op.status,
 				 "mapping in shared page %d from domain %d",
 				 gnt_ref, dev->otherend_id);
@@ -508,7 +508,7 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
 		BUG();
 
 	if (op.status == GNTST_okay)
-		free_vm_area(area);
+		xen_free_vm_area(area);
 	else
 		xenbus_dev_error(dev, op.status,
 				 "unmapping page at handle %d error %d",
diff --git a/include/asm-x86/xen/grant_table.h b/include/asm-x86/xen/grant_table.h
new file mode 100644
index 0000000..2444d45
--- /dev/null
+++ b/include/asm-x86/xen/grant_table.h
@@ -0,0 +1,7 @@
+#ifndef __XEN_GRANT_TABLE_H
+#define __XEN_GRANT_TABLE_H
+
+#define xen_alloc_vm_area(size)	alloc_vm_area(size)
+#define xen_free_vm_area(area)	free_vm_area(area)
+
+#endif /* __XEN_GRANT_TABLE_H */
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 761c834..d282292 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -39,6 +39,7 @@
 
 #include <asm/xen/hypervisor.h>
 #include <xen/interface/grant_table.h>
+#include <asm/xen/grant_table.h>
 
 /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
 #define NR_GRANT_FRAMES 4
-- 
1.5.3

-- 
yamahata
