Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbXJGEvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbXJGEvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 00:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXJGEve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 00:51:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39104 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXJGEvd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 00:51:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-mm[12] - the amazing disappearing MSI IRQ
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191732692_10413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Oct 2007 00:51:32 -0400
Message-ID: <23735.1191732692@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191732692_10413P
Content-Type: text/plain; charset=us-ascii

Dell Latitude D820, T7200 processor, x86_64 kernel.  The MSI IRQs for
HDA-Intel evaporate fairly consistently some time after boot.  On a few
occasions, the MSI IRQ for the ethernet interface also has dropped.

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express (rev 02)

A while after boot I have this in /proc/interrupts:

Sat Oct  6 22:25:19 EDT 2007
           CPU0       CPU1       
  0:     222717          0   IO-APIC-edge      timer
  1:          9       1783   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
  9:          2          0   IO-APIC-fasteoi   acpi
 12:         86          0   IO-APIC-edge      i8042
 14:       5490      30700   IO-APIC-edge      libata
 15:         36          0   IO-APIC-edge      libata
 16:       2657          0   IO-APIC-fasteoi   nvidia
 19:          9          0   IO-APIC-fasteoi   ohci1394, yenta
 20:        125       6393   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:         90          0   IO-APIC-fasteoi   uhci_hcd:usb3
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
312:        149      19249   PCI-MSI-edge      eth0
313:         92          0   PCI-MSI-edge      iwl3945
314:       5375          0   PCI-MSI-edge      HDA Intel
NMI:          0          0   Non-maskable interrupts
LOC:      63560     180342   Local interrupts
RES:      60295      49751   Rescheduling interrupts
CAL:        342       2070   function call interrupts
TLB:       2173       1804   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

Ethernet, wireless, and sound card all have MSI interrupts attached.
Then after a while, this pops in dmesg:

[ 2086.388000] ALSA sound/pci/hda/hda_intel.c:563: hda_intel: No response from codec, disabling MSI: last cmd=0x012f1c00
[ 2087.389000] ALSA sound/pci/hda/hda_intel.c:576: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x012f1c00

(The exact time has varied anywhere from 123 seconds after boot to 10,502 secs).

And now /proc/interrupts looks like:

Sat Oct  6 23:26:59 EDT 2007
           CPU0       CPU1       
  0:    2438973          0   IO-APIC-edge      timer
  1:          9      10061   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
  9:          2          0   IO-APIC-fasteoi   acpi
 12:         86          0   IO-APIC-edge      i8042
 14:       5490      87784   IO-APIC-edge      libata
 15:         36          0   IO-APIC-edge      libata
 16:      30831          0   IO-APIC-fasteoi   nvidia
 19:          9          0   IO-APIC-fasteoi   ohci1394, yenta
 20:        125      55664   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:         91      13292   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
312:        149     101422   PCI-MSI-edge      eth0
313:       2378          0   PCI-MSI-edge      iwl3945
314:      15643          0      none-edge    
NMI:          0          0   Non-maskable interrupts
LOC:     395385    1640119   Local interrupts
RES:     675388     582673   Rescheduling interrupts
CAL:        429       2195   function call interrupts
TLB:       5776       4119   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

Sound card has moved to IRQ 21, and 314 is left hanging in the breeze.

I've also seen the eth0 MSI IRQ evaporate, leaving *two* 'none-edge' IRQs,
but I can't replicate it at the moment, as it seems to happen pseudo-randomly.



--==_Exmh_1191732692_10413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCGXUcC3lWbTT17ARAsn9AKCwgjNczg5D5jZcDfCfFwip1Ul5nACcCHHI
nL0HidCn3tKKNU1zOIzfA6M=
=73SI
-----END PGP SIGNATURE-----

--==_Exmh_1191732692_10413P--
