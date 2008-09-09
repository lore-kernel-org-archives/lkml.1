Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYIITle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYIITle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYIITl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:41:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:24431 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYIITlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=uxCe35xPJWWhnrDzt47QIxjzn0GsK2qmxIxhA3iS6WDxuQo9KtlteAhrcVL5QtWvUr
         +1pZQWhkJh82wlGMWOQOOtC4IQ3A3+QyeFz3RYedYi+VV6BwOXgXCEL/SCOl3mk2lCs6
         mW3mwZvAHfdNE6NsXi5ztNPiJRbzkFfWPfUh4=
Date: Tue, 9 Sep 2008 23:34:35 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: forcedeth: option to disable 100Hz timer (try 2)
Message-ID: <20080909233435.7eafede1@laska>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/_1qdSCkY/=3xK2VNJYf9caQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/_1qdSCkY/=3xK2VNJYf9caQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On some hardware no TX done interrupts are generated, thus special
100Hz timer interrupt is required to handle this situation properly.
Other device do not require that timer interrupt feature. 

Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
Unfortunately, nobody know the actual list of broken devices, so all
device has this flag on. Other problem, this flag is not user visible,
so the kernel recompilation is required to disable timer interrupts and
test a device.

This patch add a "disable_timerirq" option to disable interrupt 
timer mentioned above. This may be extremely useful for laptop users.

Mikhail Kshevetskiy

--MP_/_1qdSCkY/=3xK2VNJYf9caQ
Content-Type: text/x-patch; name=forcedeth.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=forcedeth.diff

--- linux-2.6.27-rc5/drivers/net/forcedeth.c.orig	2008-09-02 00:58:07.000000000 +0400
+++ linux-2.6.27-rc5/drivers/net/forcedeth.c	2008-09-02 02:02:34.000000000 +0400
@@ -842,6 +842,16 @@
 static int poll_interval = -1;
 
 /*
+ * On some hardware no TX done interrupts are generated, thus special
+ * timer interrupt is required to handle this situation properly.
+ *
+ * Setting this variable to 1 leads to removing DEV_NEED_TIMERIRQ from
+ * the driver_data flags and thus disable 100Hz timer mentioned above.
+ * This may be extremely usefull for laptop users.
+ */
+static int disable_timerirq = 0;
+
+/*
  * MSI interrupts
  */
 enum {
@@ -5704,7 +5714,7 @@
 			np->msi_flags |= 0x0001;
 	}
 
-	if (id->driver_data & DEV_NEED_TIMERIRQ)
+	if (id->driver_data & DEV_NEED_TIMERIRQ && !disable_timerirq)
 		np->irqmask |= NVREG_IRQ_TIMER;
 	if (id->driver_data & DEV_NEED_LINKTIMER) {
 		dprintk(KERN_INFO "%s: link timer on.\n", pci_name(pci_dev));
@@ -6180,6 +6190,8 @@
 MODULE_PARM_DESC(dma_64bit, "High DMA is enabled by setting to 1 and disabled by setting to 0.");
 module_param(phy_cross, int, 0);
 MODULE_PARM_DESC(phy_cross, "Phy crossover detection for Realtek 8201 phy is enabled by setting to 1 and disabled by setting to 0.");
+module_param(disable_timerirq, int, 0);
+MODULE_PARM_DESC(disable_timerirq, "100Hz timer required for some hardware is disabled by setting to 1 and enabled by setting to 0.");
 
 MODULE_AUTHOR("Manfred Spraul <manfred@colorfullife.com>");
 MODULE_DESCRIPTION("Reverse Engineered nForce ethernet driver");

--MP_/_1qdSCkY/=3xK2VNJYf9caQ--
