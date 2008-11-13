Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYKMFRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYKMFRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYKMFRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:17:40 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:45900 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYKMFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:17:39 -0500
Date: Thu, 13 Nov 2008 00:17:36 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [STABLE PATCH .26 .27] ACPI: avoid empty file name in sysfs
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0811130015100.3128@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Gruber <nokos@gmx.net>

upstream 4feba70a2c1a1a0c96909f657f48b2e11e682370

Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
allowed to have an empty signature and /sys/firmware/acpi/tables uses the
signature as filename.  Applications using naive recursion through /sys
loop forever.  A possible solution would be: (replacing the zero length
filename with the string "NULL")

http://bugzilla.kernel.org/show_bug.cgi?id=11539

Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/system.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 1d74171..62ec75e 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -78,9 +78,15 @@ static ssize_t acpi_table_show(struct kobject *kobj,
 	    container_of(bin_attr, struct acpi_table_attr, attr);
 	struct acpi_table_header *table_header = NULL;
 	acpi_status status;
+	char name[ACPI_NAME_SIZE];
+
+	if (strncmp(table_attr->name, "NULL", 4))
+		memcpy(name, table_attr->name, ACPI_NAME_SIZE);
+	else
+		memcpy(name, "\0\0\0\0", 4);
 
 	status =
-	    acpi_get_table(table_attr->name, table_attr->instance,
+	    acpi_get_table(name, table_attr->instance,
 			   &table_header);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
@@ -95,21 +101,24 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
 	struct acpi_table_header *header = NULL;
 	struct acpi_table_attr *attr = NULL;
 
-	memcpy(table_attr->name, table_header->signature, ACPI_NAME_SIZE);
+	if (table_header->signature[0] != '\0')
+		memcpy(table_attr->name, table_header->signature,
+			ACPI_NAME_SIZE);
+	else
+		memcpy(table_attr->name, "NULL", 4);
 
 	list_for_each_entry(attr, &acpi_table_attr_list, node) {
-		if (!memcmp(table_header->signature, attr->name,
-			    ACPI_NAME_SIZE))
+		if (!memcmp(table_attr->name, attr->name, ACPI_NAME_SIZE))
 			if (table_attr->instance < attr->instance)
 				table_attr->instance = attr->instance;
 	}
 	table_attr->instance++;
 
 	if (table_attr->instance > 1 || (table_attr->instance == 1 &&
-					 !acpi_get_table(table_header->
-							 signature, 2,
-							 &header)))
-		sprintf(table_attr->name + 4, "%d", table_attr->instance);
+					!acpi_get_table
+					(table_header->signature, 2, &header)))
+		sprintf(table_attr->name + ACPI_NAME_SIZE, "%d",
+			table_attr->instance);
 
 	table_attr->attr.size = 0;
 	table_attr->attr.read = acpi_table_show;
-- 
1.6.0.4.617.g2baf

