Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYAYIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYAYIb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764108AbYAYIBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:23 -0500
Received: from ns.suse.de ([195.135.220.2]:59484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763925AbYAYH76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 162/196] Kobject: convert kernel/module.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:33:11 -0800
Message-Id: <1201246425-5058-83-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0ae8117..89cd4c7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1217,18 +1217,16 @@ int mod_sysfs_init(struct module *mod)
 		err = -EINVAL;
 		goto out;
 	}
-	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
-	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
-	if (err)
-		goto out;
-	mod->mkobj.kobj.kset = module_kset;
-	mod->mkobj.kobj.ktype = &module_ktype;
 	mod->mkobj.mod = mod;
 
-	kobject_init(&mod->mkobj.kobj);
+	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
+	mod->mkobj.kobj.kset = module_kset;
+	err = kobject_init_and_add(&mod->mkobj.kobj, &module_ktype, NULL,
+				   "%s", mod->name);
+	if (err)
+		kobject_put(&mod->mkobj.kobj);
 
 	/* delay uevent until full sysfs population */
-	err = kobject_add(&mod->mkobj.kobj);
 out:
 	return err;
 }
-- 
1.5.3.8

