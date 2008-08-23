Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYHWVF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYHWVF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 17:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYHWVFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 17:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYHWVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 17:05:14 -0400
Date: Sat, 23 Aug 2008 14:05:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, carlos@strangeworlds.co.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Fix oops in acer_wmi
Message-ID: <20080823140509.4b197021@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current kerneloops.org stats, acer_wmi is pretty high on the
list for 2.6.27-rc:
http://www.kerneloops.org/search.php?search=acer_wmi_init

this is due to a null pointer due to a misordered initialization...
when the DMI quirks get run, the "interface" variable might not have been initialized.
The patch below 1) prevents the oops and 2) runs the quirks again after all the "interface"
initialization has completed.

This oops is new in 2.6.27-rc and thus counts as a regression...


--- linux.trees.git/drivers/misc/acer-wmi.c~	2008-08-23 13:59:22.000000000 -0700
+++ linux.trees.git/drivers/misc/acer-wmi.c	2008-08-23 14:00:32.000000000 -0700
@@ -192,6 +192,9 @@ static struct quirk_entry *quirks;
 
 static void set_quirks(void)
 {
+	if (!interface)
+		return;
+
 	if (quirks->mailled)
 		interface->capability |= ACER_CAP_MAILLED;
 
@@ -1237,6 +1240,8 @@ static int __init acer_wmi_init(void)
 		return -ENODEV;
 	}
 
+	set_quirks();
+
 	if (platform_driver_register(&acer_platform_driver)) {
 		printk(ACER_ERR "Unable to register platform driver.\n");
 		goto error_platform_register;
