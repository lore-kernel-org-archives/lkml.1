Return-Path: <linux-kernel-owner+w=401wt.eu-S1765057AbYAYIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765057AbYAYIKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764041AbYAYIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:14 -0500
Received: from ns2.suse.de ([195.135.220.15]:53636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764056AbYAYH7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Len Brown <len.brown@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 119/196] Kobject: change drivers/acpi/system.c to use kobject_create_and_add
Date: Thu, 24 Jan 2008 23:32:28 -0800
Message-Id: <1201246425-5058-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register for this static kobject, as it's overkill.
This way is much simpler.

Cc: Len Brown <len.brown@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/system.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index c22b93a..5ffe0ea 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -58,7 +58,7 @@ module_param_call(acpica_version, NULL, param_get_acpica_version, NULL, 0444);
                               FS Interface (/sys)
    -------------------------------------------------------------------------- */
 static LIST_HEAD(acpi_table_attr_list);
-static struct kobject tables_kobj;
+static struct kobject *tables_kobj;
 
 struct acpi_table_attr {
 	struct bin_attribute attr;
@@ -135,11 +135,9 @@ static int acpi_system_sysfs_init(void)
 	int table_index = 0;
 	int result;
 
-	tables_kobj.parent = acpi_kobj;
-	kobject_set_name(&tables_kobj, "tables");
-	result = kobject_register(&tables_kobj);
-	if (result)
-		return result;
+	tables_kobj = kobject_create_and_add("tables", acpi_kobj);
+	if (!tables_kobj)
+		return -ENOMEM;
 
 	do {
 		result = acpi_get_table_by_index(table_index, &table_header);
@@ -153,7 +151,7 @@ static int acpi_system_sysfs_init(void)
 
 			acpi_table_attr_init(table_attr, table_header);
 			result =
-			    sysfs_create_bin_file(&tables_kobj,
+			    sysfs_create_bin_file(tables_kobj,
 						  &table_attr->attr);
 			if (result) {
 				kfree(table_attr);
@@ -163,6 +161,7 @@ static int acpi_system_sysfs_init(void)
 					      &acpi_table_attr_list);
 		}
 	} while (!result);
+	kobject_uevent(tables_kobj, KOBJ_ADD);
 
 	return 0;
 }
-- 
1.5.3.8

