Return-Path: <linux-kernel-owner+w=401wt.eu-S1763948AbYDQJNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763948AbYDQJNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbYDQJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:58 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58956
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbYDQJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:54 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 05/45] s390: KVM preparation: split sysinfo defintions for kvm use
Date: Thu, 17 Apr 2008 12:10:10 +0300
Message-Id: <1208423450-29415-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

drivers/s390/sysinfo.c uses the store system information intruction to query
the system about information of the machine, the LPAR and additional
hypervisors. KVM has to implement the host part for this instruction.

To avoid code duplication, this patch splits the common definitions from
sysinfo.c into a separate header file include/asm-s390/sysinfo.h for KVM use.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/s390/sysinfo.c     |  100 +---------------------------------------
 include/asm-s390/sysinfo.h |  111 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 99 deletions(-)
 create mode 100644 include/asm-s390/sysinfo.h

diff --git a/drivers/s390/sysinfo.c b/drivers/s390/sysinfo.c
index 291ff62..43fffa3 100644
--- a/drivers/s390/sysinfo.c
+++ b/drivers/s390/sysinfo.c
@@ -11,111 +11,13 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/ebcdic.h>
+#include <asm/sysinfo.h>
 
 /* Sigh, math-emu. Don't ask. */
 #include <asm/sfp-util.h>
 #include <math-emu/soft-fp.h>
 #include <math-emu/single.h>
 
