Return-Path: <linux-kernel-owner+w=401wt.eu-S1764186AbXKCARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764186AbXKCARd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbXKCADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:35047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762283AbXKCADg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH 51/54] kset: convert acpi to use kset_create
Date: Fri,  2 Nov 2007 16:59:29 -0700
Message-Id: <1194047972-9850-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/bus.c      |   12 ++++++++----
 drivers/acpi/system.c   |    2 +-
 include/acpi/acpi_bus.h |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index fe90513..8be7567 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -744,7 +744,7 @@ static int __init acpi_bus_init(void)
 	return -ENODEV;
 }
 
-decl_subsys(acpi, NULL);
+struct kset *acpi_kset;
 
 static int __init acpi_init(void)
 {
@@ -756,10 +756,14 @@ static int __init acpi_init(void)
 		return -ENODEV;
 	}
 
-	result = firmware_register(&acpi_subsys);
-	if (result < 0)
-		printk(KERN_WARNING "%s: firmware_register error: %d\n",
+	acpi_kset = kset_create_and_register("acpi", NULL, NULL,
+					     firmware_kset);
+	if (IS_ERR(acpi_kset)) {
+		result = PTR_ERR(acpi_kset);
+		printk(KERN_WARNING "%s: kset create error: %d\n",
 			__FUNCTION__, result);
+		acpi_kset = NULL;
+	}
 
 	result = acpi_bus_init();
 
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index edee280..a9eb14c 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -135,7 +135,7 @@ static int acpi_system_sysfs_init(void)
 	int table_index = 0;
 	int result;
 
-	tables_kobj.parent = &acpi_subsys.kobj;
+	tables_kobj.parent = &acpi_kset->kobj;
 	kobject_set_name(&tables_kobj, "tables");
 	result = kobject_register(&tables_kobj);
 	if (result)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 19c3ead..17514cb 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -318,7 +318,7 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-extern struct kset acpi_subsys;
+extern struct kset *acpi_kset;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 /*
  * External Functions
-- 
1.5.3.4

