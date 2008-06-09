Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYFIVML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYFIVML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYFIVKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:10:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52531 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724AbYFIVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:10:46 -0400
Message-Id: <20080609211044.992972808@attica.americas.sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Jun 2008 16:10:29 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 01/11] GRU Driver - hardware data structures
Content-Disposition: inline; filename=gru_handles_header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the definitions of the hardware GRU data structures that are used
by the driver to manage the GRU.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/gru/gruhandles.h |  690 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 690 insertions(+)

Index: linux/drivers/misc/gru/gruhandles.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/misc/gru/gruhandles.h	2008-06-09 13:53:05.864786467 -0500
@@ -0,0 +1,690 @@
+/*
+ * SN Platform GRU Driver
+ *
+ *              GRU HANDLE DEFINITION
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
+#ifndef __GRUHANDLES_H__
+#define __GRUHANDLES_H__
+
+/*
+ * Manifest constants for GRU Memory Map
+ */
+#define GRU_GSEG0_BASE		0
+#define GRU_MCS_BASE		(64 * 1024 * 1024)
+#define GRU_SIZE		(128UL * 1024 * 1024)
+
+/* Handle & resource counts */
+#define GRU_NUM_CB		128
+#define GRU_NUM_DSR_BYTES	(32 * 1024)
+#define GRU_NUM_TFM		16
+#define GRU_NUM_TGH		24
+#define GRU_NUM_CBE		128
+#define GRU_NUM_TFH		128
+#define GRU_NUM_CCH		16
+#define GRU_NUM_GSH		1
+
+/* Maximum resource counts that can be reserved by user programs */
+#define GRU_NUM_USER_CBR	GRU_NUM_CBE
+#define GRU_NUM_USER_DSR_BYTES	GRU_NUM_DSR_BYTES
+
+/* Bytes per handle & handle stride. Code assumes all cb, tfh, cbe handles
+ * are the same */
+#define GRU_HANDLE_BYTES	64
+#define GRU_HANDLE_STRIDE	256
+
+/* Base addresses of handles */
+#define GRU_TFM_BASE		(GRU_MCS_BASE + 0x00000)
+#define GRU_TGH_BASE		(GRU_MCS_BASE + 0x08000)
+#define GRU_CBE_BASE		(GRU_MCS_BASE + 0x10000)
+#define GRU_TFH_BASE		(GRU_MCS_BASE + 0x18000)
+#define GRU_CCH_BASE		(GRU_MCS_BASE + 0x20000)
+#define GRU_GSH_BASE		(GRU_MCS_BASE + 0x30000)
+
+/* User gseg constants */
+#define GRU_GSEG_STRIDE		(4 * 1024 * 1024)
+#define GSEG_BASE(a)		((a) & ~(GRU_GSEG_PAGESIZE - 1))
+
+/* Data segment constants */
+#define GRU_DSR_AU_BYTES	1024
+#define GRU_DSR_CL		(GRU_NUM_DSR_BYTES / GRU_CACHE_LINE_BYTES)
+#define GRU_DSR_AU_CL		(GRU_DSR_AU_BYTES / GRU_CACHE_LINE_BYTES)
+#define GRU_DSR_AU		(GRU_NUM_DSR_BYTES / GRU_DSR_AU_BYTES)
+
+/* Control block constants */
+#define GRU_CBR_AU_SIZE		2
+#define GRU_CBR_AU		(GRU_NUM_CBE / GRU_CBR_AU_SIZE)
+
+/* Convert resource counts to the number of AU */
+#define GRU_DS_BYTES_TO_AU(n)	(((n) + GRU_DSR_AU_BYTES - 1) / \
+				 GRU_DSR_AU_BYTES)
+#define GRU_CB_COUNT_TO_AU(n)	(((n) + GRU_CBR_AU_SIZE - 1) / 	\
+				 GRU_CBR_AU_SIZE)
+
+/* UV limits */
+#define GRU_CHIPLETS_PER_HUB	2
+#define GRU_HUBS_PER_BLADE	1
+#define GRU_CHIPLETS_PER_BLADE	(GRU_HUBS_PER_BLADE * GRU_CHIPLETS_PER_HUB)
+
+/* User GRU Gseg offsets */
+#define GRU_CB_BASE		0
+#define GRU_CB_LIMIT		(GRU_CB_BASE + GRU_HANDLE_STRIDE * GRU_NUM_CBE)
+#define GRU_DS_BASE		0x20000
+#define GRU_DS_LIMIT		(GRU_DS_BASE + GRU_NUM_DSR_BYTES)
+
+/* General addressing macros. b=grubase, c=ctxnum, i=cbnum, cl=cacheline#  */
+#define GRU_GSEG(b, c)		((void *)((b) + GRU_GSEG0_BASE +	\
+		GRU_GSEG_STRIDE * (c)))
+#define GRU_GSEG_CB(b, c, i)	((void *)(GRU_GSEG((b), (c)) +		\
+		GRU_CB_BASE + GRU_HANDLE_STRIDE * (i)))
+#define GRU_GSEG_DS(b, c, cl)	((void *)(GRU_GSEG((b), (c)) +		\
+		GRU_DS_BASE + GRU_CACHE_LINE_BYTES * (cl)))
+#define GRU_TFM(b, c)		((struct gru_tlb_fault_map *)		\
+		((unsigned long)(b) + GRU_TFM_BASE + (c) * GRU_HANDLE_STRIDE))
+#define GRU_TGH(b, c)		((struct gru_tlb_global_handle *)	\
+		((unsigned long)(b) + GRU_TGH_BASE + (c) * GRU_HANDLE_STRIDE))
+#define GRU_CBE(b, n)		((struct gru_control_block_extended *)	\
+		((unsigned long)(b) + GRU_CBE_BASE + (n) * GRU_HANDLE_STRIDE))
+#define GRU_TFH(b, n)		((struct gru_tlb_fault_handle *)	\
+		((unsigned long)(b) + GRU_TFH_BASE + (n) * GRU_HANDLE_STRIDE))
+#define GRU_CCH(b, n)		((struct gru_context_configuration_handle *) \
+		((unsigned long)(b) + GRU_CCH_BASE + (n) * GRU_HANDLE_STRIDE))
+#define GRU_GSH(b)		((struct gru_global_status_handle *)	\
+		((unsigned long)(b) + GRU_GSH_BASE))
+
+/*
+ * Test if an offset is a valid kernel handle address.
+ * 	Ex:  TYPE_IS(CBE, chiplet_offset)
+ */
+#define TYPE_IS(hn, h)		((h) >= GRU_##hn##_BASE && (h) < 	\
+	GRU_##hn##_BASE + GRU_NUM_##hn * GRU_HANDLE_STRIDE && 		\
+				 (((h) & (GRU_HANDLE_STRIDE - 1)) == 0))
+
+/*
+ * Test a GRU physical address to determine the type of address range (does
+ * NOT validate holes)
+ */
+#define IS_MCS_PADDR(h)		(((h) & (GRU_SIZE - 1)) >= GRU_MCS_BASE)
+#define IS_CBR_PADDR(h)		(((h) & (GRU_SIZE - 1)) < 		\
+		GRU_MCS_BASE && (((h) & (GRU_GSEG_STRIDE - 1)) < GRU_DS_BASE))
+#define IS_DSR_PADDR(h)		(((h) & (GRU_SIZE - 1)) < GRU_MCS_BASE && \
+		(((h) & (GRU_GSEG_STRIDE - 1)) >= GRU_DS_BASE))
+
+/* Convert an arbitrary handle address to the beginning of the GRU segment */
+#ifndef __PLUGIN__
+#define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
+#else
+/* Emulator hack */
+extern void *gmu_grubase(void *h);
+#define GRUBASE(h)		gmu_grubase(h)
+#endif
+
+/* Convert a GRU physical address to the chiplet offset */
+#define GSEGPOFF(h) ((h) & (GRU_SIZE - 1))
+
+/* Convert a GSEG CB address to the relative CB number within the context */
+#define CBNUM(cb) ((((unsigned long)(cb) - GRU_CB_BASE) % GRU_GSEG_PAGESIZE) / \
+			GRU_HANDLE_STRIDE)
+
+/* Convert a TFH address to the relative TFH number within the GRU*/
+#define TFHNUM(tfh) ((((unsigned long)(tfh) - GRU_TFH_BASE) % GRU_SIZE) / \
+			GRU_HANDLE_STRIDE)
+
+/* Convert a CCH address to the relative context number within the GRU*/
+#define CCHNUM(cch) ((((unsigned long)(cch) - GRU_CCH_BASE) % GRU_SIZE) / \
+			GRU_HANDLE_STRIDE)
+
+/* Convert a CBE address to the relative context number within the GRU*/
+#define CBENUM(cbe) ((((unsigned long)(cbe) - GRU_CBE_BASE) % GRU_SIZE) / \
+			GRU_HANDLE_STRIDE)
+
+/* Convert a TFM address to the relative context number within the GRU*/
+#define TFMNUM(tfm) ((((unsigned long)(tfm) - GRU_TFM_BASE) % GRU_SIZE) / \
+			GRU_HANDLE_STRIDE)
+
+/* byte offset to a specific GRU chiplet. (p=pnode, c=chiplet (0 or 1)*/
+#define GRUCHIPOFFSET(p, c) (GRU_SIZE * ((p) * 2 + (c)))
+
+#ifndef BITS_TO_LONGS
+#define BITS_TO_LONGS(bits)     (((bits)+64-1)/64)
+#endif
+
+/*
+ * GSH - GRU Status Handle
+ *	Shows status of each CBR/CBR resources
+ */
+struct gru_global_status_handle {
+	unsigned long bits[BITS_TO_LONGS(GRU_NUM_CBE) * 2];
+	unsigned long fill[4];
+};
+
+enum gru_gsh_status {
+	GSHSTATUS_INACTIVE,
+	GSHSTATUS_IDLE,
+	GSHSTATUS_ACTIVE,
+	GSHSTATUS_INTERRUPTED
+};
+
+/*
+ * Global TLB Fault Map
+ * 	Bitmap of outstanding TLB misses needing interrupt/polling service.
+ *
+ */
+struct gru_tlb_fault_map {
+	unsigned long fault_bits[BITS_TO_LONGS(GRU_NUM_CBE)];
+	unsigned long fill0[2];
+	unsigned long done_bits[BITS_TO_LONGS(GRU_NUM_CBE)];
+	unsigned long fill1[2];
+};
+
+/*
+ * TGH - TLB Global Handle
+ * 	Used for TLB flushing.
+ *
+ */
+struct gru_tlb_global_handle {
+	unsigned int cmd:1;		/* DW 0 */
+	unsigned int delresp:1;
+	unsigned int opc:1;
+	unsigned int fill1:5;
+
+	unsigned int fill2:8;
+
+	unsigned int status:2;
+	unsigned long fill3:2;
+	unsigned int state:3;
+	unsigned long fill4:1;
+
+	unsigned int cause:3;
+	unsigned long fill5:37;
+
+	unsigned long vaddr:64;		/* DW 1 */
+
+	unsigned int asid:24;		/* DW 2 */
+	unsigned int fill6:8;
+
+	unsigned int pagesize:5;
+	unsigned int fill7:11;
+
+	unsigned int global:1;
+	unsigned int fill8:15;
+
+	unsigned long vaddrmask:39;	/* DW 3 */
+	unsigned int fill9:9;
+	unsigned int n:10;
+	unsigned int fill10:6;
+
+	unsigned int ctxbitmap:16;	/* DW4 */
+	unsigned long fill11[3];
+};
+
+enum gru_tgh_cmd {
+	TGHCMD_START
+};
+
+enum gru_tgh_opc {
+	TGHOP_TLBNOP,
+	TGHOP_TLBINV
+};
+
+enum gru_tgh_status {
+	TGHSTATUS_IDLE,
+	TGHSTATUS_EXCEPTION,
+	TGHSTATUS_ACTIVE
+};
+
+enum gru_tgh_state {
+	TGHSTATE_IDLE,
+	TGHSTATE_PE_INVAL,
+	TGHSTATE_INTERRUPT_INVAL,
+	TGHSTATE_WAITDONE,
+	TGHSTATE_RESTART_CTX,
+};
+
+/*
+ * TFH - TLB Global Handle
+ * 	Used for TLB dropins into the GRU TLB.
+ *
+ */
+struct gru_tlb_fault_handle {
+	unsigned int cmd:1;		/* DW 0 - low 32*/
+	unsigned int delresp:1;
+	unsigned int fill0:2;
+	unsigned int opc:3;
+	unsigned int fill1:9;
+
+	unsigned int status:2;
+	unsigned int fill2:1;
+	unsigned int color:1;
+	unsigned int state:3;
+	unsigned int fill3:1;
+
+	unsigned int cause:7;		/* DW 0 - high 32 */
+	unsigned int fill4:1;
+
+	unsigned int indexway:12;
+	unsigned int fill5:4;
+
+	unsigned int ctxnum:4;
+	unsigned int fill6:12;
+
+	unsigned long missvaddr:64;	/* DW 1 */
+
+	unsigned int missasid:24;	/* DW 2 */
+	unsigned int fill7:8;
+	unsigned int fillasid:24;
+	unsigned int dirty:1;
+	unsigned int gaa:2;
+	unsigned long fill8:5;
+
+	unsigned long pfn:41;		/* DW 3 */
+	unsigned int fill9:7;
+	unsigned int pagesize:5;
+	unsigned int fill10:11;
+
+	unsigned long fillvaddr:64;	/* DW 4 */
+
+	unsigned long fill11[3];
+};
+
+enum gru_tfh_opc {
+	TFHOP_NOOP,
+	TFHOP_RESTART,
+	TFHOP_WRITE_ONLY,
+	TFHOP_WRITE_RESTART,
+	TFHOP_EXCEPTION,
+	TFHOP_USER_POLLING_MODE = 7,
+};
+
+enum tfh_status {
+	TFHSTATUS_IDLE,
+	TFHSTATUS_EXCEPTION,
+	TFHSTATUS_ACTIVE,
+};
+
+enum tfh_state {
+	TFHSTATE_INACTIVE,
+	TFHSTATE_IDLE,
+	TFHSTATE_MISS_UPM,
+	TFHSTATE_MISS_FMM,
+	TFHSTATE_HW_ERR,
+	TFHSTATE_WRITE_TLB,
+	TFHSTATE_RESTART_CBR,
+};
+
+/* TFH cause bits */
+enum tfh_cause {
+	TFHCAUSE_NONE,
+	TFHCAUSE_TLB_MISS,
+	TFHCAUSE_TLB_MOD,
+	TFHCAUSE_HW_ERROR_RR,
+	TFHCAUSE_HW_ERROR_MAIN_ARRAY,
+	TFHCAUSE_HW_ERROR_VALID,
+	TFHCAUSE_HW_ERROR_PAGESIZE,
+	TFHCAUSE_INSTRUCTION_EXCEPTION,
+	TFHCAUSE_UNCORRECTIBLE_ERROR,
+};
+
+/* GAA values */
+#define GAA_RAM				0x0
+#define GAA_NCRAM			0x2
+#define GAA_MMIO			0x1
+#define GAA_REGISTER			0x3
+
+/* GRU paddr shift for pfn. (NOTE: shift is NOT by actual pagesize) */
+#define GRU_PADDR_SHIFT			12
+
+/*
+ * Context Configuration handle
+ * 	Used to allocate resources to a GSEG context.
+ *
+ */
+struct gru_context_configuration_handle {
+	unsigned int cmd:1;			/* DW0 */
+	unsigned int delresp:1;
+	unsigned int opc:3;
+	unsigned int unmap_enable:1;
+	unsigned int req_slice_set_enable:1;
+	unsigned int req_slice:2;
+	unsigned int cb_int_enable:1;
+	unsigned int tlb_int_enable:1;
+	unsigned int tfm_fault_bit_enable:1;
+	unsigned int tlb_int_select:4;
+
+	unsigned int status:2;
+	unsigned int state:2;
+	unsigned int reserved2:4;
+
+	unsigned int cause:4;
+	unsigned int tfm_done_bit_enable:1;
+	unsigned int unused:3;
+
+	unsigned int dsr_allocation_map;
+
+	unsigned long cbr_allocation_map;	/* DW1 */
+
+	unsigned int asid[8];			/* DW 2 - 5 */
+	unsigned short sizeavail[8];		/* DW 6 - 7 */
+} __attribute__ ((packed));
+
+enum gru_cch_opc {
+	CCHOP_START = 1,
+	CCHOP_ALLOCATE,
+	CCHOP_INTERRUPT,
+	CCHOP_DEALLOCATE,
+	CCHOP_INTERRUPT_SYNC,
+};
+
+enum gru_cch_status {
+	CCHSTATUS_IDLE,
+	CCHSTATUS_EXCEPTION,
+	CCHSTATUS_ACTIVE,
+};
+
+enum gru_cch_state {
+	CCHSTATE_INACTIVE,
+	CCHSTATE_MAPPED,
+	CCHSTATE_ACTIVE,
+	CCHSTATE_INTERRUPTED,
+};
+
+/* CCH Exception cause */
+enum gru_cch_cause {
+	CCHCAUSE_REGION_REGISTER_WRITE_ERROR = 1,
+	CCHCAUSE_ILLEGAL_OPCODE = 2,
+	CCHCAUSE_INVALID_START_REQUEST = 3,
+	CCHCAUSE_INVALID_ALLOCATION_REQUEST = 4,
+	CCHCAUSE_INVALID_DEALLOCATION_REQUEST = 5,
+	CCHCAUSE_INVALID_INTERRUPT_REQUEST = 6,
+	CCHCAUSE_CCH_BUSY = 7,
+	CCHCAUSE_NO_CBRS_TO_ALLOCATE = 8,
+	CCHCAUSE_BAD_TFM_CONFIG = 9,
+	CCHCAUSE_CBR_RESOURCES_OVERSUBSCRIPED = 10,
+	CCHCAUSE_DSR_RESOURCES_OVERSUBSCRIPED = 11,
+	CCHCAUSE_CBR_DEALLOCATION_ERROR = 12,
+};
+/*
+ * CBE - Control Block Extended
+ * 	Maintains internal GRU state for active CBs.
+ *
+ */
+struct gru_control_block_extended {
+	unsigned int reserved0:1;	/* DW 0  - low */
+	unsigned int imacpy:3;
+	unsigned int reserved1:4;
+	unsigned int xtypecpy:3;
+	unsigned int iaa0cpy:2;
+	unsigned int iaa1cpy:2;
+	unsigned int reserved2:1;
+	unsigned int opccpy:8;
+	unsigned int exopccpy:8;
+
+	unsigned int idef2cpy:22;	/* DW 0  - high */
+	unsigned int reserved3:10;
+
+	unsigned int idef4cpy:22;	/* DW 1 */
+	unsigned int reserved4:10;
+	unsigned int idef4upd:22;
+	unsigned int reserved5:10;
+
+	unsigned long idef1upd:64;	/* DW 2 */
+
+	unsigned long idef5cpy:64;	/* DW 3 */
+
+	unsigned long idef6cpy:64;	/* DW 4 */
+
+	unsigned long idef3upd:64;	/* DW 5 */
+
+	unsigned long idef5upd:64;	/* DW 6 */
+
+	unsigned int idef2upd:22;	/* DW 7 */
+	unsigned int reserved6:10;
+
+	unsigned int ecause:20;
+	unsigned int cbrstate:4;
+	unsigned int cbrexecstatus:8;
+};
+
+enum gru_cbr_state {
+	CBRSTATE_INACTIVE,
+	CBRSTATE_IDLE,
+	CBRSTATE_PE_CHECK,
+	CBRSTATE_QUEUED,
+	CBRSTATE_WAIT_RESPONSE,
+	CBRSTATE_INTERRUPTED,
+	CBRSTATE_INTERRUPTED_MISS_FMM,
+	CBRSTATE_BUSY_INTERRUPT_MISS_FMM,
+	CBRSTATE_INTERRUPTED_MISS_UPM,
+	CBRSTATE_BUSY_INTERRUPTED_MISS_UPM,
+	CBRSTATE_REQUEST_ISSUE,
+	CBRSTATE_BUSY_INTERRUPT,
+};
+
+/* CBE cbrexecstatus bits */
+#define CBR_EXS_ABORT_OCC_BIT			0
+#define CBR_EXS_INT_OCC_BIT			1
+#define CBR_EXS_PENDING_BIT			2
+#define CBR_EXS_QUEUED_BIT			3
+#define CBR_EXS_TLBHW_BIT			4
+#define CBR_EXS_EXCEPTION_BIT			5
+
+#define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
+#define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
+#define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
+#define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
+#define CBR_EXS_TLBHW				(1 << CBR_EXS_TLBHW_BIT)
+#define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
+
+/* CBE ecause bits  - defined in gru_instructions.h */
+
+/*
+ * Convert a processor pagesize into the strange encoded pagesize used by the
+ * GRU. Processor pagesize is encoded as log of bytes per page. (or PAGE_SHIFT)
+ * 	pagesize	log pagesize	grupagesize
+ * 	  4k			12	0
+ * 	 16k 			14	1
+ * 	 64k			16	2
+ * 	256k			18	3
+ * 	  1m			20	4
+ * 	  2m			21	5
+ * 	  4m			22	6
+ * 	 16m			24	7
+ * 	 64m			26	8
+ * 	...
+ */
+#define GRU_PAGESIZE(sh)	((((sh) > 20 ? (sh) + 2: (sh)) >> 1) - 6)
+#define GRU_SIZEAVAIL(sh)	(1UL << GRU_PAGESIZE(sh))
+
+/* minimum TLB purge count to ensure a full purge */
+#define GRUMAXINVAL		1024UL
+
+/*-----------------------------------------------------------------------------
+ *
+ * Handle operations
+ */
+
+#define cch_to_gsh(c)		GRU_GSH(GRUBASE(c))
+#define cch_to_tfh(c, i)	GRU_TFH(GRUBASE(c), (i))
+#define cch_to_cbe(c, i)	GRU_CBE(GRUBASE(c), (i))
+#define cbe_to_tfh(c)		GRU_TFH(GRUBASE(c), CBENUM(c))
+#define cbe_to_cch(c)		GRU_CCH(GRUBASE(c), CBENUM(c))
+#define tfh_to_cbe(c)		GRU_CBE(GRUBASE(c), TFHNUM(c))
+#define cb_to_cbe(c, n)		GRU_CBE(GRUBASE(c), (n))
+
+#ifdef __KERNEL__
+#include "gru_instructions.h"
+
+/* Extract the status field from a kernel handle */
+#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
+
+static inline void start_instruction(void *h)
+{
+	unsigned long *w0 = h;
+
+	wmb();		/* setting CMD bit must be last */
+	*w0 = *w0 | 1;
+	gru_flush_cache(h);
+}
+
+static inline int wait_instruction_complete(void *h)
+{
+	int status;
+
+	do {
+		cpu_relax();
+		barrier();
+		status = GET_MSEG_HANDLE_STATUS(h);
+	} while (status == CCHSTATUS_ACTIVE);
+	return status;
+}
+
+#if defined __ia64__
+static inline void cch_allocate_set_asids(
+		  struct gru_context_configuration_handle *cch, int asidval)
+{
+	int i;
+
+	for (i = 0; i <= RGN_HPAGE; i++) {  /*  assume HPAGE is last region */
+		cch->asid[i] = (asidval++);
+		if (i == RGN_HPAGE)
+			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
+		else
+			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
+	}
+}
+#elif defined __x86_64__
+static inline void cch_allocate_set_asids(
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
+static inline int cch_allocate(struct gru_context_configuration_handle *cch,
+			       int asidval, unsigned long cbrmap,
+			       unsigned long dsrmap)
+{
+	cch_allocate_set_asids(cch, asidval);
+	cch->dsr_allocation_map = dsrmap;
+	cch->cbr_allocation_map = cbrmap;
+	cch->opc = CCHOP_ALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch);
+}
+
+static inline int cch_start(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_START;
+	start_instruction(cch);
+	return wait_instruction_complete(cch);
+}
+
+static inline int cch_interrupt(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_INTERRUPT;
+	start_instruction(cch);
+	return wait_instruction_complete(cch);
+}
+
+static inline int cch_deallocate(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_DEALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch);
+}
+
+static inline int cch_interrupt_sync(struct gru_context_configuration_handle
+				     *cch)
+{
+	cch->opc = CCHOP_INTERRUPT_SYNC;
+	start_instruction(cch);
+	return wait_instruction_complete(cch);
+}
+
+static inline int tgh_invalidate(struct gru_tlb_global_handle *tgh,
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
+	return wait_instruction_complete(tgh);
+}
+
+static inline void tfh_write_only(struct gru_tlb_fault_handle *tfh,
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
+static inline void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
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
+static inline void tfh_restart(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_RESTART;
+	start_instruction(tfh);
+}
+
+static inline void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_USER_POLLING_MODE;
+	start_instruction(tfh);
+}
+
+static inline void tfh_exception(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_EXCEPTION;
+	start_instruction(tfh);
+}
+#endif /* __KERNEL__ */
+
+#endif /* __GRUHANDLES_H__ */

-- 
Thanks

Jack Steiner (steiner@sgi.com)          651-683-5302
Sr Principal Engineer                   SGI - Silicon Graphics, Inc.


