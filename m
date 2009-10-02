Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZJBB5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZJBB5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZJBB5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:57:14 -0400
Received: from kroah.org ([198.145.64.141]:33027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZJBBcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012410.821540276@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [033/136] PM / yenta: Fix cardbus suspend/resume regression
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=pm-yenta-fix-cardbus-suspend-resume-regression.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 0c570cdeb8fdfcb354a3e9cd81bfc6a09c19de0c upstream.

Since 2.6.29 the PCI PM core have been restoring the standard
configuration registers of PCI devices in the early phase of
resume.  In particular, PCI devices without drivers have been handled
this way since commit 355a72d75b3b4f4877db4c9070c798238028ecb5
(PCI: Rework default handling of suspend and resume).  Unfortunately,
this leads to post-resume problems with CardBus devices which cannot
be accessed in the early phase of resume, because the sockets they
are on have not been woken up yet at that point.

To solve this problem, move the yenta socket resume to the early
phase of resume and, analogously, move the suspend of it to the late
phase of suspend.  Additionally, remove some unnecessary PCI code
from the yenta socket's resume routine.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13092, which is a
post-2.6.28 regression.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Florian <fs-kernelbugzilla@spline.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/yenta_socket.c |   92 ++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 42 deletions(-)

--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1225,60 +1225,71 @@ static int __devinit yenta_probe (struct
 }
 
 #ifdef CONFIG_PM
-static int yenta_dev_suspend (struct pci_dev *dev, pm_message_t state)
+static int yenta_dev_suspend_noirq(struct device *dev)
 {
-	struct yenta_socket *socket = pci_get_drvdata(dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct yenta_socket *socket = pci_get_drvdata(pdev);
 	int ret;
 
-	ret = pcmcia_socket_dev_suspend(&dev->dev);
+	ret = pcmcia_socket_dev_suspend(dev);
 
-	if (socket) {
-		if (socket->type && socket->type->save_state)
-			socket->type->save_state(socket);
-
-		/* FIXME: pci_save_state needs to have a better interface */
-		pci_save_state(dev);
-		pci_read_config_dword(dev, 16*4, &socket->saved_state[0]);
-		pci_read_config_dword(dev, 17*4, &socket->saved_state[1]);
-		pci_disable_device(dev);
-
-		/*
-		 * Some laptops (IBM T22) do not like us putting the Cardbus
-		 * bridge into D3.  At a guess, some other laptop will
-		 * probably require this, so leave it commented out for now.
-		 */
-		/* pci_set_power_state(dev, 3); */
-	}
+	if (!socket)
+		return ret;
+
+	if (socket->type && socket->type->save_state)
+		socket->type->save_state(socket);
+
+	pci_save_state(pdev);
+	pci_read_config_dword(pdev, 16*4, &socket->saved_state[0]);
+	pci_read_config_dword(pdev, 17*4, &socket->saved_state[1]);
+	pci_disable_device(pdev);
+
+	/*
+	 * Some laptops (IBM T22) do not like us putting the Cardbus
+	 * bridge into D3.  At a guess, some other laptop will
+	 * probably require this, so leave it commented out for now.
+	 */
+	/* pci_set_power_state(dev, 3); */
 
 	return ret;
 }
 
-
-static int yenta_dev_resume (struct pci_dev *dev)
+static int yenta_dev_resume_noirq(struct device *dev)
 {
-	struct yenta_socket *socket = pci_get_drvdata(dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct yenta_socket *socket = pci_get_drvdata(pdev);
+	int ret;
 
-	if (socket) {
-		int rc;
+	if (!socket)
+		return 0;
 
-		pci_set_power_state(dev, 0);
-		/* FIXME: pci_restore_state needs to have a better interface */
-		pci_restore_state(dev);
-		pci_write_config_dword(dev, 16*4, socket->saved_state[0]);
-		pci_write_config_dword(dev, 17*4, socket->saved_state[1]);
+	pci_write_config_dword(pdev, 16*4, socket->saved_state[0]);
+	pci_write_config_dword(pdev, 17*4, socket->saved_state[1]);
 
-		rc = pci_enable_device(dev);
-		if (rc)
-			return rc;
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
 
-		pci_set_master(dev);
+	pci_set_master(pdev);
 
-		if (socket->type && socket->type->restore_state)
-			socket->type->restore_state(socket);
-	}
+	if (socket->type && socket->type->restore_state)
+		socket->type->restore_state(socket);
 
-	return pcmcia_socket_dev_resume(&dev->dev);
+	return pcmcia_socket_dev_resume(dev);
 }
+
+static struct dev_pm_ops yenta_pm_ops = {
+	.suspend_noirq = yenta_dev_suspend_noirq,
+	.resume_noirq = yenta_dev_resume_noirq,
+	.freeze_noirq = yenta_dev_suspend_noirq,
+	.thaw_noirq = yenta_dev_resume_noirq,
+	.poweroff_noirq = yenta_dev_suspend_noirq,
+	.restore_noirq = yenta_dev_resume_noirq,
+};
+
+#define YENTA_PM_OPS	(&yenta_pm_ops)
+#else
+#define YENTA_PM_OPS	NULL
 #endif
 
 #define CB_ID(vend,dev,type)				\
@@ -1376,10 +1387,7 @@ static struct pci_driver yenta_cardbus_d
 	.id_table	= yenta_table,
 	.probe		= yenta_probe,
 	.remove		= __devexit_p(yenta_close),
-#ifdef CONFIG_PM
-	.suspend	= yenta_dev_suspend,
-	.resume		= yenta_dev_resume,
-#endif
+	.driver.pm	= YENTA_PM_OPS,
 };
 
 


