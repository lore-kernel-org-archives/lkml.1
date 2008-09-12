Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYILB1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYILB1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 21:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYILB0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 21:26:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:35509 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYILB0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 21:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QV+eZZBrkcHVnCErJ81U7hQMDiDMveAPJKJVg1pDaSsIktiaufY2j73Ogoh0cNH8QC
         /gcGCSdAINVKUl9CbHHCiohmDStmMLuloR54JZtDVqXCAk1zVL49OiDps5Difzk2pzpm
         xb5nP2vJEdrl1tdm7RlZKRTDkQw8CVyefE5R8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: check dsdt before find oem table for es7000
Date: Thu, 11 Sep 2008 18:25:47 -0700
Message-Id: <1221182747-11481-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mach-generic/es7000.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/mach-generic/es7000.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6/arch/x86/mach-generic/es7000.c
@@ -47,16 +47,28 @@ static __init int mps_oem_check(struct m
 /* Hook from generic ACPI tables.c */
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	unsigned long oem_addr;
+	unsigned long oem_addr = 0;
+	int check_dsdt;
+	int ret = 0;
+
+	/* check dsdt at first to avoid clear fix_map for oem_addr */
+	check_dsdt = es7000_check_dsdt();
+
 	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
+		if (check_dsdt)
+			ret = parse_unisys_oem((char *)oem_addr);
 		else {
 			setup_unisys();
-			return 1;
+			ret = 1;
 		}
+		/*
+		 * we may need to unmap it, if we have __acpi_unmap_table()
+		 */
+#if 0
+		unmap_unisys_acpi_oem_table(oem_addr);
+#endif
 	}
-	return 0;
+	return ret;
 }
 #else
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
