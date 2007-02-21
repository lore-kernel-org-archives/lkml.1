Return-Path: <linux-kernel-owner+w=401wt.eu-S1161215AbXBUKCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161215AbXBUKCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXBUKCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:02:43 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:54597 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179AbXBUKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:02:26 -0500
Date: Wed, 21 Feb 2007 11:02:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] New header file ipl.h
Message-ID: <20070221100226.GH13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] New header file ipl.h

Setup.h has been misused for ipl related stuff in the past. We now move
everything, which has to do with ipl and reipl to a new header file named
"ipl.h".

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |    1 
 arch/s390/kernel/ipl.c   |   24 ---------
 arch/s390/kernel/setup.c |    1 
 arch/s390/kernel/smp.c   |    1 
 drivers/s390/cio/cio.c   |    1 
 include/asm-s390/ipl.h   |  113 +++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-s390/setup.h |   74 ------------------------------
 7 files changed, 119 insertions(+), 96 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	2007-02-21 10:47:30.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-02-21 10:47:30.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
+#include <asm/ipl.h>
 #include <asm/lowcore.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-02-21 10:47:30.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
+#include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
 #include <asm/cpcmd.h>
@@ -94,27 +95,6 @@ static char *shutdown_action_str(enum sh
 	}
 }
 
-enum diag308_subcode  {
-	DIAG308_IPL   = 3,
-	DIAG308_DUMP  = 4,
-	DIAG308_SET   = 5,
-	DIAG308_STORE = 6,
-};
-
-enum diag308_ipl_type {
-	DIAG308_IPL_TYPE_FCP = 0,
-	DIAG308_IPL_TYPE_CCW = 2,
-};
-
-enum diag308_opt {
-	DIAG308_IPL_OPT_IPL  = 0x10,
-	DIAG308_IPL_OPT_DUMP = 0x20,
-};
-
-enum diag308_rc {
-	DIAG308_RC_OK = 1,
-};
-
 static int diag308_set_works = 0;
 
 static int reipl_capabilities = IPL_TYPE_UNKNOWN;
@@ -134,7 +114,7 @@ static struct ipl_parameter_block *dump_
 
 static enum shutdown_action on_panic_action = SHUTDOWN_STOP;
 
-static int diag308(unsigned long subcode, void *addr)
+int diag308(unsigned long subcode, void *addr)
 {
 	register unsigned long _addr asm("0") = (unsigned long) addr;
 	register unsigned long _rc asm("1") = 0;
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-02-21 10:47:30.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-02-21 10:47:30.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/ctype.h>
 #include <linux/reboot.h>
 
+#include <asm/ipl.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/smp.h>
diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-02-21 10:47:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-02-21 10:47:31.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/timex.h>
+#include <asm/ipl.h>
 #include <asm/setup.h>
 #include <asm/sigp.h>
 #include <asm/pgalloc.h>
diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-02-21 10:47:11.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-02-21 10:47:31.000000000 +0100
@@ -21,6 +21,7 @@
 #include <asm/irq_regs.h>
 #include <asm/setup.h>
 #include <asm/reset.h>
+#include <asm/ipl.h>
 #include "airq.h"
 #include "cio.h"
 #include "css.h"
diff -urpN linux-2.6/include/asm-s390/ipl.h linux-2.6-patched/include/asm-s390/ipl.h
--- linux-2.6/include/asm-s390/ipl.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/ipl.h	2007-02-21 10:47:31.000000000 +0100
@@ -0,0 +1,113 @@
+/*
+ * s390 (re)ipl support
+ *
+ * Copyright IBM Corp. 2007
+ */
+
+#ifndef _ASM_S390_IPL_H
+#define _ASM_S390_IPL_H
+
+#include <asm/types.h>
+
+#define IPL_PARMBLOCK_ORIGIN	0x2000
+
+#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_fcp))
+
+#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_ccw))
+
+#define IPL_MAX_SUPPORTED_VERSION (0)
+
+#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
+				 IPL_PARMBLOCK_ORIGIN)
+#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
+
+struct ipl_list_hdr {
+	u32 len;
+	u8  reserved1[3];
+	u8  version;
+	u32 blk0_len;
+	u8  pbt;
+	u8  flags;
+	u16 reserved2;
+} __attribute__((packed));
+
+struct ipl_block_fcp {
+	u8  reserved1[313-1];
+	u8  opt;
+	u8  reserved2[3];
+	u16 reserved3;
+	u16 devno;
+	u8  reserved4[4];
+	u64 wwpn;
+	u64 lun;
+	u32 bootprog;
+	u8  reserved5[12];
+	u64 br_lba;
+	u32 scp_data_len;
+	u8  reserved6[260];
+	u8  scp_data[];
+} __attribute__((packed));
+
+struct ipl_block_ccw {
+	u8  load_param[8];
+	u8  reserved1[84];
+	u8  reserved2[2];
+	u16 devno;
+	u8  vm_flags;
+	u8  reserved3[3];
+	u32 vm_parm_len;
+} __attribute__((packed));
+
+struct ipl_parameter_block {
+	struct ipl_list_hdr hdr;
+	union {
+		struct ipl_block_fcp fcp;
+		struct ipl_block_ccw ccw;
+	} ipl_info;
+} __attribute__((packed));
+
+/*
+ * IPL validity flags and parameters as detected in head.S
+ */
+extern u32 ipl_flags;
+extern u16 ipl_devno;
+
+extern void do_reipl(void);
+extern void ipl_save_parameters(void);
+
+enum {
+	IPL_DEVNO_VALID		= 1,
+	IPL_PARMBLOCK_VALID	= 2,
+	IPL_NSS_VALID		= 4,
+};
+
+/*
+ * DIAG 308 support
+ */
+enum diag308_subcode  {
+	DIAG308_REL_HSA	= 2,
+	DIAG308_IPL	= 3,
+	DIAG308_DUMP	= 4,
+	DIAG308_SET	= 5,
+	DIAG308_STORE	= 6,
+};
+
+enum diag308_ipl_type {
+	DIAG308_IPL_TYPE_FCP	= 0,
+	DIAG308_IPL_TYPE_CCW	= 2,
+};
+
+enum diag308_opt {
+	DIAG308_IPL_OPT_IPL	= 0x10,
+	DIAG308_IPL_OPT_DUMP	= 0x20,
+};
+
+enum diag308_rc {
+	DIAG308_RC_OK	= 1,
+};
+
+extern int diag308(unsigned long subcode, void *addr);
+
+#endif /* _ASM_S390_IPL_H */
diff -urpN linux-2.6/include/asm-s390/setup.h linux-2.6-patched/include/asm-s390/setup.h
--- linux-2.6/include/asm-s390/setup.h	2007-02-21 10:47:14.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/setup.h	2007-02-21 10:47:31.000000000 +0100
@@ -16,7 +16,6 @@
 
 #define PARMAREA		0x10400
 #define MEMORY_CHUNKS		16	/* max 0x7fff */
