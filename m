Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616Ab0ASXDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab0ASXDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473Ab0ASXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:03:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0ASXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:03:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for January 18 (pci + pm)
Date: Wed, 20 Jan 2010 00:04:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20100118195743.b45f119e.sfr@canb.auug.org.au> <20100118154424.d54c0e3e.randy.dunlap@oracle.com>
In-Reply-To: <20100118154424.d54c0e3e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001200004.07654.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010, Randy Dunlap wrote:
> On Mon, 18 Jan 2010 19:57:43 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100114:
> 
> 
> drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
> drivers/pci/pci-driver.c:991: error: implicit declaration of function 'pci_pm_default_resume_early'
> drivers/pci/pci-driver.c: At top level:
> drivers/pci/pci-driver.c:1027: error: 'pci_pm_prepare' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1028: error: 'pci_pm_complete' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1029: error: 'pci_pm_suspend' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1030: error: 'pci_pm_resume' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1031: error: 'pci_pm_freeze' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1032: error: 'pci_pm_thaw' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1033: error: 'pci_pm_poweroff' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1034: error: 'pci_pm_restore' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1035: error: 'pci_pm_suspend_noirq' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1036: error: 'pci_pm_resume_noirq' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1037: error: 'pci_pm_freeze_noirq' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1038: error: 'pci_pm_thaw_noirq' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1039: error: 'pci_pm_poweroff_noirq' undeclared here (not in a function)
> drivers/pci/pci-driver.c:1040: error: 'pci_pm_restore_noirq' undeclared here (not in a function)
> 
> 
> partial config:
> 
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM_OPS=y
> 
> 
> Full config is attached.

Ah, too many ifdefs.

Thanks, the patch below fixes that for me.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / PM: Fix compilation for set CONFIG_PM_RUNTIME and CONFIG_PM_SLEEP unset

Fix failure to compile drivers/pci/pci-driver.c for CONFIG_PM_RUNTIME
set and CONFIG_PM_SLEEP is unset, introduced by the PCI run-time
power management patches.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/pci-driver.c |   61 +++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -405,6 +405,35 @@ static void pci_device_shutdown(struct d
 	pci_msix_shutdown(pci_dev);
 }
 
+#ifdef CONFIG_PM_OPS
+
+/* Auxiliary functions used for system resume and run-time resume. */
+
+/**
+ * pci_restore_standard_config - restore standard config registers of PCI device
+ * @pci_dev: PCI device to handle
+ */
+static int pci_restore_standard_config(struct pci_dev *pci_dev)
+{
+	pci_update_current_state(pci_dev, PCI_UNKNOWN);
+
+	if (pci_dev->current_state != PCI_D0) {
+		int error = pci_set_power_state(pci_dev, PCI_D0);
+		if (error)
+			return error;
+	}
+
+	return pci_restore_state(pci_dev);
+}
+
+static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
+{
+	pci_restore_standard_config(pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
+}
+
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 
 /*
@@ -521,29 +550,6 @@ static int pci_legacy_resume(struct devi
 
 /* Auxiliary functions used by the new power management framework */
 
-/**
- * pci_restore_standard_config - restore standard config registers of PCI device
- * @pci_dev: PCI device to handle
- */
-static int pci_restore_standard_config(struct pci_dev *pci_dev)
-{
-	pci_update_current_state(pci_dev, PCI_UNKNOWN);
-
-	if (pci_dev->current_state != PCI_D0) {
-		int error = pci_set_power_state(pci_dev, PCI_D0);
-		if (error)
-			return error;
-	}
-
-	return pci_restore_state(pci_dev);
-}
-
-static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
-{
-	pci_restore_standard_config(pci_dev);
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
-}
-
 static void pci_pm_default_resume(struct pci_dev *pci_dev)
 {
 	pci_fixup_device(pci_fixup_resume, pci_dev);
@@ -607,6 +613,13 @@ static void pci_pm_complete(struct devic
 		drv->pm->complete(dev);
 }
 
+#else /* !CONFIG_PM_SLEEP */
+
+#define pci_pm_prepare	NULL
+#define pci_pm_complete	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 #ifdef CONFIG_SUSPEND
 
 static int pci_pm_suspend(struct device *dev)
@@ -943,8 +956,6 @@ static int pci_pm_restore(struct device 
 
 #endif /* !CONFIG_HIBERNATION */
 
-#endif /* !CONFIG_PM_SLEEP */
-
 #ifdef CONFIG_PM_RUNTIME
 
 static int pci_pm_runtime_suspend(struct device *dev)
