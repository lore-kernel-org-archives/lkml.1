Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbYCLGsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbYCLGsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYCLGr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:47:58 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17126 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYCLGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:47:57 -0400
Date: Wed, 12 Mar 2008 00:47:56 -0600
From: Alex Chiang <achiang@hp.com>
To: mlord@pobox.com, kristen.c.accardi@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [regression] pciehp hang on hp ia64 rx6600
Message-ID: <20080312064755.GA31493@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, mlord@pobox.com,
	kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Kristin,

On my hp ia64 rx6600, 'modprobe pciehp' causes lockups and a
system hang on 2.6.25-rc4. My system often hangs when only pciehp
is loaded and my console is sitting idle, but I can accelerate
the hang 100% of the time by immediately doing a 'modprobe
acpiphp' right afterwards.

I have bisected the hang down to this commit:

0a3c33d77ff7ad5b988997536a8f09c49e35ad20 is first bad commit
commit 0a3c33d77ff7ad5b988997536a8f09c49e35ad20
Author: Mark Lord <lkml@rtr.ca>
Date:   Wed Nov 28 15:11:28 2007 -0800

    PCIE: fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks (and others?) in conjunction with modparam of pciehp_force=1.

    Fix pciehp_probe() to deal with ExpressCard cards
    that were inserted prior to the driver being loaded.

    Signed-off-by: Mark Lord <mlord@pobox.com>
    Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Theodore Ts'o <tytso@mit.edu>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 5fe9142c7d2add2db2891a8f469159e338e1c4e4 cd147cb51d7a2133679dd57796044c680159dab7 M      drivers

Reverting this commit makes the hang go away (and I can modprobe
pciehp / acpiphp again without problems).

