Return-Path: <linux-kernel-owner+w=401wt.eu-S1422992AbXDYXwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992AbXDYXwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423405AbXDYXwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:52:05 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:44007 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423401AbXDYXv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:51:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Lzohp7D1JSpflC/CnQ13cXp1lqobgGD2ROz1cswbDRvm77ffkddcmDU0b51H6hNYVrA1AXtaez0BALCUqP4QOIvo44EgqDTQvLL2BVXX5MJ7sbT9QJwu+MwcG/00nLIUlwx6LXJb0DLsHATQKuxlRuHKGoe/iU2IIz2HFA+F+Uk=
Message-ID: <462FE982.7030906@gmail.com>
Date: Wed, 25 Apr 2007 17:51:30 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com> <20070425085432.GD17130@htj.dyndns.org> <20070425093044.GE17130@htj.dyndns.org>
In-Reply-To: <20070425093044.GE17130@htj.dyndns.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060800020602020207020202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060800020602020207020202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Please test this one instead.  Thanks.
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 1c00526..c9999e6 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5871,6 +5871,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>  	if (!ap)
>  		return NULL;
>  
> +	ap->pflags |= ATA_PFLAG_INITIALIZING;
>  	ap->lock = &host->lock;
>  	ap->flags = ATA_FLAG_DISABLED;
>  	ap->print_id = -1;
> @@ -6239,6 +6240,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
>  			ehi->action |= ATA_EH_SOFTRESET;
>  			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
>  
> +			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
>  			ap->pflags |= ATA_PFLAG_LOADING;
>  			ata_port_schedule_eh(ap);
>  
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 59d0fb5..4c6914c 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -529,6 +529,9 @@ void ata_port_schedule_eh(struct ata_port *ap)
>  {
>  	WARN_ON(!ap->ops->error_handler);
>  
> +	if (ap->pflags & ATA_PFLAG_INITIALIZING)
> +		return;
> +
>  	ap->pflags |= ATA_PFLAG_EH_PENDING;
>  	scsi_schedule_eh(ap->scsi_host);
>  
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index fa551fd..8ca3611 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -191,6 +191,7 @@ enum {
>  	ATA_PFLAG_LOADING	= (1 << 4), /* boot/loading probe */
>  	ATA_PFLAG_UNLOADING	= (1 << 5), /* module is unloading */
>  	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
> +	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
>  
>  	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
>  	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */

Okay, while this patch allows my system to boot, it eventually crashed.
 Unfortunately, I don't know enough to know if this crash is at all
related, but it seems like it might be?

[ 1314.960784] irq 316: nobody cared (try booting with the "irqpoll" option)
[ 1314.967602]
[ 1314.967602] Call Trace:
[ 1314.971566]  [<ffffffff8025dae3>] dump_trace+0xb6/0x3d6
[ 1314.976809]  [<ffffffff8025de3f>] show_trace+0x3c/0x52
[ 1314.981963]  [<ffffffff8025de6a>] dump_stack+0x15/0x17
[ 1314.987118]  [<ffffffff802993c8>] __report_bad_irq+0x38/0x7c
[ 1314.992790]  [<ffffffff802995db>] note_interrupt+0x1cf/0x215
[ 1314.998463]  [<ffffffff8029a037>] handle_edge_irq+0x104/0x133
[ 1315.004231]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
[ 1315.009039]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
[ 1315.014281]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
[ 1315.019433]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
[ 1315.024414]  [<ffffffff8025c988>] rest_init+0x49/0x4b
[ 1315.029489]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
[ 1315.034989]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
[ 1315.040323]
[ 1315.041813] handlers:
[ 1315.044090] [<ffffffff803e4951>] (ahci_interrupt+0x0/0x47a)
[ 1315.049722] Disabling IRQ #316
[ 1345.037254] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
frozen
[ 1345.044333] ata1.00: cmd c8/00:08:ff:53:00/00:00:00:00:00/e2 tag 0
cdb 0x0 data 4096 in
[ 1345.044334]          res 40/00:00:76:5a:00/00:00:00:00:00/e0 Emask
0x4 (timeout)
[ 1345.059832] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[ 1345.066919] ata3.00: cmd 60/08:00:bb:26:0a/00:00:09:00:00/40 tag 0
cdb 0x0 data 4096 in
[ 1345.066920]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[ 1345.389731] ata1: soft resetting port
[ 1345.396451] ata3: soft resetting port

I've attached the entire dmesg, as well as the output of lspci -nn (but
while running under 2.6.21-rc6-mm2, if that matters).

--------------060800020602020207020202
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="dmesg"


[14316256.221707] Linux version 2.6.21-rc7-mm1 (root@luna) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #2 SMP Wed Apr 25 06:06:01 MDT 2007
[14316256.221707] Command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[14316256.221707] BIOS-provided physical RAM map:
[14316256.221707]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[14316256.221707]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[14316256.221707]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[14316256.221707]  BIOS-e820: 0000000000100000 - 000000003ff80000 (usable)
[14316256.221707]  BIOS-e820: 000000003ff80000 - 000000003ff8e000 (ACPI data)
[14316256.221707]  BIOS-e820: 000000003ff8e000 - 000000003ffe0000 (ACPI NVS)
[14316256.221707]  BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
[14316256.221707]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[14316256.221707] end_pfn_map = 1048576
[14316256.221707] DMI 2.4 present.
[14316256.221707] ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
[14316256.221707] ACPI: XSDT 3FF80100, 0064 (r1 NEC              1000724 MSFT       97)
[14316256.221707] ACPI: FACP 3FF80290, 00F4 (r3 A_M_I_ OEMFACP   1000724 MSFT       97)
[14316256.221707] ACPI: DSDT 3FF80590, 9560 (r1  A0543 A0543000        0 INTL 20060113)
[14316256.221707] ACPI: FACS 3FF8E000, 0040
[14316256.221707] ACPI: APIC 3FF80390, 0080 (r1 A_M_I_ OEMAPIC   1000724 MSFT       97)
[14316256.221707] ACPI: SLIC 3FF80410, 0176 (r1 NEC              1000724 MSFT       97)
[14316256.221707] ACPI: OEMB 3FF8E040, 0066 (r1 A_M_I_ AMI_OEM   1000724 MSFT       97)
[14316256.221707] ACPI: HPET 3FF89AF0, 0038 (r1 A_M_I_ OEMHPET   1000724 MSFT       97)
[14316256.221707] ACPI: MCFG 3FF89B30, 003C (r1 A_M_I_ OEMMCFG   1000724 MSFT       97)
[14316256.221707] ACPI: SSDT 3FF8E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[14316256.221707] ACPI: SSDT 3FF8E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[14316256.221707] Zone PFN ranges:
[14316256.221707]   DMA             0 ->     4096
[14316256.221707]   DMA32        4096 ->  1048576
[14316256.221707]   Normal    1048576 ->  1048576
[14316256.221707] Movable zone start PFN for each node
[14316256.221707] early_node_map[2] active PFN ranges
[14316256.221707]     0:        0 ->      159
[14316256.221707]     0:      256 ->   262016
[14316256.221707] ACPI: PM-Timer IO Port: 0x808
[14316256.221707] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[14316256.221707] Processor #0 (Bootup-CPU)
[14316256.221707] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[14316256.221707] Processor #1
[14316256.221707] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[14316256.221707] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[14316256.221707] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[14316256.221707] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[14316256.221707] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[14316256.221707] Setting APIC routing to flat
[14316256.221707] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[14316256.221707] Using ACPI (MADT) for SMP configuration information
[14316256.221707] Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
[14316256.221707] PERCPU: Allocating 32896 bytes of per cpu data
[14316256.221707] Built 1 zonelists, mobility grouping on.  Total pages: 257236
[14316256.221707] Kernel command line: root=/dev/sdc1 ro console=tty0 console=ttyS0,115200n8 BOOT_IMAGE=vmlinuz
[14316256.221707] Initializing CPU#0
[14316256.221707] PID hash table entries: 4096 (order: 12, 32768 bytes)
[14316256.221707] time.c: Detected 2564.906 MHz processor.
[14316256.231707] Console: colour VGA+ 80x25
[14316256.235040] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[14316256.235040] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[14316256.235040] Checking aperture...
[14316256.241707] Memory: 1026888k/1048064k available (2355k kernel code, 20620k reserved, 1490k data, 212k init)
[14316256.325040] Calibrating delay using timer specific routine.. 5134.40 BogoMIPS (lpj=8554254)
[14316256.325040] Mount-cache hash table entries: 256
[14316256.325040] CPU: L1 I cache: 32K, L1 D cache: 32K
[14316256.325040] CPU: L2 cache: 2048K
[14316256.325040] using mwait in idle threads.
[14316256.325040] CPU: Physical Processor ID: 0
[14316256.325040] CPU: Processor Core ID: 0
[14316256.325040] CPU0: Thermal monitoring enabled (TM2)
[14316256.325040] Freeing SMP alternatives: 26k freed
[14316256.325040] ACPI: Core revision 20070126
[14316256.361707] Using local APIC timer interrupts.
[14316256.361707] result 22900940
[14316256.361707] Detected 22.900 MHz APIC timer.
[14316256.368374] Booting processor 1/2 APIC 0x1
[14316256.378374] Initializing CPU#1
[14316256.461707] Calibrating delay using timer specific routine.. 5131.51 BogoMIPS (lpj=8549621)
[14316256.461707] CPU: L1 I cache: 32K, L1 D cache: 32K
[14316256.461707] CPU: L2 cache: 2048K
[14316256.461707] CPU: Physical Processor ID: 0
[14316256.461707] CPU: Processor Core ID: 1
[14316256.461707] CPU1: Thermal monitoring enabled (TM2)
[14316256.461707] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[14316256.461707] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[14316256.468374] Brought up 2 CPUs
[14316256.525040] migration_cost=3333
[14316256.525040] BUG: at arch/x86_64/kernel/../../i386/kernel/sched-clock.c:175 init_sched_clock()
[14316256.525040] 
[14316256.525040] Call Trace:
[14316256.525040]  [<ffffffff8025dae3>] dump_trace+0xb6/0x3d6
[14316256.525040]  [<ffffffff8025de3f>] show_trace+0x3c/0x52
[14316256.525040]  [<ffffffff8025de6a>] dump_stack+0x15/0x17
[14316256.525040]  [<ffffffff805e24f9>] init_sched_clock+0x57/0x64
[14316256.525040]  [<ffffffff805dc654>] kernel_init+0x167/0x2df
[14316256.525040]  [<ffffffff80255978>] child_rip+0xa/0x12
[14316256.525040] 
[    0.303346] NET: Registered protocol family 16
[    0.303442] ACPI: bus type pci registered
[    0.303488] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[    0.303532] PCI: Not using MMCONFIG.
[    0.303571] PCI: Using configuration type 1
[    0.312502] ACPI: Interpreter enabled
[    0.312542] ACPI: Using IOAPIC for interrupt routing
[    0.319396] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.319829] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.319874] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.319954] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[    0.319998] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[    0.320042] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[    0.320086] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[    0.320592] PCI: Transparent bridge - 0000:00:1e.0
[    0.323128] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.323576] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.324025] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.324475] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.324922] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.325369] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.325816] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.326263] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.326687] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.326737] pnp: PnP ACPI init
[    0.326782] ACPI: bus type pnp registered
[    0.329347] pnp: PnP ACPI: found 15 devices
[    0.329388] ACPI: ACPI bus type pnp unregistered
[    0.329538] SCSI subsystem initialized
[    0.329622] PCI: Using ACPI for IRQ routing
[    0.329663] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.329784] PCI-GART: No AMD northbridge found.
[    0.329828] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.329973] hpet0: 3 64-bit timers, 14318180 Hz
[    0.331054] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.331100] Time: tsc clocksource has been installed.
[    0.331161] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[    0.331208] pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.331253] pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.331298] pnp: 00:08: iomem range 0xfed50000[    0.331342] pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.331400] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.331444] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0f has been reserved
[    0.331637] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.331681] pnp: 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
[    0.331911] PCI: Bridge: 0000:00:01.0
[    0.331951]   IO window: dis159]   MEM window: disabled.
[    0.332200]   PREFETCH window: cfe00000-cfefffff
[    0.332243] PCI: Bridge: 0000:00:1c.3
[     0.332492]   MEM window: fa700000-fa8fffff
[    0.332534]   PREFETCH window: 50000000-500fffff
[    0.332585] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.332677] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level,  -> IRQ 19
[    0.332878] NET: Registered protocol family 2
[    0.374601] IP route cache hash table entries: 32768 (order: 6
[    0.375857] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.376366] TCP: Hash tables configured (estabser4. See www.namesys.com for a description of Reiser4.
[14316256.611707] io scheduler noop registered
[14316256.611707] io sity
[14316256.635040] assign_interrupt_mode Found MSI capability
[14316256.635040] assign_interrupt_mode Found MSI capabilityutton (FF) [PWRF]
[14316256.635040] input: Power Button (CM) as /class/input/input1
[14316256.635040] ACPI: Power Button (CM)uld be F7 [20070126]
[14316256.635040] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._OSC] (Node ffff81EADY_EXISTS
[14316256.635040] ACPI: Marking method _PDC as Serialized
[14316256.635040] ACPI: Processor [CPU1] (supports 8 thPU2._OSC] (Node ffff810002057a10), AE_ALREADY_EXISTS
[14316256.635040] ACPI: Marking method _OSC as Serialized
[14316256.635040] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PDC] (Node ffff810002057a30), AE_ALREADY_EXISTS
[143 [CPU2] (supports 8 throttling states)
[14316256.638374] Real Time Clock Driver v1.12ac
[14316256.638374] intel_rng: FWH not 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[14316256.638374] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 1[14316257.998374] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[14316257.998374]         <Adaptec 2940 Ultra2 SCSI adapter>
[14316257.998374]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[14316257.998374] 
[14316258.021707] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
[    2.064305] scsi 0:0:1:0: Direct-Access     IBM-PCCO ST39102LC     !# B219 PQ: 0 ANSI: 2
[    2.072472] scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
[    2.077975]  target0:0:1: Beginning Domain Validation
[    2.089502]  target0:0:1: wide asynchronous
[    2.098421]  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    2.109664]  target0:0:1: Domain Validation skipping write tests
[    2.115731]  target0:0:1: Ending Domain Validation
[    2.123579] scsi 0:0:2:0: Direct-Access     SGI      SEAGATE ST39102L 2702 PQ: 0 ANSI: 2
[    2.131733] scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
[    2.137227]  target0:0:2: Beginning Domain Validation
[    2.147621]  target0:0:2: wide asynchronous
[    2.155722]  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
[    2.166157]  target0:0:2: Domain Validation skipping write tests
[    2.172222]  target0:0:2: Ending Domain Validation
[14316259.031707] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[14316259.038373] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[14316259.048373] scsi1 : ahci
[14316259.048373] scsi2 : ahci
[14316259.051707] scsi3 : ahci
[14316259.055040] scsi4 : ahci
[14316259.058373] ata1: SATA max UDMA/133 cmd 0xffffc20000028900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
[14316259.068373] ata2: SATA max UDMA/133 cmd 0xffffc20000028980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
[14316259.078373] ata3: SATA max UDMA/133 cmd 0xffffc20000028a00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
[14316259.088373] ata4: SATA max UDMA/133 cmd 0xffffc20000028a80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
[    3.393982] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.403590] ata1.00: ata_hpa_resize 1: sectors = 72303840, hpa_sectors = 72303840
[    3.411141] ata1.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
[    3.417732] ata1.00: 72303840 sectors, multi 16: LBA48 
[    3.427409] ata1.00: ata_hpa_resize 1: sectors = 72303840, hpa_sectors = 72303840
[    3.434962] ata1.00: configured for UDMA/133
[    3.920657] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.253128] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    5.262032] sd 0:0:1:0: [sda] Write Protect is off
[    5.268458] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.277883] sd 0:0:1:0: [sda] 17774160 512-byte hardware sectors (9100 MB)
[    5.286788] sd 0:0:1:0: [sda] Write Protect is off
[    5.293215] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.301816]  sda: sda1 sda2
[    5.309142] sd 0:0:1:0: [sda] Attached SCSI disk
[    5.313851] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    5.320101] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    5.330410] sd 0:0:2:0: [sdb] Write Protect is off
[    5.339046] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.348428] sd 0:0:2:0: [sdb] 17781520 512-byte hardware sectors (9104 MB)
[    5.358738] sd 0:0:2:0: [sdb] Write Protect is off
[    5.367360] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.375950]  sdb: sdb1
[    5.383512] sd 0:0:2:0: [sdb] Attached SCSI disk
[    5.388216] sd 0:0:2:0: Attached scsi generic sg1 type 0
[   33.959814] ata2.00: qc timeout (cmd 0xec)
[   33.963964] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   39.959635] ata2: port is slow to respond, please be patient (Status 0x80)
[   44.496294] ata2: COMRESET failed (errno=-16)
[   45.345140] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   45.351447] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
[   45.357517] ata2.00: 640 sectors, multi 1: LBA 
[   45.362165] ata2.00: configured for UDMA/133
[   45.848406] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   45.855482] ata3.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
[   45.863215] ata3.00: ATA-7: ST3250823AS, 3.03, max UDMA/133
[   45.868842] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   45.876558] ata3.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
[   45.884273] ata3.00: configured for UDMA/133
[   46.200554] ata4: SATA link down (SStatus 0 SControl 300)
[14316302.311702] scsi 1:0:0:0: Direct-Access     ATA      WDC WD360GD-00FL 31.0 PQ: 0 ANSI: 5
[14316302.321702] sd 1:0:0:0: [sdc] 72303840 512-byte hardware sectors (37020 MB)
[14316302.328369] sd 1:0:0:0: [sdc] Write Protect is off
[14316302.331702] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[14316302.341702] sd 1:0:0:0: [sdc] 72303840 512-byte hardware sectors (37020 MB)
[14316302.348369] sd 1:0:0:0: [sdc] Write Protect is off
[14316302.355036] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[14316302.365036]  sdc: sdc1 sdc2
[   46.282946] sd 1:0:0:0: [sdc] Attached SCSI disk
[   46.287664] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   46.293072] scsi 2:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
[   46.301294] sd 2:0:0:0: [sdd] 640 512-byte hardware sectors (0 MB)
[   46.307539] sd 2:0:0:0: [sdd] Write Protect is off
[   46.312387] sd 2:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   46.321608] sd 2:0:0:0: [sdd] 640 512-byte hardware sectors (0 MB)
[   46.327843] sd 2:0:0:0: [sdd] Write Protect is off
[   46.332696] sd 2:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   46.341898]  sdd: unknown partition table
[   46.346168] sd 2:0:0:0: [sdd] Attached SCSI disk
[   46.350880] sd 2:0:0:0: Attached scsi generic sg3 type 0
[   46.356293] scsi 3:0:0:0: Direct-Access     ATA      ST3250823AS      3.03 PQ: 0 ANSI: 5
[   46.364505] sd 3:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
[   46.371706] sd 3:0:0:0: [sde] Write Protect is off
[   46.376560] sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   46.385702] sd 3:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
[   46.392901] sd 3:0:0:0: [sde] Write Protect is off
[   46.397754] sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   46.406869]  sde: sde1 sde2
[   46.428030] sd 3:0:0:0: [sde] Attached SCSI disk
[   46.432743] sd 3:0:0:0: Attached scsi generic sg4 type 0
[   46.438154] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
[   46.445713] scsi5 : ata_piix
[   46.448680] scsi6 : ata_piix
[   46.451638] ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001ffa0 irq 14
[   46.461976] ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001ffa8 irq 15
[   46.943934] ata5.00: ATAPI, max UDMA/33
[   46.947821] ata5.01: ATAPI, max UDMA/33
[   47.118631] ata5.00: configured for UDMA/33
[   47.289904] ata5.01: configured for UDMA/33
[   47.457702] ATA: abnormal status 0x7F on port 0x0000000000010177
[   47.474385] scsi 5:0:0:0: CD-ROM            LITE-ON  LTR-48246S       SS0E PQ: 0 ANSI: 5
[   47.555571] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   47.562423] Uniform CD-ROM driver Revision: 3.20
[   47.567162] sr 5:0:0:0: Attached scsi generic sg5 type 5
[   47.573524] scsi 5:0:1:0: CD-ROM            _NEC     DVD_RW ND-3520AW 3.04 PQ: 0 ANSI: 5
[   47.585795] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   47.592708] sr 5:0:1:0: Attached scsi generic sg6 type 5
[   47.598122] sil680: BA5_EN = 1 clock = 00
[   47.602187] sil680: BA5_EN = 1 clock = 10
[   47.606251] sil680: 133MHz clock.
[   47.609626] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[   47.617179] scsi7 : pata_sil680
[   47.620407] scsi8 : pata_sil680
[   47.623625] ata7: PATA max UDMA/133 cmd 0x000000000001bc00 ctl 0x000000000001b882 bmdma 0x000000000001b400 irq 0
[   47.633869] ata8: PATA max UDMA/133 cmd 0x000000000001b800 ctl 0x000000000001b482 bmdma 0x000000000001b408 irq 0
[   47.849834] ata7.00: ATA-0: SAMSUNG WN316025A (1.6 GB), GF102, max MWDMA2
[   47.856675] ata7.00: 3145968 sectors, multi 16: LBA 
[   47.886527] ata7.00: configured for MWDMA2
[   48.051102] ata8.00: ata_hpa_resize 1: sectors = 78198750, hpa_sectors = 78198750
[   48.058656] ata8.00: ATA-5: MAXTOR 6L040J2, A93.0500, max UDMA/133
[   48.064888] ata8.00: 78198750 sectors, multi 16: LBA 
[   48.077754] ata8.00: ata_hpa_resize 1: sectors = 78198750, hpa_sectors = 78198750
[   48.085306] ata8.00: configured for UDMA/133
[   48.089672] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG WN316025 GF10 PQ: 0 ANSI: 5
[   48.097885] sd 7:0:0:0: [sdf] 3145968 512-byte hardware sectors (1611 MB)
[   48.104738] sd 7:0:0:0: [sdf] Write Protect is off
[   48.109592] sd 7:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   48.118818] sd 7:0:0:0: [sdf] 3145968 512-byte hardware sectors (1611 MB)
[   48.125673] sd 7:0:0:0: [sdf] Write Protect is off
[   48.130528] sd 7:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   48.139737]  sdf: sdf1
[   48.161217] sd 7:0:0:0: [sdf] Attached SCSI disk
[   48.165928] sd 7:0:0:0: Attached scsi generic sg7 type 0
[   48.171341] scsi 8:0:0:0: Direct-Access     ATA      MAXTOR 6L040J2   A93. PQ: 0 ANSI: 5
[   48.179565] sd 8:0:0:0: [sdg] 78198750 512-byte hardware sectors (40038 MB)
[   48.186590] sd 8:0:0:0: [sdg] Write Protect is off
[   48.191445] sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   48.200590] sd 8:0:0:0: [sdg] 78198750 512-byte hardware sectors (40038 MB)
[   48.207613] sd 8:0:0:0: [sdg] Write Protect is off
[   48.212457] sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   48.221581]  sdg: sdg1
[   48.225623] sd 8:0:0:0: [sdg] Attached SCSI disk
[   48.230340] sd 8:0:0:0: Attached scsi generic sg8 type 0
[   48.235778] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   48.242011] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   48.251350] serio: i8042 KBD port at 0x60,0x64 irq 1
[   48.256374] serio: i8042 AUX port at 0x60,0x64 irq 12
[   48.261558] mice: PS/2 mouse device common for all mice
[   48.266862] coretemp: This driver uses undocumented features of Core CPU. Temperature might be wrong!
[   48.299326] input: AT Translated Set 2 keyboard as /class/input/input2
[   48.327180] EDAC MC: Ver: 2.0.1 Apr 24 2007
[   48.331523] TCP cubic registered
[   48.334806] Initializing XFRM netlink socket
[   48.339136] NET: Registered protocol family 1
[   48.343548] NET: Registered protocol family 17
[   48.348045] NET: Registered protocol family 15
[   48.352886] ReiserFS: sdc1: found reiserfs format "3.6" with standard journal
[   48.360088] ReiserFS: sdc1: using ordered data mode
[   48.375503] ReiserFS: sdc1: journal params: device sdc1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   48.390451] ReiserFS: sdc1: checking transaction log (sdc1)
[   48.425515] ReiserFS: sdc1: Using r5 hash to sort names
[   48.430812] VFS: Mounted root (reiserfs filesystem) readonly.
[   48.436626] Freeing unused kernel memory: 212k freed
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[   49.740332] Floppy drive(s): fd0 is 1.44M
[   49.764382] FDC 0 is a post-1991 82077
[   49.855522] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 23
[   49.897174] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[   49.904732] sky2 0000:02:00.0: v1.14 addr 0xfa9fc000 irq 19 Yukon-EC (0xb6) rev 2
[   49.912559] sky2 eth0: addr 00:18:f3:99:3a:fa
[14316305.758369] usbcore: registered new interface driver usbfs
[14316305.765035] usbcore: registered new interface driver hub
[14316305.771702] usbcore: registered new device driver usb
[   49.932754] eth0 renamed to eth4
[   49.995723] USB Universal Host Controller Interface driver v3.0
[   50.001736] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[   50.009315] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   50.014699] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   50.022306] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480
[   50.028172] usb usb1: new device found, idVendor=0000, idProduct=0000
[   50.034701] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[   50.041634] usb usb1: Product: UHCI Host Controller
[   50.046569] usb usb1: Manufacturer: Linux 2.6.21-rc7-mm1 uhci_hcd
[   50.052710] usb usb1: SerialNumber: 0000:00:1d.0
[   50.058813] usb usb1: configuration #1 chosen from 1 choice
[   50.064533] hub 1-0:1.0: USB hub found
[   50.068340] hub 1-0:1.0: 2 ports detected
[   50.176136] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[   50.183643] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   50.188938] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   50.196412] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800
[   50.202232] usb usb2: new device found, idVendor=0000, idProduct=0000
[   50.208723] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[   50.215653] usb usb2: Product: UHCI Host Controller
[   50.220579] usb usb2: Manufacturer: Linux 2.6.21-rc7-mm1 uhci_hcd
[   50.226729] usb usb2: SerialNumber: 0000:00:1d.1
[   50.231442] usb usb2: configuration #1 chosen from 1 choice
[   50.237081] hub 2-0:1.0: USB hub found
[   50.240884] hub 2-0:1.0: 2 ports detected
[   50.350260] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   50.357771] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   50.363060] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   50.370544] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880
[   50.376363] usb usb3: new device found, idVendor=0000, idProduct=0000
[   50.382865] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
[   50.389801] usb usb3: Product: UHCI Host Controller
[   50.394729] usb usb3: Manufacturer: Linux 2.6.21-rc7-mm1 uhci_hcd
[   50.400862] usb usb3: SerialNumber: 0000:00:1d.2
[   50.405567] usb usb3: configuration #1 chosen from 1 choice
[   50.411211] hub 3-0:1.0: USB hub found
[   50.415016] hub 3-0:1.0: 2 ports detected
[14316306.218369] usb 1-1: new low speed USB device using uhci_hcd and address 2
[   50.524350] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
[   50.531869] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   50.542410] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   50.549889] uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00
[   50.555710] usb usb4: new device found, idVendor=0000, idProduct=0000
[   50.562210] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
[   50.569139] usb usb4: Product: UHCI Host Controller
[   50.574066] usb usb4: Manufacturer: Linux 2.6.21-rc7-mm1 uhci_hcd
[   50.580209] usb usb4: SerialNumber: 0000:00:1d.3
[   50.584913] usb usb4: configuration #1 chosen from 1 choice
[   50.590558] hub 4-0:1.0: USB hub found
[   50.594361] hub 4-0:1.0: 2 ports detected
[   50.677784] usb 1-1: new device found, idVendor=045e, idProduct=001e
[   50.684211] usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[   50.691063] usb 1-1: Product: Microsoft IntelliMouse® Explorer
[   50.696949] usb 1-1: Manufacturer: Microsoft
[   50.701302] usb 1-1: configuration #1 chosen from 1 choice
[14316306.431702] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[14316306.438369] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[14316306.445035] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[14316306.455035] ehci_hcd 0000:00:1d.7: debug port 1
[14316306.458369] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfebfbc00
[14316306.468369] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[14316306.475035] usb usb5: new device found, idVendor=0000, idProduct=0000
[14316306.481702] usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
[14316306.491702] usb usb5: Product: EHCI Host Controller
[14316306.495035] usb usb5: Manufacturer: Linux 2.6.21-rc7-mm1 ehci_hcd
[14316306.501702] usb usb5: SerialNumber: 0000:00:1d.7
[14316306.508369] usb usb5: configuration #1 chosen from 1 choice
[14316306.511702] hub 5-0:1.0: USB hub found
[14316306.518369] hub 5-0:1.0: 8 ports detected
[   50.888747] usb 1-1: USB disconnect, address 2
[14316306.625035] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19 (level, low) -> IRQ 19
[14316308.115035] usb 5-7: new high speed USB device using ehci_hcd and address 6
[   52.530829] usb 5-7: new device found, idVendor=05e3, idProduct=0606
[   52.537363] usb 5-7: new device strings: Mfr=0, Product=1, SerialNumber=0
[   52.544250] usb 5-7: Product: USB2.0 Hub
[   52.548299] usb 5-7: configuration #1 chosen from 1 choice
[   52.559839] hub 5-7:1.0: USB hub found
[   52.564061] hub 5-7:1.0: 4 ports detected
[   52.670276] usbcore: registered new interface driver hiddev
[   52.898255] usb 1-1: new low speed USB device using uhci_hcd and address 3
[   53.086368] usb 1-1: new device found, idVendor=045e, idProduct=001e
[   53.092779] usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[   53.099630] usb 1-1: Product: Microsoft IntelliMouse® Explorer
[   53.105516] usb 1-1: Manufacturer: Microsoft
[   53.109889] usb 1-1: configuration #1 chosen from 1 choice
[   53.344916] usb 1-2: new low speed USB device using uhci_hcd and address 4
[   53.518113] usb 1-2: new device found, idVendor=0d3d, idProduct=0001
[   53.524523] usb 1-2: new device strings: Mfr=0, Product=2, SerialNumber=0
[   53.531374] usb 1-2: Product: USBPS2
[   53.535045] usb 1-2: configuration #1 chosen from 1 choice
[   53.798287] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   53.922430] usb 2-2: device descriptor read/64, error -32
[   54.143861] usb 2-2: device descriptor read/64, error -32
[   54.362122] usb 2-2: new full speed USB device using uhci_hcd and address 3
[   54.482704] usb 2-2: device descriptor read/64, error -32
[   54.704555] usb 2-2: device descriptor read/64, error -32
[   54.918971] usb 2-2: new full speed USB device using uhci_hcd and address 4
[   55.335210] usb 2-2: device not accepting address 4, error -32
[   55.445896] usb 2-2: new full speed USB device using uhci_hcd and address 5
[   55.865260] usb 2-2: device not accepting address 5, error -32
[   56.097114] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   61.291939] usb 3-2: new device found, idVendor=03f0, idProduct=0401
[   61.298353] usb 3-2: new device strings: Mfr=1, Product=2, SerialNumber=3
[   61.305203] usb 3-2: Product: HP ScanJet 5200C
[   61.309702] usb 3-2: Manufacturer: Hewlett-Packard
[   61.314544] usb 3-2: SerialNumber: SG91U161Z2HT
[   61.319186] usb 3-2: configuration #1 chosen from 1 choice
[   61.520417] usb 5-7.3: new high speed USB device using ehci_hcd and address 7
[   61.620607] usb 5-7.3: new device found, idVendor=0bda, idProduct=8187
[   61.627302] usb 5-7.3: new device strings: Mfr=1, Product=2, SerialNumber=3
[   61.634371] usb 5-7.3: Product: RTL8187_Wireless
[   61.639066] usb 5-7.3: Manufacturer: Manufacturer_Realtek_RTL8187_
[   61.645341] usb 5-7.3: SerialNumber: 0015AF09B434
[   61.650163] usb 5-7.3: configuration #1 chosen from 1 choice
[   61.672526] input: Microsoft Microsoft IntelliMouse® Explorer as /class/input/input3
[   61.680381] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Explorer] on usb-0000:00:1d.0-1
[   61.704491] input: USBPS2 as /class/input/input4
[   61.709196] input,hidraw1: USB HID v1.00 Keyboard [USBPS2] on usb-0000:00:1d.0-2
[   61.738585] input: USBPS2 as /class/input/input5
[   61.743302] input,hidraw2: USB HID v1.00 Mouse [USBPS2] on usb-0000:00:1d.0-2
[   61.750678] usbcore: registered new interface driver usbhid
[   61.756313] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
done.
Setting parameters of disc: (none).
Activating swap:swapon on /dev/sdc2
[   62.341958] Adding 1959920k swap on /dev/sdc2.  Priority:-1 extents:1 across:1959920k
.
Setting the system clock..
System Clock set. Local time: Wed Apr 25 17:05:55 MDT 2007.
Cleaning up ifupdown....
Loading kernel module nvidia.
FATAL: Could not open '/lib/modules/2.6.21-rc7-mm1/kernel/drivers/video/nvidia.ko': No such file or directory
Loading kernel module 8139too.
[   62.794193] 8139too Fast Ethernet driver 0.9.28
Loading kernel module sky2.
Loading kernel module i2c-i801.
Loading kernel module i2c-isa.
Loading kernel module eeprom.
Loading kernel module w83627ehf.
Loading kernel module snd-rtctimer.
Loading kernel module cdc-acm.
FATAL: Module cdc_acm not found.
Loading kernel module coretemp.
FATAL: Module coretemp not found.
Loading kernel module uhci-hcd.
Loading device-mapper support.
Will now check all file systems.
fsck 1.40-WIP (14-Nov-2006)
Checking all file systems.
Done checking file systems. 
A log is being saved in /var/log/fsck/checkfs if that location is writable.
Setting kernel variables...done.
Will now mount local filesystems:[   63.109404] ReiserFS: sde1: found reiserfs format "3.6" with standard journal
[   63.116610] ReiserFS: sde1: using ordered data mode
[   63.128517] ReiserFS: sde1: journal params: device sde1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   63.143413] ReiserFS: sde1: checking transaction log (sde1)
[   63.188229] ReiserFS: sde1: Using r5 hash to sort names
[   63.247358] ReiserFS: sda1: found reiserfs format "3.6" with standard journal
[   63.254560] ReiserFS: sda1: using ordered data mode
[   63.261580] ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   63.276599] ReiserFS: sda1: checking transaction log (sda1)
[   63.300573] ReiserFS: sda1: Using r5 hash to sort names
.
Will now activate swapfile swap:done.
Cleaning /tmp...done.
Cleaning /var/run...done.
Cleaning /var/lock...done.
Setting up networking....
Configuring network interfaces...[   63.616227] sky2 eth4: enabling interface
[   63.622102] sky2 eth4: ram buffer 48K
[   66.101890] sky2 eth4: Link is up at 1000 Mbps, full duplex, flow control both
Starting portmap daemon....
done.
Starting portmap daemon...Already running..
Setting console screen modes and fonts.
Setting up ALSA...done.
Initializing random number generator...done.
Recovering nvi editor sessions...none found.
Setting up X server socket directory /tmp/.X11-unix....
Setting up ICE socket directory /tmp/.ICE-unix....
Recovering schroot sessions:E: /var/lib/schroot/session: Failed to open file: No such file or directory
.
INIT: Entering runlevel: 2
Starting system log daemon....
Starting kernel log daemon....
Loading ACPI modules....
Starting Advanced Configuration and Power Interface daemon....
Starting Common Unix Printing System: cupsd.
Starting system message bus: dbus.
Starting Hardware abstraction layer: hald.
Starting Avahi mDNS/DNS-SD Daemon: avahi-daemon.
Starting DirMngr: dirmngr.
Starting mouse interface server: gpm.
Starting disk temperature monitoring daemon: hddtemp:[   75.514238] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   75.520756] ata2.00: (irq_stat 0x40000001)
[   75.524902] ata2.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 0 
[   75.524903]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   75.540857] ata2.00: configured for UDMA/133
[   75.545208] ata2: EH complete
[   75.548405] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   75.554912] ata2.00: (irq_stat 0x40000001)
[   75.559056] ata2.00: cmd b0/d0:01:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
[   75.559057]          res 51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
[   75.575052] ata2.00: configured for UDMA/133
[   75.579385] ata2: EH complete
[   75.583150] sd 2:0:0:0: [sdd] 640 512-byte hardware sectors (0 MB)
[   75.589407] sd 2:0:0:0: [sdd] Write Protect is off
[   75.594350] sd 2:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   75.603580] sd 2:0:0:0: [sdd] 640 512-byte hardware sectors (0 MB)
[   75.609830] sd 2:0:0:0: [sdd] Write Protect is off
[   75.614716] sd 2:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  /dev/sdc /dev/sde /dev/sdg..
Starting internet superserver: inetd.
Starting Postfix Mail Transport Agent: postfix.
Starting Samba daemons: nmbd smbd.
Starting OpenBSD Secure Shell server: sshd.
Setting up X font server socket directory /tmp/.font-unix...done.
Starting X font server: xfs.
Starting NFS common utilities: statd.
Starting NTP server: ntpd.
Starting deferred execution scheduler: atd.
Starting periodic command scheduler: crond.
Starting K Display Manager: kdm.
Running local boot scripts (/etc/rc.local).

