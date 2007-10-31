Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXJaFMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXJaFMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXJaFMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:12:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbXJaFMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:12:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/6] kobject: check for duplicate names in kobject_rename
Date: Tue, 30 Oct 2007 22:11:41 -0700
Message-Id: <1193807505-3821-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193807505-3821-1-git-send-email-gregkh@suse.de>
References: <20071031050954.GA3791@kroah.com>
 <1193807505-3821-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This should catch any duplicate names before we try to tell sysfs to
rename the object.  This happens a lot with older versions of udev and
the network rename scripts.

Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 03d4036..a7e3bf4 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -308,6 +308,19 @@ int kobject_rename(struct kobject * kobj, const char *new_name)
 	if (!kobj->parent)
 		return -EINVAL;
 
+	/* see if this name is already in use */
+	if (kobj->kset) {
+		struct kobject *temp_kobj;
+		temp_kobj = kset_find_obj(kobj->kset, new_name);
+		if (temp_kobj) {
+			printk(KERN_WARNING "kobject '%s' can not be renamed "
+			       "to '%s' as '%s' is already in existance.\n",
+			       kobject_name(kobj), new_name, new_name);
+			kobject_put(temp_kobj);
+			return -EINVAL;
+		}
+	}
+
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
 	if (!devpath) {
 		error = -ENOMEM;
-- 
1.5.3.4

