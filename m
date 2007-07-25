Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXGYX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXGYX1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbXGYX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:26:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761612AbXGYX06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:26:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Date: Wed, 25 Jul 2007 19:26:44 -0400
User-Agent: KMail/1.9.5
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <200707251323.04594.lenb@kernel.org> <20070725115804.5b8efe83.akpm@linux-foundation.org>
In-Reply-To: <20070725115804.5b8efe83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251926.44656.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 14:58, Andrew Morton wrote:
> On Wed, 25 Jul 2007 13:23:04 -0400
> Len Brown <lenb@kernel.org> wrote:
> 
> > Andrew, you want to re-pull the acpi tree, or do you want me to send
> > you some patches on top of the current mm?
> 
> I'd appreciate a fix for this one, please - I'll drop it int he hot-fixes
> directory as quite a few people seem to be hitting this.

Maybe simpler for mm1 to go backwards in time rather than forwards.
This should fix the problem at hand.

cheers,
-Len

commit 106994f83cdd97c77bfe1b333ca369560b6d0649
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 25 19:17:38 2007 -0400

    ACPI: revert d-states branch from Jun-17 to Jun-19 for 2.6.23-rc1-mm1
    
    Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c  |   75 ---------------------------------
 drivers/pci/pci-acpi.c     |   28 +-----------
 drivers/pci/pci.c          |    8 +--
 drivers/pci/pci.h          |    2
 drivers/pnp/driver.c       |    5 --
 drivers/pnp/pnpacpi/core.c |   14 ------
 include/acpi/acpi_bus.h    |    2
 include/linux/pnp.h        |    4 -
 8 files changed, 9 insertions(+), 129 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 34abe8e..ada2a6e 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -261,81 +261,6 @@ static struct platform_hibernation_ops acpi_hibernation_ops = {
 };
 #endif				/* CONFIG_SOFTWARE_SUSPEND */
 
-/**
- *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
- *		in the system sleep state given by %acpi_target_sleep_state
- *	@dev: device to examine
- *	@wake: if set, the device should be able to wake up the system
- *	@d_min_p: used to store the upper limit of allowed states range
- *	Return value: preferred power state of the device on success, -ENODEV on
- *		failure (ie. if there's no 'struct acpi_device' for @dev)
- *
- *	Find the lowest power (highest number) ACPI device power state that
- *	device @dev can be in while the system is in the sleep state represented
- *	by %acpi_target_sleep_state.  If @wake is nonzero, the device should be
- *	able to wake up the system from this sleep state.  If @d_min_p is set,
- *	the highest power (lowest number) device power state of @dev allowed
- *	in this system sleep state is stored at the location pointed to by it.
- *
- *	The caller must ensure that @dev is valid before using this function.
- *	The caller is also responsible for figuring out if the device is
- *	supposed to be able to wake up the system and passing this information
- *	via @wake.
- */
-
-int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
-{
-	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
-	struct acpi_device *adev;
-	char acpi_method[] = "_SxD";
-	unsigned long d_min, d_max;
-
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
-		printk(KERN_ERR "ACPI handle has no context!\n");
-		return -ENODEV;
-	}
-
-	acpi_method[2] = '0' + acpi_target_sleep_state;
-	/*
-	 * If the sleep state is S0, we will return D3, but if the device has
-	 * _S0W, we will use the value from _S0W
-	 */
-	d_min = ACPI_STATE_D0;
-	d_max = ACPI_STATE_D3;
-
-	/*
-	 * If present, _SxD methods return the minimum D-state (highest power
-	 * state) we can use for the corresponding S-states.  Otherwise, the
-	 * minimum D-state is D0 (ACPI 3.x).
-	 *
-	 * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
-	 * provided -- that's our fault recovery, we ignore retval.
-	 */
-	if (acpi_target_sleep_state > ACPI_STATE_S0)
-		acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
-
-	/*
-	 * If _PRW says we can wake up the system from the target sleep state,
-	 * the D-state returned by _SxD is sufficient for that (we assume a
-	 * wakeup-aware driver if wake is set).  Still, if _SxW exists
-	 * (ACPI 3.x), it should return the maximum (lowest power) D-state that
-	 * can wake the system.  _S0W may be valid, too.
-	 */
-	if (acpi_target_sleep_state == ACPI_STATE_S0 ||
-	    (wake && adev->wakeup.state.enabled &&
-	     adev->wakeup.sleep_state <= acpi_target_sleep_state)) {
-		acpi_method[3] = 'W';
-		acpi_evaluate_integer(handle, acpi_method, NULL, &d_max);
-		/* Sanity check */
-		if (d_max < d_min)
-			d_min = d_max;
-	}
-
-	if (d_min_p)
-		*d_min_p = d_min;
-	return d_max;
-}
-
 /*
  * Toshiba fails to preserve interrupts over S1, reinitialization
  * of 8259 is needed after S1 resume.
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 67c63d1..c806249 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -245,33 +245,16 @@ EXPORT_SYMBOL(pci_osc_control_set);
  * currently we simply return _SxD, if present.
  */
 
