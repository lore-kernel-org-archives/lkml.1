Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYBKTWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYBKTWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYBKTW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:22:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:59029 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbYBKTWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FNRsxpxERuSe4PkyIn88tb/9er/dy72sU7VQlMIB6rKbYm0ovnPLOzRc09jR6NBBJ9Bmr7w28qJqt09vIswBj6leucFG7kgsH3WoBaPWlwhL0rF+5zuI7RUGfv0ObC0zh8z183SnGmSuggtqzVQMTIfCtrSEmKHsdgh0bFN1cJE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.26-git0: IDE oops during boot
Date: Mon, 11 Feb 2008 20:35:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       ananth@in.ibm.com, Andi Kleen <andi@firstfloor.org>
References: <20080206105334.GA3664@elf.ucw.cz> <29495f1d0802101332p6b39b331ye2f6fb488b63e228@mail.gmail.com> <47AFFF30.6070808@linux.vnet.ibm.com>
In-Reply-To: <47AFFF30.6070808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802112035.39462.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 11 February 2008, Kamalesh Babulal wrote:
> Nish Aravamudan wrote:
> > On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >> On Thursday 07 February 2008, Kamalesh Babulal wrote:
> >>> Bartlomiej Zolnierkiewicz wrote:
> >>>> Hi,
> >>>>
> >>>> On Wednesday 06 February 2008, Pavel Machek wrote:
> >>>>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
> >>>>>> Hi!
> >>>>>>
> >>>>>> Trying to boot 2.6.25-git0 (few days old), I get
> >>>>>>
> >>>>>> BUG: unable to handle kernel paging request at ffff..ffb0
> >>>>>> IP at init_irq+0x42e
> >>>> init_irq? hmm...
> >>>>
> >>>>>> Call trace:
> >>>>>> ide_device_add_all
> >>>> this comes from ide-generic
> >>>> (Generic IDE host driver)
> >>>>
> >>>>>> ide_generic_init
> >>>>>> kernel_init
> >>>>>> child_rip
> >>>>>> vgacon_cursor
> >>>>>> kernel_init
> >>>>>> child_rip
> >>>>>>
> >>>>>> Excerpt from config:
> >>>>>>
> >>>>>> CONFIG_IDE=y
> >>>>>> CONFIG_BLK_DEV_IDE=y
> >>>>> Disabling CONFIG_IDE made my machine boot, as it was using libata
> >>>>> anyway.
> >>>> Kamalesh/Pavel:
> >>>>
> >>>> Could you try latest git and see if the OOPS is still there?
> >>>>
> >>>> [ Yeah, I'm unable to reproduce it. :( ]
> >>>>
> >>>> Thanks,
> >>>> Bart
> >>> Hi Bart,
> >>>
> >>> The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
> >>> similar to the previous one
> >> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
> >>
> >> Could you please bisect it down to the guilty commit?
> > 
> > Kamalesh, were you able to bisect this down? I just got hit by the
> > same panic on a 4-way x86_64, with 2.6.24-git22.
> > 
> > Thanks,
> > Nish
> 
> Hi Nish,
> 
> I tried bisecting and the guilty patch seems to be 
> 
> 36501650ec45b1db308c3b51886044863be2d762 is first bad commit
> commit 36501650ec45b1db308c3b51886044863be2d762
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Fri Feb 1 23:09:31 2008 +0100
> 
>     ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t
> 
> 
> the gdb output, also points to the changes made by the guilty patch
> 
> (gdb) p ide_device_add_all
> $1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804176ac <ide_device_add_all>
> (gdb) p/x 0xffffffff804176ac+0xb60
> $2 = 0xffffffff8041820c
> (gdb) l *0xffffffff8041820c
> 0xffffffff8041820c is in ide_device_add_all (drivers/ide/ide-probe.c:1249).
> 1244                    goto out;
> 1245            }
> 1246
> 1247            sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> 1248
> 1249            if (init_irq(hwif) == 0)
> 1250                    goto done;
> 1251
> 1252            old_irq = hwif->irq;
> 1253            /*
> (gdb) 
> 
> 
> (gdb) p init_irq
> $1 = {int (ide_hwif_t *)} 0xffffffff8041721f <init_irq>
> (gdb) p/x 0xffffffff8041721f+0x1a4
> $2 = 0xffffffff804173c3
> (gdb) l *0xffffffff804173c3
> 0xffffffff804173c3 is in init_irq (include/asm/pci.h:101).
> 96      /* Returns the node based on pci bus */
> 97      static inline int __pcibus_to_node(struct pci_bus *bus)
> 98      {
> 99              struct pci_sysdata *sd = bus->sysdata;
> 100
> 101             return sd->node;
> 102     }
> 103
> 104     static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
> 105     {
> (gdb) 

Thanks for the detailed analysis and sorry for the bug.

I think that this may has been just fixed by Andi's recent hwif_to_node()
fix (patch below, it is in Linus' tree already), could please verify this?

commit 1f07e988290fc45932f5028c9e2a862c37a57336
Author: Andi Kleen <andi@firstfloor.org>
Date:   Mon Feb 11 01:35:20 2008 +0100

    Prevent IDE boot ops on NUMA system
    
    Without this patch a Opteron test system here oopses at boot with
    current git.
    
    Calling to_pci_dev() on a NULL pointer gives a negative value so the
    following NULL pointer check never triggers and then an illegal address
    is referenced.  Check the unadjusted original device pointer for NULL
    instead.
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/ide.h b/include/linux/ide.h
index 23fad89..a3b69c1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1295,7 +1295,7 @@ static inline void ide_dump_identify(u8 *id)
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	return dev ? pcibus_to_node(dev->bus) : -1;
+	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
 }
 
 static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
