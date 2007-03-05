Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXCEWvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXCEWvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXCEWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:51:16 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:11208 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXCEWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:51:05 -0500
Date: Mon, 5 Mar 2007 23:44:11 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] cio/ipl: Clean interface between cio and ipl code.
Message-ID: <20070305224411.GO22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] cio/ipl: Clean interface between cio and ipl code.

Clean interface between cio and ipl code, so Peter stops complaining.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |   23 ++++++++++++++++++++++-
 drivers/s390/cio/cio.c |   38 ++++++++++----------------------------
 include/asm-s390/cio.h |    7 +++++++
 include/asm-s390/ipl.h |    3 +--
 4 files changed, 40 insertions(+), 31 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-03-05 22:51:50.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-03-05 22:52:03.000000000 +0100
@@ -47,7 +47,7 @@ enum ipl_type {
  * Must be in data section since the bss section
  * is not cleared when these are accessed.
  */
-u16 ipl_devno __attribute__((__section__(".data"))) = 0;
+static u16 ipl_devno __attribute__((__section__(".data"))) = 0;
 u32 ipl_flags __attribute__((__section__(".data"))) = 0;
 
 static char *ipl_type_str(enum ipl_type type)
@@ -1039,6 +1039,27 @@ static int __init s390_ipl_init(void)
 
 __initcall(s390_ipl_init);
 
+void __init ipl_save_parameters(void)
+{
+	struct cio_iplinfo iplinfo;
+	unsigned int *ipl_ptr;
+	void *src, *dst;
+
+	if (cio_get_iplinfo(&iplinfo))
+		return;
+
+	ipl_devno = iplinfo.devno;
+	ipl_flags |= IPL_DEVNO_VALID;
+	if (!iplinfo.is_qdio)
+		return;
+	ipl_flags |= IPL_PARMBLOCK_VALID;
+	ipl_ptr = (unsigned int *)__LC_IPL_PARMBLOCK_PTR;
+	src = (void *)(unsigned long)*ipl_ptr;
+	dst = (void *)IPL_PARMBLOCK_ORIGIN;
+	memmove(dst, src, PAGE_SIZE);
+	*ipl_ptr = IPL_PARMBLOCK_ORIGIN;
+}
+
 static LIST_HEAD(rcall);
 static DEFINE_MUTEX(rcall_mutex);
 
diff -urpN linux-2.6/drivers/s390/cio/cio.c linux-2.6-patched/drivers/s390/cio/cio.c
--- linux-2.6/drivers/s390/cio/cio.c	2007-03-05 22:51:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/cio.c	2007-03-05 22:52:03.000000000 +0100
@@ -1048,37 +1048,19 @@ void reipl_ccw_dev(struct ccw_dev_id *de
 	do_reipl_asm(*((__u32*)&schid));
 }
 
-static struct schib __initdata ipl_schib;
-
-/*
- * ipl_save_parameters gets called very early. It is not allowed to access
- * anything in the bss section at all. The bss section is not cleared yet,
- * but may contain some ipl parameters written by the firmware.
- * These parameters (if present) are copied to 0x2000.
- * To avoid corruption of the ipl parameters, all variables used by this
- * function must reside on the stack or in the data section.
- */
-void ipl_save_parameters(void)
+int __init cio_get_iplinfo(struct cio_iplinfo *iplinfo)
 {
 	struct subchannel_id schid;
-	unsigned int *ipl_ptr;
-	void *src, *dst;
+	struct schib schib;
 
 	schid = *(struct subchannel_id *)__LC_SUBCHANNEL_ID;
 	if (!schid.one)
-		return;
-	if (stsch(schid, &ipl_schib))
-		return;
-	if (!ipl_schib.pmcw.dnv)
-		return;
-	ipl_devno = ipl_schib.pmcw.dev;
-	ipl_flags |= IPL_DEVNO_VALID;
-	if (!ipl_schib.pmcw.qf)
-		return;
-	ipl_flags |= IPL_PARMBLOCK_VALID;
-	ipl_ptr = (unsigned int *)__LC_IPL_PARMBLOCK_PTR;
-	src = (void *)(unsigned long)*ipl_ptr;
-	dst = (void *)IPL_PARMBLOCK_ORIGIN;
-	memmove(dst, src, PAGE_SIZE);
-	*ipl_ptr = IPL_PARMBLOCK_ORIGIN;
+		return -ENODEV;
+	if (stsch(schid, &schib))
+		return -ENODEV;
+	if (!schib.pmcw.dnv)
+		return -ENODEV;
+	iplinfo->devno = schib.pmcw.dev;
+	iplinfo->is_qdio = schib.pmcw.qf;
+	return 0;
 }
diff -urpN linux-2.6/include/asm-s390/cio.h linux-2.6-patched/include/asm-s390/cio.h
--- linux-2.6/include/asm-s390/cio.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/cio.h	2007-03-05 22:52:03.000000000 +0100
@@ -292,6 +292,13 @@ extern void css_schedule_reprobe(void);
 
 extern void reipl_ccw_dev(struct ccw_dev_id *id);
 
+struct cio_iplinfo {
+	u16 devno;
+	int is_qdio;
+};
+
+extern int cio_get_iplinfo(struct cio_iplinfo *iplinfo);
+
 #endif
 
 #endif
diff -urpN linux-2.6/include/asm-s390/ipl.h linux-2.6-patched/include/asm-s390/ipl.h
--- linux-2.6/include/asm-s390/ipl.h	2007-03-05 22:51:50.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/ipl.h	2007-03-05 22:52:03.000000000 +0100
@@ -69,10 +69,9 @@ struct ipl_parameter_block {
 } __attribute__((packed));
 
 /*
- * IPL validity flags and parameters as detected in head.S
+ * IPL validity flags
  */
 extern u32 ipl_flags;
-extern u16 ipl_devno;
 
 extern u32 dump_prefix_page;
 extern void do_reipl(void);
