Return-Path: <linux-kernel-owner+w=401wt.eu-S1423594AbXEAOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423594AbXEAOYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423587AbXEAOYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:24:36 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:49503 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423595AbXEAOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:24:33 -0400
Date: Tue, 1 May 2007 16:24:31 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: regression on quad Xeon: no SCSI-disks
Message-ID: <20070501142431.GA11667@erig.dyndns.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry
for detecting this 2 year old regression so late.

2.6.13 or later is bad.
2.6.12 is good,

"git bisect" worked fine and points to the attached patch.
The patch is pretty small. The problem seemed to be dependant
on the PCI-architecture of these particular systems.
Tried this on two machines with the same behaviour.

Wolfgang


$ git bisect bad 
299de0343c7d18448a69c635378342e9214b14af is first bad commit
commit 299de0343c7d18448a69c635378342e9214b14af
Author: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date:   Wed Jun 15 18:59:27 2005 +0400

    [PATCH] PCI: pci_assign_unassigned_resources() on x86
    
    - Add sanity check for io[port,mem]_resource in setup-bus.c. These
      resources look like "free" as they have no parents, but obviously
      we must not touch them.
    - In i386.c:pci_allocate_bus_resources(), if a bridge resource cannot be
      allocated for some reason, then clear its flags. This prevents any child
      allocations in this range, so the setup-bus code will work with a clean
      resource sub-tree.
    - i386.c:pcibios_enable_resources() doesn't enable bridges, as it checks
      only resources 0-5, which looks like a clear bug to me. I suspect it
      might break hotplug as well in some cases.
    
    From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 ecab084beb95987f3e4ead8b61ce19cc052a5fa3 4c1364a6fd511b6dc6ddec06d787bcf105687835 M      arch
:040000 040000 0956f28cde32bd7494d7a87e2814bcd726547a32 0d2e2b611b007085e5a0994a66fd9c0a873ac8f8 M      drivers

====== on console =======
sym0: <875> rev 0x26 at pci 0000:01:02.0 irq 30
sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.0
scsi 0:0:0:0 ABORT operation started.
scsi 0:0:0:0 ABORT operation timed-out.
scsi 0:0:0:0 DEVICE RESET operation started.
scsi 0:0:0:0 DEVICE RESET operation timed-out.
scsi 0:0:0:0 BUS RESET operation started.
scsi 0:0:0:0 BUS RESET operation timed-out.
      ....
no disk, no fun

$ lspci
00:02.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:02.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:02.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:02.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:03.0 VGA compatible controller: Cirrus Logic GD 5446 (rev 45)
00:04.0 System peripheral: Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller (rev 02)
00:05.0 PCI bridge: Intel Corporation 80960RP [i960 RP Microprocessor/Bridge] (rev 03)
00:05.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 03)
00:10.0 Host bridge: Intel Corporation 450NX - 82451NX Memory & I/O Controller (rev 03)
00:12.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
00:13.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
00:14.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
01:01.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)
01:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
03:0e.0 SCSI storage controller: QLogic Corp. QLA2100 64-bit Fibre Channel Adapter (rev 03)

