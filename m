Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZKIRJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZKIRJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZKIRJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:09:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44984 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755120AbZKIRJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:09:01 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091109170906.657310000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 11:08:58 -0600
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 4/6] x86: UV - Update XPC to handle updated BIOS interface.
References: <20091109170854.161447000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_uv_bios_changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The UV BIOS has moved the location of some of their pointers to the
"partition reserved page" from memory into a uv hub MMR.  The GRU does
not support bcopy operations from MMR space so we need to special case
the MMR addresses using VLOAD operations.

To: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 drivers/misc/sgi-xp/xp_uv.c         |   23 +++++++++++++++++++++++
 drivers/misc/sgi-xp/xpc_partition.c |   13 +++++++++----
 drivers/misc/sgi-xp/xpc_uv.c        |   10 ++++++----
 3 files changed, 38 insertions(+), 8 deletions(-)
Index: linux-2.6.27/drivers/misc/sgi-xp/xp_uv.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xp_uv.c	2009-10-29 16:22:16.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xp_uv.c	2009-10-29 16:23:06.000000000 -0500
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
Index: linux-2.6.27/drivers/misc/sgi-xp/xpc_partition.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xpc_partition.c	2009-10-29 16:15:05.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xpc_partition.c	2009-10-29 16:24:07.000000000 -0500
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
Index: linux-2.6.27/drivers/misc/sgi-xp/xpc_uv.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xpc_uv.c	2009-10-29 16:15:05.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xpc_uv.c	2009-10-29 16:23:06.000000000 -0500
@@ -155,9 +155,10 @@ static int
 xpc_gru_mq_watchlist_alloc_uv(struct xpc_gru_mq_uv *mq)
 {
 	int ret;
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
 
 #if defined CONFIG_X86_64
-	ret = uv_bios_mq_watchlist_alloc(mq->mmr_blade, uv_gpa(mq->address),
+	ret = uv_bios_mq_watchlist_alloc(mmr_pnode, uv_gpa(mq->address),
 					 mq->order, &mq->mmr_offset);
 	if (ret < 0) {
 		dev_err(xpc_part, "uv_bios_mq_watchlist_alloc() failed, "
@@ -165,7 +166,7 @@ xpc_gru_mq_watchlist_alloc_uv(struct xpc
 		return ret;
 	}
 #elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_alloc(mq->mmr_blade, (void *)uv_gpa(mq->address),
+	ret = sn_mq_watchlist_alloc(mmr_pnode, (void *)uv_gpa(mq->address),
 				    mq->order, &mq->mmr_offset);
 	if (ret < 0) {
 		dev_err(xpc_part, "sn_mq_watchlist_alloc() failed, ret=%d\n",
@@ -184,12 +185,13 @@ static void
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

