Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZEKQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZEKQMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZEKQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:12:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:52395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZEKQM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:12:27 -0400
Message-ID: <4A084E38.2050107@kernel.org>
Date: Mon, 11 May 2009 09:11:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, eswierk@aristanetworks.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org> <20090511110234.GH4648@elte.hu>
In-Reply-To: <20090511110234.GH4648@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Commit-ID:  4401da6111ac58f94234417427d06a72c4048c74
>> Gitweb:     http://git.kernel.org/tip/4401da6111ac58f94234417427d06a72c4048c74
>> Author:     Yinghai Lu <yinghai@kernel.org>
>> AuthorDate: Sat, 2 May 2009 10:40:57 -0700
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Mon, 11 May 2009 11:29:23 +0200
>>
>> x86: read apic ID in the !acpi_lapic case
>>
>> Ed found that on 32-bit, boot_cpu_physical_apicid is not read right,
>> when the mptable is broken.
> 
> -tip testing found that this patch causes a kernel crash:
> 
> [    1.208000] initcall pci_iommu_init+0x0/0x11 returned 0 after 0 usecs
> [    1.212000] calling  print_all_ICs+0x0/0x62a @ 1
> [    1.216000] 
> [    1.216000] printing PIC contents
> [    1.220000] ... PIC  IMR: fffa
> [    1.220000] ... PIC  IRR: 0000
> [    1.224000] ... PIC  ISR: 0000
> [    1.228000] ... PIC ELCR: 0828
> [    1.232000] BUG: unable to handle kernel paging request at ffffb020
> [    1.232000] IP: [<78417d5c>] native_apic_mem_read+0x15/0x19
> [    1.232000] *pde = 010ef067 *pte = 00000000 
> [    1.232000] Oops: 0000 [#1] PREEMPT 
> [    1.232000] last sysfs file: 
> [    1.232000] Modules linked in:
> [    1.232000] 
> [    1.232000] Pid: 1, comm: swapper Not tainted (2.6.30-rc5-tip #40847) System Product Name
> [    1.232000] EIP: 0060:[<78417d5c>] EFLAGS: 00010046 CPU: 0
> [    1.232000] EIP is at native_apic_mem_read+0x15/0x19
> [    1.232000] EAX: ffffb020 EBX: 00000000 ECX: 00000000 EDX: fffff000
> [    1.232000] ESI: 00000000 EDI: 7908c52e EBP: 9786fd38 ESP: 9786fd38
> [    1.232000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    1.232000] Process swapper (pid: 1, ti=9786e000 task=97870000 task.ti=9786e000)
> [    1.232000] Stack:
> [    1.232000]  9786fd40 78416e0d 9786fd48 78416fad 9786fd64 7908c55f 00000001 00000000
> [    1.232000]  00000000 00000000 7908c52e 9786fd78 784671bf 00000001 00000000 00000000
> [    1.232000]  9786fdac 7908ca42 00000001 9786fda0 784551ad 00000001 00000000 487ab0fc
> [    1.232000] Call Trace:
> [    1.232000]  [<78416e0d>] ? read_apic_id+0x19/0x24
> [    1.232000]  [<78416fad>] ? hard_smp_processor_id+0xd/0xf
> [    1.232000]  [<7908c55f>] ? print_local_APIC+0x31/0x3c7
> [    1.232000]  [<7908c52e>] ? print_local_APIC+0x0/0x3c7
> [    1.232000]  [<784671bf>] ? smp_call_function_single+0x5b/0x64
> [    1.232000]  [<7908ca42>] ? print_all_ICs+0x14d/0x62a
> [    1.232000]  [<784551ad>] ? ktime_get+0x16/0x34
> [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
> [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
> [    1.232000]  [<7840107f>] ? _stext+0x7f/0x1f2
> [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
> [    1.232000]  [<784afae4>] ? page_count+0x22/0x3f
> [    1.232000]  [<784b1c0a>] ? get_page_from_freelist+0x51f/0x6b0
> [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
> [    1.232000]  [<784dcbee>] ? check_object+0x207/0x252
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<784dd5c5>] ? __slab_free+0x11a/0x4af
> [    1.232000]  [<784df012>] ? kmem_cache_free+0xce/0x163
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<786bb75f>] ? ida_pre_get+0x13/0x18b
> [    1.232000]  [<7853f384>] ? proc_register+0x32a/0x34e
> [    1.232000]  [<7853f5bd>] ? create_proc_entry+0xf0/0x119
> [    1.232000]  [<7847e0bc>] ? register_irq_proc+0x87/0xbb
> [    1.232000]  [<7908251b>] ? kernel_init+0x8d/0x10a
> [    1.232000]  [<7908248e>] ? kernel_init+0x0/0x10a
> [    1.232000]  [<78403ee7>] ? kernel_thread_helper+0x7/0x10
> [    1.232000] Code: 44 00 00 89 d1 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff 89 08 5d c3 55 89 e5 0f 1f 44 00 00 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff <8b> 00 5d c3 55 89 e5 0f 1f 44 00 00 89 c2 eb 02 f3 90 8b 02 85 
> [    1.232000] EIP: [<78417d5c>] native_apic_mem_read+0x15/0x19 SS:ESP 0068:9786fd38
> [    1.232000] CR2: 00000000ffffb020
> [    1.232000] ---[ end trace a7919e7f17c0a725 ]---
> [    1.232000] Kernel panic - not syncing: Fatal exception
> 
> 	Ingo
> 
> [    0.000000] Linux version 2.6.30-rc5-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #40847 PREEMPT Mon May 11 12:34:41 CEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
> [    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] console [earlyser0] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] MPS support code is not built-in.
> [    0.000000] Using acpi=off or acpi=noirq or pci=noacpi may have problem
...
> [    0.000000] Using APIC driver default
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
> [    0.000000] APIC: disable apic facility
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
> [    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 maxcpus=1 nosmp noapic idle=mwait highmem=512m notsc acpi=off
...
> [    1.212000] calling  print_all_ICs+0x0/0x62a @ 1
> [    1.216000] 
> [    1.216000] printing PIC contents
> [    1.220000] ... PIC  IMR: fffa
> [    1.220000] ... PIC  IRR: 0000
> [    1.224000] ... PIC  ISR: 0000
> [    1.228000] ... PIC ELCR: 0828
> [    1.232000] BUG: unable to handle kernel paging request at ffffb020
> [    1.232000] IP: [<78417d5c>] native_apic_mem_read+0x15/0x19
> [    1.232000] *pde = 010ef067 *pte = 00000000 
> [    1.232000] Oops: 0000 [#1] PREEMPT 
> [    1.232000] last sysfs file: 
> [    1.232000] Modules linked in:
> [    1.232000] 
> [    1.232000] Pid: 1, comm: swapper Not tainted (2.6.30-rc5-tip #40847) System Product Name
> [    1.232000] EIP: 0060:[<78417d5c>] EFLAGS: 00010046 CPU: 0
> [    1.232000] EIP is at native_apic_mem_read+0x15/0x19
> [    1.232000] EAX: ffffb020 EBX: 00000000 ECX: 00000000 EDX: fffff000
> [    1.232000] ESI: 00000000 EDI: 7908c52e EBP: 9786fd38 ESP: 9786fd38
> [    1.232000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    1.232000] Process swapper (pid: 1, ti=9786e000 task=97870000 task.ti=9786e000)
> [    1.232000] Stack:
> [    1.232000]  9786fd40 78416e0d 9786fd48 78416fad 9786fd64 7908c55f 00000001 00000000
> [    1.232000]  00000000 00000000 7908c52e 9786fd78 784671bf 00000001 00000000 00000000
> [    1.232000]  9786fdac 7908ca42 00000001 9786fda0 784551ad 00000001 00000000 487ab0fc
> [    1.232000] Call Trace:
> [    1.232000]  [<78416e0d>] ? read_apic_id+0x19/0x24
> [    1.232000]  [<78416fad>] ? hard_smp_processor_id+0xd/0xf
> [    1.232000]  [<7908c55f>] ? print_local_APIC+0x31/0x3c7
> [    1.232000]  [<7908c52e>] ? print_local_APIC+0x0/0x3c7
> [    1.232000]  [<784671bf>] ? smp_call_function_single+0x5b/0x64
> [    1.232000]  [<7908ca42>] ? print_all_ICs+0x14d/0x62a
> [    1.232000]  [<784551ad>] ? ktime_get+0x16/0x34
> [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
> [    1.232000]  [<7908c8f5>] ? print_all_ICs+0x0/0x62a
> [    1.232000]  [<7840107f>] ? _stext+0x7f/0x1f2
> [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
> [    1.232000]  [<784afae4>] ? page_count+0x22/0x3f
> [    1.232000]  [<784b1c0a>] ? get_page_from_freelist+0x51f/0x6b0
> [    1.232000]  [<786c2658>] ? put_dec+0x44/0x137
> [    1.232000]  [<784dcbee>] ? check_object+0x207/0x252
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<784dd5c5>] ? __slab_free+0x11a/0x4af
> [    1.232000]  [<784df012>] ? kmem_cache_free+0xce/0x163
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<786bb54f>] ? ida_get_new_above+0x2b0/0x2ca
> [    1.232000]  [<786bb75f>] ? ida_pre_get+0x13/0x18b
> [    1.232000]  [<7853f384>] ? proc_register+0x32a/0x34e
> [    1.232000]  [<7853f5bd>] ? create_proc_entry+0xf0/0x119
> [    1.232000]  [<7847e0bc>] ? register_irq_proc+0x87/0xbb
> [    1.232000]  [<7908251b>] ? kernel_init+0x8d/0x10a
> [    1.232000]  [<7908248e>] ? kernel_init+0x0/0x10a
> [    1.232000]  [<78403ee7>] ? kernel_thread_helper+0x7/0x10
> [    1.232000] Code: 44 00 00 89 d1 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff 89 08 5d c3 55 89 e5 0f 1f 44 00 00 8b 15 08 8b de 78 8d 84 10 00 c0 ff ff <8b> 00 5d c3 55 89 e5 0f 1f 44 00 00 89 c2 eb 02 f3 90 8b 02 85 
> [    1.232000] EIP: [<78417d5c>] native_apic_mem_read+0x15/0x19 SS:ESP 0068:9786fd38
> [    1.232000] CR2: 00000000ffffb020
> [    1.232000] ---[ end trace a7919e7f17c0a725 ]---
> [    1.232000] Kernel panic - not syncing: Fatal exception

so !cpu_has_apic

we may add one native_apic_mem_read_dummy? also we could avoid alloc_bootmem_pages(PAGE_SIZE) to spare 4k bytes.

and we should check if cpu_has_apic in print_all_ICs()

YH
