Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815Ab0BZAqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:46:54 -0500
Received: from kroah.org ([198.145.64.141]:39809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934783Ab0BZAqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:46:52 -0500
Date: Thu, 25 Feb 2010 16:46:46 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100226004646.GA31483@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225173611.GA14124@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100225230639.GB20900@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:40:52PM +0000, Haiyang Zhang wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, February 25, 2010 6:07 PM
> > If so, what is the vendor and product id of this device?
> 
> The Vendor:Device Id is: 1414:5353
> 00:08.0 VGA compatible controller [0300]: Microsoft Corporation Device [1414:5353]
> 
> This hasn't been changed since the first release of HyperV. I will ask
> around about the future stability of the VGA card (and the DMI).

Ok, below are 2 patches that I will queue up in my tree.

Can you test them to verify that they work properly?

thanks,

greg k-h

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Staging: hv: add a pci device table

This allows the HV core to be properly found and autoloaded
by the system tools.

It uses the Microsoft virtual VGA device to trigger this.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/hv/vmbus_drv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
+#include <linux/pci.h>
 #include "VersionInfo.h"
 #include "osd.h"
 #include "logging.h"
@@ -974,6 +975,22 @@ static void __exit vmbus_exit(void)
 	return;
 }
 
+/*
+ * We use a PCI table to determine if we should autoload this driver  This is
+ * needed by distro tools to determine if the hyperv drivers should be
+ * installed and/or configured.  We don't do anything else with the table, but
+ * it needs to be present.
+ *
+ * We might consider triggering off of DMI table info as well, as that does
+ * decribe the virtual machine being run on, but not all configuration tools
+ * seem to be able to handle DMI device ids properly.
+ */
+const static struct pci_device_id microsoft_hv_pci_table[] = {
+	{ PCI_DEVICE(0x1414, 0x5353) },	/* VGA compatible controller */
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 module_param(vmbus_irq, int, S_IRUGO);



From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Staging: hv: match on DMI values to know if we should run.

The HV core mucks around with specific irqs and other low-level stuff
and takes forever to determine that it really shouldn't be running on a
machine.  So instead, trigger off of the DMI system information and
error out much sooner.  This also allows the module loading tools to
recognize that this code should be loaded on this type of system.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/vmbus_drv.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/pci.h>
+#include <linux/dmi.h>
 #include "VersionInfo.h"
 #include "osd.h"
 #include "logging.h"
@@ -948,6 +949,19 @@ static irqreturn_t vmbus_isr(int irq, vo
 	}
 }
 
+static struct dmi_system_id __initdata microsoft_hv_dmi_table[] = {
+	{
+		.ident = "Hyper-V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MicrosoftCorporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VirtualMachine"),
+			DMI_MATCH(DMI_BOARD_NAME, "VirtualMachine"),
+		},
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
+
 static int __init vmbus_init(void)
 {
 	int ret = 0;
@@ -959,6 +973,9 @@ static int __init vmbus_init(void)
 		vmbus_loglevel, HIWORD(vmbus_loglevel), LOWORD(vmbus_loglevel));
 	/* Todo: it is used for loglevel, to be ported to new kernel. */
 
+	if (!dmi_check_system(microsoft_hv_dmi_table))
+		return -ENODEV;
+
 	ret = vmbus_bus_init(VmbusInitialize);
 
 	DPRINT_EXIT(VMBUS_DRV);
@@ -980,10 +997,6 @@ static void __exit vmbus_exit(void)
  * needed by distro tools to determine if the hyperv drivers should be
  * installed and/or configured.  We don't do anything else with the table, but
  * it needs to be present.
- *
- * We might consider triggering off of DMI table info as well, as that does
- * decribe the virtual machine being run on, but not all configuration tools
- * seem to be able to handle DMI device ids properly.
  */
 const static struct pci_device_id microsoft_hv_pci_table[] = {
 	{ PCI_DEVICE(0x1414, 0x5353) },	/* VGA compatible controller */
