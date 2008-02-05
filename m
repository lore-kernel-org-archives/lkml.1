Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYBETZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYBETZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYBETZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:25:44 -0500
Received: from mail.chilan.com ([82.160.213.101]:40228 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbYBETZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:25:42 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 14:25:42 EST
From: Grzegorz Chwesewicz <ceho@chilan.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Problem with recording on hda-intel (sata_sil or hda-intel bug) - HP nx6325
Date: Tue, 5 Feb 2008 20:15:23 +0100
User-Agent: KMail/1.9.7
Cc: chilek@chilan.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052015.23170.ceho@chilan.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi. 
Problem description:

I have a problem with recording on HP nx6325 notebook (hda-intel with AD1981HD 
codec). Playback works fine, but after 5-10 min. of recording microphone 
stops working (playback works all the time). Unloading and loading sound 
modules fixes problem, but only for another 5-10 minutes. This problem exists 
from more than a year (at least from 2.6.17.13 kernel). In [1] we came to 
conclusion that this problem is ralated to IRQ sharing [2] (HDA Intel is on 
the same IRQ as sata_sil). 

How to reproduce the problem:

1) on one console run arecord and see the output (You should see some garbage)
2) on another console run cat /etc/*
3) at once arecord on the first console gives no output

So, doing lot of hdd I/O occurs problem with mic.

What had been done:

1) I tried to boot Fedora 8 livecd and unload sata_sil, so that hda_intel was 
the only device using IRQ. After that microphone was working all the time (I 
left recording for all night, and in the morning I had almost 2h voip chat 
using Twinkle). So when sata_sil is unloaded, and hda-intel is not sharing 
the IRQ, the mic. is working all the time. Look at [3] to 
see /proc/interrupts output when laptop is booted from livecd, and mic works.

2) I tried to load hda-intel with enable_msi=1 (my RS480 chip is on blacklist, 
but I've removed it). Module loads and playback works ok, but problem with 
mic still exists. Difference here is that when recording stops to work the 
playback also stops to work (without MSI only mic stops to work). Look at [4] 
to see /proc/interrupts output when module is loaded with enable_msi=1.

Question:

What information I need to provide to help resolving the problem ? Where to 
start, because I've run out of ideas :) ?

References:
[1] https://bugtrack.alsa-project.org/alsa-bug/view.php?id=2449

######################################

[2] cat /proc/interrupts (IRQ sharing)
           CPU0 CPU1
  0: 71953009 0 local-APIC-edge-fasteoi timer
  1: 36662 1 IO-APIC-edge i8042
  8: 1 1 IO-APIC-edge rtc
 12: 147 1 IO-APIC-edge i8042
 14: 49 2 IO-APIC-edge ide0
 16: 681511809 679908107 IO-APIC-fasteoi sata_sil, HDA Intel
 18: 29 1 IO-APIC-fasteoi
 19: 430379 1 IO-APIC-fasteoi ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20: 0 1 IO-APIC-fasteoi sdhci:slot0, yenta
 21: 1231834 9 IO-APIC-fasteoi acpi
 23: 2273726 1 IO-APIC-fasteoi eth0
NMI: 0 0 Non-maskable interrupts
LOC: 0 71952388 Local timer interrupts
RES: 44883365 19180072 Rescheduling interrupts
CAL: 57631 790 function call interrupts
TLB: 7262 11762 TLB shootdowns
TRM: 0 0 Thermal event interrupts
SPU: 0 0 Spurious interrupts
ERR: 37465
MIS: 0

[ceho@ensima-hp ~]$ cat /proc/asound/version
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 
2007 UTC).

[ceho@ensima-hp ~]$ uname -a
Linux ensima-hp 2.6.24 #7 SMP PREEMPT Mon Feb 4 20:34:21 CET 2008 i686 AMD 
Turion(tm) 64 X2 Mobile Technology TL-56 AuthenticAMD GNU/Linux

######################################

[3] [fedora@localhost ~]$ cat /proc/interrupts
           CPU0 CPU1
  0: 3014988 0 local-APIC-edge-fasteoi timer
  1: 0 1881 IO-APIC-edge i8042
  8: 0 1 IO-APIC-edge rtc
 12: 0 151 IO-APIC-edge i8042
 14: 2 17391 IO-APIC-edge libata
 15: 0 0 IO-APIC-edge libata
 16: 1 49 IO-APIC-fasteoi yenta, firewire_ohci, tifm_7xx1, sdhci:slot0
 17: 0 23001 IO-APIC-fasteoi ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb3
 18: 0 260787 IO-APIC-fasteoi HDA Intel
 20: 0 297695 IO-APIC-fasteoi eth1
 21: 3 2304 IO-APIC-fasteoi acpi
NMI: 0 0
LOC: 0 3014807
ERR: 15
MIS: 0

[fedora@localhost ~]$ cat /proc/asound/version
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 23 06:09:18 
2007 UTC).

[fedora@localhost ~]$ uname -a
Linux localhost.localdomain 2.6.23.1-42.fc8 #1 SMP Tue Oct 30 13:55:12 EDT 
2007 i686 athlon i386 GNU/Linux

######################################

[4] cat /proc/interrupts
           CPU0       CPU1
  0:   51997092          0  local-APIC-edge-fasteoi   timer
  1:      50850          2   IO-APIC-edge      i8042
  8:          1          1   IO-APIC-edge      rtc
 12:        792          2   IO-APIC-edge      i8042
 14:       9331          2   IO-APIC-edge      ide0
 16:          0          1   IO-APIC-fasteoi   yenta, sdhci:slot0
 17:    3449488     190200   IO-APIC-fasteoi   eth0
 18:     492896          6   IO-APIC-fasteoi   sata_sil
 20:     457421          1   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, 
ohci_hcd:usb3
 21:     181549          9   IO-APIC-fasteoi   acpi
220:      50035    1136607   PCI-MSI-edge      HDA Intel
NMI:          0          0   Non-maskable interrupts
LOC:          0   51994900   Local timer interrupts
RES:    3435250    2342689   Rescheduling interrupts
CAL:       9842       2528   function call interrupts
TLB:      11148      18295   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:        113
MIS:          0

######################################

[4] I'll attach dmesg output in next message.

-- 
Greetings
Grzegorz Chwesewicz, Chilan 
mailto:grzegorz.chwesewicz@chilan.com