$ lshw
    description: System
    product: PRIMERGY 870-40
    vendor: FUJITSU SIEMENS
    version: Rev.1
    serial: None
    width: 32 bits
    capabilities: smbios-2.1 dmi-2.1
    configuration: chassis=server
  *-core
       description: Motherboard
       product: D1998
       vendor: FUJITSU SIEMENS
       physical id: 0
       version: Rev.1
       serial: None
       slot: Xeon
     *-firmware
          description: BIOS
          vendor: Phoenix Technologies LTD
          physical id: 0
          version: 4.06  Rev. 3.11.1998 (12/16/99)
          size: 98KB
          capacity: 448KB
          capabilities: isa pci pnp apm upgrade shadowing escd cdboot bootselect socketedrom edd int13floppy360 int13floppy1200 int13floppy720 int13floppy2880 int14serial int17printer int10video usb
     *-cpu:0
          description: CPU
          product: Pentium III (Katmai)
          vendor: Intel Corp.
          physical id: 1
          bus info: cpu@0
          version: 6.7.3
          slot: Socket 0
          size: 550MHz
          width: 32 bits
          clock: 100MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
        *-cache:0
             description: L1 cache
             physical id: 4d
             slot: L1 Cache
             size: 32KB
             capabilities: synchronous internal write-back instruction
        *-cache:1
             description: L2 cache
             physical id: 4f
             slot: L2 Cache
             size: 512KB
             capacity: 2MB
             capabilities: internal write-back unified
        *-cache:2
             description: L3 cache
             physical id: 50
             slot: L3 Cache
             size: 32MB
             capacity: 64MB
             clock: 100MHz (10.0ns)
             capabilities: pipeline-burst external write-back unified
     *-cpu:1
          description: CPU
          product: Pentium III (Katmai)
          vendor: Intel Corp.
          physical id: 4
          bus info: cpu@1
          version: 6.7.3
          slot: Socket 1
          size: 550MHz
          width: 32 bits
          clock: 100MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
        *-cache:0
             description: L1 cache
             physical id: 4e
             slot: L1 Cache
             size: 32KB
             capabilities: synchronous internal write-back data
        *-cache:1
             description: L2 cache
             physical id: 0
             size: 512KB
     *-cpu:2
          description: CPU
          product: Pentium III (Katmai)
          vendor: Intel Corp.
          physical id: 6
          bus info: cpu@2
          version: 6.7.3
          slot: Socket 2
          size: 550MHz
          width: 32 bits
          clock: 100MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-cpu:3
          description: CPU
          product: Pentium III (Katmai)
          vendor: Intel Corp.
          physical id: 7
          bus info: cpu@3
          version: 6.7.3
          slot: Socket 3
          size: 550MHz
          width: 32 bits
          clock: 100MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-cpu:4
          description: CPU
          vendor: Intel
          physical id: 8
          bus info: cpu@4
          version: 6.7.3
          slot: Socket 4
          size: 550MHz
          clock: 100MHz
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-cpu:5
          description: CPU
          vendor: Intel
          physical id: 9
          bus info: cpu@5
          version: 6.7.3
          slot: Socket 5
          size: 550MHz
          clock: 100MHz
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-cpu:6
          description: CPU
          vendor: Intel
          physical id: a
          bus info: cpu@6
          version: 6.7.3
          slot: Socket 6
          size: 550MHz
          clock: 100MHz
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-cpu:7
          description: CPU
          vendor: Intel
          physical id: b
          bus info: cpu@7
          version: 6.7.3
          slot: Socket 7
          size: 550MHz
          clock: 100MHz
        *-cache:0
             description: L1 cache
             physical id: 0
             size: 32KB
        *-cache:1
             description: L2 cache
             physical id: 1
             size: 512KB
     *-memory
          description: System Memory
          physical id: 78
          slot: System board or motherboard
          size: 2560MB
        *-bank:0
             description: DIMM DRAM EDO
             physical id: 0
             slot: 0
             size: 256MB
             width: 64 bits
        *-bank:1
             description: DIMM DRAM EDO
             physical id: 1
             slot: 1
             size: 256MB
             width: 64 bits
        *-bank:2
             description: DIMM DRAM EDO
             physical id: 2
             slot: 2
             size: 256MB
             width: 64 bits
        *-bank:3
             description: DIMM DRAM EDO
             physical id: 3
             slot: 3
             size: 256MB
             width: 64 bits
        *-bank:4
             description: DIMM DRAM EDO
             physical id: 4
             slot: 4
             size: 256MB
             width: 64 bits
        *-bank:5
             description: DIMM DRAM EDO
             physical id: 5
             slot: 5
             size: 256MB
             width: 64 bits
        *-bank:6
             description: DIMM DRAM EDO
             physical id: 6
             slot: 6
             size: 256MB
             width: 64 bits
        *-bank:7
             description: DIMM DRAM EDO
             physical id: 7
             slot: 7
             size: 256MB
             width: 64 bits
        *-bank:8
             description: DIMM DRAM EDO
             physical id: 8
             slot: 8
             size: 128MB
             width: 64 bits
        *-bank:9
             description: DIMM DRAM EDO
             physical id: 9
             slot: 9
             size: 128MB
             width: 64 bits
        *-bank:10
             description: DIMM DRAM EDO
             physical id: a
             slot: 10
             size: 128MB
             width: 64 bits
        *-bank:11
             description: DIMM DRAM EDO
             physical id: b
             slot: 11
             size: 128MB
             width: 64 bits
        *-bank:12
             description: DIMM DRAM EDO [empty]
             physical id: c
             slot: 12
        *-bank:13
             description: DIMM DRAM EDO [empty]
             physical id: d
             slot: 13
        *-bank:14
             description: DIMM DRAM EDO [empty]
             physical id: e
             slot: 14
        *-bank:15
             description: DIMM DRAM EDO [empty]
             physical id: f
             slot: 15
        *-bank:16
             description: DIMM DRAM EDO [empty]
             physical id: 10
             slot: 16
        *-bank:17
             description: DIMM DRAM EDO [empty]
             physical id: 11
             slot: 17
        *-bank:18
             description: DIMM DRAM EDO [empty]
             physical id: 12
             slot: 18
        *-bank:19
             description: DIMM DRAM EDO [empty]
             physical id: 13
             slot: 19
        *-bank:20
             description: DIMM DRAM EDO [empty]
             physical id: 14
             slot: 20
        *-bank:21
             description: DIMM DRAM EDO [empty]
             physical id: 15
             slot: 21
        *-bank:22
             description: DIMM DRAM EDO [empty]
             physical id: 16
             slot: 22
        *-bank:23
             description: DIMM DRAM EDO [empty]
             physical id: 17
             slot: 23
        *-bank:24
             description: DIMM DRAM EDO [empty]
             physical id: 18
             slot: 24
        *-bank:25
             description: DIMM DRAM EDO [empty]
             physical id: 19
             slot: 25
        *-bank:26
             description: DIMM DRAM EDO [empty]
             physical id: 1a
             slot: 26
        *-bank:27
             description: DIMM DRAM EDO [empty]
             physical id: 1b
             slot: 27
        *-bank:28
             description: DIMM DRAM EDO [empty]
             physical id: 1c
             slot: 28
        *-bank:29
             description: DIMM DRAM EDO [empty]
             physical id: 1d
             slot: 29
        *-bank:30
             description: DIMM DRAM EDO [empty]
             physical id: 1e
             slot: 30
        *-bank:31
             description: DIMM DRAM EDO [empty]
             physical id: 1f
             slot: 31
        *-bank:32
             description: DIMM DRAM EDO [empty]
             physical id: 20
             slot: 32
        *-bank:33
             description: DIMM DRAM EDO [empty]
             physical id: 21
             slot: 33
        *-bank:34
             description: DIMM DRAM EDO [empty]
             physical id: 22
             slot: 34
        *-bank:35
             description: DIMM DRAM EDO [empty]
             physical id: 23
             slot: 35
        *-bank:36
             description: DIMM DRAM EDO [empty]
             physical id: 24
             slot: 36
        *-bank:37
             description: DIMM DRAM EDO [empty]
             physical id: 25
             slot: 37
        *-bank:38
             description: DIMM DRAM EDO [empty]
             physical id: 26
             slot: 38
        *-bank:39
             description: DIMM DRAM EDO [empty]
             physical id: 27
             slot: 39
        *-bank:40
             description: DIMM DRAM EDO [empty]
             physical id: 28
             slot: 40
        *-bank:41
             description: DIMM DRAM EDO [empty]
             physical id: 29
             slot: 41
        *-bank:42
             description: DIMM DRAM EDO [empty]
             physical id: 2a
             slot: 42
        *-bank:43
             description: DIMM DRAM EDO [empty]
             physical id: 2b
             slot: 43
        *-bank:44
             description: DIMM DRAM EDO [empty]
             physical id: 2c
             slot: 44
        *-bank:45
             description: DIMM DRAM EDO [empty]
             physical id: 2d
             slot: 45
        *-bank:46
             description: DIMM DRAM EDO [empty]
             physical id: 2e
             slot: 46
        *-bank:47
             description: DIMM DRAM EDO [empty]
             physical id: 2f
             slot: 47
        *-bank:48
             description: DIMM DRAM EDO [empty]
             physical id: 30
             slot: 48
        *-bank:49
             description: DIMM DRAM EDO [empty]
             physical id: 31
             slot: 49
        *-bank:50
             description: DIMM DRAM EDO [empty]
             physical id: 32
             slot: 50
        *-bank:51
             description: DIMM DRAM EDO [empty]
             physical id: 33
             slot: 51
        *-bank:52
             description: DIMM DRAM EDO [empty]
             physical id: 34
             slot: 52
        *-bank:53
             description: DIMM DRAM EDO [empty]
             physical id: 35
             slot: 53
        *-bank:54
             description: DIMM DRAM EDO [empty]
             physical id: 36
             slot: 54
        *-bank:55
             description: DIMM DRAM EDO [empty]
             physical id: 37
             slot: 55
        *-bank:56
             description: DIMM DRAM EDO [empty]
             physical id: 38
             slot: 56
        *-bank:57
             description: DIMM DRAM EDO [empty]
             physical id: 39
             slot: 57
        *-bank:58
             description: DIMM DRAM EDO [empty]
             physical id: 3a
             slot: 58
        *-bank:59
             description: DIMM DRAM EDO [empty]
             physical id: 3b
             slot: 59
        *-bank:60
             description: DIMM DRAM [empty]
             physical id: 3c
             slot: X0
        *-bank:61
             description: DIMM DRAM [empty]
             physical id: 3d
             slot: 61
        *-bank:62
             description: DIMM DRAM [empty]
             physical id: 3e
             slot: 62
        *-bank:63
             description: DIMM DRAM [empty]
             physical id: 3f
             slot: 63
     *-isa
          description: ISA bridge
          product: 82371AB/EB/MB PIIX4 ISA
          vendor: Intel Corporation
          physical id: 2
          bus info: pci@0000:00:02.0
          version: 02
          width: 32 bits
          clock: 33MHz
          capabilities: isa bus_master
          configuration: latency=0
     *-ide UNCLAIMED
          description: IDE interface
          product: 82371AB/EB/MB PIIX4 IDE
          vendor: Intel Corporation
          physical id: 2.1
          bus info: pci@0000:00:02.1
          version: 01
          width: 32 bits
          clock: 33MHz
          capabilities: ide bus_master
          configuration: latency=64
     *-usb UNCLAIMED
          description: USB Controller
          product: 82371AB/EB/MB PIIX4 USB
          vendor: Intel Corporation
          physical id: 2.2
          bus info: pci@0000:00:02.2
          version: 01
          width: 32 bits
          clock: 33MHz
          capabilities: uhci bus_master
          configuration: latency=64
     *-bridge UNCLAIMED
          description: Bridge
          product: 82371AB/EB/MB PIIX4 ACPI
          vendor: Intel Corporation
          physical id: 2.3
          bus info: pci@0000:00:02.3
          version: 02
          width: 32 bits
          clock: 33MHz
          capabilities: bridge
          configuration: latency=0
     *-display
          description: VGA compatible controller
          product: GD 5446
          vendor: Cirrus Logic
          physical id: 3
          bus info: pci@0000:00:03.0
          version: 45
          width: 32 bits
          clock: 33MHz
          capabilities: vga
          configuration: latency=0
     *-system UNCLAIMED
          description: System peripheral
          product: FSC Multiprocessor Interrupt Controller
          vendor: Siemens Nixdorf AG
          physical id: 5
          bus info: pci@0000:00:04.0
          version: 02
          width: 32 bits
          clock: 33MHz
          configuration: latency=0
     *-pci:0
          description: PCI bridge
          product: 80960RP [i960 RP Microprocessor/Bridge]
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:05.0
          version: 03
          width: 32 bits
          clock: 33MHz
          capabilities: pci normal_decode bus_master
        *-network
             description: Ethernet interface
             product: 82557/8/9 [Ethernet Pro 100]
             vendor: Intel Corporation
             physical id: 1
             bus info: pci@0000:01:01.0
             logical name: eth0
             version: 05
             serial: 08:00:06:0d:90:33
             size: 100MB/s
             capacity: 100MB/s
             width: 32 bits
             clock: 33MHz
             capabilities: pm bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd autonegotiation
             configuration: autonegotiation=on broadcast=yes driver=eepro100 driverversion=eepro100.c:v1.09j-t 9/29/99 Don duplex=full ip=172.25.231.86 latency=64 link=yes maxlatency=56 mingnt=8 multicast=yes port=MII speed=100MB/s
        *-scsi:0
             description: SCSI storage controller
             product: 53c875
             vendor: LSI Logic / Symbios Logic
             physical id: 2
             bus info: pci@0000:01:02.0
             logical name: scsi0
             version: 26
             width: 32 bits
             clock: 33MHz
             capabilities: scsi pm bus_master cap_list scsi-host
             configuration: driver=sym53c8xx latency=72 maxlatency=64 mingnt=17
           *-disk:0
                description: SCSI Disk
                product: ST39102LC
                vendor: SEAGATE
                physical id: 0.0.0
                bus info: scsi@0:0.0.0
                logical name: /dev/sda
                version: 7503
                serial: LV263085000010162PGM
                size: 8683MB
                capacity: 8729MB
                capabilities: 10000rpm partitioned partitioned:dos
                configuration: ansiversion=2
              *-volume:0
                   description: Linux swap / Solaris partition
                   physical id: 1
                   bus info: scsi@0:0.0.0,1
                   logical name: /dev/sda1
                   capacity: 4GB
                   capabilities: primary nofs
              *-volume:1
                   description: Linux filesystem partition
                   physical id: 2
                   bus info: scsi@0:0.0.0,2
                   logical name: /dev/sda2
                   capacity: 4586MB
                   capabilities: primary
           *-disk:1
                description: SCSI Disk
                product: MAN3367MC
                vendor: FUJITSU
                physical id: 0.1.0
                bus info: scsi@0:0.1.0
                logical name: /dev/sdb
                version: 5207
                serial: UFD7P23005G9
                size: 34GB
                capacity: 42GB
                capabilities: 10000rpm
                configuration: ansiversion=3
           *-disk:2
                description: SCSI Disk
                product: MAN3367MC
                vendor: FUJITSU
                physical id: 0.2.0
                bus info: scsi@0:0.2.0
                logical name: /dev/sdc
                version: 5207
                serial: UFD7P23005HG
                size: 34GB
                capacity: 42GB
                capabilities: 10000rpm
                configuration: ansiversion=3
           *-disk:3
                description: SCSI Disk
                product: MAG3182LC
                vendor: FUJITSU
                physical id: 0.3.0
                bus info: scsi@0:0.3.0
                logical name: /dev/sdd
                version: 3709
                serial: 00006678
                size: 17GB
                capacity: 19GB
                capabilities: 10000rpm
                configuration: ansiversion=2
           *-processor UNCLAIMED
                description: SCSI Processor
                product: STM/L S1
                vendor: SAG
                physical id: 0.8.0
                bus info: scsi@0:0.8.0
                version: 4.1b
                serial: 1
                configuration: ansiversion=2
        *-scsi:1
             description: SCSI storage controller
             product: 53c875
             vendor: LSI Logic / Symbios Logic
             physical id: 3
             bus info: pci@0000:01:03.0
             logical name: scsi1
             version: 26
             width: 32 bits
             clock: 33MHz
             capabilities: scsi pm bus_master cap_list scsi-host
             configuration: driver=sym53c8xx latency=72 maxlatency=64 mingnt=17
           *-tape
                description: SCSI Tape
                product: C1537A
                vendor: HP
                physical id: 0.3.0
                bus info: scsi@1:0.3.0
                logical name: /dev/nst0
                logical name: /dev/st0
                version: L708
                capabilities: removable
                configuration: ansiversion=2
           *-cdrom
                description: SCSI CD-ROM
                product: CD-ROM XM-6201TA
                vendor: TOSHIBA
                physical id: 0.5.0
                bus info: scsi@1:0.5.0
                logical name: /dev/cdrom
                logical name: /dev/scd0
                logical name: /dev/sr0
                version: 1042
                capabilities: removable audio
                configuration: ansiversion=2 status=open
     *-generic UNCLAIMED
          description: I2O
          product: 80960RP [i960RP Microprocessor]
          vendor: Intel Corporation
          physical id: 5.1
          bus info: pci@0000:00:05.1
          version: 03
          width: 32 bits
          clock: 33MHz
          capabilities: bus_master
          configuration: latency=64
     *-pci:1
          description: Host bridge
          product: 450NX - 82451NX Memory & I/O Controller
          vendor: Intel Corporation
          physical id: 101
          bus info: pci@0000:00:10.0
          version: 03
          width: 32 bits
          clock: 33MHz
     *-pci:2
          description: Host bridge
          product: 450NX - 82454NX/84460GX PCI Expander Bridge
          vendor: Intel Corporation
          physical id: 102
          bus info: pci@0000:00:12.0
          version: 02
          width: 32 bits
          clock: 33MHz
          configuration: latency=72
     *-pci:3
          description: Host bridge
          product: 450NX - 82454NX/84460GX PCI Expander Bridge
          vendor: Intel Corporation
          physical id: 103
          bus info: pci@0000:00:13.0
          version: 02
          width: 32 bits
          clock: 33MHz
          configuration: latency=72
     *-pci:4
          description: Host bridge
          product: 450NX - 82454NX/84460GX PCI Expander Bridge
          vendor: Intel Corporation
          physical id: 104
          bus info: pci@0000:00:14.0
          version: 02
          width: 32 bits
          clock: 33MHz
          configuration: latency=72
     *-scsi UNCLAIMED
          description: SCSI storage controller
          product: QLA2100 64-bit Fibre Channel Adapter
          vendor: QLogic Corp.
          physical id: e
          bus info: pci@0000:03:0e.0
          version: 03
          width: 32 bits
          clock: 33MHz
          capabilities: scsi bus_master
          configuration: latency=64
  *-battery
       description: Unknown Battery
       physical id: 1
       slot: Right Side
