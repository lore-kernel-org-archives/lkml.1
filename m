Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYCNQRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYCNQRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYCNQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:16:49 -0400
Received: from catapult-mx.catapult.com ([192.94.66.29]:1804 "EHLO
	Catapult-mx.catapult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYCNQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:16:47 -0400
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 12:16:47 EDT
Subject: Timer interrupt stops, causes soft lockup
From: "Joel K. Greene" <joel.greene@catapult.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
References: <1204653133.718.14.camel@linuxdt036.nc.catapult.com>
	 <47CD634E.2828.00B3.0@novell.com>
	 <1204722318.6578.12.camel@linuxdt036.nc.catapult.com>
	 <47CE45D8.2828.00B3.0@novell.com>
	 <1204728175.6578.23.camel@linuxdt036.nc.catapult.com>
	 <47D3DC53.2828.00B3.0@novell.com>
	 <1205152374.18463.17.camel@linuxdt036.nc.catapult.com>
	 <1205235450.18463.45.camel@linuxdt036.nc.catapult.com>
	 <47D6423D.1E6F.00AA.0@novell.com>
	 <1205255048.18463.60.camel@linuxdt036.nc.catapult.com>
	 <1205260328.18463.67.camel@linuxdt036.nc.catapult.com>
	 <47D68B9D.1E6F.00AA.0@novell.com>
	 <1205265642.18463.82.camel@linuxdt036.nc.catapult.com>
	 <1205322793.20205.9.camel@linuxdt036.nc.catapult.com>
	 <1205326713.20205.27.camel@linuxdt036.nc.catapult.com>
	 <1205332212.20205.33.camel@linuxdt036.nc.catapult.com>
Content-Type: text/plain
Organization: Catapult Communications Corporation
Date: Fri, 14 Mar 2008 11:53:29 -0400
Message-Id: <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

We have been seeing a condition where wall time gets stuck in a 4-second
loop:
        lab-m500-5:~ # date
        Thu Mar 13 17:54:48 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:49 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:49 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:45 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:46 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:46 EDT 2008
        lab-m500-5:~ # date
        Thu Mar 13 17:54:47 EDT 2008

Of course when time stops progessing forward at a steady pace all
sorts of Bad Things happen.  

The clock loop is caused by jiffies not incrementing. It seems that wall
time updates itself and then resync's with jiffies every ~4s.

We verified that all spinlocks ( xtime_lock in particular ) were not
being held, and that the kernel had no reason not to update jiffies.
Other interrupts continue to fire, so we're not stuck in the timer
handler.

So, we went on to look at the PIC. We threw together a little kernel
module to get some debug info.

What we found is that when the time loop occurs, the PIC registers look
like this:

                ... PIC  IMR: ff00
                ... PIC  IRR: 0001
                ... PIC  ISR: 0001
                ... PIC ELCR: 0e00
                

When running correctly these registers look like:

                        ... PIC  IMR: fffa
                        ... PIC  IRR: 0000
                        ... PIC  ISR: 0000
                        ... PIC ELCR: 0ea0
        
        
The Interrupt Mask Register masks off the corresponding interrupts,
preventing the CPU from getting these. In the bad state, all interrupts
have been enabled. This is wrong, but does not seem to contribute to the
problem directly. I do not believe that INT2, INT4-INT7 are connected to
anything in our system.  But the register is getting stomped, and we
have no idea how.

The Interrupt Request Register shows that the PIC has received an
interrupt request from the hardware - the timer, in our case. However,
this is a problem here because the timer interrupt is edge-triggered. As
we understand it, the IRR bit should never get set for an edge-triggered
interrupt.

The In Service Register indicates which interrupt the PIC thinks the CPU
is processing at the time. This bit staying set indicates that the PIC
thinks that the CPU is in the timer interrupt handler. This is what is
preventing the PIC from interrupting the CPU again. Presumably, the PIC
missed the End of Interrupt cycle for the last timer interrupt. We are
about 90% certain that the PIC is configured in Auto-EOI mode.

We have found that calling the kernel functions mask_and_ack_8259A and
init_8259A will clear the ISR bit and allow the timer interrupt, and
therefore the system, to go back to functioning normally. ( As far as we
can tell ) When we do this, the registers show:

        ... PIC  IMR: ff00
        ... PIC  IRR: 0001
        ... PIC  ISR: 0000
        ... PIC ELCR: 0ea0
        
IMR,IRR, and ELCR are not corrected, but do not see to affect system
operation
- as far as we can tell. We are not comfortable enough to declare the
system "stable" after this recovery, but have not found anything that
doesn't work.

So- 
We have no idea what is getting us into this state other than the vague
impression that it is caused by hardware delays. HZ=1000 seems to
aggragate it, even without our cPCI cards or SW in the system. Others
seem to have had verious hardware failures, including faulty DIMMs lead
to this. It _seems_ to be a race aggravated by hardware delays.

We originally saw this on the SLED10 kernel - SuSE's version of
2.6.16.21 - where the issue would occur in a matter of weeks or months.
We have been working with Novell, and have duplicate it on SuSE's
updated kernels 2.6.16.46 and 2.6.16.54. Yesterday I pulled down
2.6.16.60 from kernel.org and built that kernel with HZ=1000 and
reproduced the problem in about 7 hours. We are testing with HZ=100, but
have no conclusive data yet.  We have run the same systems on SuSE 9.2
( 2.6.8 ) with no known occurances. We have no confirmed sightings on
several other platforms running the same SLED10 and very similar
applications. 

We have over 10 systems demonstrating the problem, many in customer
sites. 

We have disabled irg balancer, and determined that is not a cause.
Binding all interrupts to CPU0 does seem to make the problem happen
faster, but staticaly distributing them does not prevent.

We have a 2.6.16.54-0.2.5-smp running HZ=100 that we are monitoring SMI
on to see if perhaps SMM is biting us, but have no data yet. 

This is running on a Kontron DT-64:
http://us.kontron.com/index.php?id=226&cat=480&productid=103
It's a dual P3 with a ServerWorks chipset. The PIC is implemented in a
CSB5 v2.1, rev 0x11.


Per suggetions in the lkml FAQ, I'm not posting .config and lots of
other stuff ( first time caller...). I can provide anything on
request... The only change I have made from the SLED10
config-2.6.16.21-0.8-smp is CONFIG_HZ_1000=y.

Please cc: me on any replies.

Any advice appreciated!!!

Thanks,
Joel.






Devices:
lab-m500-5:~ # lspci
00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 06)
00:03.0 VGA compatible controller: Chips and Technologies F69000
HiQVideo (rev 64)
00:0f.0 Host bridge: Broadcom CSB5 South Bridge (rev 93)
00:0f.1 IDE interface: Broadcom CSB5 IDE Controller (rev 93)
00:0f.2 USB Controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 05)
00:0f.3 ISA bridge: Broadcom CSB5 LPC bridge
01:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet
Controller (Copper) (rev 02)
01:03.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet
Controller (Copper) (rev 02)
01:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (transparent
mode) (rev 04)
02:0f.0 PCI bridge: Intel Corporation 21154 PCI-to-PCI Bridge
03:0d.0 PCI bridge: Intel Corporation 21154 PCI-to-PCI Bridge
03:0e.0 PCI bridge: Intel Corporation 21154 PCI-to-PCI Bridge
03:0f.0 PCI bridge: Intel Corporation 21154 PCI-to-PCI Bridge
        


