Return-Path: <linux-kernel-owner+w=401wt.eu-S1161459AbXECR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161459AbXECR3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161461AbXECR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:29:21 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:30041 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161459AbXECR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=roclOmaedu33tQPU+BHoJXJQ1vwPuy2BMFWbyJAXGHNyZxpM+K4kKrR7o6cb4xxEkoMPnFKwd8L0Dr1jAMWxmWvxirbf89+fFN2lzZhfG33OBIbmyqbgaTcwy1mMSwFCWAE13XWfJVMC4tSwVeNOLmPoKqWkYZ5HHikMxn0VkYk=
Date: Fri, 4 May 2007 02:23:15 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] cm4000_cs: fix error paths
Message-ID: <20070503172315.GA3491@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes error paths in module_init and probe
functions in cm4000_cs and cm4040_cs drivers.

Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/char/pcmcia/cm4000_cs.c |    9 +++++++--
 drivers/char/pcmcia/cm4040_cs.c |    7 ++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

Index: 2.6-git/drivers/char/pcmcia/cm4000_cs.c
===================================================================
--- 2.6-git.orig/drivers/char/pcmcia/cm4000_cs.c
+++ 2.6-git/drivers/char/pcmcia/cm4000_cs.c
@@ -1881,8 +1881,11 @@ static int cm4000_probe(struct pcmcia_de
 	init_waitqueue_head(&dev->readq);
 
 	ret = cm4000_config(link, i);
-	if (ret)
+	if (ret) {
+		dev_table[i] = NULL;
+		kfree(dev);
 		return ret;
+	}
 
 	class_device_create(cmm_class, NULL, MKDEV(major, i), NULL,
 			    "cmm%d", i);
@@ -1907,7 +1910,7 @@ static void cm4000_detach(struct pcmcia_
 	cm4000_release(link);
 
 	dev_table[devno] = NULL;
- 	kfree(dev);
+	kfree(dev);
 
 	class_device_destroy(cmm_class, MKDEV(major, devno));
 
@@ -1956,12 +1959,14 @@ static int __init cmm_init(void)
 	if (major < 0) {
 		printk(KERN_WARNING MODULE_NAME
 			": could not get major number\n");
+		class_destroy(cmm_class);
 		return major;
 	}
 
 	rc = pcmcia_register_driver(&cm4000_driver);
 	if (rc < 0) {
 		unregister_chrdev(major, DEVICE_NAME);
+		class_destroy(cmm_class);
 		return rc;
 	}
 
Index: 2.6-git/drivers/char/pcmcia/cm4040_cs.c
===================================================================
--- 2.6-git.orig/drivers/char/pcmcia/cm4040_cs.c
+++ 2.6-git/drivers/char/pcmcia/cm4040_cs.c
@@ -636,8 +636,11 @@ static int reader_probe(struct pcmcia_de
 	setup_timer(&dev->poll_timer, cm4040_do_poll, 0);
 
 	ret = reader_config(link, i);
-	if (ret)
+	if (ret) {
+		dev_table[i] = NULL;
+		kfree(dev);
 		return ret;
+	}
 
 	class_device_create(cmx_class, NULL, MKDEV(major, i), NULL,
 			    "cmx%d", i);
@@ -708,12 +711,14 @@ static int __init cm4040_init(void)
 	if (major < 0) {
 		printk(KERN_WARNING MODULE_NAME
 			": could not get major number\n");
+		class_destroy(cmx_class);
 		return major;
 	}
 
 	rc = pcmcia_register_driver(&reader_driver);
 	if (rc < 0) {
 		unregister_chrdev(major, DEVICE_NAME);
+		class_destroy(cmx_class);
 		return rc;
 	}
 
