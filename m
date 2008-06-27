Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbYF0S1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbYF0S1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbYF0SZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:52 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11695 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757988AbYF0SZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:49 -0400
Date: Fri, 27 Jun 2008 12:13:33 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 9/13] EDAC core fix static to dynamic kset
Message-ID: <48652dcd.9e9yZTQQua24d8I6%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

Static kobjects and ksets are not supported in
Linux kernel.  Convert the mc_kset from static
to dynamic.  This patch depends on my previous
patch to remove the module parameter attributes
from mc...

Signed-off-by:  Arthur Jones <ajones@riverbed.com>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
---
 edac_mc_sysfs.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
@@ -645,7 +645,7 @@ static struct kobj_type ktype_mci = {
 /* EDAC memory controller sysfs kset:
  *	/sys/devices/system/edac/mc
  */
-static struct kset mc_kset;
+static struct kset *mc_kset;
 
 /*
  * edac_mc_register_sysfs_main_kobj
@@ -676,7 +676,7 @@ int edac_mc_register_sysfs_main_kobj(str
 	}
 
 	/* this instance become part of the mc_kset */
-	kobj_mci->kset = &mc_kset;
+	kobj_mci->kset = mc_kset;
 
 	/* register the mc<id> kobject to the mc_kset */
 	err = kobject_init_and_add(kobj_mci, &ktype_mci, NULL,
@@ -906,12 +906,9 @@ int edac_sysfs_setup_mc_kset(void)
 	}
 
 	/* Init the MC's kobject */
-	kobject_set_name(&mc_kset.kobj, "mc");
-	mc_kset.kobj.parent = &edac_class->kset.kobj;
-
-	/* register the mc_kset */
-	err = kset_register(&mc_kset);
-	if (err) {
+	mc_kset = kset_create_and_add("mc", NULL, &edac_class->kset.kobj);
+	if (!mc_kset) {
+		err = -ENOMEM;
 		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
 		goto fail_out;
 	}
@@ -933,6 +930,6 @@ fail_out:
  */
 void edac_sysfs_teardown_mc_kset(void)
 {
-	kset_unregister(&mc_kset);
+	kset_unregister(mc_kset);
 }
 
