Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXIOMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXIOMqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXIOMqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:46:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38668 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXIOMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:46:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Sep 2007 14:45:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: nodemgr: fix leak of struct csr1212_keyval
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.37945da3d080e083@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

csr1212_keep_keyval(kv) in nodemgr_process_root_directory was
unbalanced if ne->vendor_name_kv already exists.  This happens for
example if eth1394 or raw1394 modify the local config ROM and it is
parsed again.

As a bonus, the attempt to add the vendor_name_kv sysfs attribute
when it already exists is now fixed for good.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -1113,7 +1113,7 @@ static void nodemgr_process_root_directo
 {
 	unsigned int ud_id = 0;
 	struct csr1212_dentry *dentry;
-	struct csr1212_keyval *kv;
+	struct csr1212_keyval *kv, *vendor_name_kv = NULL;
 	u8 last_key_id = 0;
 
 	ne->needs_probe = 0;
@@ -1140,8 +1140,8 @@ static void nodemgr_process_root_directo
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_WIDTH(kv) == 0 &&
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_CHAR_SET(kv) == 0 &&
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_LANGUAGE(kv) == 0) {
-					ne->vendor_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					vendor_name_kv = kv;
 				}
 			}
 			break;
@@ -1150,10 +1150,13 @@ static void nodemgr_process_root_directo
 	}
 
 	if (ne->vendor_name_kv) {
-		int error = device_create_file(&ne->device,
-					       &dev_attr_ne_vendor_name_kv);
-
-		if (error && error != -EEXIST)
+		kv = ne->vendor_name_kv;
+		ne->vendor_name_kv = vendor_name_kv;
+		csr1212_release_keyval(kv);
+	} else if (vendor_name_kv) {
+		ne->vendor_name_kv = vendor_name_kv;
+		if (device_create_file(&ne->device,
+				       &dev_attr_ne_vendor_name_kv) != 0)
 			HPSB_ERR("Failed to add sysfs attribute");
 	}
 }

-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/