Debian GNU/Linux lenny/sid luna ttyS0

luna login: [14316647.861668] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9755  Mon Feb 26 23:16:31 PST 2007
[ 1314.960784] irq 316: nobody cared (try booting with the "irqpoll" option)
[ 1314.967602] 
[ 1314.967602] Call Trace:
[ 1314.971566]  [<ffffffff8025dae3>] dump_trace+0xb6/0x3d6
[ 1314.976809]  [<ffffffff8025de3f>] show_trace+0x3c/0x52
[ 1314.981963]  [<ffffffff8025de6a>] dump_stack+0x15/0x17
[ 1314.987118]  [<ffffffff802993c8>] __report_bad_irq+0x38/0x7c
[ 1314.992790]  [<ffffffff802995db>] note_interrupt+0x1cf/0x215
[ 1314.998463]  [<ffffffff8029a037>] handle_edge_irq+0x104/0x133
[ 1315.004231]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
[ 1315.009039]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
[ 1315.014281]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
[ 1315.019433]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
[ 1315.024414]  [<ffffffff8025c988>] rest_init+0x49/0x4b
[ 1315.029489]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
[ 1315.034989]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
[ 1315.040323] 
[ 1315.041813] handlers:
[ 1315.044090] [<ffffffff803e4951>] (ahci_interrupt+0x0/0x47a)
[ 1315.049722] Disabling IRQ #316
[ 1345.037254] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[ 1345.044333] ata1.00: cmd c8/00:08:ff:53:00/00:00:00:00:00/e2 tag 0 cdb 0x0 data 4096 in
[ 1345.044334]          res 40/00:00:76:5a:00/00:00:00:00:00/e0 Emask 0x4 (timeout)
[ 1345.059832] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
[ 1345.066919] ata3.00: cmd 60/08:00:bb:26:0a/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 in
[ 1345.066920]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1345.389731] ata1: soft resetting port
[ 1345.396451] ata3: soft resetting port
[ 1345.561431] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1345.571485] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1375.554036] ata1.00: qc timeout (cmd 0xec)
[ 1375.558175] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1375.564323] ata1.00: revalidation failed (errno=-5)
[14317631.711570] ata3.00: qc timeout (cmd 0xec)
[14317631.711570] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[14317631.711570] ata3.00: revalidation failed (errno=-5)
[14317631.711570] ata3: failed to recover some devices, retrying in 5 secs
[ 1375.591761] ata1: failed to recover some devices, retrying in 5 secs
[14317636.714902] ata3: hard resetting port
[ 1380.600585] ata1: hard resetting port
[14317642.208235] ata3: port is slow to respond, please be patient (Status 0x80)
[ 1386.087391] ata1: port is slow to respond, please be patient (Status 0x80)
[ 1390.622521] ata1: COMRESET failed (errno=-16)
[ 1390.626934] ata1: hard resetting port
[14317646.761568] ata3: COMRESET failed (errno=-16)
[14317646.764901] ata3: hard resetting port
[ 1391.103669] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[14317647.241568] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1421.092102] ata1.00: qc timeout (cmd 0xec)
[ 1421.096246] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1421.102394] ata1.00: revalidation failed (errno=-5)
[ 1421.107327] ata1.00: limiting speed to UDMA/133:PIO3
[ 1421.112312] ata1: failed to recover some devices, retrying in 5 secs
[14317677.248232] ata3.00: qc timeout (cmd 0xec)
[14317677.248232] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[14317677.248232] ata3.00: revalidation failed (errno=-5)
[14317677.248232] ata3.00: limiting speed to UDMA/133:PIO3
[14317677.248232] ata3: failed to recover some devices, retrying in 5 secs
[14317682.251564] ata3: hard resetting port
[ 1426.145902] ata1: hard resetting port
[14317687.748231] ata3: port is slow to respond, please be patient (Status 0x80)
[ 1431.636512] ata1: port is slow to respond, please be patient (Status 0x80)
[ 1436.168459] ata1: COMRESET failed (errno=-16)
[ 1436.172869] ata1: hard resetting port
[14317692.294897] ata3: COMRESET failed (errno=-16)
[14317692.298230] ata3: hard resetting port
[ 1436.642434] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[14317692.774897] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1466.632758] ata1.00: qc timeout (cmd 0xec)
[ 1466.636881] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 1466.643016] ata1.00: revalidation failed (errno=-5)
[ 1466.647933] ata1.00: disabled
[14317722.781560] ata3.00: qc timeout (cmd 0xec)
[14317722.788227] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[14317722.794894] ata3.00: revalidation failed (errno=-5)
[14317722.798227] ata3.00: disabled
[ 1467.153320] ata1: EH complete
[ 1467.156339] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1467.164926] end_request: I/O error, dev sdc, sector 33575935
[ 1467.170659] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1467.179248] end_request: I/O error, dev sdc, sector 40912823
[ 1467.184936] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1467.193495] end_request: I/O error, dev sdc, sector 40yte=DIDr4>[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23953408) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 193865403
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23986176) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 194127547
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24018944) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 194389691
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24051712) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 194651835
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24084480) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 194913979
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24117248) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195176123
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24150016) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195438267
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24182784) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195700411
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24215552) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195962555
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24248320) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 196224699
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24281088) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 196486843
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24313856) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 196748987
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24346624) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197011131
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24379392) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197273275
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24412160) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197535419
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24444928) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197797563
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24477696) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 198059707
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24510464) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 198321851
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24543232) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 198583995
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24576000) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 198846139
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24608768) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverby95] end_request: I/O error, dev sde, sector 199108283
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24674304) reading failed
[143ostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 199894715
[1reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.sh-2029: reiserfs_read_bitmap_block: bitmap block (#24772608) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 200681147
[14317723.304895] ReiserFS: sde1: warning: sh-2: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, secIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 201205435
[14317723.304895] ReiserFS: sde1: warnO error, dev sde, sector 201467579
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap bloc04895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O erap_block: bitmap block (#25001984) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverby4317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_reques[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#25100288) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I302587
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#25165824) reading failed
[14317723.304895] end_request: I/O error, dev sde, sector 203564731
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reise
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#21626880) reading failed
[1431reiserfs_read_bitmap_block: bitmap block (#21659648) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_Breading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.esult: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 17603757952) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[1dev sde, sector 176563899
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#21823488) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[1431 error, dev sde, sector 177088187
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap blockReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#21921792) reading failed
[14317723.304894] sd 3:0p_block: bitmap block (#21954560) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyt317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 178398907
[14317723.3043.304894] end_request: I/O error, dev sde, sector 178661051
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_byte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 178923195
[1431[14317723.304894] end_request: I/O error, dev sde, sector 179185339
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserctor 179447483
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22183936) readinsde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sectorsde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22282240) reading failed
[14317723.304894] sd 3:0:0:0: [sderror, dev sde, sector 180496059
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (iserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22347776) reading failed
[14317723.304894] sd 3:0:0st: I/O error, dev sde, sector 181020347
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitma04894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22413312) reading failed
[14317723.304894]nd_request: I/O error, dev sde, sector 181544635
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_blocd
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 182068923
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22511616) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_O920) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 183117499
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_ree1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22708224) reading failed
[14317723.304894] sd 3:0:0:0: [sde] e=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 184166075
[14317723.304894] ReiserFS: sde1: riverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 184690363
[14317723.304894] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#22839296) reading failed
[14317723.304894] sd 3:0:0:0: [sfs_read_bitmap_block: bitmap block (#22937600) reading failed
[14317723.304894] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TAR hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304894] end_request: I/O error, dev sde, sector 186263227
_OK
[14317723.304895] end_request: I/O error, dev sde, sector 186525371
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23068672) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BA#23101440) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23134208) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Rep block (#23166976) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SU sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, diverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 188098235
[14317723.304895] ReiserFS:[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_requs_read_bitmap_block: bitmap block (#23363584) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGhostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 189671099
[ reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723 sh-2029: reiserfs_read_bitmap_block: bitmap block (#23494656) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: host23527424) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23560192) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 1907196verbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 191506107
[14317723.304895] ReiserFS: RGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 192030395
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23756800) reading failed
[14317723.304895] sd 3:0:0723.304895] end_request: I/O error, dev sde, sector 192816827
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_reastbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 193078971
[143953408) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[arning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#23986176) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Resuldev sde, sector 194127547
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24018: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24051712) reading failed
[14317723.304895] sd 3:0:0:0: [s bitmap block (#24084480) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER04895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O erGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195438267
[14317723.304895] Rei_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 195962555
[14317723.304iled
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] eneiserfs_read_bitmap_block: bitmap block (#24281088) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BA
[14317723.304895] end_request: I/O error, dev sde, sector 196748987
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reisesult: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197011GEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 197273275
[14317723.304895] ReiserFS: sde1: warning: sh-202ev sde, sector 197535419
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#244449sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24477696) reading failed
[14317723.304895] sd 3:0:0:0: [sdeerror, dev sde, sector 198059707
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block yte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 198321851
[14317723.304895] ReiserFS: sde1895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O erroend_request: I/O error, dev sde, sector 199108283
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_bloAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 199370427
[14317723.30489304895] end_request: I/O error, dev sde, sector 199632571
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bi4715
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24739840) reading failed
029: reiserfs_read_bitmap_block: bitmap block (#24772608) reading failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=tor 200419003
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24805376) readingde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 200943291
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24870912) reading faide1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#24903680) reading failed
[14317723.304895] sd 3:0:0:0: [sde]ror, dev sde, sector 201467579
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#te=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 201729723
[14317723.304895] ReiserFS: sde1:5] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error,driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 202254011
[14317723.304895] ReiserFd_request: I/O error, dev sde, sector 202516155
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block17723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_block: bitmap block (#25100288) reading failed
[14317723.4895] end_request: I/O error, dev sde, sector 203040443
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmg failed
[14317723.304895] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317723.304895] end_request: I/O error, dev sde, sector 203564731
[14317723.304895] ReiserFS: sde1: warning: sh-2029: reiserfs_read_bitmap_b236] end_request: I/O error, dev sdc, sector 50140327
[ 1471.039957] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.048549] end_request: I/O error, dev sdc, sector 62970423
[ 1471.054222] sd 1:0:0:0: [sdc] Resostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.119986] end_request: I/O error, dev sdc, sector 39342279
[ 1471.125701] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.134288] end_request: I/O error, dev sdc, sector 46063
[ 1471.139709] Buffer I/O error on device sdc1, logical block 5750
[ 1471.145640] lost page write d sdc1, logical block 5752
[ 1471.167486] lost page write due to I/O error on sdc1
[ 1471.172474] Buffer I/O error on device s4303] Buffer I/O error on device sdc1, logical block 5755
[ 1471.200234] lost page write due to I/O error on sdc1
[ 1471.2052 write due to I/O error on sdc1
[14317723.478227] REISERFS: abort (device sdc1): Journal write error in flush_commit_list
[ 156] Reducing readahead size to 256K
[ 1471.244223] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.244232] end_request: I/O error, dev sdc, sector 40895823
[ 1471.250886] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.250889] end_req33018 on readonly FS
[ 1471.370552] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.370555] end_request: I/O error, dev sdc, sector 61758303
[ 1471.370564] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET drivting inode 33018 on readonly FS
[ 1471.371733] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.3FS
[ 1471.372218] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.372234] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.372386] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readoing inode 33018 on readonly FS
[ 1471.372743] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.372903] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.372920] ReiserFS: sdc1: warning: clm-6006: ing inode 33018 on readonly FS
[ 1471.373093] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.37FS
[ 1471.373603] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.373620] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.373775] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readoing inode 33018 on readonly FS
[ 1471.374474] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.374619] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.374913] ReiserFS: sdc1: warning: clm-6006: K,SUGGEST_OK
[ 1471.708489] end_request: I/O error, dev sdc, sector 39339775
[ 1471.708493] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.708495] end_request: I/O error, dev sdc, sector 39342367
[ 1471.70850uest: I/O error, dev sdc, sector 23981039
[ 1471.708659] Reducing readahead size to 64K
[ 1471.708666] ReiserFS: sdc1: warninquest: I/O error, dev sdc, sector 23981023
[ 1471.708725] Reducing readahead size to 16K
[ 1471.708730] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.709184] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on read FS
[ 1471.709361] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.709377] ReiserFS: sdc1: warni FS
[ 1471.710613] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.710629] ReiserFS: sdc1: warni FS
[ 1471.710956] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.710972] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.711128] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on read sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.711463] ReiserFS: sdc1: warning: clm-6006: writing inode 3ting inode 33018 on readonly FS
[ 1471.711813] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7ting inode 33018 on readonly FS
[ 1471.712152] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7 sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.712463] ReiserFS: sdc1: warning: clm-6006: writing inode 3 FS
[ 1471.712828] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.713512] ReiserFS: sdc1: warniting inode 33018 on readonly FS
[ 1471.713686] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7 sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.713866] ReiserFS: sdc1: warning: clm-6006: writing inode 3FS
[ 1471.714035] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.714253] ReiserFS: sdc1: warninting inode 33018 on readonly FS
[ 1471.714418] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7ting inode 33018 on readonly FS
[ 1471.714756] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7 sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.715350] ReiserFS: sdc1: warning: clm-6006: writing inode 3FS
[ 1471.715514] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.715667] ReiserFS: sdc1: warninting inode 33018 on readonly FS
[ 1471.715833] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.7_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1471.719989] end_request: I/O error, dev sdc, sector 61687807
[ 1471.720048] sdbyte=DRIVER_OK,SUGGEST_OK
[ 1471.720058] end_request: I/O error, dev sdc, sector 39339783
[ 1471.720065] sd 1:0:0:0: [sdc] ReGGEST_OK
[ 1471.720074] end_request: I/O error, dev sdc, sector 46711
[ 1471.734789] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.734808] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FS
[ 1471.734-6006: writing inode 33018 on readonly FS
[ 1471.735573] ReiserFS: sdc1: warning: clm-6006: writing inode 33018 on readonly FSdev sde,sFeo
r 203826939
[14317724.738227] sd 3:0:0:0:s de] Result: hostbyte=DID_BAD_TARGET drivery tD0RIVER_OK,SUGGEST_OK
[14317724.744894eR_Ee qeis:r/yeerrordEev sde, sector 203827035
[14317724.751560] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGER_OK,SUGGEST_OK
[14317724.774894] end_request: I/O error, dev sde, sector 203828651
[ 1472.538658]R:ee/rFS: sdc1: warning: cAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.539540] end_request: I/O error, dev sdc, sector 33586583
[ 1472.539558] sd 1rbyte=DRIVER_OK,SUGGEST_OK
 s1472.539567] end_request: I/O error, dev sdc, sector 23979615
