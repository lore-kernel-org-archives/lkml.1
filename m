Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXKCAGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXKCAGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXKCABW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:41149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761759AbXKCABV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 19/54] kset: convert drivers/base/firmware.c kset_create_and_register
Date: Fri,  2 Nov 2007 16:58:57 -0700
Message-Id: <1194047972-9850-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index 336be04..d1c2ef4 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -11,15 +11,16 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/device.h>
 
 #include "base.h"
 
-static decl_subsys(firmware, NULL);
+static struct kset *firmware_kset;
 
 int firmware_register(struct kset *s)
 {
-	s->kobj.kset = &firmware_subsys;
+	s->kobj.kset = firmware_kset;
 	s->kobj.ktype = NULL;
 	return subsystem_register(s);
 }
@@ -31,7 +32,10 @@ void firmware_unregister(struct kset *s)
 
 int __init firmware_init(void)
 {
-	return subsystem_register(&firmware_subsys);
+	firmware_kset = kset_create_and_register("firmware", NULL, NULL, NULL);
+	if (IS_ERR(firmware_kset))
+		return PTR_ERR(firmware_kset);
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(firmware_register);
-- 
1.5.3.4

