Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKBOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKBOok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 09:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYKBOoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 09:44:32 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:37339 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYKBOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 09:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=heIzzW7j/voalc/LOK/UIyjOfSBkgQU0nyEwcKEQdcjoxTkSvoHrxxceap8NbCljgt
         R+3jHb/logGwM/zO4mkLJLibogYZNZZoFNPaM9CFZ3e1WWaCrUYYkpb5jGNyKADxLg2F
         htQW6a6iykgqyr+H8kESScM2/l2ZKI35KAcVA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: upstream regression (IO-APIC?)
Date: Sun, 2 Nov 2008 15:37:24 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Alok N Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Pavel Machek <pavel@suse.cz>
References: <fa.mewpISr5S4wcdUNw1DVfOnQfl8s@ifi.uio.no> <4909011F.1050102@shaw.ca>
In-Reply-To: <4909011F.1050102@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811021537.24771.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, Robert Hancock wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > The current Linus tree as of commit e946217e4fdaa67681bbabfa8e6b18641921f750
> > is broken for me.  I get either the following panic (see log from qemu below)
> > or lost IRQs on ATA init...  Is this a known issue?
> > 
> > PS The tree that I used before and was supposedly good (sorry, I'm too tired
> > to verify it now) had commit 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 at head.

Unfortunately 57f8f7b60db6f1ed2c6918ab9230c4623a9dbe37 (v2.6.28-rc1)
is also bad.  Bisecting it further was a real pain (i.e. I hit broken
build with x86 irqbalance changes, broken build with netfilter nat
changes and jbd journal problem).  In the end it turned out that 2.6.27
is bad too!  However with 2.6.27 the panic occurs only once per several
attempts and if there is no panic kernel boots normally (no lost IRQs).

[...]

I finally managed to narrow it down to change making x86 use tsc_khz
for loops_per_jiffy -- commit 3da757daf86e498872855f0b5e101f763ba79499
("x86: use cpu_khz for loops_per_jiffy calculation").  This approach
seems too simplistic (as I see now Arjan & Pavel expressed concerns
about it back when the patch was posted initially [1][2]).  Also it
would probably be preferred to re-use existing preset_lpj variable
(just like KVM does it for similar purpose [3]) instead of adding a
lpj_tsc one and increasing complexity.

[2] http://lkml.org/lkml/2008/6/4/216
[2] http://lkml.org/lkml/2008/6/27/87
[3] http://www.mail-archive.com/kvm@vger.kernel.org/msg02013.html

Applying following hack to current Linus tree fixes the panic:

---
 init/calibrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/init/calibrate.c
===================================================================
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -128,7 +128,7 @@ void __cpuinit calibrate_delay(void)
 		loops_per_jiffy = preset_lpj;
 		printk(KERN_INFO
 			"Calibrating delay loop (skipped) preset value.. ");
