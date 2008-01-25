Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbYAYHv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbYAYHv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761445AbYAYHfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:49808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761930AbYAYHfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH 090/196] kobject: convert /sys/firmware/acpi/ to use kobject_create
Date: Thu, 24 Jan 2008 23:31:59 -0800
Message-Id: <1201246425-5058-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/bus.c      |   11 ++++++-----
 drivers/acpi/system.c   |    2 +-
 include/acpi/acpi_bus.h |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 7c172d9..e550da6 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -743,7 +743,7 @@ static int __init acpi_bus_init(void)
 	return -ENODEV;
 }
 
-decl_subsys(acpi, NULL);
+struct kobject *acpi_kobj;
 
 static int __init acpi_init(void)
 {
@@ -755,10 +755,11 @@ static int __init acpi_init(void)
 		return -ENODEV;
 	}
 
-	result = firmware_register(&acpi_subsys);
-	if (result < 0)
-		printk(KERN_WARNING "%s: firmware_register error: %d\n",
-			__FUNCTION__, result);
+	acpi_kobj = kobject_create_and_add("acpi", &firmware_kset->kobj);
+	if (!acpi_kobj) {
+		printk(KERN_WARNING "%s: kset create error\n", __FUNCTION__);
+		acpi_kobj = NULL;
+	}
 
 	result = acpi_bus_init();
 
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index edee280..c22b93a 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -135,7 +135,7 @@ static int acpi_system_sysfs_init(void)
 	int table_index = 0;
 	int result;
 
-	tables_kobj.parent = &acpi_subsys.kobj;
+	tables_kobj.parent = acpi_kobj;
 	kobject_set_name(&tables_kobj, "tables");
 	result = kobject_register(&tables_kobj);
 	if (result)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 7b74b60..fb7171b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -319,7 +319,7 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-extern struct kset acpi_subsys;
+extern struct kobject *acpi_kobj;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 /*
  * External Functions
-- 
1.5.3.8

