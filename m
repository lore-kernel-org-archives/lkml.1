Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZATUd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZATUd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762173AbZATUcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:32:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZATUco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:32:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Suspned/resume can't work on the 2.6.29-rc1 but it can work well on the 2.6.28
Date: Tue, 20 Jan 2009 21:32:04 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Zhao Yakui <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <1232413680.3971.32.camel@yakui_zhao.sh.intel.com> <20090120074534.GE16426@elte.hu>
In-Reply-To: <20090120074534.GE16426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202132.04682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009, Ingo Molnar wrote:
> 
> * Zhao Yakui <yakui.zhao@intel.com> wrote:
> 
> > Hi, All
> >     I do some tests about suspend/resume on my two boxes. One is HP
> > laptop and the other is Asus EEEPC901. The suspend/resume can't work
> > well. Even after core is selected as the test mode, it still can't work
> > well.(echo core > /sys/power/pm_test)
> >     
> >     Then I do the same test by using the 2.6.28 kernel. And
> > suspend/resume can work well.
> >     
> >     Of course I will try to use the git-bisect to identify the first bad 
> > commit ASAP.
> 
> make sure you try this patch from Rafael first (it's not on lkml it 
> appears - Rafael, mind resending the patch to this thread?):

Appended, and it is at:
http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commit;h=aa8c6c93747f7b55fa11e1624fec8ca33763a805
 
> Subject: [PATCH] PCI PM: Restore standard config registers of all devices early
>         (was: Re: EeePC resume failure - timers)
> 
> 	Ingo

However, first please verify if the patches from

http://bugzilla.kernel.org/show_bug.cgi?id=12495 (3 patches)
http://bugzilla.kernel.org/show_bug.cgi?id=12422 (1 patch)

on top of the current mainline fix the problem.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI PM: Restore standard config registers of all devices early

There is a problem in our handling of suspend-resume of PCI devices
that many of them have their standard config registers restored with
interrupts enabled and they are put into the full power state with
interrupts enabled as well.  This may lead to the following scenario:
* an interrupt vector is shared between two or more devices
* one device is resumed earlier and generates an interrupt
* the interrupt handler of another device tries to handle it and
  attempts to access the device the config space of which hasn't
  been restored yet and/or which still is in a low power state
* the system crashes as a result