-	} else if ((smp_processor_id() == 0) && lpj_fine) {
+	} else if ((smp_processor_id() == 0) && lpj_fine && 0) {
 		loops_per_jiffy = lpj_fine;
 		printk(KERN_INFO
 			"Calibrating delay loop (skipped), "


> What's the bootup dmesg from a working kernel?

Here is a diff between dmesgs for good/bad kernel:

--- log-3.txt	2008-11-02 13:29:56.000000000 +0100
+++ log-1.txt	2008-11-02 13:19:54.000000000 +0100
@@ -1,6 +1,6 @@
 [    0.000000] Initializing cgroup subsys cpuset
 [    0.000000] Initializing cgroup subsys cpu
-[    0.000000] Linux version 2.6.26-rc6 (bzolnier@localhost.localdomain) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #85 SMP Sun Nov 2 13:29:08 CET 2008
+[    0.000000] Linux version 2.6.26-rc6 (bzolnier@localhost.localdomain) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #84 SMP Sun Nov 2 13:15:10 CET 2008
 [    0.000000] PAT disabled. Not yet verified on this CPU type.
 [    0.000000] BIOS-provided physical RAM map:
 [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
@@ -43,7 +43,7 @@
 [    0.000000] Enabling unmasked SIMD FPU exception support... done.
 [    0.000000] Initializing CPU#0
 [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
-[    0.000000] Detected 1495.128 MHz processor.
+[    0.000000] Detected 1495.176 MHz processor.
 [    0.000999] Console: colour VGA+ 80x25
 [    0.000999] console [ttyS0] enabled
 [    0.000999] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
@@ -55,61 +55,65 @@
 [    0.000999]     vmalloc : 0xc8800000 - 0xff3fe000   ( 875 MB)
 [    0.000999]     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
 [    0.000999]       .init : 0xc0404000 - 0xc0435000   ( 196 kB)
-[    0.000999]       .data : 0xc0354a54 - 0xc03fe670   ( 679 kB)
-[    0.000999]       .text : 0xc0200000 - 0xc0354a54   (1362 kB)
+[    0.000999]       .data : 0xc0354a4c - 0xc03fe670   ( 679 kB)
+[    0.000999]       .text : 0xc0200000 - 0xc0354a4c   (1362 kB)
 [    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
 [    0.000999] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
-[    0.061990] Calibrating delay using timer specific routine.. 11980.95 BogoMIPS (lpj=5990477)
-[    0.061990] Mount-cache hash table entries: 512
-[    0.062990] Initializing cgroup subsys ns
-[    0.062990] Initializing cgroup subsys cpuacct
-[    0.062990] CPU: L1 I cache: 32K, L1 D cache: 32K
-[    0.062990] CPU: L2 cache: 2048K
-[    0.062990] Checking 'hlt' instruction... OK.
-[    0.069989] SMP alternatives: switching to UP code
-[    0.080987] Freeing SMP alternatives: 7k freed
-[    0.080987] ACPI: Core revision 20080321
-[    0.083987] ENABLING IO-APIC IRQs
-[    0.084986] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
-[    0.095985] CPU0: Intel Pentium II (Klamath) stepping 03
-[    0.095985] APIC calibration not consistent with PM Timer: 400ms instead of 100ms
-[    0.095985] APIC delta adjusted to PM-Timer: 6249997 (25001456)
-[    0.095985] Brought up 1 CPUs
-[    0.096515] Total of 1 processors activated (11980.95 BogoMIPS).
-[    0.098984] Time: 12:29:40  Date: 11/02/08
-[    0.099984] No dock devices found.
-[    0.100984] ACPI: bus type pci registered
-[    0.100984] PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
-[    0.100984] PCI: Using configuration type 1 for base access
-[    0.101791] Setting up standard PCI resources
-[    0.110983] ACPI: Interpreter enabled
-[    0.110983] ACPI: (supports S0 S5)
-[    0.110983] ACPI: Using IOAPIC for interrupt routing
-[    0.115461] ACPI: PCI Root Bridge [PCI0] (0000:00)
-[    0.115982] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
-[    0.115982] * this clock source is slow. Consider trying other clock sources
-[    0.116914] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
-[    0.116982] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
-[    0.119981] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
-[    0.119981] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
-[    0.120925] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
-[    0.120981] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
-[    0.121581] Linux Plug and Play Support v0.97 (c) Adam Belay
-[    0.121981] pnp: PnP ACPI init
-[    0.121981] ACPI: bus type pnp registered
-[    0.124980] pnp: PnP ACPI: found 6 devices
-[    0.124980] ACPI: ACPI bus type pnp unregistered
-[    0.125980] SCSI subsystem initialized
-[    0.126980] PCI: Using ACPI for IRQ routing
-[    0.126980] ACPI: Failed to create genetlink family for ACPI event
-[    0.167988] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
-[    0.223568] msgmni has been set to 247
-[    0.223995] io scheduler noop registered (default)
-[    0.223995] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
-[    0.223995] pci 0000:00:01.0: PIIX3: Enabling Passive Release
-[    0.223995] pci 0000:00:01.0: Activating ISA DMA hang workarounds
-[    0.227980] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
-[    0.276002] Non-volatile memory driver v1.2
-[    0.276002] Linux agpgart interface v0.103
-[    0.279950] [drm] Initialized drm 1.1.0 20060810
-[    0.279994] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
+[    0.001999] Calibrating delay loop (skipped), using tsc calculated value.. <6>2990.35 BogoMIPS (lpj=1495176)
+[    0.001999] Mount-cache hash table entries: 512
+[    0.002999] Initializing cgroup subsys ns
+[    0.002999] Initializing cgroup subsys cpuacct
+[    0.002999] CPU: L1 I cache: 32K, L1 D cache: 32K
+[    0.002999] CPU: L2 cache: 2048K
+[    0.002999] Checking 'hlt' instruction... OK.
+[    0.006998] SMP alternatives: switching to UP code
+[    0.017997] Freeing SMP alternatives: 7k freed
+[    0.017997] ACPI: Core revision 20080321
+[    0.020996] ENABLING IO-APIC IRQs
+[    0.021996] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
+[    0.024996] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
+[    0.024996] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
+[    0.024996] ...trying to set up timer as Virtual Wire IRQ... failed.
+[    0.024996] ...trying to set up timer as ExtINT IRQ... works.
+[    0.029995] CPU0: Intel Pentium II (Klamath) stepping 03
+[    0.029995] APIC calibration not consistent with PM Timer: 399ms instead of 100ms
+[    0.029995] APIC delta adjusted to PM-Timer: 6249993 (24999711)
+[    0.029995] Brought up 1 CPUs
+[    0.029995] Total of 1 processors activated (2990.35 BogoMIPS).
+[    0.052991] Time: 12:19:35  Date: 11/02/08
+[    0.052991] No dock devices found.
+[    0.053991] ACPI: bus type pci registered
+[    0.053991] PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
+[    0.053991] PCI: Using configuration type 1 for base access
+[    0.053991] Setting up standard PCI resources
+[    0.062990] ACPI: Interpreter enabled
+[    0.062990] ACPI: (supports S0 S5)
+[    0.063514] ACPI: Using IOAPIC for interrupt routing
+[    0.067989] ACPI: PCI Root Bridge [PCI0] (0000:00)
+[    0.068989] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
+[    0.068989] * this clock source is slow. Consider trying other clock sources
+[    0.068989] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
+[    0.068989] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
+[    0.071988] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
+[    0.071988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
+[    0.072988] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
+[    0.072988] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
+[    0.073988] Linux Plug and Play Support v0.97 (c) Adam Belay
+[    0.073988] pnp: PnP ACPI init
+[    0.073988] ACPI: bus type pnp registered
+[    0.076988] pnp: PnP ACPI: found 6 devices
+[    0.076988] ACPI: ACPI bus type pnp unregistered
+[    0.077988] SCSI subsystem initialized
+[    0.078987] PCI: Using ACPI for IRQ routing
+[    0.078987] ACPI: Failed to create genetlink family for ACPI event
+[    0.123598] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
+[    0.175956] msgmni has been set to 247
+[    0.175956] io scheduler noop registered (default)
+[    0.175956] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
+[    0.175956] pci 0000:00:01.0: PIIX3: Enabling Passive Release
+[    0.179499] pci 0000:00:01.0: Activating ISA DMA hang workarounds
+[    0.180361] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
+[    0.227973] Non-volatile memory driver v1.2
+[    0.227973] Linux agpgart interface v0.103
+[    0.232105] [drm] Initialized drm 1.1.0 20060810
+[    0.232105] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled

and also one for success/fail runs with bad kernel:

--- log-1.txt	2008-11-02 13:19:54.000000000 +0100
+++ log-2.txt	2008-11-02 13:19:24.000000000 +0100
@@ -43,7 +43,7 @@
 [    0.000000] Enabling unmasked SIMD FPU exception support... done.
 [    0.000000] Initializing CPU#0
 [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
-[    0.000000] Detected 1495.176 MHz processor.
+[    0.000000] Detected 1495.107 MHz processor.
 [    0.000999] Console: colour VGA+ 80x25
 [    0.000999] console [ttyS0] enabled
 [    0.000999] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
@@ -59,61 +59,49 @@
 [    0.000999]       .text : 0xc0200000 - 0xc0354a4c   (1362 kB)
 [    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
 [    0.000999] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
-[    0.001999] Calibrating delay loop (skipped), using tsc calculated value.. <6>2990.35 BogoMIPS (lpj=1495176)
+[    0.001999] Calibrating delay loop (skipped), using tsc calculated value.. <6>2990.21 BogoMIPS (lpj=1495107)
 [    0.001999] Mount-cache hash table entries: 512
 [    0.002999] Initializing cgroup subsys ns
 [    0.002999] Initializing cgroup subsys cpuacct
-[    0.002999] CPU: L1 I cache: 32K, L1 D cache: 32K
-[    0.002999] CPU: L2 cache: 2048K
-[    0.002999] Checking 'hlt' instruction... OK.
-[    0.006998] SMP alternatives: switching to UP code
-[    0.017997] Freeing SMP alternatives: 7k freed
-[    0.017997] ACPI: Core revision 20080321
-[    0.020996] ENABLING IO-APIC IRQs
-[    0.021996] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
-[    0.024996] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
-[    0.024996] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
-[    0.024996] ...trying to set up timer as Virtual Wire IRQ... failed.
-[    0.024996] ...trying to set up timer as ExtINT IRQ... works.
-[    0.029995] CPU0: Intel Pentium II (Klamath) stepping 03
-[    0.029995] APIC calibration not consistent with PM Timer: 399ms instead of 100ms
-[    0.029995] APIC delta adjusted to PM-Timer: 6249993 (24999711)
-[    0.029995] Brought up 1 CPUs
-[    0.029995] Total of 1 processors activated (2990.35 BogoMIPS).
-[    0.052991] Time: 12:19:35  Date: 11/02/08
-[    0.052991] No dock devices found.
-[    0.053991] ACPI: bus type pci registered
-[    0.053991] PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
-[    0.053991] PCI: Using configuration type 1 for base access
-[    0.053991] Setting up standard PCI resources
-[    0.062990] ACPI: Interpreter enabled
-[    0.062990] ACPI: (supports S0 S5)
-[    0.063514] ACPI: Using IOAPIC for interrupt routing
-[    0.067989] ACPI: PCI Root Bridge [PCI0] (0000:00)
-[    0.068989] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
-[    0.068989] * this clock source is slow. Consider trying other clock sources
-[    0.068989] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
-[    0.068989] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
-[    0.071988] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
-[    0.071988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
-[    0.072988] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
-[    0.072988] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
-[    0.073988] Linux Plug and Play Support v0.97 (c) Adam Belay
-[    0.073988] pnp: PnP ACPI init
-[    0.073988] ACPI: bus type pnp registered
-[    0.076988] pnp: PnP ACPI: found 6 devices
-[    0.076988] ACPI: ACPI bus type pnp unregistered
-[    0.077988] SCSI subsystem initialized
-[    0.078987] PCI: Using ACPI for IRQ routing
-[    0.078987] ACPI: Failed to create genetlink family for ACPI event
-[    0.123598] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
-[    0.175956] msgmni has been set to 247
-[    0.175956] io scheduler noop registered (default)
-[    0.175956] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
-[    0.175956] pci 0000:00:01.0: PIIX3: Enabling Passive Release
-[    0.179499] pci 0000:00:01.0: Activating ISA DMA hang workarounds
-[    0.180361] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
-[    0.227973] Non-volatile memory driver v1.2
-[    0.227973] Linux agpgart interface v0.103
-[    0.232105] [drm] Initialized drm 1.1.0 20060810
-[    0.232105] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
+[    0.003678] CPU: L1 I cache: 32K, L1 D cache: 32K
+[    0.003965] CPU: L2 cache: 2048K
+[    0.003999] Checking 'hlt' instruction... OK.
+[    0.007998] SMP alternatives: switching to UP code
+[    0.018997] Freeing SMP alternatives: 7k freed
+[    0.018997] ACPI: Core revision 20080321
+[    0.021996] ENABLING IO-APIC IRQs
+[    0.022996] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
+[    0.025996] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
+[    0.025996] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
+[    0.025996] ...trying to set up timer as Virtual Wire IRQ... failed.
+[    0.025996] ...trying to set up timer as ExtINT IRQ... failed :(.
+[    0.029995] Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option
+[    0.029995] general protection fault: fffa [#1] SMP 
+[    0.029995] Modules linked in:
+[    0.029995] 
+[    0.029995] Pid: 1, comm: swapper Not tainted (2.6.26-rc6 #84)
+[    0.029995] EIP: 0060:[<c0354b63>] EFLAGS: 00000246 CPU: 0
+[    0.029995] EIP is at 0xc0354b63
+[    0.029995] EAX: 00000000 EBX: ffffffff ECX: 00000000 EDX: ffffffff
+[    0.029995] ESI: 00000000 EDI: 00000002 EBP: 00000000 ESP: c7825e28
+[    0.029995]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
+[    0.029995] Process swapper (pid: 1, ti=c7824000 task=c7820000 task.ti=c7824000)
+[    0.029995] Stack: ffffffff fffffff6 c040e64c c0399b31 c0399b24 00000000 00000000 00000000 
+[    0.029995]        00000971 01000000 00000008 00000026 00000000 00000000 00000000 00000246 
+[    0.029995]        ffffffff 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
+[    0.029995] Call Trace:
+[    0.029995]  [<c040e64c>] setup_IO_APIC+0xd78/0xdbd
+[    0.029995]  [<c0208e00>] arch_ptrace+0x213/0x315
+[    0.029995]  [<c040b638>] native_smp_prepare_cpus+0x2c5/0x31c
+[    0.029995]  [<c04040e3>] kernel_init+0x0/0x25c
+[    0.029995]  [<c0404120>] kernel_init+0x3d/0x25c
+[    0.029995]  [<c021e9b6>] schedule_tail+0x17/0x44
+[    0.029995]  [<c020371a>] ret_from_fork+0x6/0x1c
+[    0.029995]  [<c04040e3>] kernel_init+0x0/0x25c
+[    0.029995]  [<c04040e3>] kernel_init+0x0/0x25c
+[    0.029995]  [<c02043cb>] kernel_thread_helper+0x7/0x10
+[    0.029995]  =======================
+[    0.029995] Code: 15 a0 c2 44 c0 89 c3 b8 58 89 41 00 e8 be 7a f5 ff 8d 74 1e 01 69 05 a4 c2 44 c0 e8 03 00 00 39 c6 7c d5 e8 13 8a ed ff fb 31 f6 <e8> 79 4d ef ff 89 f0 ff 15 a0 c2 44 c0 89 c3 b8 58 89 41 00 e8 
+[    0.029995] EIP: [<c0354b63>] 0xc0354b63 SS:ESP 0068:c7825e28
+[    0.029995] ---[ end trace 4eaa2a86a8e2da22 ]---
+[    0.029995] Kernel panic - not syncing: Attempted to kill init!
