Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbYDBSmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbYDBSmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbYDBSfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:52 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38417 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757394AbYDBSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 24] xen: replace callers of
	alloc_vm_area()/free_vm_area() with xen_ prefixed one
X-Mercurial-Node: 38e0bd91b3522ddb9c536920bf32f020ac6c3d14
Message-Id: <38e0bd91b3522ddb9c53.1207158839@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

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
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/grant-table.c          |    2 +-
 drivers/xen/xenbus/xenbus_client.c |    6 +++---
 include/asm-x86/xen/grant_table.h  |    7 +++++++
 include/xen/grant_table.h          |    3 +--
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -478,7 +478,7 @@
 
 	if (shared == NULL) {
 		struct vm_struct *area;
-		area = alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
+		area = xen_alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
 		BUG_ON(area == NULL);
 		shared = area->addr;
 	}
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -399,7 +399,7 @@
 
 	*vaddr = NULL;
 
-	area = alloc_vm_area(PAGE_SIZE);
+	area = xen_alloc_vm_area(PAGE_SIZE);
 	if (!area)
 		return -ENOMEM;
 
@@ -409,7 +409,7 @@
 		BUG();
 
 	if (op.status != GNTST_okay) {
-		free_vm_area(area);
+		xen_free_vm_area(area);
 		xenbus_dev_fatal(dev, op.status,
 				 "mapping in shared page %d from domain %d",
 				 gnt_ref, dev->otherend_id);
@@ -508,7 +508,7 @@
 		BUG();
 
 	if (op.status == GNTST_okay)
-		free_vm_area(area);
+		xen_free_vm_area(area);
 	else
 		xenbus_dev_error(dev, op.status,
 				 "unmapping page at handle %d error %d",
diff --git a/include/asm-x86/xen/grant_table.h b/include/asm-x86/xen/grant_table.h
new file mode 100644
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
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -39,6 +39,7 @@
 
 #include <asm/xen/hypervisor.h>
 #include <xen/interface/grant_table.h>
+#include <asm/xen/grant_table.h>
 
 /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
 #define NR_GRANT_FRAMES 4


