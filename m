Return-Path: <linux-kernel-owner+w=401wt.eu-S934743AbXEWULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbXEWULq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXEWULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:11:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37584 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbXEWULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:11:36 -0400
Date: Wed, 23 May 2007 15:11:18 -0500
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.21.1: ide-pci is not finding ide controller.
Message-ID: <20070523201118.GZ5921@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've got a rather old x86 box that I'm booting 2.6.21.1 on;
this kernel is not finding an ide controller on it. 

The motherboard has 4 ide controllers total; two olde-fashioned
ones (PIIX4, using the original 40-pin IDE ribbon cable) and two 
"HighPoint HPT366" controllers, taking the 80-pin cable. 
BIOS allows the two olde-fashioned channels to be enabled
or disabled; but the HPT seems to alaways be on (I could not
find any BIOS entry to play with them.)

A bit of debugging localized the symptoms to drivers/ide/setup-pci.c
It seems that there was some recent ide-pci fix that changed/fixed
the way that pci config space is read' this "fix" breaks my recognition
of my controller.  I made a lame attempt to google for pci ide config
space, but could not find any specs, and so can quite figure out what's
wrong. Details below.

First, a debugging patch; I can boot with this patch, because it
disables the case that fails. 

Index: linux-2.6.21.1/drivers/ide/setup-pci.c
===================================================================
--- linux-2.6.21.1.orig/drivers/ide/setup-pci.c	2007-05-22 20:03:10.000000000 -0500
+++ linux-2.6.21.1/drivers/ide/setup-pci.c	2007-05-22 20:03:26.000000000 -0500
@@ -585,15 +585,24 @@
 	for (port = 0; port <= 1; ++port) {
 		ide_pci_enablebit_t *e = &(d->enablebits[port]);
 	
+#if 0
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val))
 			continue;	/* port not enabled */
+#endif
+		if (e->reg) {
+			int rc = pci_read_config_byte(dev, e->reg, &tmp);
+printk ("duude port %d readrc=%d got ereg=%x, tmp=%x\n", port, rc, e->reg, tmp);
+		}
+printk ("duuude port =%d tmp=%x mask=%x tmp&mask=%x val=%x\n", port, tmp, e->mask, tmp&e->mask, e->val);
 
 		if (d->channels	<= port)
 			break;
 	
-		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL)
-			continue;
+		if ((hwif = ide_hwif_configure(dev, d, mate, port, pciirq)) == NULL) {
+printk(KERN_ERR "duuude port=%d didn't work!!!!!!!!!!!!!!!!! \n", port);
+continue;
+}
 
 		/* setup proper ancestral information */
 		hwif->gendev.parent = &dev->dev;


Now, for some output. I applied this patch to 2.6.19 (which boots fine)
and to 2.6.21.1, so that behaviour can be compared. First, te 2.6.21
output:


[    0.000000] Linux version 2.6.21.1linas (root@backlot) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #5 SMP PREEMPT Sat May 19 13:40:44 CDT 2007
...
[   35.177649] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   35.177724] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   35.177960] PIIX4: IDE controller at PCI slot 0000:00:07.1
[   35.178042] PCI: Enabling device 0000:00:07.1 (0000 -> 0001)
[   35.178219] PIIX4: chipset revision 1
[   35.178283] PIIX4: not 100% native mode: will probe irqs later
[   35.178355] duude port 0 readrc=0 got ereg=41, tmp=0
[   35.178421] duuude port =0 tmp=0 mask=80 tmp&mask=0 val=80

                              tmp&mask != val, so this and the next
                              controller are not ordinarily found. 
                              That's OK, since this controller is 
                              "disabled" in BIOS.

[   35.178505]     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
[   35.178689] duude port 1 readrc=0 got ereg=43, tmp=0
[   35.178754] duuude port =1 tmp=0 mask=80 tmp&mask=0 val=80
[   35.178824]     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
[   35.179010] Probing IDE interface ide0...
[   35.738016] Probing IDE interface ide1...
[   36.297984] HPT366: onboard version of chipset, pin1=1 pin2=2
[   36.298060] HPT366: IDE controller at PCI slot 0000:00:13.0
[   36.298143] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level, low) -> IRQ 16
[   36.298275] HPT366: chipset revision 1
[   36.298350] HPT366: using 33 MHz PCI clock
[   36.298412] HPT366: 100% native mode on irq 16
[   36.298478] duude port 0 readrc=0 got ereg=50, tmp=33
[   36.298542] duuude port =0 tmp=33 mask=4 tmp&mask=0 val=4

                                  tmp&mask != val, so this, and the next
                                  controller is not usually found.
                                  By comparison, tmp, mask and val were 
                                  all zero in 2.6.19-rc4 (see below)

                                  I cannot find any way to enable or 
                                  disable this controller in BIOS.