EXCERPTS from boot.msg:

<5>Linux version 2.6.16.60-smp (root@linuxdt036) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #1 SMP Thu Mar 13 11:08:55 EDT 2008
<6>BIOS-provided physical RAM map:
<4> BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
<4> BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 0000000040000000 (usable)
<4> BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
<4> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<4> BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
<5>824MB HIGHMEM available.
<5>200MB LOWMEM available.
<6>found SMP MP-table at 000f7860
<7>On node 0 totalpages: 262144
<7>  DMA zone: 4096 pages, LIFO batch:0
<7>  DMA32 zone: 0 pages, LIFO batch:0
<7>  Normal zone: 47104 pages, LIFO batch:15
<7>  HighMem zone: 210944 pages, LIFO batch:31
<6>DMI present.
<6>Using APIC driver default
<3>ACPI: Unable to locate RSDP
<6>Intel MultiProcessor Specification v1.4
<6>    Virtual Wire compatibility mode.
<6>OEM ID: RCC      Product ID: LE30 SERVER APIC at: 0xFEE00000
<4>Processor #3 6:11 APIC version 17
<4>Processor #0 6:11 APIC version 17
<6>I/O APIC #1 Version 17 at 0xFEC00000.
<6>I/O APIC #2 Version 17 at 0xFEC01000.
<6>I/O APIC #4 Version 17 at 0xFEC02000.
<6>I/O APIC #5 Version 17 at 0xFEC03000.
<4>Enabling APIC mode:  Flat.  Using 4 I/O APICs
<6>Processors: 2
<4>Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
<4>Built 1 zonelists
<5>Kernel command line: root=/dev/hda6 vga=0x314  splash=verbose  catt_mach=m500-1 vmalloc=824M
<7>mapped APIC to ffffd000 (fee00000)
<7>mapped IOAPIC to ffffc000 (fec00000)
<7>mapped IOAPIC to ffffb000 (fec01000)
<7>mapped IOAPIC to ffffa000 (fec02000)
<7>mapped IOAPIC to ffff9000 (fec03000)
<6>Enabling fast FPU save and restore... done.
<6>Enabling unmasked SIMD FPU exception support... done.
<6>Initializing CPU#0
<4>PID hash table entries: 1024 (order: 10, 16384 bytes)
<4>Detected 931.108 MHz processor.
<6>Using tsc for high-res timesource
<4>Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
<4>Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
<6>Memory: 1032764k/1048576k available (1562k kernel code, 14640k reserved, 655k data, 192k init, 843776k highmem)
<4>Checking if this processor honours the WP bit even in supervisor mode... Ok.
<4>Calibrating delay using timer specific routine.. 1863.47 BogoMIPS (lpj=931736)
<6>Security Framework v1.0.0 initialized
<4>Mount-cache hash table entries: 512
<7>CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
<7>CPU: After vendor identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
<6>CPU: L1 I cache: 16K, L1 D cache: 16K
<6>CPU: L2 cache: 512K
<7>CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
<6>Intel machine check architecture supported.
<6>Intel machine check reporting enabled on CPU#0.
<6>Checking 'hlt' instruction... OK.
<4>CPU0: Intel(R) Pentium(R) III CPU - S          933MHz stepping 04
<4>Booting processor 1/0 eip 3000
<6>Initializing CPU#1
<4>Calibrating delay using timer specific routine.. 1861.64 BogoMIPS (lpj=930820)
<7>CPU: After generic identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
<7>CPU: After vendor identify, caps: 0383fbff 00000000 00000000 00000000 00000000 00000000 00000000
<6>CPU: L1 I cache: 16K, L1 D cache: 16K
<6>CPU: L2 cache: 512K
<7>CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
<6>Intel machine check architecture supported.
<6>Intel machine check reporting enabled on CPU#1.
<4>CPU1: Intel(R) Pentium(R) III CPU - S          933MHz stepping 04
<6>Total of 2 processors activated (3725.11 BogoMIPS).
<4>ExtINT not setup in hardware but reported by MP table
<4>ENABLING IO-APIC IRQs
<6>..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
<3>..MP-BIOS bug: 8254 timer not connected to IO-APIC
<6>...trying to set up timer (IRQ0) through the 8259A ...
<4>..... (found pin 0) ...works.
<6>checking TSC synchronization across 2 CPUs: passed.
<6>Brought up 2 CPUs
<4>migration_cost=2082
<6>PCI: PCI BIOS revision 2.10 entry at 0xfda21, last bus=6
<6>PCI: Using configuration type 1
<6>ACPI: Subsystem revision 20060127
<6>ACPI: Interpreter disabled.
<6>SvrWks CSB5: IDE controller at PCI slot 0000:00:0f.1
<6>SvrWks CSB5: chipset revision 147
<6>SvrWks CSB5: not 100% native mode: will probe irqs later
<6>piix4_smbus 0000:00:0f.0: Found 0000:00:0f.0 device
<6>piix4_smbus 0000:00:0f.0: Unusual config register value
<6>piix4_smbus 0000:00:0f.0: Try using fix_hstcfg=1 if you experience problems
<3>piix4_smbus 0000:00:0f.0: Illegal Interrupt configuration (or code out of date)!


