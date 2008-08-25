Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYHYDnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYHYDnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 23:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYHYDnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 23:43:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:10149 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYHYDnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 23:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VQ73USJ4SI3NGRz4zNUdDKPniczOVUvx2NanQYux1Xyd6FMrtzkSnlfB4rNGrYkixu
         d9lFktlLcLpRPwyuB0Wsr6TFBHmfVDLOyeu1nOL60b4/fasZXUvvYNlBtJ4xM+A0I8lV
         ahkaK8LvegPpCAx6CwrpyjQBvRmt40PUEmlgw=
Message-ID: <86802c440808242043w36c11e57v2e226028aad0035@mail.gmail.com>
Date: Sun, 24 Aug 2008 20:43:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: only put e820 ram entries in resource tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Bernhard Walle" <bwalle@suse.de>,
       "Vivek Goyal" <vgoyal@redhat.com>
In-Reply-To: <m14p59ztz1.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219617897-9870-1-git-send-email-yhlu.kernel@gmail.com>
	 <m14p59ztz1.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 7:52 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> may need user to have new kexec tools that could create e820 table
>> from /sys/firmware/memmap instead of /proc/iomem for second kernel
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> /proc/iomem is mostly about io resources which you have just removed.
> It is totally the wrong thing to only register RAM resource!
>
> The use by kexec was and is just taking advantage of something that
> already existed.

story:
before 2.6.26, kernel will insert_resource with lapic addr into resource tree.
and then use request_resource to add entries with all entries in e820 tables.
so one entry is overlapped with lapic address is never added to resource tree.

from 2.6.26, we use have e820 insert_resource for it's entries to
resource tree at first. and later use
insert_resource for lapic address. so all entries from e820 is showing
up on resource tree.

problem: some devices that on bus0, has resource with BAR,, and those
address is falling into reserved area in e820.
when pcibios_allocate_bus_resources check those resource, it found
request_resource(pr, res) will fail. at this point pr is
resource of parent bus of those device. ant it is iomem_resource. then
those device will updated resource by OS allocations.
that should be ok, but some chipset put HPET in one BAR1, that changes
will make hpet addr is not consistent anymore.
the system will hang...

solutions will be:
1. use quirks to protect the hpet in BAR

[PATCH] x86: protect hpet in BAR for one ATI chipset v3

so avoid kernel don't allocate nre resource for it because it can not
allocate the old
address from BIOS.

the same way like some IO APIC address in BAR handling

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/quirks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -1918,6 +1918,22 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_B
                         PCI_DEVICE_ID_NX2_5709S,
                         quirk_brcm_570x_limit_vpd);

+static void __init quirk_hpet_in_bar(struct pci_dev *pdev)
+{
+       int i;
+       u64 base, size;
+
+       /* the BAR1 is the location of the HPET...we must
+        * not touch this, so forcibly insert it into the resource tree */
+       base = pci_resource_start(pdev, 1);
+       size = pci_resource_len(pdev, 1);
+       if (base && size) {
+               insert_resource(&iomem_resource, &pdev->resource[1]);
+               dev_info(&pdev->dev, "HPET at %08llx-%08llx\n", base,
base + size - 1);
+       }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x4385, quirk_hpet_in_bar);
+
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually

2. or more generic way, double check that in pcibios_allocate_bus_resources

[PATCH] x86: check hpet with BAR

insert some resources to resource tree forcily, so could avoid kernel update the
resources in pci device.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/pci/i386.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>

 #include <asm/pat.h>
+#include <asm/hpet.h>

 #include "pci.h"

@@ -77,6 +78,30 @@ pcibios_align_resource(void *data, struc
 }
 EXPORT_SYMBOL(pcibios_align_resource);

+static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
+{
+       unsigned long base;
+       unsigned long size;
+
+       base = res->start;
+       size = (res->start == 0 && res->end == res->start) ? 0 :
+                (res->end - res->start + 1);
+
+       if (!base || !size)
+               return 0;
+
+#ifdef CONFIG_HPET_TIMER
+       /* for hpet */
+       if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
+               dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
+                                base, base + size - 1);
+               return 1;
+       }
+#endif
+
+       return 0;
+}
+
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
@@ -128,6 +153,23 @@ static void __init pcibios_allocate_bus_
                                pr = pci_find_parent_resource(dev, r);
                                if (!r->start || !pr ||
                                    request_resource(pr, r) < 0) {
+                                       if (check_res_with_valid(dev, r)) {
+                                               struct resource *root = NULL;
+
+                                               /*
+                                                * forcibly insert it into the
+                                                * resource tree
+                                                */
+                                               if (r->flags & IORESOURCE_MEM)
+                                                       root = &iomem_resource;
+                                               else if (r->flags &
IORESOURCE_IO)
+                                                       root = &ioport_resource;
+
+                                               if (root)
+
insert_resource(root, r);
+                                               continue;
+                                       }
+
                                        dev_err(&dev->dev, "BAR %d: can't "
                                                "allocate resource\n", idx);
                                        /*

3. or this patch, just don't use e820 reserved entries in resource tree.
it seems pci code is trying to find gap in e820 directly. (recently
some try to use acpi with that).
other usage of e820 reserved entries is for mmconfig, and that is
checking with e820 directly.

don't know who is using reserved entries in resource tree from e820.
please remember that some reserved entry is missing till 2.6.25....

YH
