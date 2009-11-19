Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZKSRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZKSRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZKSRdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:33:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54923 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753314AbZKSRcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:02 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173207.277928000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:32:01 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 4/8] X86: UV - Implement a gru_read_gpa kernel function.
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=gru_read_gpa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The BIOS has decided to store a pointer to the partition reserved page
in a scratch MMR.  The GRU is only able to read an MMR using a vload
instruction.  The gru_read_gpa() function will implemented.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org

---
 drivers/misc/sgi-gru/gru_instructions.h |   13 +++++++++++++
 drivers/misc/sgi-gru/grukservices.c     |   23 +++++++++++++++++++++++
 drivers/misc/sgi-gru/grukservices.h     |   14 ++++++++++++++
 drivers/misc/sgi-gru/gruprocfs.c        |    1 +
 drivers/misc/sgi-gru/grutables.h        |    1 +
 5 files changed, 52 insertions(+)
Index: linux-x86/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux-x86.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-10-17 03:59:22.000000000 -0500
+++ linux-x86/drivers/misc/sgi-gru/gru_instructions.h	2009-11-18 21:21:31.000000000 -0600
@@ -340,6 +340,19 @@ static inline void gru_start_instruction
  *     	- nelem and stride are in elements
  *     	- tri0/tri1 is in bytes for the beginning of the data segment.
  */
+static inline void gru_vload_phys(void *cb, unsigned long gpa,
+		unsigned int tri0, int iaa, unsigned long hints)
+{
+	struct gru_instruction *ins = (struct gru_instruction *)cb;
+
+	ins->baddr0 = (long)gpa | ((unsigned long)iaa << 62);
+	ins->nelem = 1;
+	ins->tri0 = tri0;
+	ins->op1_stride = 1;
+	gru_start_instruction(ins, __opword(OP_VLOAD, 0, XTYPE_DW, iaa, 0,
+					CB_IMA(hints)));
+}
+
 static inline void gru_vload(void *cb, unsigned long mem_addr,
 		unsigned int tri0, unsigned char xtype, unsigned long nelem,
 		unsigned long stride, unsigned long hints)
Index: linux-x86/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux-x86.orig/drivers/misc/sgi-gru/grukservices.c	2009-10-17 03:59:22.000000000 -0500
+++ linux-x86/drivers/misc/sgi-gru/grukservices.c	2009-11-18 21:04:40.000000000 -0600
@@ -858,6 +858,29 @@ EXPORT_SYMBOL_GPL(gru_get_next_message);
 /* ---------------------- GRU DATA COPY FUNCTIONS ---------------------------*/
 
 /*
+ * Load a DW from a global GPA. The GPA can be a memory or MMR address.
+ */
+int gru_read_gpa(unsigned long *value, unsigned long gpa)
+{
+	void *cb;
+	void *dsr;
+	int ret, iaa;
+
+	STAT(read_gpa);
+	if (gru_get_cpu_resources(GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr))
+		return MQE_BUG_NO_RESOURCES;
+	iaa = gpa >> 62;
+	gru_vload_phys(cb, gpa, gru_get_tri(dsr), iaa, IMA);
+	ret = gru_wait(cb);
+	if (ret == CBS_IDLE)
+		*value = *(unsigned long *)dsr;
+	gru_free_cpu_resources(cb, dsr);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gru_read_gpa);
+
+
+/*
  * Copy a block of data using the GRU resources
  */
 int gru_copy_gpa(unsigned long dest_gpa, unsigned long src_gpa,
Index: linux-x86/drivers/misc/sgi-gru/grukservices.h
===================================================================
--- linux-x86.orig/drivers/misc/sgi-gru/grukservices.h	2009-10-17 03:59:22.000000000 -0500
+++ linux-x86/drivers/misc/sgi-gru/grukservices.h	2009-11-18 21:03:14.000000000 -0600
@@ -131,6 +131,20 @@ extern void *gru_get_next_message(struct
 
 
 /*
+ * Read a GRU global GPA. Source can be located in a remote partition.
+ *
+ *    Input:
+ *    	value		memory address where MMR value is returned
+ *    	gpa		source numalink physical address of GPA
+ *
+ *    Output:
+ *	0		OK
+ *	>0		error
+ */
+int gru_read_gpa(unsigned long *value, unsigned long gpa);
+
+
+/*
  * Copy data using the GRU. Source or destination can be located in a remote
  * partition.
  *
Index: linux-x86/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux-x86.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-11-18 13:45:38.000000000 -0600
+++ linux-x86/drivers/misc/sgi-gru/gruprocfs.c	2009-11-18 21:11:34.000000000 -0600
@@ -98,6 +98,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, flush_tlb_gru_tgh);
 	printstat(s, flush_tlb_gru_zero_asid);
 	printstat(s, copy_gpa);
+	printstat(s, read_gpa);
 	printstat(s, mesq_receive);
 	printstat(s, mesq_receive_none);
 	printstat(s, mesq_send);
Index: linux-x86/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux-x86.orig/drivers/misc/sgi-gru/grutables.h	2009-10-17 03:59:22.000000000 -0500
+++ linux-x86/drivers/misc/sgi-gru/grutables.h	2009-11-18 21:07:58.000000000 -0600
@@ -224,6 +224,7 @@ struct gru_stats_s {
 	atomic_long_t flush_tlb_gru_zero_asid;
 
 	atomic_long_t copy_gpa;
+	atomic_long_t read_gpa;
 
 	atomic_long_t mesq_receive;
 	atomic_long_t mesq_receive_none;