-struct sysinfo_1_1_1 {
-	char reserved_0[32];
-	char manufacturer[16];
-	char type[4];
-	char reserved_1[12];
-	char model_capacity[16];
-	char sequence[16];
-	char plant[4];
-	char model[16];
-};
-
-struct sysinfo_1_2_1 {
-	char reserved_0[80];
-	char sequence[16];
-	char plant[4];
-	char reserved_1[2];
-	unsigned short cpu_address;
-};
-
-struct sysinfo_1_2_2 {
-	char format;
-	char reserved_0[1];
-	unsigned short acc_offset;
-	char reserved_1[24];
-	unsigned int secondary_capability;
-	unsigned int capability;
-	unsigned short cpus_total;
-	unsigned short cpus_configured;
-	unsigned short cpus_standby;
-	unsigned short cpus_reserved;
-	unsigned short adjustment[0];
-};
-
-struct sysinfo_1_2_2_extension {
-	unsigned int alt_capability;
-	unsigned short alt_adjustment[0];
-};
-
-struct sysinfo_2_2_1 {
-	char reserved_0[80];
-	char sequence[16];
-	char plant[4];
-	unsigned short cpu_id;
-	unsigned short cpu_address;
-};
-
-struct sysinfo_2_2_2 {
-	char reserved_0[32];
-	unsigned short lpar_number;
-	char reserved_1;
-	unsigned char characteristics;
-	unsigned short cpus_total;
-	unsigned short cpus_configured;
-	unsigned short cpus_standby;
-	unsigned short cpus_reserved;
-	char name[8];
-	unsigned int caf;
-	char reserved_2[16];
-	unsigned short cpus_dedicated;
-	unsigned short cpus_shared;
-};
-
-#define LPAR_CHAR_DEDICATED	(1 << 7)
-#define LPAR_CHAR_SHARED	(1 << 6)
-#define LPAR_CHAR_LIMITED	(1 << 5)
-
-struct sysinfo_3_2_2 {
-	char reserved_0[31];
-	unsigned char count;
-	struct {
-		char reserved_0[4];
-		unsigned short cpus_total;
-		unsigned short cpus_configured;
-		unsigned short cpus_standby;
-		unsigned short cpus_reserved;
-		char name[8];
-		unsigned int caf;
-		char cpi[16];
-		char reserved_1[24];
-
-	} vm[8];
-};
-
-static inline int stsi(void *sysinfo, int fc, int sel1, int sel2)
-{
-	register int r0 asm("0") = (fc << 28) | sel1;
-	register int r1 asm("1") = sel2;
-
-	asm volatile(
-		"   stsi 0(%2)\n"
-		"0: jz   2f\n"
-		"1: lhi  %0,%3\n"
-		"2:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (r0) : "d" (r1), "a" (sysinfo), "K" (-ENOSYS)
-		: "cc", "memory" );
-	return r0;
-}
-
 static inline int stsi_0(void)
 {
 	int rc = stsi (NULL, 0, 0, 0);
diff --git a/include/asm-s390/sysinfo.h b/include/asm-s390/sysinfo.h
new file mode 100644
index 0000000..0e4d57e
--- /dev/null
+++ b/include/asm-s390/sysinfo.h
@@ -0,0 +1,111 @@
+/*
+ * definition for store system information stsi
+ *
+ * Copyright IBM Corp. 2001,2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Ulrich Weigand <weigand@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+struct sysinfo_1_1_1 {
+	char reserved_0[32];
+	char manufacturer[16];
+	char type[4];
+	char reserved_1[12];
+	char model_capacity[16];
+	char sequence[16];
+	char plant[4];
+	char model[16];
+};
+
+struct sysinfo_1_2_1 {
+	char reserved_0[80];
+	char sequence[16];
+	char plant[4];
+	char reserved_1[2];
+	unsigned short cpu_address;
+};
+
+struct sysinfo_1_2_2 {
+	char format;
+	char reserved_0[1];
+	unsigned short acc_offset;
+	char reserved_1[24];
+	unsigned int secondary_capability;
+	unsigned int capability;
+	unsigned short cpus_total;
+	unsigned short cpus_configured;
+	unsigned short cpus_standby;
+	unsigned short cpus_reserved;
+	unsigned short adjustment[0];
+};
+
+struct sysinfo_1_2_2_extension {
+	unsigned int alt_capability;
+	unsigned short alt_adjustment[0];
+};
+
+struct sysinfo_2_2_1 {
+	char reserved_0[80];
+	char sequence[16];
+	char plant[4];
+	unsigned short cpu_id;
+	unsigned short cpu_address;
+};
+
+struct sysinfo_2_2_2 {
+	char reserved_0[32];
+	unsigned short lpar_number;
+	char reserved_1;
+	unsigned char characteristics;
+	unsigned short cpus_total;
+	unsigned short cpus_configured;
+	unsigned short cpus_standby;
+	unsigned short cpus_reserved;
+	char name[8];
+	unsigned int caf;
+	char reserved_2[16];
+	unsigned short cpus_dedicated;
+	unsigned short cpus_shared;
+};
+
+#define LPAR_CHAR_DEDICATED	(1 << 7)
+#define LPAR_CHAR_SHARED	(1 << 6)
+#define LPAR_CHAR_LIMITED	(1 << 5)
+
+struct sysinfo_3_2_2 {
+	char reserved_0[31];
+	unsigned char count;
+	struct {
+		char reserved_0[4];
+		unsigned short cpus_total;
+		unsigned short cpus_configured;
+		unsigned short cpus_standby;
+		unsigned short cpus_reserved;
+		char name[8];
+		unsigned int caf;
+		char cpi[16];
+		char reserved_1[24];
+
+	} vm[8];
+};
+
+static inline int stsi(void *sysinfo, int fc, int sel1, int sel2)
+{
+	register int r0 asm("0") = (fc << 28) | sel1;
+	register int r1 asm("1") = sel2;
+
+	asm volatile(
+		"   stsi 0(%2)\n"
+		"0: jz   2f\n"
+		"1: lhi  %0,%3\n"
+		"2:\n"
+		EX_TABLE(0b, 1b)
+		: "+d" (r0) : "d" (r1), "a" (sysinfo), "K" (-ENOSYS)
+		: "cc", "memory");
+	return r0;
+}
-- 
1.5.5

