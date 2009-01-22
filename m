Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbZAVRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbZAVRxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbZAVRuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:37 -0500
Received: from relay3.sgi.com ([192.48.171.31]:56057 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760087AbZAVRu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:28 -0500
Message-Id: <20090122175027.488504000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:23 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 06/14] Change GRU CCH commands from inline functions to outofline functions
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_outofline_mcs_instructions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Change the GRU instructions that manage contexts from inline functions
to out-of-line functions.  This simplifies adding statistics & error
checking to these functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/Makefile     |    2 
 drivers/misc/sgi-gru/gruhandles.c |  197 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/sgi-gru/gruhandles.h |  174 +++------------------------------
 drivers/misc/sgi-gru/grutables.h  |    3 
 4 files changed, 217 insertions(+), 159 deletions(-)

Index: linux/drivers/misc/sgi-gru/Makefile
===================================================================
--- linux.orig/drivers/misc/sgi-gru/Makefile	2009-01-15 08:17:49.000000000 -0600
+++ linux/drivers/misc/sgi-gru/Makefile	2009-01-15 08:18:08.000000000 -0600
@@ -3,5 +3,5 @@ ifdef CONFIG_SGI_GRU_DEBUG
 endif
 
 obj-$(CONFIG_SGI_GRU) := gru.o
-gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o gruhandles.o
 
Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2009-01-15 08:18:08.000000000 -0600
@@ -0,0 +1,197 @@
+/*
+ *              GRU KERNEL MCS INSTRUCTIONS
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include "gru.h"
+#include "grulib.h"
+#include "grutables.h"
+
+/* 10 sec */
+#ifdef CONFIG_IA64
+#include <asm/processor.h>
+#define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
+#else
+#include <asm/tsc.h>
+#define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
+#endif
+
+/* Extract the status field from a kernel handle */
+#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
+
+static void start_instruction(void *h)
+{
+	unsigned long *w0 = h;
+
+	wmb();		/* setting CMD bit must be last */
+	*w0 = *w0 | 1;
+	gru_flush_cache(h);
+}
+
+static int wait_instruction_complete(void *h, enum mcs_op opc)
+{
+	int status;
+	cycles_t start_time = get_cycles();
+
+	while (1) {
+		cpu_relax();
+		status = GET_MSEG_HANDLE_STATUS(h);
+		if (status != CCHSTATUS_ACTIVE)
+			break;
+		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
+			panic("GRU %p is malfunctioning\n", h);
+	}
+	return status;
+}
+
+#if defined CONFIG_IA64
+static void cch_allocate_set_asids(
+		  struct gru_context_configuration_handle *cch, int asidval)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = (asidval++);
+#if 0
+		/* ZZZ hugepages not supported yet */
+		if (i == RGN_HPAGE)
+			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
+		else
+#endif
+			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
+	}
+}
+#elif defined CONFIG_X86_64
+static void cch_allocate_set_asids(
+		  struct gru_context_configuration_handle *cch, int asidval)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = asidval++;
+		cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT) |
+			GRU_SIZEAVAIL(21);
+	}
+}
+#endif
+
+int cch_allocate(struct gru_context_configuration_handle *cch,
+			       int asidval, unsigned long cbrmap,
+			       unsigned long dsrmap)
+{
+	cch_allocate_set_asids(cch, asidval);
+	cch->dsr_allocation_map = dsrmap;
+	cch->cbr_allocation_map = cbrmap;
+	cch->opc = CCHOP_ALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_allocate);
+}
+
+int cch_start(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_START;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_start);
+}
+
+int cch_interrupt(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_INTERRUPT;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_interrupt);
+}
+
+int cch_deallocate(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_DEALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_deallocate);
+}
+
+int cch_interrupt_sync(struct gru_context_configuration_handle
+				     *cch)
+{
+	cch->opc = CCHOP_INTERRUPT_SYNC;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_interrupt_sync);
+}
+
+int tgh_invalidate(struct gru_tlb_global_handle *tgh,
+				 unsigned long vaddr, unsigned long vaddrmask,
+				 int asid, int pagesize, int global, int n,
+				 unsigned short ctxbitmap)
+{
+	tgh->vaddr = vaddr;
+	tgh->asid = asid;
+	tgh->pagesize = pagesize;
+	tgh->n = n;
+	tgh->global = global;
+	tgh->vaddrmask = vaddrmask;
+	tgh->ctxbitmap = ctxbitmap;
+	tgh->opc = TGHOP_TLBINV;
+	start_instruction(tgh);
+	return wait_instruction_complete(tgh, tghop_invalidate);
+}
+
+void tfh_write_only(struct gru_tlb_fault_handle *tfh,
+				  unsigned long pfn, unsigned long vaddr,
+				  int asid, int dirty, int pagesize)
+{
+	tfh->fillasid = asid;
+	tfh->fillvaddr = vaddr;
+	tfh->pfn = pfn;
+	tfh->dirty = dirty;
+	tfh->pagesize = pagesize;
+	tfh->opc = TFHOP_WRITE_ONLY;
+	start_instruction(tfh);
+}
+
+void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
+				     unsigned long paddr, int gaa,
+				     unsigned long vaddr, int asid, int dirty,
+				     int pagesize)
+{
+	tfh->fillasid = asid;
+	tfh->fillvaddr = vaddr;
+	tfh->pfn = paddr >> GRU_PADDR_SHIFT;
+	tfh->gaa = gaa;
+	tfh->dirty = dirty;
+	tfh->pagesize = pagesize;
+	tfh->opc = TFHOP_WRITE_RESTART;
+	start_instruction(tfh);
+}
+
+void tfh_restart(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_RESTART;
+	start_instruction(tfh);
+}
+
+void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_USER_POLLING_MODE;
+	start_instruction(tfh);
+}
+
+void tfh_exception(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_EXCEPTION;
+	start_instruction(tfh);
+}
+
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-01-15 08:18:04.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-01-15 08:18:08.000000000 -0600
@@ -495,164 +495,22 @@ enum gru_cbr_state {
 /* minimum TLB purge count to ensure a full purge */
 #define GRUMAXINVAL		1024UL
 
+int cch_allocate(struct gru_context_configuration_handle *cch,
+       int asidval, unsigned long cbrmap, unsigned long dsrmap);
 
-/* Extract the status field from a kernel handle */
-#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
-
-static inline void start_instruction(void *h)
-{
-	unsigned long *w0 = h;
-
-	wmb();		/* setting CMD bit must be last */
-	*w0 = *w0 | 1;
-	gru_flush_cache(h);
-}
-
-static inline int wait_instruction_complete(void *h)
-{
-	int status;
-
-	do {
-		cpu_relax();
-		barrier();
-		status = GET_MSEG_HANDLE_STATUS(h);
-	} while (status == CCHSTATUS_ACTIVE);
-	return status;
-}
-
-#if defined CONFIG_IA64
-static inline void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
-{
-	int i;
-
-	for (i = 0; i <= RGN_HPAGE; i++) {  /*  assume HPAGE is last region */
-		cch->asid[i] = (asidval++);
-#if 0
-		/* ZZZ hugepages not supported yet */
-		if (i == RGN_HPAGE)
-			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
-		else
-#endif
-			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
-	}
-}
-#elif defined CONFIG_X86_64
-static inline void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
-{
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = asidval++;
-		cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT) |
-			GRU_SIZEAVAIL(21);
-	}
-}
-#endif
-
-static inline int cch_allocate(struct gru_context_configuration_handle *cch,
-			       int asidval, unsigned long cbrmap,
-			       unsigned long dsrmap)
-{
-	cch_allocate_set_asids(cch, asidval);
-	cch->dsr_allocation_map = dsrmap;
-	cch->cbr_allocation_map = cbrmap;
-	cch->opc = CCHOP_ALLOCATE;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_start(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_START;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_interrupt(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_INTERRUPT;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_deallocate(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_DEALLOCATE;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_interrupt_sync(struct gru_context_configuration_handle
-				     *cch)
-{
-	cch->opc = CCHOP_INTERRUPT_SYNC;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int tgh_invalidate(struct gru_tlb_global_handle *tgh,
-				 unsigned long vaddr, unsigned long vaddrmask,
-				 int asid, int pagesize, int global, int n,
-				 unsigned short ctxbitmap)
-{
-	tgh->vaddr = vaddr;
-	tgh->asid = asid;
-	tgh->pagesize = pagesize;
-	tgh->n = n;
-	tgh->global = global;
-	tgh->vaddrmask = vaddrmask;
-	tgh->ctxbitmap = ctxbitmap;
-	tgh->opc = TGHOP_TLBINV;
-	start_instruction(tgh);
-	return wait_instruction_complete(tgh);
-}
-
-static inline void tfh_write_only(struct gru_tlb_fault_handle *tfh,
-				  unsigned long pfn, unsigned long vaddr,
-				  int asid, int dirty, int pagesize)
-{
-	tfh->fillasid = asid;
-	tfh->fillvaddr = vaddr;
-	tfh->pfn = pfn;
-	tfh->dirty = dirty;
-	tfh->pagesize = pagesize;
-	tfh->opc = TFHOP_WRITE_ONLY;
-	start_instruction(tfh);
-}
-
-static inline void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
-				     unsigned long paddr, int gaa,
-				     unsigned long vaddr, int asid, int dirty,
-				     int pagesize)
-{
-	tfh->fillasid = asid;
-	tfh->fillvaddr = vaddr;
-	tfh->pfn = paddr >> GRU_PADDR_SHIFT;
-	tfh->gaa = gaa;
-	tfh->dirty = dirty;
-	tfh->pagesize = pagesize;
-	tfh->opc = TFHOP_WRITE_RESTART;
-	start_instruction(tfh);
-}
-
-static inline void tfh_restart(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_RESTART;
-	start_instruction(tfh);
-}
-
-static inline void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_USER_POLLING_MODE;
-	start_instruction(tfh);
-}
-
-static inline void tfh_exception(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_EXCEPTION;
-	start_instruction(tfh);
-}
+int cch_start(struct gru_context_configuration_handle *cch);
+int cch_interrupt(struct gru_context_configuration_handle *cch);
+int cch_deallocate(struct gru_context_configuration_handle *cch);
+int cch_interrupt_sync(struct gru_context_configuration_handle *cch);
+int tgh_invalidate(struct gru_tlb_global_handle *tgh, unsigned long vaddr,
+	unsigned long vaddrmask, int asid, int pagesize, int global, int n,
+	unsigned short ctxbitmap);
+void tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long pfn,
+	unsigned long vaddr, int asid, int dirty, int pagesize);
+void tfh_write_restart(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
+	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
+void tfh_restart(struct gru_tlb_fault_handle *tfh);
+void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh);
+void tfh_exception(struct gru_tlb_fault_handle *tfh);
 
 #endif /* __GRUHANDLES_H__ */
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:06.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-01-15 08:18:08.000000000 -0600
@@ -239,6 +239,9 @@ struct gru_stats_s {
 
 };
 
+enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
+	cchop_deallocate, tghop_invalidate, mcsop_last};
+
 #define OPT_DPRINT	1
 #define OPT_STATS	2
 #define GRU_QUICKLOOK	4