It looks like the patch is calling pciehp_enable_slot() if the
slot is occupied. I'm not sure exactly what should be happening
on my machine (it's late here ;), but I can try and do some more
thinking tomorrow.

Console log and lspci -vv output follows. Please let me know what
else you might need.

Thanks.

/ac

[root@canola ~]# dmesg -n 8
[root@canola ~]# modprobe pciehp
pciehp: HPC vendor_id 103c device_id 403b ss_vid 0 ss_did 0
pciehp: pciehp_enable_slot: already enabled on slot(0016_0006)
Load service driver hpdriver on pcie device 0000:0f:00.0:pcie02
pciehp: HPC vendor_id 111d device_id 801c ss_vid 0 ss_did 0
pciehp: pciehp_enable_slot: already enabled on slot(0082_0004)
Load service driver hpdriver on pcie device 0000:51:00.0:pcie22
pciehp: HPC vendor_id 111d device_id 801c ss_vid 0 ss_did 0
pciehp: pciehp_enable_slot: latch open on slot(0139_0003)
Load service driver hpdriver on pcie device 0000:51:01.0:pcie22
pciehp: HPC vendor_id 103c device_id 403b ss_vid 0 ss_did 0
Load service driver hpdriver on pcie device 0000:c4:00.0:pcie02
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[root@canola ~]# modprobe acpiphp
INFO: task rsyslogd:3753 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rsyslogd      D a00000010023cec0     0  3753      1

Call Trace:
 [<a0000001007d3c20>] schedule+0x1200/0x1400
                                sp=e0000005167afcf0 bsp=e0000005167a1018
 [<a00000010023cec0>] log_wait_commit+0x140/0x220
                                sp=e0000005167afd80 bsp=e0000005167a0fd8
 [<a00000010022f710>] journal_stop+0x430/0x4e0
                                sp=e0000005167afdb0 bsp=e0000005167a0f90
 [<a000000100230f40>] journal_force_commit+0x80/0xa0
                                sp=e0000005167afdb0 bsp=e0000005167a0f70
 [<a00000010021ffc0>] ext3_force_commit+0x60/0x80
                                sp=e0000005167afdb0 bsp=e0000005167a0f50
 [<a0000001002126e0>] ext3_write_inode+0xa0/0xc0
                                sp=e0000005167afdb0 bsp=e0000005167a0f28
 [<a0000001001a23b0>] __writeback_single_inode+0x4b0/0x740
                                sp=e0000005167afdb0 bsp=e0000005167a0ee0
 [<a0000001001a3ae0>] sync_inode+0x40/0x80
                                sp=e0000005167afdf0 bsp=e0000005167a0eb0
 [<a0000001002098f0>] ext3_sync_file+0x1b0/0x220
                                sp=e0000005167afdf0 bsp=e0000005167a0e88
 [<a0000001001a9700>] do_fsync+0xe0/0x180
                                sp=e0000005167afe30 bsp=e0000005167a0e48
 [<a0000001001a97f0>] __do_fsync+0x50/0x80
                                sp=e0000005167afe30 bsp=e0000005167a0e18
 [<a0000001001a98b0>] sys_fsync+0x30/0x60
                                sp=e0000005167afe30 bsp=e0000005167a0db8
 [<a00000010000a980>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000005167afe30 bsp=e0000005167a0db8
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000005167b0000 bsp=e0000005167a0db8


[more soft lockup output, then my console becomes unresponsive, needs
hard system reset]

[root@canola ~]# lspci -vv
00:01.0 Class ff00: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Subsystem: Hewlett-Packard Company RMP-3 (Remote Management Processor)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000

00:01.1 Communication controller: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Subsystem: Hewlett-Packard Company RMP-3 Shared Memory Driver
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 0
	Region 1: Memory at 84034000 (64-bit, non-prefetchable) [size=4K]
	Region 3: Memory at 80080000000 (64-bit, prefetchable) [size=128K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
		Address: 0000000000000000  Data: 0000

00:01.2 Serial controller: Hewlett-Packard Company Diva Serial [GSP] Multiport UART (prog-if 02 [16550])
	Subsystem: Hewlett-Packard Company Diva RMP3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (250ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 59
	Region 1: Memory at 84033000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [e8] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000

00:02.0 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 61
	Region 0: Memory at 84032000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: NEC Corporation USB (rev 43) (prog-if 10 [OHCI])
	Subsystem: Unknown device 03f0:0226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (250ns min, 10500ns max), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 62
	Region 0: Memory at 84031000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.2 USB Controller: NEC Corporation USB 2.0 (rev 04) (prog-if 20 [EHCI])
	Subsystem: Unknown device 03f0:0326
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
	Interrupt: pin C routed to IRQ 60
	Region 0: Memory at 84030000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] (prog-if 00 [VGA])
	Subsystem: Hewlett-Packard Company Radeon 7000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128 (2000ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 58
	Region 0: Memory at 80000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at 1001000 [size=256]
	Region 2: Memory at 84020000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at 84000000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0f:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=0f, secondary=10, subordinate=48, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: b0000000-bfffffff
	Prefetchable memory behind bridge: 0000080380000000-00000803ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4033
	Capabilities: [60] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <16us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn+ PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise-
		Slot: Number 6, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Unknown (11)

10:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 03)
	Subsystem: Hewlett-Packard Company E500 SAS Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 50
	Region 0: Memory at b0000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at 4001000 [size=256]
	Region 3: Memory at b0140000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at b0100000 [disabled] [size=256K]
	Capabilities: [b0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s <2us, L1 unlimited
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [d4] MSI-X: Enable+ Mask- TabSize=4
		Vector table: BAR=0 offset=000fe000
		PBA: BAR=0 offset=000ff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [ec] Vital Product Data
	Capabilities: [100] Power Budgeting

49:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 76
	Region 0: Memory at c0120000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c00c0000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001040 [size=64]
	Expansion ROM at c0080000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=49:02.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

49:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
	Subsystem: Hewlett-Packard Company Core Dual Port 1000Base-T [AB352A]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (63750ns min), Cache Line Size: 128 bytes
	Interrupt: pin B routed to IRQ 77
	Region 0: Memory at c0100000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at c0040000 (64-bit, non-prefetchable) [size=256K]
	Region 4: I/O ports at 5001000 [size=64]
	Expansion ROM at c0000000 [disabled] [size=256K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=4096 OST=4
		Status: Dev=49:02.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

4f:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=4f, secondary=50, subordinate=c3, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4035
	Capabilities: [60] Express Root Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <16us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Unknown (11)

50:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=50, secondary=51, subordinate=c3, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: e0000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Upstream Port IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <64ns, L1 <1us
		Device: AtnBtn+ AtnInd+ PwrInd+
		Device: SlotPowerLimit 0.000000
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
		Link: Latency L0s <2us, L1 <4us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel

51:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=51, secondary=52, subordinate=8a, sec-latency=0
	I/O behind bridge: 00001000-00008fff
	Memory behind bridge: e8000000-efffffff
	Prefetchable memory behind bridge: 0000080680000000-00000806bfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Downstream Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 2048 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 1
		Link: Latency L0s <2us, L1 <4us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn+ PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise-
		Slot: Number 4, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd On, Power-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4036
	Capabilities: [100] Virtual Channel

51:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=51, secondary=8b, subordinate=c3, sec-latency=0
	I/O behind bridge: 00009000-0000ffff
	Memory behind bridge: e0000000-e7ffffff
	Prefetchable memory behind bridge: 00000806c0000000-00000806ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Downstream Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 2048 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 2
		Link: Latency L0s <2us, L1 <4us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn+ PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise-
		Slot: Number 3, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd On, Power-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4037
	Capabilities: [100] Virtual Channel

52:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 03)
	Subsystem: Hewlett-Packard Company Smart Array P800
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 52
	Region 0: Memory at e8000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at 7001000 [size=256]
	Region 3: Memory at e8140000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at e8100000 [disabled] [size=256K]
	Capabilities: [b0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s <2us, L1 unlimited
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [d4] MSI-X: Enable+ Mask- TabSize=4
		Vector table: BAR=0 offset=000fe000
		PBA: BAR=0 offset=000ff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [ec] Vital Product Data
	Capabilities: [100] Power Budgeting

8b:00.0 RAID bus controller: Hewlett-Packard Company Smart Array Controller (rev 03)
	Subsystem: Hewlett-Packard Company P400 SAS Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 71
	Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: I/O ports at 7009000 [size=256]
	Region 3: Memory at e0140000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at e0100000 [disabled] [size=256K]
	Capabilities: [b0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 2048 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
		Link: Latency L0s <2us, L1 unlimited
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
	Capabilities: [d4] MSI-X: Enable+ Mask- TabSize=4
		Vector table: BAR=0 offset=000fe000
		PBA: BAR=0 offset=000ff000
	Capabilities: [e0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [ec] Vital Product Data
	Capabilities: [100] Power Budgeting

c4:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 128 bytes
	Bus: primary=c4, secondary=c5, subordinate=fe, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: f0000000-fdffffff
	Prefetchable memory behind bridge: 0000080780000000-00000807ffffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee00000  Data: 4039
	Capabilities: [60] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <16us
		Link: ASPM Disabled RCB 128 bytes Disabled CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn+ PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+ Surpise-
		Slot: Number 5, PowerLimit 25.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
		Slot: AttnInd Off, PwrInd Off, Power+
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Unknown (11)


[root@canola ~]# lspci -vt
-+-[0000:c4]---00.0-[0000:c5-fe]--
 +-[0000:4f]---00.0-[0000:50-c3]----00.0-[0000:51-c3]--+-00.0-[0000:52-8a]----00.0  Hewlett-Packard Company Smart Array Controller
 |                                                     \-01.0-[0000:8b-c3]----00.0  Hewlett-Packard Company Smart Array Controller
 +-[0000:49]-+-02.0  Intel Corporation 82546GB Gigabit Ethernet Controller
 |           \-02.1  Intel Corporation 82546GB Gigabit Ethernet Controller
 +-[0000:0f]---00.0-[0000:10-48]----00.0  Hewlett-Packard Company Smart Array Controller
 \-[0000:00]-+-01.0  Hewlett-Packard Company RMP-3 (Remote Management Processor)
             +-01.1  Hewlett-Packard Company RMP-3 Shared Memory Driver
             +-01.2  Hewlett-Packard Company Diva Serial [GSP] Multiport UART
             +-02.0  NEC Corporation USB
             +-02.1  NEC Corporation USB
             +-02.2  NEC Corporation USB 2.0
             \-04.0  ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]

