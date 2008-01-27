Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYA0Xkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYA0Xkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbYA0XkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:40:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbYA0XkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:40:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] Module: check to see if we have a built in module with the same name
Date: Sun, 27 Jan 2008 15:38:40 -0800
Message-Id: <1201477122-4541-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080127233751.GA4524@kroah.com>
References: <20080127233751.GA4524@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to load a module with the same name as a built-in one, a
scary kobject backtrace comes up.  Prevent that from checking for this
condition and warning the user as to what exactly is going on.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1bb4c5e..76ddc85 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1214,6 +1214,7 @@ void module_remove_modinfo_attrs(struct module *mod)
 int mod_sysfs_init(struct module *mod)
 {
 	int err;
+	struct kobject *kobj;
 
 	if (!module_sysfs_initialized) {
 		printk(KERN_ERR "%s: module sysfs not initialized\n",
@@ -1221,6 +1222,15 @@ int mod_sysfs_init(struct module *mod)
 		err = -EINVAL;
 		goto out;
 	}
+
+	kobj = kset_find_obj(module_kset, mod->name);
+	if (kobj) {
+		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
+		kobject_put(kobj);
+		err = -EINVAL;
+		goto out;
+	}
+
 	mod->mkobj.mod = mod;
 
 	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
-- 
1.5.3.8

