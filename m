Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYHQTHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYHQTHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYHQTHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:07:37 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27434 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYHQTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:07:36 -0400
Date: Sun, 17 Aug 2008 21:06:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080817210659.06601a3b@hyperion.delvare>
In-Reply-To: <20080816062259.GB20541@kroah.com>
References: <for-27-patch1-0@bga.com>
	<200808151046.59590.jbarnes@virtuousgeek.org>
	<20080815205500.1945916f@hyperion.delvare>
	<200808151215.02499.jbarnes@virtuousgeek.org>
	<20080816062259.GB20541@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fri, 15 Aug 2008 23:22:59 -0700, Greg KH wrote:
> On Fri, Aug 15, 2008 at 12:15:01PM -0700, Jesse Barnes wrote:
> > On Friday, August 15, 2008 11:55 am Jean Delvare wrote:
> > > In fact we can do even better than that. We could accept from
> > > user-space only driver_data values which at least one device ID entry in
> > > the driver already uses. That should be fairly easy to implement, and
> > > would offer a level of safety an order of magnitude above what we have
> > > at the moment... And it works both ways: if 0 is not a valid data for
> > > some driver, that would force the user to provide a non-zero (and
> > > valid) data value. And it guarantees that the user can't ask for
> > > something the driver doesn't expect, so drivers don't even need extra
> > > checks. And no need for a use_driver_data flag either.
> > 
> > Meaning a driver audit of the usage?  Yeah that would be great.
> > 
> > > The only drawback is that it prevents the user from passing a "new"
> > > data value even if it would be valid. But honestly, I don't expect that
> > > case to happen frequently... if ever at all. So I'd say the benefits
> > > totally outweight the drawback.
> > >
> > > If the interested people agree with the idea, I'll look into
> > > implementing it.
> > 
> > Well the audit would show if user supplied "new" values are needed; otherwise 
> > the approach sounds good to me.
> 
> That sounds reasonable, and should work properly.
> 
> No objection from me.

Ok, here's what it could look like:

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: PCI: Check dynids driver_data value for validity

Only accept dynids those driver_data value matches one of the driver's
pci_driver_id entry. This prevents the user from accidentally passing
values the drivers do not expect.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Milton Miller <miltonm@bga.com>
Cc: Greg KH <greg@kroah.com>
---
 Documentation/PCI/pci.txt       |    4 ++++
 drivers/i2c/busses/i2c-amd756.c |    4 ----
 drivers/i2c/busses/i2c-viapro.c |    4 ----
 drivers/pci/pci-driver.c        |   18 ++++++++++++++++--
 4 files changed, 20 insertions(+), 10 deletions(-)

--- linux-2.6.27-rc3.orig/Documentation/PCI/pci.txt	2008-08-17 18:24:33.000000000 +0200
+++ linux-2.6.27-rc3/Documentation/PCI/pci.txt	2008-08-17 18:24:38.000000000 +0200
@@ -163,6 +163,10 @@ need pass only as many optional fields a
 	o class and classmask fields default to 0
 	o driver_data defaults to 0UL.
 
+Note that driver_data must match the value used by any of the pci_device_id
+entries defined in the driver. This makes the driver_data field mandatory
+if all the pci_device_id entries have a non-zero driver_data value.
+
 Once added, the driver probe routine will be invoked for any unclaimed
 PCI devices listed in its (newly updated) pci_ids list.
 
--- linux-2.6.27-rc3.orig/drivers/i2c/busses/i2c-amd756.c	2008-08-17 17:15:57.000000000 +0200
+++ linux-2.6.27-rc3/drivers/i2c/busses/i2c-amd756.c	2008-08-17 19:42:14.000000000 +0200
@@ -332,10 +332,6 @@ static int __devinit amd756_probe(struct
 	int error;
 	u8 temp;
 	
-	/* driver_data might come from user-space, so check it */
-	if (id->driver_data >= ARRAY_SIZE(chipname))
-		return -EINVAL;
-
 	if (amd756_ioport) {
 		dev_err(&pdev->dev, "Only one device supported "
 		       "(you have a strange motherboard, btw)\n");
--- linux-2.6.27-rc3.orig/drivers/i2c/busses/i2c-viapro.c	2008-08-17 17:15:57.000000000 +0200
+++ linux-2.6.27-rc3/drivers/i2c/busses/i2c-viapro.c	2008-08-17 19:42:24.000000000 +0200
@@ -320,10 +320,6 @@ static int __devinit vt596_probe(struct 
 	unsigned char temp;
 	int error = -ENODEV;
 
-	/* driver_data might come from user-space, so check it */
-	if (id->driver_data & 1 || id->driver_data > 0xff)
-		return -EINVAL;
-
 	/* Determine the address of the SMBus areas */
 	if (force_addr) {
 		vt596_smba = force_addr & 0xfff0;
--- linux-2.6.27-rc3.orig/drivers/pci/pci-driver.c	2008-08-17 17:15:57.000000000 +0200
+++ linux-2.6.27-rc3/drivers/pci/pci-driver.c	2008-08-17 19:17:55.000000000 +0200
@@ -43,18 +43,32 @@ store_new_id(struct device_driver *drive
 {
 	struct pci_dynid *dynid;
 	struct pci_driver *pdrv = to_pci_driver(driver);
+	const struct pci_device_id *ids = pdrv->id_table;
 	__u32 vendor, device, subvendor=PCI_ANY_ID,
 		subdevice=PCI_ANY_ID, class=0, class_mask=0;
 	unsigned long driver_data=0;
 	int fields=0;
-	int retval = 0;
+	int retval;
 
-	fields = sscanf(buf, "%x %x %x %x %x %x %lux",
+	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
 			&vendor, &device, &subvendor, &subdevice,
 			&class, &class_mask, &driver_data);
 	if (fields < 2)
 		return -EINVAL;
 
+	/* Only accept driver_data values that match an existing id_table
+	   entry */
+	retval = -EINVAL;
+	while (ids->vendor || ids->subvendor || ids->class_mask) {
+		if (driver_data == ids->driver_data) {
+			retval = 0;
+			break;
+		}
+		ids++;
+	}
+	if (retval)	/* No match */
+		return retval;
+
 	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
 	if (!dynid)
 		return -ENOMEM;


* * * * *

The patch above applies on top of Milton's patch removing
dynids.use_driver_data.

Note that I fixed a bug in the code: the driver_data value was scanned
with format "%lux" which isn't valid. It's either "%lu" or "%lx". It
went unnoticed so far because it's the last field. I've made it "%lx"
because that's what our documentation says it should be. The old code
was behaving like "%lu" instead, so that's an interface change. But I
doubt it matters much, given that only 3 drivers were using this field
so far.

As mentioned before, this safety check might be too tight in some
cases (for example if driver_data is a bit field and the new device
needs a flag combination that no supported device uses.) It wouldn't be
difficult to let drivers set a flag saying they will care about the
safety check themselves. I can even implement it now if anybody thinks
that my code is too restrictive.

Thanks,
-- 
Jean Delvare
