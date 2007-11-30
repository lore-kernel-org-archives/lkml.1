Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXK3BvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXK3BvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932938AbXK3BvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:51:09 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26561 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbXK3BvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:51:08 -0500
Date: Thu, 29 Nov 2007 18:51:05 -0700
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071130015105.GH24707@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <474E6E82.40307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474E6E82.40307@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > Hi Gary, Kenji-san, et. al,
> > 
> > * Gary Hade <garyhade@us.ibm.com>:
> >> Alex, What I was trying to suggest is a boot-time kernel
> >> option, not a kernel configuration option.  The basic idea is
> >> to give the user (with a single binary kernel) the ability to
> >> include your ACPI-PCI slot driver feature changes only when
> >> they are really needed.  In addition to reducing the number of
> >> system/PCI hotplug driver combinations where your changes would
> >> need to be validated, I believe would also help alleviate other
> >> worries (e.g. Andi Kleen's memory consumption concern).  I
> >> believe this goal could also be achieved with the kernel config
> >> option by making the pci_slot module runtime loadable with the
> >> PCI hotplug drivers only visiting your new code when the
> >> pci_slot driver is loaded, although I think this would be more
> >> difficult to implement.
> > 
> > I have modified my patch series so that the final patch that
> > introduces my ACPI-PCI slot driver is a full-fledged module, that
> > has a tristate Kconfig option.
> > 
> 
> Thank you for your good job.

Thanks for testing. :)

> I tested shpchp and pciehp both with and without pci_slot
> module. There seems no regression from shpchp and pciehp's
> point of view.  (I had a little concern about the hotplug
> slots' name that vary depending on whether pci_slot
> functionality is enabled or disabled. But, now that we can
> build pci_slot driver as a kernel module, I don't think it is a
> big problem).

Hm, you are right. On my machine, if I load pciehp first and
acpiphp second (even without loading pci_slot), I will see the
following:

[root@canola slots]# ls
0016_0006  0197_0005  10  3  4  7  8  9

[root@canola slots]# lsmod | grep pci_slot
[root@canola slots]# lsmod | grep hp
acpiphp               115984  0 
pciehp                140616  0 
pci_hotplug           123972  2 acpiphp,pciehp

On the other hand, if I do load pci_slot first, and then pciehp,
you are right, I will see something like this:

[root@canola slots]# ls
1  10  2  3  4  5  6  7  8  9

[root@canola slots]# lsmod | grep pci_slot
pci_slot               74436  0 
[root@canola slots]# lsmod | grep hp
pciehp                140616  0 
pci_hotplug           123972  1 pciehp

But I do agree, people don't need to load pci_slot at all if they
don't want it, and they won't be bothered.

> Only the problems is that I got Call Traces with the following
> error messages when pci_slot driver was loaded, and one strange
> slot named '1023' was registered (other slots are fine). This
> is the same problem I reported before.
> 
>     sysfs: duplicate filename '1023' can not be created
>     WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> 
>     kobject_add failed for 1023 with -EEXIST, don't try to
>     register things with the same name in the same directory.
> 
> On my system, hotplug slots themselves can be added, removed
> and replaced with the ohter type of I/O box. The ACPI firmware
> tells OS the presence of those slots using _STA method (That
> is, it doesn't use 'LoadTable()' AML operator). On the other
> hand, current pci_slot driver doesn't check _STA.  As a result,
> pci_slot driver tryied to register the invalid (non-existing)
> slots. The ACPI firmware of my system returns '1023' if the
> invalid slot's _SUN is evaluated. This is the cause of Call
> Traces mentioned above. To fix this problem, pci_slot driver
> need to check _STA when scanning ACPI Namespace.

Now this is very curious. The relevant line in pci_slot is:

check_slot()
	status = acpi_evaluate_integer(handle, "_SUN", NULL, sun);
	if (ACPI_FAILURE(status))
		return -1;

Why does your firmware return the error information inside sun,
instead of returning an error in status? That doesn't seem right
to me...

> I'm sorry for reporting this so late. I'm attaching the patch
> to fix the problem. This is against 2.6.24-rc3 with your
> patches applied. Could you try it?

Applying this patch causes me to only detect populated slots in
my system, which isn't what I want -- otherwise, I could have
just enumerated the PCI bus and found the devices that way. :)

Maybe on your machine, checking existence of _STA might do the
right thing, but I don't think we should actually be looking at
any of the actual bits returned. 

If we check ACPI_STA_DEVICE_PRESENT, then we will not detect
empty slots on my system. Can you try this patch to see if at
least the first call to acpi_evaluate_integer helps? If that
doesn't help, maybe the second block will help you, but it breaks
my machine...

Thanks.

/ac


diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 724f4f0..63a4dc8 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -55,9 +65,21 @@ static struct acpi_pci_driver acpi_pci_slot_driver = {
 static int
 check_slot(acpi_handle handle, int *device, unsigned long *sun)
 {
-       unsigned long adr;
+       unsigned long adr, sta;
        acpi_status status;
 
+       /* Doesn't seem to hurt anything on hp systems */
+       status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+       if (ACPI_FAILURE(status))
+               return -1;
+
+       /* This code causes us to fail to detect empty slots, so
+        * commented out for now.
+        *
+       if (!(sta & ACPI_STA_DEVICE_PRESENT))
+               return -1;
+        */
+
        status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
        if (ACPI_FAILURE(status))
                return -1;
