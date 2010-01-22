Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186Ab0AVSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0AVSg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159Ab0AVSgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:36:24 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:48235 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0AVSgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        b=SJsO0jrludCNExjmfIZFSvKmRxo2h0es8P+NtxyTAvVbXLNqWYDM4aeyI3MiTDCNw/
         nNvFt0f0h3GStuV7eaqXNg7lpOCoYCb0J0k5JrAxptCohxaucTY0UqSalro2h+nUYJm0
         4/kxS5lt8ACNy1HyZLWw0MNx7QLh5LEVAg8pw=
Date: Fri, 22 Jan 2010 22:05:07 +0330
From: Ali Gholami Rudi <ali@rudi.ir>
To: linux-acpi@vger.kernel.org
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: kacpi_notify_wq and kacpid_wq use a lot of cpu
Message-ID: <4b59efdb.E0ClbTr8sKopLDl5JyKeEOdy@lilem.mirepesht>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_4b59efdb.Q2nVe7r/zVBNxteMjjMgTF4vSDIYr7KHljVHiClF9EFkMov7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--=_4b59efdb.Q2nVe7r/zVBNxteMjjMgTF4vSDIYr7KHljVHiClF9EFkMov7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Sometimes kacpi_notify_wq and kacpid_wq workqueues use a lot of cpu.

I'm using yesterday's tip.  At times kacpi_notify_wq uses 30-50% of
my cpu and kacpid_wq uses 3-5%:

# uptime
 12:49:54 up  4:16,  1 user,  load average: 0.52, 0.55, 0.40
# ps -e | grep kacpi
  189 ?        00:00:52 kacpid
  190 ?        00:10:26 kacpi_notify
  191 ?        00:00:00 kacpi_hotplug

This sometimes happens after a few hours of uptime; so this is
very hard to bisect (by the way, I think the same thing causes
the fans to work fullspeed sometimes when I reboot the machine).
I tried this patch to find out which of the callers of
acpi_os_execute() is the culprit:

=== patch ====
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index afacf44..eded044 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -504,6 +504,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 	acpi_status status;
 	struct acpi_gpe_event_info local_gpe_event_info;
 	struct acpi_evaluate_info *info;
+	printk("acpi_ev_asynch_execute_gpe_method\n");
 
 	ACPI_FUNCTION_TRACE(ev_asynch_execute_gpe_method);
 
