Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXD0TAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXD0TAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXD0S7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:50812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbXD0S66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/46] define platform wakeup hook, use in pci_enable_wake()
Date: Fri, 27 Apr 2007 11:53:56 -0700
Message-Id: <11777001971761-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001931075-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
 <11777001891914-git-send-email-gregkh@suse.de>
 <11777001931075-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

This defines a platform hook to enable/disable a device as a wakeup event
source.  It's initially for use with ACPI, but more generally it could be used
whenever enable_irq_wake()/disable_irq_wake() don't suffice.

The hook is called -- if available -- inside pci_enable_wake(); and the
semantics of that call are enhanced so that support for PCI PME# is no longer
needed.  It can now work for devices with "legacy PCI PM", when platform
support allows it.  (That support would use some board-specific signal for for
the same purpose as PME#.)

[akpm@linux-foundation.org: Make it compile with CONFIG_PM=n]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    3 ++
 drivers/pci/pci.c         |   58 +++++++++++++++++++++++++++++++-------------
 include/linux/pm.h        |   19 ++++++++++++++
 3 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bbbb973..05dc876 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -29,6 +29,9 @@ LIST_HEAD(dpm_off_irq);
 DECLARE_MUTEX(dpm_sem);
 DECLARE_MUTEX(dpm_list_sem);
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+
 /**
  *	device_pm_set_parent - Specify power dependency.
  *	@dev:		Device who needs power.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d3eab05..2a45827 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -891,31 +892,48 @@ pci_disable_device(struct pci_dev *dev)
 }
 
 /**
- * pci_enable_wake - enable device to generate PME# when suspended
- * @dev: - PCI device to operate on
- * @state: - Current state of device.
- * @enable: - Flag to enable or disable generation
- * 
- * Set the bits in the device's PM Capabilities to generate PME# when
- * the system is suspended. 
+ * pci_enable_wake - enable PCI device as wakeup event source
+ * @dev: PCI device affected
+ * @state: PCI state from which device will issue wakeup events
+ * @enable: True to enable event generation; false to disable
  *
- * -EIO is returned if device doesn't have PM Capabilities. 
- * -EINVAL is returned if device supports it, but can't generate wake events.
- * 0 if operation is successful.
- * 
+ * This enables the device as a wakeup event source, or disables it.
+ * When such events involves platform-specific hooks, those hooks are
+ * called automatically by this routine.
+ *
+ * Devices with legacy power management (no standard PCI PM capabilities)
+ * always require such platform hooks.  Depending on the platform, devices
+ * supporting the standard PCI PME# signal may require such platform hooks;
+ * they always update bits in config space to allow PME# generation.
+ *
+ * -EIO is returned if the device can't ever be a wakeup event source.
+ * -EINVAL is returned if the device can't generate wakeup events from
+ * the specified PCI state.  Returns zero if the operation is successful.
  */
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable)
 {
 	int pm;
+	int status;
 	u16 value;
 
+	/* Note that drivers should verify device_may_wakeup(&dev->dev)
+	 * before calling this function.  Platform code should report
+	 * errors when drivers try to enable wakeup on devices that
+	 * can't issue wakeups, or on which wakeups were disabled by
+	 * userspace updating the /sys/devices.../power/wakeup file.
+	 */
+
+	status = call_platform_enable_wakeup(&dev->dev, enable);
+
 	/* find PCI PM capability in list */
 	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
 
-	/* If device doesn't support PM Capabilities, but request is to disable
-	 * wake events, it's a nop; otherwise fail */
-	if (!pm) 
-		return enable ? -EIO : 0; 
+	/* If device doesn't support PM Capabilities, but caller wants to
+	 * disable wake events, it's a NOP.  Otherwise fail unless the
+	 * platform hooks handled this legacy device already.
+	 */
+	if (!pm)
+		return enable ? status : 0;
 
 	/* Check device's ability to generate PME# */
 	pci_read_config_word(dev,pm+PCI_PM_PMC,&value);
@@ -924,8 +942,14 @@ int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable)
 	value >>= ffs(PCI_PM_CAP_PME_MASK) - 1;   /* First bit of mask */
 
 	/* Check if it can generate PME# from requested state. */
-	if (!value || !(value & (1 << state))) 
+	if (!value || !(value & (1 << state))) {
+		/* if it can't, revert what the platform hook changed,
+		 * always reporting the base "EINVAL, can't PME#" error
+		 */
+		if (enable)
+			call_platform_enable_wakeup(&dev->dev, 0);
 		return enable ? -EINVAL : 0;
+	}
 
 	pci_read_config_word(dev, pm + PCI_PM_CTRL, &value);
 
@@ -936,7 +960,7 @@ int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable)
 		value &= ~PCI_PM_CTRL_PME_ENABLE;
 
 	pci_write_config_word(dev, pm + PCI_PM_CTRL, value);
-	
+
 	return 0;
 }
 
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 21db05a..b0ab623 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -273,6 +273,20 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
 		__suspend_report_result(__FUNCTION__, fn, ret);		\
 	} while (0)
 
+/*
+ * Platform hook to activate device wakeup capability, if that's not already
+ * handled by enable_irq_wake() etc.
+ * Returns zero on success, else negative errno
+ */
+extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	if (platform_enable_wakeup)
+		return (*platform_enable_wakeup)(dev, is_on);
+	return 0;
+}
+
 #else /* !CONFIG_PM */
 
 static inline int device_suspend(pm_message_t state)
@@ -294,6 +308,11 @@ static inline void dpm_runtime_resume(struct device * dev)
 
 #define suspend_report_result(fn, ret) do { } while (0)
 
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	return -EIO;
+}
+
 #endif
 
 /* changes to device_may_wakeup take effect on the next pm state change.
-- 
1.5.1.2