[ 1472.539855] sd 1:0:0:0: [sdc] Ror, dev sdc, sector 23979615
[ 1472.551298] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OKesult: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.551426] end_request: I/O error, dev sdc, sector 23981039[ 1472.562967] end_request: I/O error, dev sdc, sector 33576791
[ 1472.562981] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARG
[ 1472.563037] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.563040] end_request:GET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.569418] end_request: I/O error, dev sdc, sector 33586583
[ 1472.569891] sd 1:0:0:0: I/O error, dev sdc, sector 23981039
[ 1472.581706] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SU0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.581770] end_request: I/O error, dev sdc, sectoUGGEST_OK
[ 1472.585203] end_request: I/O error, dev sdc, sector 33578231
[ 1472.585247] sd 1:0:0:0: [sdc] Result: hostbyte=Dor 23981039
[ 1472.593160] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.593164] end_request: I/O error, dev sdc, sector 24015871
[ 1472.696433] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DR=DRIVER_OK,SUGGEST_OK
[ 1472.814587] end_request: I/O error, dev sdc, sector 33581863
[ 1472.814600] sd 1:0:0:0: [sdc] Result sdc, sector 33581863
[ 1472.814650] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472rror, dev sde, sector 203828699
[14317725.101560] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGE0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317725.101560] end_request: I/O error, dev sde, IVER_OK,SUGGEST_OK
[14317725.111560] end_request: I/O error, dev sde, sector 1995835
[14317725.118227] sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317725.121560] end_request: I/O error, dev sde, sector 1995907commit_list
[14317725.134894] REISERFS: Aborting journal for filesystem on sde1
[ 1472.942955] sd 1:0:0:0: [sdc] Result: hostI/O error, dev sdc, sector 58196775
[ 1472.957390] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGG0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1472.980682] end_request: I/O error, dev sdc, secto,SUGGEST_OK
[ 1472.995278] end_request: I/O error, dev sdc, sector 59769727
[ 1473.001049] sd 1:0:0:0: [sdc] Result: hostbytesector 61657975
[ 1473.015603] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.02432byte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.038767] end_request: I/O error, dev sdc, sector 61700191
[ 1473.044622] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.053378] end_request: I/O error,BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.067932] end_request: I/O error, dev sdc, sector 61912951
[ 1473.073695] sd request: I/O error, dev sdc, sector 62925383
[ 1473.088076] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVE1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.111169] end_request: I/O error, dev sdc,R_OK,SUGGEST_OK
[ 1473.125545] end_request: I/O error, dev sdc, sector 64769791
[ 1473.131254] sd 1:0:0:0: [sdc] Result: host sector 64770095
[ 1473.145632] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.15421039
[ 1473.181963] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1473.190612] end_requ dev sdc, sector 33589647
[14317725.321560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK[14317725.341560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317725.351560] end_request: I/O error, dev sdc, sector 64772455
[14317725.354893] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVERverbyte=DRIVER_OK,SUGGEST_OK
[14317725.381560] end_request: I/O error, dev sdc, sector 66102031
[14317725.384893] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317725.394893] end_request: I/O error, dev sdc, sectbyte=DRIVER_OK,SUGGEST_OK
[14317725.411560] end_request: I/O error, dev sdc, sector 68158103
[14317725.414893] sd 1:0:0:0: [s[ 1478.022538] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.031174] end_request: I/O error, dev sdc, sector 17568599
[ 1478.036893] printk: 148 messages suppressed.
[ 1478.041213] Buffer I/O error on device sdc1, logical block 2196067
[ 1478.047450] lost page write due to I/O error on sdc1
[ 1478.052496] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.061127] end_request: I/O error, dev sdc, sector 17568831
[ 1478.066840] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.075468] end_request: I/O error, dev sdc, sector 61912951
[ 1478.081193] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.089822] end_request: I/O error, dev sdc, sector 30487759
[ 1478.095547] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.104193] end_request: I/O error, dev sdc, sector 50352055
[ 1478.109913] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.118553] end_request: I/O error, dev sdc, sector 61912951
[ 1478.124274] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.132923] end_request: I/O error, dev sdc, sector 63025647
[ 1478.138644] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1478.147274] end_request: I/O error, dev sdc, sector 61912951
[14317730.231560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.241560] end_request: I/O error, dev sdc, sector 61912951
[14317730.248226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.258226] end_request: I/O error, dev sdc, sector 61912951
[14317730.261560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.271560] end_request: I/O error, dev sdc, sector 61912951
[14317730.278226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.288226] end_request: I/O error, dev sdc, sector 61912951
[14317730.291560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.301560] end_request: I/O error, dev sdc, sector 61912951
[14317730.308226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.318226] end_request: I/O error, dev sdc, sector 61912951
[14317730.321560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.331560] end_request: I/O error, dev sdc, sector 61912951
[14317730.338226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.344893] end_request: I/O error, dev sdc, sector 61912951
[14317730.351560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.361560] end_request: I/O error, dev sdc, sector 61912951
[14317730.368226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.374893] end_request: I/O error, dev sdc, sector 61912951
[14317730.381560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.391560] end_request: I/O error, dev sdc, sector 61912951
[14317730.398226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.404893] end_request: I/O error, dev sdc, sector 61912951
[14317730.411560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.421560] end_request: I/O error, dev sdc, sector 61912951
[14317730.431560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.441560] end_request: I/O error, dev sdc, sector 39342175
[14317730.448226] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.454893] end_request: I/O error, dev sdc, sector 39342279
[14317730.461560] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[14317730.471560] end_request: I/O error, dev sdc, sector 40912823
[ 1481.156121] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1481.164765] end_request: I/O error, dev sdc, sector 63717679
[ 1481.170654] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1481.179300] end_request: I/O error, dev sdc, sector 63717679
[ 1481.185091] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1481.193730] end_request: I/O error, dev sdc, sector 63717679
[ 1490.184313] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1490.195737] end_request: I/O error, dev sdc, sector 63717679
[ 1490.201452] printk: 9 messages suppressed.
[ 1490.205600] Buffer I/O error on device sdc1, logical block 7964702
[ 1490.212017] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1490.220662] end_request: I/O error, dev sdc, sector 63717679
[ 1490.226372] Buffer I/O error on device sdc1, logical block 7964702

--------------060800020602020207020202
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge [0600]: Intel Corporation 82975X Memory Controller Hub [8086:277c] (rev c0)
00:01.0 PCI bridge [0604]: Intel Corporation 82975X PCI Express Root Port [8086:277d] (rev c0)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 01)
00:1c.3 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 [8086:27d6] (rev 01)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 [8086:27c8] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 [8086:27c9] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 [8086:27ca] (rev 01)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 [8086:27cb] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev e1)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge [8086:27b8] (rev 01)
00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE Controller [8086:27df] (rev 01)
00:1f.2 SATA controller [0106]: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI [8086:27c1] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 01)
01:00.0 RAID bus controller [0104]: Silicon Image, Inc. PCI0680 Ultra ATA-133 Host Controller [1095:0680] (rev 02)
01:01.0 SCSI storage controller [0100]: Adaptec AHA-2940U2/U2W [9005:0010]
02:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller [11ab:4362] (rev 20)
04:00.0 VGA compatible controller [0300]: nVidia Corporation GeForce 7300 GS [10de:01df] (rev a1)

--------------060800020602020207020202--