@@ -577,6 +578,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 static void acpi_ev_asynch_enable_gpe(void *context)
 {
 	struct acpi_gpe_event_info *gpe_event_info = context;
+	printk("acpi_ev_asynch_enable_gpe\n");
 	acpi_status status;
 	if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
 	    ACPI_GPE_LEVEL_TRIGGERED) {
diff --git a/drivers/acpi/acpica/evmisc.c b/drivers/acpi/acpica/evmisc.c
index ce224e1..e2307d1 100644
--- a/drivers/acpi/acpica/evmisc.c
+++ b/drivers/acpi/acpica/evmisc.c
@@ -224,6 +224,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_notify_dispatch(void *context)
 	acpi_notify_handler global_handler = NULL;
 	void *global_context = NULL;
 	union acpi_operand_object *handler_obj;
+	printk("acpi_ev_notify_dispatch\n");
 
 	ACPI_FUNCTION_ENTRY();
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index fd1801b..f3d8cc1 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -514,6 +514,7 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 	struct acpi_ec *ec = ec_cxt;
 	u8 value = 0;
 	struct acpi_ec_query_handler *handler, copy;
+	printk("acpi_ec_gpe_query\n");
 
 	if (!ec || acpi_ec_query(ec, &value))
 		return;
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index d933980..99f39db 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -217,6 +217,7 @@ EXPORT_SYMBOL_GPL(acpi_smbus_unregister_callback);
 static inline void acpi_smbus_callback(void *context)
 {
 	struct acpi_smb_hc *hc = context;
+	printk("acpi_smbus_callback\n");
 	if (hc->callback)
 		hc->callback(hc->context);
 }
=== patch ====

This was produced when the kacpi_notify high cpu usage happened:

=== dmesg ====
..
[12786.473794] acpi_ev_asynch_enable_gpe
[12786.473803] acpi_ev_notify_dispatch
[12786.476741] acpi_ev_asynch_execute_gpe_method
[12786.477109] acpi_ev_notify_dispatch
[12786.482973] acpi_ev_asynch_enable_gpe
[12786.482982] acpi_ev_notify_dispatch
[12786.483033] acpi_ev_asynch_execute_gpe_method
[12786.489049] acpi_ev_notify_dispatch
[12786.494038] acpi_ev_asynch_enable_gpe
[12786.494083] acpi_ev_asynch_execute_gpe_method
[12786.494434] acpi_ev_notify_dispatch
[12786.496798] acpi_ev_asynch_enable_gpe
[12786.496845] acpi_ev_asynch_execute_gpe_method
[12786.497210] acpi_ev_notify_dispatch
[12786.503034] acpi_ev_asynch_enable_gpe
[12786.503043] acpi_ev_notify_dispatch
[12786.504363] acpi_ev_asynch_execute_gpe_method
[12786.505198] acpi_ev_notify_dispatch
[12786.511051] acpi_ev_asynch_enable_gpe
[12786.511093] acpi_ev_notify_dispatch
[12786.511100] acpi_ev_asynch_execute_gpe_method
[12786.517091] acpi_ev_notify_dispatch
[12786.518697] acpi_ev_asynch_enable_gpe
[12786.518706] acpi_ev_notify_dispatch
[12786.524051] acpi_ev_asynch_execute_gpe_method
[12786.524409] acpi_ev_notify_dispatch
[12786.530079] acpi_ev_asynch_enable_gpe
[12786.530089] acpi_ev_notify_dispatch
[12786.530128] acpi_ev_asynch_execute_gpe_method
[12786.536094] acpi_ev_notify_dispatch
[12786.537761] acpi_ev_asynch_enable_gpe
[12786.537770] acpi_ev_notify_dispatch
[12786.537936] acpi_ev_asynch_execute_gpe_method
[12786.543131] acpi_ev_notify_dispatch
[12786.545642] acpi_ev_asynch_enable_gpe
[12786.545651] acpi_ev_notify_dispatch
[12786.545692] acpi_ev_asynch_execute_gpe_method
[12786.552133] acpi_ev_notify_dispatch
[12786.557167] acpi_ev_asynch_enable_gpe
[12786.557176] acpi_ev_notify_dispatch
[12786.557215] acpi_ev_asynch_execute_gpe_method
[12786.560062] acpi_ev_notify_dispatch
[12786.565185] acpi_ev_asynch_enable_gpe
[12786.565227] acpi_ev_notify_dispatch
[12786.565234] acpi_ev_asynch_execute_gpe_method
[12786.571202] acpi_ev_notify_dispatch
[12786.572811] acpi_ev_asynch_enable_gpe
[12786.575307] acpi_ev_asynch_execute_gpe_method
[12786.575664] acpi_ev_notify_dispatch
[12786.581250] acpi_ev_asynch_enable_gpe
[12786.581260] acpi_ev_notify_dispatch
[12786.581307] acpi_ev_asynch_execute_gpe_method
[12786.587251] acpi_ev_notify_dispatch
[12786.588854] acpi_ev_asynch_enable_gpe
[12786.588863] acpi_ev_notify_dispatch
[12786.822334] acpi_ev_asynch_execute_gpe_method
[12786.822710] acpi_ev_notify_dispatch
[12786.828829] acpi_ev_asynch_enable_gpe
[12786.828838] acpi_ev_notify_dispatch
[12786.828881] acpi_ev_asynch_execute_gpe_method
[12786.833867] acpi_ev_notify_dispatch
[12786.836233] acpi_ev_asynch_enable_gpe
[12786.836242] acpi_ev_notify_dispatch
[12786.957678] acpi_ev_asynch_execute_gpe_method
[12786.958065] acpi_ev_notify_dispatch
[12786.964196] acpi_ev_asynch_enable_gpe
[12786.964205] acpi_ev_notify_dispatch
[12786.964244] acpi_ev_asynch_execute_gpe_method
[12786.970213] acpi_ev_notify_dispatch
[12786.971816] acpi_ev_asynch_enable_gpe
[12786.971825] acpi_ev_notify_dispatch
[12786.997100] acpi_ev_asynch_execute_gpe_method
[12786.997472] acpi_ev_notify_dispatch
[12787.003279] acpi_ev_asynch_enable_gpe
[12787.003290] acpi_ev_notify_dispatch
[12787.003317] acpi_ev_asynch_execute_gpe_method
[12787.008331] acpi_ev_notify_dispatch
[12787.010682] acpi_ev_asynch_enable_gpe
[12787.010692] acpi_ev_notify_dispatch
[12787.309017] acpi_ev_asynch_execute_gpe_method
[12787.313035] acpi_ev_notify_dispatch
[12787.315300] acpi_ev_asynch_enable_gpe
[12787.319026] acpi_ev_asynch_execute_gpe_method
[12787.319387] acpi_ev_notify_dispatch
[12787.326065] acpi_ev_asynch_enable_gpe
[12787.326075] acpi_ev_notify_dispatch
[12787.326113] acpi_ev_asynch_execute_gpe_method
[12787.332078] acpi_ev_notify_dispatch
[12787.333685] acpi_ev_asynch_enable_gpe
[12787.333694] acpi_ev_notify_dispatch
[12788.338728] acpi_ev_asynch_execute_gpe_method
[12788.339140] acpi_ev_notify_dispatch
[12788.345606] acpi_ev_asynch_enable_gpe
[12788.345616] acpi_ev_notify_dispatch
[12788.345660] acpi_ev_asynch_execute_gpe_method
[12788.350599] acpi_ev_notify_dispatch
[12788.352955] acpi_ev_asynch_enable_gpe
[12788.352965] acpi_ev_notify_dispatch
[12789.646199] acpi_ev_asynch_execute_gpe_method
[12789.646595] acpi_ev_notify_dispatch
[12789.652861] acpi_ev_asynch_enable_gpe
[12789.652871] acpi_ev_notify_dispatch
[12789.652913] acpi_ev_asynch_execute_gpe_method
[12789.658870] acpi_ev_notify_dispatch
[12789.660495] acpi_ev_asynch_enable_gpe
[12789.660505] acpi_ev_notify_dispatch
[12791.535774] acpi_ev_asynch_execute_gpe_method
[12791.536210] acpi_ev_notify_dispatch
[12791.542525] acpi_ev_asynch_enable_gpe
[12791.542535] acpi_ev_notify_dispatch
[12791.542580] acpi_ev_asynch_execute_gpe_method
[12791.547545] acpi_ev_notify_dispatch
[12791.549935] acpi_ev_asynch_enable_gpe
[12791.549944] acpi_ev_notify_dispatch
[12791.593592] acpi_ev_asynch_execute_gpe_method
[12791.593976] acpi_ev_notify_dispatch
[12791.599677] acpi_ev_asynch_enable_gpe
[12791.599686] acpi_ev_notify_dispatch
[12791.599730] acpi_ev_asynch_execute_gpe_method
[12791.604667] acpi_ev_notify_dispatch
[12791.607042] acpi_ev_asynch_enable_gpe
[12791.607052] acpi_ev_notify_dispatch
[12791.672433] acpi_ev_asynch_execute_gpe_method
[12791.672801] acpi_ev_notify_dispatch
[12791.678850] acpi_ev_asynch_enable_gpe
[12791.678859] acpi_ev_notify_dispatch
[12791.678902] acpi_ev_asynch_execute_gpe_method
[12791.683884] acpi_ev_notify_dispatch
[12791.686249] acpi_ev_asynch_enable_gpe
[12791.686259] acpi_ev_notify_dispatch
[12791.689514] acpi_ev_asynch_execute_gpe_method
[12791.689868] acpi_ev_notify_dispatch
[12791.696055] acpi_ev_asynch_enable_gpe
[12791.696064] acpi_ev_notify_dispatch
[12791.696103] acpi_ev_asynch_execute_gpe_method
[12791.701927] acpi_ev_notify_dispatch
[12791.703545] acpi_ev_asynch_enable_gpe
[12791.703554] acpi_ev_notify_dispatch
[12791.705273] acpi_ev_asynch_execute_gpe_method
[12791.705698] acpi_ev_notify_dispatch
[12791.711953] acpi_ev_asynch_enable_gpe
[12791.711962] acpi_ev_notify_dispatch
[12791.712031] acpi_ev_asynch_execute_gpe_method
[12791.716945] acpi_ev_notify_dispatch
[12791.719313] acpi_ev_asynch_enable_gpe
[12791.719322] acpi_ev_notify_dispatch
=== dmesg ====

Is there something I can do to trace the problem? dmesg and lspci
are attached.

Thanks,
Ali

--=_4b59efdb.Q2nVe7r/zVBNxteMjjMgTF4vSDIYr7KHljVHiClF9EFkMov7
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Linux version 2.6.33-rc4 (root@laper) (gcc version 4.4.1 (CRUX) (GCC) ) #12 SMP Fri Jan 22 12:56:49 IRST 2010
[    0.000000] Command line: auto BOOT_IMAGE=laper ro root=802 rootflags=data=writeback i915.lvds_downclock=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000003f7b0000 - 000000003f7c5400 (reserved)
[    0.000000]  BIOS-e820: 000000003f7c5400 - 000000003f7e7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f7e7fb8 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3f7b0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 03F800000 mask FFF800000 uncachable
[    0.000000]   2 base 0FEDA0000 mask FFFFE0000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003f7b0000
[    0.000000]  0000000000 - 003f600000 page 2M
[    0.000000]  003f600000 - 003f7b0000 page 4k
[    0.000000] kernel direct mapping tables up to 3f7b0000 @ 8000-b000
[    0.000000] ACPI: RSDP 00000000000f6f60 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000003f7c81c4 00074 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: FACP 000000003f7c8084 000F4 (v04 HP     308A     00000003 HP   00000001)
[    0.000000] ACPI: DSDT 000000003f7c8348 13057 (v01 HP      nc6xxxs 00010000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000003f7e7d80 00040
[    0.000000] ACPI: HPET 000000003f7c8238 00038 (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: APIC 000000003f7c8270 00068 (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 000000003f7c82d8 0003C (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 000000003f7c8314 00032 (v02 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 000000003f7db39f 00328 (v01 HP       HPQSAT 00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000003f7db6c7 0017D (v01 HP       HPQMRM 00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000003f7dc229 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000003f7dc488 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000003f7dc52e 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 003f7b0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 000179f9e4]    TEXT DATA BSS ==> [0001000000 - 000179f9e4]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #3 [00017a0000 - 00017a0188]              BRK ==> [00017a0000 - 00017a0188]
[    0.000000]   #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #5 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #6 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff880001c00000-ffff8800029fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f7b0
[    0.000000] On node 0 totalpages: 259919
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3499 pages used for memmap
[    0.000000]   DMA32 zone: 252421 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880001800000 s77656 r8192 d20648 u1048576
[    0.000000] pcpu-alloc: s77656 r8192 d20648 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256260
[    0.000000] Kernel command line: auto BOOT_IMAGE=laper ro root=802 rootflags=data=writeback i915.lvds_downclock=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Memory: 1015000k/1040064k available (3826k kernel code, 388k absent, 24020k reserved, 3054k data, 420k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.971 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.94 BogoMIPS (lpj=1994971)
[    0.001253] Mount-cache hash table entries: 256
[    0.001516] CPU: Physical Processor ID: 0
[    0.001628] CPU: Processor Core ID: 0
[    0.001739] using mwait in idle threads.
[    0.002003] Performance Events: Core2 events, Intel PMU driver.
[    0.002205] ... version:                2
[    0.002318] ... bit width:              40
[    0.002429] ... generic registers:      2
[    0.002541] ... value mask:             000000ffffffffff
[    0.002654] ... max period:             000000007fffffff
[    0.002768] ... fixed-purpose events:   3
[    0.002881] ... event mask:             0000000700000003
[    0.003020] ACPI: Core revision 20091214
[    0.026066] Setting APIC routing to flat
[    0.026532] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036792] CPU0: Intel(R) Core(TM)2 Duo CPU     T5870  @ 2.00GHz stepping 0d
[    0.036999] Booting Node   0, Processors  #1 Ok.
[    0.108030] Brought up 2 CPUs
[    0.108145] Total of 2 processors activated (7979.75 BogoMIPS).
[    0.108643] devtmpfs: initialized
[    0.109008] khelper used greatest stack depth: 6608 bytes left
[    0.109061] khelper used greatest stack depth: 6032 bytes left
[    0.109187] Time: 18:11:16  Date: 01/22/10
[    0.109187] NET: Registered protocol family 16
[    0.110030] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.110209] ACPI: bus type pci registered
[    0.110333] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.110333] PCI: not using MMCONFIG
[    0.110334] PCI: Using configuration type 1 for base access
[    0.116030] bio: create slab <bio-0> at 0
[    0.118177] ACPI: EC: Look up EC in DSDT
[    0.142752] ACPI: SSDT 000000003f7db90c 0027F (v01 HP      Cpu0Ist 00003000 INTL 20060317)
[    0.143736] ACPI: SSDT 000000003f7dbc10 00619 (v01 HP      Cpu0Cst 00003001 INTL 20060317)
[    0.144827] ACPI: SSDT 000000003f7db844 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
[    0.145677] ACPI: SSDT 000000003f7dbb8b 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
[    0.182090] ACPI: Interpreter enabled
[    0.182206] ACPI: (supports S0 S3 S5)
[    0.182459] ACPI: Using IOAPIC for interrupt routing
[    0.183030] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.188852] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.202069] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.203057] ACPI: Power Resource [C2A5] (on)
[    0.203216] ACPI: Power Resource [C1CE] (off)
[    0.203429] ACPI: Power Resource [C3C1] (off)
[    0.203635] ACPI: Power Resource [C3C2] (off)
[    0.203840] ACPI: Power Resource [C3C3] (off)
[    0.204103] ACPI: Power Resource [C3C4] (off)
[    0.204308] ACPI: Power Resource [C3C5] (off)
[    0.204433] ACPI: No dock devices found.
[    0.209655] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.209799] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.219178] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.219182] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.219185] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.219187] pci_root PNP0A08:00: host bridge window [mem 0x3f800000-0xfedfffff] (ignored)
[    0.219191] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xfffffffe] invalid; aligning end to 16-byte boundary
[    0.219194] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff] (ignored)
[    0.219196] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.219262] pci 0000:00:02.0: reg 10: [mem 0xe8300000-0xe83fffff 64bit]
[    0.219270] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.219275] pci 0000:00:02.0: reg 20: [io  0x6000-0x6007]
[    0.219313] pci 0000:00:02.1: reg 10: [mem 0xe8400000-0xe84fffff 64bit]
[    0.219429] pci 0000:00:1a.0: reg 20: [io  0x6020-0x603f]
[    0.219496] pci 0000:00:1a.7: reg 10: [mem 0xe8500000-0xe85003ff]
[    0.219562] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.219568] pci 0000:00:1a.7: PME# disabled
[    0.219613] pci 0000:00:1b.0: reg 10: [mem 0xe8504000-0xe8507fff 64bit]
[    0.219676] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.219681] pci 0000:00:1b.0: PME# disabled
[    0.219779] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.219784] pci 0000:00:1c.0: PME# disabled
[    0.219892] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.219897] pci 0000:00:1c.5: PME# disabled
[    0.219959] pci 0000:00:1d.0: reg 20: [io  0x6040-0x605f]
[    0.220027] pci 0000:00:1d.1: reg 20: [io  0x6060-0x607f]
[    0.220093] pci 0000:00:1d.2: reg 20: [io  0x6080-0x609f]
[    0.220158] pci 0000:00:1d.7: reg 10: [mem 0xe8508000-0xe85083ff]
[    0.220223] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.220229] pci 0000:00:1d.7: PME# disabled
[    0.220399] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.220583] pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
[    0.220702] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
[    0.220889] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
[    0.221052] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.221060] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.221068] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.221076] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.221084] pci 0000:00:1f.1: reg 20: [io  0x60a0-0x60af]
[    0.221149] pci 0000:00:1f.2: reg 10: [io  0x13f0-0x13f7]
[    0.221157] pci 0000:00:1f.2: reg 14: [io  0x15f4-0x15f7]
[    0.221166] pci 0000:00:1f.2: reg 18: [io  0x1370-0x1377]
[    0.221174] pci 0000:00:1f.2: reg 1c: [io  0x1574-0x1577]
[    0.221182] pci 0000:00:1f.2: reg 20: [io  0x60e0-0x60ff]
[    0.221190] pci 0000:00:1f.2: reg 24: [mem 0xe8509000-0xe85097ff]
[    0.221235] pci 0000:00:1f.2: PME# supported from D3hot
[    0.221240] pci 0000:00:1f.2: PME# disabled
[    0.221322] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.221509] pci 0000:30:00.0: reg 10: [mem 0xe0000000-0xe0003fff 64bit]
[    0.221521] pci 0000:30:00.0: reg 18: [io  0x2000-0x20ff]
[    0.221612] pci 0000:30:00.0: supports D1 D2
[    0.221614] pci 0000:30:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.221621] pci 0000:30:00.0: PME# disabled
[    0.221696] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.221814] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.221819] pci 0000:00:1c.5:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.221903] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.222033] pci_bus 0000:00: on NUMA node 0
[    0.222037] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.222323] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B6._PRT]
[    0.222436] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C125._PRT]
[    0.222518] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C13D._PRT]
[    0.260019] ACPI: PCI Interrupt Link [C135] (IRQs *10 11)
[    0.260515] ACPI: PCI Interrupt Link [C136] (IRQs *10 11)
[    0.261009] ACPI: PCI Interrupt Link [C137] (IRQs 10 *11)
[    0.261490] ACPI: PCI Interrupt Link [C138] (IRQs 10 11) *0, disabled.
[    0.262070] ACPI: PCI Interrupt Link [C148] (IRQs *10 11)
[    0.262559] ACPI: PCI Interrupt Link [C149] (IRQs *10 11)
[    0.263047] ACPI: PCI Interrupt Link [C14A] (IRQs 10 11) *0, disabled.
[    0.263510] ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20091214/pci_link-184)
[    0.264016] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.264202] vgaarb: loaded
[    0.264387] SCSI subsystem initialized
[    0.264387] libata version 3.00 loaded.
[    0.264387] usbcore: registered new interface driver usbfs
[    0.264387] usbcore: registered new interface driver hub
[    0.265016] usbcore: registered new device driver usb
[    0.265127] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.265133] PCI: Using ACPI for IRQ routing
[    0.265247] PCI: pci_cache_line_size set to 64 bytes
[    0.265351] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.267011] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.268108] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.271018] Switching to clocksource tsc
[    0.271120] pnp: PnP ACPI init
[    0.271156] ACPI: bus type pnp registered
[    0.280965] pnp: PnP ACPI: found 12 devices
[    0.281079] ACPI: ACPI bus type pnp unregistered
[    0.281199] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.281317] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.281435] system 00:00: [mem 0x00100000-0x3f7fffff] could not be reserved
[    0.281558] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.281673] system 00:09: [io  0x0800-0x080f] has been reserved
[    0.281793] system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.281910] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    0.282029] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.282145] system 00:0a: [io  0x1000-0x107f] has been reserved
[    0.282262] system 00:0a: [io  0x1100-0x113f] has been reserved
[    0.282378] system 00:0a: [io  0x1200-0x121f] has been reserved
[    0.282494] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.282610] system 00:0a: [mem 0xfec00000-0xfec000ff] could not be reserved
[    0.282728] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.282850] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.282966] system 00:0a: [mem 0xfed90000-0xfed99fff] has been reserved
[    0.283085] system 00:0b: [mem 0x000cec00-0x000cffff] has been reserved
[    0.283202] system 00:0b: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.283318] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.288489] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.288604] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.288723] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.288844] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.288965] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.289081] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.289201] pci 0000:00:1c.5:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.289320] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    0.289441] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.289554] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.289673] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.289793] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.289927] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.290047] pci 0000:00:1c.0: setting latency timer to 64
[    0.290058] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.290178] pci 0000:00:1c.5: setting latency timer to 64
[    0.290186] pci 0000:00:1e.0: setting latency timer to 64
[    0.290191] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.290193] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.290196] pci_bus 0000:30: resource 0 [io  0x2000-0x2fff]
[    0.290198] pci_bus 0000:30: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.290201] pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
[    0.290203] pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.290224] NET: Registered protocol family 2
[    0.290389] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.290799] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.291992] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.292893] TCP: Hash tables configured (established 131072 bind 65536)
[    0.293011] TCP reno registered
[    0.293125] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.293251] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.293510] NET: Registered protocol family 1
[    0.293648] pci 0000:00:02.0: Boot video device
[    0.293827] PCI: CLS 64 bytes, default 64
[    0.295230] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.298675] msgmni has been set to 1983
[    0.299201] alg: No test for stdrng (krng)
[    0.299418] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.299601] io scheduler noop registered
[    0.299714] io scheduler deadline registered
[    0.299964] io scheduler cfq registered (default)
[    0.300173] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.300232] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.300377] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.300430] pcieport 0000:00:1c.5: irq 25 for MSI/MSI-X
[    0.304888] ACPI: AC Adapter [C244] (on-line)
[    0.305147] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.305329] ACPI: Sleep Button [C2BE]
[    0.305514] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.305766] ACPI: Lid Switch [C15B]
[    0.305958] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.306140] ACPI: Power Button [PWRF]
[    0.306545] ACPI: Fan [C3C6] (off)
[    0.306887] ACPI: Fan [C3C7] (off)
[    0.307220] ACPI: Fan [C3C8] (off)
[    0.307552] ACPI: Fan [C3C9] (off)
[    0.307892] ACPI: Fan [C3CA] (off)
[    0.311144] Monitor-Mwait will be used to enter C-1 state
[    0.311166] Monitor-Mwait will be used to enter C-2 state
[    0.311185] Monitor-Mwait will be used to enter C-3 state
[    0.311191] Marking TSC unstable due to TSC halts in idle
[    0.311354] Switching to clocksource hpet
[    0.321481] thermal LNXTHERM:01: registered as thermal_zone0
[    0.321604] ACPI: Thermal Zone [TZ3] (31 C)
[    0.330985] thermal LNXTHERM:02: registered as thermal_zone1
[    0.331117] ACPI: Thermal Zone [TZ4] (29 C)
[    0.334688] thermal LNXTHERM:03: registered as thermal_zone2
[    0.334810] ACPI: Thermal Zone [TZ5] (75 C)
[    0.346667] thermal LNXTHERM:04: registered as thermal_zone3
[    0.346789] ACPI: Thermal Zone [TZ0] (33 C)
[    0.351336] thermal LNXTHERM:05: registered as thermal_zone4
[    0.351457] ACPI: Thermal Zone [TZ1] (35 C)
[    0.355718] Non-volatile memory driver v1.3
[    0.355902] Linux agpgart interface v0.103
[    0.356059] agpgart-intel 0000:00:00.0: Intel 965GME/GLE Chipset
[    0.356796] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    0.361513] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.361775] [drm] Initialized drm 1.1.0 20060810
[    0.361909] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.362036] i915 0000:00:02.0: setting latency timer to 64
[    0.371673] i915 0000:00:02.0: irq 26 for MSI/MSI-X
[    0.371707] [drm] set up 7M of stolen space
[    0.394284] ACPI: Battery Slot [C245] (battery present)
[    0.495342] [drm] initialized overlay support
[    1.225120] Console: switching to colour frame buffer device 170x48
[    1.228103] fb0: inteldrmfb frame buffer device
[    1.228126] registered panic notifier
[    1.235503] acpi device:00: registered as cooling_device7
[    1.236299] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.236352] ACPI: Video Device [C09E] (multi-head: yes  rom: no  post: no)
[    1.236460] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.236556] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.239310] brd: module loaded
[    1.240357] loop: module loaded
[    1.240377] Uniform Multi-Platform E-IDE driver
[    1.240510] piix 0000:00:1f.1: IDE controller (0x8086:0x2850 rev 0x03)
[    1.240557] pci 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.240604] piix 0000:00:1f.1: IDE port disabled
[    1.240641] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    1.240683]     ide0: BM-DMA at 0x60a0-0x60a7
[    1.240711] Probing IDE interface ide0...
[    1.394043] async/0 used greatest stack depth: 4552 bytes left
[    1.759105] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.759207] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.759254] ide-gd driver 1.18
[    1.759317] ide-cd driver 5.00
[    1.759451] Loading iSCSI transport class v2.0-870.
[    1.759897] ahci 0000:00:1f.2: version 3.0
[    1.759910] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.759991] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    1.760027] ahci: SSS flag set, parallel bus scan disabled
[    1.760910] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.761822] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc 
[    1.762743] ahci 0000:00:1f.2: setting latency timer to 64
[    1.763000] scsi0 : ahci
[    1.764098] scsi1 : ahci
[    1.765178] scsi2 : ahci
[    1.766287] ata1: SATA max UDMA/133 abar m2048@0xe8509000 port 0xe8509100 irq 27
[    1.767309] ata2: SATA max UDMA/133 abar m2048@0xe8509000 port 0xe8509180 irq 27
[    1.768331] ata3: SATA max UDMA/133 abar m2048@0xe8509000 port 0xe8509200 irq 27
[    1.769590] sky2 driver version 1.26
[    1.770662] sky2 0000:30:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.771755] sky2 0000:30:00.0: setting latency timer to 64
[    1.771782] sky2 0000:30:00.0: Yukon-2 FE+ chip revision 0
[    1.773965] sky2 0000:30:00.0: irq 28 for MSI/MSI-X
[    1.774250] sky2 eth0: addr 00:26:55:b0:8c:42
[    1.775561] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.776765] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.777975] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.777979] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.779281] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.780564] ehci_hcd 0000:00:1a.7: debug port 1
[    1.785691] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.785704] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8500000
[    1.796015] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.797337] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.798683] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.800046] usb usb1: Product: EHCI Host Controller
[    1.801430] usb usb1: Manufacturer: Linux 2.6.33-rc4 ehci_hcd
[    1.802850] usb usb1: SerialNumber: 0000:00:1a.7
[    1.804409] hub 1-0:1.0: USB hub found
[    1.805784] hub 1-0:1.0: 4 ports detected
[    1.807213] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.808625] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.808629] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.810059] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.811454] ehci_hcd 0000:00:1d.7: debug port 1
[    1.816665] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.816680] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8508000
[    1.827265] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.828592] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.829937] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.831296] usb usb2: Product: EHCI Host Controller
[    1.832637] usb usb2: Manufacturer: Linux 2.6.33-rc4 ehci_hcd
[    1.833982] usb usb2: SerialNumber: 0000:00:1d.7
[    1.835475] hub 2-0:1.0: USB hub found
[    1.836786] hub 2-0:1.0: 6 ports detected
[    1.838168] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.839500] uhci_hcd: USB Universal Host Controller Interface driver
[    1.840874] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.842168] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.842172] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.843493] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.844803] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00006020
[    1.846092] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.847392] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.848649] usb usb3: Product: UHCI Host Controller
[    1.849892] usb usb3: Manufacturer: Linux 2.6.33-rc4 uhci_hcd
[    1.851119] usb usb3: SerialNumber: 0000:00:1a.0
[    1.852479] hub 3-0:1.0: USB hub found
[    1.853709] hub 3-0:1.0: 2 ports detected
[    1.854998] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.856245] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.856248] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.857578] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.858879] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006040
[    1.860172] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.861419] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.862671] usb usb4: Product: UHCI Host Controller
[    1.863916] usb usb4: Manufacturer: Linux 2.6.33-rc4 uhci_hcd
[    1.865152] usb usb4: SerialNumber: 0000:00:1d.0
[    1.866521] hub 4-0:1.0: USB hub found
[    1.867753] hub 4-0:1.0: 2 ports detected
[    1.869041] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.870317] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.870321] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.871637] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    1.872931] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006060
[    1.874209] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.875474] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.876724] usb usb5: Product: UHCI Host Controller
[    1.877978] usb usb5: Manufacturer: Linux 2.6.33-rc4 uhci_hcd
[    1.879225] usb usb5: SerialNumber: 0000:00:1d.1
[    1.880618] hub 5-0:1.0: USB hub found
[    1.881869] hub 5-0:1.0: 2 ports detected
[    1.883133] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.884409] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.884412] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.885725] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    1.887015] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006080
[    1.888309] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.889571] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.890839] usb usb6: Product: UHCI Host Controller
[    1.892100] usb usb6: Manufacturer: Linux 2.6.33-rc4 uhci_hcd
[    1.893356] usb usb6: SerialNumber: 0000:00:1d.2
[    1.894755] hub 6-0:1.0: USB hub found
[    1.896023] hub 6-0:1.0: 2 ports detected
[    1.897352] Initializing USB Mass Storage driver...
[    1.898673] usbcore: registered new interface driver usb-storage
[    1.899932] USB Mass Storage support registered.
[    1.901266] usbcore: registered new interface driver libusual
[    1.902639] PNP: PS/2 Controller [PNP0303:C2A2,PNP0f13:C2A3] at 0x60,0x64 irq 1,12
[    1.905609] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.907735] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.909039] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.910328] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.911615] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.912864] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.914203] mice: PS/2 mouse device common for all mice
[    1.915744] rtc_cmos 00:05: RTC can wake from S4
[    1.917084] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.918357] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.919963] cpuidle: using governor ladder
[    1.921842] cpuidle: using governor menu
[    1.923212] usbcore: registered new interface driver usbkbd
[    1.924453] usbkbd: :USB HID Boot Protocol keyboard driver
[    1.929788] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    1.930992] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.932283] HDA Intel 0000:00:1b.0: irq 29 for MSI/MSI-X
[    1.932316] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.937942] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.000206] ALSA device list:
[    2.001479]   #0: HDA Intel at 0xe8504000 irq 29
[    2.002749] Netfilter messages via NETLINK v0.30.
[    2.003979] nf_conntrack version 0.5.0 (7934 buckets, 31736 max)
[    2.005574] ctnetlink v0.93: registering with nfnetlink.
[    2.007300] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.008573] TCP cubic registered
[    2.009827] Initializing XFRM netlink socket
[    2.011490] NET: Registered protocol family 10
[    2.013478] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.014732] IPv6 over IPv4 tunneling driver
[    2.016586] NET: Registered protocol family 17
[    2.019319] registered taskstats version 1
[    2.022521]   Magic number: 10:148:191
[    2.025345] acpi device:1d: hash matches
[    2.073082] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.081325] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (unknown) filtered out
[    2.084079] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (unknown) filtered out
[    2.086854] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (unknown) succeeded
[    2.086865] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
[    2.090419] ata1.00: ATA-8: WDC WD1600BEVT-60ZCT1, 13.01A13, max UDMA/100
[    2.093063] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.101404] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (unknown) filtered out
[    2.104077] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (unknown) filtered out
[    2.106817] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (unknown) succeeded
[    2.106825] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
[    2.110404] ata1.00: configured for UDMA/100
[    2.126241] ata1.00: configured for UDMA/100
[    2.128879] ata1: EH complete
[    2.131693] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-6 13.0 PQ: 0 ANSI: 5
[    2.135043] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.135167] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.140414] sd 0:0:0:0: [sda] Write Protect is off
[    2.142967] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.143029] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.145930]  sda: sda1 sda2 sda3 sda4 <
[    2.204063] CE: hpet increasing min_delta_ns to 15000 nsec
[    2.209380]  sda5 sda6 sda7 sda8 >
[    2.261816] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.296086] usb 4-2: new low speed USB device using uhci_hcd and address 2
[    2.448078] ata2: SATA link down (SStatus 0 SControl 300)
[    2.457240] usb 4-2: New USB device found, idVendor=13ba, idProduct=0017
[    2.460095] usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.462897] usb 4-2: Product: Generic USB K/B
[    2.468714] input: Generic USB K/B as /devices/pci0000:00/0000:00:1d.0/usb4/4-2/4-2:1.0/input/input5
[    2.768087] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.783767] ata3.00: ATAPI: Optiarc DVD RW AD-7561S, AH03, max UDMA/100
[    2.800509] ata3.00: configured for UDMA/100
[    2.816270] scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7561S  AH03 PQ: 0 ANSI: 5
[    2.825187] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.828155] Uniform CD-ROM driver Revision: 3.20
[    2.831562] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.831939] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    2.915644] kjournald starting.  Commit interval 5 seconds
[    2.915699] EXT3-fs (sda2): mounted filesystem with writeback data mode
[    2.915720] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    2.945908] devtmpfs: mounted
[    2.948963] Freeing unused kernel memory: 420k freed
[    2.952227] Write protecting the kernel read-only data: 6144k
[    2.955677] Freeing unused kernel memory: 248k freed
[    2.958964] Freeing unused kernel memory: 224k freed
[    3.705452] fsck.ext3 used greatest stack depth: 4344 bytes left
[    4.425108] EXT3-fs (sda2): using internal journal
[    4.648272] kjournald starting.  Commit interval 5 seconds
[    4.648597] EXT3-fs (sda3): using internal journal
[    4.648606] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    4.664793] kjournald starting.  Commit interval 5 seconds
[    4.667924] EXT3-fs (sda5): using internal journal
[    4.671037] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    4.699800] kjournald starting.  Commit interval 5 seconds
[    4.700123] EXT3-fs (sda6): using internal journal
[    4.700131] EXT3-fs (sda6): mounted filesystem with writeback data mode
[    5.821803] rc used greatest stack depth: 4168 bytes left
[    6.366935] ip used greatest stack depth: 4136 bytes left
[    6.377270] sky2 eth0: enabling interface
[    6.377735] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.965384] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[    7.965534] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.017062] eth0: no IPv6 routers present

