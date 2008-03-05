Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbYCEFtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbYCEFtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYCEFtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:12 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYCEFtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=dHM6qmQWWqezsWjv+0H7HR7AHi+vvMLQuqA3qkr0YW207S/PfaFwyp5xLp1LZPySoARbnDJyWly+J3v/NoIfBxGad8+bdQD2I+vgYBKrAkJBZmkXRP4AIpSG3x1RV8261FJ/fOUTdUbgm8udu8TVWKHDRI4jH+LsNWoQdzd3Zds=
Message-ID: <47CE3458.3010906@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:49:12 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/11] /drivers/block/ps2esdi.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Jon Schindler <jkschind@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced init_module and cleanup_module with static functions and module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
---
diff --git a/drivers/block/ps2esdi.c b/drivers/block/ps2esdi.c
index 3c796e2..edcd150 100644
--- a/drivers/block/ps2esdi.c
+++ b/drivers/block/ps2esdi.c
@@ -135,7 +135,7 @@ static struct block_device_operations ps2esdi_fops =
 
 static struct gendisk *ps2esdi_gendisk[2];
 
-/* initialization routine called by ll_rw_blk.c   */
+/* initialization routine used when compiled into kernel   */
 static int __init ps2esdi_init(void)
 {
 
@@ -180,7 +180,10 @@ module_param_array(head, int, NULL, 0);
 module_param_array(sect, int, NULL, 0);
 MODULE_LICENSE("GPL");
 
-int init_module(void) {
+/* extra work needs to be done in addition to ps2esdi_init
+ * when compiled as a module */
+static int __init ps2esdi_init_module(void)
+{
 	int drive;
 
 	for(drive = 0; drive < MAX_HD; drive++) {
@@ -198,9 +201,10 @@ int init_module(void) {
 	}
 	return ps2esdi_init();
 }
+module_init(ps2esdi_init_module);
 
-void
-cleanup_module(void) {
+static void __exit ps2esdi_cleanup_module(void)
+{
 	int i;
 	if(ps2esdi_slot) {
 		mca_mark_as_unused(ps2esdi_slot);
@@ -216,6 +220,8 @@ cleanup_module(void) {
 		put_disk(ps2esdi_gendisk[i]);
 	}
 }
+module_exit(ps2esdi_cleanup_module);
+
 #endif /* MODULE */
 
 /* handles boot time command line parameters */