-#define IPL_PARMBLOCK_ORIGIN	0x2000
 
 #ifndef __ASSEMBLY__
 
@@ -97,82 +96,9 @@ extern char vmpoff_cmd[];
 #define SET_CONSOLE_3215	do { console_mode = 2; } while (0)
 #define SET_CONSOLE_3270	do { console_mode = 3; } while (0)
 
-struct ipl_list_hdr {
-	u32 len;
-	u8  reserved1[3];
-	u8  version;
-	u32 blk0_len;
-	u8  pbt;
-	u8  flags;
-	u16 reserved2;
-} __attribute__((packed));
-
-struct ipl_block_fcp {
-	u8  reserved1[313-1];
-	u8  opt;
-	u8  reserved2[3];
-	u16 reserved3;
-	u16 devno;
-	u8  reserved4[4];
-	u64 wwpn;
-	u64 lun;
-	u32 bootprog;
-	u8  reserved5[12];
-	u64 br_lba;
-	u32 scp_data_len;
-	u8  reserved6[260];
-	u8  scp_data[];
-} __attribute__((packed));
-
-struct ipl_block_ccw {
-	u8  load_param[8];
-	u8  reserved1[84];
-	u8  reserved2[2];
-	u16 devno;
-	u8  vm_flags;
-	u8  reserved3[3];
-	u32 vm_parm_len;
-} __attribute__((packed));
-
-struct ipl_parameter_block {
-	struct ipl_list_hdr hdr;
-	union {
-		struct ipl_block_fcp fcp;
-		struct ipl_block_ccw ccw;
-	} ipl_info;
-} __attribute__((packed));
-
-#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_fcp))
-
-#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_ccw))
-
-#define IPL_MAX_SUPPORTED_VERSION (0)
-
-/*
- * IPL validity flags and parameters as detected in head.S
- */
-extern u32 ipl_flags;
-extern u16 ipl_devno;
-
-extern void do_reipl(void);
-extern void ipl_save_parameters(void);
-
-enum {
-	IPL_DEVNO_VALID	= 1,
-	IPL_PARMBLOCK_VALID = 2,
-	IPL_NSS_VALID = 4,
-};
-
 #define NSS_NAME_SIZE	8
-
 extern char kernel_nss_name[];
 
-#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
-				 IPL_PARMBLOCK_ORIGIN)
-#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
-
 #else /* __ASSEMBLY__ */
 
 #ifndef __s390x__
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

