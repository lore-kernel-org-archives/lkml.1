Return-Path: <linux-kernel-owner+w=401wt.eu-S1764430AbXLTS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764430AbXLTS0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXLTS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:26:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbXLTS0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:26:03 -0500
Message-ID: <476AB3B5.9080808@redhat.com>
Date: Thu, 20 Dec 2007 13:25:57 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de>
In-Reply-To: <20071220172205.GB5636@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Why haven't we gotten reports about this before if this is a common
> problem?
> 
> And why hasn't the vendor fixed the bios on these to work properly?
>
I can't really answer either of these questions. All I know is the
problem exists, and we need to deal with it.

That's why the unreachable_devices() routine exists in the first place.

But that routine is limited to only the first 16 buses on segment-0.
You would like to think that hardware designers would confine legacy
hardware, or problematic hardware, to that area, but they don't.

As I said before, expanding that routine to cover more buses would
adversely impact mmconfig pci access, since the mmconfig access
code does a lookup of that bitmap for every request. I don't think
we want that bitmap and the accompanying in-line lookup to increase
enough to encompass the pci configuration of some of these larger
systems.

> Do you have a pointer to this blacklist anywhere so that everyone can
> benifit from this knowledge?
>

Appended below is a code snippet embedded in the RHEL version of mmconfig.c,
for both i386 and x86_64. It does not encompass all the systems that have
(or will have) problems with mmconf. Only HP platforms are listed, but I
believe there are others.

The reason the HP platforms got caught is they put these devices beyond
bus 16, where they would have been trapped, and the problem would have
been avoided.

static int __devinit disable_mmconf(struct dmi_system_id *d)
{
         pci_probe &= ~PCI_PROBE_MMCONF;
         printk(KERN_INFO "%s detected: disabling PCI MMCONFIG\n", d->ident);
         return 0;
}


/*
  * Systems which cannot use PCI MMCONFIG at this time...
  */
static struct dmi_system_id __devinitdata nommconf_dmi_table[] = {
         {
                 .callback = disable_mmconf,
                 .ident = "HP xw9300 Workstation",
                 .matches = {
                         DMI_MATCH(DMI_PRODUCT_NAME, "HP xw9300 Workstation"),
                 },
         },
         {
                 .callback = disable_mmconf,
                 .ident = "HP xw9400 Workstation",
                 .matches = {
                         DMI_MATCH(DMI_PRODUCT_NAME, "HP xw9400 Workstation"),
                 },
         },
         {
                 .callback = disable_mmconf,
                 .ident = "ProLiant DL585 G2",
                 .matches = {
                         DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
                 },
         },
         {
                 .callback = disable_mmconf,
                 .ident = "HP Compaq dc5700 Microtower",
                 .matches = {
                         DMI_MATCH(DMI_PRODUCT_NAME,
                                 "HP Compaq dc5700 Microtower"),
                 },
         },

         {}
};

>> The one device we know about that throws exceptions is the 830M/MG
>> graphics chip. This chip passes the read-compare test, so the code
>> merrily advances to bus sizing. When the bus sizing code writes the
>> BAR at offset 0x18 in this device, the system hangs.
> 
> So it doesn't work at all, with or without this patch?  Does the vendor
> know about this?
> 
> thanks,
> 
> greg k-h

I have talked to intel about this, but they haven't gotten back to me.

All I know at this point is that a mmconf write to the BAR at offset 0x18
of this device hangs the system.
