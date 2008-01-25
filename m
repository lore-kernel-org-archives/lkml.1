Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYAYHbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYAYHbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbYAYHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:11 -0500
Received: from mail.suse.de ([195.135.220.2]:52729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbYAYHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 049/196] kobject: convert securityfs to use kobject_create
Date: Thu, 24 Jan 2008 23:09:47 -0800
Message-Id: <1201245134-4876-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 security/inode.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 9e42f5f..dfc5978 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -315,20 +315,19 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
-static decl_subsys(security, NULL);
+static struct kobject *security_kobj;
 
 static int __init securityfs_init(void)
 {
 	int retval;
 
-	security_subsys.kobj.kset = &kernel_subsys;
-	retval = subsystem_register(&security_subsys);
-	if (retval)
-		return retval;
+	security_kobj = kobject_create_and_add("security", &kernel_subsys.kobj);
+	if (!security_kobj)
+		return -EINVAL;
 
 	retval = register_filesystem(&fs_type);
 	if (retval)
-		subsystem_unregister(&security_subsys);
+		kobject_unregister(security_kobj);
 	return retval;
 }
 
-- 
1.5.3.8

