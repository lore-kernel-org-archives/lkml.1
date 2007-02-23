Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXBWXTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXBWXTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXBWXTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:19:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:54372 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265AbXBWXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/9] driver core: refcounting fix
Date: Fri, 23 Feb 2007 15:15:49 -0800
Message-Id: <11722725592291-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <11722725561867-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

Fix a reference counting bug exposed by commit
725522b5453dd680412f2b6463a988e4fd148757.  If driver.mod_name exists, we
take a reference in module_add_driver(), and never release it.  Undo that
reference in module_remove_driver().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8c25b1a..1ecf081 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2425,6 +2425,12 @@ void module_remove_driver(struct device_driver *drv)
 			kfree(driver_name);
 		}
 	}
+	/*
+	 * Undo the additional reference we added in module_add_driver()
+	 * via kset_find_obj()
+	 */
+	if (drv->mod_name)
+		kobject_put(&drv->kobj);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif
-- 
1.5.0.1

