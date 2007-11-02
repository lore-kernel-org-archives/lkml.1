Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXKCABx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXKCABx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761505AbXKCAA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:41040 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761468AbXKCAA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 06/54] kset: convert securityfs to use kset_create
Date: Fri,  2 Nov 2007 16:58:44 -0700
Message-Id: <1194047972-9850-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 security/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 9e42f5f..9071d81 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -315,20 +315,20 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
-static decl_subsys(security, NULL);
+static struct kset *security_kset;
 
 static int __init securityfs_init(void)
 {
 	int retval;
 
-	security_subsys.kobj.kset = &kernel_subsys;
-	retval = subsystem_register(&security_subsys);
-	if (retval)
-		return retval;
+	security_kset = kset_create_and_register("security", NULL, NULL,
+						 &kernel_subsys);
+	if (IS_ERR(security_kset))
+		return PTR_ERR(security_kset);
 
 	retval = register_filesystem(&fs_type);
 	if (retval)
-		subsystem_unregister(&security_subsys);
+		kset_unregister(security_kset);
 	return retval;
 }
 
-- 
1.5.3.4

