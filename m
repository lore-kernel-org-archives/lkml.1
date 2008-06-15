Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYFOOOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYFOOOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYFOON6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:13:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31537 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbYFOON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=NonoLvJGHYkcCMZQUjmcZtUh3cxaeFmVBgXEA8pGK7r3CwW01Bd0hJ9IcPic+es1MO
         H/RGmFJ46Mjl5GyzfRUAo/aFQGn2WOu9v6IP1GbSz0i/FsNRB8SxHp2c+imt9/1iEI1r
         Uz8gaTB0x1YMw9aLVIGUM7YAoFnbNKP5qkTNw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [BUG] IDE: 2.6.26-rc5-git5 ide_generic leaks resources breaking my NE2000 NIC
Date: Sun, 15 Jun 2008 16:12:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200806151155.m5FBtoou029056@harpo.it.uu.se>
In-Reply-To: <200806151155.m5FBtoou029056@harpo.it.uu.se>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806151612.21248.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 15 June 2008, Mikael Pettersson wrote:
> The machine in question is an ancient ISA/VLB 486.
> It has no identifiable chipset, so uses IDE_GENERIC=y.
> 
> Up to 2.6.26-rc5-git4, ide_generic would probe ide0 at
> 0x1f0-0x1f7,0x3f6 on irq 14, find the disk, and be done.
> Later, ne (the NE2000 NIC driver) would probe io 0x300
> irq 10 and find my NIC there.
> 
> Starting with 2.6.26-rc5-git5, ide_generic also probes
> ide1 to ide3, with ide3 on irq 10. It doesn't find anything
> on ide1 to ide3, but keeps the io/irq resources for itself.
> Later, the ne driver fails to detect the NIC because its irq
> 10 is stolen by IDE.
> 
> Here's a dmesg diff showing the misbehaviour:
> --- dmesg-2.6.26-rc5-git4	2008-06-15 13:21:25.000000000 +0200
> +++ dmesg-2.6.26-rc5-git5	2008-06-15 13:21:26.000000000 +0200
> @@ -70,7 +70,13 @@
>  ide: Assuming 50MHz system bus speed for PIO modes; override with idebus=xx
>  Probing IDE interface ide0...
>  hda: WDC AC32500H, ATA DISK drive
> +Probing IDE interface ide1...
> +Probing IDE interface ide2...
> +Probing IDE interface ide3...
>  ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> +ide1 at 0x170-0x177,0x376 on irq 15
> +ide2 at 0x1e8-0x1ef,0x3ee on irq 11
> +ide3 at 0x168-0x16f,0x36e on irq 10
>  hda: max request size: 128KiB
>  hda: 4999680 sectors (2559 MB) w/128KiB Cache, CHS=4960/16/63
>   hda: hda1 hda2 hda3 hda4 < hda5 >
> @@ -98,5 +104,9 @@
>  NET: Registered protocol family 17
>  ne.c:v1.10 9/23/94 Donald Becker (becker@scyld.com)
>  Last modified Nov 1, 2000 by Paul Gortmaker
> -NE*000 ethercard probe at 0x300:00:40:05:3a:7b:f6
> -eth0: NE2000 found at 0x300, using IRQ 10.
> +NE*000 ethercard probe at 0x300: failed to detect IRQ line.
> +ne.c: No NE*000 card found at i/o = 0x300
> +ne.c:v1.10 9/23/94 Donald Becker (becker@scyld.com)
> +Last modified Nov 1, 2000 by Paul Gortmaker
> +NE*000 ethercard probe at 0x300: failed to detect IRQ line.
> +ne.c: No NE*000 card found at i/o = 0x300
> 
> A bisection found commit 343a3451e20314d5959b59b992e33fbaadfe52bf
> to be the culprit:
> >ide-generic: add missing hwif->chipset setup
> >
> >hwif->chipset need to be set properly or ide-generic driver will break once
> >we make a final step in fixing host drivers' dependence on ide_hwifs[].
> >
> >Problem was catched early thanks to IDE tree exposure in -mm / -next trees
> >and reported by people listed people (thank you guys!).
> >
> >Reported-by: "John Keller" <jpk@sgi.com>
> >Reported-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> >Reported-by: Mel Gorman <mel@csn.ul.ie>
> >Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >---
> >
> >diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
> >index a6073e2..9134488 100644
> >--- a/drivers/ide/ide-generic.c
> >+++ b/drivers/ide/ide-generic.c
> >@@ -125,6 +125,7 @@ static int __init ide_generic_init(void)
> > 			memset(&hw, 0, sizeof(hw));
> > 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
> > 			hw.irq = ide_default_irq(io_addr);
> >+			hw.chipset = ide_generic;
> > 			ide_init_port_hw(hwif, &hw);
> > 
> > 			idx[i] = i;
> 
> Reverting this one-line change restores the previous correct
> behaviour and allows my NIC to work again.
> 
> I'm assuming the resource leakage is unintended side-effect of this
> supposedly needed patch?

