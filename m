Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZKXBjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZKXBjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZKXBju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:39:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755576AbZKXBjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:39:48 -0500
Message-Id: <20091124013954.025597000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 23 Nov 2009 19:39:42 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: [patch 5/8] x86: UV - Update XPC to handle updated BIOS interface.
References: <20091124013937.354595000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_uv_bios_changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The UV BIOS has moved the location of some of their pointers to the
"partition reserved page" from memory into a uv hub MMR.  The GRU does
not support bcopy operations from MMR space so we need to special case
the MMR addresses using VLOAD operations.

Additionally, the BIOS call for registering a message queue watchlist
has removed the 'blade' value and eliminated the structure that was
being passed in.  This is also reflected in this patch.

To: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Cc: linux-mm@vger.kernel.org

---

 arch/x86/include/asm/uv/bios.h      |   11 +----------
 arch/x86/kernel/bios_uv.c           |    8 ++------
 drivers/misc/sgi-xp/xp_uv.c         |   23 +++++++++++++++++++++++
 drivers/misc/sgi-xp/xpc_partition.c |   13 +++++++++----
 drivers/misc/sgi-xp/xpc_uv.c        |   27 +++++++++++++++------------
 5 files changed, 50 insertions(+), 32 deletions(-)


Index: pv1000000/arch/x86/include/asm/uv/bios.h
===================================================================
--- pv1000000.orig/arch/x86/include/asm/uv/bios.h	2009-11-23 18:40:44.000000000 -0600
+++ pv1000000/arch/x86/include/asm/uv/bios.h	2009-11-23 18:41:22.000000000 -0600
@@ -76,15 +76,6 @@ union partition_info_u {
 	};
 };
 
