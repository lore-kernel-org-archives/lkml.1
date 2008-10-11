Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYJKHiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYJKHiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYJKHgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:36:54 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:48084 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYJKHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:36:53 -0400
Date: Sat, 11 Oct 2008 02:35:32 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 12/85] ACPICA: Fix table compare code, length then data
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <14ec9a5d33f848336a3f4b74633fc810658fa9b8.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Split the ACPI table compare. First check that the lengths match
exactly. Then compare the data.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables/tbinstal.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/tables/tbinstal.c b/drivers/acpi/tables/tbinstal.c
index 905dc38..18747ce 100644
--- a/drivers/acpi/tables/tbinstal.c
+++ b/drivers/acpi/tables/tbinstal.c
@@ -110,7 +110,6 @@ acpi_status
 acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 {
 	u32 i;
-	u32 length;
 	acpi_status status = AE_OK;
 
 	ACPI_FUNCTION_TRACE(tb_add_table);
@@ -145,13 +144,18 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 			}
 		}
 
-		/* Check for a table match on the entire table length */
+		/*
+		 * Check for a table match on the entire table length,
+		 * not just the header.
+		 */
+		if (table_desc->length !=
+		    acpi_gbl_root_table_list.tables[i].length) {
+			continue;
+		}
 
-		length = ACPI_MIN(table_desc->length,
-				  acpi_gbl_root_table_list.tables[i].length);
 		if (ACPI_MEMCMP(table_desc->pointer,
 				acpi_gbl_root_table_list.tables[i].pointer,
-				length)) {
+				acpi_gbl_root_table_list.tables[i].length)) {
 			continue;
 		}
 
-- 
1.5.5.1

