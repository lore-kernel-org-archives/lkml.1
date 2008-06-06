Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbYFFVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbYFFVPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbYFFVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:14:39 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:47677 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932593AbYFFVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:14:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 17:14:37 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=oROiKCc1719dLcpTqacToe/Ad5XSqMyY++Z0k8Q1/VuRpGFAZ1SG8KP9IgdvpIiq2ieW2GPfsIA8//YFVJODAvcRr4CHFsQGZXaleQ2+DOKA64Kg6bjrRJnJ/kmVTt2cOoj7nGcInFxBDvEM4L7jL349FC2F+U5Vh9bAfbX/Rcc=;
X-YMail-OSG: 6dWEEhgVM1n7Fe.X7c0xAYzPkKISLuTgY2LoMrb01dhIIuufN5C13Qm_dzAywr3r0tj5tyAQBUPpRqimBvb.rNEIEGSrbZyYUQ--
Date: Fri, 6 Jun 2008 14:07:55 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Linux-next Alsa hda_intel events/0 high CPU usage, bisected
To: linux-kernel@vger.kernel.org
Cc: benjkidwell@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <442229.60477.qm@web53706.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux-next Alsa hda_intel events/0 high CPU usage, bisected

During sound playback with recent linux-next-20080806 I observed much higher
than usual cpu usage for the events/0 process, locked at a near constant 4.3%
according to ps. 2.6.25-rc5 does not exhibit this behavior on my machine.

I git-bisected and arrived at this commit to sound/pci/hda/hda_intel.c
8a4bd4dff53ad23c32ffc0b366e592319dd566a4
which fixes IRQ timing issues.

As a very crude debugging test, I short-circuited this decision:

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1489,7 +1489,7 @@
        }
 
        if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
-               return 0; /* NG - it's below the period boundary */
+               return 1; /* Tell a lie */
        return 1; /* OK, it's fine */
 }

and sure enough, the events/0 process cpu load dropped down to its usual
level, undetectable with top and ps. I don't know if the high events/0 load is
the intended behavior of this code on my hardware or not. Sound playback and
general system behavior seemed subjectively equivalent regardless of the
highly active events/0 process. 

This report is from /dev/random_user and I'm not qualified to diff bugs vs.
features, so sorry if this message is just noise. I'm happy to provide more
info if needed. 

Here's a bit of relevant info from my machine from a run with the high
events/0 usage. A few bits of dmesg:

[    0.066419] ACPI: Core revision 20080321
[    0.075988] ENABLING IO-APIC IRQs
[    0.075988] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.075988] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.075988] ...trying to set up timer (IRQ0) through the 8259A ...  
failed.
[    0.075988] ...trying to set up timer as Virtual Wire IRQ... works.
[    0.086170] CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.086986] CPU 1 irqstacks, hard=c0359000 soft=c0357000
[    0.086986] Booting processor 1/1 ip 6000
[    0.096985] Initializing CPU#1
[    0.096985] Calibrating delay using timer specific routine.. 5998.67
BogoMIPS (lpj=2999338)
[    0.160975] ACPI: bus type pci registered
[    0.160975] PCI: MCFG configuration 0: base e0000000 segment 0 buses
 0 -
255
[    0.160975] PCI: MCFG area at e0000000 reserved in E820
[    0.160975] PCI: Using MMCONFIG for extended config space
[    0.160975] PCI: Using configuration type 1 for base access
[    0.160975] Setting up standard PCI resources
[    0.166580] ACPI: EC: Look up EC in DSDT
[    0.172973] ACPI: Interpreter enabled
[    0.172977] ACPI: (supports S0 S3 S5)
[    0.173185] ACPI: Using IOAPIC for interrupt routing
[    0.179736] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.180460] PCI: Transparent bridge - 0000:00:14.4
[    0.180566] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.180972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.194970] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.195606] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.196309] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.197026] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.197969] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11)
[    0.198286] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.198989] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.199567] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 10 11)
[   17.037709] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   17.135812] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, 
low) -> IRQ 16
[   27.183697] hda-intel: Invalid position buffer, using LPIB read 
method instead.

output of lsmod:

ipv6                  223300  12 
cpufreq_userspace       2988  0 
cpufreq_stats           4748  0 
cpufreq_powersave       1792  0 
cpufreq_ondemand        6796  0 
freq_table              3592  2 cpufreq_stats,cpufreq_ondemand
sbs                    11144  0 
sbshc                   4864  1 sbs
container               3456  0 
battery                10116  0 
iptable_filter          2688  0 
ip_tables               9872  1 iptable_filter
x_tables               12164  1 ip_tables
ac                      4228  0 
loop                   13452  0 
af_packet              15232  2 
snd_hda_intel          55692  3 
snd_pcm                62084  1 snd_hda_intel
snd_timer              18312  1 snd_pcm
serio_raw               5124  0 
snd                    39092  9 snd_hda_intel,snd_pcm,snd_timer
psmouse                23432  0 
i2c_piix4               7696  0 
soundcore               5984  1 snd
snd_page_alloc          7304  2 snd_hda_intel,snd_pcm
i2c_core               18324  1 i2c_piix4
ati_agp                 6540  0 
agpgart                26312  1 ati_agp
button                  6032  0 
evdev                   8704  3 
ext3                  116616  1 
jbd                    39828  1 ext3
mbcache                 6404  1 ext3
usbhid                 19364  0 
hid                    36096  1 usbhid
ide_cd_mod             29444  0 
cdrom                  33056  1 ide_cd_mod
sd_mod                 20760  3 
pata_atiixp             4608  0 
8139too                20992  0 
8139cp                 17408  0 
mii                     4480  2 8139too,8139cp
atiixp                  3588  0 [permanent]
ehci_hcd               31372  0 
ohci_hcd               20228  0 
sata_sil                7560  2 
pata_acpi               3968  0 
ata_generic             4868  0 
usbcore               120176  4 usbhid,ehci_hcd,ohci_hcd
libata                139616  4 
pata_atiixp,sata_sil,pata_acpi,ata_generic
scsi_mod               85448  2 sd_mod,libata
dock                    7824  1 libata
ide_pci_generic         4100  0 [permanent]
ide_core               84904  3 ide_cd_mod,atiixp,ide_pci_generic
thermal                15004  0 
processor              31424  1 thermal
fan                     4228  0 
fuse                   45468  3 

audio entry snipped from lspci -vvv
00:14.2 Audio device: ATI Technologies Inc IXP SB4x0 High Definition 
Audio Controller (rev 01)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 725a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at fdff4000 (64-bit, non-prefetchable) 
[size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
 PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000



      
