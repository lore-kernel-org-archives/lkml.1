Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZIWXXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZIWXXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZIWXXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:23:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41908 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZIWXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:23:30 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: fixing "pci=use_crs"
Date: Wed, 23 Sep 2009 17:23:30 -0600
User-Agent: KMail/1.9.10
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909211520.56800.bjorn.helgaas@hp.com> <4AB95F41.1070500@lwfinger.net>
In-Reply-To: <4AB95F41.1070500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909231723.31786.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009 05:35:29 pm Larry Finger wrote:
> Bjorn Helgaas wrote:
> > On Saturday 19 September 2009 11:08:02 am Larry Finger wrote:
> >> Bjorn Helgaas wrote:
> >>> It looks like you have an HP box -- what exactly is it and
> >>> what BIOS version do you have?  Maybe I can borrow one to play
> >>> with myself so I don't have to bug you as much.
> >> It is an HP dv2815nr. The BIOS is F.21. I understand that debugging
> >> is much easier when you have the machine in hand, but I don't mind
> >> providing information.
> >> ...
> >> Do you want me to boot with "pci=use_crs"?
> > 
> > That'd be great.  HP's bureaucracy makes it hard for me to borrow
> > machines.  If you could also turn on CONFIG_PNP_DEBUG_MESSAGES
> > and boot with "pnp.debug", we should get some clues about what _CRS
> > returns for all the ACPI devices.  Just attach the resulting dmesg
> > to the bugzilla (http://bugzilla.kernel.org/show_bug.cgi?id=14183).
> 
> I put the dmesg output with pci=use_crs and pnp.debug in the bugzilla.

Thanks a lot.  These resources:

  pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
  pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
  pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]

are obviously coming from _CRS, and we only exercise the
pci_acpi_scan_root() -> get_current_resources() -> setup_resource()
path when we have an acpi_device.

But we don't have a PNPACPI device with those resources.  There are
a couple cases where we don't build PNPACPI devices for an ACPI
device: HID isn't valid PNP ID ("AAAXXXX"), device is excluded
(EC, PIC, interrupt links, timers), or status is "!present".

The most likely seems like a device that is "!present && functional".
We build acpi_devices for those, but not PNP devices.

Would you mind trying the attached debug patch to try to confirm this?

Bjorn

P.S.  Yinghai, you posted some patches earlier dealing with "only one
HT chain."  You apparently have some insight into what's going on here,
but unfortunately, the changelogs mean absolutely nothing to me.  Can
you give me any clues?


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 1014eb4..7c817f8 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -7,6 +7,7 @@
 #include <asm/pci_x86.h>
 
 struct pci_root_info {
+	struct acpi_device *device;
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
@@ -77,6 +78,10 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
 
+	dev_info(&info->device->dev, "res %d addr %d min %#llx len %#llx tra %#llx\n",
+		 acpi_res->type,
+		 addr.resource_type, addr.minimum, addr.address_length,
+		 addr.translation_offset);
 	if (addr.resource_type == ACPI_MEMORY_RANGE) {
 		root = &iomem_resource;
 		flags = IORESOURCE_MEM;
@@ -117,6 +122,8 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	return AE_OK;
 }
 
+#define STRUCT_TO_INT(s)        (*((int*)&s))
+
 static void
 get_current_resources(struct acpi_device *device, int busnum,
 			int domain, struct pci_bus *bus)
@@ -124,6 +131,10 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
+	dev_info(&device->dev, "getting resources (status 0x%x)\n",
+		 STRUCT_TO_INT(device->status));
+
+	info.device = device;
 	info.bus = bus;
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 31b961c..78a5fd6 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -461,6 +461,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	acpi_handle handle;
 	struct acpi_device *child;
 	u32 flags, base_flags;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	segment = 0;
 	status = acpi_evaluate_integer(device->handle, METHOD_NAME__SEG, NULL,
@@ -508,9 +509,11 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	/* TBD: Locking */
 	list_add_tail(&root->node, &acpi_pci_roots);
 
+	acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
 	printk(KERN_INFO PREFIX "%s [%s] (%04x:%02x)\n",
-	       acpi_device_name(device), acpi_device_bid(device),
+	       acpi_device_name(device), (char *) buffer.pointer,
 	       root->segment, root->bus_nr);
+	kfree(buffer.pointer);
 
 	/*
 	 * Scan the Root Bridge
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 83b8b5a..3a0a93b 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -154,6 +154,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	acpi_status status;
 	struct pnp_dev *dev;
 	struct acpi_hardware_id *id;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	/*
 	 * If a PnPacpi device is not present , the device
@@ -205,7 +206,11 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	/* clear out the damaged flags */
 	if (!dev->active)
 		pnp_init_resources(dev);
+
+	acpi_get_name(temp, ACPI_FULL_PATHNAME, &buffer);
+	pnp_dbg(&dev->dev, "pnp device for [%s]\n", (char *) buffer.pointer);
 	pnp_add_device(dev);
+	kfree(buffer.pointer);
 	num++;
 
 	return AE_OK;
