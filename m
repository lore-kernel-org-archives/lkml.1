Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbYAYIj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbYAYIj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760771AbYAYIBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:59442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 121/196] Kobject: change arch/sh/kernel/cpu/sh4/sq.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:30 -0800
Message-Id: <1201246425-5058-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sh/kernel/cpu/sh4/sq.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh4/sq.c b/arch/sh/kernel/cpu/sh4/sq.c
index b22a78c..97fd9b9 100644
--- a/arch/sh/kernel/cpu/sh4/sq.c
+++ b/arch/sh/kernel/cpu/sh4/sq.c
@@ -341,17 +341,18 @@ static int __devinit sq_sysdev_add(struct sys_device *sysdev)
 {
 	unsigned int cpu = sysdev->id;
 	struct kobject *kobj;
+	int error;
 
 	sq_kobject[cpu] = kzalloc(sizeof(struct kobject), GFP_KERNEL);
 	if (unlikely(!sq_kobject[cpu]))
 		return -ENOMEM;
 
 	kobj = sq_kobject[cpu];
-	kobj->parent = &sysdev->kobj;
-	kobject_set_name(kobj, "%s", "sq");
-	kobj->ktype = &ktype_percpu_entry;
-
-	return kobject_register(kobj);
+	error = kobject_init_and_add(kobj, &ktype_percpu_entry, &sysdev->kobj,
+				     "%s", "sq");
+	if (!error)
+		kobject_uevent(kobj, KOBJ_ADD);
+	return error;
 }
 
 static int __devexit sq_sysdev_remove(struct sys_device *sysdev)
-- 
1.5.3.8