[   36.298619]     ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:DMA, hdf:pio
[   36.298805] duude port 1 readrc=0 got ereg=54, tmp=33
[   36.298871] duuude port =1 tmp=33 mask=4 tmp&mask=0 val=4
[   36.298943] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 18 (level, low) -> IRQ 16
[   36.299079] HPT366: using 33 MHz PCI clock
[   36.299145] duude port 0 readrc=0 got ereg=50, tmp=33
[   36.299210] duuude port =0 tmp=33 mask=4 tmp&mask=0 val=4
[   36.299284]     ide3: BM-DMA at 0xe800-0xe807, BIOS settings: hdg:DMA, hdh:pio
[   36.299457] duude port 1 readrc=0 got ereg=54, tmp=33
[   36.299522] duuude port =1 tmp=33 mask=4 tmp&mask=0 val=4
[   36.299592] Probing IDE interface ide2...
[   36.586101] hde: Maxtor 6Y200P0, ATA DISK drive
[   37.258080] ide2 at 0xd400-0xd407,0xd802 on irq 16
[   37.258569] Probing IDE interface ide3...
[   37.545991] hdg: Maxtor 4G160J8, ATA DISK drive
[   38.217957] ide3 at 0xe000-0xe007,0xe402 on irq 16
[   38.219288] Probing IDE interface ide0...
[   38.781666] Probing IDE interface ide1...
[   39.341883] hde: max request size: 512KiB
[   39.342712] hde: 398297088 sectors (203928 MB) w/7936KiB Cache, CHS=24792/255/63, UDMA(66)
[   39.343158] hde: cache flushes supported
[   39.343357]  hde: hde1 hde2 < hde5 hde6 hde7 hde8 hde9 >
[   39.387815] hdg: max request size: 512KiB
[   39.389453] hdg: 320173056 sectors (163928 MB) w/2048KiB Cache, CHS=19929/255/63, UDMA(66)
[   39.389747] hdg: cache flushes not supported
[   39.389949]  hdg: hdg1 hdg2 < hdg5 hdg6 hdg7 hdg8 >


======================================================================
For comparison, an older 2.6.19 kernel.


[    0.000000] Linux version 2.6.19-rc4-git3linas (root@backlot) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #2 SMP PREEMPT Tue May 22 20:07:21 CDT 2007
[    0.686498] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    0.686570] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    0.686805] PIIX4: IDE controller at PCI slot 0000:00:07.1
[    0.686888] PCI: Enabling device 0000:00:07.1 (0000 -> 0001)
[    0.686980] PIIX4: chipset revision 1
[    0.687041] PIIX4: not 100% native mode: will probe irqs later
[    0.687111] duude port 0 readrc=0 got ereg=41, tmp=0
[    0.687176] duuude port =0 tmp=0 mask=80 tmp&mask=0 val=80
[    0.687259]     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
[    0.687438] duude port 1 readrc=0 got ereg=43, tmp=0
[    0.687502] duuude port =1 tmp=0 mask=80 tmp&mask=0 val=80
[    0.687571]     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
[    0.687745] Probing IDE interface ide0...
[    1.255798] Probing IDE interface ide1...
[    1.819761] HPT366: onboard version of chipset, pin1=1 pin2=2
[    1.819843] HPT366: IDE controller at PCI slot 0000:00:13.0
[    1.819935] HPT366: chipset revision 1
[    1.820014] HPT366: 100% native mode on irq 18
[    1.820079] duuude port =0 tmp=0 mask=0 tmp&mask=0 val=0
[    1.820161]     ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:DMA, hdf:pio

                      Why lookit! The older kernels got all zeros 
                      for ths test ... but the result is that the
                      if statements pass, and the controller is
                      recognized!  I guess someone "fixed" this,
                      breaking my system.

[    1.820342] duuude port =1 tmp=0 mask=0 tmp&mask=0 val=0
[    1.820435] duuude port =0 tmp=0 mask=0 tmp&mask=0 val=0
[    1.820517]     ide3: BM-DMA at 0xe800-0xe807, BIOS settings: hdg:DMA, hdh:pio
[    1.820688] duuude port =1 tmp=0 mask=0 tmp&mask=0 val=0
[    1.820757] Probing IDE interface ide2...
[    2.111886] hde: Maxtor 6Y200P0, ATA DISK drive
[    2.787893] ide2 at 0xd400-0xd407,0xd802 on irq 18
[    2.788368] Probing IDE interface ide3...
[    3.079775] hdg: Maxtor 4G160J8, ATA DISK drive
[    3.755761] ide3 at 0xe000-0xe007,0xe402 on irq 18
[    3.757057] Probing IDE interface ide0...
[    4.323446] Probing IDE interface ide1...
[    4.887657] hde: max request size: 512KiB
[    4.888436] hde: 398297088 sectors (203928 MB) w/7936KiB Cache, CHS=24792/255/63, UDMA(66)
[    4.888869] hde: cache flushes supported
[    4.889141]  hde: hde1 hde2 < hde5 hde6 hde7 hde8 hde9 >
[    4.949544] hdg: max request size: 512KiB
[    4.951136] hdg: 320173056 sectors (163928 MB) w/2048KiB Cache, CHS=19929/255/63, UDMA(66)
[    4.951410] hdg: cache flushes not supported
[    4.951610]  hdg: hdg1 hdg2 < hdg5 hdg6 hdg7 hdg8 >
