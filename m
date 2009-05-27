Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbZE0Tl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbZE0Tl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZE0Tlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:41:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33893 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZE0Tls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:41:48 -0400
Date: Wed, 27 May 2009 12:41:44 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Alex Chiang <achiang@hp.com>,
       linux-acpi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090527194144.GA7933@us.ibm.com>
References: <49ED22EC.2040204@kernel.org> <200905081640.12677.bjorn.helgaas@hp.com> <20090520164910.6939b92b@jbarnes-g45> <200905210846.18292.bjorn.helgaas@hp.com> <20090521163737.GA7891@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521163737.GA7891@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:37:37AM -0700, Gary Hade wrote:
> On Thu, May 21, 2009 at 08:46:17AM -0600, Bjorn Helgaas wrote:
> > On Wednesday 20 May 2009 5:49:10 pm Jesse Barnes wrote:
> > > On Fri, 8 May 2009 16:40:10 -0600
> > > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > > Did anything happen with this?
> > > > 
> > > > The longer we wait to make "use_crs" the default, the harder it
> > > > will be, so I'd like to push ahead.
> > > 
> > > Here's a patch to make CRS the default.  If it looks ok I can push it
> > > into my linux-next branch.  I'm all for using reliable data from the
> > > BIOS.  I guess we'll find out fairly quickly if this stuff isn't...
> > 
> > Thanks for following up on this, Jesse.  It was on my to-do list for
> > yesterday, but I didn't get to it.
> > 
> > Yinghai mentioned a specific box where we might have trouble, but we
> > never got enough details to really debug it.  So I think we might as
> > well give it a shot and fine-tune it as we need to.
> 
> I just remembered that Andrew Morton once raised some concerns
> related to the number of _CRS returned resources exceeding the
> fixed resource array size -> http://lkml.org/lkml/2007/11/1/49
> 
> I believe PCI_BUS_NUM_RESOURCES was later increased but if 
> that increase was insufficient to cover all systems that the
> code will now be exposed to, it seems like the "And should we
> really be silently ignoring this problem?  Should we at least
> report it?" comment that was not addressed could become relevent.

Not only do we not warn, if we did warn based on the current
    'if (info->res_num >= PCI_BUS_NUM_RESOURCES)'
resource array overrun avoidance criteria it would be incorrect
for a root bus that is connected to a subordinate bus with a
transparent bridge.  We need to avoid the last 3 slots of the
resource array since they do not get mapped to a transparent
bridge connected subordinate bus.  I believe the below patch
addresses these issues.

With PCI_BUS_NUM_RESOURCES currently at 16 we still have space
to accomodate 13 _CRS returned resource descriptors which will
hopefully be sufficient.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


From: Gary Hade <garyhade@us.ibm.com>

Correct maximum allowed _CRS returned resources and warn if exceeded.

Issue a warning if _CRS returns too many resource descriptors
to be accommodated by the fixed size resource array instances.
If there is no transparent bridge on the root bus "too many"
is the PCI_BUS_NUM_RESOURCES size of the resource array.
Otherwise, the last 3 slots of the resource array must be
excluded making the maximum (PCI_BUS_NUM_RESOURCES - 3).

The current code:
 - is silent when _CRS returns too many resource descriptors and
 - incorrectly allows use of the last 3 slots of the resource array
   for a root bus with a transparent bridge

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/pci/acpi.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

Index: linux-2.6.28-rc7/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.28-rc7.orig/arch/x86/pci/acpi.c	2009-05-27 10:42:10.000000000 -0700
+++ linux-2.6.28-rc7/arch/x86/pci/acpi.c	2009-05-27 10:43:35.000000000 -0700
@@ -38,15 +38,26 @@ count_resource(struct acpi_resource *acp
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 
-	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
-		return AE_OK;
-
 	status = resource_to_addr(acpi_res, &addr);
 	if (ACPI_SUCCESS(status))
 		info->res_num++;
 	return AE_OK;
 }
 
+static int
+bus_has_transparent_bridge(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 class = dev->class >> 8;
+
+		if (class == PCI_CLASS_BRIDGE_PCI && dev->transparent)
+			return true;
+	}
+	return false;
+}
+
 static acpi_status
 setup_resource(struct acpi_resource *acpi_res, void *data)
 {
@@ -56,9 +67,7 @@ setup_resource(struct acpi_resource *acp
 	acpi_status status;
 	unsigned long flags;
 	struct resource *root;
-
-	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
-		return AE_OK;
+	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
 
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
@@ -82,6 +91,18 @@ setup_resource(struct acpi_resource *acp
 	res->end = res->start + addr.address_length - 1;
 	res->child = NULL;
 
+	if (bus_has_transparent_bridge(info->bus))
+		max_root_bus_resources -= 3;
+	if (info->res_num >= max_root_bus_resources) {
+		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
+			"from %s for %s due to _CRS returning more than "
+			"%d resource descriptors\n", (unsigned long) res->start,
+			(unsigned long) res->end, root->name, info->name,
+			max_root_bus_resources);
+		info->res_num++;
+		return AE_OK;
+	}
+
 	if (insert_resource(root, res)) {
 		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
 			"from %s for %s\n", (unsigned long) res->start,
