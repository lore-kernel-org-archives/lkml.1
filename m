Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZJWX3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZJWX3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZJWX3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:29:33 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:50364
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbZJWX3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:29:33 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] bluetooth: remove useless variable in virtual hci driver
Date: Fri, 23 Oct 2009 21:29:35 -0200
Message-Id: <1256340575-19359-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac28494c has removed the option to give a minor number as
parameter for VHCI driver. Remove the variable used for that parameter.
Print the error code when registering the device fails, instead of the
requested minor number (which would always be MISC_DYNAMIC_MINOR).

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/bluetooth/hci_vhci.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index d5cde6d..74c094c 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -41,8 +41,6 @@
 
 #define VERSION "1.3"
 
-static int minor = MISC_DYNAMIC_MINOR;
-
 struct vhci_data {
 	struct hci_dev *hdev;
 
@@ -292,7 +290,7 @@ static const struct file_operations vhci_fops = {
 	.release	= vhci_release,
 };
 
-static struct miscdevice vhci_miscdev= {
+static struct miscdevice vhci_miscdev = {
 	.name	= "vhci",
 	.fops	= &vhci_fops,
 	.minor	= MISC_DYNAMIC_MINOR,
@@ -300,10 +298,13 @@ static struct miscdevice vhci_miscdev= {
 
 static int __init vhci_init(void)
 {
+	int r;
+
 	BT_INFO("Virtual HCI driver ver %s", VERSION);
 
-	if (misc_register(&vhci_miscdev) < 0) {
-		BT_ERR("Can't register misc device with minor %d", minor);
+	r = misc_register(&vhci_miscdev);
+	if (r < 0) {
+		BT_ERR("Can't register misc device: %d", r);
 		return -EIO;
 	}
 
@@ -312,8 +313,10 @@ static int __init vhci_init(void)
 
 static void __exit vhci_exit(void)
 {
-	if (misc_deregister(&vhci_miscdev) < 0)
-		BT_ERR("Can't unregister misc device with minor %d", minor);
+	int r;
+	r = misc_deregister(&vhci_miscdev);
+	if (r < 0)
+		BT_ERR("Can't unregister misc device: %d", r);
 }
 
 module_init(vhci_init);
-- 
1.6.3.3

