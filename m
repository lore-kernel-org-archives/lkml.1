Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbXHHImm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbXHHImm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXHHImc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:42:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62312 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXHHImb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uXdVHa3Ndag6pn9oF+mZWgXBldOZ0USMTLMeBWk3+kNaaQ4zZ9HjYgdT64TijLwR2iDmmp7b93TclzmYLDyBuo6NaNwuLW2euXpGM+/TDB5B1m1cdP4/th8tWGeezUdA2g2FnRjUibHNvi7a16BgZlSoJ0dGdjBk+9QOU4lGhrQ=
Date: Wed, 8 Aug 2007 16:43:34 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: hmh@hmh.eng.br
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] thinkpad acpi module_exit fix
Message-ID: <20070808164334.GA2732@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[This fix is not very good for the global variable, any comments are
welcome.]

The thinkpad_acpi module_init fail out entrace is not very properly. if
failing before register driver or before create sysfs file, the
module_exit will try to remove nonexist sysfs files, the kernel will
oops.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/misc/thinkpad_acpi.c |   19 +++++++++++++------
1 file changed, 13 insertions(+), 6 deletions(-)

diff -upr linux/drivers/misc/thinkpad_acpi.c linux.new/drivers/misc/thinkpad_acpi.c
--- linux/drivers/misc/thinkpad_acpi.c	2007-08-08 16:28:19.000000000 +0000
+++ linux.new/drivers/misc/thinkpad_acpi.c	2007-08-08 16:35:11.000000000 +0000
@@ -91,6 +91,8 @@ MODULE_LICENSE("GPL");
 
 /* Please remove this in year 2009 */
 MODULE_ALIAS("ibm_acpi");
+static int sysfs_ret = 1;
+static int driver_ret = 1;
 
 /*
  * DMI matching for module autoloading
@@ -4662,14 +4664,14 @@ static int __init thinkpad_acpi_module_i
 	}
 	proc_dir->owner = THIS_MODULE;
 
-	ret = platform_driver_register(&tpacpi_pdriver);
-	if (ret) {
+	driver_ret = platform_driver_register(&tpacpi_pdriver);
+	if (driver_ret) {
 		printk(IBM_ERR "unable to register platform driver\n");
 		thinkpad_acpi_module_exit();
 		return ret;
 	}
-	ret = tpacpi_create_driver_attributes(&tpacpi_pdriver.driver);
-	if (ret) {
+	sysfs_ret = tpacpi_create_driver_attributes(&tpacpi_pdriver.driver);
+	if (sysfs_ret) {
 		printk(IBM_ERR "unable to create sysfs driver attributes\n");
 		thinkpad_acpi_module_exit();
 		return ret;
@@ -4756,8 +4758,13 @@ static void thinkpad_acpi_module_exit(vo
 	if (tpacpi_pdev)
 		platform_device_unregister(tpacpi_pdev);
 
-	tpacpi_remove_driver_attributes(&tpacpi_pdriver.driver);
-	platform_driver_unregister(&tpacpi_pdriver);
+	if(!sysfs_ret){
+		tpacpi_remove_driver_attributes(&tpacpi_pdriver.driver);
+	}
+
+	if(!driver_ret){
+		platform_driver_unregister(&tpacpi_pdriver);
+	}
 
 	if (proc_dir)
 		remove_proc_entry(IBM_PROC_DIR, acpi_root_dir);
