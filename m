Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYIYG2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYIYG2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYIYG2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:28:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:25259 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYIYG2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pYsk6B417OHoxNa5y9mE/Ne2/9PnBvbsjiW6LuXkk0HRhJYl3PhqWT2838XqoIPfSF
         ZUX/d4HhPvERJpN1b9xk34AuToTwJjKjtLXOYhVbsmjEEbfr7KlU8MfKIFmMSklR1QMY
         aE5Fvi23Tvxqg9VDbw00ohCPjjz6wwnfoX89E=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak
Date: Wed, 24 Sep 2008 23:27:28 -0700
Message-Id: <1222324048-13853-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use early_acpi_os_unmap_memory

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/dmar.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -42,6 +42,7 @@
 LIST_HEAD(dmar_drhd_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
+static acpi_size __initdata dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
@@ -296,9 +297,13 @@ static int __init dmar_table_detect(void
 {
 	acpi_status status = AE_OK;
 
+	if (dmar_tbl)
+		early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
+
 	/* if we could find DMAR table, then there are DMAR devices */
-	status = acpi_get_table(ACPI_SIG_DMAR, 0,
-				(struct acpi_table_header **)&dmar_tbl);
+	status = acpi_get_table_with_size(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl,
+				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
 		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
