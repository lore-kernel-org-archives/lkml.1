Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYIAXU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYIAXU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYIAXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:18:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45263 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYIAXSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=uo/BcWU6EhLhFVfWSHLIHPInjd4E+REwusvcPNylBLr+xNnE0U/bqwyxGzKlgbdlv0
         F6OGivlLlPv55wq28bajG9FAGKFpL2tgde2M42+ycO3Ntj6erKu1zor2h9yOSy4npTI/
         4YR2Vh1++EHTH/L1Va//dreeQyVTzEfF2tQ4s=
Date: Tue, 2 Sep 2008 02:47:48 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: forcedeth: option to disable 100Hz timer
Message-ID: <20080902024748.5528d1bb@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/gj=i6bn66HD.IZ1pWG3_Rll"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/gj=i6bn66HD.IZ1pWG3_Rll
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On some hardware no TX done interrupts are generated, thus special
100Hz timer interrupt is required to handle this situation properly.
Other device do not require that timer interrupt feature.

Patch add a "disable_timerirq" option to disable interrupt timer 
mentioned above. This may be extremely usefull for laptop users.

Mikhail Kshevetskiy

--MP_/gj=i6bn66HD.IZ1pWG3_Rll
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

--MP_/gj=i6bn66HD.IZ1pWG3_Rll--
