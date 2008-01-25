Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYAYIIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYAYIIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763776AbYAYIAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:59400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764055AbYAYH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Domsch <Matt_Domsch@dell.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 111/196] Kobject: change drivers/firmware/edd.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:20 -0800
Message-Id: <1201246425-5058-32-git-send-email-gregkh@suse.de>
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
 drivers/firmware/edd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index ddcc957..dc0b87b 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -721,13 +721,13 @@ edd_device_register(struct edd_device *edev, int i)
 	if (!edev)
 		return 1;
 	edd_dev_set_info(edev, i);
-	kobject_set_name(&edev->kobj, "int13_dev%02x",
-			 0x80 + i);
 	edev->kobj.kset = edd_kset;
-	edev->kobj.ktype = &edd_ktype;
-	error = kobject_register(&edev->kobj);
-	if (!error)
+	error = kobject_init_and_add(&edev->kobj, &edd_ktype, NULL,
+				     "int13_dev%02x", 0x80 + i);
+	if (!error) {
 		edd_populate_dir(edev);
+		kobject_uevent(&edev->kobj, KOBJ_ADD);
+	}
 	return error;
 }
 
-- 
1.5.3.8

