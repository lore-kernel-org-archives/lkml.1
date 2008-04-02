Return-Path: <linux-kernel-owner+w=401wt.eu-S1760373AbYDBSiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373AbYDBSiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbYDBSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:40 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38408 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756769AbYDBSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 24] xen: add missing definitions for xen grant table
	which ia64/xen needs
X-Mercurial-Node: 386b9057e627373ad9ef64e8a298907a61e4c7f4
Message-Id: <386b9057e627373ad9ef.1207158832@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Add xen handles realted definitions for grant table which ia64/xen
needs.
Pointer argumsnts for ia64/xen hypercall are passed in pseudo physical
address (guest physical address) so that it is required to convert
guest kernel virtual address into pseudo physical address right before
issuing hypercall.
The xen guest handle represents such arguments.
Define necessary handles and helper functions.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/grant-table.c           |    2 +-
 include/asm-x86/xen/interface.h     |   24 ++++++++++++++++++++++++
 include/xen/interface/grant_table.h |   12 ++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -466,7 +466,7 @@
 
 	setup.dom        = DOMID_SELF;
 	setup.nr_frames  = nr_gframes;
-	setup.frame_list = frames;
+	set_xen_guest_handle(setup.frame_list, frames);
 
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_setup_table, &setup, 1);
 	if (rc == -ENOSYS) {
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -21,6 +21,30 @@
 	__DEFINE_GUEST_HANDLE(name, struct name)
 #define DEFINE_GUEST_HANDLE(name) __DEFINE_GUEST_HANDLE(name, name)
 #define GUEST_HANDLE(name)        __guest_handle_ ## name
+
+#ifdef __XEN__
+#if defined(__i386__)
+#define set_xen_guest_handle(hnd, val)			\
+	do {						\
+		if (sizeof(hnd) == 8)			\
+			*(uint64_t *)&(hnd) = 0;	\
+		(hnd).p = val;				\
+	} while (0)
+#elif defined(__x86_64__)
+#define set_xen_guest_handle(hnd, val)	do { (hnd).p = val; } while (0)
+#endif
+#else
+#if defined(__i386__)
+#define set_xen_guest_handle(hnd, val)			\
+	do {						\
+		if (sizeof(hnd) == 8)			\
+			*(uint64_t *)&(hnd) = 0;	\
+		(hnd) = val;				\
+	} while (0)
+#elif defined(__x86_64__)
+#define set_xen_guest_handle(hnd, val)	do { (hnd) = val; } while (0)
+#endif
+#endif
 
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -185,6 +185,7 @@
     grant_handle_t handle;
     uint64_t dev_bus_addr;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_map_grant_ref);
 
 /*
  * GNTTABOP_unmap_grant_ref: Destroy one or more grant-reference mappings
@@ -206,6 +207,7 @@
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_grant_ref);
 
 /*
  * GNTTABOP_setup_table: Set up a grant table for <dom> comprising at least
@@ -223,8 +225,9 @@
     uint32_t nr_frames;
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
-    ulong *frame_list;
+    GUEST_HANDLE(ulong) frame_list;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_setup_table);
 
 /*
  * GNTTABOP_dump_table: Dump the contents of the grant table to the
@@ -237,6 +240,7 @@
     /* OUT parameters. */
     int16_t status;               /* GNTST_* */
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
 
 /*
  * GNTTABOP_transfer_grant_ref: Transfer <frame> to a foreign domain. The
@@ -255,7 +259,7 @@
     /* OUT parameters. */
     int16_t       status;
 };
-
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_transfer);
 
 /*
  * GNTTABOP_copy: Hypervisor based copy
@@ -296,6 +300,7 @@
 	/* OUT parameters. */
 	int16_t       status;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_copy);
 
 /*
  * GNTTABOP_query_size: Query the current and maximum sizes of the shared
@@ -313,7 +318,7 @@
     uint32_t max_nr_frames;
     int16_t  status;              /* GNTST_* */
 };
-
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_query_size);
 
 /*
  * Bitfield values for update_pin_status.flags.