Yes, you're right on this one.  The above patch is in fact 2.6.26
regression bugfix (2.6.25 will probe ide1-3 and -git4 didn't) but as
a side-effect it exposes ide-generic to IDE warm-plug support added
in 2.6.26.

[ In 2.6.25 ide-generic will probe all ports and if there are no
  devices it will release resources back (despite leaving IDE port
  slots claimed) - this is no longer possible in 2.6.26 without
  affecting ordering of IDE devices and warm-plug functionality. ]

Coincidentally just yesterday I was trying to come with a reliable
scheme for automatically detecting when it is safe to probe ISA ide2-6
(on x86 they are now probed if no PCI devices are found in the system,
on some other archs/platforms they are probed unconditionally which
I believe is a left-over from basing their <asm/ide.h>-s on x86 one).

Your bugreport proves that there is no such method and that we should
leave it up to user (shouldn't be a problem anyway since systems with
ISA ide2-6 are very, very rare).

[...]

Please try attached patch.

[ Alan: you may also want to fix pata_legacy with something like:

--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1241,7 +1241,7 @@ static __init int legacy_init(void)
 	if (secondary == 0 || all)
 		legacy_probe_add(0x170, 15, UNKNOWN, 0);
 
-	if (probe_all || !pci_present) {
+	if (probe_all) {
 		/* ISA/VLB extra ports */
 		legacy_probe_add(0x1E8, 11, UNKNOWN, 0);
 		legacy_probe_add(0x168, 10, UNKNOWN, 0);

as checking ata_host_activate() for -ENODEV doesn't seem to be enough
because ata_host_{activate,register}() ignores result of port probing ]


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-generic: don't probe all legacy ISA IDE ports by default

We can't probe all legacy ISA IDE ports by default as the resources may be
occupied by other ISA devices.  Add "probe_mask" module parameter and probe
only first two ISA IDE ports by default leaving the decision about probing
the rest to the user (systems with ISA ide2-6 should be very, very rare).

This fixes a regression caused by:

commit 343a3451e20314d5959b59b992e33fbaadfe52bf
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Jun 10 20:56:36 2008 +0200

    ide-generic: add missing hwif->chipset setup
...

Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Bisected-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -22,6 +22,10 @@
 
 #define DRV_NAME	"ide_generic"
 
+static int probe_mask = 0x03;
+module_param(probe_mask, int, 0);
+MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
+
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
 	ide_hwif_t *hwif;
@@ -89,6 +93,9 @@ static int __init ide_generic_init(void)
 	u8 idx[MAX_HWIFS];
 	int i;
 
+	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
+			 "parameter for probing all legacy ISA IDE ports\n");
+
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
@@ -96,7 +103,7 @@ static int __init ide_generic_init(void)
 
 		idx[i] = 0xff;
 
-		if (io_addr) {
+		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
 				printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX "
 						"not free.\n",