--=_4b59efdb.Q2nVe7r/zVBNxteMjjMgTF4vSDIYr7KHljVHiClF9EFkMov7
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation Mobile GME965/GLE960 Memory Controller Hub (rev 0c)
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, fast devsel, latency 0, IRQ 26
	Memory at e8300000 (64-bit, non-prefetchable) [size=1M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 6000 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GME965/GLE960 Integrated Graphics Controller (rev 0c)
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, fast devsel, latency 0
	Memory at e8400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 6020 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at e8500000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, fast devsel, latency 0, IRQ 29
	Memory at e8504000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	Capabilities: [40] Express Root Port (Slot-), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 308a
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=30, subordinate=30, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: e0000000-e00fffff
	Capabilities: [40] Express Root Port (Slot-), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 308a
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 6040 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 6060 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 6080 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at e8508000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 308a

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 60a0 [size=16]
	Kernel driver in use: PIIX_IDE

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 27
	I/O ports at 13f0 [size=8]
	I/O ports at 15f4 [size=4]
	I/O ports at 1370 [size=8]
	I/O ports at 1574 [size=4]
	I/O ports at 60e0 [size=32]
	Memory at e8509000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/4 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA <?>
	Kernel driver in use: ahci

30:00.0 Ethernet controller: Marvell Technology Group Ltd. Device 4357 (rev 10)
	Subsystem: Hewlett-Packard Company Device 308a
	Flags: bus master, fast devsel, latency 0, IRQ 28
	Memory at e0000000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at 2000 [size=256]
	Capabilities: [48] Power Management version 3
	Capabilities: [5c] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [c0] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [130] Device Serial Number 42-8c-b0-ff-ff-55-26-00
	Kernel driver in use: sky2


--=_4b59efdb.Q2nVe7r/zVBNxteMjjMgTF4vSDIYr7KHljVHiClF9EFkMov7--

