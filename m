Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbYAYI02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbYAYI02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761047AbYAYIBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:08 -0500
Received: from ns.suse.de ([195.135.220.2]:59475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763718AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Domsch <Matt_Domsch@dell.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 112/196] Kobject: change drivers/firmware/efivars.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:21 -0800
Message-Id: <1201246425-5058-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7f9f086..b61a72f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -617,16 +617,16 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 	*(short_name + strlen(short_name)) = '-';
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
-	kobject_set_name(&new_efivar->kobj, "%s", short_name);
 	new_efivar->kobj.kset = vars_kset;
-	new_efivar->kobj.ktype = &efivar_ktype;
-	i = kobject_register(&new_efivar->kobj);
+	i = kobject_init_and_add(&new_efivar->kobj, &efivar_ktype, NULL,
+				 "%s", short_name);
 	if (i) {
 		kfree(short_name);
 		kfree(new_efivar);
 		return 1;
 	}
 
+	kobject_uevent(&new_efivar->kobj, KOBJ_ADD);
 	kfree(short_name);
 	short_name = NULL;
 
-- 
1.5.3.8

