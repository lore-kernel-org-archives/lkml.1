Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYAPTCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYAPTCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYAPTCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:02:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:42681 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYAPTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VEphYbkI9TnSUlJv+qPo7BnIl9cNw1YpTQzeV6CheWcFFotUKCph+I8qhqW233HZnmlBURQ/1xdyDsBhcBPJ+98b/IQL+wnM10vklUl8iTvSjyp7AlgIQVnRlvsIhy6rbcOwTeh+OBGi0JnS3nhXMHF6TWXE81MCb4zpZU36XcI=
Message-ID: <7ac1e90c0801161102i3e3047caw55ae5656301f2a0d@mail.gmail.com>
Date: Wed, 16 Jan 2008 19:02:29 +0000
From: "Bahadir Balban" <bahadir.balban@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: 2.6.24-rc5 sysfs pci bridge duplicate symlink
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080110035503.GG20448@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7ac1e90c0712280511y3a0f454cmc84e8c17f173c8dc@mail.gmail.com>
	 <20071228150322.71e5ca49.akpm@linux-foundation.org>
	 <20071228235048.GB22935@flint.arm.linux.org.uk>
	 <20080110035503.GG20448@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/08, Greg KH <gregkh@suse.de> wrote:
> On Fri, Dec 28, 2007 at 11:50:49PM +0000, Russell King - ARM Linux wrote:
> > On Fri, Dec 28, 2007 at 03:03:22PM -0800, Andrew Morton wrote:
> > > On Fri, 28 Dec 2007 13:11:37 +0000 "Bahadir Balban" <bahadir.balban@gmail.com> wrote:
> > >
> > > > Hi,
> > > >
> > > > On ARM with PCI, I get this error since -rc2 (didn't try rc1):
> > > >
> > > > sysfs: duplicate filename 'bridge' can not be created
> > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > [<c00287fc>] (dump_stack+0x0/0x14) from [<c00cbc64>] (sysfs_add_one+0x50/0xf4)
> > > > [<c00cbc14>] (sysfs_add_one+0x0/0xf4) from [<c00ccd30>]
> > > > (sysfs_create_link+0xec/0x184)
> > > >  r6:cfca8b48 r5:cfca96c8 r4:cfc2fec0
> > > > [<c00ccc44>] (sysfs_create_link+0x0/0x184) from [<c0160b44>]
> > > > (pci_bus_add_devices+0xf0/0x144)
> > > >  r7:cfc5a2d4 r6:cfc5a2d4 r5:cfc5a2c0 r4:cfcad800
> > > > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> > > > (pci_bus_add_devices+0xdc/0x144)
> > > >  r7:cfc5a3d4 r6:cfc5a3d4 r5:cfc5a3c0 r4:cfcadc00
> > > > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c0160b30>]
> > > > (pci_bus_add_devices+0xdc/0x144)
> > > >  r7:cfc5a4d4 r6:cfc5a4d4 r5:cfc5a4c0 r4:cfc5d400
> > > > [<c0160a54>] (pci_bus_add_devices+0x0/0x144) from [<c000a934>]
> > > > (pci_common_init+0x148/0x184)
> > > >  r7:c035fd58 r6:cfc3e760 r5:c001e030 r4:cfc5a4c0
> > > >
> > > >
> > > > Any idea why?
> > > >
> > >
> > > (suitable cc added)
> >
> > Looks to me as if the code added to pci_bus_add_devices() is off it's
> > rocker.
> >
> > In brief, pci_bus_add_devices() is supposed to be callable given *any*
> > state of the bus, and it will add any new devices found in the bus tree
> > from the bus that it's called for downwards.  (That's how I designed
> > that bit of PCI code - so it can cope with hotpluggable PCI bridges.)
> >
> > It still does this.  However, some bright spark decided to add sysfs
> > links to it - and break it.  Now, whenever we descend into a subordinate
> > bus (and return to a higher level) we will try to create a sysfs symlink
> > even if the bus is one that we already registered.
> >
> > So... that sysfs_create_link() call in there should not be unconditional.
> > It should _only_ ever do that call if list_empty(&dev->subordinate->node)
> > was true.  IOW, we only create symlinks for subordinate bus that we don't
> > already know about.
> >
> > It looks like it was introduced by Greg's "PCI: fix __must_check warnings"
> > but why a patch advertised _solely_ as a fix is adding additional sysfs
> > attributes I've no idea.
>
> I'm sorry, but I don't see where that patch added new sysfs attributes
> to anything.  It just reports any errors that might have occured and
> hopefully properly handle them.  Did I mess up somewhere with this?
>
> > Something like the following should fix it.  Bahadir - please test.
>
> Any test results?
>
> thanks,
>
> greg k-h
>

Hi,

I have tested and it works OK with this patch on -rc8. Without the
patch it breaks as in my original email.

While at it, could you please apply the below patch as well? It
enables PCI transactions through bridges on ARM.

Thanks,
Bahadir

From: Bahadir Balban <bahadir.balban@arm.com>


---

 arch/arm/kernel/bios32.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index e574754..7d3ebd4 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -607,6 +607,11 @@ void __init pci_common_init(struct hw_pci *hw)
 			 * Assign resources.
 			 */
 			pci_bus_assign_resources(bus);
+
+			/*
+			 * Enable bridges
+			 */
+			pci_enable_bridges(bus);
 		}

 		/*