To prevent this from happening we should restore the standard
configuration registers of all devices with interrupts disabled and
we should put them into the D0 power state right after that.
Unfortunately, this cannot be done using the existing
pci_set_power_state(), because it can sleep.  Also, to do it we have
to make sure that the config spaces of all devices were actually
saved during suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   91 +++++++++++++----------------------------------
 drivers/pci/pci.c        |   63 +++++++++++++++++++++++++++++---
 drivers/pci/pci.h        |    6 +++
 include/linux/pci.h      |    5 ++
 4 files changed, 95 insertions(+), 70 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -355,17 +355,27 @@ static int pci_legacy_suspend(struct dev
 	int i = 0;
 
 	if (drv && drv->suspend) {
+		pci_dev->state_saved = false;
+
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
-	} else {
-		pci_save_state(pci_dev);
-		/*
-		 * This is for compatibility with existing code with legacy PM
-		 * support.
-		 */
-		pci_pm_set_unknown_state(pci_dev);
+		if (i)
+			return i;
+
+		if (pci_dev->state_saved)
+			goto Fixup;
+
+		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
+			goto Fixup;
 	}
 
+	pci_save_state(pci_dev);
+	/*
+	 * This is for compatibility with existing code with legacy PM support.
+	 */
+	pci_pm_set_unknown_state(pci_dev);
+
+ Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
 	return i;
@@ -386,81 +396,34 @@ static int pci_legacy_suspend_late(struc
 
 static int pci_legacy_resume_early(struct device *dev)
 {
-	int error = 0;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
-
-	if (drv && drv->resume_early)
-		error = drv->resume_early(pci_dev);
-	return error;
+	return drv && drv->resume_early ?
+			drv->resume_early(pci_dev) : 0;
 }
 
 static int pci_legacy_resume(struct device *dev)
 {
-	int error;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
-	if (drv && drv->resume) {
-		error = drv->resume(pci_dev);
-	} else {
-		/* restore the PCI config space */
-		pci_restore_state(pci_dev);
-		error = pci_pm_reenable_device(pci_dev);
-	}
-	return error;
+	return drv && drv->resume ?
+			drv->resume(pci_dev) : pci_pm_reenable_device(pci_dev);
 }
 
 /* Auxiliary functions used by the new power management framework */
 
-static int pci_restore_standard_config(struct pci_dev *pci_dev)
-{
-	struct pci_dev *parent = pci_dev->bus->self;
-	int error = 0;
-
-	/* Check if the device's bus is operational */
-	if (!parent || parent->current_state == PCI_D0) {
-		pci_restore_state(pci_dev);
-		pci_update_current_state(pci_dev, PCI_D0);
-	} else {
-		dev_warn(&pci_dev->dev, "unable to restore config, "
-			"bridge %s in low power state D%d\n", pci_name(parent),
-			parent->current_state);
-		pci_dev->current_state = PCI_UNKNOWN;
-		error = -EAGAIN;
-	}
-
-	return error;
-}
-
-static bool pci_is_bridge(struct pci_dev *pci_dev)
-{
-	return !!(pci_dev->subordinate);
-}
-
 static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
 {
-	if (pci_restore_standard_config(pci_dev))
-		pci_fixup_device(pci_fixup_resume_early, pci_dev);
+	pci_restore_standard_config(pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 }
 
 static int pci_pm_default_resume(struct pci_dev *pci_dev)
 {
-	/*
-	 * pci_restore_standard_config() should have been called once already,
-	 * but it would have failed if the device's parent bridge had not been
-	 * in power state D0 at that time.  Check it and try again if necessary.
-	 */
-	if (pci_dev->current_state == PCI_UNKNOWN) {
-		int error = pci_restore_standard_config(pci_dev);
-		if (error)
-			return error;
-	}
-
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
 	if (!pci_is_bridge(pci_dev))
@@ -575,11 +538,11 @@ static int pci_pm_resume_noirq(struct de
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	pci_pm_default_resume_noirq(pci_dev);
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
-	pci_pm_default_resume_noirq(pci_dev);
-
 	if (drv && drv->pm && drv->pm->resume_noirq)
 		error = drv->pm->resume_noirq(dev);
 
@@ -730,11 +693,11 @@ static int pci_pm_restore_noirq(struct d
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	pci_pm_default_resume_noirq(pci_dev);
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
-	pci_pm_default_resume_noirq(pci_dev);
-
 	if (drv && drv->pm && drv->pm->restore_noirq)
 		error = drv->pm->restore_noirq(dev);
 
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -22,7 +22,7 @@
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
-unsigned int pci_pm_d3_delay = 10;
+unsigned int pci_pm_d3_delay = PCI_PM_D3_WAIT;
 
 #ifdef CONFIG_PCI_DOMAINS
 int pci_domains_supported = 1;
@@ -426,6 +426,7 @@ static inline int platform_pci_sleep_wak
  *                           given PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
+ * @wait: If 'true', wait for the device to change its power state
  *
  * RETURN VALUE:
  * -EINVAL if the requested state is invalid.
@@ -435,7 +436,7 @@ static inline int platform_pci_sleep_wak
  * 0 if device's power state has been successfully changed.
  */
 static int
-pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
+pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state, bool wait)
 {
 	u16 pmcsr;
 	bool need_restore = false;
@@ -480,8 +481,10 @@ pci_raw_set_power_state(struct pci_dev *
 		break;
 	case PCI_UNKNOWN: /* Boot-up */
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
-		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))
+		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET)) {
 			need_restore = true;
+			wait = true;
+		}
 		/* Fall-through: force to D0 */
 	default:
 		pmcsr = 0;
@@ -491,12 +494,15 @@ pci_raw_set_power_state(struct pci_dev *
 	/* enter specified state */
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
+	if (!wait)
+		return 0;
+
 	/* Mandatory power management transition delays */
 	/* see PCI PM 1.1 5.6.1 table 18 */
 	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
 		msleep(pci_pm_d3_delay);
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
-		udelay(200);
+		udelay(PCI_PM_D2_DELAY);
 
 	dev->current_state = state;
 
@@ -515,7 +521,7 @@ pci_raw_set_power_state(struct pci_dev *
 	if (need_restore)
 		pci_restore_bars(dev);
 
-	if (dev->bus->self)
+	if (wait && dev->bus->self)
 		pcie_aspm_pm_state_change(dev->bus->self);
 
 	return 0;
@@ -585,7 +591,7 @@ int pci_set_power_state(struct pci_dev *
 	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
 		return 0;
 
-	error = pci_raw_set_power_state(dev, state);
+	error = pci_raw_set_power_state(dev, state, true);
 
 	if (state > PCI_D0 && platform_pci_power_manageable(dev)) {
 		/* Allow the platform to finalize the transition */
@@ -730,6 +736,7 @@ pci_save_state(struct pci_dev *dev)
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++)
 		pci_read_config_dword(dev, i * 4,&dev->saved_config_space[i]);
+	dev->state_saved = true;
 	if ((i = pci_save_pcie_state(dev)) != 0)
 		return i;
 	if ((i = pci_save_pcix_state(dev)) != 0)
@@ -1374,6 +1381,50 @@ void pci_allocate_cap_save_buffers(struc
 }
 
 /**
+ * pci_restore_standard_config - restore standard config registers of PCI device
+ * @dev: PCI device to handle
+ *
+ * This function assumes that the device's configuration space is accessible.
+ * If the device needs to be powered up, the function will wait for it to
+ * change the state.
+ */
+int pci_restore_standard_config(struct pci_dev *dev)
+{
+	pci_power_t prev_state;
+	int error;
+
+	pci_restore_state(dev);
+	pci_update_current_state(dev, PCI_D0);
+
+	prev_state = dev->current_state;
+	if (prev_state == PCI_D0)
+		return 0;
+
+	error = pci_raw_set_power_state(dev, PCI_D0, false);
+	if (error)
+		return error;
+
+	if (pci_is_bridge(dev)) {
+		if (prev_state > PCI_D1)
+			mdelay(PCI_PM_BUS_WAIT);
+	} else {
+		switch(prev_state) {
+		case PCI_D3cold:
+		case PCI_D3hot:
+			mdelay(pci_pm_d3_delay);
+			break;
+		case PCI_D2:
+			udelay(PCI_PM_D2_DELAY);
+			break;
+		}
+	}
+
+	dev->current_state = PCI_D0;
+
+	return 0;
+}
+
+/**
  * pci_enable_ari - enable ARI forwarding if hardware support it
  * @dev: the PCI device
  */
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -117,6 +117,10 @@ typedef int __bitwise pci_power_t;
 #define PCI_UNKNOWN	((pci_power_t __force) 5)
 #define PCI_POWER_ERROR	((pci_power_t __force) -1)
 
+#define PCI_PM_D2_DELAY	200
+#define PCI_PM_D3_WAIT	10
+#define PCI_PM_BUS_WAIT	50
+
 /** The pci_channel state describes connectivity between the CPU and
  *  the pci device.  If some PCI bus between here and the pci device
  *  has crashed or locked up, this info is reflected here.
@@ -252,6 +256,7 @@ struct pci_dev {
 	unsigned int	ari_enabled:1;	/* ARI forwarding */
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
+	unsigned int	state_saved:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -49,6 +49,12 @@ extern void pci_disable_enabled_device(s
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
+extern int pci_restore_standard_config(struct pci_dev *dev);
+
+static inline bool pci_is_bridge(struct pci_dev *pci_dev)
+{
+	return !!(pci_dev->subordinate);
+}
 
 extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
 extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);