-union uv_watchlist_u {
-	u64	val;
-	struct {
-		u64	blade	: 16,
-			size	: 32,
-			filler	: 16;
-	};
-};
-
 enum uv_memprotect {
 	UV_MEMPROT_RESTRICT_ACCESS,
 	UV_MEMPROT_ALLOW_AMO,
@@ -100,7 +91,7 @@ extern s64 uv_bios_call_reentrant(enum u
 
 extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *);
 extern s64 uv_bios_freq_base(u64, u64 *);
-extern int uv_bios_mq_watchlist_alloc(int, unsigned long, unsigned int,
+extern int uv_bios_mq_watchlist_alloc(unsigned long, unsigned int,
 					unsigned long *);
 extern int uv_bios_mq_watchlist_free(int, int);
 extern s64 uv_bios_change_memprotect(u64, u64, enum uv_memprotect);
Index: pv1000000/arch/x86/kernel/bios_uv.c
===================================================================
--- pv1000000.orig/arch/x86/kernel/bios_uv.c	2009-11-23 18:40:44.000000000 -0600
+++ pv1000000/arch/x86/kernel/bios_uv.c	2009-11-23 18:41:22.000000000 -0600
@@ -101,21 +101,17 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
 }
 
 int
-uv_bios_mq_watchlist_alloc(int blade, unsigned long addr, unsigned int mq_size,
+uv_bios_mq_watchlist_alloc(unsigned long addr, unsigned int mq_size,
 			   unsigned long *intr_mmr_offset)
 {
-	union uv_watchlist_u size_blade;
 	u64 watchlist;
 	s64 ret;
 
-	size_blade.size = mq_size;
-	size_blade.blade = blade;
-
 	/*
 	 * bios returns watchlist number or negative error number.
 	 */
 	ret = (int)uv_bios_call_irqsave(UV_BIOS_WATCHLIST_ALLOC, addr,
-			size_blade.val, (u64)intr_mmr_offset,
+			mq_size, (u64)intr_mmr_offset,
 			(u64)&watchlist, 0);
 	if (ret < BIOS_STATUS_SUCCESS)
 		return ret;
Index: pv1000000/drivers/misc/sgi-xp/xp_uv.c
===================================================================
--- pv1000000.orig/drivers/misc/sgi-xp/xp_uv.c	2009-11-23 18:41:17.000000000 -0600
+++ pv1000000/drivers/misc/sgi-xp/xp_uv.c	2009-11-23 18:41:22.000000000 -0600
@@ -42,11 +42,34 @@ xp_socket_pa_uv(unsigned long gpa)
 }
 
 static enum xp_retval
+xp_remote_mmr_read(unsigned long dst_gpa, const unsigned long src_gpa,
+		   size_t len)
+{
+	int ret;
+	unsigned long *dst_va = __va(uv_gpa_to_soc_phys_ram(dst_gpa));
+
+	BUG_ON(!uv_gpa_in_mmr_space(src_gpa));
+	BUG_ON(len != 8);
+
+	ret = gru_read_gpa(dst_va, src_gpa);
+	if (ret == 0)
+		return xpSuccess;
+
+	dev_err(xp, "gru_read_gpa() failed, dst_gpa=0x%016lx src_gpa=0x%016lx "
+		"len=%ld\n", dst_gpa, src_gpa, len);
+	return xpGruCopyError;
+}
+
+
+static enum xp_retval
 xp_remote_memcpy_uv(unsigned long dst_gpa, const unsigned long src_gpa,
 		    size_t len)
 {
 	int ret;
 
+	if (uv_gpa_in_mmr_space(src_gpa))
+		return xp_remote_mmr_read(dst_gpa, src_gpa, len);
+
 	ret = gru_copy_gpa(dst_gpa, src_gpa, len);
 	if (ret == 0)
 		return xpSuccess;
Index: pv1000000/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- pv1000000.orig/drivers/misc/sgi-xp/xpc_partition.c	2009-11-23 18:40:44.000000000 -0600
+++ pv1000000/drivers/misc/sgi-xp/xpc_partition.c	2009-11-23 18:41:22.000000000 -0600
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/hardirq.h>
 #include "xpc.h"
+#include <asm/uv/uv_hub.h>
 
 /* XPC is exiting flag */
 int xpc_exiting;
@@ -92,8 +93,12 @@ xpc_get_rsvd_page_pa(int nasid)
 			break;
 
 		/* !!! L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
-		if (L1_CACHE_ALIGN(len) > buf_len) {
-			kfree(buf_base);
+		if (is_shub())
+			len = L1_CACHE_ALIGN(len);
+
+		if (len > buf_len) {
+			if (buf_base != NULL)
+				kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
 			buf = xpc_kmalloc_cacheline_aligned(buf_len, GFP_KERNEL,
 							    &buf_base);
@@ -105,7 +110,7 @@ xpc_get_rsvd_page_pa(int nasid)
 			}
 		}
 
-		ret = xp_remote_memcpy(xp_pa(buf), rp_pa, buf_len);
+		ret = xp_remote_memcpy(xp_pa(buf), rp_pa, len);
 		if (ret != xpSuccess) {
 			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
 			break;
@@ -143,7 +148,7 @@ xpc_setup_rsvd_page(void)
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
 		return -ESRCH;
 	}
-	rp = (struct xpc_rsvd_page *)__va(rp_pa);
+	rp = (struct xpc_rsvd_page *)__va(xp_socket_pa(rp_pa));
 
 	if (rp->SAL_version < 3) {
 		/* SAL_versions < 3 had a SAL_partid defined as a u8 */
Index: pv1000000/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- pv1000000.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:40:44.000000000 -0600
+++ pv1000000/drivers/misc/sgi-xp/xpc_uv.c	2009-11-23 18:41:22.000000000 -0600
@@ -156,22 +156,24 @@ xpc_gru_mq_watchlist_alloc_uv(struct xpc
 {
 	int ret;
 
-#if defined CONFIG_X86_64
-	ret = uv_bios_mq_watchlist_alloc(mq->mmr_blade, uv_gpa(mq->address),
-					 mq->order, &mq->mmr_offset);
-	if (ret < 0) {
-		dev_err(xpc_part, "uv_bios_mq_watchlist_alloc() failed, "
-			"ret=%d\n", ret);
-		return ret;
-	}
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_alloc(mq->mmr_blade, (void *)uv_gpa(mq->address),
+#if defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
+
+	ret = sn_mq_watchlist_alloc(mmr_pnode, (void *)uv_gpa(mq->address),
 				    mq->order, &mq->mmr_offset);
 	if (ret < 0) {
 		dev_err(xpc_part, "sn_mq_watchlist_alloc() failed, ret=%d\n",
 			ret);
 		return -EBUSY;
 	}
+#elif defined CONFIG_X86_64
+	ret = uv_bios_mq_watchlist_alloc(uv_gpa(mq->address),
+					 mq->order, &mq->mmr_offset);
+	if (ret < 0) {
+		dev_err(xpc_part, "uv_bios_mq_watchlist_alloc() failed, "
+			"ret=%d\n", ret);
+		return ret;
+	}
 #else
 	#error not a supported configuration
 #endif
@@ -184,12 +186,13 @@ static void
 xpc_gru_mq_watchlist_free_uv(struct xpc_gru_mq_uv *mq)
 {
 	int ret;
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
 
 #if defined CONFIG_X86_64
-	ret = uv_bios_mq_watchlist_free(mq->mmr_blade, mq->watchlist_num);
+	ret = uv_bios_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != BIOS_STATUS_SUCCESS);
 #elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_free(mq->mmr_blade, mq->watchlist_num);
+	ret = sn_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != SALRET_OK);
 #else
 	#error not a supported configuration

