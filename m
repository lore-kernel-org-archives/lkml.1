Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYLKTD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYLKTD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbYLKTDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:03:48 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35286 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYLKTDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:03:47 -0500
Date: Thu, 11 Dec 2008 12:03:46 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Chiang <achiang@hp.com>, justin.chen@hp.com,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Message-ID: <20081211190346.GD26095@parisc-linux.org>
References: <20081211181242.GD18309@ldl.fc.hp.com> <20081211181644.GE18309@ldl.fc.hp.com> <200812111035.02652.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812111035.02652.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 10:35:01AM -0800, Jesse Barnes wrote:
> On Thursday, December 11, 2008 10:16 am Alex Chiang wrote:
> > From: Justin Chen <justin.chen@hp.com>
> >
> > Certain HP machines require the full 64 bits of _SUN as allowed
> > by the ACPI spec. Without this change, we get name collisions in
> > the lower 32 bits of the _SUN returned by firmware.
> >
> > Signed-off-by: Justin Chen <justin.chen@hp.com>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> 
> It's very late in the cycle, so I'd like to get acks from at least a couple of 
> other testers for this one...  Any volunteers?

Testers or reviewers?  Here's my review (done thinking out loud style):

$ grep -w sun drivers/pci/hotplug/acpiphp*
1. drivers/pci/hotplug/acpiphp_core.c:     snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
2. drivers/pci/hotplug/acpiphp_glue.c:     unsigned long long adr, sun;
3. drivers/pci/hotplug/acpiphp_glue.c:     status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
4. drivers/pci/hotplug/acpiphp_glue.c:             sun = bridge->nr_slots+1;
5. drivers/pci/hotplug/acpiphp_glue.c:                     if (slot->sun != sun)
6. drivers/pci/hotplug/acpiphp_glue.c:             slot->sun = sun;
7. drivers/pci/hotplug/acpiphp_glue.c: slot->sun, pci_domain_nr(bridge->pci_bus),
8. drivers/pci/hotplug/acpiphp_glue.c: "hotplug driver\n", slot->sun);
9. drivers/pci/hotplug/acpiphp.h:  u32             sun;            /* ACPI _SUN (slot unique number) */
10. drivers/pci/hotplug/acpiphp_ibm.c:#define hpslot_to_sun(A) (((struct
slot *)((A)->private))->acpi_slot->sun)
11. drivers/pci/hotplug/acpiphp_ibm.c:              u8  sun;

#1 is a printk ... string changed to %llu.  Fine.

#2 is a declaration of a local variable, not related.
#3 is a use of said local variable, fine.
#4 ditto
#5 compares said local variable to the newly widened element.  Good.
#6 is an assignment.  Good.
#7 is also a printk.  Also changed to %llu.  Good.
#8 Ditto.
#9 is the change in question.

#10 and #11 are in the acpiphp_ibm driver.  This driver will truncate
the stored value of 'sun' to 32-bit ... however, it then compares the
result for equality with an 8-bit value.  We do no harm here by storing
a 64-bit value in sun instead of a 32-bit value.  If IBM want to produce
machines that use more than 8 bits for slot number, they will have to
change their firmware interface anyway -- their ACPI table uses 8-bit
wide data types for it.

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
