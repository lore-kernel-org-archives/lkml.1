Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbYJKHCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbYJKHCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbYJKGlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:41:14 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:39136 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYJKGgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:51 -0400
Date: Sat, 11 Oct 2008 02:35:30 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 10/85] ACPICA: Allow same ACPI table to be loaded/unloaded more
 than once
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <33fcba0da215beffe0b13ec734eff21b5825f62a.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Without this change, a table cannot be loaded again once it has
been loaded/unloaded one time. The current mechanism does not
unregister a table upon an unload. During a load, if the same
table is found, this no longer returns an exception.

http://www.acpica.org/bugzilla/show_bug.cgi?id=722

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables/tbinstal.c |   49 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/tables/tbinstal.c b/drivers/acpi/tables/tbinstal.c
index b22185f..905dc38 100644
--- a/drivers/acpi/tables/tbinstal.c
+++ b/drivers/acpi/tables/tbinstal.c
@@ -145,6 +145,8 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 			}
 		}
 
+		/* Check for a table match on the entire table length */
+
 		length = ACPI_MIN(table_desc->length,
 				  acpi_gbl_root_table_list.tables[i].length);
 		if (ACPI_MEMCMP(table_desc->pointer,
@@ -153,17 +155,49 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 			continue;
 		}
 
-		/* Table is already registered */
-
+		/*
+		 * Note: the current mechanism does not unregister a table if it is
+		 * dynamically unloaded. The related namespace entries are deleted,
+		 * but the table remains in the root table list.
+		 *
+		 * The assumption here is that the number of different tables that
+		 * will be loaded is actually small, and there is minimal overhead
+		 * in just keeping the table in case it is needed again.
+		 *
+		 * If this assumption changes in the future (perhaps on large
+		 * machines with many table load/unload operations), tables will
+		 * need to be unregistered when they are unloaded, and slots in the
+		 * root table list should be reused when empty.
+		 */
+
+		/*
+		 * Table is already registered.
+		 * We can delete the table that was passed as a parameter.
+		 */
 		acpi_tb_delete_table(table_desc);
 		*table_index = i;
-		status = AE_ALREADY_EXISTS;
-		goto release;
+
+		if (acpi_gbl_root_table_list.tables[i].
+		    flags & ACPI_TABLE_IS_LOADED) {
+
+			/* Table is still loaded, this is an error */
+
+			status = AE_ALREADY_EXISTS;
+			goto release;
+		} else {
+			/* Table was unloaded, allow it to be reloaded */
+
+			table_desc->pointer =
+			    acpi_gbl_root_table_list.tables[i].pointer;
+			table_desc->address =
+			    acpi_gbl_root_table_list.tables[i].address;
+			status = AE_OK;
+			goto print_header;
+		}
 	}
 
-	/*
-	 * Add the table to the global table list
-	 */
+	/* Add the table to the global root table list */
+
 	status = acpi_tb_store_table(table_desc->address, table_desc->pointer,
 				     table_desc->length, table_desc->flags,
 				     table_index);
@@ -171,6 +205,7 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
 		goto release;
 	}
 
+      print_header:
 	acpi_tb_print_table_header(table_desc->address, table_desc->pointer);
 
       release:
-- 
1.5.5.1

