Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXCYUUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXCYUUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 16:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXCYUUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 16:20:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:60436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752276AbXCYUUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 16:20:52 -0400
X-Authenticated: #17142692
X-Provags-ID: V01U2FsdGVkX1/IaWBIaf/IdRQ0GFQNffLblSHdzFqA0AAauFRhEd
	fyTuWXgQTtTd0U
Message-ID: <4606D9A1.3070005@gmx.de>
Date: Sun, 25 Mar 2007 22:20:49 +0200
From: thomas schorpp <t.schorpp@gmx.de>
Reply-To: t.schorpp@gmx.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.11) Gecko/20070217 Iceape/1.0.8 (Debian-1.0.8-4)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: stable@kernel.org
Subject: [BUG]pci layer may report wrong iomem resources data to drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lo,

aic7xxx driver mmio / dma on x86_64 and some pre 2.6.19.5 ix86 linux kernels are 
broken here with the adaptec asc19160 PCI/32 scsi hba pci card.

well, i've got several live cd systems < 2.6.19.5i386 like whax 3.0 and knoppix that oops
and hang boot in aic7xxx init, only one booting here so far is knoppix 5.2,

the latest unofficial debian stable 2.6.8-12-amd64-generic, which says ACPI: 
PCI interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
aic7xxx: PCI0:6:0 MEM region 0x0 unavailable. Cannot memory map device.
but works in PIO mode,

a debian etch 2.6.18-4-amd64 x86_64 which says:

SCSI subsystem initialized
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 169
BUG: soft lockup detected on CPU#0!

Call Trace:
<IRQ> [<ffffffff802a3fec>] softlockup_tick+0xdb/0xed
[<ffffffff802881df>] update_process_times+0x42/0x68
[<ffffffff8026cbd8>] smp_local_timer_interrupt+0x23/0x47
[<ffffffff8026d2cc>] smp_apic_timer_interrupt+0x41/0x47
[<ffffffff8025904a>] apic_timer_interrupt+0x66/0x6c
<EOI> [<ffffffff8038a412>] pci_conf1_write+0x0/0xc9
[<ffffffff88053718>] :aic7xxx:ahc_pci_test_register_access+0xc2/0x391
[<ffffffff880536a5>] :aic7xxx:ahc_pci_test_register_access+0x4f/0x391
[<ffffffff88059416>] :aic7xxx:ahc_pci_map_registers+0x1bb/0x239
[<ffffffff880523d2>] :aic7xxx:ahc_pci_config+0x4c/0x12d0
[<ffffffff80389fb7>] pcibios_set_master+0x1e/0x84
[<ffffffff88059186>] :aic7xxx:ahc_linux_pci_dev_probe+0x13e/0x213
[<ffffffff80317eea>] pci_device_probe+0xdf/0x147
[<ffffffff8036b9db>] driver_probe_device+0x52/0xa8
[<ffffffff8036ba96>] __driver_attach+0x0/0x9a
[<ffffffff8036bae6>] __driver_attach+0x50/0x9a
[<ffffffff8036ba96>] __driver_attach+0x0/0x9a
[<ffffffff8036b458>] bus_for_each_dev+0x43/0x6e
[<ffffffff8036b09a>] bus_add_driver+0x7e/0x130
[<ffffffff803180c4>] __pci_register_driver+0x57/0x7d
[<ffffffff8805903e>] :aic7xxx:ahc_linux_pci_init+0x17/0x21
[<ffffffff8806e325>] :aic7xxx:ahc_linux_init+0x325/0x336
[<ffffffff8027d27d>] default_wake_function+0x0/0xe
[<ffffffff8025e2e5>] __down_read+0x12/0x9a
[<ffffffff80294fa1>] __link_module+0x0/0x25
[<ffffffff802200e5>] __up_read+0x13/0x8a
[<ffffffff80297695>] sys_init_module+0x16cc/0x1882
[<ffffffff802584d6>] system_call+0x7e/0x83

BUG: soft lockup detected on CPU#0!

which is not surprising, since the aic driver has a thread 4E4 blocking test function:

> I can fix the mmio check not to
> hang, but the card won't actually work mmio until whatever's assigning
> the BAR above 32 bits is fixed (that could either be a kernel PCI bug or
> a BIOS bug).
James.Bottomley@SteelEye.com

a kernel.org 2.6.20 with K8 config set but built in a 32Bit debian sid environment, but works ok:

tom1:~# uname -a
Linux tom1.schorpp.dyndns.dk 2.6.20 #1 PREEMPT Mon Feb 5 11:21:13 CET 2007 i686 GNU/Linux

tom1:~# lspci -vvv -s 00:06.0
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
        Subsystem: Adaptec 19160 Ultra160 SCSI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        BIST result: 00
        Region 0: I/O ports at d800 [disabled] [size=256]
        Region 1: Memory at 30000000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fbee0000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


and finally the latest kernel.org 2.6.20.4 AMD K8 and .21-rc4 git built on debian amd64 etch userland that 
hangs boot on aic7xxx init without magic sysreq keys functionality and oops print triggering, 
(so the softlockup detection does not work without SMP config set, too):

Loading iSCSI transport class v2.0-724.
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
... Kernel alive - Kernel direct mapping tables up to 100000000 @ 8000-d000

i've dangerously commented out the blocking while(!ahc_is_paused) and got the driver to work in PIO mode so far.

tom1:~# lspci -vvv -s 00:06.0
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
       Subsystem: Adaptec 19160 Ultra160 SCSI Controller
       Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step ping- SERR+ FastB2B-
       Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
       Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
       Interrupt: pin A routed to IRQ 17
       BIST result: 00
       Region 0: I/O ports at d800 [size=256]
       Region 1: Memory at ffffff000 (64-bit, non-prefetchable) [disabled] [size=4K]
       Expansion ROM at fbee0000 [disabled] [size=128K]
       Capabilities: [dc] Power Management version 2
               Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME- 


the driver asks the pci layer for the iomem resource correctly (checked 0x1000 len) with:

request_mem_region(start, 0x1000, "aic7xxx")

which returns a invalid >32Bit address and the 64Bit pci mem resources flag is set.
the driver shortens the return value then: ahc->platform_data->mem_busaddr is u32.

on later freeing [   49.278810] Trying to free nonexistent resource <00000000fffff000-00000000ffffffff>
warning occours respectively.

i've tried to change containers to u64 but then the above allocation call fails with NULL return.

theres no reason to agree about a mb bios issue since the mb bios does not care about OS kernels 
and since some 32bit linux versions/kernel configs work and winxp_x64 kernel works fine with mmio.

we're not sure how to fix that:

> The problem you seem to have is that your system is reporting a BAR
> beyond 32 bits (4GB) which the card physically can't use.  This could be
> because of a BIOS misconfiguration or because there's a bug in the PCI
> subsystem somewhere.
> 
> James

on what circumstances can a >= 2.6.19.5 32bit kernel pci layer decode/report a correct 
iomem address and a < or 64bit x86_64 configured/built not?

working in to linux pci hal next, some change there must have caused the issue.
it seems fixed for 32bit kernels but not for 64bit.

y
tom