-static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev,
-	pm_message_t state)
+static int acpi_pci_choose_state(struct pci_dev *pdev, pm_message_t state)
 {
-	int acpi_state;
-
-	acpi_state = acpi_pm_device_sleep_state(&pdev->dev,
-		device_may_wakeup(&pdev->dev), NULL);
-	if (acpi_state < 0)
-		return PCI_POWER_ERROR;
-
-	switch (acpi_state) {
-	case ACPI_STATE_D0:
-		return PCI_D0;
-	case ACPI_STATE_D1:
-		return PCI_D1;
-	case ACPI_STATE_D2:
-		return PCI_D2;
-	case ACPI_STATE_D3:
-		return PCI_D3hot;
-	}
-	return PCI_POWER_ERROR;
+	/* TBD */
+
+	return -ENODEV;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	acpi_handle tmp;
 	static int state_conv[] = {
 		[0] = 0,
 		[1] = 1,
@@ -283,9 +266,6 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	if (!handle)
 		return -ENODEV;
-	/* If the ACPI device has _EJ0, ignore the device */
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
-		return 0;
 	return acpi_bus_set_power(handle, acpi_state);
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b731cd1..15632b2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -499,7 +499,7 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 	return 0;
 }
 
-pci_power_t (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
+int (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
  
 /**
  * pci_choose_state - Choose the power state of a PCI device
@@ -513,15 +513,15 @@ pci_power_t (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state
 
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
 {
-	pci_power_t ret;
+	int ret;
 
 	if (!pci_find_capability(dev, PCI_CAP_ID_PM))
 		return PCI_D0;
 
 	if (platform_pci_choose_state) {
 		ret = platform_pci_choose_state(dev, state);
-		if (ret != PCI_POWER_ERROR)
-			return ret;
+		if (ret >= 0)
+			state.event = ret;
 	}
 
 	switch (state.event) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3bdfc3e..5692c3f 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -7,7 +7,7 @@ extern void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_cleanup_rom(struct pci_dev *dev);
 
 /* Firmware callbacks */
-extern pci_power_t (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
+extern int (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
 extern int (*platform_pci_set_power_state)(struct pci_dev *dev, pci_power_t state);
 
 extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index 1432806..e161423 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -167,8 +167,6 @@ static int pnp_bus_suspend(struct device *dev, pm_message_t state)
 	    		return error;
 	}
 
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
-		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
 
@@ -181,9 +179,6 @@ static int pnp_bus_resume(struct device *dev)
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
-		pnp_dev->protocol->resume(pnp_dev);
-
 	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
 		error = pnp_start_dev(pnp_dev);
 		if (error)
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index c37a558..a005487 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -119,25 +119,11 @@ static int pnpacpi_disable_resources(struct pnp_dev *dev)
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
-static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
-{
-	return acpi_bus_set_power((acpi_handle)dev->data,
-		acpi_pm_device_sleep_state(&dev->dev,
-		device_may_wakeup(&dev->dev), NULL));
-}
-
-static int pnpacpi_resume(struct pnp_dev *dev)
-{
-	return acpi_bus_set_power((acpi_handle)dev->data, ACPI_STATE_D0);
-}
-
 static struct pnp_protocol pnpacpi_protocol = {
 	.name	= "Plug and Play ACPI",
 	.get	= pnpacpi_get_resources,
 	.set	= pnpacpi_set_resources,
 	.disable = pnpacpi_disable_resources,
-	.suspend = pnpacpi_suspend,
-	.resume = pnpacpi_resume,
 };
 
 static int __init pnpacpi_add_device(struct acpi_device *device)
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a9f73ef..5e3dcf3 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -365,8 +365,6 @@ acpi_handle acpi_get_child(acpi_handle, acpi_integer);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
-int acpi_pm_device_sleep_state(struct device *, int, int *);
-
 #endif				/* CONFIG_ACPI */
 
 #endif /*__ACPI_BUS_H__*/
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 66edb22..2a1897e 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -335,10 +335,6 @@ struct pnp_protocol {
 	int (*set)(struct pnp_dev *dev, struct pnp_resource_table *res);
 	int (*disable)(struct pnp_dev *dev);
 
-	/* protocol specific suspend/resume */
-	int (*suspend)(struct pnp_dev *dev, pm_message_t state);
-	int (*resume)(struct pnp_dev *dev);
-
 	/* used by pnp layer only (look but don't touch) */
 	unsigned char		number;		/* protocol number*/
 	struct device		dev;		/* link to driver model */
