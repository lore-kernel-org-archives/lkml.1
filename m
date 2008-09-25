Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYIYW3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYIYW3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYIYW33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:29:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbYIYW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:29:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work anymore with 2.6.27-rc
Date: Fri, 26 Sep 2008 00:35:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809222309.34413.rjw@sisk.pl> <20080922211844.GA7049@dose.home.local>
In-Reply-To: <20080922211844.GA7049@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809260035.09052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 of September 2008, Tino Keitel wrote:
> On Mon, Sep 22, 2008 at 23:09:34 +0200, Rafael J. Wysocki wrote:
> > On Monday, 22 of September 2008, Tino Keitel wrote:
> > > Hi,
> > 
> > Hi,
> > 
> > > my Mac mini core duo used to wake up from suspend to RAM when a key or
> > > mouse button is pressed. This doesn't work anymore with 2.6.27-rc, the
> > > current version that I tried is 2.6.27-rc7. I checked /proc/acpi/wakeup
> > > for differences, with 2.6.26 and 2.6.27-rc, but both were identical:
> > 
> > Did you test that with any 2.6.27-rc before -rc7?
> 
> Only -rc6 IIRC.
> 
> > > Any hints if there are some commits that I should try to revert, before
> > > I start bisecting?
> > 
> > I don't think you need to revert anything. :-)
> > 
> > Please check if the /sys/devices/.../power/wakeup file contains 'enabled' for
> > the USB controller pci:0000:00:1d.7 (I assume this is the one the keyboard &
> > mouse are attached to).  If it doesn't, please try to write 'enabled' to this
> > file and retest.
> 
> Yes, this works. Thanks.

This actually is a regression for which I'm sorry.

Can you please check if the appended patch restores the previous behavior?

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI: Make /proc/acpi/wakeup interface handle PCI devices

Make the ACPI /proc/acpi/wakeup interface set the appropriate
wake-up bits of physical devices corresponding to the ACPI
devices and make those bits be set initially for devices that are
enabled to wake up by default.  This is needed to restore the
previous behavior for the PCI devices that were previously handled
correctly with the help of the /proc/acpi/wakeup interface.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/glue.c       |    5 ++++-
 drivers/acpi/sleep/proc.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/sleep/proc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/proc.c
+++ linux-2.6/drivers/acpi/sleep/proc.c
@@ -377,6 +377,14 @@ acpi_system_wakeup_device_seq_show(struc
 	return 0;
 }
 
+static void physical_device_enable_wakeup(struct acpi_device *adev)
+{
+	struct device *dev = acpi_get_physical_device(adev->handle);
+
+	if (dev && device_can_wakeup(dev))
+		device_set_wakeup_enable(dev, adev->wakeup.state.enabled);
+}
+
 static ssize_t
 acpi_system_write_wakeup_device(struct file *file,
 				const char __user * buffer,
@@ -411,6 +419,7 @@ acpi_system_write_wakeup_device(struct f
 		}
 	}
 	if (found_dev) {
+		physical_device_enable_wakeup(found_dev);
 		list_for_each_safe(node, next, &acpi_wakeup_device_list) {
 			struct acpi_device *dev = container_of(node,
 							       struct
@@ -428,6 +437,7 @@ acpi_system_write_wakeup_device(struct f
 				       dev->pnp.bus_id, found_dev->pnp.bus_id);
 				dev->wakeup.state.enabled =
 				    found_dev->wakeup.state.enabled;
+				physical_device_enable_wakeup(dev);
 			}
 		}
 	}
Index: linux-2.6/drivers/acpi/glue.c
===================================================================
--- linux-2.6.orig/drivers/acpi/glue.c
+++ linux-2.6/drivers/acpi/glue.c
@@ -165,8 +165,11 @@ static int acpi_bind_one(struct device *
 				"firmware_node");
 		ret = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
 				"physical_node");
-		if (acpi_dev->wakeup.flags.valid)
+		if (acpi_dev->wakeup.flags.valid) {
 			device_set_wakeup_capable(dev, true);
+			device_set_wakeup_enable(dev,
+						acpi_dev->wakeup.state.enabled);
+		}
 	}
 
 	return 0;
