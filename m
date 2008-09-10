Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYIJL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYIJL5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYIJL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:56:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYIJL4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:56:41 -0400
Date: Wed, 10 Sep 2008 13:55:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080910115525.GA31692@elte.hu>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908142619.GA10580@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So i'd suggest a different, more carful approach: keep the new code 
> you wrote, but print a WARN()ing if prev_map is not unmapped yet when 
> the next mapping is acquired. That way the ACPI code can be fixed 
> gradually and without breaking existing functionality.

ok, i stuck in your patches into tip/master today and -tip testing 
quickly found an early-ioremap leak:

[   36.625100] calling  check_early_ioremap_leak+0x0/0x3d
[   36.630253] ------------[ cut here ]------------
[   36.634884] WARNING: at arch/x86/mm/ioremap.c:577 check_early_ioremap_leak+0x28/0x3d()
[   36.642811] Debug warning: early ioremap leak of 1 areas detected.

find the full log below with ioremap-leak-tracing turned on. I've 
excluded these commits for now from tip/master.

	Ingo

---------------->
[    0.000000] Linux version 2.6.27-rc6-tip-00189-gafeef79-dirty (mingo@titan) (gcc version 4.2.3) #1 SMP Wed Sep 10 13:53:53 CEST 2008
[    0.000000] Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi early_ioremap_debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
[    0.000000]  BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
[    0.000000]  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
[    0.000000]  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] last_pfn = 0x3ff00 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003ff00000 page 4k
[    0.000000] kernel direct mapping tables up to 3ff00000 @ 8000-b000
[    0.000000] early_ioremap(00008000, 00001000) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff81278194>] early_memremap+0x13/0x15
[    0.000000]  [<ffffffff80bdc019>] alloc_low_page+0x76/0x98
[    0.000000]  [<ffffffff812b394b>] phys_pmd_init+0x171/0x1fa
[    0.000000]  [<ffffffff812b3ac9>] phys_pud_init+0xf5/0x1fb
[    0.000000]  [<ffffffff80bdc4c6>] init_memory_mapping+0x46d/0x5e5
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812685b2>] setup_arch+0x450/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00001000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80230c27>] ? update_page_count+0x37/0x3c
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff80bdc057>] unmap_low_page+0x1c/0x1e
[    0.000000]  [<ffffffff812b3968>] phys_pmd_init+0x18e/0x1fa
[    0.000000]  [<ffffffff812b3ac9>] phys_pud_init+0xf5/0x1fb
[    0.000000]  [<ffffffff80bdc4c6>] init_memory_mapping+0x46d/0x5e5
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812685b2>] setup_arch+0x450/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] last_map_addr: 3ff00000 end: 3ff00000
[    0.000000] early_ioremap(000f0000, 00010000) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff812a7ba4>] dmi_scan_machine+0x74/0xd9
[    0.000000]  [<ffffffff812686dc>] setup_arch+0x57a/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] DMI 2.3 present.
[    0.000000] early_ioremap(000e4d10, 0000061f) [1] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff812a7aec>] dmi_present+0xe3/0x127
[    0.000000]  [<ffffffff812a7bc0>] dmi_scan_machine+0x90/0xd9
[    0.000000]  [<ffffffff812686dc>] setup_arch+0x57a/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000d10 + ffffffffff440000
[    0.000000] early_iounmap(ffffffffff440d10, 0000061f) [1]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80a0f636>] ? dmi_table+0x56/0x81
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff812a7b20>] dmi_present+0x117/0x127
[    0.000000]  [<ffffffff812a7bc0>] dmi_scan_machine+0x90/0xd9
[    0.000000]  [<ffffffff812686dc>] setup_arch+0x57a/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_iounmap(ffffffffff400000, 00010000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff812a7bdb>] dmi_scan_machine+0xab/0xd9
[    0.000000]  [<ffffffff812686dc>] setup_arch+0x57a/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(0000040e, 00000002) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec343>] acpi_find_root_pointer+0x3f/0x254
[    0.000000]  [<ffffffff8128a953>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff8128aa15>] acpi_initialize_tables+0x99/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 0000040e + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff40040e, 00000002) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec3b8>] acpi_find_root_pointer+0xb4/0x254
[    0.000000]  [<ffffffff8128a953>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff8128aa15>] acpi_initialize_tables+0x99/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(0009fc00, 00000400) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec3b8>] acpi_find_root_pointer+0xb4/0x254
[    0.000000]  [<ffffffff8128a953>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff8128aa15>] acpi_initialize_tables+0x99/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000c00 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400c00, 00000400) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec46a>] acpi_find_root_pointer+0x166/0x254
[    0.000000]  [<ffffffff8128a953>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff8128aa15>] acpi_initialize_tables+0x99/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(000e0000, 00020000) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec46a>] acpi_find_root_pointer+0x166/0x254
[    0.000000]  [<ffffffff8128a953>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff8128aa15>] acpi_initialize_tables+0x99/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00020000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128aabe>] acpi_tb_parse_root_table+0x42/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(000fe020, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128aabe>] acpi_tb_parse_root_table+0x42/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000020 + ffffffffff400000
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] early_iounmap(ffffffffff400020, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128abb2>] acpi_tb_parse_root_table+0x136/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefde48, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128abb2>] acpi_tb_parse_root_table+0x136/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e48 + ffffffffff400000
[    0.000000] ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400e48, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128ac61>] acpi_tb_parse_root_table+0x1e5/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefde48, 00000050) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff8128ac61>] acpi_tb_parse_root_table+0x1e5/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e48 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400e48, 00000050) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277e5d>] ? __early_set_fixmap+0xb3/0xbc
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefcf10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000f10 + ffffffffff400000
[    0.000000] ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400f10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec15f>] acpi_tb_parse_fadt+0x32/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefcf10, 00000074) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ec15f>] acpi_tb_parse_fadt+0x32/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000f10 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400f10, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277e5d>] ? __early_set_fixmap+0xb3/0xbc
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff805ec1a3>] acpi_tb_parse_fadt+0x76/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef8010, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff805ec1a3>] acpi_tb_parse_fadt+0x76/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000010 + ffffffffff400000
[    0.000000] ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400010, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff805ec1bd>] acpi_tb_parse_fadt+0x90/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fedfc40, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff805ec1bd>] acpi_tb_parse_fadt+0x90/0x9b
[    0.000000]  [<ffffffff8128adc2>] acpi_tb_parse_root_table+0x346/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000c40 + ffffffffff400000
[    0.000000] ACPI: FACS 3FEDFC40, 0040
[    0.000000] early_iounmap(ffffffffff400c40, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400e10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef7f90, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000f90 + ffffffffff400000
[    0.000000] ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400f90, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef7f10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000f10 + ffffffffff400000
[    0.000000] ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400f10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefcd10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000d10 + ffffffffff400000
[    0.000000] ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400d10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef7e90, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e90 + ffffffffff400000
[    0.000000] ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400e90, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefdc10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000c10 + ffffffffff400000
[    0.000000] ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400c10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefda10, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000a10 + ffffffffff400000
[    0.000000] ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400a10, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefd810, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000810 + ffffffffff400000
[    0.000000] ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400810, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefd610, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000610 + ffffffffff400000
[    0.000000] ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400610, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefd410, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805ebba1>] acpi_tb_install_table+0x53/0xf6
[    0.000000]  [<ffffffff8128ada4>] acpi_tb_parse_root_table+0x328/0x3ae
[    0.000000]  [<ffffffff8128aa4f>] acpi_initialize_tables+0xd3/0x100
[    0.000000]  [<ffffffff8128a19e>] acpi_table_init+0x1b/0x7d
[    0.000000]  [<ffffffff8126dd7a>] acpi_boot_table_init+0x35/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000410 + ffffffffff400000
[    0.000000] ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
[    0.000000] early_iounmap(ffffffffff400410, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff805eabb6>] ? acpi_get_table+0xc/0x98
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef8010, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff805eabb6>] ? acpi_get_table+0xc/0x98
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000010 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400010, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef8010, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000010 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400010, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef8010, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000010 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400010, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef8010, 00000024) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eafd7>] acpi_get_table_header+0x66/0xb5
[    0.000000]  [<ffffffff8128a3d1>] acpi_blacklisted+0x41/0x15c
[    0.000000]  [<ffffffff8126d102>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff8126ddc2>] acpi_boot_table_init+0x7d/0xda
[    0.000000]  [<ffffffff812686e6>] setup_arch+0x584/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000010 + ffffffffff400000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003ff00000
[    0.000000] Bootmem setup node 0 0000000000000000-000000003ff00000
[    0.000000]   NODE_DATA [0000000000009000 - 000000000003cfff]
[    0.000000]   bootmap [000000000003d000 -  0000000000044fdf] pages 8
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003ff00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0001e6ede0]    TEXT DATA BSS ==> [0000200000 - 0001e6ede0]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fe680] 000fe680
[    0.000000]  [ffffe20000000000-ffffe200015fffff] PMD -> [ffff880002000000-ffff8800035fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ed94
[    0.000000]     0: 0x0003ee4e -> 0x0003fea2
[    0.000000]     0: 0x0003fee9 -> 0x0003feed
[    0.000000]     0: 0x0003feff -> 0x0003ff00
[    0.000000] On node 0 totalpages: 261516
[    0.000000]   DMA zone: 3809 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 251978 pages, LIFO batch:31
[    0.000000] early_iounmap(ffffffffff400010, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d0b3>] ? acpi_parse_fadt+0x0/0x4f
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d764>] acpi_boot_init+0x4a/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefcf10, 00000074) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d0b3>] ? acpi_parse_fadt+0x0/0x4f
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d764>] acpi_boot_init+0x4a/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000f10 + ffffffffff400000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] early_iounmap(ffffffffff400f10, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d312>] ? acpi_parse_madt+0x0/0x74
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d777>] acpi_boot_init+0x5d/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d312>] ? acpi_parse_madt+0x0/0x74
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d777>] acpi_boot_init+0x5d/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8024ba80>] ? printk+0x6c/0x6e
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126ce45>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff8126d37d>] ? acpi_parse_madt+0x6b/0x74
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7ab>] acpi_boot_init+0x91/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126ce45>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff8126d37d>] ? acpi_parse_madt+0x6b/0x74
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7ab>] acpi_boot_init+0x91/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d284>] ? acpi_parse_sapic+0x0/0x4b
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7da>] acpi_boot_init+0xc0/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d284>] ? acpi_parse_sapic+0x0/0x4b
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7da>] acpi_boot_init+0xc0/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d2cf>] ? acpi_parse_lapic+0x0/0x43
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7f3>] acpi_boot_init+0xd9/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d2cf>] ? acpi_parse_lapic+0x0/0x43
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d7f3>] acpi_boot_init+0xd9/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d23e>] ? acpi_parse_lapic_nmi+0x0/0x46
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d822>] acpi_boot_init+0x108/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d23e>] ? acpi_parse_lapic_nmi+0x0/0x46
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d822>] acpi_boot_init+0x108/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126db30>] ? acpi_parse_ioapic+0x0/0x41
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d8a1>] acpi_boot_init+0x187/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126db30>] ? acpi_parse_ioapic+0x0/0x41
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d8a1>] acpi_boot_init+0x187/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d5b3>] ? acpi_parse_int_src_ovr+0x0/0x9f
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d8e7>] acpi_boot_init+0x1cd/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d5b3>] ? acpi_parse_int_src_ovr+0x0/0x9f
[    0.000000]  [<ffffffff80232e61>] ? native_set_fixmap+0x45/0x49
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d8e7>] acpi_boot_init+0x1cd/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d216>] ? acpi_parse_nmi_src+0x0/0x28
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d929>] acpi_boot_init+0x20f/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fefce10, 00000078) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8128a2c5>] acpi_table_parse_entries+0x5d/0x109
[    0.000000]  [<ffffffff8126d216>] ? acpi_parse_nmi_src+0x0/0x28
[    0.000000]  [<ffffffff8128a38e>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8126d929>] acpi_boot_init+0x20f/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e10 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400e10, 00000078) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81277fa0>] early_iounmap+0x4e/0xc4
[    0.000000]  [<ffffffff8126dccc>] __acpi_map_table+0x33/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d386>] ? acpi_parse_hpet+0x0/0x143
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d9b6>] acpi_boot_init+0x29c/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] early_ioremap(3fef7e90, 00000038) [0] => Pid: 0, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80228ed1>] ? native_make_pte+0x9/0xe
[    0.000000]  [<ffffffff81278077>] __early_ioremap+0x61/0x16b
[    0.000000]  [<ffffffff812781a9>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8126dcde>] __acpi_map_table+0x45/0x51
[    0.000000]  [<ffffffff80bde390>] acpi_os_map_memory+0x1e/0x20
[    0.000000]  [<ffffffff805eb813>] acpi_tb_verify_table+0x49/0xc3
[    0.000000]  [<ffffffff805eabfa>] acpi_get_table+0x50/0x98
[    0.000000]  [<ffffffff8126d386>] ? acpi_parse_hpet+0x0/0x143
[    0.000000]  [<ffffffff8128a24e>] acpi_table_parse+0x4e/0x68
[    0.000000]  [<ffffffff8126d9b6>] acpi_boot_init+0x29c/0x2a2
[    0.000000]  [<ffffffff81268744>] setup_arch+0x5e2/0x67c
[    0.000000]  [<ffffffff80c307b5>] ? _spin_unlock+0x2b/0x2f
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff81261b73>] start_kernel+0xe9/0x40a
[    0.000000]  [<ffffffff81261140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff812612be>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff81261421>] x86_64_start_kernel+0x13c/0x14b
[    0.000000] 00000e90 + ffffffffff400000
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
[    0.000000] dyn_array irq_2_pin_head+0x0/0x8 size:0x10 nr:256 align:0x1000
[    0.000000] dyn_array irq_cfgx+0x0/0x8 size:0x420 nr:32 align:0x1000
[    0.000000] dyn_array sparse_irqs+0x0/0x8 size:0x500 nr:32 align:0x1000
[    0.000000] dyn_array total_size: 0x14000
[    0.000000] dyn_array irq_2_pin_head+0x0/0x8  ==> [0x1e83000 - 0x1e84000]
[    0.000000] dyn_array irq_cfgx+0x0/0x8  ==> [0x1e84000 - 0x1e8c400]
[    0.000000] dyn_array sparse_irqs+0x0/0x8  ==> [0x1e8d000 - 0x1e97000]
[    0.000000] kstat_irqs ==> [0x1e97000 - 0x1e97200]
[    0.000000] PERCPU: Allocating 57344 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000001e98000
[    0.000000] per cpu data for cpu1 on node0 at 0000000001ea6000
[    0.000000] per cpu data for cpu2 on node0 at 0000000001eb4000
[    0.000000] per cpu data for cpu3 on node0 at 0000000001ec2000
[    0.000000] NR_CPUS: 4096, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255787
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi early_ioremap_debug
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] found new irq_desc for irq 0
[    0.000000] found new irq_desc for irq 1
[    0.000000] found new irq_desc for irq 2
[    0.000000] found new irq_desc for irq 3
[    0.000000] found new irq_desc for irq 4
[    0.000000] found new irq_desc for irq 5
[    0.000000] found new irq_desc for irq 6
[    0.000000] found new irq_desc for irq 7
[    0.000000] found new irq_desc for irq 8
[    0.000000] found new irq_desc for irq 9
[    0.000000] found new irq_desc for irq 10
[    0.000000] found new irq_desc for irq 11
[    0.000000] found new irq_desc for irq 12
[    0.000000] found new irq_desc for irq 13
[    0.000000] found new irq_desc for irq 14
[    0.000000] found new irq_desc for irq 15
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2933.341 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console handover: boot [earlyser0] -> real [tty0]
[    0.004000] console [ttyS0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:           4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 3839 kB
[    0.004000]  per task-struct memory footprint: 1920 bytes
[    0.004000] ------------------------
[    0.004000] | Locking API testsuite:
[    0.004000] ----------------------------------------------------------------------------
[    0.004000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.004000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]               recursive read-lock:             |  ok  |             |failed|
[    0.004000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.004000]             mixed read-write-lock:             |failed|             |failed|
[    0.004000]             mixed write-read-lock:             |failed|             |failed|
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.004000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.004000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.004000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.004000]       hard-irq read-recursion/123:  ok  |
[    0.004000]       soft-irq read-recursion/123:  ok  |
[    0.004000]       hard-irq read-recursion/132:  ok  |
[    0.004000]       soft-irq read-recursion/132:  ok  |
[    0.004000]       hard-irq read-recursion/213:  ok  |
[    0.004000]       soft-irq read-recursion/213:  ok  |
[    0.004000]       hard-irq read-recursion/231:  ok  |
[    0.004000]       soft-irq read-recursion/231:  ok  |
[    0.004000]       hard-irq read-recursion/312:  ok  |
[    0.004000]       soft-irq read-recursion/312:  ok  |
[    0.004000]       hard-irq read-recursion/321:  ok  |
[    0.004000]       soft-irq read-recursion/321:  ok  |
[    0.004000] --------------------------------------------------------
[    0.004000] 133 out of 218 testcases failed, as expected. |
[    0.004000] ----------------------------------------------------
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 952092k/1047552k available (10447k kernel code, 93972k reserved, 5618k data, 1468k init)
[    0.004000] CPA: page pool initialized 16 of 16 pages preallocated
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5866.68 BogoMIPS (lpj=11733364)
[    0.008087] Security Framework initialized
[    0.012385] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.016782] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.020326] Mount-cache hash table entries: 256
[    0.024616] Initializing cgroup subsys debug
[    0.028012] Initializing cgroup subsys ns
[    0.032013] Initializing cgroup subsys devices
[    0.036044] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.040006] CPU: L2 cache: 4096K
[    0.044007] CPU 0/0 -> Node 0
[    0.046989] CPU: Physical Processor ID: 0
[    0.048006] CPU: Processor Core ID: 0
[    0.052012] CPU0: Thermal monitoring enabled (TM2)
[    0.056007] using mwait in idle threads.
[    0.060008] numa_add_cpu cpu 0 node 0: mask now 0
[    0.064606] ACPI: Core revision 20080609
[    0.082980] Parsing all Control Methods:
[    0.084273] Table [DSDT](id 0001) - 529 Objects with 55 Devices 147 Methods 32 Regions
[    0.088427] Parsing all Control Methods:
[    0.092258] Table [SSDT](id 0002) - 10 Objects with 0 Devices 4 Methods 0 Regions
[    0.096228] Parsing all Control Methods:
[    0.100260] Table [SSDT](id 0003) - 5 Objects with 0 Devices 3 Methods 0 Regions
[    0.104228] Parsing all Control Methods:
[    0.108263] Table [SSDT](id 0004) - 5 Objects with 0 Devices 3 Methods 0 Regions
[    0.112238] Parsing all Control Methods:
[    0.116267] Table [SSDT](id 0005) - 5 Objects with 0 Devices 3 Methods 0 Regions
[    0.120231] Parsing all Control Methods:
[    0.124268] Table [SSDT](id 0006) - 5 Objects with 0 Devices 3 Methods 0 Regions
[    0.128011]  tbxface-0596 [02] tb_load_namespace     : ACPI Tables successfully acquired
[    0.140013] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
[    0.148171] Setting APIC routing to flat
[    0.152014] enabled ExtINT on CPU#0
[    0.156156] ENABLING IO-APIC IRQs
[    0.159484] init IO_APIC IRQs
[    0.160013]  2-0<7> 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
[    0.168023] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.172016]  0 add_pin_to_irq: irq 0 --> apic 0 pin 2
[    0.176015] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.180016]  0 add_pin_to_irq: irq 3 --> apic 0 pin 3
[    0.184014] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.188015]  0 add_pin_to_irq: irq 4 --> apic 0 pin 4
[    0.192014] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.196016]  0 add_pin_to_irq: irq 5 --> apic 0 pin 5
[    0.200015] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.204016]  0 add_pin_to_irq: irq 6 --> apic 0 pin 6
[    0.208016] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.212017]  0 add_pin_to_irq: irq 7 --> apic 0 pin 7
[    0.216016] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.220017]  0 add_pin_to_irq: irq 8 --> apic 0 pin 8
[    0.224016] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.228018]  0 add_pin_to_irq: irq 9 --> apic 0 pin 9
[    0.232017] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.236018]  0 add_pin_to_irq: irq 10 --> apic 0 pin 10
[    0.240018] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.244019]  0 add_pin_to_irq: irq 11 --> apic 0 pin 11
[    0.248018] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.252019]  0 add_pin_to_irq: irq 12 --> apic 0 pin 12
[    0.256019] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.260020]  0 add_pin_to_irq: irq 13 --> apic 0 pin 13
[    0.264019] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.268020]  0 add_pin_to_irq: irq 14 --> apic 0 pin 14
[    0.272020] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.276021]  0 add_pin_to_irq: irq 15 --> apic 0 pin 15
[    0.280020] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.284021]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.291635] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.333484] CPU0: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
[    0.340023] Using local APIC timer interrupts.
[    0.340023] calibrating APIC timer ...
[    0.348021] ... lapic delta = 1666650
[    0.348021] ... PM timer delta = 357952
[    0.348021] ... PM timer result ok
[    0.348021] ..... delta 1666650
[    0.348021] ..... mult: 71577598
[    0.348021] ..... calibration result: 1066656
[    0.348021] ..... CPU clock speed is 2933.1227 MHz.
[    0.348021] ..... host bus clock speed is 266.2656 MHz.
[    0.348035] calling  migration_init+0x0/0x5b
[    0.352091] initcall migration_init+0x0/0x5b returned 1 after 0 msecs
[    0.358401] initcall migration_init+0x0/0x5b returned with error code 1 
[    0.364024] calling  spawn_ksoftirqd+0x0/0x58
[    0.368083] initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0 msecs
[    0.376027] calling  init_call_single_data+0x0/0x76
[    0.380026] initcall init_call_single_data+0x0/0x76 returned 0 after 0 msecs
[    0.388026] calling  relay_init+0x0/0x14
[    0.392027] initcall relay_init+0x0/0x14 returned 0 after 0 msecs
[    0.398502] lockdep: fixing up alternatives.
[    0.400088] Booting processor 1/1 ip 6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5866.69 BogoMIPS (lpj=11733398)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.496639] CPU1: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
[    0.505296] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.508064] Brought up 2 CPUs
[    0.512034] Total of 2 processors activated (11733.38 BogoMIPS).
[    0.516183] CPU0 attaching sched-domain:
[    0.520035]  domain 0: span 0-1 level MC
[    0.525716]   groups: 0 1
[    0.528659]   domain 1: span 0-1 level NODE
[    0.532032]    groups: 0-1
[    0.536249] CPU1 attaching sched-domain:
[    0.540036]  domain 0: span 0-1 level MC
[    0.545716]   groups: 1 0
[    0.548662]   domain 1: span 0-1 level NODE
[    0.552032]    groups: 0-1
[    0.556350] device: 'platform': device_add
[    0.560052] PM: Adding info for No Bus:platform
[    0.564118] bus: 'platform': registered
[    0.568037] Registering sysdev class 'cpu'
[    0.572276] calling  net_ns_init+0x0/0x13e
[    0.576034] net_namespace: 1648 bytes
[    0.580046] initcall net_ns_init+0x0/0x13e returned 0 after 3 msecs
[    0.586410] calling  init_smp_flush+0x0/0x66
[    0.588033] initcall init_smp_flush+0x0/0x66 returned 0 after 0 msecs
[    0.594410] calling  print_banner+0x0/0xe
[    0.596033] Booting paravirtualized kernel on bare hardware
[    0.600033] initcall print_banner+0x0/0xe returned 0 after 3 msecs
[    0.606409] calling  sysctl_init+0x0/0x16
[    0.608035] initcall sysctl_init+0x0/0x16 returned 0 after 0 msecs
[    0.616033] calling  ksysfs_init+0x0/0xbb
[    0.620097] initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
[    0.626411] calling  init_jiffies_clocksource+0x0/0x12
[    0.628034] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
[    0.634413] calling  pm_init+0x0/0x34
[    0.636040] initcall pm_init+0x0/0x34 returned 0 after 0 msecs
[    0.644034] calling  filelock_init+0x0/0x2e
[    0.648039] initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
[    0.654410] calling  init_script_binfmt+0x0/0x12
[    0.656037] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
[    0.662410] calling  init_elf_binfmt+0x0/0x12
[    0.664033] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
[    0.672033] calling  init_compat_elf_binfmt+0x0/0x12
[    0.676034] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
[    0.682410] calling  debugfs_init+0x0/0x51
[    0.684039] initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
[    0.692033] calling  securityfs_init+0x0/0x51
[    0.696038] initcall securityfs_init+0x0/0x51 returned 0 after 0 msecs
[    0.702410] calling  random32_init+0x0/0xca
[    0.704034] initcall random32_init+0x0/0xca returned 0 after 0 msecs
[    0.712034] calling  gnttab_init+0x0/0x16c
[    0.716033] initcall gnttab_init+0x0/0x16c returned -19 after 0 msecs
[    0.724033] calling  cpuidle_init+0x0/0x40
[    0.728040] initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
[    0.734409] calling  sock_init+0x0/0x5e
[    0.736094] initcall sock_init+0x0/0x5e returned 0 after 0 msecs
[    0.744033] calling  netpoll_init+0x0/0x14
[    0.748034] initcall netpoll_init+0x0/0x14 returned 0 after 0 msecs
[    0.754410] calling  netlink_proto_init+0x0/0x14b
[    0.756069] NET: Registered protocol family 16
[    0.760058] initcall netlink_proto_init+0x0/0x14b returned 0 after 3 msecs
[    0.766410] calling  bdi_class_init+0x0/0x41
[    0.768034] device class 'bdi': registering
[    0.772097] initcall bdi_class_init+0x0/0x41 returned 0 after 3 msecs
[    0.778410] calling  kobject_uevent_init+0x0/0x45
[    0.780040] initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
[    0.786410] calling  pcibus_class_init+0x0/0x19
[    0.788033] device class 'pci_bus': registering
[    0.792096] initcall pcibus_class_init+0x0/0x19 returned 0 after 3 msecs
[    0.798411] calling  pci_driver_init+0x0/0x12
[    0.800096] bus: 'pci': registered
[    0.804034] initcall pci_driver_init+0x0/0x12 returned 0 after 3 msecs
[    0.812033] calling  backlight_class_init+0x0/0x4d
[    0.816034] device class 'backlight': registering
[    0.820096] initcall backlight_class_init+0x0/0x4d returned 0 after 3 msecs
[    0.828033] calling  dock_init+0x0/0x5a
[    0.832218] No dock devices found.
[    0.836033] initcall dock_init+0x0/0x5a returned 0 after 3 msecs
[    0.842409] calling  xenbus_probe_init+0x0/0xf1
[    0.844033] initcall xenbus_probe_init+0x0/0xf1 returned -19 after 0 msecs
[    0.850583] calling  tty_class_init+0x0/0x31
[    0.852033] device class 'tty': registering
[    0.856096] initcall tty_class_init+0x0/0x31 returned 0 after 3 msecs
[    0.864033] calling  vtconsole_class_init+0x0/0xc3
[    0.868034] device class 'vtconsole': registering
[    0.872096] device: 'vtcon0': device_add
[    0.876056] PM: Adding info for No Bus:vtcon0
[    0.880096] initcall vtconsole_class_init+0x0/0xc3 returned 0 after 11 msecs
[    0.886496] calling  register_node_type+0x0/0x45
[    0.888033] Registering sysdev class 'node'
[    0.892096] initcall register_node_type+0x0/0x45 returned 0 after 3 msecs
[    0.898410] calling  amd_postcore_init+0x0/0x859
[    0.900033] initcall amd_postcore_init+0x0/0x859 returned 0 after 0 msecs
[    0.908034] calling  arch_kdebugfs_init+0x0/0x24
[    0.912039] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 msecs
[    0.920033] calling  mtrr_if_init+0x0/0x94
[    0.924038] initcall mtrr_if_init+0x0/0x94 returned 0 after 0 msecs
[    0.932033] calling  acpi_pci_init+0x0/0x57
[    0.936039] ACPI: bus type pci registered
[    0.940033] initcall acpi_pci_init+0x0/0x57 returned 0 after 3 msecs
[    0.946410] calling  init_acpi_device_notify+0x0/0x4b
[    0.948033] initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 msecs
[    0.954413] calling  setup_vcpu_hotplug_event+0x0/0x22
[    0.956033] initcall setup_vcpu_hotplug_event+0x0/0x22 returned -19 after 0 msecs
[    0.962587] calling  dmi_id_init+0x0/0x2f0
[    0.964036] device class 'dmi': registering
[    0.968096] device: 'id': device_add
[    0.971686] PM: Adding info for No Bus:id
[    0.972096] initcall dmi_id_init+0x0/0x2f0 returned 0 after 7 msecs
[    0.980033] calling  pci_arch_init+0x0/0x4e
[    0.984055] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.988033] PCI: Not using MMCONFIG.
[    0.992034] PCI: Using configuration type 1 for base access
[    0.996039] initcall pci_arch_init+0x0/0x4e returned 0 after 11 msecs
[    1.002497] calling  topology_init+0x0/0x7b
[    1.004033] Registering sys device of class 'node'
[    1.008037] Registering sys device 'node0'
[    1.012096] Registering sys device of class 'cpu'
[    1.016037] Registering sys device 'cpu0'
[    1.020096] Registering sys device of class 'cpu'
[    1.024037] Registering sys device 'cpu1'
[    1.028096] initcall topology_init+0x0/0x7b returned 0 after 22 msecs
[    1.036033] calling  mtrr_init_finialize+0x0/0x3d
[    1.040034] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 msecs
[    1.048033] calling  param_sysfs_init+0x0/0x1d6
[    1.086385] initcall param_sysfs_init+0x0/0x1d6 returned 0 after 30 msecs
[    1.092476] calling  pm_sysrq_init+0x0/0x1e
[    1.096056] initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 msecs
[    1.104034] calling  readahead_init+0x0/0x38
[    1.108061] device: 'default': device_add
[    1.112054] PM: Adding info for No Bus:default
[    1.116091] initcall readahead_init+0x0/0x38 returned 0 after 7 msecs
[    1.122411] calling  init_bio+0x0/0xca
[    1.128305] initcall init_bio+0x0/0xca returned 0 after 0 msecs
[    1.132523] calling  integrity_init+0x0/0x3a
[    1.140159] initcall integrity_init+0x0/0x3a returned 0 after 0 msecs
[    1.144592] calling  blk_settings_init+0x0/0x2a
[    1.152105] initcall blk_settings_init+0x0/0x2a returned 0 after 0 msecs
[    1.160033] calling  blk_ioc_init+0x0/0x2a
[    1.164039] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
[    1.170409] calling  genhd_device_init+0x0/0x55
[    1.176033] device class 'block': registering
[    1.180071] initcall genhd_device_init+0x0/0x55 returned 0 after 3 msecs
[    1.186410] calling  blk_dev_integrity_init+0x0/0x2a
[    1.192038] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 msecs
[    1.198414] calling  pci_slot_init+0x0/0x4a
[    1.204039] initcall pci_slot_init+0x0/0x4a returned 0 after 0 msecs
[    1.208033] calling  fbmem_init+0x0/0x91
[    1.212057] device class 'graphics': registering
[    1.216097] initcall fbmem_init+0x0/0x91 returned 0 after 3 msecs
[    1.224034] calling  acpi_init+0x0/0x221
[    1.229169] evgpeblk-0957 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[    1.236203] ACPI: EC: Look up EC in DSDT
[    1.246704] Completing Region/Field/Buffer/Package initialization:.................................................................................
[    1.269987] Initialized 26/32 Regions 0/0 Fields 25/25 Buffers 30/30 Packages (568 nodes)
[    1.276034] Initializing Device/Processor/Thermal objects by executing _INI methods:.
[    1.284305] Executed 1 _INI methods requiring 0 _STA executions (examined 61 objects)
[    1.293480] evgpeblk-1054 [03] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
[    1.304108] ACPI: Interpreter enabled
[    1.308033] ACPI: (supports S0 S5)
[    1.312655] ACPI: Using IOAPIC for interrupt routing
[    1.316127] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    1.333006] PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
[    1.340034] PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    1.350852] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    1.356034] initcall acpi_init+0x0/0x221 returned 0 after 122 msecs
[    1.360033] calling  acpi_scan_init+0x0/0x110
[    1.368097] bus: 'acpi': registered
[    1.368097] device: 'LNXSYSTM:00': device_add
[    1.376041] bus: 'acpi': add device LNXSYSTM:00
[    1.380044] PM: Adding info for acpi:LNXSYSTM:00
[    1.384091] device: 'LNXPWRBN:00': device_add
[    1.388039] bus: 'acpi': add device LNXPWRBN:00
[    1.392050] PM: Adding info for acpi:LNXPWRBN:00
[    1.396092] device: 'ACPI0007:00': device_add
[    1.400040] bus: 'acpi': add device ACPI0007:00
[    1.404043] PM: Adding info for acpi:ACPI0007:00
[    1.412091] device: 'ACPI0007:01': device_add
[    1.416040] bus: 'acpi': add device ACPI0007:01
[    1.420043] PM: Adding info for acpi:ACPI0007:01
[    1.424090] device: 'ACPI0007:02': device_add
[    1.428040] bus: 'acpi': add device ACPI0007:02
[    1.432049] PM: Adding info for acpi:ACPI0007:02
[    1.440090] device: 'ACPI0007:03': device_add
[    1.444048] bus: 'acpi': add device ACPI0007:03
[    1.448044] PM: Adding info for acpi:ACPI0007:03
[    1.452141] device: 'device:00': device_add
[    1.456040] bus: 'acpi': add device device:00
[    1.460043] PM: Adding info for acpi:device:00
[    1.464041] device: 'device:00': dev_uevent: bus uevent() returned -12
[    1.472236] device: 'PNP0C0E:00': device_add
[    1.476046] bus: 'acpi': add device PNP0C0E:00
[    1.480044] PM: Adding info for acpi:PNP0C0E:00
[    1.484139] device: 'PNP0A03:00': device_add
[    1.492040] bus: 'acpi': add device PNP0A03:00
[    1.496043] PM: Adding info for acpi:PNP0A03:00
[    1.500144] device: 'PNP0C02:00': device_add
[    1.504040] bus: 'acpi': add device PNP0C02:00
[    1.508043] PM: Adding info for acpi:PNP0C02:00
[    1.516239] device: 'device:01': device_add
[    1.520040] bus: 'acpi': add device device:01
[    1.524043] PM: Adding info for acpi:device:01
[    1.528042] device: 'device:01': dev_uevent: bus uevent() returned -12
[    1.536126] device: 'device:02': device_add
[    1.540039] bus: 'acpi': add device device:02
[    1.544044] PM: Adding info for acpi:device:02
[    1.548041] device: 'device:02': dev_uevent: bus uevent() returned -12
[    1.552322] device: 'PNP0C0F:00': device_add
[    1.560040] bus: 'acpi': add device PNP0C0F:00
[    1.564044] PM: Adding info for acpi:PNP0C0F:00
[    1.568343] device: 'PNP0C0F:01': device_add
[    1.572040] bus: 'acpi': add device PNP0C0F:01
[    1.576044] PM: Adding info for acpi:PNP0C0F:01
[    1.580325] device: 'PNP0C0F:02': device_add
[    1.584040] bus: 'acpi': add device PNP0C0F:02
[    1.592044] PM: Adding info for acpi:PNP0C0F:02
[    1.596322] device: 'PNP0C0F:03': device_add
[    1.600040] bus: 'acpi': add device PNP0C0F:03
[    1.604050] PM: Adding info for acpi:PNP0C0F:03
[    1.608363] device: 'PNP0C0F:04': device_add
[    1.612040] bus: 'acpi': add device PNP0C0F:04
[    1.616052] PM: Adding info for acpi:PNP0C0F:04
[    1.624355] device: 'PNP0C0F:05': device_add
[    1.628040] bus: 'acpi': add device PNP0C0F:05
[    1.632044] PM: Adding info for acpi:PNP0C0F:05
[    1.636365] device: 'PNP0C0F:06': device_add
[    1.640040] bus: 'acpi': add device PNP0C0F:06
[    1.644043] PM: Adding info for acpi:PNP0C0F:06
[    1.648358] device: 'PNP0C0F:07': device_add
[    1.656041] bus: 'acpi': add device PNP0C0F:07
[    1.660044] PM: Adding info for acpi:PNP0C0F:07
[    1.664158] device: 'PNP0200:00': device_add
[    1.668040] bus: 'acpi': add device PNP0200:00
[    1.672050] PM: Adding info for acpi:PNP0200:00
[    1.676151] device: 'PNP0B00:00': device_add
[    1.680040] bus: 'acpi': add device PNP0B00:00
[    1.688044] PM: Adding info for acpi:PNP0B00:00
[    1.692149] device: 'PNP0000:00': device_add
[    1.696040] bus: 'acpi': add device PNP0000:00
[    1.700044] PM: Adding info for acpi:PNP0000:00
[    1.704154] device: 'PNP0C04:00': device_add
[    1.708050] bus: 'acpi': add device PNP0C04:00
[    1.712044] PM: Adding info for acpi:PNP0C04:00
[    1.716146] device: 'PNP0100:00': device_add
[    1.724040] bus: 'acpi': add device PNP0100:00
[    1.728044] PM: Adding info for acpi:PNP0100:00
[    1.732144] device: 'PNP0800:00': device_add
[    1.736040] bus: 'acpi': add device PNP0800:00
[    1.740044] PM: Adding info for acpi:PNP0800:00
[    1.744150] device: 'PNP0C02:01': device_add
[    1.748040] bus: 'acpi': add device PNP0C02:01
[    1.752044] PM: Adding info for acpi:PNP0C02:01
[    1.760780] device: 'PNP0700:00': device_add
[    1.764041] bus: 'acpi': add device PNP0700:00
[    1.768044] PM: Adding info for acpi:PNP0700:00
[    1.772866] device: 'PNP0401:00': device_add
[    1.776049] bus: 'acpi': add device PNP0401:00
[    1.780050] PM: Adding info for acpi:PNP0401:00
[    1.788310] device: 'PNP0F03:00': device_add
[    1.792041] bus: 'acpi': add device PNP0F03:00
[    1.796044] PM: Adding info for acpi:PNP0F03:00
[    1.800307] device: 'PNP0303:00': device_add
[    1.804041] bus: 'acpi': add device PNP0303:00
[    1.808044] PM: Adding info for acpi:PNP0303:00
[    1.812687] device: 'PNP0501:00': device_add
[    1.820041] bus: 'acpi': add device PNP0501:00
[    1.824044] PM: Adding info for acpi:PNP0501:00
[    1.828405] device: 'device:03': device_add
[    1.832041] bus: 'acpi': add device device:03
[    1.836044] PM: Adding info for acpi:device:03
[    1.840042] device: 'device:03': dev_uevent: bus uevent() returned -12
[    1.848251] device: 'device:04': device_add
[    1.852040] bus: 'acpi': add device device:04
[    1.856044] PM: Adding info for acpi:device:04
[    1.860041] device: 'device:04': dev_uevent: bus uevent() returned -12
[    1.868255] device: 'device:05': device_add
[    1.872040] bus: 'acpi': add device device:05
[    1.876044] PM: Adding info for acpi:device:05
[    1.880041] device: 'device:05': dev_uevent: bus uevent() returned -12
[    1.888247] device: 'device:06': device_add
[    1.892040] bus: 'acpi': add device device:06
[    1.896044] PM: Adding info for acpi:device:06
[    1.900041] device: 'device:06': dev_uevent: bus uevent() returned -12
[    1.908244] device: 'device:07': device_add
[    1.912040] bus: 'acpi': add device device:07
[    1.916044] PM: Adding info for acpi:device:07
[    1.920041] device: 'device:07': dev_uevent: bus uevent() returned -12
[    1.928058] device: 'device:08': device_add
[    1.932050] bus: 'acpi': add device device:08
[    1.936044] PM: Adding info for acpi:device:08
[    1.940042] device: 'device:08': dev_uevent: bus uevent() returned -12
[    1.948141] device: 'PNP0003:00': device_add
[    1.952039] bus: 'acpi': add device PNP0003:00
[    1.956044] PM: Adding info for acpi:PNP0003:00
[    1.960495] device: 'device:09': device_add
[    1.964044] bus: 'acpi': add device device:09
[    1.968052] PM: Adding info for acpi:device:09
[    1.976042] device: 'device:09': dev_uevent: bus uevent() returned -12
[    1.980366] device: 'device:0a': device_add
[    1.984046] bus: 'acpi': add device device:0a
[    1.988053] PM: Adding info for acpi:device:0a
[    1.992042] device: 'device:0a': dev_uevent: bus uevent() returned -12
[    2.004411] device: 'device:0b': device_add
[    2.008040] bus: 'acpi': add device device:0b
[    2.012044] PM: Adding info for acpi:device:0b
[    2.016041] device: 'device:0b': dev_uevent: bus uevent() returned -12
[    2.024407] device: 'device:0c': device_add
[    2.028043] bus: 'acpi': add device device:0c
[    2.032044] PM: Adding info for acpi:device:0c
[    2.036042] device: 'device:0c': dev_uevent: bus uevent() returned -12
[    2.044417] device: 'device:0d': device_add
[    2.048040] bus: 'acpi': add device device:0d
[    2.056050] PM: Adding info for acpi:device:0d
[    2.060042] device: 'device:0d': dev_uevent: bus uevent() returned -12
[    2.064401] device: 'device:0e': device_add
[    2.068040] bus: 'acpi': add device device:0e
[    2.076044] PM: Adding info for acpi:device:0e
[    2.080041] device: 'device:0e': dev_uevent: bus uevent() returned -12
[    2.084397] device: 'device:0f': device_add
[    2.088040] bus: 'acpi': add device device:0f
[    2.096044] PM: Adding info for acpi:device:0f
[    2.100041] device: 'device:0f': dev_uevent: bus uevent() returned -12
[    2.104148] device: 'device:10': device_add
[    2.108040] bus: 'acpi': add device device:10
[    2.112051] PM: Adding info for acpi:device:10
[    2.120042] device: 'device:10': dev_uevent: bus uevent() returned -12
[    2.124188] device: 'device:11': device_add
[    2.128039] bus: 'acpi': add device device:11
[    2.132044] PM: Adding info for acpi:device:11
[    2.140042] device: 'device:11': dev_uevent: bus uevent() returned -12
[    2.144141] device: 'device:12': device_add
[    2.148039] bus: 'acpi': add device device:12
[    2.152044] PM: Adding info for acpi:device:12
[    2.156042] device: 'device:12': dev_uevent: bus uevent() returned -12
[    2.164139] device: 'device:13': device_add
[    2.168039] bus: 'acpi': add device device:13
[    2.172044] PM: Adding info for acpi:device:13
[    2.176042] device: 'device:13': dev_uevent: bus uevent() returned -12
[    2.184154] device: 'device:14': device_add
[    2.188040] bus: 'acpi': add device device:14
[    2.192044] PM: Adding info for acpi:device:14
[    2.196042] device: 'device:14': dev_uevent: bus uevent() returned -12
[    2.204141] device: 'device:15': device_add
[    2.208048] bus: 'acpi': add device device:15
[    2.212045] PM: Adding info for acpi:device:15
[    2.216042] device: 'device:15': dev_uevent: bus uevent() returned -12
[    2.224137] device: 'device:16': device_add
[    2.228039] bus: 'acpi': add device device:16
[    2.232044] PM: Adding info for acpi:device:16
[    2.236042] device: 'device:16': dev_uevent: bus uevent() returned -12
[    2.244134] device: 'device:17': device_add
[    2.248045] bus: 'acpi': add device device:17
[    2.252045] PM: Adding info for acpi:device:17
[    2.256042] device: 'device:17': dev_uevent: bus uevent() returned -12
[    2.264133] device: 'device:18': device_add
[    2.268039] bus: 'acpi': add device device:18
[    2.272044] PM: Adding info for acpi:device:18
[    2.276042] device: 'device:18': dev_uevent: bus uevent() returned -12
[    2.284129] device: 'device:19': device_add
[    2.288039] bus: 'acpi': add device device:19
[    2.292044] PM: Adding info for acpi:device:19
[    2.296042] device: 'device:19': dev_uevent: bus uevent() returned -12
[    2.304129] device: 'device:1a': device_add
[    2.308039] bus: 'acpi': add device device:1a
[    2.312051] PM: Adding info for acpi:device:1a
[    2.316042] device: 'device:1a': dev_uevent: bus uevent() returned -12
[    2.320080] device: 'LNXTHERM:00': device_add
[    2.328039] bus: 'acpi': add device LNXTHERM:00
[    2.332044] PM: Adding info for acpi:LNXTHERM:00
[    2.336090] initcall acpi_scan_init+0x0/0x110 returned 0 after 923 msecs
[    2.342585] calling  acpi_ec_init+0x0/0x61
[    2.348039] bus: 'acpi': add driver ec
[    2.352156] initcall acpi_ec_init+0x0/0x61 returned 0 after 3 msecs
[    2.356033] calling  acpi_pci_root_init+0x0/0x28
[    2.360033] bus: 'acpi': add driver pci_root
[    2.364046] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    2.376033] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    2.384052] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    2.388086] device: 'pci0000:00': device_add
[    2.392058] PM: Adding info for No Bus:pci0000:00
[    2.396034] device: '0000:00': device_add
[    2.400051] PM: Adding info for No Bus:0000:00
[    2.404088] PCI: Scanning bus 0000:00
[    2.408054] pci 0000:00:00.0: found [8086/277c] class 000600 header type 00
[    2.416060] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.424056] pci 0000:00:01.0: found [8086/277d] class 000604 header type 01
[    2.428050] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.436038] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.444034] pci 0000:00:01.0: PME# disabled
[    2.448083] pci 0000:00:1b.0: found [8086/27d8] class 000403 header type 00
[    2.452044] PCI: 0000:00:1b.0 reg 10 64bit mmio: [50400000, 50403fff]
[    2.460066] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.467454] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.472035] pci 0000:00:1b.0: PME# disabled
[    2.476048] pci 0000:00:1c.0: found [8086/27d0] class 000604 header type 01
[    2.484063] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.492044] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.496035] pci 0000:00:1c.0: PME# disabled
[    2.500053] pci 0000:00:1c.4: found [8086/27e0] class 000604 header type 01
[    2.508059] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.520043] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.524035] pci 0000:00:1c.4: PME# disabled
[    2.528048] pci 0000:00:1c.5: found [8086/27e2] class 000604 header type 01
[    2.536059] pci 0000:00:1c.5: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.544044] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    2.548035] pci 0000:00:1c.5: PME# disabled
[    2.552046] pci 0000:00:1d.0: found [8086/27c8] class 000c03 header type 00
[    2.560059] PCI: 0000:00:1d.0 reg 20 io port: [4080, 409f]
[    2.564046] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.572045] pci 0000:00:1d.1: found [8086/27c9] class 000c03 header type 00
[    2.580059] PCI: 0000:00:1d.1 reg 20 io port: [4060, 407f]
[    2.584046] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.592045] pci 0000:00:1d.2: found [8086/27ca] class 000c03 header type 00
[    2.600059] PCI: 0000:00:1d.2 reg 20 io port: [4040, 405f]
[    2.604046] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.611462] pci 0000:00:1d.3: found [8086/27cb] class 000c03 header type 00
[    2.620059] PCI: 0000:00:1d.3 reg 20 io port: [4020, 403f]
[    2.624046] pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.632067] pci 0000:00:1d.7: found [8086/27cc] class 000c03 header type 00
[    2.636041] PCI: 0000:00:1d.7 reg 10 32bit mmio: [50404400, 504047ff]
[    2.644074] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.651455] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.656036] pci 0000:00:1d.7: PME# disabled
[    2.660052] pci 0000:00:1e.0: found [8086/244e] class 000604 header type 01
[    2.668052] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.676063] pci 0000:00:1f.0: found [8086/27b0] class 000601 header type 00
[    2.684085] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.688049] pci 0000:00:1f.1: found [8086/27df] class 000101 header type 00
[    2.696041] PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
[    2.700038] PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
[    2.708038] PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
[    2.712038] PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
[    2.716038] PCI: 0000:00:1f.1 reg 20 io port: [40b0, 40bf]
[    2.724048] pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.728068] pci 0000:00:1f.2: found [8086/27c0] class 000101 header type 00
[    2.736040] PCI: 0000:00:1f.2 reg 10 io port: [40c8, 40cf]
[    2.740040] PCI: 0000:00:1f.2 reg 14 io port: [40e4, 40e7]
[    2.748037] PCI: 0000:00:1f.2 reg 18 io port: [40c0, 40c7]
[    2.752037] PCI: 0000:00:1f.2 reg 1c io port: [40e0, 40e3]
[    2.760037] PCI: 0000:00:1f.2 reg 20 io port: [40a0, 40af]
[    2.764037] PCI: 0000:00:1f.2 reg 24 32bit mmio: [50404000, 504043ff]
[    2.772045] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.776037] pci 0000:00:1f.2: PME# supported from D3hot
[    2.784035] pci 0000:00:1f.2: PME# disabled
[    2.788046] pci 0000:00:1f.3: found [8086/27da] class 000c05 header type 00
[    2.792065] PCI: 0000:00:1f.3 reg 20 io port: [4000, 401f]
[    2.800050] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2f
[    2.808039] PCI: Fixups for bus 0000:00
[    2.808039] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    2.816039] PCI: Scanning bus 0000:01
[    2.820051] pci 0000:01:00.0: found [1002/7249] class 000300 header type 00
[    2.828033] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x20
[    2.832039] PCI: 0000:01:00.0 reg 10 32bit mmio: [40000000, 4fffffff]
[    2.840045] PCI: 0000:01:00.0 reg 18 64bit mmio: [50300000, 5030ffff]
[    2.848037] PCI: 0000:01:00.0 reg 20 io port: [3000, 30ff]
[    2.852041] PCI: 0000:01:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
[    2.860047] pci 0000:01:00.0: supports D1
[    2.864033] pci 0000:01:00.0: supports D2
[    2.868051] pci 0000:01:00.1: found [1002/7269] class 000380 header type 00
[    2.872033] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x20
[    2.878333] PCI: 0000:01:00.1 reg 10 64bit mmio: [50310000, 5031ffff]
[    2.884065] pci 0000:01:00.1: supports D1
[    2.888033] pci 0000:01:00.1: supports D2
[    2.892046] Pre-1.1 PCIe device detected, disable ASPM for 0000:00:01.0. It can be enabled forcedly with 'pcie_aspm=force'
[    2.904065] PCI: Fixups for bus 0000:01
[    2.908034] PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
[    2.916034] PCI: bridge 0000:00:01.0 32bit mmio: [50300000, 503fffff]
[    2.920036] PCI: bridge 0000:00:01.0 64bit mmio pref: [40000000, 4fffffff]
[    2.928033] PCI: Bus scan for 0000:01 returning with max=01
[    2.932035] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    2.940040] PCI: Scanning bus 0000:02
[    2.944061] pci 0000:02:00.0: found [1131/7162] class 000480 header type 00
[    2.952050] PCI: 0000:02:00.0 reg 10 64bit mmio: [50200000, 502fffff]
[    2.956100] pci 0000:02:00.0: supports D1
[    2.960033] pci 0000:02:00.0: supports D2
[    2.964033] pci 0000:02:00.0: PME# supported from D0 D1 D2
[    2.972036] pci 0000:02:00.0: PME# disabled
[    2.976044] Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.0. It can be enabled forcedly with 'pcie_aspm=force'
[    2.988065] PCI: Fixups for bus 0000:02
[    2.992037] PCI: bridge 0000:00:1c.0 32bit mmio: [50200000, 502fffff]
[    2.996040] PCI: Bus scan for 0000:02 returning with max=02
[    3.004035] pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 0
[    3.008040] PCI: Scanning bus 0000:03
[    3.012066] PCI: Fixups for bus 0000:03
[    3.016042] PCI: Bus scan for 0000:03 returning with max=03
[    3.024035] pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 0
[    3.036040] PCI: Scanning bus 0000:04
[    3.036081] pci 0000:04:00.0: found [8086/109a] class 000200 header type 00
[    3.044048] PCI: 0000:04:00.0 reg 10 32bit mmio: [50100000, 5011ffff]
[    3.052055] PCI: 0000:04:00.0 reg 18 io port: [2000, 201f]
[    3.056097] pci 0000:04:00.0: calling pci_fixup_transparent_bridge+0x0/0x2f
[    3.064043] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    3.072038] pci 0000:04:00.0: PME# disabled
[    3.076053] Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.5. It can be enabled forcedly with 'pcie_aspm=force'
[    3.084065] PCI: Fixups for bus 0000:04
[    3.088035] PCI: bridge 0000:00:1c.5 io port: [2000, 2fff]
[    3.096035] PCI: bridge 0000:00:1c.5 32bit mmio: [50100000, 501fffff]
[    3.100037] PCI: Bus scan for 0000:04 returning with max=04
[    3.108035] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
[    3.112040] PCI: Scanning bus 0000:05
[    3.116059] pci 0000:05:02.0: found [1814/0301] class 000280 header type 00
[    3.124041] PCI: 0000:05:02.0 reg 10 32bit mmio: [50000000, 50007fff]
[    3.132105] pci 0000:05:04.0: found [104c/8024] class 000c00 header type 00
[    3.136042] PCI: 0000:05:04.0 reg 10 32bit mmio: [5000c000, 5000c7ff]
[    3.144038] PCI: 0000:05:04.0 reg 14 32bit mmio: [50008000, 5000bfff]
[    3.152075] pci 0000:05:04.0: supports D1
[    3.156033] pci 0000:05:04.0: supports D2
[    3.160033] pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
[    3.164036] pci 0000:05:04.0: PME# disabled
[    3.168057] pci 0000:05:05.0: found [1095/3114] class 000104 header type 00
[    3.176041] PCI: 0000:05:05.0 reg 10 io port: [1018, 101f]
[    3.180038] PCI: 0000:05:05.0 reg 14 io port: [1024, 1027]
[    3.188038] PCI: 0000:05:05.0 reg 18 io port: [1010, 1017]
[    3.192038] PCI: 0000:05:05.0 reg 1c io port: [1020, 1023]
[    3.200038] PCI: 0000:05:05.0 reg 20 io port: [1000, 100f]
[    3.204038] PCI: 0000:05:05.0 reg 24 32bit mmio: [5000c800, 5000cbff]
[    3.212038] PCI: 0000:05:05.0 reg 30 32bit mmio: [fff80000, ffffffff]
[    3.216047] pci 0000:05:05.0: supports D1
[    3.220033] pci 0000:05:05.0: supports D2
[    3.224068] PCI: Fixups for bus 0000:05
[    3.228033] pci 0000:00:1e.0: transparent bridge
[    3.232035] PCI: bridge 0000:00:1e.0 io port: [1000, 1fff]
[    3.240035] PCI: bridge 0000:00:1e.0 32bit mmio: [50000000, 500fffff]
[    3.244037] PCI: Bus scan for 0000:05 returning with max=05
[    3.252038] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    3.256036] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    3.264037] pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 1
[    3.272037] pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 1
[    3.280037] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
[    3.284036] PCI: Bus scan for 0000:00 returning with max=05
[    3.292043] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.300657] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    3.308440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    3.316743] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    3.320725] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    3.328785] device: '0000:00:00.0': device_add
[    3.332803] bus: 'pci': add device 0000:00:00.0
[    3.340072] PM: Adding info for pci:0000:00:00.0
[    3.344093] device: '0000:00:01.0': device_add
[    3.348789] bus: 'pci': add device 0000:00:01.0
[    3.352074] PM: Adding info for pci:0000:00:01.0
[    3.360056] device: '0000:00:1b.0': device_add
[    3.364264] bus: 'pci': add device 0000:00:1b.0
[    3.368065] PM: Adding info for pci:0000:00:1b.0
[    3.372092] device: '0000:00:1c.0': device_add
[    3.377052] bus: 'pci': add device 0000:00:1c.0
[    3.384066] PM: Adding info for pci:0000:00:1c.0
[    3.388092] device: '0000:00:1c.4': device_add
[    3.393036] bus: 'pci': add device 0000:00:1c.4
[    3.396072] PM: Adding info for pci:0000:00:1c.4
[    3.404092] device: '0000:00:1c.5': device_add
[    3.408578] bus: 'pci': add device 0000:00:1c.5
[    3.412072] PM: Adding info for pci:0000:00:1c.5
[    3.416092] device: '0000:00:1d.0': device_add
[    3.421015] bus: 'pci': add device 0000:00:1d.0
[    3.428073] PM: Adding info for pci:0000:00:1d.0
[    3.432092] device: '0000:00:1d.1': device_add
[    3.437005] bus: 'pci': add device 0000:00:1d.1
[    3.440072] PM: Adding info for pci:0000:00:1d.1
[    3.448092] device: '0000:00:1d.2': device_add
[    3.452811] bus: 'pci': add device 0000:00:1d.2
[    3.456072] PM: Adding info for pci:0000:00:1d.2
[    3.460092] device: '0000:00:1d.3': device_add
[    3.464984] bus: 'pci': add device 0000:00:1d.3
[    3.472080] PM: Adding info for pci:0000:00:1d.3
[    3.476092] device: '0000:00:1d.7': device_add
[    3.480973] bus: 'pci': add device 0000:00:1d.7
[    3.488066] PM: Adding info for pci:0000:00:1d.7
[    3.492091] device: '0000:00:1e.0': device_add
[    3.496952] bus: 'pci': add device 0000:00:1e.0
[    3.500067] PM: Adding info for pci:0000:00:1e.0
[    3.504092] device: '0000:00:1f.0': device_add
[    3.512956] bus: 'pci': add device 0000:00:1f.0
[    3.516072] PM: Adding info for pci:0000:00:1f.0
[    3.520092] device: '0000:00:1f.1': device_add
[    3.524941] bus: 'pci': add device 0000:00:1f.1
[    3.532072] PM: Adding info for pci:0000:00:1f.1
[    3.536092] device: '0000:00:1f.2': device_add
[    3.540944] bus: 'pci': add device 0000:00:1f.2
[    3.548088] PM: Adding info for pci:0000:00:1f.2
[    3.552091] device: '0000:00:1f.3': device_add
[    3.556911] bus: 'pci': add device 0000:00:1f.3
[    3.560076] PM: Adding info for pci:0000:00:1f.3
[    3.568091] device: '0000:01:00.0': device_add
[    3.572040] bus: 'pci': add device 0000:01:00.0
[    3.576071] PM: Adding info for pci:0000:01:00.0
[    3.580091] device: '0000:01:00.1': device_add
[    3.584040] bus: 'pci': add device 0000:01:00.1
[    3.588065] PM: Adding info for pci:0000:01:00.1
[    3.596091] device: '0000:01': device_add
[    3.600058] PM: Adding info for No Bus:0000:01
[    3.604090] device: '0000:02:00.0': device_add
[    3.608049] bus: 'pci': add device 0000:02:00.0
[    3.612071] PM: Adding info for pci:0000:02:00.0
[    3.616091] device: '0000:02': device_add
[    3.620053] PM: Adding info for No Bus:0000:02
[    3.624090] device: '0000:03': device_add
[    3.628053] PM: Adding info for No Bus:0000:03
[    3.632090] device: '0000:04:00.0': device_add
[    3.640042] bus: 'pci': add device 0000:04:00.0
[    3.644071] PM: Adding info for pci:0000:04:00.0
[    3.648091] device: '0000:04': device_add
[    3.652062] PM: Adding info for No Bus:0000:04
[    3.656090] device: '0000:05:02.0': device_add
[    3.660041] bus: 'pci': add device 0000:05:02.0
[    3.664072] PM: Adding info for pci:0000:05:02.0
[    3.668091] device: '0000:05:04.0': device_add
[    3.676042] bus: 'pci': add device 0000:05:04.0
[    3.680072] PM: Adding info for pci:0000:05:04.0
[    3.684091] device: '0000:05:05.0': device_add
[    3.688042] bus: 'pci': add device 0000:05:05.0
[    3.692071] PM: Adding info for pci:0000:05:05.0
[    3.696091] device: '0000:05': device_add
[    3.700052] PM: Adding info for No Bus:0000:05
[    3.704090] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    3.712034] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    3.720147] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 1296 msecs
[    3.728033] calling  acpi_pci_link_init+0x0/0x48
[    3.732034] bus: 'acpi': add driver pci_link
[    3.736051] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    3.744033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    3.752328] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    3.760746] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    3.768037] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    3.776034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    3.784033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    3.792308] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    3.798453] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    3.804034] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    3.812034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    3.820033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    3.828307] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
[    3.836450] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    3.844034] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    3.852034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    3.860033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    3.868308] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
[    3.874452] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    3.880034] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    3.888034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    3.896033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    3.904314] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    3.913616] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    3.920034] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    3.928034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    3.936033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    3.948306] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    3.955238] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    3.960034] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    3.968034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    3.976033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    3.984306] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    3.993039] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    4.000034] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    4.008034] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    4.016033] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    4.024178] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    4.030455] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    4.036034] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    4.044133] initcall acpi_pci_link_init+0x0/0x48 returned 0 after 297 msecs
[    4.054585] calling  acpi_power_init+0x0/0x77
[    4.060038] bus: 'acpi': add driver power
[    4.064156] initcall acpi_power_init+0x0/0x77 returned 0 after 3 msecs
[    4.068033] calling  acpi_system_init+0x0/0x25f
[    4.072190] initcall acpi_system_init+0x0/0x25f returned 0 after 3 msecs
[    4.080033] calling  acpi_debug_init+0x0/0xa5
[    4.084050] initcall acpi_debug_init+0x0/0xa5 returned 0 after 0 msecs
[    4.092033] calling  acpi_wmi_init+0x0/0x4f
[    4.096034] bus: 'acpi': add driver wmi
[    4.100156] ACPI: WMI: Mapper loaded
[    4.104035] initcall acpi_wmi_init+0x0/0x4f returned 0 after 7 msecs
[    4.110409] calling  acpi_cm_sbs_init+0x0/0x8
[    4.116033] initcall acpi_cm_sbs_init+0x0/0x8 returned 0 after 0 msecs
[    4.120032] calling  pnp_init+0x0/0x20
[    4.124033] Linux Plug and Play Support v0.97 (c) Adam Belay
[    4.132091] bus: 'pnp': registered
[    4.132091] initcall pnp_init+0x0/0x20 returned 0 after 7 msecs
[    4.140033] calling  pnpacpi_init+0x0/0x8c
[    4.144033] pnp: PnP ACPI init
[    4.147106] device: 'pnp0': device_add
[    4.152043] PM: Adding info for No Bus:pnp0
[    4.156034] ACPI: bus type pnp registered
[    4.160071] pnp 00:00: parse allocated resources
[    4.170505] pnp 00:00:   add io  0xcf8-0xcff flags 0x1
[    4.176037] device: '00:00': device_add
[    4.180070] bus: 'pnp': add device 00:00
[    4.184044] PM: Adding info for pnp:00:00
[    4.188089] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    4.193783] pnp 00:01: parse allocated resources
[    4.200051] pnp 00:01:   add mem 0xf0000000-0xf3ffffff flags 0x0
[    4.204034] pnp 00:01:   add mem 0xfed13000-0xfed13fff flags 0x0
[    4.212034] pnp 00:01:   add mem 0xfed14000-0xfed17fff flags 0x0
[    4.216034] pnp 00:01:   add mem 0xfed18000-0xfed18fff flags 0x0
[    4.224034] pnp 00:01:   add mem 0xfed19000-0xfed19fff flags 0x0
[    4.228034] pnp 00:01:   add mem 0xfed1c000-0xfed1ffff flags 0x0
[    4.236034] pnp 00:01:   add mem 0xfed20000-0xfed3ffff flags 0x0
[    4.240034] pnp 00:01:   add mem 0xfed45000-0xfed99fff flags 0x0
[    4.248034] pnp 00:01:   add mem 0xc0000-0xdffff flags 0x0
[    4.252034] pnp 00:01:   add mem 0xe0000-0xfffff flags 0x0
[    4.256036] pnp 00:01: PNP0c02: calling quirk_system_pci_resources+0x0/0x17c
[    4.264113] device: '00:01': device_add
[    4.268059] bus: 'pnp': add device 00:01
[    4.272044] PM: Adding info for pnp:00:01
[    4.276088] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.284640] pnp 00:02: parse allocated resources
[    4.288044] pnp 00:02:   add io  0x0-0xf flags 0x1
[    4.292034] pnp 00:02:   add io  0x81-0x83 flags 0x1
[    4.300034] pnp 00:02:   add io  0x87-0x87 flags 0x1
[    4.304034] pnp 00:02:   add io  0x89-0x8b flags 0x1
[    4.308034] pnp 00:02:   add io  0x8f-0x8f flags 0x1
[    4.312034] pnp 00:02:   add io  0xc0-0xdf flags 0x1
[    4.320034] pnp 00:02:   add dma 4 flags 0x0
[    4.324035] device: '00:02': device_add
[    4.328060] bus: 'pnp': add device 00:02
[    4.332059] PM: Adding info for pnp:00:02
[    4.336088] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.341776] pnp 00:03: parse allocated resources
[    4.344044] pnp 00:03:   add io  0x70-0x71 flags 0x1
[    4.352034] pnp 00:03:   add io  0x74-0x77 flags 0x1
[    4.356037] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    4.364037] pnp 00:03:   add irq 8 flags 0x1
[    4.368036] device: '00:03': device_add
[    4.371920] bus: 'pnp': add device 00:03
[    4.376044] PM: Adding info for pnp:00:03
[    4.380088] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.385784] pnp 00:04: parse allocated resources
[    4.392044] pnp 00:04:   add io  0xf0-0xf0 flags 0x1
[    4.396035] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    4.404036] pnp 00:04:   add irq 13 flags 0x1
[    4.408036] device: '00:04': device_add
[    4.412062] bus: 'pnp': add device 00:04
[    4.416008] PM: Adding info for pnp:00:04
[    4.420088] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.425784] pnp 00:05: parse allocated resources
[    4.432043] pnp 00:05:   add io  0x61-0x61 flags 0x1
[    4.436036] device: '00:05': device_add
[    4.440064] bus: 'pnp': add device 00:05
[    4.444050] PM: Adding info for pnp:00:05
[    4.448088] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.453774] pnp 00:06: parse allocated resources
[    4.460046] pnp 00:06:   add io  0x500-0x53f flags 0x1
[    4.464040] pnp 00:06:   add io  0x400-0x47f flags 0x1
[    4.468034] pnp 00:06:   add io  0x92-0x92 flags 0x1
[    4.476034] pnp 00:06:   add io  0x680-0x6ff flags 0x1
[    4.480034] pnp 00:06:   add io  0x10-0x1f flags 0x1
[    4.484034] pnp 00:06:   add io  0x72-0x73 flags 0x1
[    4.488034] pnp 00:06:   add io  0x80-0x80 flags 0x1
[    4.496034] pnp 00:06:   add io  0x84-0x86 flags 0x1
[    4.500035] pnp 00:06:   add io  0x88-0x88 flags 0x1
[    4.504034] pnp 00:06:   add io  0x8c-0x8e flags 0x1
[    4.508034] pnp 00:06:   add io  0x90-0x9f flags 0x1
[    4.516035] pnp 00:06: PNP0c02: calling quirk_system_pci_resources+0x0/0x17c
[    4.520112] device: '00:06': device_add
[    4.524065] bus: 'pnp': add device 00:06
[    4.528044] PM: Adding info for pnp:00:06
[    4.532088] pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.540401] pnp 00:07: parse allocated resources
[    4.544889] pnp 00:07:   add io  0x3f0-0x3f5 flags 0x1
[    4.552034] pnp 00:07:   add io  0x3f0-0x3f0 flags 0x1
[    4.556035] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    4.564036] pnp 00:07:   add irq 6 flags 0x1
[    4.572034] pnp 00:07:   add dma 2 flags 0x0
[    4.576034] pnp 00:07: parse resource options
[    4.580128] pnp 00:07:   dependent set 0 (preferred) io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
[    4.588035] pnp 00:07:   dependent set 0 (preferred) io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
[    4.596035] pnp 00:07:   dependent set 0 (preferred) irq 6 flags 0x1
[    4.604034] pnp 00:07:   dependent set 0 (preferred) dma 2 (bitmask 0x4) flags 0x0
[    4.612035] device: '00:07': device_add
[    4.616066] bus: 'pnp': add device 00:07
[    4.620050] PM: Adding info for pnp:00:07
[    4.624088] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.630200] pnp 00:08: parse allocated resources
[    4.636538] pnp 00:08:   add io  0x378-0x37f flags 0x1
[    4.640034] pnp 00:08:   add io  0x778-0x77f flags 0x1
[    4.648035] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    4.652036] pnp 00:08:   add irq 7 flags 0x1
[    4.656034] pnp 00:08:   add dma 0 flags 0x10000000
[    4.664034] pnp 00:08: parse resource options
[    4.668134] pnp 00:08:   dependent set 0 (preferred) io  min 0x378 max 0x378 align 1 size 8 flags 0x1
[    4.676035] pnp 00:08:   dependent set 0 (preferred) io  min 0x778 max 0x778 align 1 size 8 flags 0x1
[    4.684041] pnp 00:08:   dependent set 0 (preferred) irq 5 7 flags 0x1
[    4.692035] pnp 00:08:   dependent set 0 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
[    4.700034] pnp 00:08:   dependent set 1 (preferred) io  min 0x278 max 0x278 align 1 size 8 flags 0x1
[    4.708034] pnp 00:08:   dependent set 1 (preferred) io  min 0x678 max 0x678 align 1 size 8 flags 0x1
[    4.720035] pnp 00:08:   dependent set 1 (preferred) irq 5 7 flags 0x1
[    4.724034] pnp 00:08:   dependent set 1 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
[    4.732034] pnp 00:08:   dependent set 2 (preferred) io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1
[    4.740034] pnp 00:08:   dependent set 2 (preferred) io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1
[    4.752035] pnp 00:08:   dependent set 2 (preferred) irq 5 7 flags 0x1
[    4.756034] pnp 00:08:   dependent set 2 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
[    4.764036] device: '00:08': device_add
[    4.768067] bus: 'pnp': add device 00:08
[    4.772044] PM: Adding info for pnp:00:08
[    4.776089] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (active)
[    4.784127] pnp 00:09: parse allocated resources
[    4.788122] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    4.796040] pnp 00:09:   add irq 12 flags 0x1
[    4.800037] device: '00:09': device_add
[    4.804067] bus: 'pnp': add device 00:09
[    4.808050] PM: Adding info for pnp:00:09
[    4.812088] pnp 00:09: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    4.824127] pnp 00:0a: parse allocated resources
[    4.828043] pnp 00:0a:   add io  0x60-0x60 flags 0x1
[    4.832034] pnp 00:0a:   add io  0x64-0x64 flags 0x1
[    4.836034] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    4.844036] pnp 00:0a:   add irq 1 flags 0x1
[    4.848037] device: '00:0a': device_add
[    4.852067] bus: 'pnp': add device 00:0a
[    4.856044] PM: Adding info for pnp:00:0a
[    4.860088] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    4.868194] pnp 00:0b: parse allocated resources
[    4.872544] pnp 00:0b:   add io  0x3f8-0x3ff flags 0x1
[    4.880035] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    4.884036] pnp 00:0b:   add irq 4 flags 0x1
[    4.892034] pnp 00:0b: parse resource options
[    4.896132] pnp 00:0b:   dependent set 0 (preferred) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    4.904036] pnp 00:0b:   dependent set 0 (preferred) irq 4 flags 0x1
[    4.912034] pnp 00:0b:   dependent set 1 (preferred) io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    4.920035] pnp 00:0b:   dependent set 1 (preferred) irq 4 flags 0x1
[    4.924034] pnp 00:0b:   dependent set 2 (preferred) io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    4.936035] pnp 00:0b:   dependent set 2 (preferred) irq 3 flags 0x1
[    4.940034] pnp 00:0b:   dependent set 3 (preferred) io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    4.952035] pnp 00:0b:   dependent set 3 (preferred) irq 3 flags 0x1
[    4.956040] pnp 00:0b:   dependent set 4 (functional) io  min 0x100 max 0x3f8 align 8 size 8 flags 0x1
[    4.968036] pnp 00:0b:   dependent set 4 (functional) irq 1 3 4 5 6 7 8 10 11 12 13 14 15 flags 0x1
[    4.976036] device: '00:0b': device_add
[    4.979922] bus: 'pnp': add device 00:0b
[    4.984044] PM: Adding info for pnp:00:0b
[    4.988087] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.993899] pnp 00:0c: parse allocated resources
[    5.000042] pnp 00:0c:   add mem 0xfec00000-0xfec000ff flags 0x0
[    5.004036] device: '00:0c': device_add
[    5.008070] bus: 'pnp': add device 00:0c
[    5.012044] PM: Adding info for pnp:00:0c
[    5.016088] pnp 00:0c: Plug and Play ACPI device, IDs PNP0003 (active)
[    5.024311] pnp: PnP ACPI: found 13 devices
[    5.028034] ACPI: ACPI bus type pnp unregistered
[    5.032034] initcall pnpacpi_init+0x0/0x8c returned 0 after 846 msecs
[    5.038583] calling  setup_shutdown_event+0x0/0x14
[    5.044034] initcall setup_shutdown_event+0x0/0x14 returned 0 after 0 msecs
[    5.050409] calling  balloon_init+0x0/0x1c2
[    5.056037] initcall balloon_init+0x0/0x1c2 returned -19 after 0 msecs
[    5.060033] calling  misc_init+0x0/0xa0
[    5.064041] device class 'misc': registering
[    5.068093] initcall misc_init+0x0/0xa0 returned 0 after 3 msecs
[    5.078412] calling  cn_init+0x0/0xf3
[    5.080076] initcall cn_init+0x0/0xf3 returned 0 after 0 msecs
[    5.088033] calling  tifm_init+0x0/0x83
[    5.092098] bus: 'tifm': registered
[    5.095558] device class 'tifm_adapter': registering
[    5.100092] initcall tifm_init+0x0/0x83 returned 0 after 7 msecs
[    5.106415] calling  phy_init+0x0/0x31
[    5.112100] bus: 'mdio_bus': registered
[    5.116034] bus: 'mdio_bus': add driver Generic PHY
[    5.120097] initcall phy_init+0x0/0x31 returned 0 after 7 msecs
[    5.124033] calling  init_dvbdev+0x0/0xc3
[    5.128036] device class 'dvb': registering
[    5.132091] initcall init_dvbdev+0x0/0xc3 returned 0 after 3 msecs
[    5.140033] calling  init_scsi+0x0/0x8c
[    5.144300] device class 'scsi_host': registering
[    5.148101] bus: 'scsi': registered
[    5.152034] device class 'scsi_device': registering
[    5.156090] SCSI subsystem initialized
[    5.160034] initcall init_scsi+0x0/0x8c returned 0 after 15 msecs
[    5.166495] calling  ata_init+0x0/0x367
[    5.172075] libata version 3.00 loaded.
[    5.176034] initcall ata_init+0x0/0x367 returned 0 after 3 msecs
[    5.180033] calling  spi_init+0x0/0x83
[    5.184091] bus: 'spi': registered
[    5.188033] device class 'spi_master': registering
[    5.192090] initcall spi_init+0x0/0x83 returned 0 after 7 msecs
[    5.198411] calling  usb_init+0x0/0x113
[    5.204092] bus: 'usb': registered
[    5.208035] device class 'usb_host': registering
[    5.212090] bus: 'usb': add driver usbfs
[    5.216054] usbcore: registered new interface driver usbfs
[    5.220039] bus: 'usb': add driver hub
[    5.224095] usbcore: registered new interface driver hub
[    5.232068] bus: 'usb': add driver usb
[    5.232093] usbcore: registered new device driver usb
[    5.240034] initcall usb_init+0x0/0x113 returned 0 after 34 msecs
[    5.244033] calling  serio_init+0x0/0x98
[    5.248090] bus: 'serio': registered
[    5.252075] initcall serio_init+0x0/0x98 returned 0 after 3 msecs
[    5.258410] calling  gameport_init+0x0/0x99
[    5.264091] bus: 'gameport': registered
[    5.268068] initcall gameport_init+0x0/0x99 returned 0 after 3 msecs
[    5.272033] calling  input_init+0x0/0x108
[    5.276033] device class 'input': registering
[    5.284099] initcall input_init+0x0/0x108 returned 0 after 7 msecs
[    5.288033] calling  rtc_init+0x0/0x65
[    5.292034] device class 'rtc': registering
[    5.296090] initcall rtc_init+0x0/0x65 returned 0 after 3 msecs
[    5.302411] calling  i2c_init+0x0/0x67
[    5.308100] bus: 'i2c': registered
[    5.308100] device class 'i2c-adapter': registering
[    5.316092] bus: 'i2c': add driver dummy
[    5.320097] i2c-core: driver [dummy] registered
[    5.324038] initcall i2c_init+0x0/0x67 returned 0 after 15 msecs
[    5.328033] calling  hwmon_init+0x0/0x42
[    5.332034] device class 'hwmon': registering
[    5.336091] initcall hwmon_init+0x0/0x42 returned 0 after 3 msecs
[    5.344033] calling  thermal_init+0x0/0x58
[    5.348033] device class 'thermal': registering
[    5.352091] initcall thermal_init+0x0/0x58 returned 0 after 3 msecs
[    5.358412] calling  mmc_init+0x0/0x74
[    5.364091] bus: 'mmc': registered
[    5.368034] device class 'mmc_host': registering
[    5.372097] bus: 'sdio': registered
[    5.376034] initcall mmc_init+0x0/0x74 returned 0 after 11 msecs
[    5.380033] calling  leds_init+0x0/0x31
[    5.384034] device class 'leds': registering
[    5.388090] initcall leds_init+0x0/0x31 returned 0 after 3 msecs
[    5.394411] calling  dma_bus_init+0x0/0x33
[    5.400033] device class 'dma': registering
[    5.404090] initcall dma_bus_init+0x0/0x33 returned 0 after 3 msecs
[    5.408033] calling  ac97_bus_init+0x0/0x12
[    5.412091] bus: 'ac97': registered
[    5.416034] initcall ac97_bus_init+0x0/0x12 returned 0 after 3 msecs
[    5.424034] calling  pci_subsys_init+0x0/0x131
[    5.428033] PCI: Using ACPI for IRQ routing
[    5.432242] initcall pci_subsys_init+0x0/0x131 returned 0 after 3 msecs
[    5.440034] calling  proto_init+0x0/0x2e
[    5.444039] initcall proto_init+0x0/0x2e returned 0 after 0 msecs
[    5.448034] calling  net_dev_init+0x0/0x1f1
[    5.452051] device class 'net': registering
[    5.460074] initcall net_dev_init+0x0/0x1f1 returned 0 after 7 msecs
[    5.464033] calling  neigh_init+0x0/0x71
[    5.468034] initcall neigh_init+0x0/0x71 returned 0 after 0 msecs
[    5.474410] calling  fib_rules_init+0x0/0xa6
[    5.480035] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 msecs
[    5.484033] calling  pktsched_init+0x0/0xc4
[    5.488042] initcall pktsched_init+0x0/0xc4 returned 0 after 0 msecs
[    5.496033] calling  tc_filter_init+0x0/0x4c
[    5.500035] initcall tc_filter_init+0x0/0x4c returned 0 after 0 msecs
[    5.506410] calling  genl_init+0x0/0xd8
[    5.524074] initcall genl_init+0x0/0xd8 returned 0 after 11 msecs
[    5.528034] calling  cipso_v4_init+0x0/0x88
[    5.532042] initcall cipso_v4_init+0x0/0x88 returned 0 after 0 msecs
[    5.540033] calling  wanrouter_init+0x0/0x55
[    5.544033] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    5.552046] initcall wanrouter_init+0x0/0x55 returned 0 after 7 msecs
[    5.558410] calling  irda_init+0x0/0x92
[    5.564073] NET: Registered protocol family 23
[    5.568087] initcall irda_init+0x0/0x92 returned 0 after 3 msecs
[    5.572033] calling  bt_init+0x0/0x5d
[    5.576033] Bluetooth: Core ver 2.13
[    5.580082] device class 'bluetooth': registering
[    5.588092] NET: Registered protocol family 31
[    5.592033] Bluetooth: HCI device and connection manager initialized
[    5.596040] Bluetooth: HCI socket layer initialized
[    5.604033] initcall bt_init+0x0/0x5d returned 0 after 26 msecs
[    5.608033] calling  wireless_nlevent_init+0x0/0x41
[    5.612033] initcall wireless_nlevent_init+0x0/0x41 returned 0 after 0 msecs
[    5.620034] calling  cfg80211_init+0x0/0x4d
[    5.624033] device class 'ieee80211': registering
[    5.628091] initcall cfg80211_init+0x0/0x4d returned 0 after 3 msecs
[    5.636033] calling  ieee80211_init+0x0/0x1f
[    5.640040] initcall ieee80211_init+0x0/0x1f returned 0 after 0 msecs
[    5.646410] calling  netlbl_init+0x0/0x83
[    5.652033] NetLabel: Initializing
[    5.656032] NetLabel:  domain hash size = 128
[    5.660032] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.664101] NetLabel:  unlabeled traffic allowed by default
[    5.668034] initcall netlbl_init+0x0/0x83 returned 0 after 15 msecs
[    5.676033] calling  rfkill_init+0x0/0x72
[    5.680033] device class 'rfkill': registering
[    5.684090] initcall rfkill_init+0x0/0x72 returned 0 after 3 msecs
[    5.690410] calling  sysctl_init+0x0/0x49
[    5.696034] initcall sysctl_init+0x0/0x49 returned 0 after 0 msecs
[    5.704035] calling  pci_iommu_init+0x0/0x1c
[    5.708102] PCI-GART: No AMD northbridge found.
[    5.712034] initcall pci_iommu_init+0x0/0x1c returned 0 after 3 msecs
[    5.718410] calling  print_all_ICs+0x0/0x4b9
[    5.724033] 
[    5.724033] printing PIC contents
[    5.728035] ... PIC  IMR: ffff
[    5.731105] ... PIC  IRR: 0c00
[    5.736033] ... PIC  ISR: 0000
[    5.736034] ... PIC ELCR: 0e00
[    5.740034] 
[    5.740034] printing local APIC contents on CPU#0/0:
[    5.744031] ... APIC ID:      00000000 (0)
[    5.744031] ... APIC VERSION: 00050014
[    5.744031] ... APIC TASKPRI: 00000000 (00)
[    5.744031] ... APIC PROCPRI: 00000000
[    5.744031] ... APIC LDR: 01000000
[    5.744031] ... APIC DFR: ffffffff
[    5.744031] ... APIC SPIV: 000001ff
[    5.744031] ... APIC ISR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] ... APIC TMR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] ... APIC IRR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000010000000000000000
[    5.744031] ... APIC ESR: 00000000
[    5.744031] ... APIC ICR: 00000606
[    5.744031] ... APIC ICR2: 01000000
[    5.744031] ... APIC LVTT: 000200ef
[    5.744031] ... APIC LVTPC: 00010000
[    5.744031] ... APIC LVT0: 00010700
[    5.744031] ... APIC LVT1: 00000400
[    5.744031] ... APIC LVTERR: 000000fe
[    5.744031] ... APIC TMICT: 0001046a
[    5.744031] ... APIC TMCCT: 000072ff
[    5.744031] ... APIC TDCR: 00000003
[    5.744031] 
[    5.741516] 
[    5.741516] printing local APIC contents on CPU#1/1:
[    5.744031] ... APIC ID:      01000000 (1)
[    5.744031] ... APIC VERSION: 00050014
[    5.744031] ... APIC TASKPRI: 00000000 (00)
[    5.744031] ... APIC PROCPRI: 00000000
[    5.744031] ... APIC LDR: 02000000
[    5.744031] ... APIC DFR: ffffffff
[    5.744031] ... APIC SPIV: 000001ff
[    5.744031] ... APIC ISR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] ... APIC TMR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] ... APIC IRR field:
[    5.744031] 0123456789abcdef0123456789abcdef
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000000000000000000000
[    5.744031] 00000000000000010000000000000000
[    5.744031] ... APIC ESR: 00000000
[    5.744031] ... APIC ICR: 000008fb
[    5.744031] ... APIC ICR2: 01000000
[    5.744031] ... APIC LVTT: 000200ef
[    5.744031] ... APIC LVTPC: 00010000
[    5.744031] ... APIC LVT0: 00010700
[    5.744031] ... APIC LVT1: 00010400
[    5.744031] ... APIC LVTERR: 000000fe
[    5.744031] ... APIC TMICT: 0001046a
[    5.744031] ... APIC TMCCT: 00000de8
[    5.744031] ... APIC TDCR: 00000003
[    5.744031] 
[    5.972037] number of MP IRQ sources: 15.
[    5.976033] number of IO-APIC #2 registers: 24.
[    5.980033] testing the IO APIC.......................
[    5.984037] 
[    5.985548] IO APIC #2......
[    5.988033] .... register #00: 00000000
[    5.992033] .......    : physical APIC id: 00
[    6.000033] .......    : Delivery Type: 0
[    6.004033] .......    : LTS          : 0
[    6.008033] .... register #01: 00170020
[    6.012033] .......     : max redirection entries: 0017
[    6.016033] .......     : PRQ implemented: 0
[    6.020033] .......     : IO APIC version: 0020
[    6.024033] .... IRQ redirection table:
[    6.028033]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    6.032035]  00 000 1    0    0   0   0    0    0    00
[    6.039278]  01 003 0    0    0   0   0    1    1    31
[    6.044035]  02 003 0    0    0   0   0    1    1    30
[    6.048035]  03 003 0    0    0   0   0    1    1    33
[    6.055278]  04 003 0    0    0   0   0    1    1    34
[    6.060035]  05 003 0    0    0   0   0    1    1    35
[    6.064035]  06 003 0    0    0   0   0    1    1    36
[    6.071278]  07 003 0    0    0   0   0    1    1    37
[    6.076035]  08 003 0    0    0   0   0    1    1    38
[    6.080035]  09 003 0    1    0   0   0    1    1    39
[    6.088035]  0a 003 0    0    0   0   0    1    1    3A
[    6.092035]  0b 003 0    0    0   0   0    1    1    3B
[    6.096035]  0c 003 0    0    0   0   0    1    1    3C
[    6.104035]  0d 003 0    0    0   0   0    1    1    3D
[    6.108035]  0e 003 0    0    0   0   0    1    1    3E
[    6.112035]  0f 003 0    0    0   0   0    1    1    3F
[    6.120035]  10 000 1    0    0   0   0    0    0    00
[    6.124033]  11 000 1    0    0   0   0    0    0    00
[    6.128038]  12 000 1    0    0   0   0    0    0    00
[    6.132035]  13 000 1    0    0   0   0    0    0    00
[    6.139277]  14 000 1    0    0   0   0    0    0    00
[    6.144035]  15 000 1    0    0   0   0    0    0    00
[    6.148035]  16 000 1    0    0   0   0    0    0    00
[    6.155277]  17 000 1    0    0   0   0    0    0    00
[    6.160033] IRQ to pin mappings:
[    6.164033] IRQ0 -> 0:2
[    6.166563] IRQ1 -> 0:1
[    6.168797] IRQ3 -> 0:3
[    6.171328] IRQ4 -> 0:4
[    6.172797] IRQ5 -> 0:5
[    6.176797] IRQ6 -> 0:6
[    6.179328] IRQ7 -> 0:7
[    6.180797] IRQ8 -> 0:8
[    6.184243] IRQ9 -> 0:9
[    6.186774] IRQ10 -> 0:10
[    6.188883] IRQ11 -> 0:11
[    6.192243] IRQ12 -> 0:12
[    6.194947] IRQ13 -> 0:13
[    6.196883] IRQ14 -> 0:14
[    6.200243] IRQ15 -> 0:15
[    6.202948] .................................... done.
[    6.208033] initcall print_all_ICs+0x0/0x4b9 returned 0 after 461 msecs
[    6.214583] calling  hpet_late_init+0x0/0x192
[    6.220036] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    6.224243] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    6.229039] initcall hpet_late_init+0x0/0x192 returned 0 after 11 msecs
[    6.236033] calling  init_kmmio+0x0/0x2c
[    6.240039] initcall init_kmmio+0x0/0x2c returned 0 after 0 msecs
[    6.248034] calling  clocksource_done_booting+0x0/0x12
[    6.252033] initcall clocksource_done_booting+0x0/0x12<6>Switched to NOHz mode on CPU #0
[    6.262678] Switched to NOHz mode on CPU #1
[    6.266876]  returned 0 after 0 msecs
[    6.273112] calling  tracer_alloc_buffers+0x0/0x4e4
[    6.279818] tracer: 357 pages allocated for 16384 entries of 88 bytes
[    6.286269]    actual entries 16422
[    6.289878] initcall tracer_alloc_buffers+0x0/0x4e4 returned 0 after 11 msecs
[    6.297058] calling  init_pipe_fs+0x0/0x4c
[    6.301211] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 msecs
[    6.307523] calling  init_mnt_writers+0x0/0x87
[    6.311983] initcall init_mnt_writers+0x0/0x87 returned 0 after 0 msecs
[    6.318642] calling  eventpoll_init+0x0/0x95
[    6.322942] initcall eventpoll_init+0x0/0x95 returned 0 after 0 msecs
[    6.329431] calling  anon_inode_init+0x0/0x115
[    6.333909] initcall anon_inode_init+0x0/0x115 returned 0 after 0 msecs
[    6.340572] calling  pcie_aspm_init+0x0/0x22
[    6.347314] initcall pcie_aspm_init+0x0/0x22 returned 0 after 2 msecs
[    6.353806] calling  acpi_event_init+0x0/0x80
[    6.372081] initcall acpi_event_init+0x0/0x80 returned 0 after 13 msecs
[    6.378744] calling  pnp_system_init+0x0/0x12
[    6.383117] pnp: the driver 'system' has been registered
[    6.388441] bus: 'pnp': add driver system
[    6.394762] bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
[    6.402517] bus: 'pnp': really_probe: probing driver system with device 00:01
[    6.409680] system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
[    6.416826] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    6.423972] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    6.431118] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    6.438263] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    6.445407] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    6.452551] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    6.459704] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    6.466849] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    6.473476] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    6.480447] system 00:01: driver attached
[    6.484475] driver: '00:01': driver_bound: bound to device 'system'
[    6.490754] bus: 'pnp': really_probe: bound device 00:01 to driver system
[    6.497558] bus: 'pnp': driver_probe_device: matched device 00:06 with driver system
[    6.505314] bus: 'pnp': really_probe: probing driver system with device 00:06
[    6.512464] system 00:06: ioport range 0x500-0x53f has been reserved
[    6.518830] system 00:06: ioport range 0x400-0x47f has been reserved
[    6.525196] system 00:06: ioport range 0x680-0x6ff has been reserved
[    6.531561] system 00:06: driver attached
[    6.535585] driver: '00:06': driver_bound: bound to device 'system'
[    6.541864] bus: 'pnp': really_probe: bound device 00:06 to driver system
[    6.548771] initcall pnp_system_init+0x0/0x12 returned 0 after 157 msecs
[    6.555517] calling  chr_dev_init+0x0/0xb4
[    6.559650] device class 'mem': registering
[    6.563946] device: 'mem': device_add
[    6.567651] PM: Adding info for No Bus:mem
[    6.571872] device: 'null': device_add
[    6.575656] PM: Adding info for No Bus:null
[    6.579948] device: 'port': device_add
[    6.583731] PM: Adding info for No Bus:port
[    6.588025] device: 'zero': device_add
[    6.591812] PM: Adding info for No Bus:zero
[    6.596105] device: 'full': device_add
[    6.599885] PM: Adding info for No Bus:full
[    6.604177] device: 'random': device_add
[    6.608134] PM: Adding info for No Bus:random
[    6.612599] device: 'urandom': device_add
[    6.616643] PM: Adding info for No Bus:urandom
[    6.621195] device: 'kmsg': device_add
[    6.624986] PM: Adding info for No Bus:kmsg
[    6.629278] device: 'oldmem': device_add
[    6.633236] PM: Adding info for No Bus:oldmem
[    6.637699] initcall chr_dev_init+0x0/0xb4 returned 0 after 74 msecs
[    6.644102] calling  firmware_class_init+0x0/0x79
[    6.648819] device class 'firmware': registering
[    6.653547] initcall firmware_class_init+0x0/0x79 returned 0 after 4 msecs
[    6.660471] calling  loopback_init+0x0/0x12
[    6.664685] device: 'lo': device_add
[    6.668366] PM: Adding info for No Bus:lo
[    6.672505] initcall loopback_init+0x0/0x12 returned 0 after 7 msecs
[    6.678905] calling  init_acpi_pm_clocksource+0x0/0xba
[    6.684080] initcall init_acpi_pm_clocksource+0x0/0xba returned 0 after 0 msecs
[    6.691437] calling  ssb_modinit+0x0/0x4a
[    6.695580] bus: 'ssb': registered
[    6.699007] initcall ssb_modinit+0x0/0x4a returned 0 after 3 msecs
[    6.705235] calling  pcibios_assign_resources+0x0/0x88
[    6.710475] pci 0000:01:00.0: BAR 6: got res [0x50320000-0x5033ffff] bus [0x50320000-0x5033ffff] flags 0x27200
[    6.720485] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    6.726417] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    6.731743] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    6.737850] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x0000004fffffff
[    6.745436] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    6.751367] pci 0000:00:1c.0:   IO window: disabled
[    6.756262] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    6.762368] pci 0000:00:1c.0:   PREFETCH window: disabled
[    6.767785] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    6.773715] pci 0000:00:1c.4:   IO window: disabled
[    6.778609] pci 0000:00:1c.4:   MEM window: disabled
[    6.783590] pci 0000:00:1c.4:   PREFETCH window: disabled
[    6.789007] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
[    6.794939] pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
[    6.800266] pci 0000:00:1c.5:   MEM window: 0x50100000-0x501fffff
[    6.806373] pci 0000:00:1c.5:   PREFETCH window: disabled
[    6.811789] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    6.817722] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    6.823051] pci 0000:00:1e.0:   MEM window: 0x50000000-0x500fffff
[    6.829158] pci 0000:00:1e.0:   PREFETCH window: disabled
[    6.834585] found new irq_cfg for irq 16
[    6.838524]  0 add_pin_to_irq: irq 16 --> apic 0 pin 16
[    6.843764] IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
[    6.851260] found new irq_desc for irq 16
[    6.855286] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.861999] pci 0000:00:01.0: setting latency timer to 64
[    6.867418] found new irq_cfg for irq 17
[    6.871357]  0 add_pin_to_irq: irq 17 --> apic 0 pin 17
[    6.876597] IOAPIC[0]: Set routing entry (2-17 -> 0x51 -> IRQ 17 Mode:1 Active:1)
[    6.884092] found new irq_desc for irq 17
[    6.888117] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.894831] pci 0000:00:1c.0: setting latency timer to 64
[    6.900249] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.909262] pci 0000:00:1c.4: setting latency timer to 64
[    6.914679] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    6.921393] pci 0000:00:1c.5: setting latency timer to 64
[    6.926810] pci 0000:00:1e.0: setting latency timer to 64
[    6.932224] bus: 00 index 0 io port: [0, ffff]
[    6.936682] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    6.941920] bus: 01 index 0 io port: [3000, 3fff]
[    6.946637] bus: 01 index 1 mmio: [50300000, 503fffff]
[    6.951789] bus: 01 index 2 mmio: [40000000, 4fffffff]
[    6.956941] bus: 01 index 3 mmio: [0, 0]
[    6.960880] bus: 02 index 0 mmio: [0, 0]
[    6.964818] bus: 02 index 1 mmio: [50200000, 502fffff]
[    6.969970] bus: 02 index 2 mmio: [0, 0]
[    6.973909] bus: 02 index 3 mmio: [0, 0]
[    6.977848] bus: 03 index 0 mmio: [0, 0]
[    6.981786] bus: 03 index 1 mmio: [0, 0]
[    6.985725] bus: 03 index 2 mmio: [0, 0]
[    6.989663] bus: 03 index 3 mmio: [0, 0]
[    6.993602] bus: 04 index 0 io port: [2000, 2fff]
[    6.998321] bus: 04 index 1 mmio: [50100000, 501fffff]
[    7.003477] bus: 04 index 2 mmio: [0, 0]
[    7.007416] bus: 04 index 3 mmio: [0, 0]
[    7.011355] bus: 05 index 0 io port: [1000, 1fff]
[    7.016074] bus: 05 index 1 mmio: [50000000, 500fffff]
[    7.021227] bus: 05 index 2 mmio: [0, 0]
[    7.025166] bus: 05 index 3 io port: [0, ffff]
[    7.029623] bus: 05 index 4 mmio: [0, ffffffffffffffff]
[    7.034863] initcall pcibios_assign_resources+0x0/0x88 returned 0 after 309 msecs
[    7.042395] calling  inet_init+0x0/0x1e9
[    7.046360] NET: Registered protocol family 2
[    7.096341] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    7.104415] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    7.113943] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    7.123184] TCP: Hash tables configured (established 131072 bind 65536)
[    7.129856] TCP reno registered
[    7.148494] initcall inet_init+0x0/0x1e9 returned 0 after 97 msecs
[    7.154727] calling  af_unix_init+0x0/0x55
[    7.158849] NET: Registered protocol family 1
[    7.163233] initcall af_unix_init+0x0/0x55 returned 0 after 4 msecs
[    7.169549] calling  populate_rootfs+0x0/0x233
[    7.174469] initcall populate_rootfs+0x0/0x233 returned 0 after 0 msecs
[    7.181135] calling  calgary_fixup_tce_spaces+0x0/0xf0
[    7.186287] initcall calgary_fixup_tce_spaces+0x0/0xf0 returned -19 after 0 msecs
[    7.193821] calling  pci_init+0x0/0x3a
[    7.197595] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.203994] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.210310] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.216971] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xaa
[    7.222854] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.229258] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.235568] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.242229] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xaa
[    7.248114] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.254513] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.260830] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.267487] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xaa
[    7.273371] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.279768] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.286083] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.295298] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xaa
[    7.301181] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x17f
[    7.307579] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x20
[    7.313894] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.320554] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xaa
[    7.326434] pci 0000:00:1c.5: calling quirk_e100_interrupt+0x0/0x17f
[    7.332838] pci 0000:00:1c.5: calling quirk_cardbus_legacy+0x0/0x20
[    7.339148] pci 0000:00:1c.5: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.345809] pci 0000:00:1c.5: calling pci_fixup_video+0x0/0xaa
[    7.351690] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.358092] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.364405] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.371067] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    7.377605] pci 0000:00:1d.0: Performing full reset
[    7.382507] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xaa
[    7.388391] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x17f
[    7.394790] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x20
[    7.401105] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.407765] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    7.414303] pci 0000:00:1d.1: Performing full reset
[    7.419202] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xaa
[    7.425085] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x17f
[    7.431485] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x20
[    7.437800] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.444465] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    7.451003] pci 0000:00:1d.2: Performing full reset
[    7.455902] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xaa
[    7.461789] pci 0000:00:1d.3: calling quirk_e100_interrupt+0x0/0x17f
[    7.468192] pci 0000:00:1d.3: calling quirk_cardbus_legacy+0x0/0x20
[    7.474504] pci 0000:00:1d.3: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.481169] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
[    7.487706] pci 0000:00:1d.3: Performing full reset
[    7.492605] pci 0000:00:1d.3: calling pci_fixup_video+0x0/0xaa
[    7.498489] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x17f
[    7.504896] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x20
[    7.511207] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.517999] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xaa
[    7.523882] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.530285] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.536600] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.543258] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xaa
[    7.549145] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.555545] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.561860] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.568522] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xaa
[    7.574406] pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x17f
[    7.580809] pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x20
[    7.587120] pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.593782] pci 0000:00:1f.1: calling pci_fixup_video+0x0/0xaa
[    7.599664] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x17f
[    7.606067] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x20
[    7.612381] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.619040] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xaa
[    7.624926] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x17f
[    7.631324] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x20
[    7.637639] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.644301] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xaa
[    7.650183] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.656498] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.663157] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xaa
[    7.669040] pci 0000:01:00.0: Boot video device
[    7.673588] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x20
[    7.679899] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.686562] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xaa
[    7.692446] pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.698759] pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.705421] pci 0000:02:00.0: calling pci_fixup_video+0x0/0xaa
[    7.711304] pci 0000:04:00.0: calling quirk_e100_interrupt+0x0/0x17f
[    7.717707] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.724018] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.730680] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xaa
[    7.736564] pci 0000:05:02.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.742878] pci 0000:05:02.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.749541] pci 0000:05:02.0: calling pci_fixup_video+0x0/0xaa
[    7.755422] pci 0000:05:04.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.761737] pci 0000:05:04.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.768402] pci 0000:05:04.0: calling pci_fixup_video+0x0/0xaa
[    7.774287] pci 0000:05:05.0: calling quirk_cardbus_legacy+0x0/0x20
[    7.780601] pci 0000:05:05.0: calling quirk_usb_early_handoff+0x0/0x3d7
[    7.787260] pci 0000:05:05.0: calling pci_fixup_video+0x0/0xaa
[    7.793145] initcall pci_init+0x0/0x3a returned 0 after 567 msecs
[    7.799286] calling  ehci_hcd_init+0x0/0x8b
[    7.803486] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    7.809515] bus: 'pci': add driver ehci_hcd
[    7.813746] bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with driver ehci_hcd
[    7.822281] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:1d.7
[    7.830243] found new irq_cfg for irq 23
[    7.834183]  0 add_pin_to_irq: irq 23 --> apic 0 pin 23
[    7.839425] IOAPIC[0]: Set routing entry (2-23 -> 0x59 -> IRQ 23 Mode:1 Active:1)
[    7.846920] found new irq_desc for irq 23
[    7.850950] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    7.858105] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    7.863951] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.869216] device: 'usb_host1': device_add
[    7.873437] PM: Adding info for No Bus:usb_host1
[    7.878230] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    7.885647] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    7.894619] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    7.902928] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.915703] ehci_hcd 0000:00:1d.7: debug port 1
[    7.920253] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    7.927052] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    7.932844] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50404400
[    7.938517] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    7.951278] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    7.968060] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.975646] usb usb1: default language 0x0409
[    7.980047] device: 'usb1': device_add
[    7.983873] bus: 'usb': add device usb1
[    7.987745] PM: Adding info for usb:usb1
[    7.991694] usb usb1: uevent
[    7.994686] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[    8.002095] bus: 'usb': really_probe: probing driver usb with device usb1
[    8.008898] usb usb1: usb_probe_device
[    8.012664] usb usb1: configuration #1 chosen from 1 choice
[    8.018269] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.024028] device: '1-0:1.0': device_add
[    8.028072] bus: 'usb': add device 1-0:1.0
[    8.032195] PM: Adding info for usb:1-0:1.0
[    8.036402] usb 1-0:1.0: uevent
[    8.039656] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[    8.047325] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[    8.054389] hub 1-0:1.0: usb_probe_interface
[    8.058675] hub 1-0:1.0: usb_probe_interface - got id
[    8.063740] hub 1-0:1.0: USB hub found
[    8.067530] hub 1-0:1.0: 8 ports detected
[    8.071557] hub 1-0:1.0: standalone hub
[    8.075410] hub 1-0:1.0: no power switching (usb 1.0)
[    8.080473] hub 1-0:1.0: individual port over-current protection
[    8.086491] hub 1-0:1.0: power on to power good time: 20ms
[    8.092009] hub 1-0:1.0: local power source is good
[    8.096902] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    8.204151] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    8.204157] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    8.215848] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    8.222564] device class 'usb_endpoint': registering
[    8.227674] device: 'usbdev1.1_ep81': device_add
[    8.232352] PM: Adding info for No Bus:usbdev1.1_ep81
[    8.237527] driver: 'usb1': driver_bound: bound to device 'usb'
[    8.243460] bus: 'usb': really_probe: bound device usb1 to driver usb
[    8.249932] device: 'usbdev1.1_ep00': device_add
[    8.254612] PM: Adding info for No Bus:usbdev1.1_ep00
[    8.259778] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    8.266578] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.273813] usb usb1: Product: EHCI Host Controller
[    8.278706] usb usb1: Manufacturer: Linux 2.6.27-rc6-tip-00189-gafeef79-dirty ehci_hcd
[    8.286634] usb usb1: SerialNumber: 0000:00:1d.7
[    8.291268] driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd'
[    8.298327] bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd
[    8.306024] initcall ehci_hcd_init+0x0/0x8b returned 0 after 479 msecs
[    8.312601] calling  ohci_hcd_mod_init+0x0/0xa4
[    8.317147] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.324642] ohci_hcd: block sizes: ed 80 td 96
[    8.329107] bus: 'pci': add driver ohci_hcd
[    8.333438] initcall ohci_hcd_mod_init+0x0/0xa4 returned 0 after 15 msecs
[    8.340274] calling  uhci_hcd_init+0x0/0xec
[    8.344472] USB Universal Host Controller Interface driver v3.0
[    8.350421] bus: 'pci': add driver uhci_hcd
[    8.354633] bus: 'pci': driver_probe_device: matched device 0000:00:1d.0 with driver uhci_hcd
[    8.363172] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.0
[    8.371114] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    8.378265] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.386667] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.391917] device: 'usb_host2': device_add
[    8.396146] PM: Adding info for No Bus:usb_host2
[    8.400874] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    8.408290] uhci_hcd 0000:00:1d.0: detected 2 ports
[    8.413184] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    8.419894] uhci_hcd 0000:00:1d.0: Performing full reset
[    8.425231] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    8.431000] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    8.436832] usb usb2: default language 0x0409
[    8.441233] device: 'usb2': device_add
[    8.445055] bus: 'usb': add device usb2
[    8.448920] PM: Adding info for usb:usb2
[    8.452867] usb usb2: uevent
[    8.455853] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[    8.463262] bus: 'usb': really_probe: probing driver usb with device usb2
[    8.470064] usb usb2: usb_probe_device
[    8.473832] usb usb2: configuration #1 chosen from 1 choice
[    8.479426] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    8.485185] device: '2-0:1.0': device_add
[    8.489228] bus: 'usb': add device 2-0:1.0
[    8.493367] PM: Adding info for usb:2-0:1.0
[    8.497574] usb 2-0:1.0: uevent
[    8.500821] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[    8.508490] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[    8.515552] hub 2-0:1.0: usb_probe_interface
[    8.519838] hub 2-0:1.0: usb_probe_interface - got id
[    8.524902] hub 2-0:1.0: USB hub found
[    8.528693] hub 2-0:1.0: 2 ports detected
[    8.532721] hub 2-0:1.0: standalone hub
[    8.536573] hub 2-0:1.0: no power switching (usb 1.0)
[    8.541637] hub 2-0:1.0: individual port over-current protection
[    8.547655] hub 2-0:1.0: power on to power good time: 2ms
[    8.553081] hub 2-0:1.0: local power source is good
[    8.557974] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    8.668086] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[    8.668093] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    8.679783] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[    8.686500] device: 'usbdev2.1_ep81': device_add
[    8.691176] PM: Adding info for No Bus:usbdev2.1_ep81
[    8.696342] driver: 'usb2': driver_bound: bound to device 'usb'
[    8.702274] bus: 'usb': really_probe: bound device usb2 to driver usb
[    8.708752] device: 'usbdev2.1_ep00': device_add
[    8.713420] PM: Adding info for No Bus:usbdev2.1_ep00
[    8.718582] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.725381] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.732615] usb usb2: Product: UHCI Host Controller
[    8.737507] usb usb2: Manufacturer: Linux 2.6.27-rc6-tip-00189-gafeef79-dirty uhci_hcd
[    8.745436] usb usb2: SerialNumber: 0000:00:1d.0
[    8.750078] driver: '0000:00:1d.0': driver_bound: bound to device 'uhci_hcd'
[    8.757135] bus: 'pci': really_probe: bound device 0000:00:1d.0 to driver uhci_hcd
[    8.764718] bus: 'pci': driver_probe_device: matched device 0000:00:1d.1 with driver uhci_hcd
[    8.773251] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.1
[    8.781189] found new irq_cfg for irq 19
[    8.785128]  0 add_pin_to_irq: irq 19 --> apic 0 pin 19
[    8.790368] IOAPIC[0]: Set routing entry (2-19 -> 0x61 -> IRQ 19 Mode:1 Active:1)
[    8.797862] found new irq_desc for irq 19
[    8.801890] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.809040] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.814886] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.820136] device: 'usb_host3': device_add
[    8.824363] PM: Adding info for No Bus:usb_host3
[    8.829090] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    8.836513] uhci_hcd 0000:00:1d.1: detected 2 ports
[    8.841408] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    8.848118] uhci_hcd 0000:00:1d.1: Performing full reset
[    8.853455] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    8.859238] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    8.865065] usb usb3: default language 0x0409
[    8.869466] device: 'usb3': device_add
[    8.873289] bus: 'usb': add device usb3
[    8.877154] PM: Adding info for usb:usb3
[    8.881101] usb usb3: uevent
[    8.884084] bus: 'usb': driver_probe_device: matched device usb3 with driver usb
[    8.891493] bus: 'usb': really_probe: probing driver usb with device usb3
[    8.898296] usb usb3: usb_probe_device
[    8.902061] usb usb3: configuration #1 chosen from 1 choice
[    8.907657] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    8.913416] device: '3-0:1.0': device_add
[    8.917460] bus: 'usb': add device 3-0:1.0
[    8.921590] PM: Adding info for usb:3-0:1.0
[    8.925797] usb 3-0:1.0: uevent
[    8.929044] bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
[    8.936714] bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
[    8.943775] hub 3-0:1.0: usb_probe_interface
[    8.948061] hub 3-0:1.0: usb_probe_interface - got id
[    8.953126] hub 3-0:1.0: USB hub found
[    8.956904] hub 3-0:1.0: 2 ports detected
[    8.960929] hub 3-0:1.0: standalone hub
[    8.964781] hub 3-0:1.0: no power switching (usb 1.0)
[    8.969845] hub 3-0:1.0: individual port over-current protection
[    8.975864] hub 3-0:1.0: power on to power good time: 2ms
[    8.981288] hub 3-0:1.0: local power source is good
[    8.986182] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    9.096068] driver: '3-0:1.0': driver_bound: bound to device 'hub'
[    9.096074] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.107763] bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
[    9.114481] device: 'usbdev3.1_ep81': device_add
[    9.119165] PM: Adding info for No Bus:usbdev3.1_ep81
[    9.124331] driver: 'usb3': driver_bound: bound to device 'usb'
[    9.130264] bus: 'usb': really_probe: bound device usb3 to driver usb
[    9.136747] device: 'usbdev3.1_ep00': device_add
[    9.141416] PM: Adding info for No Bus:usbdev3.1_ep00
[    9.146579] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    9.153379] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.160613] usb usb3: Product: UHCI Host Controller
[    9.165504] usb usb3: Manufacturer: Linux 2.6.27-rc6-tip-00189-gafeef79-dirty uhci_hcd
[    9.173430] usb usb3: SerialNumber: 0000:00:1d.1
[    9.178071] driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd'
[    9.185128] bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd
[    9.192712] bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with driver uhci_hcd
[    9.201246] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.2
[    9.209184] found new irq_cfg for irq 18
[    9.213123]  0 add_pin_to_irq: irq 18 --> apic 0 pin 18
[    9.218363] IOAPIC[0]: Set routing entry (2-18 -> 0x69 -> IRQ 18 Mode:1 Active:1)
[    9.225859] found new irq_desc for irq 18
[    9.229887] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    9.237037] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.242884] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.248152] device: 'usb_host4': device_add
[    9.252381] PM: Adding info for No Bus:usb_host4
[    9.257109] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    9.264541] uhci_hcd 0000:00:1d.2: detected 2 ports
[    9.269436] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    9.276147] uhci_hcd 0000:00:1d.2: Performing full reset
[    9.281481] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    9.287264] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    9.293088] usb usb4: default language 0x0409
[    9.297486] device: 'usb4': device_add
[    9.301307] bus: 'usb': add device usb4
[    9.305173] PM: Adding info for usb:usb4
[    9.309120] usb usb4: uevent
[    9.312106] bus: 'usb': driver_probe_device: matched device usb4 with driver usb
[    9.319516] bus: 'usb': really_probe: probing driver usb with device usb4
[    9.326328] usb usb4: usb_probe_device
[    9.330107] usb usb4: configuration #1 chosen from 1 choice
[    9.335705] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    9.341465] device: '4-0:1.0': device_add
[    9.345509] bus: 'usb': add device 4-0:1.0
[    9.349639] PM: Adding info for usb:4-0:1.0
[    9.353846] usb 4-0:1.0: uevent
[    9.357091] bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
[    9.364761] bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
[    9.371822] hub 4-0:1.0: usb_probe_interface
[    9.376109] hub 4-0:1.0: usb_probe_interface - got id
[    9.381174] hub 4-0:1.0: USB hub found
[    9.384953] hub 4-0:1.0: 2 ports detected
[    9.388979] hub 4-0:1.0: standalone hub
[    9.392832] hub 4-0:1.0: no power switching (usb 1.0)
[    9.397897] hub 4-0:1.0: individual port over-current protection
[    9.403915] hub 4-0:1.0: power on to power good time: 2ms
[    9.409341] hub 4-0:1.0: local power source is good
[    9.414233] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    9.524070] driver: '4-0:1.0': driver_bound: bound to device 'hub'
[    9.524076] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.535765] bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
[    9.542483] device: 'usbdev4.1_ep81': device_add
[    9.547150] PM: Adding info for No Bus:usbdev4.1_ep81
[    9.552323] driver: 'usb4': driver_bound: bound to device 'usb'
[    9.560810] bus: 'usb': really_probe: bound device usb4 to driver usb
[    9.567287] device: 'usbdev4.1_ep00': device_add
[    9.571955] PM: Adding info for No Bus:usbdev4.1_ep00
[    9.577132] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    9.583931] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.591166] usb usb4: Product: UHCI Host Controller
[    9.596059] usb usb4: Manufacturer: Linux 2.6.27-rc6-tip-00189-gafeef79-dirty uhci_hcd
[    9.603986] usb usb4: SerialNumber: 0000:00:1d.2
[    9.608627] driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd'
[    9.615685] bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd
[    9.623268] bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with driver uhci_hcd
[    9.631802] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.3
[    9.639741] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    9.646892] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    9.652739] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    9.657989] device: 'usb_host5': device_add
[    9.662213] PM: Adding info for No Bus:usb_host5
[    9.666940] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    9.674356] uhci_hcd 0000:00:1d.3: detected 2 ports
[    9.679251] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    9.685966] uhci_hcd 0000:00:1d.3: Performing full reset
[    9.691300] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    9.697092] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    9.702919] usb usb5: default language 0x0409
[    9.707321] device: 'usb5': device_add
[    9.711143] bus: 'usb': add device usb5
[    9.715009] PM: Adding info for usb:usb5
[    9.718956] usb usb5: uevent
[    9.721943] bus: 'usb': driver_probe_device: matched device usb5 with driver usb
[    9.729354] bus: 'usb': really_probe: probing driver usb with device usb5
[    9.736157] usb usb5: usb_probe_device
[    9.739923] usb usb5: configuration #1 chosen from 1 choice
[    9.745519] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    9.751278] device: '5-0:1.0': device_add
[    9.755320] bus: 'usb': add device 5-0:1.0
[    9.759450] PM: Adding info for usb:5-0:1.0
[    9.763658] usb 5-0:1.0: uevent
[    9.766905] bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
[    9.774575] bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
[    9.781638] hub 5-0:1.0: usb_probe_interface
[    9.785924] hub 5-0:1.0: usb_probe_interface - got id
[    9.790989] hub 5-0:1.0: USB hub found
[    9.794767] hub 5-0:1.0: 2 ports detected
[    9.798793] hub 5-0:1.0: standalone hub
[    9.802646] hub 5-0:1.0: no power switching (usb 1.0)
[    9.807710] hub 5-0:1.0: individual port over-current protection
[    9.813726] hub 5-0:1.0: power on to power good time: 2ms
[    9.819150] hub 5-0:1.0: local power source is good
[    9.824042] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    9.830932] usb usb2: suspend_rh (auto-stop)
[    9.936082] driver: '5-0:1.0': driver_bound: bound to device 'hub'
[    9.936088] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    9.947777] bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
[    9.954493] device: 'usbdev5.1_ep81': device_add
[    9.959160] PM: Adding info for No Bus:usbdev5.1_ep81
[    9.964326] driver: 'usb5': driver_bound: bound to device 'usb'
[    9.970260] bus: 'usb': really_probe: bound device usb5 to driver usb
[    9.976729] device: 'usbdev5.1_ep00': device_add
[    9.981410] PM: Adding info for No Bus:usbdev5.1_ep00
[    9.986573] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    9.993373] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.000607] usb usb5: Product: UHCI Host Controller
[   10.005498] usb usb5: Manufacturer: Linux 2.6.27-rc6-tip-00189-gafeef79-dirty uhci_hcd
[   10.013425] usb usb5: SerialNumber: 0000:00:1d.3
[   10.018066] driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd'
[   10.025123] bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd
[   10.032820] initcall uhci_hcd_init+0x0/0xec returned 0 after 1610 msecs
[   10.039482] calling  i8259A_init_sysfs+0x0/0x22
[   10.044028] Registering sysdev class 'i8259'
[   10.048405] Registering sys device of class 'i8259'
[   10.053301] Registering sys device 'i82590'
[   10.057589] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 12 msecs
[   10.064424] calling  vsyscall_init+0x0/0x6c
[   10.068631] initcall vsyscall_init+0x0/0x6c returned 0 after 0 msecs
[   10.075050] calling  sbf_init+0x0/0xd5
[   10.078816] initcall sbf_init+0x0/0xd5 returned 0 after 0 msecs
[   10.084785] calling  i8237A_init_sysfs+0x0/0x22
[   10.089331] Registering sysdev class 'i8237'
[   10.093710] Registering sys device of class 'i8237'
[   10.098623] Registering sys device 'i82370'
[   10.102911] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 12 msecs
[   10.109748] calling  add_rtc_cmos+0x0/0x1d
[   10.113861] initcall add_rtc_cmos+0x0/0x1d returned 0 after 0 msecs
[   10.120174] calling  cache_sysfs_init+0x0/0x5c
[   10.125561] initcall cache_sysfs_init+0x0/0x5c returned 0 after 0 msecs
[   10.132225] calling  mce_init_device+0x0/0x78
[   10.136598] Registering sysdev class 'machinecheck'
[   10.141581] Registering sys device of class 'machinecheck'
[   10.147084] Registering sys device 'machinecheck0'
[   10.151995] Registering sys device of class 'machinecheck'
[   10.157499] Registering sys device 'machinecheck1'
[   10.162427] device: 'mcelog': device_add
[   10.166385] PM: Adding info for No Bus:mcelog
[   10.170855] initcall mce_init_device+0x0/0x78 returned 0 after 32 msecs
[   10.177518] calling  periodic_mcheck_init+0x0/0x3f
[   10.182330] initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 msecs
[   10.189337] calling  thermal_throttle_init_device+0x0/0x7f
[   10.194857] initcall thermal_throttle_init_device+0x0/0x7f returned 0 after 0 msecs
[   10.202562] calling  threshold_init_device+0x0/0x42
[   10.207455] initcall threshold_init_device+0x0/0x42 returned 0 after 0 msecs
[   10.214549] calling  msr_init+0x0/0xed
[   10.218320] device class 'msr': registering
[   10.222616] device: 'msr0': device_add
[   10.226401] PM: Adding info for No Bus:msr0
[   10.230698] device: 'msr1': device_add
[   10.234489] PM: Adding info for No Bus:msr1
[   10.238779] initcall msr_init+0x0/0xed returned 0 after 19 msecs
[   10.244835] calling  cpuid_init+0x0/0xed
[   10.248778] device class 'cpuid': registering
[   10.253247] device: 'cpu0': device_add
[   10.257031] PM: Adding info for No Bus:cpu0
[   10.261328] device: 'cpu1': device_add
[   10.265112] PM: Adding info for No Bus:cpu1
[   10.269402] initcall cpuid_init+0x0/0xed returned 0 after 19 msecs
[   10.275630] calling  microcode_intel_module_init+0x0/0x45
[   10.281045] device: 'microcode': device_add
[   10.285261] PM: Adding info for No Bus:microcode
[   10.289986] Registering platform device 'microcode'. Parent at platform
[   10.296611] device: 'microcode': device_add
[   10.300822] bus: 'platform': add device microcode
[   10.305555] PM: Adding info for platform:microcode
[   10.310503] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
[   10.319126] initcall microcode_intel_module_init+0x0/0x45<7>usb usb3: suspend_rh (auto-stop)
[   10.327635]  returned 0 after 36 msecs
[   10.331402] calling  init_lapic_sysfs+0x0/0x3f
[   10.335862] Registering sysdev class 'lapic'
[   10.340241] Registering sys device of class 'lapic'
[   10.345140] Registering sys device 'lapic0'
[   10.349429] initcall init_lapic_sysfs+0x0/0x3f returned 0 after 12 msecs
[   10.356178] calling  ioapic_init_sysfs+0x0/0x99
[   10.360724] Registering sysdev class 'ioapic'
[   10.365189] Registering sys device of class 'ioapic'
[   10.370173] Registering sys device 'ioapic0'
[   10.374549] initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 13 msecs
[   10.381384] calling  add_pcspkr+0x0/0x43
[   10.385325] Registering platform device 'pcspkr'. Parent at platform
[   10.391689] device: 'pcspkr': device_add
[   10.395634] bus: 'platform': add device pcspkr
[   10.400113] PM: Adding info for platform:pcspkr
[   10.404752] initcall add_pcspkr+0x0/0x43 returned 0 after 18 msecs
[   10.410977] calling  uv_ptc_init+0x0/0x75
[   10.415003] initcall uv_ptc_init+0x0/0x75 returned 0 after 0 msecs
[   10.421231] calling  uv_bau_init+0x0/0x4ec
[   10.425344] initcall uv_bau_init+0x0/0x4ec returned 0 after 0 msecs
[   10.431655] calling  audit_classes_init+0x0/0xaf
[   10.436298] initcall audit_classes_init+0x0/0xaf returned 0 after 0 msecs
[   10.443129] calling  debug_pagealloc_proc_init+0x0/0x2b
[   10.448388] initcall debug_pagealloc_proc_init+0x0/0x2b returned 0 after 0 msecs
[   10.455831] calling  pt_dump_init+0x0/0x30
[   10.459950] initcall pt_dump_init+0x0/0x30 returned 0 after 0 msecs
[   10.466265] calling  init+0x0/0x12
[   10.469695] initcall init+0x0/0x12 returned 0 after 0 msecs
[   10.475314] calling  init+0x0/0x12
[   10.478736] initcall init+0x0/0x12 returned 0 after 0 msecs
[   10.484358] calling  init_vdso_vars+0x0/0x1a7
[   10.488741] initcall init_vdso_vars+0x0/0x1a7 returned 0 after 0 msecs
[   10.495312] calling  ia32_binfmt_init+0x0/0x14
[   10.499773] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 msecs
[   10.506437] calling  sysenter_setup+0x0/0x2c5
[   10.510814] initcall sysenter_setup+0x0/0x2c5 returned 0 after 0 msecs
[   10.517389] calling  init_sched_debug_procfs+0x0/0x2c
[   10.522465] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 msecs
[   10.529738] calling  ioresources_init+0x0/0x36
[   10.534204] initcall ioresources_init+0x0/0x36 returned 0 after 0 msecs
[   10.543421] calling  uid_cache_init+0x0/0x6e
[   10.547721] initcall uid_cache_init+0x0/0x6e returned 0 after 0 msecs
[   10.554209] calling  init_posix_timers+0x0/0xfd
[   10.558761] initcall init_posix_timers+0x0/0xfd returned 0 after 0 msecs
[   10.565510] calling  init_posix_cpu_timers+0x0/0xd4
[   10.570416] initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 msecs
[   10.577509] calling  nsproxy_cache_init+0x0/0x2d
[   10.582148] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 msecs
[   10.588982] calling  create_proc_profile+0x0/0x265
[   10.593802] initcall create_proc_profile+0x0/0x265 returned 0 after 0 msecs
[   10.600811] calling  timekeeping_init_device+0x0/0x22
[   10.605879] Registering sysdev class 'timekeeping'
[   10.610779] Registering sys device of class 'timekeeping'
[   10.616197] Registering sys device 'timekeeping0'
[   10.621008] initcall timekeeping_init_device+0x0/0x22 returned 0 after 14 msecs
[   10.628366] calling  init_clocksource_sysfs+0x0/0x50
[   10.633345] Registering sysdev class 'clocksource'
[   10.638250] Registering sys device of class 'clocksource'
[   10.643667] Registering sys device 'clocksource0'
[   10.648481] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 14 msecs
[   10.655753] calling  init_timer_list_procfs+0x0/0x2c
[   10.660738] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 msecs
[   10.667916] calling  init_tstats_procfs+0x0/0x2c
[   10.672555] initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 msecs
[   10.679385] calling  lockdep_proc_init+0x0/0x3c
[   10.683947] initcall lockdep_proc_init+0x0/0x3c returned 0 after 0 msecs
[   10.690693] calling  futex_init+0x0/0x6a
[   10.694648] initcall futex_init+0x0/0x6a returned 0 after 0 msecs
[   10.700789] calling  proc_dma_init+0x0/0x22
[   10.704992] initcall proc_dma_init+0x0/0x22 returned 0 after 0 msecs
[   10.711391] calling  kallsyms_init+0x0/0x25
[   10.715594] initcall kallsyms_init+0x0/0x25 returned 0 after 0 msecs
[   10.721998] calling  backtrace_regression_test+0x0/0xfd
[   10.727237] ====[ backtrace testing ]===========
[   10.731868] Testing a backtrace from process context.
[   10.736934] The following trace is a kernel self test and not a bug!
[   10.743299] Pid: 1, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[   10.751054] Call Trace:
[   10.753522]  [<ffffffff802183e1>] ? paravirt_read_tsc+0x17/0x1a
[   10.759454]  [<ffffffff80270bd4>] backtrace_regression_test+0x3d/0xfd
[   10.765907]  [<ffffffff802640a0>] ? clocksource_read+0xc/0xe
[   10.771579]  [<ffffffff8026428f>] ? getnstimeofday+0x41/0xa3
[   10.777252]  [<ffffffff802614e9>] ? ktime_set+0x9/0x32
[   10.782405]  [<ffffffff80261584>] ? timespec_to_ktime+0x1a/0x1c
[   10.788337]  [<ffffffff80261d25>] ? ktime_get+0x23/0x25
[   10.793576]  [<ffffffff8020a05c>] do_one_initcall+0x4c/0x151
[   10.799249]  [<ffffffff8025b577>] ? start_workqueue_thread+0x2e/0x32
[   10.805614]  [<ffffffff8025b958>] ? __create_workqueue_key+0xd3/0x190
[   10.812066]  [<ffffffff81261a19>] kernel_init+0x1ba/0x22b
[   10.816306] hub 1-0:1.0: hub_suspend
[   10.816319] usb usb1: bus auto-suspend
[   10.816321] ehci_hcd 0000:00:1d.7: suspend root hub
[   10.816353] hub 2-0:1.0: hub_suspend
[   10.816356] usb usb2: bus auto-suspend
[   10.816358] usb usb2: suspend_rh
[   10.840314] usb usb4: suspend_rh (auto-stop)
[   10.844619]  [<ffffffff80212089>] child_rip+0xa/0x11
[   10.849598]  [<ffffffff8126185f>] ? kernel_init+0x0/0x22b
[   10.855011]  [<ffffffff8021207f>] ? child_rip+0x0/0x11
[   10.860163] Testing a backtrace from irq context.
[   10.864887] The following trace is a kernel self test and not a bug!
[   10.871258] Pid: 6, comm: ksoftirqd/1 Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[   10.879357] Call Trace:
[   10.881824]  <IRQ>  [<ffffffff80270b89>] backtrace_test_irq_callback+0xe/0x1c
[   10.889004]  [<ffffffff80250213>] tasklet_action+0x83/0xec
[   10.894502]  [<ffffffff8021256c>] ? call_softirq+0x1c/0x28
[   10.900002]  [<ffffffff8024fe84>] __do_softirq+0x6f/0xc5
[   10.905328]  [<ffffffff8024fad0>] ? ksoftirqd+0x0/0xb8
[   10.910480]  [<ffffffff8021256c>] call_softirq+0x1c/0x28
[   10.915805]  <EOI>  [<ffffffff80214bc4>] do_softirq+0x49/0x91
[   10.921601]  [<ffffffff8024fb18>] ksoftirqd+0x48/0xb8
[   10.926666]  [<ffffffff8025eecd>] kthread+0x4e/0x7d
[   10.931557]  [<ffffffff80212089>] child_rip+0xa/0x11
[   10.936535]  [<ffffffff8025ee7f>] ? kthread+0x0/0x7d
[   10.941514]  [<ffffffff8021207f>] ? child_rip+0x0/0x11
[   10.946671] Testing a saved backtrace.
[   10.950438] The following trace is a kernel self test and not a bug!
[   10.956802]  [<ffffffff8021cb47>] save_stack_trace+0x2f/0x50
[   10.962510]  [<ffffffff80270c72>] backtrace_regression_test+0xdb/0xfd
[   10.968996]  [<ffffffff8020a05c>] do_one_initcall+0x4c/0x151
[   10.974702]  [<ffffffff81261a19>] kernel_init+0x1ba/0x22b
[   10.980150]  [<ffffffff80212089>] child_rip+0xa/0x11
[   10.985167]  [<ffffffffffffffff>] 0xffffffffffffffff
[   10.990181] ====[ end of backtrace testing ]====
[   10.994812] initcall backtrace_regression_test+0x0/0xfd returned 0 after 255 msecs
[   11.002432] calling  pid_namespaces_init+0x0/0x2d
[   11.007158] initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 msecs
[   11.014079] calling  audit_init+0x0/0x101
[   11.018105] audit: initializing netlink socket (disabled)
[   11.023547] type=2000 audit(1221047986.020:1): initialized
[   11.029051] audit: cannot initialize inotify handle
[   11.033945] initcall audit_init+0x0/0x101 returned 0 after 15 msecs
[   11.040256] calling  rcu_torture_init+0x0/0x627
[   11.044803] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[   11.059032] initcall rcu_torture_init+0x0/0x627 returned 0 after 13 msecs
[   11.065873] usb usb5: suspend_rh (auto-stop)
[   11.070170] calling  utsname_sysctl_init+0x0/0x14
[   11.074892] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 msecs
[   11.081813] calling  init_lstats_procfs+0x0/0x25
[   11.086453] initcall init_lstats_procfs+0x0/0x25 returned 0 after 0 msecs
[   11.093287] calling  init_sched_switch_trace+0x0/0x41
[   11.098354] initcall init_sched_switch_trace+0x0/0x41 returned 0 after 0 msecs
[   11.105626] calling  init_stack_trace+0x0/0x12
[   11.110084] initcall init_stack_trace+0x0/0x12 returned 0 after 0 msecs
[   11.116745] calling  init_function_trace+0x0/0x12
[   11.121468] initcall init_function_trace+0x0/0x12 returned 0 after 0 msecs
[   11.128388] calling  stack_trace_init+0x0/0x84
[   11.132868] initcall stack_trace_init+0x0/0x84 returned 0 after 0 msecs
[   11.139526] calling  init_mmio_trace+0x0/0x12
[   11.143899] initcall init_mmio_trace+0x0/0x12 returned 0 after 0 msecs
[   11.150473] calling  init_per_zone_pages_min+0x0/0x45
[   11.155655] initcall init_per_zone_pages_min+0x0/0x45 returned 0 after 0 msecs
[   11.162925] calling  pdflush_init+0x0/0x1d
[   11.167144] initcall pdflush_init+0x0/0x1d returned 0 after 0 msecs
[   11.173459] calling  kswapd_init+0x0/0x4c
[   11.177549] initcall kswapd_init+0x0/0x4c returned 0 after 0 msecs
[   11.183775] calling  setup_vmstat+0x0/0x44
[   11.187890] initcall setup_vmstat+0x0/0x44 returned 0 after 0 msecs
[   11.194206] calling  mm_sysfs_init+0x0/0x29
[   11.198410] initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 msecs
[   11.204812] calling  procswaps_init+0x0/0x22
[   11.209103] initcall procswaps_init+0x0/0x22 returned 0 after 0 msecs
[   11.215588] calling  hugetlb_init+0x0/0x2a4
[   11.219791] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.226171] initcall hugetlb_init+0x0/0x2a4 returned 0 after 6 msecs
[   11.232572] calling  init_tmpfs+0x0/0xda
[   11.236582] initcall init_tmpfs+0x0/0xda returned 0 after 0 msecs
[   11.242720] calling  slab_sysfs_init+0x0/0xf0
[   11.260500] initcall slab_sysfs_init+0x0/0xf0 returned 0 after 12 msecs
[   11.267164] calling  fasync_init+0x0/0x2a
[   11.271351] initcall fasync_init+0x0/0x2a returned 0 after 0 msecs
[   11.277582] calling  aio_setup+0x0/0x73
[   11.281849] initcall aio_setup+0x0/0x73 returned 0 after 0 msecs
[   11.287902] calling  init_sys32_ioctl+0x0/0x7c
[   11.292375] initcall init_sys32_ioctl+0x0/0x7c returned 0 after 0 msecs
[   11.299034] calling  init_mbcache+0x0/0x14
[   11.303147] initcall init_mbcache+0x0/0x14 returned 0 after 0 msecs
[   11.309461] calling  dnotify_init+0x0/0x2a
[   11.313725] initcall dnotify_init+0x0/0x2a returned 0 after 0 msecs
[   11.320037] calling  vmcore_init+0x0/0x8b5
[   11.324150] initcall vmcore_init+0x0/0x8b5 returned 0 after 0 msecs
[   11.330464] calling  configfs_init+0x0/0xb3
[   11.334842] initcall configfs_init+0x0/0xb3 returned 0 after 0 msecs
[   11.341245] calling  init_devpts_fs+0x0/0x40
[   11.345586] initcall init_devpts_fs+0x0/0x40 returned 0 after 0 msecs
[   11.352071] calling  init_dlm+0x0/0x88
[   11.356055] device: 'dlm-control': device_add
[   11.360453] PM: Adding info for No Bus:dlm-control
[   11.365373] device: 'dlm_plock': device_add
[   11.369591] PM: Adding info for No Bus:dlm_plock
[   11.374313] DLM (built Sep 10 2008 13:51:24) installed
[   11.379471] initcall init_dlm+0x0/0x88 returned 0 after 22 msecs
[   11.385527] calling  init_reiserfs_fs+0x0/0x95
[   11.390154] initcall init_reiserfs_fs+0x0/0x95 returned 0 after 0 msecs
[   11.396817] calling  init_ext3_fs+0x0/0x6a
[   11.401239] initcall init_ext3_fs+0x0/0x6a returned 0 after 0 msecs
[   11.407552] calling  journal_init+0x0/0x93
[   11.412264] initcall journal_init+0x0/0x93 returned 0 after 0 msecs
[   11.418580] calling  init_ext2_fs+0x0/0x5b
[   11.422844] initcall init_ext2_fs+0x0/0x5b returned 0 after 0 msecs
[   11.429160] calling  init_cramfs_fs+0x0/0x31
[   11.433467] initcall init_cramfs_fs+0x0/0x31 returned 0 after 0 msecs
[   11.439953] calling  init_ramfs_fs+0x0/0x12
[   11.444154] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 msecs
[   11.450556] calling  init_hugetlbfs_fs+0x0/0x98
[   11.455301] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 msecs
[   11.462052] calling  init_coda+0x0/0x13c
[   11.466154] device class 'coda': registering
[   11.470542] device: 'cfs0': device_add
[   11.474326] PM: Adding info for No Bus:cfs0
[   11.478625] device: 'cfs1': device_add
[   11.482416] PM: Adding info for No Bus:cfs1
[   11.489282] device: 'cfs2': device_add
[   11.493071] PM: Adding info for No Bus:cfs2
[   11.497364] device: 'cfs3': device_add
[   11.501151] PM: Adding info for No Bus:cfs3
[   11.505445] device: 'cfs4': device_add
[   11.509228] PM: Adding info for No Bus:cfs4
[   11.513526] initcall init_coda+0x0/0x13c returned 0 after 45 msecs
[   11.519754] calling  init_fat_fs+0x0/0x4f
[   11.524074] initcall init_fat_fs+0x0/0x4f returned 0 after 0 msecs
[   11.530304] calling  init_msdos_fs+0x0/0x12
[   11.534505] initcall init_msdos_fs+0x0/0x12 returned 0 after 0 msecs
[   11.540907] calling  init_hfsplus_fs+0x0/0x5d
[   11.545431] initcall init_hfsplus_fs+0x0/0x5d returned 0 after 0 msecs
[   11.552005] calling  init_hfs_fs+0x0/0x5d
[   11.556187] initcall init_hfs_fs+0x0/0x5d returned 0 after 0 msecs
[   11.562416] calling  vxfs_init+0x0/0x59
[   11.566423] initcall vxfs_init+0x0/0x59 returned 0 after 0 msecs
[   11.572479] calling  init_nfs_fs+0x0/0x113
[   11.577533] initcall init_nfs_fs+0x0/0x113 returned 0 after 0 msecs
[   11.583846] calling  init_nfsd+0x0/0xbb
[   11.587699] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.594866] initcall init_nfsd+0x0/0xbb returned 0 after 6 msecs
[   11.600922] calling  init_nlm+0x0/0x22
[   11.604690] initcall init_nlm+0x0/0x22 returned 0 after 0 msecs
[   11.610657] calling  init_nls_cp437+0x0/0x12
[   11.614948] initcall init_nls_cp437+0x0/0x12 returned 0 after 0 msecs
[   11.621436] calling  init_nls_cp737+0x0/0x12
[   11.625723] initcall init_nls_cp737+0x0/0x12 returned 0 after 0 msecs
[   11.632208] calling  init_nls_cp852+0x0/0x12
[   11.636498] initcall init_nls_cp852+0x0/0x12 returned 0 after 0 msecs
[   11.642983] calling  init_nls_cp855+0x0/0x12
[   11.647271] initcall init_nls_cp855+0x0/0x12 returned 0 after 0 msecs
[   11.653758] calling  init_nls_cp857+0x0/0x12
[   11.658044] initcall init_nls_cp857+0x0/0x12 returned 0 after 0 msecs
[   11.664531] calling  init_nls_cp863+0x0/0x12
[   11.668818] initcall init_nls_cp863+0x0/0x12 returned 0 after 0 msecs
[   11.675302] calling  init_nls_cp865+0x0/0x12
[   11.679589] initcall init_nls_cp865+0x0/0x12 returned 0 after 0 msecs
[   11.686076] calling  init_nls_cp866+0x0/0x12
[   11.690362] initcall init_nls_cp866+0x0/0x12 returned 0 after 0 msecs
[   11.696850] calling  init_nls_cp869+0x0/0x12
[   11.701136] initcall init_nls_cp869+0x0/0x12 returned 0 after 0 msecs
[   11.707621] calling  init_nls_cp874+0x0/0x12
[   11.711908] initcall init_nls_cp874+0x0/0x12 returned 0 after 0 msecs
[   11.718396] calling  init_nls_cp932+0x0/0x12
[   11.722682] initcall init_nls_cp932+0x0/0x12 returned 0 after 0 msecs
[   11.729169] calling  init_nls_euc_jp+0x0/0x48
[   11.733542] initcall init_nls_euc_jp+0x0/0x48 returned 0 after 0 msecs
[   11.740114] calling  init_nls_cp936+0x0/0x12
[   11.744401] initcall init_nls_cp936+0x0/0x12 returned 0 after 0 msecs
[   11.750885] calling  init_nls_cp949+0x0/0x12
[   11.755172] initcall init_nls_cp949+0x0/0x12 returned 0 after 0 msecs
[   11.761660] calling  init_nls_cp950+0x0/0x12
[   11.765946] initcall init_nls_cp950+0x0/0x12 returned 0 after 0 msecs
[   11.772433] calling  init_nls_cp1250+0x0/0x12
[   11.776805] initcall init_nls_cp1250+0x0/0x12 returned 0 after 0 msecs
[   11.783375] calling  init_nls_cp1251+0x0/0x12
[   11.787748] initcall init_nls_cp1251+0x0/0x12 returned 0 after 0 msecs
[   11.794321] calling  init_nls_ascii+0x0/0x12
[   11.798608] initcall init_nls_ascii+0x0/0x12 returned 0 after 0 msecs
[   11.805095] calling  init_nls_iso8859_1+0x0/0x12
[   11.809726] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 msecs
[   11.816367] hub 3-0:1.0: hub_suspend
[   11.816374] usb usb3: bus auto-suspend
[   11.816376] usb usb3: suspend_rh
[   11.816395] hub 4-0:1.0: hub_suspend
[   11.816398] usb usb4: bus auto-suspend
[   11.816400] usb usb4: suspend_rh
[   11.837746] calling  init_nls_iso8859_2+0x0/0x12
[   11.842380] initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 msecs
[   11.849215] calling  init_nls_iso8859_3+0x0/0x12
[   11.853849] initcall init_nls_iso8859_3+0x0/0x12 returned 0 after 0 msecs
[   11.860684] calling  init_nls_iso8859_5+0x0/0x12
[   11.865318] initcall init_nls_iso8859_5+0x0/0x12 returned 0 after 0 msecs
[   11.872150] calling  init_nls_iso8859_6+0x0/0x12
[   11.876782] initcall init_nls_iso8859_6+0x0/0x12 returned 0 after 0 msecs
[   11.883613] calling  init_nls_iso8859_7+0x0/0x12
[   11.888245] initcall init_nls_iso8859_7+0x0/0x12 returned 0 after 0 msecs
[   11.895083] calling  init_nls_cp1255+0x0/0x12
[   11.899456] initcall init_nls_cp1255+0x0/0x12 returned 0 after 0 msecs
[   11.906031] calling  init_nls_iso8859_13+0x0/0x12
[   11.910750] initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 0 msecs
[   11.917670] calling  init_nls_iso8859_14+0x0/0x12
[   11.922390] initcall init_nls_iso8859_14+0x0/0x12 returned 0 after 0 msecs
[   11.929311] calling  init_nls_koi8_u+0x0/0x12
[   11.933683] initcall init_nls_koi8_u+0x0/0x12 returned 0 after 0 msecs
[   11.940253] calling  init_nls_koi8_ru+0x0/0x48
[   11.944712] initcall init_nls_koi8_ru+0x0/0x48 returned 0 after 0 msecs
[   11.951371] calling  init_nls_utf8+0x0/0x25
[   11.955572] initcall init_nls_utf8+0x0/0x25 returned 0 after 0 msecs
[   11.961973] calling  init_sysv_fs+0x0/0x4f
[   11.966255] initcall init_sysv_fs+0x0/0x4f returned 0 after 0 msecs
[   11.972570] calling  init_smb_fs+0x0/0x6c
[   11.976368] hub 5-0:1.0: hub_suspend
[   11.976372] usb usb5: bus auto-suspend
[   11.976373] usb usb5: suspend_rh
[   11.987507] initcall init_smb_fs+0x0/0x6c returned 0 after 0 msecs
[   11.993736] calling  init_cifs+0x0/0x517
[   11.998810] initcall init_cifs+0x0/0x517 returned 0 after 1 msecs
[   12.004959] calling  init_hpfs_fs+0x0/0x5a
[   12.009229] initcall init_hpfs_fs+0x0/0x5a returned 0 after 0 msecs
[   12.015542] calling  init_ufs_fs+0x0/0x5a
[   12.019724] initcall init_ufs_fs+0x0/0x5a returned 0 after 0 msecs
[   12.025954] calling  init_affs_fs+0x0/0x5a
[   12.030222] initcall init_affs_fs+0x0/0x5a returned 0 after 0 msecs
[   12.036536] calling  init_autofs_fs+0x0/0x12
[   12.040824] initcall init_autofs_fs+0x0/0x12 returned 0 after 0 msecs
[   12.047308] calling  init_autofs4_fs+0x0/0x12
[   12.051682] initcall init_autofs4_fs+0x0/0x12 returned -16 after 0 msecs
[   12.058432] initcall init_autofs4_fs+0x0/0x12 returned with error code -16 
[   12.065437] calling  init_adfs_fs+0x0/0x5a
[   12.069705] initcall init_adfs_fs+0x0/0x5a returned 0 after 0 msecs
[   12.076017] calling  fuse_init+0x0/0x11f
[   12.079958] fuse init (API version 7.9)
[   12.084128] device: 'fuse': device_add
[   12.087914] PM: Adding info for No Bus:fuse
[   12.092218] initcall fuse_init+0x0/0x11f returned 0 after 11 msecs
[   12.098447] calling  init_udf_fs+0x0/0x5a
[   12.102628] initcall init_udf_fs+0x0/0x5a returned 0 after 0 msecs
[   12.108857] calling  init_jfs_fs+0x0/0x2b0
[   12.113309] JFS: nTxBlock = 7438, nTxLock = 59505
[   12.123668] initcall init_jfs_fs+0x0/0x2b0 returned 0 after 10 msecs
[   12.130079] calling  init_xfs_fs+0x0/0xa9
[   12.134105] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   12.146962] SGI XFS Quota Management subsystem
[   12.151443] initcall init_xfs_fs+0x0/0xa9 returned 0 after 16 msecs
[   12.157761] calling  ocfs2_init+0x0/0x29c
[   12.161785] OCFS2 1.5.0
[   12.164680] initcall ocfs2_init+0x0/0x29c returned 0 after 2 msecs
[   12.170907] calling  ocfs2_stack_glue_init+0x0/0x95
[   12.175827] initcall ocfs2_stack_glue_init+0x0/0x95 returned 0 after 0 msecs
[   12.182919] calling  o2cb_stack_init+0x0/0x12
[   12.187292] ocfs2: Registered cluster interface o2cb
[   12.192276] initcall o2cb_stack_init+0x0/0x12 returned 0 after 4 msecs
[   12.198849] calling  init_o2nm+0x0/0x9a
[   12.202702] OCFS2 Node Manager 1.5.0
[   12.206629] initcall init_o2nm+0x0/0x9a returned 0 after 3 msecs
[   12.212685] calling  dlm_init+0x0/0x233
[   12.216537] OCFS2 DLM 1.5.0
[   12.219982] initcall dlm_init+0x0/0x233 returned 0 after 3 msecs
[   12.226054] calling  init_dlmfs_fs+0x0/0xd3
[   12.230253] OCFS2 DLMFS 1.5.0
[   12.233472] OCFS2 User DLM kernel interface loaded
[   12.238279] initcall init_dlmfs_fs+0x0/0xd3 returned 0 after 7 msecs
[   12.244681] calling  key_proc_init+0x0/0x33
[   12.248890] initcall key_proc_init+0x0/0x33 returned 0 after 0 msecs
[   12.255288] calling  crypto_algapi_init+0x0/0xd
[   12.259839] initcall crypto_algapi_init+0x0/0xd returned 0 after 0 msecs
[   12.266585] calling  blkcipher_module_init+0x0/0x2a
[   12.271480] initcall blkcipher_module_init+0x0/0x2a returned 0 after 0 msecs
[   12.278573] calling  seqiv_module_init+0x0/0x12
[   12.283119] initcall seqiv_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.289865] calling  cryptomgr_init+0x0/0x12
[   12.294151] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 msecs
[   12.300639] calling  hmac_module_init+0x0/0x12
[   12.305109] initcall hmac_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.311767] calling  crypto_null_mod_init+0x0/0x7b
[   12.316578] initcall crypto_null_mod_init+0x0/0x7b returned 0 after 0 msecs
[   12.323583] calling  md4_mod_init+0x0/0x12
[   12.327697] initcall md4_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.334011] calling  md5_mod_init+0x0/0x12
[   12.338124] initcall md5_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.344438] calling  rmd160_mod_init+0x0/0x12
[   12.348813] initcall rmd160_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.355385] calling  rmd256_mod_init+0x0/0x12
[   12.359759] initcall rmd256_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.366332] calling  sha1_generic_mod_init+0x0/0x12
[   12.371226] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.378320] calling  sha512_generic_mod_init+0x0/0x3f
[   12.383389] initcall sha512_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
[   12.390661] calling  tgr192_mod_init+0x0/0x64
[   12.395037] initcall tgr192_mod_init+0x0/0x64 returned 0 after 0 msecs
[   12.401612] calling  crypto_ecb_module_init+0x0/0x12
[   12.406596] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.413776] calling  crypto_cbc_module_init+0x0/0x12
[   12.418756] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.425936] calling  crypto_pcbc_module_init+0x0/0x12
[   12.431001] initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.440827] calling  crypto_cts_module_init+0x0/0x12
[   12.445806] initcall crypto_cts_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.452986] calling  crypto_module_init+0x0/0x12
[   12.457618] initcall crypto_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.464452] calling  crypto_module_init+0x0/0x12
[   12.469085] initcall crypto_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.475916] calling  crypto_ctr_module_init+0x0/0x3f
[   12.480898] initcall crypto_ctr_module_init+0x0/0x3f returned 0 after 0 msecs
[   12.488074] calling  crypto_gcm_module_init+0x0/0x5d
[   12.493057] initcall crypto_gcm_module_init+0x0/0x5d returned 0 after 0 msecs
[   12.500234] calling  crypto_ccm_module_init+0x0/0x5d
[   12.505219] initcall crypto_ccm_module_init+0x0/0x5d returned 0 after 0 msecs
[   12.512399] calling  des_generic_mod_init+0x0/0x3f
[   12.517207] initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
[   12.524210] calling  fcrypt_mod_init+0x0/0x12
[   12.528584] initcall fcrypt_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.535154] calling  blowfish_mod_init+0x0/0x12
[   12.539701] initcall blowfish_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.546448] calling  twofish_mod_init+0x0/0x12
[   12.550909] initcall twofish_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.557570] calling  serpent_mod_init+0x0/0x3f
[   12.562033] initcall serpent_mod_init+0x0/0x3f returned 0 after 0 msecs
[   12.568694] calling  aes_init+0x0/0x2ce
[   12.572562] initcall aes_init+0x0/0x2ce returned 0 after 0 msecs
[   12.578614] calling  cast5_mod_init+0x0/0x12
[   12.582901] initcall cast5_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.589388] calling  cast6_mod_init+0x0/0x12
[   12.593676] initcall cast6_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.600160] calling  arc4_init+0x0/0x12
[   12.604015] initcall arc4_init+0x0/0x12 returned 0 after 0 msecs
[   12.610070] calling  tea_mod_init+0x0/0x64
[   12.614186] initcall tea_mod_init+0x0/0x64 returned 0 after 0 msecs
[   12.620500] calling  seed_init+0x0/0x12
[   12.624351] initcall seed_init+0x0/0x12 returned 0 after 0 msecs
[   12.630406] calling  salsa20_generic_mod_init+0x0/0x12
[   12.635560] initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.642915] calling  michael_mic_init+0x0/0x12
[   12.647377] initcall michael_mic_init+0x0/0x12 returned 0 after 0 msecs
[   12.654038] calling  crc32c_mod_init+0x0/0x3f
[   12.658412] initcall crc32c_mod_init+0x0/0x3f returned 0 after 0 msecs
[   12.664991] calling  crypto_authenc_module_init+0x0/0x12
[   12.670319] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 msecs
[   12.677850] calling  lzo_mod_init+0x0/0x12
[   12.681964] initcall lzo_mod_init+0x0/0x12 returned 0 after 0 msecs
[   12.688274] calling  bsg_init+0x0/0x126
[   12.692287] device class 'bsg': registering
[   12.696593] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[   12.704001] initcall bsg_init+0x0/0x126 returned 0 after 11 msecs
[   12.710144] calling  noop_init+0x0/0x14
[   12.714001] io scheduler noop registered
[   12.717940] initcall noop_init+0x0/0x14 returned 0 after 3 msecs
[   12.723992] calling  as_init+0x0/0x14
[   12.727671] io scheduler anticipatory registered
[   12.732302] initcall as_init+0x0/0x14 returned 0 after 4 msecs
[   12.738182] calling  cfq_init+0x0/0x94
[   12.742263] io scheduler cfq registered (default)
[   12.746985] initcall cfq_init+0x0/0x94 returned 0 after 4 msecs
[   12.752953] calling  init_kmp+0x0/0x12
[   12.756725] initcall init_kmp+0x0/0x12 returned 0 after 0 msecs
[   12.762692] calling  init_bm+0x0/0x12
[   12.766371] initcall init_bm+0x0/0x12 returned 0 after 0 msecs
[   12.772249] calling  init_fsm+0x0/0x12
[   12.776015] initcall init_fsm+0x0/0x12 returned 0 after 0 msecs
[   12.781983] calling  percpu_counter_startup+0x0/0x14
[   12.786965] initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
[   12.794144] calling  pci_proc_init+0x0/0x6a
[   12.798530] initcall pci_proc_init+0x0/0x6a returned 0 after 0 msecs
[   12.804933] calling  pcie_portdrv_init+0x0/0x4c
[   12.809599] bus: 'pci_express': registered
[   12.813714] bus: 'pci': add driver pcieport-driver
[   12.818529] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pcieport-driver
[   12.827670] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:01.0
[   12.836225] pcieport-driver 0000:00:01.0: setting latency timer to 64
[   12.842713] pcieport-driver 0000:00:01.0: found MSI capability
[   12.848560] pci_express 0000:00:01.0:pcie00: allocate port service
[   12.854753] device: '0000:00:01.0:pcie00': device_add
[   12.859825] bus: 'pci_express': add device 0000:00:01.0:pcie00
[   12.865681] PM: Adding info for pci_express:0000:00:01.0:pcie00
[   12.871714] pci_express 0000:00:01.0:pcie03: allocate port service
[   12.877907] device: '0000:00:01.0:pcie03': device_add
[   12.882980] bus: 'pci_express': add device 0000:00:01.0:pcie03
[   12.888844] PM: Adding info for pci_express:0000:00:01.0:pcie03
[   12.894912] driver: '0000:00:01.0': driver_bound: bound to device 'pcieport-driver'
[   12.902582] bus: 'pci': really_probe: bound device 0000:00:01.0 to driver pcieport-driver
[   12.910773] bus: 'pci': driver_probe_device: matched device 0000:00:1c.0 with driver pcieport-driver
[   12.919918] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.0
[   12.928467] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[   12.934952] pcieport-driver 0000:00:1c.0: found MSI capability
[   12.940799] pci_express 0000:00:1c.0:pcie00: allocate port service
[   12.946991] device: '0000:00:1c.0:pcie00': device_add
[   12.952061] bus: 'pci_express': add device 0000:00:1c.0:pcie00
[   12.957922] PM: Adding info for pci_express:0000:00:1c.0:pcie00
[   12.963952] pci_express 0000:00:1c.0:pcie02: allocate port service
[   12.970146] device: '0000:00:1c.0:pcie02': device_add
[   12.975224] bus: 'pci_express': add device 0000:00:1c.0:pcie02
[   12.981080] PM: Adding info for pci_express:0000:00:1c.0:pcie02
[   12.987111] pci_express 0000:00:1c.0:pcie03: allocate port service
[   12.993304] device: '0000:00:1c.0:pcie03': device_add
[   12.998375] bus: 'pci_express': add device 0000:00:1c.0:pcie03
[   13.004231] PM: Adding info for pci_express:0000:00:1c.0:pcie03
[   13.010302] driver: '0000:00:1c.0': driver_bound: bound to device 'pcieport-driver'
[   13.017972] bus: 'pci': really_probe: bound device 0000:00:1c.0 to driver pcieport-driver
[   13.026161] bus: 'pci': driver_probe_device: matched device 0000:00:1c.4 with driver pcieport-driver
[   13.035301] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.4
[   13.043850] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[   13.050335] pcieport-driver 0000:00:1c.4: found MSI capability
[   13.056181] pci_express 0000:00:1c.4:pcie00: allocate port service
[   13.062373] device: '0000:00:1c.4:pcie00': device_add
[   13.067444] bus: 'pci_express': add device 0000:00:1c.4:pcie00
[   13.073305] PM: Adding info for pci_express:0000:00:1c.4:pcie00
[   13.079335] pci_express 0000:00:1c.4:pcie02: allocate port service
[   13.085528] device: '0000:00:1c.4:pcie02': device_add
[   13.090598] bus: 'pci_express': add device 0000:00:1c.4:pcie02
[   13.096454] PM: Adding info for pci_express:0000:00:1c.4:pcie02
[   13.102483] pci_express 0000:00:1c.4:pcie03: allocate port service
[   13.108676] device: '0000:00:1c.4:pcie03': device_add
[   13.113747] bus: 'pci_express': add device 0000:00:1c.4:pcie03
[   13.119602] PM: Adding info for pci_express:0000:00:1c.4:pcie03
[   13.125671] driver: '0000:00:1c.4': driver_bound: bound to device 'pcieport-driver'
[   13.133340] bus: 'pci': really_probe: bound device 0000:00:1c.4 to driver pcieport-driver
[   13.141530] bus: 'pci': driver_probe_device: matched device 0000:00:1c.5 with driver pcieport-driver
[   13.150669] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.5
[   13.159219] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[   13.165703] pcieport-driver 0000:00:1c.5: found MSI capability
[   13.171551] pci_express 0000:00:1c.5:pcie00: allocate port service
[   13.177746] device: '0000:00:1c.5:pcie00': device_add
[   13.182817] bus: 'pci_express': add device 0000:00:1c.5:pcie00
[   13.188672] PM: Adding info for pci_express:0000:00:1c.5:pcie00
[   13.194702] pci_express 0000:00:1c.5:pcie02: allocate port service
[   13.200895] device: '0000:00:1c.5:pcie02': device_add
[   13.205969] bus: 'pci_express': add device 0000:00:1c.5:pcie02
[   13.211832] PM: Adding info for pci_express:0000:00:1c.5:pcie02
[   13.217861] pci_express 0000:00:1c.5:pcie03: allocate port service
[   13.224055] device: '0000:00:1c.5:pcie03': device_add
[   13.229126] bus: 'pci_express': add device 0000:00:1c.5:pcie03
[   13.234982] PM: Adding info for pci_express:0000:00:1c.5:pcie03
[   13.241051] driver: '0000:00:1c.5': driver_bound: bound to device 'pcieport-driver'
[   13.248720] bus: 'pci': really_probe: bound device 0000:00:1c.5 to driver pcieport-driver
[   13.257030] initcall pcie_portdrv_init+0x0/0x4c returned 0 after 426 msecs
[   13.263949] calling  aer_service_init+0x0/0x20
[   13.268408] bus: 'pci_express': add driver aer
[   13.272981] initcall aer_service_init+0x0/0x20 returned 0 after 4 msecs
[   13.279640] calling  pci_hotplug_init+0x0/0x4e
[   13.284100] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.289686] initcall pci_hotplug_init+0x0/0x4e returned 0 after 5 msecs
[   13.296344] calling  acpiphp_init+0x0/0x5f
[   13.300456] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   13.311196] acpiphp_glue: can't get bus number, assuming 0
[   13.317093] initcall acpiphp_init+0x0/0x5f returned -19 after 15 msecs
[   13.323664] calling  ibm_acpiphp_init+0x0/0x16f
[   13.332407] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[   13.338862] initcall ibm_acpiphp_init+0x0/0x16f returned -19 after 10 msecs
[   13.345870] calling  zt5550_init+0x0/0x7c
[   13.349896] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   13.356695] bus: 'pci': add driver zt5550_hc
[   13.361113] initcall zt5550_init+0x0/0x7c returned 0 after 10 msecs
[   13.367425] calling  cpcihp_generic_init+0x0/0x426
[   13.372230] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[   13.379985] cpcihp_generic: not configured, disabling.
[   13.387694] initcall cpcihp_generic_init+0x0/0x426 returned -22 after 14 msecs
[   13.394964] initcall cpcihp_generic_init+0x0/0x426 returned with error code -22 
[   13.402407] calling  pcied_init+0x0/0x7b
[   13.406346] bus: 'pci_express': add driver hpdriver
[   13.411247] bus: 'pci_express': driver_probe_device: matched device 0000:00:1c.0:pcie02 with driver hpdriver
[   13.421081] bus: 'pci_express': really_probe: probing driver hpdriver with device 0000:00:1c.0:pcie02
[   13.430441] bus: 'pci_express': driver_probe_device: matched device 0000:00:1c.4:pcie02 with driver hpdriver
[   13.440280] bus: 'pci_express': really_probe: probing driver hpdriver with device 0000:00:1c.4:pcie02
[   13.449625] bus: 'pci_express': driver_probe_device: matched device 0000:00:1c.5:pcie02 with driver hpdriver
[   13.459459] bus: 'pci_express': really_probe: probing driver hpdriver with device 0000:00:1c.5:pcie02
[   13.468899] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   13.475527] initcall pcied_init+0x0/0x7b returned 0 after 65 msecs
[   13.481753] calling  shpcd_init+0x0/0x62
[   13.485692] bus: 'pci': add driver shpchp
[   13.489847] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.496561] initcall shpcd_init+0x0/0x62 returned 0 after 10 msecs
[   13.502785] calling  dummyphp_init+0x0/0x97
[   13.506983] fakephp: Fake PCI Hot Plug Controller Driver
[   13.512380] pci_create_slot: created pci_slot on 0000:00:00
[   13.518080] pci_create_slot: created pci_slot on 0000:00:01
[   13.523770] pci_create_slot: created pci_slot on 0000:00:1b
[   13.529462] pci_create_slot: created pci_slot on 0000:00:1c
[   13.535156] pci_create_slot: created pci_slot on 0000:00:1d
[   13.540855] pci_create_slot: created pci_slot on 0000:00:1e
[   13.546551] pci_create_slot: created pci_slot on 0000:00:1f
[   13.552256] pci_create_slot: created pci_slot on 0000:01:00
[   13.557950] pci_create_slot: created pci_slot on 0000:02:00
[   13.563641] pci_create_slot: created pci_slot on 0000:04:00
[   13.569333] pci_create_slot: created pci_slot on 0000:05:02
[   13.575033] pci_create_slot: created pci_slot on 0000:05:04
[   13.580722] pci_create_slot: created pci_slot on 0000:05:05
[   13.586406] initcall dummyphp_init+0x0/0x97 returned 0 after 75 msecs
[   13.592896] calling  corgibl_init+0x0/0x12
[   13.597010] bus: 'platform': add driver generic-bl
[   13.601920] initcall corgibl_init+0x0/0x12 returned 0 after 4 msecs
[   13.608232] calling  mbp_init+0x0/0xe3
[   13.611999] initcall mbp_init+0x0/0xe3 returned -19 after 0 msecs
[   13.618141] calling  display_class_init+0x0/0x7e
[   13.622773] device class 'display': registering
[   13.627417] initcall display_class_init+0x0/0x7e returned 0 after 4 msecs
[   13.634253] calling  arcfb_init+0x0/0x74
[   13.638192] initcall arcfb_init+0x0/0x74 returned -6 after 0 msecs
[   13.644419] initcall arcfb_init+0x0/0x74 returned with error code -6 
[   13.650908] calling  pm2fb_init+0x0/0x159
[   13.654936] bus: 'pci': add driver pm2fb
[   13.659010] initcall pm2fb_init+0x0/0x159 returned 0 after 3 msecs
[   13.665240] calling  pm3fb_init+0x0/0x115
[   13.669267] bus: 'pci': add driver pm3fb
[   13.673334] initcall pm3fb_init+0x0/0x115 returned 0 after 3 msecs
[   13.679561] calling  matroxfb_init+0x0/0x9b3
[   13.683848] bus: 'pci': add driver matroxfb
[   13.688177] initcall matroxfb_init+0x0/0x9b3 returned 0 after 4 msecs
[   13.694670] calling  rivafb_init+0x0/0x1e1
[   13.698783] rivafb_setup START
[   13.701856] bus: 'pci': add driver rivafb
[   13.706014] initcall rivafb_init+0x0/0x1e1 returned 0 after 6 msecs
[   13.712326] calling  nvidiafb_init+0x0/0x2c3
[   13.716614] bus: 'pci': add driver nvidiafb
[   13.720938] initcall nvidiafb_init+0x0/0x2c3 returned 0 after 4 msecs
[   13.727425] calling  sisfb_init+0x0/0x7dd
[   13.731452] bus: 'pci': add driver sisfb
[   13.735526] initcall sisfb_init+0x0/0x7dd returned 0 after 3 msecs
[   13.741756] calling  kyrofb_init+0x0/0xf6
[   13.745783] bus: 'pci': add driver kyrofb
[   13.749949] initcall kyrofb_init+0x0/0xf6 returned 0 after 3 msecs
[   13.756175] calling  savagefb_init+0x0/0x77
[   13.760374] bus: 'pci': add driver savagefb
[   13.764710] initcall savagefb_init+0x0/0x77 returned 0 after 4 msecs
[   13.771110] calling  gx1fb_init+0x0/0x130
[   13.775138] bus: 'pci': add driver gx1fb
[   13.779206] initcall gx1fb_init+0x0/0x130 returned 0 after 3 msecs
[   13.785435] calling  gxfb_init+0x0/0x84
[   13.789289] bus: 'pci': add driver gxfb
[   13.793270] initcall gxfb_init+0x0/0x84 returned 0 after 3 msecs
[   13.799323] calling  tdfxfb_init+0x0/0x12f
[   13.803436] bus: 'pci': add driver tdfxfb
[   13.807598] initcall tdfxfb_init+0x0/0x12f returned 0 after 3 msecs
[   13.813914] calling  tridentfb_init+0x0/0x21c
[   13.818286] bus: 'pci': add driver tridentfb
[   13.822703] initcall tridentfb_init+0x0/0x21c returned 0 after 4 msecs
[   13.829278] calling  vmlfb_init+0x0/0x96
[   13.833216] vmlfb: initializing
[   13.836374] bus: 'pci': add driver vmlfb
[   13.840443] initcall vmlfb_init+0x0/0x96 returned 0 after 6 msecs
[   13.846586] calling  s3fb_init+0x0/0xf4
[   13.850439] bus: 'pci': add driver s3fb
[   13.854422] initcall s3fb_init+0x0/0xf4 returned 0 after 3 msecs
[   13.860478] calling  arkfb_init+0x0/0x59
[   13.864414] bus: 'pci': add driver arkfb
[   13.868486] initcall arkfb_init+0x0/0x59 returned 0 after 3 msecs
[   13.874627] calling  hgafb_init+0x0/0x6b
[   13.878565] bus: 'platform': add driver hgafb
[   13.883051] Registering platform device 'hgafb.0'. Parent at platform
[   13.889504] device: 'hgafb.0': device_add
[   13.893537] bus: 'platform': add device hgafb.0
[   13.898095] PM: Adding info for platform:hgafb.0
[   13.902821] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[   13.911097] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[   13.918776] hgafb: HGA card not detected.
[   13.922810] hgafb: probe of hgafb.0 failed with error -22
[   13.928224] initcall hgafb_init+0x0/0x6b returned 0 after 47 msecs
[   13.934452] calling  xenfb_init+0x0/0x58
[   13.938391] initcall xenfb_init+0x0/0x58 returned -19 after 0 msecs
[   13.944708] calling  carminefb_init+0x0/0x39
[   13.948997] bus: 'pci': add driver carminefb
[   13.953412] initcall carminefb_init+0x0/0x39 returned 0 after 4 msecs
[   13.959898] calling  uvesafb_init+0x0/0x3e7
[   13.964103] bus: 'platform': add driver uvesafb
[   13.968754] Registering platform device 'uvesafb.0'. Parent at platform
[   13.975380] device: 'uvesafb.0': device_add
[   13.979585] bus: 'platform': add device uvesafb.0
[   13.984316] PM: Adding info for platform:uvesafb.0
[   13.989216] bus: 'platform': driver_probe_device: matched device uvesafb.0 with driver uvesafb
[   13.997839] bus: 'platform': really_probe: probing driver uvesafb with device uvesafb.0
[   14.005996] uvesafb: failed to execute /sbin/v86d
[   14.010717] uvesafb: make sure that the v86d helper is installed and executable
[   14.018042] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[   14.024668] uvesafb: vbe_init() failed with -22
[   14.029224] uvesafb: probe of uvesafb.0 failed with error -22
[   14.034988] initcall uvesafb_init+0x0/0x3e7 returned 0 after 67 msecs
[   14.041476] calling  imacfb_init+0x0/0x1de
[   14.045589] initcall imacfb_init+0x0/0x1de returned -19 after 0 msecs
[   14.052074] calling  acpi_reserve_resources+0x0/0xeb
[   14.057058] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 msecs
[   14.064236] calling  acpi_ac_init+0x0/0x45
[   14.068362] bus: 'acpi': add driver ac
[   14.072307] initcall acpi_ac_init+0x0/0x45 returned 0 after 3 msecs
[   14.078624] calling  acpi_fan_init+0x0/0x5e
[   14.082827] bus: 'acpi': add driver fan
[   14.086839] initcall acpi_fan_init+0x0/0x5e returned 0 after 3 msecs
[   14.093243] calling  irqrouter_init_sysfs+0x0/0x38
[   14.098047] Registering sysdev class 'irqrouter'
[   14.102777] Registering sys device of class 'irqrouter'
[   14.108020] Registering sys device 'irqrouter0'
[   14.112655] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 13 msecs
[   14.119748] calling  acpi_pci_slot_init+0x0/0x20
[   14.124867] initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 0 msecs
[   14.131700] calling  asus_acpi_init+0x0/0xfe
[   14.135992] bus: 'acpi': add driver asus_acpi
[   14.140535] bus: 'acpi': remove driver asus_acpi
[   14.145262] driver: 'asus_acpi': driver_release
[   14.149820] initcall asus_acpi_init+0x0/0xfe returned -19 after 13 msecs
[   14.156567] calling  toshiba_acpi_init+0x0/0x183
[   14.161209] initcall toshiba_acpi_init+0x0/0x183 returned -19 after 0 msecs
[   14.168218] calling  rand_initialize+0x0/0x31
[   14.172605] initcall rand_initialize+0x0/0x31 returned 0 after 0 msecs
[   14.179177] calling  tty_init+0x0/0x1cd
[   14.183035] device: 'tty': device_add
[   14.186738] PM: Adding info for No Bus:tty
[   14.190954] device: 'console': device_add
[   14.194998] PM: Adding info for No Bus:console
[   14.199554] device: 'ptmx': device_add
[   14.203351] PM: Adding info for No Bus:ptmx
[   14.207648] device: 'tty0': device_add
[   14.211433] PM: Adding info for No Bus:tty0
[   14.215728] device class 'vc': registering
[   14.219944] device: 'vcs': device_add
[   14.223641] PM: Adding info for No Bus:vcs
[   14.227854] device: 'vcsa': device_add
[   14.231644] PM: Adding info for No Bus:vcsa
[   14.235950] device: 'tty1': device_add
[   14.239735] PM: Adding info for No Bus:tty1
[   14.244028] device: 'tty2': device_add
[   14.247810] PM: Adding info for No Bus:tty2
[   14.252105] device: 'tty3': device_add
[   14.255887] PM: Adding info for No Bus:tty3
[   14.260180] device: 'tty4': device_add
[   14.266524] PM: Adding info for No Bus:tty4
[   14.270820] device: 'tty5': device_add
[   14.274602] PM: Adding info for No Bus:tty5
[   14.278896] device: 'tty6': device_add
[   14.282678] PM: Adding info for No Bus:tty6
[   14.286984] device: 'tty7': device_add
[   14.290769] PM: Adding info for No Bus:tty7
[   14.295062] device: 'tty8': device_add
[   14.298852] PM: Adding info for No Bus:tty8
[   14.303147] device: 'tty9': device_add
[   14.306938] PM: Adding info for No Bus:tty9
[   14.311231] device: 'tty10': device_add
[   14.315101] PM: Adding info for No Bus:tty10
[   14.319481] device: 'tty11': device_add
[   14.323357] PM: Adding info for No Bus:tty11
[   14.327738] device: 'tty12': device_add
[   14.331609] PM: Adding info for No Bus:tty12
[   14.335989] device: 'tty13': device_add
[   14.339859] PM: Adding info for No Bus:tty13
[   14.344240] device: 'tty14': device_add
[   14.348110] PM: Adding info for No Bus:tty14
[   14.352490] device: 'tty15': device_add
[   14.356370] PM: Adding info for No Bus:tty15
[   14.360751] device: 'tty16': device_add
[   14.364622] PM: Adding info for No Bus:tty16
[   14.369002] device: 'tty17': device_add
[   14.372873] PM: Adding info for No Bus:tty17
[   14.377253] device: 'tty18': device_add
[   14.381123] PM: Adding info for No Bus:tty18
[   14.385504] device: 'tty19': device_add
[   14.389380] PM: Adding info for No Bus:tty19
[   14.393761] device: 'tty20': device_add
[   14.397632] PM: Adding info for No Bus:tty20
[   14.402013] device: 'tty21': device_add
[   14.405892] PM: Adding info for No Bus:tty21
[   14.410273] device: 'tty22': device_add
[   14.414144] PM: Adding info for No Bus:tty22
[   14.418524] device: 'tty23': device_add
[   14.422401] PM: Adding info for No Bus:tty23
[   14.426782] device: 'tty24': device_add
[   14.430653] PM: Adding info for No Bus:tty24
[   14.435034] device: 'tty25': device_add
[   14.438905] PM: Adding info for No Bus:tty25
[   14.443285] device: 'tty26': device_add
[   14.447161] PM: Adding info for No Bus:tty26
[   14.451543] device: 'tty27': device_add
[   14.455421] PM: Adding info for No Bus:tty27
[   14.459802] device: 'tty28': device_add
[   14.463677] PM: Adding info for No Bus:tty28
[   14.468057] device: 'tty29': device_add
[   14.471928] PM: Adding info for No Bus:tty29
[   14.476309] device: 'tty30': device_add
[   14.480185] PM: Adding info for No Bus:tty30
[   14.484571] device: 'tty31': device_add
[   14.488438] PM: Adding info for No Bus:tty31
[   14.492820] device: 'tty32': device_add
[   14.496691] PM: Adding info for No Bus:tty32
[   14.501073] device: 'tty33': device_add
[   14.504943] PM: Adding info for No Bus:tty33
[   14.509323] device: 'tty34': device_add
[   14.513209] PM: Adding info for No Bus:tty34
[   14.517590] device: 'tty35': device_add
[   14.521461] PM: Adding info for No Bus:tty35
[   14.525858] device: 'tty36': device_add
[   14.529730] PM: Adding info for No Bus:tty36
[   14.534110] device: 'tty37': device_add
[   14.537988] PM: Adding info for No Bus:tty37
[   14.542368] device: 'tty38': device_add
[   14.546240] PM: Adding info for No Bus:tty38
[   14.550620] device: 'tty39': device_add
[   14.554491] PM: Adding info for No Bus:tty39
[   14.558871] device: 'tty40': device_add
[   14.562743] PM: Adding info for No Bus:tty40
[   14.567123] device: 'tty41': device_add
[   14.571000] PM: Adding info for No Bus:tty41
[   14.575381] device: 'tty42': device_add
[   14.579253] PM: Adding info for No Bus:tty42
[   14.583633] device: 'tty43': device_add
[   14.587504] PM: Adding info for No Bus:tty43
[   14.591884] device: 'tty44': device_add
[   14.595755] PM: Adding info for No Bus:tty44
[   14.600135] device: 'tty45': device_add
[   14.604014] PM: Adding info for No Bus:tty45
[   14.608394] device: 'tty46': device_add
[   14.612266] PM: Adding info for No Bus:tty46
[   14.616646] device: 'tty47': device_add
[   14.620527] PM: Adding info for No Bus:tty47
[   14.624908] device: 'tty48': device_add
[   14.628779] PM: Adding info for No Bus:tty48
[   14.633159] device: 'tty49': device_add
[   14.637037] PM: Adding info for No Bus:tty49
[   14.641418] device: 'tty50': device_add
[   14.645289] PM: Adding info for No Bus:tty50
[   14.649669] device: 'tty51': device_add
[   14.653541] PM: Adding info for No Bus:tty51
[   14.657921] device: 'tty52': device_add
[   14.661799] PM: Adding info for No Bus:tty52
[   14.666180] device: 'tty53': device_add
[   14.670052] PM: Adding info for No Bus:tty53
[   14.674432] device: 'tty54': device_add
[   14.678304] PM: Adding info for No Bus:tty54
[   14.682684] device: 'tty55': device_add
[   14.686570] PM: Adding info for No Bus:tty55
[   14.690951] device: 'tty56': device_add
[   14.694836] PM: Adding info for No Bus:tty56
[   14.699217] device: 'tty57': device_add
[   14.703090] PM: Adding info for No Bus:tty57
[   14.707470] device: 'tty58': device_add
[   14.711341] PM: Adding info for No Bus:tty58
[   14.715722] device: 'tty59': device_add
[   14.719597] PM: Adding info for No Bus:tty59
[   14.723977] device: 'tty60': device_add
[   14.727863] PM: Adding info for No Bus:tty60
[   14.732244] device: 'tty61': device_add
[   14.736115] PM: Adding info for No Bus:tty61
[   14.740496] device: 'tty62': device_add
[   14.744368] PM: Adding info for No Bus:tty62
[   14.748747] device: 'tty63': device_add
[   14.752626] PM: Adding info for No Bus:tty63
[   14.757067] initcall tty_init+0x0/0x1cd returned 0 after 547 msecs
[   14.763295] calling  pty_init+0x0/0x462
[   14.767175] device: 'ptyp0': device_add
[   14.771046] PM: Adding info for No Bus:ptyp0
[   14.775430] device: 'ptyp1': device_add
[   14.779301] PM: Adding info for No Bus:ptyp1
[   14.783682] device: 'ptyp2': device_add
[   14.787553] PM: Adding info for No Bus:ptyp2
[   14.791933] device: 'ptyp3': device_add
[   14.795811] PM: Adding info for No Bus:ptyp3
[   14.800191] device: 'ptyp4': device_add
[   14.804063] PM: Adding info for No Bus:ptyp4
[   14.808444] device: 'ptyp5': device_add
[   14.812316] PM: Adding info for No Bus:ptyp5
[   14.816696] device: 'ptyp6': device_add
[   14.820567] PM: Adding info for No Bus:ptyp6
[   14.824945] device: 'ptyp7': device_add
[   14.828823] PM: Adding info for No Bus:ptyp7
[   14.833204] device: 'ptyp8': device_add
[   14.837084] PM: Adding info for No Bus:ptyp8
[   14.841464] device: 'ptyp9': device_add
[   14.845345] PM: Adding info for No Bus:ptyp9
[   14.849725] device: 'ptypa': device_add
[   14.853597] PM: Adding info for No Bus:ptypa
[   14.857977] device: 'ptypb': device_add
[   14.861855] PM: Adding info for No Bus:ptypb
[   14.866236] device: 'ptypc': device_add
[   14.870108] PM: Adding info for No Bus:ptypc
[   14.874487] device: 'ptypd': device_add
[   14.878359] PM: Adding info for No Bus:ptypd
[   14.882739] device: 'ptype': device_add
[   14.886617] PM: Adding info for No Bus:ptype
[   14.890998] device: 'ptypf': device_add
[   14.894870] PM: Adding info for No Bus:ptypf
[   14.899249] device: 'ptyq0': device_add
[   14.903121] PM: Adding info for No Bus:ptyq0
[   14.907501] device: 'ptyq1': device_add
[   14.911373] PM: Adding info for No Bus:ptyq1
[   14.915752] device: 'ptyq2': device_add
[   14.919631] PM: Adding info for No Bus:ptyq2
[   14.924012] device: 'ptyq3': device_add
[   14.927884] PM: Adding info for No Bus:ptyq3
[   14.932264] device: 'ptyq4': device_add
[   14.936135] PM: Adding info for No Bus:ptyq4
[   14.940515] device: 'ptyq5': device_add
[   14.944397] PM: Adding info for No Bus:ptyq5
[   14.948777] device: 'ptyq6': device_add
[   14.952655] PM: Adding info for No Bus:ptyq6
[   14.957034] device: 'ptyq7': device_add
[   14.960906] PM: Adding info for No Bus:ptyq7
[   14.965289] device: 'ptyq8': device_add
[   14.969161] PM: Adding info for No Bus:ptyq8
[   14.973542] device: 'ptyq9': device_add
[   14.977420] PM: Adding info for No Bus:ptyq9
[   14.981800] device: 'ptyqa': device_add
[   14.985673] PM: Adding info for No Bus:ptyqa
[   14.990053] device: 'ptyqb': device_add
[   14.993925] PM: Adding info for No Bus:ptyqb
[   14.998305] device: 'ptyqc': device_add
[   15.002178] PM: Adding info for No Bus:ptyqc
[   15.006574] device: 'ptyqd': device_add
[   15.013009] PM: Adding info for No Bus:ptyqd
[   15.017389] device: 'ptyqe': device_add
[   15.021262] PM: Adding info for No Bus:ptyqe
[   15.025642] device: 'ptyqf': device_add
[   15.029514] PM: Adding info for No Bus:ptyqf
[   15.033894] device: 'ptyr0': device_add
[   15.037766] PM: Adding info for No Bus:ptyr0
[   15.042146] device: 'ptyr1': device_add
[   15.046028] PM: Adding info for No Bus:ptyr1
[   15.050409] device: 'ptyr2': device_add
[   15.054290] PM: Adding info for No Bus:ptyr2
[   15.058671] device: 'ptyr3': device_add
[   15.062544] PM: Adding info for No Bus:ptyr3
[   15.066923] device: 'ptyr4': device_add
[   15.070796] PM: Adding info for No Bus:ptyr4
[   15.075176] device: 'ptyr5': device_add
[   15.079055] PM: Adding info for No Bus:ptyr5
[   15.083435] device: 'ptyr6': device_add
[   15.087308] PM: Adding info for No Bus:ptyr6
[   15.091688] device: 'ptyr7': device_add
[   15.095561] PM: Adding info for No Bus:ptyr7
[   15.099940] device: 'ptyr8': device_add
[   15.103819] PM: Adding info for No Bus:ptyr8
[   15.108199] device: 'ptyr9': device_add
[   15.112072] PM: Adding info for No Bus:ptyr9
[   15.116452] device: 'ptyra': device_add
[   15.120324] PM: Adding info for No Bus:ptyra
[   15.124703] device: 'ptyrb': device_add
[   15.128576] PM: Adding info for No Bus:ptyrb
[   15.132955] device: 'ptyrc': device_add
[   15.136834] PM: Adding info for No Bus:ptyrc
[   15.141214] device: 'ptyrd': device_add
[   15.145088] PM: Adding info for No Bus:ptyrd
[   15.149468] device: 'ptyre': device_add
[   15.153340] PM: Adding info for No Bus:ptyre
[   15.157721] device: 'ptyrf': device_add
[   15.161604] PM: Adding info for No Bus:ptyrf
[   15.165983] device: 'ptys0': device_add
[   15.169863] PM: Adding info for No Bus:ptys0
[   15.174244] device: 'ptys1': device_add
[   15.178116] PM: Adding info for No Bus:ptys1
[   15.182496] device: 'ptys2': device_add
[   15.186369] PM: Adding info for No Bus:ptys2
[   15.190749] device: 'ptys3': device_add
[   15.194628] PM: Adding info for No Bus:ptys3
[   15.199008] device: 'ptys4': device_add
[   15.202882] PM: Adding info for No Bus:ptys4
[   15.207261] device: 'ptys5': device_add
[   15.211135] PM: Adding info for No Bus:ptys5
[   15.215514] device: 'ptys6': device_add
[   15.219391] PM: Adding info for No Bus:ptys6
[   15.223772] device: 'ptys7': device_add
[   15.227659] PM: Adding info for No Bus:ptys7
[   15.232040] device: 'ptys8': device_add
[   15.235914] PM: Adding info for No Bus:ptys8
[   15.240294] device: 'ptys9': device_add
[   15.244167] PM: Adding info for No Bus:ptys9
[   15.248566] device: 'ptysa': device_add
[   15.252436] PM: Adding info for No Bus:ptysa
[   15.256816] device: 'ptysb': device_add
[   15.260704] PM: Adding info for No Bus:ptysb
[   15.265085] device: 'ptysc': device_add
[   15.268959] PM: Adding info for No Bus:ptysc
[   15.273339] device: 'ptysd': device_add
[   15.277213] PM: Adding info for No Bus:ptysd
[   15.281592] device: 'ptyse': device_add
[   15.285466] PM: Adding info for No Bus:ptyse
[   15.289846] device: 'ptysf': device_add
[   15.293726] PM: Adding info for No Bus:ptysf
[   15.298105] device: 'ptyt0': device_add
[   15.301979] PM: Adding info for No Bus:ptyt0
[   15.306359] device: 'ptyt1': device_add
[   15.310232] PM: Adding info for No Bus:ptyt1
[   15.314612] device: 'ptyt2': device_add
[   15.318491] PM: Adding info for No Bus:ptyt2
[   15.322872] device: 'ptyt3': device_add
[   15.326747] PM: Adding info for No Bus:ptyt3
[   15.331126] device: 'ptyt4': device_add
[   15.335000] PM: Adding info for No Bus:ptyt4
[   15.339380] device: 'ptyt5': device_add
[   15.343254] PM: Adding info for No Bus:ptyt5
[   15.347633] device: 'ptyt6': device_add
[   15.351514] PM: Adding info for No Bus:ptyt6
[   15.355894] device: 'ptyt7': device_add
[   15.359767] PM: Adding info for No Bus:ptyt7
[   15.364147] device: 'ptyt8': device_add
[   15.368030] PM: Adding info for No Bus:ptyt8
[   15.372410] device: 'ptyt9': device_add
[   15.376285] PM: Adding info for No Bus:ptyt9
[   15.380666] device: 'ptyta': device_add
[   15.384542] PM: Adding info for No Bus:ptyta
[   15.388925] device: 'ptytb': device_add
[   15.392799] PM: Adding info for No Bus:ptytb
[   15.397179] device: 'ptytc': device_add
[   15.401053] PM: Adding info for No Bus:ptytc
[   15.405433] device: 'ptytd': device_add
[   15.409313] PM: Adding info for No Bus:ptytd
[   15.413693] device: 'ptyte': device_add
[   15.417568] PM: Adding info for No Bus:ptyte
[   15.421948] device: 'ptytf': device_add
[   15.425822] PM: Adding info for No Bus:ptytf
[   15.430202] device: 'ptyu0': device_add
[   15.434076] PM: Adding info for No Bus:ptyu0
[   15.438455] device: 'ptyu1': device_add
[   15.442336] PM: Adding info for No Bus:ptyu1
[   15.446716] device: 'ptyu2': device_add
[   15.450591] PM: Adding info for No Bus:ptyu2
[   15.454970] device: 'ptyu3': device_add
[   15.458845] PM: Adding info for No Bus:ptyu3
[   15.463224] device: 'ptyu4': device_add
[   15.467098] PM: Adding info for No Bus:ptyu4
[   15.471478] device: 'ptyu5': device_add
[   15.475367] PM: Adding info for No Bus:ptyu5
[   15.479747] device: 'ptyu6': device_add
[   15.483622] PM: Adding info for No Bus:ptyu6
[   15.488019] device: 'ptyu7': device_add
[   15.491895] PM: Adding info for No Bus:ptyu7
[   15.496275] device: 'ptyu8': device_add
[   15.500149] PM: Adding info for No Bus:ptyu8
[   15.504529] device: 'ptyu9': device_add
[   15.508410] PM: Adding info for No Bus:ptyu9
[   15.512789] device: 'ptyua': device_add
[   15.516664] PM: Adding info for No Bus:ptyua
[   15.521043] device: 'ptyub': device_add
[   15.524917] PM: Adding info for No Bus:ptyub
[   15.529298] device: 'ptyuc': device_add
[   15.533179] PM: Adding info for No Bus:ptyuc
[   15.537559] device: 'ptyud': device_add
[   15.541435] PM: Adding info for No Bus:ptyud
[   15.545814] device: 'ptyue': device_add
[   15.549689] PM: Adding info for No Bus:ptyue
[   15.554069] device: 'ptyuf': device_add
[   15.557944] PM: Adding info for No Bus:ptyuf
[   15.562323] device: 'ptyv0': device_add
[   15.566206] PM: Adding info for No Bus:ptyv0
[   15.570586] device: 'ptyv1': device_add
[   15.574461] PM: Adding info for No Bus:ptyv1
[   15.578841] device: 'ptyv2': device_add
[   15.582725] PM: Adding info for No Bus:ptyv2
[   15.587105] device: 'ptyv3': device_add
[   15.590981] PM: Adding info for No Bus:ptyv3
[   15.595360] device: 'ptyv4': device_add
[   15.599242] PM: Adding info for No Bus:ptyv4
[   15.603622] device: 'ptyv5': device_add
[   15.607506] PM: Adding info for No Bus:ptyv5
[   15.611886] device: 'ptyv6': device_add
[   15.615763] PM: Adding info for No Bus:ptyv6
[   15.620142] device: 'ptyv7': device_add
[   15.624024] PM: Adding info for No Bus:ptyv7
[   15.628404] device: 'ptyv8': device_add
[   15.632280] PM: Adding info for No Bus:ptyv8
[   15.636669] device: 'ptyv9': device_add
[   15.640540] PM: Adding info for No Bus:ptyv9
[   15.644923] device: 'ptyva': device_add
[   15.648799] PM: Adding info for No Bus:ptyva
[   15.653198] device: 'ptyvb': device_add
[   15.657081] PM: Adding info for No Bus:ptyvb
[   15.661464] device: 'ptyvc': device_add
[   15.665341] PM: Adding info for No Bus:ptyvc
[   15.669722] device: 'ptyvd': device_add
[   15.673598] PM: Adding info for No Bus:ptyvd
[   15.677979] device: 'ptyve': device_add
[   15.681864] PM: Adding info for No Bus:ptyve
[   15.686247] device: 'ptyvf': device_add
[   15.690129] PM: Adding info for No Bus:ptyvf
[   15.694512] device: 'ptyw0': device_add
[   15.698387] PM: Adding info for No Bus:ptyw0
[   15.702769] device: 'ptyw1': device_add
[   15.706645] PM: Adding info for No Bus:ptyw1
[   15.711027] device: 'ptyw2': device_add
[   15.714902] PM: Adding info for No Bus:ptyw2
[   15.719284] device: 'ptyw3': device_add
[   15.723170] PM: Adding info for No Bus:ptyw3
[   15.727569] device: 'ptyw4': device_add
[   15.731446] PM: Adding info for No Bus:ptyw4
[   15.735828] device: 'ptyw5': device_add
[   15.739704] PM: Adding info for No Bus:ptyw5
[   15.744087] device: 'ptyw6': device_add
[   15.747969] PM: Adding info for No Bus:ptyw6
[   15.752352] device: 'ptyw7': device_add
[   15.758784] PM: Adding info for No Bus:ptyw7
[   15.763165] device: 'ptyw8': device_add
[   15.767042] PM: Adding info for No Bus:ptyw8
[   15.771424] device: 'ptyw9': device_add
[   15.775300] PM: Adding info for No Bus:ptyw9
[   15.779680] device: 'ptywa': device_add
[   15.783564] PM: Adding info for No Bus:ptywa
[   15.787946] device: 'ptywb': device_add
[   15.791832] PM: Adding info for No Bus:ptywb
[   15.796213] device: 'ptywc': device_add
[   15.800089] PM: Adding info for No Bus:ptywc
[   15.804471] device: 'ptywd': device_add
[   15.808348] PM: Adding info for No Bus:ptywd
[   15.812728] device: 'ptywe': device_add
[   15.816612] PM: Adding info for No Bus:ptywe
[   15.820996] device: 'ptywf': device_add
[   15.824872] PM: Adding info for No Bus:ptywf
[   15.829253] device: 'ptyx0': device_add
[   15.833144] PM: Adding info for No Bus:ptyx0
[   15.837527] device: 'ptyx1': device_add
[   15.841417] PM: Adding info for No Bus:ptyx1
[   15.845798] device: 'ptyx2': device_add
[   15.849678] PM: Adding info for No Bus:ptyx2
[   15.854059] device: 'ptyx3': device_add
[   15.857936] PM: Adding info for No Bus:ptyx3
[   15.862317] device: 'ptyx4': device_add
[   15.866193] PM: Adding info for No Bus:ptyx4
[   15.870574] device: 'ptyx5': device_add
[   15.874457] PM: Adding info for No Bus:ptyx5
[   15.878838] device: 'ptyx6': device_add
[   15.882715] PM: Adding info for No Bus:ptyx6
[   15.887096] device: 'ptyx7': device_add
[   15.890973] PM: Adding info for No Bus:ptyx7
[   15.895354] device: 'ptyx8': device_add
[   15.899240] PM: Adding info for No Bus:ptyx8
[   15.903621] device: 'ptyx9': device_add
[   15.907505] PM: Adding info for No Bus:ptyx9
[   15.911887] device: 'ptyxa': device_add
[   15.915764] PM: Adding info for No Bus:ptyxa
[   15.920145] device: 'ptyxb': device_add
[   15.924021] PM: Adding info for No Bus:ptyxb
[   15.928402] device: 'ptyxc': device_add
[   15.932279] PM: Adding info for No Bus:ptyxc
[   15.936667] device: 'ptyxd': device_add
[   15.940546] PM: Adding info for No Bus:ptyxd
[   15.944929] device: 'ptyxe': device_add
[   15.948806] PM: Adding info for No Bus:ptyxe
[   15.953203] device: 'ptyxf': device_add
[   15.957081] PM: Adding info for No Bus:ptyxf
[   15.961464] device: 'ptyy0': device_add
[   15.965347] PM: Adding info for No Bus:ptyy0
[   15.969746] device: 'ptyy1': device_add
[   15.973624] PM: Adding info for No Bus:ptyy1
[   15.978005] device: 'ptyy2': device_add
[   15.981882] PM: Adding info for No Bus:ptyy2
[   15.986263] device: 'ptyy3': device_add
[   15.990152] PM: Adding info for No Bus:ptyy3
[   15.994534] device: 'ptyy4': device_add
[   15.998421] PM: Adding info for No Bus:ptyy4
[   16.002803] device: 'ptyy5': device_add
[   16.006690] PM: Adding info for No Bus:ptyy5
[   16.011071] device: 'ptyy6': device_add
[   16.014948] PM: Adding info for No Bus:ptyy6
[   16.019330] device: 'ptyy7': device_add
[   16.023207] PM: Adding info for No Bus:ptyy7
[   16.027589] device: 'ptyy8': device_add
[   16.031473] PM: Adding info for No Bus:ptyy8
[   16.035855] device: 'ptyy9': device_add
[   16.039732] PM: Adding info for No Bus:ptyy9
[   16.044113] device: 'ptyya': device_add
[   16.047990] PM: Adding info for No Bus:ptyya
[   16.052371] device: 'ptyyb': device_add
[   16.056254] PM: Adding info for No Bus:ptyyb
[   16.060655] device: 'ptyyc': device_add
[   16.064528] PM: Adding info for No Bus:ptyyc
[   16.068910] device: 'ptyyd': device_add
[   16.072788] PM: Adding info for No Bus:ptyyd
[   16.077169] device: 'ptyye': device_add
[   16.081047] PM: Adding info for No Bus:ptyye
[   16.085427] device: 'ptyyf': device_add
[   16.089311] PM: Adding info for No Bus:ptyyf
[   16.093693] device: 'ptyz0': device_add
[   16.097571] PM: Adding info for No Bus:ptyz0
[   16.101952] device: 'ptyz1': device_add
[   16.105838] PM: Adding info for No Bus:ptyz1
[   16.110220] device: 'ptyz2': device_add
[   16.114099] PM: Adding info for No Bus:ptyz2
[   16.118479] device: 'ptyz3': device_add
[   16.122364] PM: Adding info for No Bus:ptyz3
[   16.126745] device: 'ptyz4': device_add
[   16.130623] PM: Adding info for No Bus:ptyz4
[   16.135003] device: 'ptyz5': device_add
[   16.138882] PM: Adding info for No Bus:ptyz5
[   16.143262] device: 'ptyz6': device_add
[   16.147140] PM: Adding info for No Bus:ptyz6
[   16.151521] device: 'ptyz7': device_add
[   16.155406] PM: Adding info for No Bus:ptyz7
[   16.159787] device: 'ptyz8': device_add
[   16.163665] PM: Adding info for No Bus:ptyz8
[   16.168045] device: 'ptyz9': device_add
[   16.171923] PM: Adding info for No Bus:ptyz9
[   16.176304] device: 'ptyza': device_add
[   16.180188] PM: Adding info for No Bus:ptyza
[   16.184569] device: 'ptyzb': device_add
[   16.188448] PM: Adding info for No Bus:ptyzb
[   16.192829] device: 'ptyzc': device_add
[   16.196707] PM: Adding info for No Bus:ptyzc
[   16.201087] device: 'ptyzd': device_add
[   16.204966] PM: Adding info for No Bus:ptyzd
[   16.209363] device: 'ptyze': device_add
[   16.213257] PM: Adding info for No Bus:ptyze
[   16.217638] device: 'ptyzf': device_add
[   16.221521] PM: Adding info for No Bus:ptyzf
[   16.225903] device: 'ptya0': device_add
[   16.229782] PM: Adding info for No Bus:ptya0
[   16.234162] device: 'ptya1': device_add
[   16.238041] PM: Adding info for No Bus:ptya1
[   16.242422] device: 'ptya2': device_add
[   16.246307] PM: Adding info for No Bus:ptya2
[   16.250689] device: 'ptya3': device_add
[   16.254571] PM: Adding info for No Bus:ptya3
[   16.258952] device: 'ptya4': device_add
[   16.262831] PM: Adding info for No Bus:ptya4
[   16.267212] device: 'ptya5': device_add
[   16.271096] PM: Adding info for No Bus:ptya5
[   16.275477] device: 'ptya6': device_add
[   16.279357] PM: Adding info for No Bus:ptya6
[   16.283737] device: 'ptya7': device_add
[   16.287616] PM: Adding info for No Bus:ptya7
[   16.291997] device: 'ptya8': device_add
[   16.295876] PM: Adding info for No Bus:ptya8
[   16.300257] device: 'ptya9': device_add
[   16.304142] PM: Adding info for No Bus:ptya9
[   16.308523] device: 'ptyaa': device_add
[   16.312403] PM: Adding info for No Bus:ptyaa
[   16.316784] device: 'ptyab': device_add
[   16.320673] PM: Adding info for No Bus:ptyab
[   16.325052] device: 'ptyac': device_add
[   16.328932] PM: Adding info for No Bus:ptyac
[   16.333312] device: 'ptyad': device_add
[   16.337198] PM: Adding info for No Bus:ptyad
[   16.341580] device: 'ptyae': device_add
[   16.345459] PM: Adding info for No Bus:ptyae
[   16.349839] device: 'ptyaf': device_add
[   16.353719] PM: Adding info for No Bus:ptyaf
[   16.358099] device: 'ptyb0': device_add
[   16.361979] PM: Adding info for No Bus:ptyb0
[   16.366360] device: 'ptyb1': device_add
[   16.370254] PM: Adding info for No Bus:ptyb1
[   16.374635] device: 'ptyb2': device_add
[   16.378515] PM: Adding info for No Bus:ptyb2
[   16.382895] device: 'ptyb3': device_add
[   16.386775] PM: Adding info for No Bus:ptyb3
[   16.391155] device: 'ptyb4': device_add
[   16.395042] PM: Adding info for No Bus:ptyb4
[   16.399422] device: 'ptyb5': device_add
[   16.403303] PM: Adding info for No Bus:ptyb5
[   16.407684] device: 'ptyb6': device_add
[   16.411563] PM: Adding info for No Bus:ptyb6
[   16.415944] device: 'ptyb7': device_add
[   16.419824] PM: Adding info for No Bus:ptyb7
[   16.424204] device: 'ptyb8': device_add
[   16.428102] PM: Adding info for No Bus:ptyb8
[   16.432483] device: 'ptyb9': device_add
[   16.436363] PM: Adding info for No Bus:ptyb9
[   16.440744] device: 'ptyba': device_add
[   16.444618] PM: Adding info for No Bus:ptyba
[   16.449020] device: 'ptybb': device_add
[   16.452901] PM: Adding info for No Bus:ptybb
[   16.457283] device: 'ptybc': device_add
[   16.461169] PM: Adding info for No Bus:ptybc
[   16.465552] device: 'ptybd': device_add
[   16.469432] PM: Adding info for No Bus:ptybd
[   16.473813] device: 'ptybe': device_add
[   16.477692] PM: Adding info for No Bus:ptybe
[   16.482073] device: 'ptybf': device_add
[   16.485959] PM: Adding info for No Bus:ptybf
[   16.490339] device: 'ptyc0': device_add
[   16.494220] PM: Adding info for No Bus:ptyc0
[   16.498601] device: 'ptyc1': device_add
[   16.505036] PM: Adding info for No Bus:ptyc1
[   16.509418] device: 'ptyc2': device_add
[   16.513298] PM: Adding info for No Bus:ptyc2
[   16.517679] device: 'ptyc3': device_add
[   16.521566] PM: Adding info for No Bus:ptyc3
[   16.525947] device: 'ptyc4': device_add
[   16.529837] PM: Adding info for No Bus:ptyc4
[   16.534218] device: 'ptyc5': device_add
[   16.538098] PM: Adding info for No Bus:ptyc5
[   16.542479] device: 'ptyc6': device_add
[   16.546359] PM: Adding info for No Bus:ptyc6
[   16.550739] device: 'ptyc7': device_add
[   16.554627] PM: Adding info for No Bus:ptyc7
[   16.559008] device: 'ptyc8': device_add
[   16.562888] PM: Adding info for No Bus:ptyc8
[   16.567269] device: 'ptyc9': device_add
[   16.571149] PM: Adding info for No Bus:ptyc9
[   16.575530] device: 'ptyca': device_add
[   16.579410] PM: Adding info for No Bus:ptyca
[   16.583790] device: 'ptycb': device_add
[   16.587678] PM: Adding info for No Bus:ptycb
[   16.592059] device: 'ptycc': device_add
[   16.595939] PM: Adding info for No Bus:ptycc
[   16.600320] device: 'ptycd': device_add
[   16.604200] PM: Adding info for No Bus:ptycd
[   16.608581] device: 'ptyce': device_add
[   16.612467] PM: Adding info for No Bus:ptyce
[   16.616849] device: 'ptycf': device_add
[   16.620730] PM: Adding info for No Bus:ptycf
[   16.625109] device: 'ptyd0': device_add
[   16.628989] PM: Adding info for No Bus:ptyd0
[   16.633370] device: 'ptyd1': device_add
[   16.637260] PM: Adding info for No Bus:ptyd1
[   16.641641] device: 'ptyd2': device_add
[   16.645529] PM: Adding info for No Bus:ptyd2
[   16.649910] device: 'ptyd3': device_add
[   16.653790] PM: Adding info for No Bus:ptyd3
[   16.658171] device: 'ptyd4': device_add
[   16.662052] PM: Adding info for No Bus:ptyd4
[   16.666433] device: 'ptyd5': device_add
[   16.670314] PM: Adding info for No Bus:ptyd5
[   16.674694] device: 'ptyd6': device_add
[   16.678582] PM: Adding info for No Bus:ptyd6
[   16.682962] device: 'ptyd7': device_add
[   16.686843] PM: Adding info for No Bus:ptyd7
[   16.691241] device: 'ptyd8': device_add
[   16.695123] PM: Adding info for No Bus:ptyd8
[   16.699504] device: 'ptyd9': device_add
[   16.703391] PM: Adding info for No Bus:ptyd9
[   16.707772] device: 'ptyda': device_add
[   16.711654] PM: Adding info for No Bus:ptyda
[   16.716034] device: 'ptydb': device_add
[   16.719915] PM: Adding info for No Bus:ptydb
[   16.724296] device: 'ptydc': device_add
[   16.728177] PM: Adding info for No Bus:ptydc
[   16.732558] device: 'ptydd': device_add
[   16.736445] PM: Adding info for No Bus:ptydd
[   16.740826] device: 'ptyde': device_add
[   16.744717] PM: Adding info for No Bus:ptyde
[   16.749096] device: 'ptydf': device_add
[   16.752986] PM: Adding info for No Bus:ptydf
[   16.757367] device: 'ptye0': device_add
[   16.761248] PM: Adding info for No Bus:ptye0
[   16.765630] device: 'ptye1': device_add
[   16.769518] PM: Adding info for No Bus:ptye1
[   16.773900] device: 'ptye2': device_add
[   16.777781] PM: Adding info for No Bus:ptye2
[   16.782161] device: 'ptye3': device_add
[   16.786042] PM: Adding info for No Bus:ptye3
[   16.790423] device: 'ptye4': device_add
[   16.794304] PM: Adding info for No Bus:ptye4
[   16.798686] device: 'ptye5': device_add
[   16.802574] PM: Adding info for No Bus:ptye5
[   16.806954] device: 'ptye6': device_add
[   16.810836] PM: Adding info for No Bus:ptye6
[   16.815216] device: 'ptye7': device_add
[   16.819097] PM: Adding info for No Bus:ptye7
[   16.823479] device: 'ptye8': device_add
[   16.827367] PM: Adding info for No Bus:ptye8
[   16.831748] device: 'ptye9': device_add
[   16.835630] PM: Adding info for No Bus:ptye9
[   16.840010] device: 'ptyea': device_add
[   16.843891] PM: Adding info for No Bus:ptyea
[   16.848272] device: 'ptyeb': device_add
[   16.852163] PM: Adding info for No Bus:ptyeb
[   16.856544] device: 'ptyec': device_add
[   16.860432] PM: Adding info for No Bus:ptyec
[   16.864813] device: 'ptyed': device_add
[   16.868694] PM: Adding info for No Bus:ptyed
[   16.873076] device: 'ptyee': device_add
[   16.876957] PM: Adding info for No Bus:ptyee
[   16.881338] device: 'ptyef': device_add
[   16.885219] PM: Adding info for No Bus:ptyef
[   16.889608] device: 'ttyp0': device_add
[   16.893495] PM: Adding info for No Bus:ttyp0
[   16.897876] device: 'ttyp1': device_add
[   16.901756] PM: Adding info for No Bus:ttyp1
[   16.906136] device: 'ttyp2': device_add
[   16.910015] PM: Adding info for No Bus:ttyp2
[   16.914396] device: 'ttyp3': device_add
[   16.918281] PM: Adding info for No Bus:ttyp3
[   16.922662] device: 'ttyp4': device_add
[   16.926542] PM: Adding info for No Bus:ttyp4
[   16.930940] device: 'ttyp5': device_add
[   16.934820] PM: Adding info for No Bus:ttyp5
[   16.939201] device: 'ttyp6': device_add
[   16.943080] PM: Adding info for No Bus:ttyp6
[   16.947461] device: 'ttyp7': device_add
[   16.951355] PM: Adding info for No Bus:ttyp7
[   16.955735] device: 'ttyp8': device_add
[   16.959615] PM: Adding info for No Bus:ttyp8
[   16.963996] device: 'ttyp9': device_add
[   16.967888] PM: Adding info for No Bus:ttyp9
[   16.972275] device: 'ttypa': device_add
[   16.976162] PM: Adding info for No Bus:ttypa
[   16.980544] device: 'ttypb': device_add
[   16.984433] PM: Adding info for No Bus:ttypb
[   16.988815] device: 'ttypc': device_add
[   16.992695] PM: Adding info for No Bus:ttypc
[   16.997077] device: 'ttypd': device_add
[   17.000956] PM: Adding info for No Bus:ttypd
[   17.005337] device: 'ttype': device_add
[   17.009217] PM: Adding info for No Bus:ttype
[   17.013601] device: 'ttypf': device_add
[   17.017488] PM: Adding info for No Bus:ttypf
[   17.021870] device: 'ttyq0': device_add
[   17.025750] PM: Adding info for No Bus:ttyq0
[   17.030133] device: 'ttyq1': device_add
[   17.034012] PM: Adding info for No Bus:ttyq1
[   17.038393] device: 'ttyq2': device_add
[   17.042279] PM: Adding info for No Bus:ttyq2
[   17.046660] device: 'ttyq3': device_add
[   17.050541] PM: Adding info for No Bus:ttyq3
[   17.054923] device: 'ttyq4': device_add
[   17.058811] PM: Adding info for No Bus:ttyq4
[   17.063193] device: 'ttyq5': device_add
[   17.067073] PM: Adding info for No Bus:ttyq5
[   17.071454] device: 'ttyq6': device_add
[   17.075340] PM: Adding info for No Bus:ttyq6
[   17.079722] device: 'ttyq7': device_add
[   17.083602] PM: Adding info for No Bus:ttyq7
[   17.087983] device: 'ttyq8': device_add
[   17.091862] PM: Adding info for No Bus:ttyq8
[   17.096243] device: 'ttyq9': device_add
[   17.100123] PM: Adding info for No Bus:ttyq9
[   17.104505] device: 'ttyqa': device_add
[   17.108394] PM: Adding info for No Bus:ttyqa
[   17.112775] device: 'ttyqb': device_add
[   17.116650] PM: Adding info for No Bus:ttyqb
[   17.121035] device: 'ttyqc': device_add
[   17.124914] PM: Adding info for No Bus:ttyqc
[   17.129297] device: 'ttyqd': device_add
[   17.133191] PM: Adding info for No Bus:ttyqd
[   17.137573] device: 'ttyqe': device_add
[   17.141453] PM: Adding info for No Bus:ttyqe
[   17.145834] device: 'ttyqf': device_add
[   17.149715] PM: Adding info for No Bus:ttyqf
[   17.154096] device: 'ttyr0': device_add
[   17.157976] PM: Adding info for No Bus:ttyr0
[   17.162357] device: 'ttyr1': device_add
[   17.166252] PM: Adding info for No Bus:ttyr1
[   17.170651] device: 'ttyr2': device_add
[   17.174532] PM: Adding info for No Bus:ttyr2
[   17.178914] device: 'ttyr3': device_add
[   17.182794] PM: Adding info for No Bus:ttyr3
[   17.187175] device: 'ttyr4': device_add
[   17.191056] PM: Adding info for No Bus:ttyr4
[   17.195438] device: 'ttyr5': device_add
[   17.199325] PM: Adding info for No Bus:ttyr5
[   17.203707] device: 'ttyr6': device_add
[   17.207587] PM: Adding info for No Bus:ttyr6
[   17.211968] device: 'ttyr7': device_add
[   17.215849] PM: Adding info for No Bus:ttyr7
[   17.220230] device: 'ttyr8': device_add
[   17.224115] PM: Adding info for No Bus:ttyr8
[   17.228497] device: 'ttyr9': device_add
[   17.232384] PM: Adding info for No Bus:ttyr9
[   17.236768] device: 'ttyra': device_add
[   17.240644] PM: Adding info for No Bus:ttyra
[   17.245029] device: 'ttyrb': device_add
[   17.251462] PM: Adding info for No Bus:ttyrb
[   17.255844] device: 'ttyrc': device_add
[   17.259731] PM: Adding info for No Bus:ttyrc
[   17.264114] device: 'ttyrd': device_add
[   17.267995] PM: Adding info for No Bus:ttyrd
[   17.272376] device: 'ttyre': device_add
[   17.276268] PM: Adding info for No Bus:ttyre
[   17.280651] device: 'ttyrf': device_add
[   17.284531] PM: Adding info for No Bus:ttyrf
[   17.288913] device: 'ttys0': device_add
[   17.292800] PM: Adding info for No Bus:ttys0
[   17.297180] device: 'ttys1': device_add
[   17.301061] PM: Adding info for No Bus:ttys1
[   17.305442] device: 'ttys2': device_add
[   17.309322] PM: Adding info for No Bus:ttys2
[   17.313703] device: 'ttys3': device_add
[   17.317585] PM: Adding info for No Bus:ttys3
[   17.321966] device: 'ttys4': device_add
[   17.325854] PM: Adding info for No Bus:ttys4
[   17.330235] device: 'ttys5': device_add
[   17.334116] PM: Adding info for No Bus:ttys5
[   17.338497] device: 'ttys6': device_add
[   17.342378] PM: Adding info for No Bus:ttys6
[   17.346759] device: 'ttys7': device_add
[   17.350646] PM: Adding info for No Bus:ttys7
[   17.355028] device: 'ttys8': device_add
[   17.358909] PM: Adding info for No Bus:ttys8
[   17.363290] device: 'ttys9': device_add
[   17.367171] PM: Adding info for No Bus:ttys9
[   17.371553] device: 'ttysa': device_add
[   17.375442] PM: Adding info for No Bus:ttysa
[   17.379824] device: 'ttysb': device_add
[   17.383712] PM: Adding info for No Bus:ttysb
[   17.388093] device: 'ttysc': device_add
[   17.391975] PM: Adding info for No Bus:ttysc
[   17.396356] device: 'ttysd': device_add
[   17.400237] PM: Adding info for No Bus:ttysd
[   17.404618] device: 'ttyse': device_add
[   17.408499] PM: Adding info for No Bus:ttyse
[   17.412898] device: 'ttysf': device_add
[   17.416786] PM: Adding info for No Bus:ttysf
[   17.421165] device: 'ttyt0': device_add
[   17.425046] PM: Adding info for No Bus:ttyt0
[   17.429427] device: 'ttyt1': device_add
[   17.433308] PM: Adding info for No Bus:ttyt1
[   17.437689] device: 'ttyt2': device_add
[   17.441570] PM: Adding info for No Bus:ttyt2
[   17.445951] device: 'ttyt3': device_add
[   17.449840] PM: Adding info for No Bus:ttyt3
[   17.454221] device: 'ttyt4': device_add
[   17.458103] PM: Adding info for No Bus:ttyt4
[   17.462484] device: 'ttyt5': device_add
[   17.466366] PM: Adding info for No Bus:ttyt5
[   17.470747] device: 'ttyt6': device_add
[   17.474634] PM: Adding info for No Bus:ttyt6
[   17.479016] device: 'ttyt7': device_add
[   17.482907] PM: Adding info for No Bus:ttyt7
[   17.487289] device: 'ttyt8': device_add
[   17.491170] PM: Adding info for No Bus:ttyt8
[   17.495551] device: 'ttyt9': device_add
[   17.499433] PM: Adding info for No Bus:ttyt9
[   17.503814] device: 'ttyta': device_add
[   17.507703] PM: Adding info for No Bus:ttyta
[   17.512085] device: 'ttytb': device_add
[   17.515975] PM: Adding info for No Bus:ttytb
[   17.520357] device: 'ttytc': device_add
[   17.524239] PM: Adding info for No Bus:ttytc
[   17.528620] device: 'ttytd': device_add
[   17.532505] PM: Adding info for No Bus:ttytd
[   17.536887] device: 'ttyte': device_add
[   17.540775] PM: Adding info for No Bus:ttyte
[   17.545156] device: 'ttytf': device_add
[   17.549038] PM: Adding info for No Bus:ttytf
[   17.553418] device: 'ttyu0': device_add
[   17.557300] PM: Adding info for No Bus:ttyu0
[   17.561681] device: 'ttyu1': device_add
[   17.565569] PM: Adding info for No Bus:ttyu1
[   17.569951] device: 'ttyu2': device_add
[   17.573833] PM: Adding info for No Bus:ttyu2
[   17.578215] device: 'ttyu3': device_add
[   17.582097] PM: Adding info for No Bus:ttyu3
[   17.586478] device: 'ttyu4': device_add
[   17.590369] PM: Adding info for No Bus:ttyu4
[   17.594750] device: 'ttyu5': device_add
[   17.598639] PM: Adding info for No Bus:ttyu5
[   17.603020] device: 'ttyu6': device_add
[   17.606902] PM: Adding info for No Bus:ttyu6
[   17.611284] device: 'ttyu7': device_add
[   17.615166] PM: Adding info for No Bus:ttyu7
[   17.619547] device: 'ttyu8': device_add
[   17.623429] PM: Adding info for No Bus:ttyu8
[   17.627810] device: 'ttyu9': device_add
[   17.631698] PM: Adding info for No Bus:ttyu9
[   17.636080] device: 'ttyua': device_add
[   17.639962] PM: Adding info for No Bus:ttyua
[   17.644343] device: 'ttyub': device_add
[   17.648225] PM: Adding info for No Bus:ttyub
[   17.652624] device: 'ttyuc': device_add
[   17.656507] PM: Adding info for No Bus:ttyuc
[   17.660889] device: 'ttyud': device_add
[   17.664778] PM: Adding info for No Bus:ttyud
[   17.669158] device: 'ttyue': device_add
[   17.673041] PM: Adding info for No Bus:ttyue
[   17.677422] device: 'ttyuf': device_add
[   17.681304] PM: Adding info for No Bus:ttyuf
[   17.685685] device: 'ttyv0': device_add
[   17.689574] PM: Adding info for No Bus:ttyv0
[   17.693955] device: 'ttyv1': device_add
[   17.697847] PM: Adding info for No Bus:ttyv1
[   17.702229] device: 'ttyv2': device_add
[   17.706111] PM: Adding info for No Bus:ttyv2
[   17.710492] device: 'ttyv3': device_add
[   17.714375] PM: Adding info for No Bus:ttyv3
[   17.718756] device: 'ttyv4': device_add
[   17.722645] PM: Adding info for No Bus:ttyv4
[   17.727027] device: 'ttyv5': device_add
[   17.730910] PM: Adding info for No Bus:ttyv5
[   17.735291] device: 'ttyv6': device_add
[   17.739174] PM: Adding info for No Bus:ttyv6
[   17.743555] device: 'ttyv7': device_add
[   17.747438] PM: Adding info for No Bus:ttyv7
[   17.751819] device: 'ttyv8': device_add
[   17.755708] PM: Adding info for No Bus:ttyv8
[   17.760090] device: 'ttyv9': device_add
[   17.763973] PM: Adding info for No Bus:ttyv9
[   17.768354] device: 'ttyva': device_add
[   17.772236] PM: Adding info for No Bus:ttyva
[   17.776617] device: 'ttyvb': device_add
[   17.780507] PM: Adding info for No Bus:ttyvb
[   17.784888] device: 'ttyvc': device_add
[   17.788775] PM: Adding info for No Bus:ttyvc
[   17.793155] device: 'ttyvd': device_add
[   17.797050] PM: Adding info for No Bus:ttyvd
[   17.801432] device: 'ttyve': device_add
[   17.805315] PM: Adding info for No Bus:ttyve
[   17.809697] device: 'ttyvf': device_add
[   17.813586] PM: Adding info for No Bus:ttyvf
[   17.817967] device: 'ttyw0': device_add
[   17.821851] PM: Adding info for No Bus:ttyw0
[   17.826233] device: 'ttyw1': device_add
[   17.830116] PM: Adding info for No Bus:ttyw1
[   17.834497] device: 'ttyw2': device_add
[   17.838381] PM: Adding info for No Bus:ttyw2
[   17.842763] device: 'ttyw3': device_add
[   17.846653] PM: Adding info for No Bus:ttyw3
[   17.851034] device: 'ttyw4': device_add
[   17.854917] PM: Adding info for No Bus:ttyw4
[   17.859298] device: 'ttyw5': device_add
[   17.863182] PM: Adding info for No Bus:ttyw5
[   17.867564] device: 'ttyw6': device_add
[   17.871447] PM: Adding info for No Bus:ttyw6
[   17.875828] device: 'ttyw7': device_add
[   17.879719] PM: Adding info for No Bus:ttyw7
[   17.884100] device: 'ttyw8': device_add
[   17.887983] PM: Adding info for No Bus:ttyw8
[   17.892382] device: 'ttyw9': device_add
[   17.896274] PM: Adding info for No Bus:ttyw9
[   17.900656] device: 'ttywa': device_add
[   17.904555] PM: Adding info for No Bus:ttywa
[   17.908937] device: 'ttywb': device_add
[   17.912822] PM: Adding info for No Bus:ttywb
[   17.917202] device: 'ttywc': device_add
[   17.921085] PM: Adding info for No Bus:ttywc
[   17.925467] device: 'ttywd': device_add
[   17.929351] PM: Adding info for No Bus:ttywd
[   17.933732] device: 'ttywe': device_add
[   17.937622] PM: Adding info for No Bus:ttywe
[   17.942004] device: 'ttywf': device_add
[   17.945888] PM: Adding info for No Bus:ttywf
[   17.950269] device: 'ttyx0': device_add
[   17.954153] PM: Adding info for No Bus:ttyx0
[   17.958534] device: 'ttyx1': device_add
[   17.962418] PM: Adding info for No Bus:ttyx1
[   17.966800] device: 'ttyx2': device_add
[   17.970690] PM: Adding info for No Bus:ttyx2
[   17.975072] device: 'ttyx3': device_add
[   17.978956] PM: Adding info for No Bus:ttyx3
[   17.983337] device: 'ttyx4': device_add
[   17.987221] PM: Adding info for No Bus:ttyx4
[   17.991603] device: 'ttyx5': device_add
[   17.998048] PM: Adding info for No Bus:ttyx5
[   18.002430] device: 'ttyx6': device_add
[   18.006314] PM: Adding info for No Bus:ttyx6
[   18.010695] device: 'ttyx7': device_add
[   18.014589] PM: Adding info for No Bus:ttyx7
[   18.018971] device: 'ttyx8': device_add
[   18.022854] PM: Adding info for No Bus:ttyx8
[   18.027236] device: 'ttyx9': device_add
[   18.031126] PM: Adding info for No Bus:ttyx9
[   18.035507] device: 'ttyxa': device_add
[   18.039395] PM: Adding info for No Bus:ttyxa
[   18.043777] device: 'ttyxb': device_add
[   18.047664] PM: Adding info for No Bus:ttyxb
[   18.052045] device: 'ttyxc': device_add
[   18.055930] PM: Adding info for No Bus:ttyxc
[   18.060311] device: 'ttyxd': device_add
[   18.064202] PM: Adding info for No Bus:ttyxd
[   18.068584] device: 'ttyxe': device_add
[   18.072468] PM: Adding info for No Bus:ttyxe
[   18.076850] device: 'ttyxf': device_add
[   18.080729] PM: Adding info for No Bus:ttyxf
[   18.085114] device: 'ttyy0': device_add
[   18.088998] PM: Adding info for No Bus:ttyy0
[   18.093380] device: 'ttyy1': device_add
[   18.097272] PM: Adding info for No Bus:ttyy1
[   18.101653] device: 'ttyy2': device_add
[   18.105550] PM: Adding info for No Bus:ttyy2
[   18.109931] device: 'ttyy3': device_add
[   18.113822] PM: Adding info for No Bus:ttyy3
[   18.118204] device: 'ttyy4': device_add
[   18.122109] PM: Adding info for No Bus:ttyy4
[   18.126490] device: 'ttyy5': device_add
[   18.130375] PM: Adding info for No Bus:ttyy5
[   18.134774] device: 'ttyy6': device_add
[   18.138660] PM: Adding info for No Bus:ttyy6
[   18.143042] device: 'ttyy7': device_add
[   18.146927] PM: Adding info for No Bus:ttyy7
[   18.151308] device: 'ttyy8': device_add
[   18.155199] PM: Adding info for No Bus:ttyy8
[   18.159581] device: 'ttyy9': device_add
[   18.163466] PM: Adding info for No Bus:ttyy9
[   18.167848] device: 'ttyya': device_add
[   18.171733] PM: Adding info for No Bus:ttyya
[   18.176114] device: 'ttyyb': device_add
[   18.179998] PM: Adding info for No Bus:ttyyb
[   18.184379] device: 'ttyyc': device_add
[   18.188270] PM: Adding info for No Bus:ttyyc
[   18.192652] device: 'ttyyd': device_add
[   18.196537] PM: Adding info for No Bus:ttyyd
[   18.200919] device: 'ttyye': device_add
[   18.204803] PM: Adding info for No Bus:ttyye
[   18.209183] device: 'ttyyf': device_add
[   18.213074] PM: Adding info for No Bus:ttyyf
[   18.217456] device: 'ttyz0': device_add
[   18.221350] PM: Adding info for No Bus:ttyz0
[   18.225731] device: 'ttyz1': device_add
[   18.229622] PM: Adding info for No Bus:ttyz1
[   18.234004] device: 'ttyz2': device_add
[   18.237889] PM: Adding info for No Bus:ttyz2
[   18.242270] device: 'ttyz3': device_add
[   18.246159] PM: Adding info for No Bus:ttyz3
[   18.250541] device: 'ttyz4': device_add
[   18.254426] PM: Adding info for No Bus:ttyz4
[   18.258808] device: 'ttyz5': device_add
[   18.262693] PM: Adding info for No Bus:ttyz5
[   18.267074] device: 'ttyz6': device_add
[   18.270959] PM: Adding info for No Bus:ttyz6
[   18.275341] device: 'ttyz7': device_add
[   18.279241] PM: Adding info for No Bus:ttyz7
[   18.283622] device: 'ttyz8': device_add
[   18.287508] PM: Adding info for No Bus:ttyz8
[   18.291889] device: 'ttyz9': device_add
[   18.295774] PM: Adding info for No Bus:ttyz9
[   18.300156] device: 'ttyza': device_add
[   18.304041] PM: Adding info for No Bus:ttyza
[   18.308423] device: 'ttyzb': device_add
[   18.312314] PM: Adding info for No Bus:ttyzb
[   18.316696] device: 'ttyzc': device_add
[   18.320581] PM: Adding info for No Bus:ttyzc
[   18.324962] device: 'ttyzd': device_add
[   18.328857] PM: Adding info for No Bus:ttyzd
[   18.333237] device: 'ttyze': device_add
[   18.337129] PM: Adding info for No Bus:ttyze
[   18.341510] device: 'ttyzf': device_add
[   18.345396] PM: Adding info for No Bus:ttyzf
[   18.349777] device: 'ttya0': device_add
[   18.353662] PM: Adding info for No Bus:ttya0
[   18.358043] device: 'ttya1': device_add
[   18.361929] PM: Adding info for No Bus:ttya1
[   18.366310] device: 'ttya2': device_add
[   18.370202] PM: Adding info for No Bus:ttya2
[   18.374602] device: 'ttya3': device_add
[   18.378488] PM: Adding info for No Bus:ttya3
[   18.382870] device: 'ttya4': device_add
[   18.386756] PM: Adding info for No Bus:ttya4
[   18.391136] device: 'ttya5': device_add
[   18.395023] PM: Adding info for No Bus:ttya5
[   18.399404] device: 'ttya6': device_add
[   18.403296] PM: Adding info for No Bus:ttya6
[   18.407678] device: 'ttya7': device_add
[   18.411564] PM: Adding info for No Bus:ttya7
[   18.415945] device: 'ttya8': device_add
[   18.419830] PM: Adding info for No Bus:ttya8
[   18.424212] device: 'ttya9': device_add
[   18.428104] PM: Adding info for No Bus:ttya9
[   18.432485] device: 'ttyaa': device_add
[   18.436381] PM: Adding info for No Bus:ttyaa
[   18.440765] device: 'ttyab': device_add
[   18.444645] PM: Adding info for No Bus:ttyab
[   18.449028] device: 'ttyac': device_add
[   18.452914] PM: Adding info for No Bus:ttyac
[   18.457296] device: 'ttyad': device_add
[   18.461188] PM: Adding info for No Bus:ttyad
[   18.465569] device: 'ttyae': device_add
[   18.469456] PM: Adding info for No Bus:ttyae
[   18.473837] device: 'ttyaf': device_add
[   18.477723] PM: Adding info for No Bus:ttyaf
[   18.482104] device: 'ttyb0': device_add
[   18.485990] PM: Adding info for No Bus:ttyb0
[   18.490372] device: 'ttyb1': device_add
[   18.494268] PM: Adding info for No Bus:ttyb1
[   18.498650] device: 'ttyb2': device_add
[   18.502538] PM: Adding info for No Bus:ttyb2
[   18.506919] device: 'ttyb3': device_add
[   18.510806] PM: Adding info for No Bus:ttyb3
[   18.515187] device: 'ttyb4': device_add
[   18.519073] PM: Adding info for No Bus:ttyb4
[   18.523454] device: 'ttyb5': device_add
[   18.527347] PM: Adding info for No Bus:ttyb5
[   18.531729] device: 'ttyb6': device_add
[   18.535615] PM: Adding info for No Bus:ttyb6
[   18.539996] device: 'ttyb7': device_add
[   18.543891] PM: Adding info for No Bus:ttyb7
[   18.548273] device: 'ttyb8': device_add
[   18.552166] PM: Adding info for No Bus:ttyb8
[   18.556548] device: 'ttyb9': device_add
[   18.560436] PM: Adding info for No Bus:ttyb9
[   18.564821] device: 'ttyba': device_add
[   18.568702] PM: Adding info for No Bus:ttyba
[   18.573085] device: 'ttybb': device_add
[   18.576971] PM: Adding info for No Bus:ttybb
[   18.581352] device: 'ttybc': device_add
[   18.585245] PM: Adding info for No Bus:ttybc
[   18.589627] device: 'ttybd': device_add
[   18.593513] PM: Adding info for No Bus:ttybd
[   18.597894] device: 'ttybe': device_add
[   18.601781] PM: Adding info for No Bus:ttybe
[   18.606162] device: 'ttybf': device_add
[   18.610048] PM: Adding info for No Bus:ttybf
[   18.614446] device: 'ttyc0': device_add
[   18.618341] PM: Adding info for No Bus:ttyc0
[   18.622723] device: 'ttyc1': device_add
[   18.626610] PM: Adding info for No Bus:ttyc1
[   18.630990] device: 'ttyc2': device_add
[   18.634877] PM: Adding info for No Bus:ttyc2
[   18.639258] device: 'ttyc3': device_add
[   18.643159] PM: Adding info for No Bus:ttyc3
[   18.647540] device: 'ttyc4': device_add
[   18.651427] PM: Adding info for No Bus:ttyc4
[   18.655808] device: 'ttyc5': device_add
[   18.659703] PM: Adding info for No Bus:ttyc5
[   18.664085] device: 'ttyc6': device_add
[   18.667972] PM: Adding info for No Bus:ttyc6
[   18.672353] device: 'ttyc7': device_add
[   18.676246] PM: Adding info for No Bus:ttyc7
[   18.680627] device: 'ttyc8': device_add
[   18.684515] PM: Adding info for No Bus:ttyc8
[   18.688896] device: 'ttyc9': device_add
[   18.692784] PM: Adding info for No Bus:ttyc9
[   18.697165] device: 'ttyca': device_add
[   18.701052] PM: Adding info for No Bus:ttyca
[   18.705433] device: 'ttycb': device_add
[   18.709327] PM: Adding info for No Bus:ttycb
[   18.713708] device: 'ttycc': device_add
[   18.717596] PM: Adding info for No Bus:ttycc
[   18.721977] device: 'ttycd': device_add
[   18.725864] PM: Adding info for No Bus:ttycd
[   18.730245] device: 'ttyce': device_add
[   18.734133] PM: Adding info for No Bus:ttyce
[   18.738514] device: 'ttycf': device_add
[   18.744964] PM: Adding info for No Bus:ttycf
[   18.749345] device: 'ttyd0': device_add
[   18.753242] PM: Adding info for No Bus:ttyd0
[   18.757624] device: 'ttyd1': device_add
[   18.761511] PM: Adding info for No Bus:ttyd1
[   18.765892] device: 'ttyd2': device_add
[   18.769786] PM: Adding info for No Bus:ttyd2
[   18.774167] device: 'ttyd3': device_add
[   18.778055] PM: Adding info for No Bus:ttyd3
[   18.782436] device: 'ttyd4': device_add
[   18.786323] PM: Adding info for No Bus:ttyd4
[   18.790704] device: 'ttyd5': device_add
[   18.794592] PM: Adding info for No Bus:ttyd5
[   18.798972] device: 'ttyd6': device_add
[   18.802867] PM: Adding info for No Bus:ttyd6
[   18.807248] device: 'ttyd7': device_add
[   18.811135] PM: Adding info for No Bus:ttyd7
[   18.815517] device: 'ttyd8': device_add
[   18.819405] PM: Adding info for No Bus:ttyd8
[   18.823787] device: 'ttyd9': device_add
[   18.827675] PM: Adding info for No Bus:ttyd9
[   18.832056] device: 'ttyda': device_add
[   18.835951] PM: Adding info for No Bus:ttyda
[   18.840333] device: 'ttydb': device_add
[   18.844220] PM: Adding info for No Bus:ttydb
[   18.848601] device: 'ttydc': device_add
[   18.852489] PM: Adding info for No Bus:ttydc
[   18.856889] device: 'ttydd': device_add
[   18.860791] PM: Adding info for No Bus:ttydd
[   18.865172] device: 'ttyde': device_add
[   18.869061] PM: Adding info for No Bus:ttyde
[   18.873442] device: 'ttydf': device_add
[   18.877330] PM: Adding info for No Bus:ttydf
[   18.881711] device: 'ttye0': device_add
[   18.885599] PM: Adding info for No Bus:ttye0
[   18.889980] device: 'ttye1': device_add
[   18.893874] PM: Adding info for No Bus:ttye1
[   18.898256] device: 'ttye2': device_add
[   18.902144] PM: Adding info for No Bus:ttye2
[   18.906525] device: 'ttye3': device_add
[   18.910413] PM: Adding info for No Bus:ttye3
[   18.914794] device: 'ttye4': device_add
[   18.918682] PM: Adding info for No Bus:ttye4
[   18.923063] device: 'ttye5': device_add
[   18.926958] PM: Adding info for No Bus:ttye5
[   18.931340] device: 'ttye6': device_add
[   18.935228] PM: Adding info for No Bus:ttye6
[   18.939609] device: 'ttye7': device_add
[   18.943497] PM: Adding info for No Bus:ttye7
[   18.947878] device: 'ttye8': device_add
[   18.951766] PM: Adding info for No Bus:ttye8
[   18.956148] device: 'ttye9': device_add
[   18.960042] PM: Adding info for No Bus:ttye9
[   18.964423] device: 'ttyea': device_add
[   18.968321] PM: Adding info for No Bus:ttyea
[   18.972703] device: 'ttyeb': device_add
[   18.976591] PM: Adding info for No Bus:ttyeb
[   18.980972] device: 'ttyec': device_add
[   18.984867] PM: Adding info for No Bus:ttyec
[   18.989247] device: 'ttyed': device_add
[   18.993136] PM: Adding info for No Bus:ttyed
[   18.997517] device: 'ttyee': device_add
[   19.001405] PM: Adding info for No Bus:ttyee
[   19.005786] device: 'ttyef': device_add
[   19.009675] PM: Adding info for No Bus:ttyef
[   19.014083] initcall pty_init+0x0/0x462 returned 0 after 4050 msecs
[   19.020397] calling  xen_init+0x0/0x87
[   19.024166] initcall xen_init+0x0/0x87 returned -19 after 0 msecs
[   19.030308] calling  raw_init+0x0/0xdd
[   19.034079] device class 'raw': registering
[   19.038380] device: 'rawctl': device_add
[   19.042353] PM: Adding info for No Bus:rawctl
[   19.046851] initcall raw_init+0x0/0xdd returned 0 after 12 msecs
[   19.052911] calling  r3964_init+0x0/0x44
[   19.056849] r3964: Philips r3964 Driver $Revision: 1.10 $
[   19.062265] initcall r3964_init+0x0/0x44 returned 0 after 5 msecs
[   19.068403] calling  hpet_init+0x0/0x6a
[   19.072263] device: 'hpet': device_add
[   19.076054] PM: Adding info for No Bus:hpet
[   19.080354] bus: 'acpi': add driver hpet
[   19.084468] initcall hpet_init+0x0/0x6a returned 0 after 11 msecs
[   19.090612] calling  nvram_init+0x0/0x8a
[   19.094554] device: 'nvram': device_add
[   19.098432] PM: Adding info for No Bus:nvram
[   19.102820] Non-volatile memory driver v1.2
[   19.107020] initcall nvram_init+0x0/0x8a returned 0 after 11 msecs
[   19.113249] calling  mod_init+0x0/0xba
[   19.117078] initcall mod_init+0x0/0xba returned -19 after 0 msecs
[   19.123218] calling  tlclk_init+0x0/0x1b7
[   19.127266] telclk_interrup = 0xf non-mcpbl0010 hw.
[   19.132176] initcall tlclk_init+0x0/0x1b7 returned -6 after 4 msecs
[   19.138493] initcall tlclk_init+0x0/0x1b7 returned with error code -6 
[   19.145069] calling  agp_init+0x0/0x26
[   19.148834] Linux agpgart interface v0.103
[   19.152946] initcall agp_init+0x0/0x26 returned 0 after 3 msecs
[   19.158913] calling  agp_intel_init+0x0/0x29
[   19.163203] bus: 'pci': add driver agpgart-intel
[   19.167981] initcall agp_intel_init+0x0/0x29 returned 0 after 4 msecs
[   19.174470] calling  agp_sis_init+0x0/0x29
[   19.178582] bus: 'pci': add driver agpgart-sis
[   19.183186] initcall agp_sis_init+0x0/0x29 returned 0 after 4 msecs
[   19.189503] calling  agp_via_init+0x0/0x29
[   19.193616] bus: 'pci': add driver agpgart-via
[   19.198209] initcall agp_via_init+0x0/0x29 returned 0 after 4 msecs
[   19.204522] calling  hangcheck_init+0x0/0x8a
[   19.208809] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   19.217776] Hangcheck: Using get_cycles().
[   19.221889] initcall hangcheck_init+0x0/0x8a returned 0 after 12 msecs
[   19.228462] calling  init_tis+0x0/0x91
[   19.232235] pnp: the driver 'tpm_tis' has been registered
[   19.237649] bus: 'pnp': add driver tpm_tis
[   19.241888] initcall init_tis+0x0/0x91 returned 0 after 9 msecs
[   19.247856] calling  init_atmel+0x0/0x1cb
[   19.251884] bus: 'platform': add driver tpm_atmel
[   19.256721] bus: 'platform': remove driver tpm_atmel
[   19.261800] driver: 'tpm_atmel': driver_release
[   19.266351] initcall init_atmel+0x0/0x1cb returned -19 after 13 msecs
[   19.272840] calling  init_inf+0x0/0x12
[   19.276603] pnp: the driver 'tpm_inf_pnp' has been registered
[   19.282364] bus: 'pnp': add driver tpm_inf_pnp
[   19.286939] initcall init_inf+0x0/0x12 returned 0 after 9 msecs
[   19.292910] calling  cn_proc_init+0x0/0x3d
[   19.297027] initcall cn_proc_init+0x0/0x3d returned 0 after 0 msecs
[   19.303338] calling  intelfb_init+0x0/0x24d
[   19.307539] intelfb: intelfb_init
[   19.310871] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets
[   19.321832] intelfb: Version 0.9.5
[   19.325252] intelfb: intelfb_setup
[   19.328667] intelfb: no options
[   19.331832] bus: 'pci': add driver intelfb
[   19.336076] initcall intelfb_init+0x0/0x24d returned 0 after 27 msecs
[   19.342566] calling  serial8250_init+0x0/0x118
[   19.347025] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[   19.353144] Registering platform device 'serial8250'. Parent at platform
[   19.359855] device: 'serial8250': device_add
[   19.364155] bus: 'platform': add device serial8250
[   19.368974] PM: Adding info for platform:serial8250
[   19.374048] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   19.380073] device: 'ttyS0': device_add
[   19.383977] PM: Adding info for No Bus:ttyS0
[   19.388379] device: 'ttyS1': device_add
[   19.392283] PM: Adding info for No Bus:ttyS1
[   19.396679] device: 'ttyS2': device_add
[   19.400581] PM: Adding info for No Bus:ttyS2
[   19.404977] device: 'ttyS3': device_add
[   19.408872] PM: Adding info for No Bus:ttyS3
[   19.413253] bus: 'platform': add driver serial8250
[   19.418070] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   19.427037] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   19.435402] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   19.442462] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   19.450576] initcall serial8250_init+0x0/0x118 returned 0 after 98 msecs
[   19.457327] calling  serial8250_pnp_init+0x0/0x12
[   19.462047] pnp: the driver 'serial' has been registered
[   19.467373] bus: 'pnp': add driver serial
[   19.471497] bus: 'pnp': driver_probe_device: matched device 00:0b with driver serial
[   19.479251] bus: 'pnp': really_probe: probing driver serial with device 00:0b
[   19.486495] device: 'ttyS0': device_unregister
[   19.490956] PM: Removing info for No Bus:ttyS0
[   19.495557] device: 'ttyS0': device_create_release
[   19.500440] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   19.506031] device: 'ttyS0': device_add
[   19.509927] PM: Adding info for No Bus:ttyS0
[   19.514312] serial 00:0b: driver attached
[   19.518341] driver: '00:0b': driver_bound: bound to device 'serial'
[   19.524619] bus: 'pnp': really_probe: bound device 00:0b to driver serial
[   19.531536] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 66 msecs
[   19.538546] calling  serial8250_pci_init+0x0/0x1b
[   19.543266] bus: 'pci': add driver serial
[   19.547437] initcall serial8250_pci_init+0x0/0x1b returned 0 after 3 msecs
[   19.554361] calling  jsm_init_module+0x0/0x48
[   19.558751] bus: 'pci': add driver jsm
[   19.562651] initcall jsm_init_module+0x0/0x48 returned 0 after 3 msecs
[   19.569227] calling  init_kgdboc+0x0/0x16
[   19.575808] initcall init_kgdboc+0x0/0x16 returned 0 after 0 msecs
[   19.582039] calling  topology_sysfs_init+0x0/0x48
[   19.586796] initcall topology_sysfs_init+0x0/0x48 returned 0 after 0 msecs
[   19.593719] calling  brd_init+0x0/0x19d
[   19.598128] device: 'ram0': device_add
[   19.601920] PM: Adding info for No Bus:ram0
[   19.606247] device: '1:0': device_add
[   19.609946] PM: Adding info for No Bus:1:0
[   19.614170] device: 'ram1': device_add
[   19.617970] PM: Adding info for No Bus:ram1
[   19.622274] device: '1:1': device_add
[   19.625972] PM: Adding info for No Bus:1:1
[   19.630190] device: 'ram2': device_add
[   19.633998] PM: Adding info for No Bus:ram2
[   19.638314] device: '1:2': device_add
[   19.642020] PM: Adding info for No Bus:1:2
[   19.646252] device: 'ram3': device_add
[   19.650054] PM: Adding info for No Bus:ram3
[   19.654356] device: '1:3': device_add
[   19.658053] PM: Adding info for No Bus:1:3
[   19.662271] device: 'ram4': device_add
[   19.666071] PM: Adding info for No Bus:ram4
[   19.670378] device: '1:4': device_add
[   19.674076] PM: Adding info for No Bus:1:4
[   19.678293] device: 'ram5': device_add
[   19.682091] PM: Adding info for No Bus:ram5
[   19.686394] device: '1:5': device_add
[   19.690092] PM: Adding info for No Bus:1:5
[   19.694310] device: 'ram6': device_add
[   19.698108] PM: Adding info for No Bus:ram6
[   19.702420] device: '1:6': device_add
[   19.706118] PM: Adding info for No Bus:1:6
[   19.710335] device: 'ram7': device_add
[   19.714129] PM: Adding info for No Bus:ram7
[   19.718438] device: '1:7': device_add
[   19.722135] PM: Adding info for No Bus:1:7
[   19.726352] device: 'ram8': device_add
[   19.730144] PM: Adding info for No Bus:ram8
[   19.734444] device: '1:8': device_add
[   19.738147] PM: Adding info for No Bus:1:8
[   19.742365] device: 'ram9': device_add
[   19.746159] PM: Adding info for No Bus:ram9
[   19.750462] device: '1:9': device_add
[   19.754165] PM: Adding info for No Bus:1:9
[   19.758392] device: 'ram10': device_add
[   19.762272] PM: Adding info for No Bus:ram10
[   19.766670] device: '1:10': device_add
[   19.770470] PM: Adding info for No Bus:1:10
[   19.774787] device: 'ram11': device_add
[   19.778667] PM: Adding info for No Bus:ram11
[   19.783057] device: '1:11': device_add
[   19.786849] PM: Adding info for No Bus:1:11
[   19.791156] device: 'ram12': device_add
[   19.795036] PM: Adding info for No Bus:ram12
[   19.799425] device: '1:12': device_add
[   19.803210] PM: Adding info for No Bus:1:12
[   19.807523] device: 'ram13': device_add
[   19.811404] PM: Adding info for No Bus:ram13
[   19.815793] device: '1:13': device_add
[   19.819576] PM: Adding info for No Bus:1:13
[   19.823882] device: 'ram14': device_add
[   19.827768] PM: Adding info for No Bus:ram14
[   19.832164] device: '1:14': device_add
[   19.835947] PM: Adding info for No Bus:1:14
[   19.840254] device: 'ram15': device_add
[   19.844149] PM: Adding info for No Bus:ram15
[   19.848539] device: '1:15': device_add
[   19.852324] PM: Adding info for No Bus:1:15
[   19.856631] brd: module loaded
[   19.859705] initcall brd_init+0x0/0x19d returned 0 after 249 msecs
[   19.865934] calling  loop_init+0x0/0x1a6
[   19.870144] device: 'loop0': device_add
[   19.874029] PM: Adding info for No Bus:loop0
[   19.878419] device: '7:0': device_add
[   19.882117] PM: Adding info for No Bus:7:0
[   19.886335] device: 'loop1': device_add
[   19.890221] PM: Adding info for No Bus:loop1
[   19.894610] device: '7:1': device_add
[   19.898308] PM: Adding info for No Bus:7:1
[   19.902525] device: 'loop2': device_add
[   19.906411] PM: Adding info for No Bus:loop2
[   19.910801] device: '7:2': device_add
[   19.914498] PM: Adding info for No Bus:7:2
[   19.918716] device: 'loop3': device_add
[   19.922610] PM: Adding info for No Bus:loop3
[   19.926998] device: '7:3': device_add
[   19.930696] PM: Adding info for No Bus:7:3
[   19.934925] device: 'loop4': device_add
[   19.938806] PM: Adding info for No Bus:loop4
[   19.943201] device: '7:4': device_add
[   19.946899] PM: Adding info for No Bus:7:4
[   19.951117] device: 'loop5': device_add
[   19.954996] PM: Adding info for No Bus:loop5
[   19.959409] device: '7:5': device_add
[   19.963113] PM: Adding info for No Bus:7:5
[   19.967331] device: 'loop6': device_add
[   19.971211] PM: Adding info for No Bus:loop6
[   19.975600] device: '7:6': device_add
[   19.979304] PM: Adding info for No Bus:7:6
[   19.983530] device: 'loop7': device_add
[   19.987411] PM: Adding info for No Bus:loop7
[   19.991808] device: '7:7': device_add
[   19.995512] PM: Adding info for No Bus:7:7
[   19.999731] loop: module loaded
[   20.002894] initcall loop_init+0x0/0x1a6 returned 0 after 126 msecs
[   20.009209] calling  cpqarray_init+0x0/0x264
[   20.013495] Compaq SMART2 Driver (v 2.6.0)
[   20.017609] bus: 'pci': add driver cpqarray
[   20.021942] initcall cpqarray_init+0x0/0x264 returned 0 after 8 msecs
[   20.028431] calling  DAC960_init_module+0x0/0x52
[   20.033064] bus: 'pci': add driver DAC960
[   20.037222] device: 'dac960_gam': device_add
[   20.041552] PM: Adding info for No Bus:dac960_gam
[   20.046366] initcall DAC960_init_module+0x0/0x52 returned 0 after 12 msecs
[   20.053292] calling  pkt_init+0x0/0x198
[   20.057196] device class 'pktcdvd': registering
[   20.061856] device: 'pktcdvd': device_add
[   20.065917] PM: Adding info for No Bus:pktcdvd
[   20.070478] initcall pkt_init+0x0/0x198 returned 0 after 12 msecs
[   20.076618] calling  mm_init+0x0/0x192
[   20.080387] bus: 'pci': add driver umem
[   20.084375] MM: desc_per_page = 128
[   20.087882] initcall mm_init+0x0/0x192 returned 0 after 7 msecs
[   20.093852] calling  nbd_init+0x0/0x304
[   20.098569] nbd: registered device at major 43
[   20.103032] device: 'nbd0': device_add
[   20.106825] PM: Adding info for No Bus:nbd0
[   20.111151] device: '43:0': device_add
[   20.114936] PM: Adding info for No Bus:43:0
[   20.119243] device: 'nbd1': device_add
[   20.123042] PM: Adding info for No Bus:nbd1
[   20.127370] device: '43:1': device_add
[   20.131155] PM: Adding info for No Bus:43:1
[   20.135462] device: 'nbd2': device_add
[   20.139269] PM: Adding info for No Bus:nbd2
[   20.143588] device: '43:2': device_add
[   20.147381] PM: Adding info for No Bus:43:2
[   20.151685] device: 'nbd3': device_add
[   20.155479] PM: Adding info for No Bus:nbd3
[   20.159802] device: '43:3': device_add
[   20.163588] PM: Adding info for No Bus:43:3
[   20.167906] device: 'nbd4': device_add
[   20.171707] PM: Adding info for No Bus:nbd4
[   20.176027] device: '43:4': device_add
[   20.179811] PM: Adding info for No Bus:43:4
[   20.184117] device: 'nbd5': device_add
[   20.187915] PM: Adding info for No Bus:nbd5
[   20.192241] device: '43:5': device_add
[   20.196033] PM: Adding info for No Bus:43:5
[   20.200337] device: 'nbd6': device_add
[   20.204129] PM: Adding info for No Bus:nbd6
[   20.208448] device: '43:6': device_add
[   20.212240] PM: Adding info for No Bus:43:6
[   20.216546] device: 'nbd7': device_add
[   20.220341] PM: Adding info for No Bus:nbd7
[   20.224665] device: '43:7': device_add
[   20.228448] PM: Adding info for No Bus:43:7
[   20.232754] device: 'nbd8': device_add
[   20.236555] PM: Adding info for No Bus:nbd8
[   20.240890] device: '43:8': device_add
[   20.244670] PM: Adding info for No Bus:43:8
[   20.248974] device: 'nbd9': device_add
[   20.252770] PM: Adding info for No Bus:nbd9
[   20.257094] device: '43:9': device_add
[   20.260884] PM: Adding info for No Bus:43:9
[   20.265189] device: 'nbd10': device_add
[   20.269069] PM: Adding info for No Bus:nbd10
[   20.273481] device: '43:10': device_add
[   20.277353] PM: Adding info for No Bus:43:10
[   20.281754] device: 'nbd11': device_add
[   20.285635] PM: Adding info for No Bus:nbd11
[   20.290061] device: '43:11': device_add
[   20.293932] PM: Adding info for No Bus:43:11
[   20.298336] device: 'nbd12': device_add
[   20.302224] PM: Adding info for No Bus:nbd12
[   20.306657] device: '43:12': device_add
[   20.310534] PM: Adding info for No Bus:43:12
[   20.314926] device: 'nbd13': device_add
[   20.318814] PM: Adding info for No Bus:nbd13
[   20.323220] device: '43:13': device_add
[   20.329653] PM: Adding info for No Bus:43:13
[   20.334045] device: 'nbd14': device_add
[   20.337925] PM: Adding info for No Bus:nbd14
[   20.342338] device: '43:14': device_add
[   20.346221] PM: Adding info for No Bus:43:14
[   20.350614] device: 'nbd15': device_add
[   20.354498] PM: Adding info for No Bus:nbd15
[   20.358910] device: '43:15': device_add
[   20.362782] PM: Adding info for No Bus:43:15
[   20.367174] initcall nbd_init+0x0/0x304 returned 0 after 256 msecs
[   20.373404] calling  carm_init+0x0/0x1b
[   20.377258] bus: 'pci': add driver sx8
[   20.381152] initcall carm_init+0x0/0x1b returned 0 after 3 msecs
[   20.387206] calling  ub_init+0x0/0x88
[   20.390889] bus: 'usb': add driver ub
[   20.394690] usbcore: registered new interface driver ub
[   20.399940] initcall ub_init+0x0/0x88 returned 0 after 8 msecs
[   20.405822] calling  xlblk_init+0x0/0x7a
[   20.409761] initcall xlblk_init+0x0/0x7a returned -19 after 0 msecs
[   20.416073] calling  eeepc_laptop_init+0x0/0x1eb
[   20.420707] bus: 'acpi': add driver Eee PC Hotkey Driver
[   20.426212] bus: 'acpi': remove driver Eee PC Hotkey Driver
[   20.431899] driver: 'Eee PC Hotkey Driver': driver_release
[   20.437401] initcall eeepc_laptop_init+0x0/0x1eb returned -19 after 15 msecs
[   20.444493] calling  msi_init+0x0/0x13a
[   20.448348] initcall msi_init+0x0/0x13a returned -19 after 0 msecs
[   20.454577] calling  compal_init+0x0/0x118
[   20.458690] initcall compal_init+0x0/0x118 returned -19 after 0 msecs
[   20.465179] calling  hp_wmi_init+0x0/0x152
[   20.469293] initcall hp_wmi_init+0x0/0x152 returned 0 after 0 msecs
[   20.475604] calling  tifm_7xx1_init+0x0/0x1b
[   20.479891] bus: 'pci': add driver tifm_7xx1
[   20.484309] initcall tifm_7xx1_init+0x0/0x1b returned 0 after 4 msecs
[   20.490798] calling  phantom_init+0x0/0x10a
[   20.494999] device class 'phantom': registering
[   20.499647] bus: 'pci': add driver phantom
[   20.503892] Phantom Linux Driver, version n0.9.8, init OK
[   20.509305] initcall phantom_init+0x0/0x10a returned 0 after 13 msecs
[   20.515792] calling  ioc4_init+0x0/0x20
[   20.519646] bus: 'pci': add driver IOC4
[   20.523629] initcall ioc4_init+0x0/0x20 returned 0 after 3 msecs
[   20.529686] calling  thinkpad_acpi_module_init+0x0/0x945
[   20.535056] initcall thinkpad_acpi_module_init+0x0/0x945 returned -19 after 0 msecs
[   20.542763] calling  enclosure_init+0x0/0x19
[   20.547049] device class 'enclosure': registering
[   20.551867] initcall enclosure_init+0x0/0x19 returned 0 after 4 msecs
[   20.558357] calling  init_kgdbts+0x0/0x16
[   20.562384] initcall init_kgdbts+0x0/0x16 returned 0 after 0 msecs
[   20.568610] calling  xp_init+0x0/0x52
[   20.572290] initcall xp_init+0x0/0x52 returned -19 after 0 msecs
[   20.578344] calling  xpc_init+0x0/0x38e
[   20.582198] initcall xpc_init+0x0/0x38e returned -19 after 0 msecs
[   20.588423] calling  xpnet_init+0x0/0x1c7
[   20.592451] initcall xpnet_init+0x0/0x1c7 returned -19 after 0 msecs
[   20.598852] calling  gru_init+0x0/0x469
[   20.602706] initcall gru_init+0x0/0x469 returned 0 after 0 msecs
[   20.608757] calling  pasic3_base_init+0x0/0x19
[   20.613222] bus: 'platform': add driver pasic3
[   20.617798] bus: 'platform': remove driver pasic3
[   20.622616] driver: 'pasic3': driver_release
[   20.626906] initcall pasic3_base_init+0x0/0x19 returned -19 after 13 msecs
[   20.633828] calling  e1000_init_module+0x0/0x87
[   20.638374] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[   20.644826] Copyright (c) 1999-2006 Intel Corporation.
[   20.649979] bus: 'pci': add driver e1000
[   20.654058] initcall e1000_init_module+0x0/0x87 returned 0 after 14 msecs
[   20.660893] calling  e1000_init_module+0x0/0x6b
[   20.665439] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   20.671543] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   20.677389] bus: 'pci': add driver e1000e
[   20.681445] bus: 'pci': driver_probe_device: matched device 0000:04:00.0 with driver e1000e
[   20.689808] bus: 'pci': really_probe: probing driver e1000e with device 0000:04:00.0
[   20.697610] vendor=8086 device=27e2
[   20.701118] e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.708098] e1000e 0000:04:00.0: setting latency timer to 64
[   20.827062] device: 'eth0': device_add
[   20.830922] PM: Adding info for No Bus:eth0
[   20.835279] 0000:04:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:ab:6e:84
[   20.842689] 0000:04:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   20.849120] 0000:04:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[   20.855312] driver: '0000:04:00.0': driver_bound: bound to device 'e1000e'
[   20.862198] bus: 'pci': really_probe: bound device 0000:04:00.0 to driver e1000e
[   20.869729] initcall e1000_init_module+0x0/0x6b returned 0 after 194 msecs
[   20.876649] calling  igb_init_module+0x0/0x6d
[   20.881021] Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
[   20.887731] Copyright (c) 2008 Intel Corporation.
[   20.892451] bus: 'pci': add driver igb
[   20.896348] initcall igb_init_module+0x0/0x6d returned 0 after 14 msecs
[   20.903011] calling  ixgbe_init_module+0x0/0x66
[   20.907556] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.3.18-k4
[   20.915396] ixgbe: Copyright (c) 1999-2007 Intel Corporation.
[   20.921155] bus: 'pci': add driver ixgbe
[   20.925222] initcall ixgbe_init_module+0x0/0x66 returned 0 after 16 msecs
[   20.932055] calling  ixgb_init_module+0x0/0x4c
[   20.936515] Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   20.943140] Copyright (c) 1999-2008 Intel Corporation.
[   20.948292] bus: 'pci': add driver ixgb
[   20.952275] initcall ixgb_init_module+0x0/0x4c returned 0 after 15 msecs
[   20.959023] calling  ipg_init_module+0x0/0x1b
[   20.963395] bus: 'pci': add driver Sundance Technology IPG Triple-Speed Ethernet
[   20.970934] initcall ipg_init_module+0x0/0x1b returned 0 after 7 msecs
[   20.977509] calling  cxgb3_init_module+0x0/0x20
[   20.982055] bus: 'pci': add driver cxgb3
[   20.986131] initcall cxgb3_init_module+0x0/0x20 returned 0 after 3 msecs
[   20.992876] calling  bonding_init+0x0/0x8df
[   20.997076] Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
[   21.003355] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[   21.020564] device: 'bond0': device_add
[   21.024509] PM: Adding info for No Bus:bond0
[   21.028975] initcall bonding_init+0x0/0x8df returned 0 after 30 msecs
[   21.035463] calling  atl1_init_module+0x0/0x1b
[   21.039924] bus: 'pci': add driver atl1
[   21.043909] initcall atl1_init_module+0x0/0x1b returned 0 after 3 msecs
[   21.050571] calling  bdx_module_init+0x0/0x9a
[   21.054947] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   21.060705] tehuti: Options: hw_csum 
[   21.064384] bus: 'pci': add driver tehuti
[   21.068541] initcall bdx_module_init+0x0/0x9a returned 0 after 12 msecs
[   21.075203] calling  rr_init_module+0x0/0x1b
[   21.079490] bus: 'pci': add driver rrunner
[   21.083740] initcall rr_init_module+0x0/0x1b returned 0 after 4 msecs
[   21.090229] calling  happy_meal_probe+0x0/0x1b
[   21.094689] bus: 'pci': add driver hme
[   21.098583] initcall happy_meal_probe+0x0/0x1b returned 0 after 3 msecs
[   21.105246] calling  vortex_init+0x0/0xad
[   21.109276] bus: 'pci': add driver 3c59x
[   21.113344] initcall vortex_init+0x0/0xad returned 0 after 3 msecs
[   21.119571] calling  typhoon_init+0x0/0x1b
[   21.123684] bus: 'pci': add driver typhoon
[   21.127927] initcall typhoon_init+0x0/0x1b returned 0 after 4 msecs
[   21.134242] calling  ne2k_pci_init+0x0/0x1b
[   21.138441] bus: 'pci': add driver ne2k-pci
[   21.142772] initcall ne2k_pci_init+0x0/0x1b returned 0 after 4 msecs
[   21.149175] calling  pcnet32_init_module+0x0/0x129
[   21.153980] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   21.160084] bus: 'pci': add driver pcnet32
[   21.164332] initcall pcnet32_init_module+0x0/0x129 returned 0 after 9 msecs
[   21.171337] calling  eepro100_init_module+0x0/0x1b
[   21.176143] bus: 'pci': add driver eepro100
[   21.180485] initcall eepro100_init_module+0x0/0x1b returned 0 after 4 msecs
[   21.187493] calling  e100_init_module+0x0/0x5d
[   21.191952] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   21.198056] e100: Copyright(c) 1999-2006 Intel Corporation
[   21.203553] bus: 'pci': add driver e100
[   21.207540] initcall e100_init_module+0x0/0x5d returned 0 after 14 msecs
[   21.214288] calling  epic_init+0x0/0x1b
[   21.218141] bus: 'pci': add driver epic100
[   21.222384] initcall epic_init+0x0/0x1b returned 0 after 4 msecs
[   21.228437] calling  sis900_init_module+0x0/0x1b
[   21.233069] bus: 'pci': add driver sis900
[   21.237224] initcall sis900_init_module+0x0/0x1b returned 0 after 3 msecs
[   21.244062] calling  yellowfin_init+0x0/0x1b
[   21.248349] bus: 'pci': add driver yellowfin
[   21.252773] initcall yellowfin_init+0x0/0x1b returned 0 after 4 msecs
[   21.259261] calling  natsemi_init_mod+0x0/0x1b
[   21.263721] bus: 'pci': add driver natsemi
[   21.267964] initcall natsemi_init_mod+0x0/0x1b returned 0 after 4 msecs
[   21.274626] calling  ns83820_init+0x0/0x29
[   21.278738] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   21.285536] bus: 'pci': add driver ns83820
[   21.289777] initcall ns83820_init+0x0/0x29 returned 0 after 10 msecs
[   21.296178] calling  tg3_init+0x0/0x1b
[   21.299945] bus: 'pci': add driver tg3
[   21.303845] initcall tg3_init+0x0/0x1b returned 0 after 3 msecs
[   21.309815] calling  bnx2_init+0x0/0x1b
[   21.313668] bus: 'pci': add driver bnx2
[   21.317651] initcall bnx2_init+0x0/0x1b returned 0 after 3 msecs
[   21.323704] calling  sky2_init_module+0x0/0x1b
[   21.328165] bus: 'pci': add driver sky2
[   21.332156] initcall sky2_init_module+0x0/0x1b returned 0 after 3 msecs
[   21.338818] calling  rhine_init+0x0/0x63
[   21.345314] bus: 'pci': add driver via-rhine
[   21.349730] initcall rhine_init+0x0/0x63 returned 0 after 4 msecs
[   21.355869] calling  velocity_init_module+0x0/0x3b
[   21.360675] bus: 'pci': add driver via-velocity
[   21.365348] initcall velocity_init_module+0x0/0x3b returned 0 after 4 msecs
[   21.372354] calling  marvell_init+0x0/0x71
[   21.376467] bus: 'mdio_bus': add driver Marvell 88E1101
[   21.381809] bus: 'mdio_bus': add driver Marvell 88E1112
[   21.387153] bus: 'mdio_bus': add driver Marvell 88E1111
[   21.392494] bus: 'mdio_bus': add driver Marvell 88E1145
[   21.397845] bus: 'mdio_bus': add driver Marvell 88E1240
[   21.403187] initcall marvell_init+0x0/0x71 returned 0 after 25 msecs
[   21.409590] calling  davicom_init+0x0/0x5d
[   21.413702] bus: 'mdio_bus': add driver Davicom DM9161E
[   21.419043] bus: 'mdio_bus': add driver Davicom DM9161A
[   21.424385] bus: 'mdio_bus': add driver Davicom DM9131
[   21.429640] initcall davicom_init+0x0/0x5d returned 0 after 15 msecs
[   21.436040] calling  cicada_init+0x0/0x3f
[   21.440067] bus: 'mdio_bus': add driver Cicada Cis8204
[   21.445319] bus: 'mdio_bus': add driver Cicada Cis8201
[   21.450584] initcall cicada_init+0x0/0x3f returned 0 after 10 msecs
[   21.456898] calling  qs6612_init+0x0/0x12
[   21.460925] bus: 'mdio_bus': add driver QS6612
[   21.465493] initcall qs6612_init+0x0/0x12 returned 0 after 4 msecs
[   21.471719] calling  broadcom_init+0x0/0xbb
[   21.475918] bus: 'mdio_bus': add driver Broadcom BCM5411
[   21.481345] bus: 'mdio_bus': add driver Broadcom BCM5421
[   21.486776] bus: 'mdio_bus': add driver Broadcom BCM5461
[   21.492205] bus: 'mdio_bus': add driver Broadcom BCM5464
[   21.497636] bus: 'mdio_bus': add driver Broadcom BCM5481
[   21.503066] bus: 'mdio_bus': add driver Broadcom BCM5482
[   21.508504] initcall broadcom_init+0x0/0xbb returned 0 after 31 msecs
[   21.514995] calling  realtek_init+0x0/0x12
[   21.519107] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[   21.525240] initcall realtek_init+0x0/0x12 returned 0 after 5 msecs
[   21.531552] calling  fixed_mdio_bus_init+0x0/0xa8
[   21.536274] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   21.543509] device: 'Fixed MDIO bus.0': device_add
[   21.548322] bus: 'platform': add device Fixed MDIO bus.0
[   21.553661] PM: Adding info for platform:Fixed MDIO bus.0
[   21.559171] Fixed MDIO Bus: probed
[   21.562593] initcall fixed_mdio_bus_init+0x0/0xa8 returned 0 after 25 msecs
[   21.569601] calling  hamachi_init+0x0/0x1b
[   21.573714] bus: 'pci': add driver hamachi
[   21.577957] initcall hamachi_init+0x0/0x1b returned 0 after 4 msecs
[   21.584269] calling  net_olddevs_init+0x0/0xa0
[   21.588732] initcall net_olddevs_init+0x0/0xa0 returned 0 after 0 msecs
[   21.595390] calling  hp100_module_init+0x0/0x1b
[   21.599937] bus: 'pci': add driver hp100
[   21.604005] initcall hp100_module_init+0x0/0x1b returned 0 after 3 msecs
[   21.610754] calling  b44_init+0x0/0x5c
[   21.614521] bus: 'pci': add driver b44
[   21.618424] bus: 'ssb': add driver b44
[   21.622294] initcall b44_init+0x0/0x5c returned 0 after 7 msecs
[   21.628260] calling  init_nic+0x0/0x1b
[   21.632028] bus: 'pci': add driver forcedeth
[   21.636447] initcall init_nic+0x0/0x1b returned 0 after 4 msecs
[   21.642420] calling  netif_init+0x0/0x6a
[   21.646359] initcall netif_init+0x0/0x6a returned -19 after 0 msecs
[   21.652673] calling  dummy_init_module+0x0/0xb5
[   21.657237] device: 'dummy0': device_add
[   21.661262] PM: Adding info for No Bus:dummy0
[   21.665756] initcall dummy_init_module+0x0/0xb5 returned 0 after 8 msecs
[   21.672502] calling  macvlan_init_module+0x0/0x53
[   21.677224] initcall macvlan_init_module+0x0/0x53 returned 0 after 0 msecs
[   21.684141] calling  cp_init+0x0/0x1b
[   21.687822] bus: 'pci': add driver 8139cp
[   21.691989] initcall cp_init+0x0/0x1b returned 0 after 3 msecs
[   21.697871] calling  rtl8139_init_module+0x0/0x1b
[   21.702591] bus: 'pci': add driver 8139too
[   21.706835] initcall rtl8139_init_module+0x0/0x1b returned 0 after 4 msecs
[   21.713757] calling  sc92031_init+0x0/0x29
[   21.717869] Silan SC92031 PCI Fast Ethernet Adapter driver 2.0c
[   21.723800] bus: 'pci': add driver sc92031
[   21.728042] initcall sc92031_init+0x0/0x29 returned 0 after 9 msecs
[   21.734357] calling  eql_init_module+0x0/0x65
[   21.738728] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   21.747272] device: 'eql': device_add
[   21.751038] PM: Adding info for No Bus:eql
[   21.755288] initcall eql_init_module+0x0/0x65 returned 0 after 15 msecs
[   21.761953] calling  tun_init+0x0/0xa0
[   21.765720] tun: Universal TUN/TAP device driver, 1.6
[   21.770786] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   21.777003] device: 'tun': device_add
[   21.780739] PM: Adding info for No Bus:tun
[   21.784947] initcall tun_init+0x0/0xa0 returned 0 after 18 msecs
[   21.791003] calling  veth_init+0x0/0x1e
[   21.794857] initcall veth_init+0x0/0x1e returned 0 after 0 msecs
[   21.800909] calling  rio_init+0x0/0x1b
[   21.804675] bus: 'pci': add driver dl2k
[   21.808658] initcall rio_init+0x0/0x1b returned 0 after 3 msecs
[   21.814628] calling  rtl8169_init_module+0x0/0x1b
[   21.819348] bus: 'pci': add driver r8169
[   21.823424] initcall rtl8169_init_module+0x0/0x1b returned 0 after 3 msecs
[   21.830346] calling  amd8111e_init+0x0/0x1b
[   21.834546] bus: 'pci': add driver amd8111e
[   21.838876] initcall amd8111e_init+0x0/0x1b returned 0 after 4 msecs
[   21.845279] calling  s2io_starter+0x0/0x1b
[   21.849392] bus: 'pci': add driver S2IO
[   21.853372] initcall s2io_starter+0x0/0x1b returned 0 after 3 msecs
[   21.859684] calling  myri10ge_init_module+0x0/0x70
[   21.864489] myri10ge: Version 1.4.3-1.358
[   21.868514] bus: 'pci': add driver myri10ge
[   21.872846] initcall myri10ge_init_module+0x0/0x70 returned 0 after 7 msecs
[   21.879851] calling  mlx4_init+0x0/0x34
[   21.883757] bus: 'pci': add driver mlx4_core
[   21.888178] initcall mlx4_init+0x0/0x34 returned 0 after 4 msecs
[   21.894236] calling  enc28j60_init+0x0/0x23
[   21.898438] bus: 'spi': add driver enc28j60
[   21.902741] initcall enc28j60_init+0x0/0x23 returned 0 after 4 msecs
[   21.909144] calling  ipddp_init_module+0x0/0x108
[   21.913782] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   21.921369] device: 'ipddp0': device_add
[   21.925394] PM: Adding info for No Bus:ipddp0
[   21.929888] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   21.938685] initcall ipddp_init_module+0x0/0x108 returned 0 after 23 msecs
[   21.945608] calling  arcnet_init+0x0/0x5d
[   21.949635] arcnet loaded.
[   21.952360] initcall arcnet_init+0x0/0x5d returned 0 after 2 msecs
[   21.958588] calling  arcnet_rfc1201_init+0x0/0x73
[   21.963306] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   21.970191] initcall arcnet_rfc1201_init+0x0/0x73 returned 0 after 6 msecs
[   21.977112] calling  arcnet_rfc1051_init+0x0/0x47
[   21.981831] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   21.989325] initcall arcnet_rfc1051_init+0x0/0x47 returned 0 after 7 msecs
[   21.996243] calling  arcnet_raw_init+0x0/0x5f
[   22.000614] arcnet: raw mode (`r') encapsulation support loaded.
[   22.006633] initcall arcnet_raw_init+0x0/0x5f returned 0 after 5 msecs
[   22.013208] calling  com90xx_init+0x0/0xeea
[   22.017427] arcnet: COM90xx chipset support
[   22.319635] S3: No ARCnet cards found.
[   22.323406] initcall com90xx_init+0x0/0xeea returned -5 after 291 msecs
[   22.330068] initcall com90xx_init+0x0/0xeea returned with error code -5 
[   22.336815] calling  com90io_init+0x0/0x493
[   22.341022] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   22.348256] E-mail me if you actually test this driver, please!
[   22.354186]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   22.362291] initcall com90io_init+0x0/0x493 returned -19 after 20 msecs
[   22.368950] calling  arc_rimi_init+0x0/0x4b1
[   22.373241] arcnet: RIM I (entirely mem-mapped) support
[   22.378479] E-mail me if you actually test the RIM I driver, please!
[   22.384842]  arc%d: Given: node 00h, shmem 0h, irq 0
[   22.389820]  arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
[   22.397146] initcall arc_rimi_init+0x0/0x4b1 returned -5 after 22 msecs
[   22.403805] initcall arc_rimi_init+0x0/0x4b1 returned with error code -5 
[   22.410644] calling  catc_init+0x0/0x39
[   22.414498] bus: 'usb': add driver catc
[   22.418465] usbcore: registered new interface driver catc
[   22.423880] catc: v2.8 CATC EL1210A NetMate USB Ethernet driver
[   22.429812] initcall catc_init+0x0/0x39 returned 0 after 14 msecs
[   22.435951] calling  kaweth_init+0x0/0x30
[   22.439978] drivers/net/usb/kaweth.c: Driver loading
[   22.444956] bus: 'usb': add driver kaweth
[   22.449102] usbcore: registered new interface driver kaweth
[   22.454692] initcall kaweth_init+0x0/0x30 returned 0 after 14 msecs
[   22.461005] calling  pegasus_init+0x0/0x19b
[   22.465206] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   22.472761] bus: 'usb': add driver pegasus
[   22.476988] usbcore: registered new interface driver pegasus
[   22.482663] initcall pegasus_init+0x0/0x19b returned 0 after 16 msecs
[   22.489152] calling  usb_rtl8150_init+0x0/0x29
[   22.493611] rtl8150: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
[   22.500496] bus: 'usb': add driver rtl8150
[   22.504719] usbcore: registered new interface driver rtl8150
[   22.510394] initcall usb_rtl8150_init+0x0/0x29 returned 0 after 16 msecs
[   22.517144] calling  asix_init+0x0/0x1b
[   22.520993] bus: 'usb': add driver asix
[   22.524957] usbcore: registered new interface driver asix
[   22.530373] initcall asix_init+0x0/0x1b returned 0 after 8 msecs
[   22.536424] calling  cdc_init+0x0/0x1b
[   22.540192] bus: 'usb': add driver cdc_ether
[   22.547142] usbcore: registered new interface driver cdc_ether
[   22.552992] initcall cdc_init+0x0/0x1b returned 0 after 12 msecs
[   22.559048] calling  dm9601_init+0x0/0x1b
[   22.563075] bus: 'usb': add driver dm9601
[   22.567212] usbcore: registered new interface driver dm9601
[   22.572807] initcall dm9601_init+0x0/0x1b returned 0 after 9 msecs
[   22.579036] calling  usbnet_init+0x0/0x1b
[   22.583062] bus: 'usb': add driver gl620a
[   22.587200] usbcore: registered new interface driver gl620a
[   22.592789] initcall usbnet_init+0x0/0x1b returned 0 after 9 msecs
[   22.599016] calling  plusb_init+0x0/0x1b
[   22.602955] bus: 'usb': add driver plusb
[   22.607016] usbcore: registered new interface driver plusb
[   22.612520] initcall plusb_init+0x0/0x1b returned 0 after 9 msecs
[   22.618660] calling  rndis_init+0x0/0x1b
[   22.622599] bus: 'usb': add driver rndis_host
[   22.627083] usbcore: registered new interface driver rndis_host
[   22.633019] initcall rndis_init+0x0/0x1b returned 0 after 9 msecs
[   22.639160] calling  cdc_subset_init+0x0/0x1b
[   22.643532] bus: 'usb': add driver cdc_subset
[   22.648014] usbcore: registered new interface driver cdc_subset
[   22.653949] initcall cdc_subset_init+0x0/0x1b returned 0 after 9 msecs
[   22.660521] calling  mcs7830_init+0x0/0x1b
[   22.664634] bus: 'usb': add driver MOSCHIP usb-ethernet driver
[   22.670593] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   22.678005] initcall mcs7830_init+0x0/0x1b returned 0 after 12 msecs
[   22.684404] calling  usbnet_init+0x0/0x2b
[   22.688435] initcall usbnet_init+0x0/0x2b returned 0 after 0 msecs
[   22.694663] calling  strip_init_driver+0x0/0x6a
[   22.699208] STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
[   22.705579] initcall strip_init_driver+0x0/0x6a returned 0 after 6 msecs
[   22.712323] calling  sixpack_init_driver+0x0/0x44
[   22.717042] AX.25: 6pack driver, Revision: 0.3.0
[   22.721676] initcall sixpack_init_driver+0x0/0x44 returned 0 after 4 msecs
[   22.728593] calling  bpq_init_driver+0x0/0x65
[   22.732970] AX.25: bpqether driver version 004
[   22.737431] initcall bpq_init_driver+0x0/0x65 returned 0 after 4 msecs
[   22.744004] calling  init_baycomserfdx+0x0/0x104
[   22.748638] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   22.748638] baycom_ser_fdx: version 0.10 compiled 13:52:58 Sep 10 2008
[   22.761630] device: 'bcsf0': device_add
[   22.765574] PM: Adding info for No Bus:bcsf0
[   22.769990] device: 'bcsf1': device_add
[   22.773931] PM: Adding info for No Bus:bcsf1
[   22.778353] device: 'bcsf2': device_add
[   22.782294] PM: Adding info for No Bus:bcsf2
[   22.786708] device: 'bcsf3': device_add
[   22.790644] PM: Adding info for No Bus:bcsf3
[   22.795052] initcall init_baycomserfdx+0x0/0x104 returned 0 after 44 msecs
[   22.801974] calling  hdlcdrv_init_driver+0x0/0x24
[   22.806695] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   22.812453] hdlcdrv: version 0.8 compiled 13:53:03 Sep 10 2008
[   22.818299] initcall hdlcdrv_init_driver+0x0/0x24 returned 0 after 11 msecs
[   22.825306] calling  init_baycomserhdx+0x0/0xf2
[   22.829851] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   22.829852] baycom_ser_hdx: version 0.10 compiled 13:53:06 Sep 10 2008
[   22.842843] device: 'bcsh0': device_add
[   22.846812] PM: Adding info for No Bus:bcsh0
[   22.851234] device: 'bcsh1': device_add
[   22.855184] PM: Adding info for No Bus:bcsh1
[   22.859599] device: 'bcsh2': device_add
[   22.863534] PM: Adding info for No Bus:bcsh2
[   22.867948] device: 'bcsh3': device_add
[   22.871888] PM: Adding info for No Bus:bcsh3
[   22.876298] initcall init_baycomserhdx+0x0/0xf2 returned 0 after 44 msecs
[   22.883132] calling  usb_irda_init+0x0/0x3e
[   22.887333] bus: 'usb': add driver irda-usb
[   22.891643] usbcore: registered new interface driver irda-usb
[   22.897406] USB IrDA support registered
[   22.901259] initcall usb_irda_init+0x0/0x3e returned 0 after 13 msecs
[   22.907744] calling  stir_init+0x0/0x1b
[   22.911597] bus: 'usb': add driver stir4200
[   22.915906] usbcore: registered new interface driver stir4200
[   22.921670] initcall stir_init+0x0/0x1b returned 0 after 9 msecs
[   22.927724] calling  nsc_ircc_init+0x0/0x1fe
[   22.932012] bus: 'platform': add driver nsc-ircc
[   22.936769] pnp: the driver 'nsc-ircc' has been registered
[   22.942269] bus: 'pnp': add driver nsc-ircc
[   22.946609] bus: 'platform': remove driver nsc-ircc
[   22.951600] driver: 'nsc-ircc': driver_release
[   22.956072] bus: 'pnp': remove driver nsc-ircc
[   22.960629] driver: 'nsc-ircc': driver_release
[   22.965093] pnp: the driver 'nsc-ircc' has been unregistered
[   22.970764] initcall nsc_ircc_init+0x0/0x1fe returned -19 after 36 msecs
[   22.977512] calling  w83977af_init+0x0/0x4c7
[   22.981859] initcall w83977af_init+0x0/0x4c7 returned -19 after 0 msecs
[   22.988518] calling  smsc_ircc_init+0x0/0x52a
[   22.992890] bus: 'platform': add driver smsc-ircc2
[   22.997943] bus: 'platform': remove driver smsc-ircc2
[   23.003107] driver: 'smsc-ircc2': driver_release
[   23.007742] initcall smsc_ircc_init+0x0/0x52a returned -19 after 14 msecs
[   23.014578] calling  ali_ircc_init+0x0/0x659
[   23.018864] bus: 'platform': add driver ali-ircc
[   23.023655] bus: 'platform': remove driver ali-ircc
[   23.028646] driver: 'ali-ircc': driver_release
[   23.033111] initcall ali_ircc_init+0x0/0x659 returned -19 after 13 msecs
[   23.039857] calling  mcs_init+0x0/0x43
[   23.043623] bus: 'usb': add driver mcs7780
[   23.047846] usbcore: registered new interface driver mcs7780
[   23.053522] initcall mcs_init+0x0/0x43 returned 0 after 9 msecs
[   23.059487] calling  irtty_sir_init+0x0/0x3f
[   23.063774] initcall irtty_sir_init+0x0/0x3f returned 0 after 0 msecs
[   23.070262] calling  sir_wq_init+0x0/0x33
[   23.074343] initcall sir_wq_init+0x0/0x33 returned 0 after 0 msecs
[   23.080569] calling  ksdazzle_init+0x0/0x1b
[   23.084767] bus: 'usb': add driver ksdazzle-sir
[   23.089423] usbcore: registered new interface driver ksdazzle-sir
[   23.095531] initcall ksdazzle_init+0x0/0x1b returned 0 after 10 msecs
[   23.102021] calling  init_netconsole+0x0/0x238
[   23.106494] console [netcon0] enabled
[   23.110174] netconsole: network logging started
[   23.114720] initcall init_netconsole+0x0/0x238 returned 0 after 7 msecs
[   23.121381] calling  netxen_init_module+0x0/0x4d
[   23.126067] bus: 'pci': add driver netxen_nic
[   23.130585] initcall netxen_init_module+0x0/0x4d returned 0 after 4 msecs
[   23.137420] calling  niu_init+0x0/0x3d
[   23.141188] bus: 'pci': add driver niu
[   23.145100] initcall niu_init+0x0/0x3d returned 0 after 3 msecs
[   23.151067] calling  videodev_init+0x0/0x84
[   23.155266] Linux video capture interface: v2.00
[   23.159904] device class 'video4linux': registering
[   23.164900] initcall videodev_init+0x0/0x84 returned 0 after 9 msecs
[   23.171303] calling  dabusb_init+0x0/0xe8
[   23.175331] bus: 'usb': add driver dabusb
[   23.179482] usbcore: registered new interface driver dabusb
[   23.185074] dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
[   23.191438] initcall dabusb_init+0x0/0xe8 returned 0 after 15 msecs
[   23.197754] calling  maxiradio_radio_init+0x0/0x1b
[   23.202559] bus: 'pci': add driver radio-maxiradio
[   23.207506] initcall maxiradio_radio_init+0x0/0x1b returned 0 after 4 msecs
[   23.214513] calling  dsbr100_init+0x0/0x34
[   23.218625] bus: 'usb': add driver dsbr100
[   23.222848] usbcore: registered new interface driver dsbr100
[   23.228523] dsbr100: v0.41:D-Link DSB-R100 USB FM radio driver
[   23.234368] initcall dsbr100_init+0x0/0x34 returned 0 after 15 msecs
[   23.240766] calling  si470x_module_init+0x0/0x29
[   23.245399] USB radio driver for Si470x FM Radio Receivers, Version 1.0.8
[   23.252196] bus: 'usb': add driver radio-si470x
[   23.256851] usbcore: registered new interface driver radio-si470x
[   23.262959] initcall si470x_module_init+0x0/0x29 returned 0 after 16 msecs
[   23.269879] calling  scsi_tgt_init+0x0/0x84
[   23.274439] device: 'tgt': device_add
[   23.278171] PM: Adding info for No Bus:tgt
[   23.282379] initcall scsi_tgt_init+0x0/0x84 returned 0 after 7 msecs
[   23.288779] calling  spi_transport_init+0x0/0x2e
[   23.293410] device class 'spi_transport': registering
[   23.298589] device class 'spi_host': registering
[   23.303319] initcall spi_transport_init+0x0/0x2e returned 0 after 9 msecs
[   23.310154] calling  iscsi_transport_init+0x0/0x14d
[   23.315046] Loading iSCSI transport class v2.0-870.
[   23.319938] device class 'iscsi_transport': registering
[   23.325271] device class 'iscsi_endpoint': registering
[   23.330533] device class 'iscsi_host': registering
[   23.335441] device class 'iscsi_connection': registering
[   23.340876] device class 'iscsi_session': registering
[   23.346111] initcall iscsi_transport_init+0x0/0x14d returned 0 after 29 msecs
[   23.353293] calling  sas_transport_init+0x0/0xbb
[   23.357925] device class 'sas_host': registering
[   23.362655] device class 'sas_phy': registering
[   23.367298] device class 'sas_port': registering
[   23.372028] device class 'sas_device': registering
[   23.376930] device class 'sas_end_device': registering
[   23.382179] device class 'sas_expander': registering
[   23.387256] initcall sas_transport_init+0x0/0xbb returned 0 after 27 msecs
[   23.394179] calling  srp_transport_init+0x0/0x3f
[   23.398810] device class 'srp_host': registering
[   23.403538] device class 'srp_remote_ports': registering
[   23.408962] initcall srp_transport_init+0x0/0x3f returned 0 after 9 msecs
[   23.415792] calling  scsi_dh_init+0x0/0x3f
[   23.419911] initcall scsi_dh_init+0x0/0x3f returned 0 after 0 msecs
[   23.426225] calling  rdac_init+0x0/0x2f
[   23.430085] rdac: device handler registered
[   23.434286] initcall rdac_init+0x0/0x2f returned 0 after 4 msecs
[   23.440337] calling  alua_init+0x0/0x36
[   23.444194] alua: device handler registered
[   23.448392] initcall alua_init+0x0/0x36 returned 0 after 4 msecs
[   23.454447] calling  ahc_linux_init+0x0/0x66
[   23.458737] bus: 'pci': add driver aic7xxx
[   23.462993] initcall ahc_linux_init+0x0/0x66 returned 0 after 4 msecs
[   23.472035] calling  init_osst+0x0/0x136
[   23.475974] osst :I: Tape driver with OnStream support version 0.99.4
[   23.475975] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   23.489133] device class 'onstream_tape': registering
[   23.494298] Driver 'osst' needs updating - please use bus_type methods
[   23.500836] bus: 'scsi': add driver osst
[   23.504879] initcall init_osst+0x0/0x136 returned 0 after 27 msecs
[   23.511110] calling  init_sd+0x0/0xf8
[   23.514811] device class 'scsi_disk': registering
[   23.519628] Driver 'sd' needs updating - please use bus_type methods
[   23.525993] bus: 'scsi': add driver sd
[   23.529875] initcall init_sd+0x0/0xf8 returned 0 after 14 msecs
[   23.535842] calling  init_sg+0x0/0x15a
[   23.539609] device class 'scsi_generic': registering
[   23.544737] initcall init_sg+0x0/0x15a returned 0 after 4 msecs
[   23.550706] calling  init_ch_module+0x0/0xaa
[   23.554992] SCSI Media Changer driver v0.25 
[   23.559278] device class 'scsi_changer': registering
[   23.564358] Driver 'ch' needs updating - please use bus_type methods
[   23.570723] bus: 'scsi': add driver ch
[   23.574589] initcall init_ch_module+0x0/0xaa returned 0 after 18 msecs
[   23.581166] calling  ahci_init+0x0/0x1b
[   23.585016] bus: 'pci': add driver ahci
[   23.589009] initcall ahci_init+0x0/0x1b returned 0 after 3 msecs
[   23.595064] calling  piix_init+0x0/0x29
[   23.598917] bus: 'pci': add driver ata_piix
[   23.603146] bus: 'pci': driver_probe_device: matched device 0000:00:1f.1 with driver ata_piix
[   23.611682] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.1
[   23.619618] ata_piix 0000:00:1f.1: version 2.12
[   23.624175] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   23.631380] ata_piix 0000:00:1f.1: setting latency timer to 64
[   23.637351] scsi0 : ata_piix
[   23.640605] device: 'host0': device_add
[   23.644470] PM: Adding info for No Bus:host0
[   23.648756] device: 'host0': device_add
[   23.652656] PM: Adding info for No Bus:host0
[   23.657133] scsi1 : ata_piix
[   23.660033] device: 'host1': device_add
[   23.663895] PM: Adding info for No Bus:host1
[   23.668182] device: 'host1': device_add
[   23.672078] PM: Adding info for No Bus:host1
[   23.678203] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[   23.685175] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[   23.855329] ata2: port disabled. ignoring.
[   23.859455] driver: '0000:00:1f.1': driver_bound: bound to device 'ata_piix'
[   23.866516] bus: 'pci': really_probe: bound device 0000:00:1f.1 to driver ata_piix
[   23.874100] bus: 'pci': driver_probe_device: matched device 0000:00:1f.2 with driver ata_piix
[   23.882635] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.2
[   23.890582] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   23.897728] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   23.903101] ata_piix 0000:00:1f.2: setting latency timer to 64
[   23.909037] scsi2 : ata_piix
[   23.911938] device: 'host2': device_add
[   23.915800] PM: Adding info for No Bus:host2
[   23.920087] device: 'host2': device_add
[   23.923983] PM: Adding info for No Bus:host2
[   23.928421] scsi3 : ata_piix
[   23.931322] device: 'host3': device_add
[   23.935184] PM: Adding info for No Bus:host3
[   23.939471] device: 'host3': device_add
[   23.943367] PM: Adding info for No Bus:host3
[   23.948335] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[   23.955480] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[   24.124411] ata3.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
[   24.130698] ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   24.152403] ata3.00: configured for UDMA/133
[   24.328382] ata4.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
[   24.334672] ata4.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   24.341396] ata4.01: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
[   24.360404] ata4.00: configured for UDMA/133
[   24.372225] ata4.01: configured for UDMA/66
[   24.376532] isa bounce pool size: 16 pages
[   24.380825] scsi 2:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
[   24.388928] device: 'target2:0:0': device_add
[   24.393311] PM: Adding info for No Bus:target2:0:0
[   24.398118] device: '2:0:0:0': device_add
[   24.402193] bus: 'scsi': add device 2:0:0:0
[   24.406406] PM: Adding info for scsi:2:0:0:0
[   24.410794] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 with driver osst
[   24.418636] bus: 'scsi': really_probe: probing driver osst with device 2:0:0:0
[   24.425884] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 with driver sd
[   24.433552] bus: 'scsi': really_probe: probing driver sd with device 2:0:0:0
[   24.440649] device: '2:0:0:0': device_add
[   24.444710] PM: Adding info for No Bus:2:0:0:0
[   24.449341] sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
[   24.456529] sd 2:0:0:0: [sda] Write Protect is off
[   24.461339] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.466484] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.475543] device: 'sda': device_add
[   24.479272] PM: Adding info for No Bus:sda
[   24.483509] sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
[   24.490693] sd 2:0:0:0: [sda] Write Protect is off
[   24.495499] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.500641] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.509702]  sda: sda1 sda2
[   24.549515] device: 'sda1': device_add
[   24.553316] PM: Adding info for No Bus:sda1
[   24.557528] device: 'sda2': device_add
[   24.561322] PM: Adding info for No Bus:sda2
[   24.565869] device: '8:0': device_add
[   24.569572] PM: Adding info for No Bus:8:0
[   24.573819] sd 2:0:0:0: [sda] Attached SCSI disk
[   24.578454] driver: '2:0:0:0': driver_bound: bound to device 'sd'
[   24.584571] bus: 'scsi': really_probe: bound device 2:0:0:0 to driver sd
[   24.591287] device: '2:0:0:0': device_add
[   24.595334] PM: Adding info for No Bus:2:0:0:0
[   24.599954] device: 'sg0': device_add
[   24.603719] PM: Adding info for No Bus:sg0
[   24.607948] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   24.613318] device: '2:0:0:0': device_add
[   24.617381] PM: Adding info for No Bus:2:0:0:0
[   24.622109] scsi 3:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
[   24.630213] device: 'target3:0:0': device_add
[   24.634596] PM: Adding info for No Bus:target3:0:0
[   24.639403] device: '3:0:0:0': device_add
[   24.643469] bus: 'scsi': add device 3:0:0:0
[   24.647680] PM: Adding info for scsi:3:0:0:0
[   24.652061] bus: 'scsi': driver_probe_device: matched device 3:0:0:0 with driver osst
[   24.659905] bus: 'scsi': really_probe: probing driver osst with device 3:0:0:0
[   24.667155] bus: 'scsi': driver_probe_device: matched device 3:0:0:0 with driver sd
[   24.674823] bus: 'scsi': really_probe: probing driver sd with device 3:0:0:0
[   24.681903] device: '3:0:0:0': device_add
[   24.685965] PM: Adding info for No Bus:3:0:0:0
[   24.690585] sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
[   24.697775] sd 3:0:0:0: [sdb] Write Protect is off
[   24.702581] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   24.707727] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.716787] device: 'sdb': device_add
[   24.720502] PM: Adding info for No Bus:sdb
[   24.724695] sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
[   24.731882] sd 3:0:0:0: [sdb] Write Protect is off
[   24.736690] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   24.741833] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.750893]  sdb: sdb1
[   24.766164] device: 'sdb1': device_add
[   24.769962] PM: Adding info for No Bus:sdb1
[   24.774407] device: '8:16': device_add
[   24.778200] PM: Adding info for No Bus:8:16
[   24.782519] sd 3:0:0:0: [sdb] Attached SCSI disk
[   24.787152] driver: '3:0:0:0': driver_bound: bound to device 'sd'
[   24.793259] bus: 'scsi': really_probe: bound device 3:0:0:0 to driver sd
[   24.799971] device: '3:0:0:0': device_add
[   24.804016] PM: Adding info for No Bus:3:0:0:0
[   24.808587] device: 'sg1': device_add
[   24.812310] PM: Adding info for No Bus:sg1
[   24.816521] sd 3:0:0:0: Attached scsi generic sg1 type 0
[   24.821869] device: '3:0:0:0': device_add
[   24.825927] PM: Adding info for No Bus:3:0:0:0
[   24.831222] scsi 3:0:1:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0 ANSI: 5
[   24.839339] device: 'target3:0:1': device_add
[   24.843721] PM: Adding info for No Bus:target3:0:1
[   24.848531] device: '3:0:1:0': device_add
[   24.852597] bus: 'scsi': add device 3:0:1:0
[   24.856808] PM: Adding info for scsi:3:0:1:0
[   24.861193] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver osst
[   24.869034] bus: 'scsi': really_probe: probing driver osst with device 3:0:1:0
[   24.876282] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver sd
[   24.883949] bus: 'scsi': really_probe: probing driver sd with device 3:0:1:0
[   24.891020] bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver ch
[   24.901240] bus: 'scsi': really_probe: probing driver ch with device 3:0:1:0
[   24.908311] device: '3:0:1:0': device_add
[   24.912357] PM: Adding info for No Bus:3:0:1:0
[   24.916946] device: 'sg2': device_add
[   24.920668] PM: Adding info for No Bus:sg2
[   24.924880] scsi 3:0:1:0: Attached scsi generic sg2 type 5
[   24.930387] device: '3:0:1:0': device_add
[   24.934446] PM: Adding info for No Bus:3:0:1:0
[   24.939023] driver: '0000:00:1f.2': driver_bound: bound to device 'ata_piix'
[   24.946083] bus: 'pci': really_probe: bound device 0000:00:1f.2 to driver ata_piix
[   24.953780] initcall piix_init+0x0/0x29 returned 0 after 1292 msecs
[   24.960093] calling  pdc_ata_init+0x0/0x1b
[   24.964212] bus: 'pci': add driver sata_promise
[   24.968906] initcall pdc_ata_init+0x0/0x1b returned 0 after 4 msecs
[   24.975221] calling  qs_ata_init+0x0/0x1b
[   24.979248] bus: 'pci': add driver sata_qstor
[   24.983748] initcall qs_ata_init+0x0/0x1b returned 0 after 4 msecs
[   24.989978] calling  sil_init+0x0/0x1b
[   24.993745] bus: 'pci': add driver sata_sil
[   24.997974] bus: 'pci': driver_probe_device: matched device 0000:05:05.0 with driver sata_sil
[   25.006509] bus: 'pci': really_probe: probing driver sata_sil with device 0000:05:05.0
[   25.014444] sata_sil 0000:05:05.0: version 2.3
[   25.018944] vendor=8086 device=244e
[   25.022450] sata_sil 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   25.029614] sata_sil 0000:05:05.0: Applying R_ERR on DMA activate FIS errata fix
[   25.037147] scsi4 : sata_sil
[   25.040052] device: 'host4': device_add
[   25.043915] PM: Adding info for No Bus:host4
[   25.048201] device: 'host4': device_add
[   25.052098] PM: Adding info for No Bus:host4
[   25.056535] scsi5 : sata_sil
[   25.059439] device: 'host5': device_add
[   25.063302] PM: Adding info for No Bus:host5
[   25.067589] device: 'host5': device_add
[   25.071493] PM: Adding info for No Bus:host5
[   25.075953] scsi6 : sata_sil
[   25.078855] device: 'host6': device_add
[   25.082718] PM: Adding info for No Bus:host6
[   25.087004] device: 'host6': device_add
[   25.090900] PM: Adding info for No Bus:host6
[   25.095332] scsi7 : sata_sil
[   25.098237] device: 'host7': device_add
[   25.102103] PM: Adding info for No Bus:host7
[   25.106390] device: 'host7': device_add
[   25.110285] PM: Adding info for No Bus:host7
[   25.114671] ata5: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c880 irq 17
[   25.121909] ata6: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c8c0 irq 17
[   25.129143] ata7: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000ca80 irq 17
[   25.136379] ata8: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000cac0 irq 17
[   25.460047] ata5: SATA link down (SStatus 0 SControl 310)
[   25.784046] ata6: SATA link down (SStatus 0 SControl 310)
[   26.108046] ata7: SATA link down (SStatus 0 SControl 310)
[   26.432046] ata8: SATA link down (SStatus 0 SControl 310)
[   26.437483] driver: '0000:05:05.0': driver_bound: bound to device 'sata_sil'
[   26.444550] bus: 'pci': really_probe: bound device 0000:05:05.0 to driver sata_sil
[   26.452234] initcall sil_init+0x0/0x1b returned 0 after 1390 msecs
[   26.458463] calling  sil24_init+0x0/0x1b
[   26.462403] bus: 'pci': add driver sata_sil24
[   26.466904] initcall sil24_init+0x0/0x1b returned 0 after 4 msecs
[   26.473050] calling  svia_init+0x0/0x1b
[   26.476904] bus: 'pci': add driver sata_via
[   26.481233] initcall svia_init+0x0/0x1b returned 0 after 4 msecs
[   26.487289] calling  sis_init+0x0/0x1b
[   26.491055] bus: 'pci': add driver sata_sis
[   26.495392] initcall sis_init+0x0/0x1b returned 0 after 4 msecs
[   26.501362] calling  nv_init+0x0/0x1b
[   26.505038] bus: 'pci': add driver sata_nv
[   26.509284] initcall nv_init+0x0/0x1b returned 0 after 4 msecs
[   26.515163] calling  mv_init+0x0/0x48
[   26.518843] bus: 'pci': add driver sata_mv
[   26.523090] bus: 'platform': add driver sata_mv
[   26.527747] initcall mv_init+0x0/0x48 returned 0 after 8 msecs
[   26.533628] calling  inic_init+0x0/0x1b
[   26.537481] bus: 'pci': add driver sata_inic162x
[   26.542253] initcall inic_init+0x0/0x1b returned 0 after 4 msecs
[   26.548306] calling  adma_ata_init+0x0/0x1b
[   26.552507] bus: 'pci': add driver pdc_adma
[   26.556834] initcall adma_ata_init+0x0/0x1b returned 0 after 4 msecs
[   26.563237] calling  ali_init+0x0/0x1b
[   26.567002] bus: 'pci': add driver pata_ali
[   26.571327] initcall ali_init+0x0/0x1b returned 0 after 4 msecs
[   26.577297] calling  amd_init+0x0/0x1b
[   26.581061] bus: 'pci': add driver pata_amd
[   26.585398] initcall amd_init+0x0/0x1b returned 0 after 4 msecs
[   26.591365] calling  artop_init+0x0/0x1b
[   26.595304] bus: 'pci': add driver pata_artop
[   26.599803] initcall artop_init+0x0/0x1b returned 0 after 4 msecs
[   26.605947] calling  atiixp_init+0x0/0x1b
[   26.609974] bus: 'pci': add driver pata_atiixp
[   26.614559] initcall atiixp_init+0x0/0x1b returned 0 after 4 msecs
[   26.620785] calling  cmd640_init+0x0/0x1b
[   26.624811] bus: 'pci': add driver pata_cmd640
[   26.629400] initcall cmd640_init+0x0/0x1b returned 0 after 4 msecs
[   26.635627] calling  cmd64x_init+0x0/0x1b
[   26.639654] bus: 'pci': add driver pata_cmd64x
[   26.644241] initcall cmd64x_init+0x0/0x1b returned 0 after 4 msecs
[   26.650470] calling  cs5520_init+0x0/0x1b
[   26.654497] bus: 'pci': add driver pata_cs5520
[   26.659090] initcall cs5520_init+0x0/0x1b returned 0 after 4 msecs
[   26.665319] calling  cs5530_init+0x0/0x1b
[   26.669346] bus: 'pci': add driver pata_cs5530
[   26.673933] initcall cs5530_init+0x0/0x1b returned 0 after 4 msecs
[   26.680160] calling  cy82c693_init+0x0/0x1b
[   26.684361] bus: 'pci': add driver pata_cypress
[   26.689034] initcall cy82c693_init+0x0/0x1b returned 0 after 4 msecs
[   26.695436] calling  efar_init+0x0/0x1b
[   26.699290] bus: 'pci': add driver pata_efar
[   26.703705] initcall efar_init+0x0/0x1b returned 0 after 4 msecs
[   26.709761] calling  hpt36x_init+0x0/0x1b
[   26.713788] bus: 'pci': add driver pata_hpt366
[   26.718375] initcall hpt36x_init+0x0/0x1b returned 0 after 4 msecs
[   26.724602] calling  hpt3x2n_init+0x0/0x1b
[   26.728716] bus: 'pci': add driver pata_hpt3x2n
[   26.733404] initcall hpt3x2n_init+0x0/0x1b returned 0 after 4 msecs
[   26.739716] calling  it821x_init+0x0/0x1b
[   26.743745] bus: 'pci': add driver pata_it821x
[   26.748355] initcall it821x_init+0x0/0x1b returned 0 after 4 msecs
[   26.754584] calling  it8213_init+0x0/0x1b
[   26.758612] bus: 'pci': add driver pata_it8213
[   26.763206] initcall it8213_init+0x0/0x1b returned 0 after 4 msecs
[   26.769436] calling  ninja32_init+0x0/0x1b
[   26.773549] bus: 'pci': add driver pata_ninja32
[   26.778223] initcall ninja32_init+0x0/0x1b returned 0 after 4 msecs
[   26.784535] calling  ns87410_init+0x0/0x1b
[   26.788648] bus: 'pci': add driver pata_ns87410
[   26.793325] initcall ns87410_init+0x0/0x1b returned 0 after 4 msecs
[   26.799639] calling  ns87415_init+0x0/0x1b
[   26.803752] bus: 'pci': add driver pata_ns87415
[   26.808425] initcall ns87415_init+0x0/0x1b returned 0 after 4 msecs
[   26.814740] calling  marvell_init+0x0/0x1b
[   26.818856] bus: 'pci': add driver pata_marvell
[   26.823538] initcall marvell_init+0x0/0x1b returned 0 after 4 msecs
[   26.829853] calling  oldpiix_init+0x0/0x1b
[   26.833966] bus: 'pci': add driver pata_oldpiix
[   26.838639] initcall oldpiix_init+0x0/0x1b returned 0 after 4 msecs
[   26.844952] calling  pdc2027x_init+0x0/0x1b
[   26.849153] bus: 'pci': add driver pata_pdc2027x
[   26.853912] initcall pdc2027x_init+0x0/0x1b returned 0 after 4 msecs
[   26.860312] calling  pdc202xx_init+0x0/0x1b
[   26.864513] bus: 'pci': add driver pata_pdc202xx_old
[   26.869619] initcall pdc202xx_init+0x0/0x1b returned 0 after 4 msecs
[   26.876019] calling  rz1000_init+0x0/0x1b
[   26.880047] bus: 'pci': add driver pata_rz1000
[   26.884643] initcall rz1000_init+0x0/0x1b returned 0 after 4 msecs
[   26.890872] calling  sc1200_init+0x0/0x1b
[   26.894900] bus: 'pci': add driver sc1200
[   26.899059] initcall sc1200_init+0x0/0x1b returned 0 after 3 msecs
[   26.905286] calling  serverworks_init+0x0/0x1b
[   26.909747] bus: 'pci': add driver pata_serverworks
[   26.914768] initcall serverworks_init+0x0/0x1b returned 0 after 4 msecs
[   26.921430] calling  via_init+0x0/0x1b
[   26.925195] bus: 'pci': add driver pata_via
[   26.929522] initcall via_init+0x0/0x1b returned 0 after 4 msecs
[   26.935490] calling  sl82c105_init+0x0/0x1b
[   26.939689] bus: 'pci': add driver pata_sl82c105
[   26.944450] initcall sl82c105_init+0x0/0x1b returned 0 after 4 msecs
[   26.950852] calling  sis_init+0x0/0x1b
[   26.954620] bus: 'pci': add driver pata_sis
[   26.958947] initcall sis_init+0x0/0x1b returned 0 after 4 msecs
[   26.964914] calling  sch_init+0x0/0x1b
[   26.968682] bus: 'pci': add driver pata_sch
[   26.973014] initcall sch_init+0x0/0x1b returned 0 after 4 msecs
[   26.978983] calling  i2o_iop_init+0x0/0x48
[   26.983095] I2O subsystem v1.325
[   26.986340] i2o: max drivers = 8
[   26.989695] bus: 'i2o': registered
[   26.993236] bus: 'i2o': add driver exec-osm
[   26.997547] bus: 'pci': add driver PCI_I2O
[   27.001788] initcall i2o_iop_init+0x0/0x48 returned 0 after 17 msecs
[   27.008189] calling  i2o_config_init+0x0/0xa4
[   27.015115] I2O Configuration OSM v1.323
[   27.019054] bus: 'i2o': add driver config-osm
[   27.023528] device: 'i2octl': device_add
[   27.027520] PM: Adding info for No Bus:i2octl
[   27.031989] initcall i2o_config_init+0x0/0xa4 returned 0 after 16 msecs
[   27.038654] calling  i2o_bus_init+0x0/0x44
[   27.042765] I2O Bus Adapter OSM v1.317
[   27.046531] bus: 'i2o': add driver bus-osm
[   27.050742] initcall i2o_bus_init+0x0/0x44 returned 0 after 7 msecs
[   27.057054] calling  i2o_scsi_init+0x0/0x44
[   27.061255] I2O SCSI Peripheral OSM v1.316
[   27.065367] bus: 'i2o': add driver scsi-osm
[   27.069662] initcall i2o_scsi_init+0x0/0x44 returned 0 after 8 msecs
[   27.076063] calling  i2o_proc_init+0x0/0x193
[   27.080348] I2O ProcFS OSM v1.316
[   27.083680] bus: 'i2o': add driver proc-osm
[   27.087987] initcall i2o_proc_init+0x0/0x193 returned 0 after 7 msecs
[   27.094476] calling  fw_core_init+0x0/0xb1
[   27.098694] bus: 'firewire': registered
[   27.102566] initcall fw_core_init+0x0/0xb1 returned 0 after 3 msecs
[   27.108877] calling  fw_ohci_init+0x0/0x1b
[   27.112991] bus: 'pci': add driver firewire_ohci
[   27.117655] bus: 'pci': driver_probe_device: matched device 0000:05:04.0 with driver firewire_ohci
[   27.126622] bus: 'pci': really_probe: probing driver firewire_ohci with device 0000:05:04.0
[   27.135004] vendor=8086 device=244e
[   27.138510] firewire_ohci 0000:05:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   27.216037] firewire_ohci: Added fw-ohci device 0000:05:04.0, OHCI version 1.10
[   27.223403] driver: '0000:05:04.0': driver_bound: bound to device 'firewire_ohci'
[   27.230900] bus: 'pci': really_probe: bound device 0000:05:04.0 to driver firewire_ohci
[   27.239023] initcall fw_ohci_init+0x0/0x1b returned 0 after 120 msecs
[   27.245512] calling  sbp2_init+0x0/0x44
[   27.249419] bus: 'firewire': add driver sbp2
[   27.253806] initcall sbp2_init+0x0/0x44 returned 0 after 4 msecs
[   27.259858] calling  ieee1394_init+0x0/0x26c
[   27.264305] bus: 'ieee1394': registered
[   27.268164] device class 'ieee1394_host': registering
[   27.273336] device class 'ieee1394_protocol': registering
[   27.278878] device class 'ieee1394_node': registering
[   27.284052] device class 'ieee1394': registering
[   27.288779] bus: 'ieee1394': add driver nodemgr
[   27.293428] initcall ieee1394_init+0x0/0x26c returned 0 after 27 msecs
[   27.300000] calling  pcilynx_init+0x0/0x3c
[   27.304115] bus: 'pci': add driver pcilynx
[   27.308371] initcall pcilynx_init+0x0/0x3c returned 0 after 4 msecs
[   27.314685] calling  ohci1394_init+0x0/0x1b
[   27.318886] bus: 'pci': add driver ohci1394
[   27.323212] initcall ohci1394_init+0x0/0x1b returned 0 after 4 msecs
[   27.329615] calling  video1394_init_module+0x0/0xd6
[   27.334510] bus: 'ieee1394': add driver video1394
[   27.339333] video1394: Installed video1394 module
[   27.344053] initcall video1394_init_module+0x0/0xd6 returned 0 after 9 msecs
[   27.351149] calling  sbp2_module_init+0x0/0x77
[   27.355609] bus: 'ieee1394': add driver sbp2
[   27.359998] initcall sbp2_module_init+0x0/0x77 returned 0 after 4 msecs
[   27.366661] calling  dv1394_init_module+0x0/0xad
[   27.371294] NOTE: The dv1394 driver is unsupported and may be removed in a future Linux release. Use raw1394 instead.
[   27.381909] bus: 'ieee1394': add driver dv1394
[   27.386472] initcall dv1394_init_module+0x0/0xad returned 0 after 14 msecs
[   27.393397] calling  ether1394_init_module+0x0/0x70
[   27.398485] bus: 'ieee1394': add driver eth1394
[   27.403156] initcall ether1394_init_module+0x0/0x70 returned 0 after 4 msecs
[   27.410251] calling  cdrom_init+0x0/0xd
[   27.414111] initcall cdrom_init+0x0/0xd returned 0 after 0 msecs
[   27.420162] calling  at25_init+0x0/0x12
[   27.424015] bus: 'spi': add driver at25
[   27.427967] initcall at25_init+0x0/0x12 returned 0 after 3 msecs
[   27.434021] calling  spidev_init+0x0/0x9a
[   27.438050] device class 'spidev': registering
[   27.442604] bus: 'spi': add driver spidev
[   27.446733] initcall spidev_init+0x0/0x9a returned 0 after 8 msecs
[   27.452959] calling  aoe_init+0x0/0xa7
[   27.456728] device class 'aoe': registering
[   27.461024] device: 'err': device_add
[   27.464740] PM: Adding info for No Bus:err
[   27.468962] device: 'discover': device_add
[   27.473110] PM: Adding info for No Bus:discover
[   27.477755] device: 'interfaces': device_add
[   27.482075] PM: Adding info for No Bus:interfaces
[   27.486886] device: 'revalidate': device_add
[   27.491199] PM: Adding info for No Bus:revalidate
[   27.496010] device: 'flush': device_add
[   27.499889] PM: Adding info for No Bus:flush
[   27.504423] aoe: AoE v47 initialised.
[   27.508181] initcall aoe_init+0x0/0xa7 returned 0 after 49 msecs
[   27.514236] calling  mon_init+0x0/0x115
[   27.518098] device class 'usbmon': registering
[   27.522669] device: 'usbmon0': device_add
[   27.526727] PM: Adding info for No Bus:usbmon0
[   27.531303] device: 'usbmon5': device_add
[   27.535368] PM: Adding info for No Bus:usbmon5
[   27.539965] device: 'usbmon4': device_add
[   27.544037] PM: Adding info for No Bus:usbmon4
[   27.548609] device: 'usbmon3': device_add
[   27.552684] PM: Adding info for No Bus:usbmon3
[   27.557256] device: 'usbmon2': device_add
[   27.561320] PM: Adding info for No Bus:usbmon2
[   27.565892] device: 'usbmon1': device_add
[   27.569962] PM: Adding info for No Bus:usbmon1
[   27.574519] initcall mon_init+0x0/0x115 returned 0 after 53 msecs
[   27.580660] calling  isp116x_init+0x0/0x3e
[   27.584772] 116x: driver isp116x-hcd, 03 Nov 2005
[   27.589492] bus: 'platform': add driver isp116x-hcd
[   27.594490] initcall isp116x_init+0x0/0x3e returned 0 after 9 msecs
[   27.600803] calling  sl811h_init+0x0/0x3e
[   27.604830] sl811: driver sl811-hcd, 19 May 2005
[   27.609461] bus: 'platform': add driver sl811-hcd
[   27.614285] initcall sl811h_init+0x0/0x3e returned 0 after 9 msecs
[   27.620512] calling  r8a66597_init+0x0/0x3e
[   27.624713] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[   27.630210] bus: 'platform': add driver r8a66597_hcd
[   27.635294] initcall r8a66597_init+0x0/0x3e returned 0 after 10 msecs
[   27.641783] calling  isp1760_init+0x0/0x34
[   27.646203] bus: 'pci': add driver isp1760
[   27.650448] initcall isp1760_init+0x0/0x34 returned 0 after 4 msecs
[   27.656760] calling  c67x00_init+0x0/0x12
[   27.660787] bus: 'platform': add driver c67x00
[   27.665360] initcall c67x00_init+0x0/0x12 returned 0 after 4 msecs
[   27.671586] calling  acm_init+0x0/0xfd
[   27.675362] bus: 'usb': add driver cdc_acm
[   27.679595] usbcore: registered new interface driver cdc_acm
[   27.685270] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   27.693804] initcall acm_init+0x0/0xfd returned 0 after 17 msecs
[   27.699857] calling  usblp_init+0x0/0x1b
[   27.703799] bus: 'usb': add driver usblp
[   27.707845] usbcore: registered new interface driver usblp
[   27.713347] initcall usblp_init+0x0/0x1b returned 0 after 9 msecs
[   27.719484] calling  wdm_init+0x0/0x1b
[   27.723256] bus: 'usb': add driver cdc_wdm
[   27.727478] device: 'fw0': device_add
[   27.731191] bus: 'firewire': add device fw0
[   27.735409] PM: Adding info for firewire:fw0
[   27.739816] usbcore: registered new interface driver cdc_wdm
[   27.745493] initcall wdm_init+0x0/0x1b returned 0 after 21 msecs
[   27.751548] calling  usb_stor_init+0x0/0x50
[   27.755745] Initializing USB Mass Storage driver...
[   27.760638] bus: 'usb': add driver usb-storage
[   27.765148] firewire_core: created device fw0: GUID 0090270001ab6fc2, S400
[   27.765220] usbcore: registered new interface driver usb-storage
[   27.765224] USB Mass Storage support registered.
[   27.765227] initcall usb_stor_init+0x0/0x50 returned 0 after 9 msecs
[   27.765230] calling  usb_usual_init+0x0/0x40
[   27.765237] bus: 'usb': add driver libusual
[   27.765353] usbcore: registered new interface driver libusual
[   27.765357] initcall usb_usual_init+0x0/0x40 returned 0 after 0 msecs
[   27.765360] calling  usb_mdc800_init+0x0/0x267
[   27.765369] bus: 'usb': add driver mdc800
[   27.765483] usbcore: registered new interface driver mdc800
[   27.765487] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   27.765489] initcall usb_mdc800_init+0x0/0x267 returned 0 after 0 msecs
[   27.765491] calling  usb_serial_init+0x0/0x235
[   27.765598] bus: 'usb-serial': registered
[   27.765613] bus: 'usb': add driver usbserial
[   27.765724] usbcore: registered new interface driver usbserial
[   27.765727] bus: 'usb-serial': add driver generic
[   27.765850] usbserial: USB Serial support registered for generic
[   27.765852] bus: 'usb': add driver usbserial_generic
[   27.765958] usbcore: registered new interface driver usbserial_generic
[   27.765959] usbserial: USB Serial Driver core
[   27.765961] initcall usb_serial_init+0x0/0x235 returned 0 after 0 msecs
[   27.765964] calling  aircable_init+0x0/0x46
[   27.765966] bus: 'usb-serial': add driver aircable
[   27.766070] usbserial: USB Serial support registered for aircable
[   27.766072] bus: 'usb': add driver aircable
[   27.766191] usbcore: registered new interface driver aircable
[   27.766194] initcall aircable_init+0x0/0x46 returned 0 after 0 msecs
[   27.766196] calling  ark3116_init+0x0/0x48
[   27.766198] bus: 'usb-serial': add driver ark3116
[   27.766300] usbserial: USB Serial support registered for ark3116
[   27.766302] bus: 'usb': add driver ark3116
[   27.766416] usbcore: registered new interface driver ark3116
[   27.766418] initcall ark3116_init+0x0/0x48 returned 0 after 0 msecs
[   27.766421] calling  belkin_sa_init+0x0/0x58
[   27.766423] bus: 'usb-serial': add driver belkin
[   27.766532] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   27.766535] bus: 'usb': add driver belkin
[   27.766640] usbcore: registered new interface driver belkin
[   27.766642] belkin_sa: USB Belkin Serial converter driver v1.2
[   27.766644] initcall belkin_sa_init+0x0/0x58 returned 0 after 0 msecs
[   27.766646] calling  ch341_init+0x0/0x48
[   27.766648] bus: 'usb-serial': add driver ch341-uart
[   27.766754] usbserial: USB Serial support registered for ch341-uart
[   27.766756] bus: 'usb': add driver ch341
[   27.766877] usbcore: registered new interface driver ch341
[   27.766879] initcall ch341_init+0x0/0x48 returned 0 after 0 msecs
[   27.766881] calling  cp2101_init+0x0/0x58
[   27.766883] bus: 'usb-serial': add driver cp2101
[   27.766980] usbserial: USB Serial support registered for cp2101
[   27.766982] bus: 'usb': add driver cp2101
[   27.767088] usbcore: registered new interface driver cp2101
[   27.767089] cp2101: Silicon Labs CP2101/CP2102 RS232 serial adaptor driver v0.07
[   27.767092] initcall cp2101_init+0x0/0x58 returned 0 after 0 msecs
[   27.767094] calling  cyberjack_init+0x0/0x66
[   27.767096] bus: 'usb-serial': add driver cyberjack
[   27.767207] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[   27.767209] bus: 'usb': add driver cyberjack
[   27.767326] usbcore: registered new interface driver cyberjack
[   27.767327] cyberjack: v1.01 Matthias Bruestle
[   27.767328] cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
[   27.767331] initcall cyberjack_init+0x0/0x66 returned 0 after 0 msecs
[   27.767333] calling  cypress_init+0x0/0xb9
[   27.767334] drivers/usb/serial/cypress_m8.c: cypress_init
[   27.767336] bus: 'usb-serial': add driver earthmate
[   27.767449] usbserial: USB Serial support registered for DeLorme Earthmate USB
[   27.767451] bus: 'usb-serial': add driver cyphidcom
[   27.767565] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[   27.767567] bus: 'usb-serial': add driver nokiaca42v2
[   27.767664] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[   27.767667] bus: 'usb': add driver cypress
[   27.767780] usbcore: registered new interface driver cypress
[   27.767781] cypress_m8: Cypress USB to Serial Driver v1.09
[   27.767783] initcall cypress_init+0x0/0xb9 returned 0 after 0 msecs
[   27.767785] calling  debug_init+0x0/0x48
[   27.767787] bus: 'usb-serial': add driver debug
[   27.767898] usbserial: USB Serial support registered for debug
[   27.767900] bus: 'usb': add driver debug
[   27.768014] usbcore: registered new interface driver debug
[   27.768016] initcall debug_init+0x0/0x48 returned 0 after 0 msecs
[   27.768018] calling  digi_init+0x0/0x76
[   27.768020] bus: 'usb-serial': add driver digi_2
[   27.768117] usbserial: USB Serial support registered for Digi 2 port USB adapter
[   27.768119] bus: 'usb-serial': add driver digi_4
[   27.768229] usbserial: USB Serial support registered for Digi 4 port USB adapter
[   27.768232] bus: 'usb': add driver digi_acceleport
[   27.768339] usbcore: registered new interface driver digi_acceleport
[   27.768340] digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
[   27.768343] initcall digi_init+0x0/0x76 returned 0 after 0 msecs
[   27.768345] calling  edgeport_init+0x0/0xc1
[   27.768347] bus: 'usb-serial': add driver edgeport_2
[   27.768443] usbserial: USB Serial support registered for Edgeport 2 port adapter
[   27.768446] bus: 'usb-serial': add driver edgeport_4
[   27.768566] usbserial: USB Serial support registered for Edgeport 4 port adapter
[   27.768569] bus: 'usb-serial': add driver edgeport_8
[   27.768671] usbserial: USB Serial support registered for Edgeport 8 port adapter
[   27.768674] bus: 'usb-serial': add driver epic
[   27.768770] usbserial: USB Serial support registered for EPiC device
[   27.768772] bus: 'usb': add driver io_edgeport
[   27.768892] usbcore: registered new interface driver io_edgeport
[   27.768893] io_edgeport: Edgeport USB Serial Driver v2.7
[   27.768895] initcall edgeport_init+0x0/0xc1 returned 0 after 0 msecs
[   27.768898] calling  edgeport_init+0x0/0x77
[   27.768900] bus: 'usb-serial': add driver edgeport_ti_1
[   27.768998] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[   27.769001] bus: 'usb-serial': add driver edgeport_ti_2
[   27.769112] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[   27.769114] bus: 'usb': add driver io_ti
[   27.769247] usbcore: registered new interface driver io_ti
[   27.769249] io_ti: Edgeport USB Serial Driver v0.7mode043006
[   27.769251] initcall edgeport_init+0x0/0x77 returned 0 after 0 msecs
[   27.769253] calling  ftdi_init+0x0/0xce
[   27.769255] bus: 'usb-serial': add driver ftdi_sio
[   27.769369] usbserial: USB Serial support registered for FTDI USB Serial Device
[   27.769371] bus: 'usb': add driver ftdi_sio
[   27.769482] usbcore: registered new interface driver ftdi_sio
[   27.769483] ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
[   27.769485] initcall ftdi_init+0x0/0xce returned 0 after 0 msecs
[   27.769488] calling  funsoft_init+0x0/0x48
[   27.769490] bus: 'usb-serial': add driver funsoft
[   27.769600] usbserial: USB Serial support registered for funsoft
[   27.769602] bus: 'usb': add driver funsoft
[   27.769710] usbcore: registered new interface driver funsoft
[   27.769712] initcall funsoft_init+0x0/0x48 returned 0 after 0 msecs
[   27.769714] calling  garmin_init+0x0/0x58
[   27.769716] bus: 'usb-serial': add driver garmin_gps
[   27.769820] usbserial: USB Serial support registered for Garmin GPS usb/tty
[   27.769823] bus: 'usb': add driver garmin_gps
[   27.769950] usbcore: registered new interface driver garmin_gps
[   27.769952] garmin_gps: garmin gps driver v0.31
[   27.769954] initcall garmin_init+0x0/0x58 returned 0 after 0 msecs
[   27.769956] calling  ipaq_init+0x0/0x91
[   27.769958] bus: 'usb-serial': add driver ipaq
[   27.770064] usbserial: USB Serial support registered for PocketPC PDA
[   27.770066] ipaq: USB PocketPC PDA driver v0.5
[   27.770068] bus: 'usb': add driver ipaq
[   27.770178] usbcore: registered new interface driver ipaq
[   27.770181] initcall ipaq_init+0x0/0x91 returned 0 after 0 msecs
[   27.770184] calling  usb_ipw_init+0x0/0x5d
[   27.770186] bus: 'usb-serial': add driver ipw
[   27.770298] usbserial: USB Serial support registered for IPWireless converter
[   27.770300] bus: 'usb': add driver ipwtty
[   27.770408] usbcore: registered new interface driver ipwtty
[   27.770409] ipw: IPWireless tty driver v0.3
[   27.770411] initcall usb_ipw_init+0x0/0x5d returned 0 after 0 msecs
[   27.770413] calling  ir_init+0x0/0x58
[   27.770415] bus: 'usb-serial': add driver ir-usb
[   27.770512] usbserial: USB Serial support registered for IR Dongle
[   27.770515] bus: 'usb': add driver ir-usb
[   27.770640] usbcore: registered new interface driver ir-usb
[   27.770641] ir_usb: USB IR Dongle driver v0.4
[   27.770643] initcall ir_init+0x0/0x58 returned 0 after 0 msecs
[   27.770645] calling  iuu_init+0x0/0x58
[   27.770647] bus: 'usb-serial': add driver iuu_phoenix
[   27.770744] usbserial: USB Serial support registered for iuu_phoenix
[   27.770747] bus: 'usb': add driver iuu_phoenix
[   27.770854] usbcore: registered new interface driver iuu_phoenix
[   27.770856] iuu_phoenix: Infinity USB Unlimited Phoenix driver v0.5
[   27.770858] initcall iuu_init+0x0/0x58 returned 0 after 0 msecs
[   27.770860] calling  kobil_init+0x0/0x66
[   27.770862] bus: 'usb-serial': add driver kobil
[   27.770974] usbserial: USB Serial support registered for KOBIL USB smart card terminal
[   27.770977] bus: 'usb': add driver kobil
[   27.771082] usbcore: registered new interface driver kobil
[   27.771083] kobil_sct: 21/05/2004 KOBIL Systems GmbH - http://www.kobil.com
[   27.771085] kobil_sct: KOBIL USB Smart Card Terminal Driver (experimental)
[   27.771087] initcall kobil_init+0x0/0x66 returned 0 after 0 msecs
[   27.771089] calling  moschip7840_init+0x0/0xcb
[   27.771091] bus: 'usb-serial': add driver mos7840
[   27.771195] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[   27.771197] mos7840: Moschip 7840/7820 USB Serial Driver 1.3.1
[   27.771199] bus: 'usb': add driver mos7840
[   27.771318] usbcore: registered new interface driver mos7840
[   27.771320] initcall moschip7840_init+0x0/0xcb returned 0 after 0 msecs
[   27.771322] calling  moto_init+0x0/0x48
[   27.771325] bus: 'usb-serial': add driver moto-modem
[   27.771442] usbserial: USB Serial support registered for moto-modem
[   27.771445] bus: 'usb': add driver moto-modem
[   27.771550] usbcore: registered new interface driver moto-modem
[   27.771552] initcall moto_init+0x0/0x48 returned 0 after 0 msecs
[   27.771555] calling  navman_init+0x0/0x48
[   27.771557] bus: 'usb-serial': add driver navman
[   27.771667] usbserial: USB Serial support registered for navman
[   27.771670] bus: 'usb': add driver navman
[   27.771775] usbcore: registered new interface driver navman
[   27.771777] initcall navman_init+0x0/0x48 returned 0 after 0 msecs
[   27.771779] calling  omninet_init+0x0/0x59
[   27.771781] bus: 'usb-serial': add driver omninet
[   27.771884] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[   27.771887] bus: 'usb': add driver omninet
[   27.772009] usbcore: registered new interface driver omninet
[   27.772011] omninet: v1.1:USB ZyXEL omni.net LCD PLUS Driver
[   27.772013] initcall omninet_init+0x0/0x59 returned 0 after 0 msecs
[   27.772015] calling  option_init+0x0/0x58
[   27.772017] bus: 'usb-serial': add driver option1
[   27.772122] usbserial: USB Serial support registered for GSM modem (1-port)
[   27.772124] bus: 'usb': add driver option
[   27.772249] usbcore: registered new interface driver option
[   27.772250] option: USB Driver for GSM modems: v0.7.2
[   27.772252] initcall option_init+0x0/0x58 returned 0 after 0 msecs
[   27.772255] calling  pl2303_init+0x0/0x59
[   27.772257] bus: 'usb-serial': add driver pl2303
[   27.772368] usbserial: USB Serial support registered for pl2303
[   27.772370] bus: 'usb': add driver pl2303
[   27.772478] usbcore: registered new interface driver pl2303
[   27.772479] pl2303: Prolific PL2303 USB to serial adaptor driver
[   27.772481] initcall pl2303_init+0x0/0x59 returned 0 after 0 msecs
[   27.772483] calling  sierra_init+0x0/0x58
[   27.772485] bus: 'usb-serial': add driver sierra
[   27.772597] usbserial: USB Serial support registered for Sierra USB modem
[   27.772600] bus: 'usb': add driver sierra
[   27.772719] usbcore: registered new interface driver sierra
[   27.772721] sierra: USB Driver for Sierra Wireless USB modems: v.1.2.13a
[   27.772723] initcall sierra_init+0x0/0x58 returned 0 after 0 msecs
[   27.772725] calling  visor_init+0x0/0x1a5
[   27.772727] bus: 'usb-serial': add driver visor
[   27.772825] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[   27.772828] bus: 'usb-serial': add driver clie_3.5
[   27.772925] usbserial: USB Serial support registered for Sony Clie 3.5
[   27.772927] bus: 'usb-serial': add driver clie_5
[   27.773040] usbserial: USB Serial support registered for Sony Clie 5.0
[   27.773043] bus: 'usb': add driver visor
[   27.773150] usbcore: registered new interface driver visor
[   27.773152] visor: USB HandSpring Visor / Palm OS driver
[   27.773154] initcall visor_init+0x0/0x1a5 returned 0 after 0 msecs
[   27.773156] calling  whiteheat_init+0x0/0x77
[   27.773158] bus: 'usb-serial': add driver whiteheatnofirm
[   27.773263] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   27.773266] bus: 'usb-serial': add driver whiteheat
[   27.773386] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[   27.773389] bus: 'usb': add driver whiteheat
[   27.773504] usbcore: registered new interface driver whiteheat
[   27.773506] whiteheat: USB ConnectTech WhiteHEAT driver v2.0
[   27.773508] initcall whiteheat_init+0x0/0x77 returned 0 after 0 msecs
[   27.773510] calling  keyspan_pda_init+0x0/0x76
[   27.773512] bus: 'usb-serial': add driver keyspan_pda
[   27.773612] usbserial: USB Serial support registered for Keyspan PDA
[   27.773614] bus: 'usb-serial': add driver xircom_no_firm
[   27.773727] usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   27.773730] bus: 'usb': add driver keyspan_pda
[   27.773843] usbcore: registered new interface driver keyspan_pda
[   27.773844] keyspan_pda: USB Keyspan PDA Converter driver v1.1
[   27.773846] initcall keyspan_pda_init+0x0/0x76 returned 0 after 0 msecs
[   27.773849] calling  appledisplay_init+0x0/0x57
[   27.925401] bus: 'usb': add driver appledisplay
[   27.925524] usbcore: registered new interface driver appledisplay
[   27.925529] initcall appledisplay_init+0x0/0x57 returned 0 after 144 msecs
[   27.925532] calling  berry_init+0x0/0x1b
[   27.925534] bus: 'usb': add driver berry_charge
[   27.925640] usbcore: registered new interface driver berry_charge
[   27.925644] initcall berry_init+0x0/0x1b returned 0 after 0 msecs
[   27.925647] calling  cypress_init+0x0/0x3a
[   27.925649] bus: 'usb': add driver cypress_cy7c63
[   27.925755] usbcore: registered new interface driver cypress_cy7c63
[   27.925759] initcall cypress_init+0x0/0x3a returned 0 after 0 msecs
[   27.925762] calling  emi26_init+0x0/0x1b
[   27.925764] bus: 'usb': add driver emi26 - firmware loader
[   27.925886] usbcore: registered new interface driver emi26 - firmware loader
[   27.925890] initcall emi26_init+0x0/0x1b returned 0 after 0 msecs
[   27.925892] calling  emi62_init+0x0/0x38
[   27.925895] bus: 'usb': add driver emi62 - firmware loader
[   27.926003] usbcore: registered new interface driver emi62 - firmware loader
[   27.926014] initcall emi62_init+0x0/0x38 returned 0 after 0 msecs
[   27.926016] calling  usb_idmouse_init+0x0/0x48
[   27.926017] idmouse: Siemens ID Mouse FingerTIP Sensor Driver 0.6
[   27.926019] bus: 'usb': add driver idmouse
[   27.926125] usbcore: registered new interface driver idmouse
[   27.926129] initcall usb_idmouse_init+0x0/0x48 returned 0 after 0 msecs
[   27.926132] calling  iowarrior_init+0x0/0x1b
[   27.926134] bus: 'usb': add driver iowarrior
[   27.926269] usbcore: registered new interface driver iowarrior
[   27.926274] initcall iowarrior_init+0x0/0x1b returned 0 after 0 msecs
[   27.926276] calling  isight_firmware_init+0x0/0x1b
[   27.926278] bus: 'usb': add driver isight_firmware
[   27.926385] usbcore: registered new interface driver isight_firmware
[   27.926390] initcall isight_firmware_init+0x0/0x1b returned 0 after 0 msecs
[   27.926392] calling  usb_lcd_init+0x0/0x3a
[   27.926395] bus: 'usb': add driver usblcd
[   27.926505] usbcore: registered new interface driver usblcd
[   27.926509] initcall usb_lcd_init+0x0/0x3a returned 0 after 0 msecs
[   27.926512] calling  ld_usb_init+0x0/0x3a
[   27.926514] bus: 'usb': add driver ldusb
[   27.926642] usbcore: registered new interface driver ldusb
[   27.926647] initcall ld_usb_init+0x0/0x3a returned 0 after 0 msecs
[   27.926649] calling  usb_led_init+0x0/0x3a
[   27.926651] bus: 'usb': add driver usbled
[   27.926771] usbcore: registered new interface driver usbled
[   27.926775] initcall usb_led_init+0x0/0x3a returned 0 after 0 msecs
[   27.926778] calling  usb_rio_init+0x0/0x38
[   27.926780] bus: 'usb': add driver rio500
[   27.926891] usbcore: registered new interface driver rio500
[   27.926895] rio500: v1.1:USB Rio 500 driver
[   27.926897] initcall usb_rio_init+0x0/0x38 returned 0 after 0 msecs
[   27.926899] calling  tv_init+0x0/0x4a
[   27.926901] bus: 'usb': add driver trancevibrator
[   27.927019] usbcore: registered new interface driver trancevibrator
[   27.927023] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   27.927025] initcall tv_init+0x0/0x4a returned 0 after 0 msecs
[   27.927027] calling  usb_sisusb_init+0x0/0x1b
[   27.927030] bus: 'usb': add driver sisusb
[   27.927149] usbcore: registered new interface driver sisusb
[   27.927154] initcall usb_sisusb_init+0x0/0x1b returned 0 after 0 msecs
[   27.927156] calling  i8042_init+0x0/0x396
[   27.927158] pnp: the driver 'i8042 kbd' has been registered
[   27.927161] bus: 'pnp': add driver i8042 kbd
[   27.927184] bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 kbd
[   27.927186] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0a
[   27.927197] i8042 kbd 00:0a: driver attached
[   27.927198] driver: '00:0a': driver_bound: bound to device 'i8042 kbd'
[   27.927200] bus: 'pnp': really_probe: bound device 00:0a to driver i8042 kbd
[   27.927304] pnp: the driver 'i8042 aux' has been registered
[   27.927306] bus: 'pnp': add driver i8042 aux
[   27.927333] bus: 'pnp': driver_probe_device: matched device 00:09 with driver i8042 aux
[   27.927335] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:09
[   27.927344] i8042 aux 00:09: driver attached
[   27.927345] driver: '00:09': driver_bound: bound to device 'i8042 aux'
[   27.927347] bus: 'pnp': really_probe: bound device 00:09 to driver i8042 aux
[   27.927459] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   27.927498] bus: 'platform': add driver i8042
[   27.927605] Registering platform device 'i8042'. Parent at platform
[   27.927607] device: 'i8042': device_add
[   27.927617] bus: 'platform': add device i8042
[   27.927632] PM: Adding info for platform:i8042
[   27.927727] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   27.927729] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   28.177752] serio: i8042 KBD port at 0x60,0x64 irq 1
[   28.177758] driver: 'i8042': driver_bound: bound to device 'i8042'
[   28.177760] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   28.177764] initcall i8042_init+0x0/0x396 returned 0 after 238 msecs
[   28.177767] calling  serport_init+0x0/0x34
[   28.177769] initcall serport_init+0x0/0x34 returned 0 after 0 msecs
[   28.177772] calling  ct82c710_init+0x0/0x17f
[   28.177797] initcall ct82c710_init+0x0/0x17f returned -19 after 0 msecs
[   28.177799] calling  pcips2_init+0x0/0x1b
[   28.177813] bus: 'pci': add driver pcips2
[   28.177887] device: 'serio0': device_add
[   28.177894] bus: 'serio': add device serio0
[   28.177919] PM: Adding info for serio:serio0
[   28.178070] initcall pcips2_init+0x0/0x1b returned 0 after 0 msecs
[   28.178073] calling  serio_raw_init+0x0/0x1b
[   28.178075] bus: 'serio': add driver serio_raw
[   28.178224] initcall serio_raw_init+0x0/0x1b returned 0 after 0 msecs
[   28.178226] calling  emu_init+0x0/0x1b
[   28.178229] bus: 'pci': add driver Emu10k1_gameport
[   28.178367] initcall emu_init+0x0/0x1b returned 0 after 0 msecs
[   28.178369] calling  fm801_gp_init+0x0/0x1b
[   28.178372] bus: 'pci': add driver FM801_gameport
[   28.178505] initcall fm801_gp_init+0x0/0x1b returned 0 after 0 msecs
[   28.178508] calling  l4_init+0x0/0x278
[   28.178521] initcall l4_init+0x0/0x278 returned -19 after 0 msecs
[   28.178524] calling  mousedev_init+0x0/0x8e
[   28.178536] device: 'mice': device_add
[   28.178627] PM: Adding info for No Bus:mice
[   28.178730] device: 'psaux': device_add
[   28.178759] PM: Adding info for No Bus:psaux
[   28.178861] mice: PS/2 mouse device common for all mice
[   28.178863] initcall mousedev_init+0x0/0x8e returned 0 after 0 msecs
[   28.178866] calling  joydev_init+0x0/0x12
[   28.178868] initcall joydev_init+0x0/0x12 returned 0 after 0 msecs
[   28.178870] calling  evbug_init+0x0/0x12
[   28.178873] initcall evbug_init+0x0/0x12 returned 0 after 0 msecs
[   28.178875] calling  atkbd_init+0x0/0x27
[   28.178877] bus: 'serio': add driver atkbd
[   28.178982] initcall atkbd_init+0x0/0x27 returned 0 after 0 msecs
[   28.178985] calling  nkbd_init+0x0/0x1b
[   28.178986] bus: 'serio': add driver newtonkbd
[   28.179087] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   28.179089] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   28.179143] initcall nkbd_init+0x0/0x1b returned 0 after 0 msecs
[   28.179146] calling  analog_init+0x0/0xf1
[   28.179151] initcall analog_init+0x0/0xf1 returned 0 after 0 msecs
[   28.179154] calling  grip_init+0x0/0x16
[   28.179156] initcall grip_init+0x0/0x16 returned 0 after 0 msecs
[   28.179159] calling  grip_init+0x0/0x16
[   28.179168] initcall grip_init+0x0/0x16 returned 0 after 0 msecs
[   28.179170] calling  guillemot_init+0x0/0x16
[   28.179173] initcall guillemot_init+0x0/0x16 returned 0 after 0 msecs
[   28.179176] calling  iforce_init+0x0/0x1b
[   28.179177] bus: 'serio': add driver iforce
[   28.179201] bus: 'gameport': add driver analog
[   28.179329] bus: 'gameport': add driver grip
[   28.179438] bus: 'gameport': add driver grip_mp
[   28.179546] bus: 'gameport': add driver guillemot
[   28.577526] initcall iforce_init+0x0/0x1b returned 0 after 379 msecs
[   28.577529] calling  interact_init+0x0/0x16
[   28.577533] initcall interact_init+0x0/0x16 returned 0 after 0 msecs
[   28.577535] calling  joydump_init+0x0/0x16
[   28.577538] initcall joydump_init+0x0/0x16 returned 0 after 0 msecs
[   28.577540] calling  magellan_init+0x0/0x1b
[   28.577542] bus: 'serio': add driver magellan
[   28.577646] bus: 'gameport': add driver interact
[   28.577733] initcall magellan_init+0x0/0x1b returned 0 after 0 msecs
[   28.577736] calling  sw_init+0x0/0x16
[   28.577738] initcall sw_init+0x0/0x16 returned 0 after 0 msecs
[   28.577741] calling  spaceball_init+0x0/0x1b
[   28.577742] bus: 'serio': add driver spaceball
[   28.577847] bus: 'gameport': add driver joydump
[   28.577961] initcall spaceball_init+0x0/0x1b returned 0 after 0 msecs
[   28.577964] calling  stinger_init+0x0/0x1b
[   28.577965] bus: 'serio': add driver stinger
[   28.578086] bus: 'gameport': add driver sidewinder
[   28.578183] initcall stinger_init+0x0/0x1b returned 0 after 0 msecs
[   28.578185] calling  tmdc_init+0x0/0x16
[   28.578188] initcall tmdc_init+0x0/0x16 returned 0 after 0 msecs
[   28.578190] calling  twidjoy_init+0x0/0x1b
[   28.578192] bus: 'serio': add driver twidjoy
[   28.578297] bus: 'gameport': add driver tmdc
[   28.578418] initcall twidjoy_init+0x0/0x1b returned 0 after 0 msecs
[   28.578420] calling  warrior_init+0x0/0x1b
[   28.578422] bus: 'serio': add driver warrior
[   28.578574] initcall warrior_init+0x0/0x1b returned 0 after 0 msecs
[   28.578577] calling  usb_xpad_init+0x0/0x38
[   28.578582] bus: 'usb': add driver xpad
[   28.578698] usbcore: registered new interface driver xpad
[   28.578702] xpad: X-Box pad driver
[   28.578704] initcall usb_xpad_init+0x0/0x38 returned 0 after 0 msecs
[   28.578706] calling  ads7846_init+0x0/0x12
[   28.578709] bus: 'spi': add driver ads7846
[   28.578818] initcall ads7846_init+0x0/0x12 returned 0 after 0 msecs
[   28.578821] calling  gunze_init+0x0/0x1b
[   28.578823] bus: 'serio': add driver gunze
[   28.578926] initcall gunze_init+0x0/0x1b returned 0 after 0 msecs
[   28.578928] calling  mk712_init+0x0/0x1ba
[   28.578934] mk712: device not present
[   28.578937] initcall mk712_init+0x0/0x1ba returned -19 after 0 msecs
[   28.578939] calling  usbtouch_init+0x0/0x1b
[   28.578942] bus: 'usb': add driver usbtouchscreen
[   28.579053] usbcore: registered new interface driver usbtouchscreen
[   28.579058] initcall usbtouch_init+0x0/0x1b returned 0 after 0 msecs
[   28.579060] calling  pm_init+0x0/0x1b
[   28.579062] bus: 'serio': add driver penmountlpc
[   28.579200] initcall pm_init+0x0/0x1b returned 0 after 0 msecs
[   28.579203] calling  touchit213_init+0x0/0x1b
[   28.579204] bus: 'serio': add driver touchit213
[   28.579312] initcall touchit213_init+0x0/0x1b returned 0 after 0 msecs
[   28.579315] calling  tw_init+0x0/0x1b
[   28.579317] bus: 'serio': add driver touchwin
[   28.579426] initcall tw_init+0x0/0x1b returned 0 after 0 msecs
[   28.579429] calling  ucb1400_ts_init+0x0/0x12
[   28.579431] bus: 'ac97': add driver ucb1400_ts
[   28.579554] initcall ucb1400_ts_init+0x0/0x12 returned 0 after 0 msecs
[   28.579557] calling  xenkbd_init+0x0/0x58
[   28.579559] initcall xenkbd_init+0x0/0x58 returned -19 after 0 msecs
[   28.579561] calling  ds1374_init+0x0/0x14
[   28.579564] bus: 'i2c': add driver rtc-ds1374
[   28.579661] i2c-core: driver [rtc-ds1374] registered
[   28.579664] initcall ds1374_init+0x0/0x14 returned 0 after 0 msecs
[   28.579667] calling  ds1511_rtc_init+0x0/0x12
[   28.579669] bus: 'platform': add driver ds1511
[   28.579796] initcall ds1511_rtc_init+0x0/0x12 returned 0 after 0 msecs
[   28.579798] calling  ds1553_init+0x0/0x12
[   28.579800] bus: 'platform': add driver rtc-ds1553
[   28.579917] initcall ds1553_init+0x0/0x12 returned 0 after 0 msecs
[   28.579920] calling  ds1672_init+0x0/0x14
[   28.579921] bus: 'i2c': add driver ds1672
[   28.580019] i2c-core: driver [ds1672] registered
[   28.580022] initcall ds1672_init+0x0/0x14 returned 0 after 0 msecs
[   28.580024] calling  fm3130_init+0x0/0x14
[   28.580026] bus: 'i2c': add driver rtc-fm3130
[   28.580121] i2c-core: driver [rtc-fm3130] registered
[   28.580124] initcall fm3130_init+0x0/0x14 returned 0 after 0 msecs
[   28.580126] calling  m41t80_rtc_init+0x0/0x14
[   28.580128] bus: 'i2c': add driver rtc-m41t80
[   28.580245] i2c-core: driver [rtc-m41t80] registered
[   28.580247] initcall m41t80_rtc_init+0x0/0x14 returned 0 after 0 msecs
[   28.580250] calling  m41t94_init+0x0/0x12
[   28.580251] bus: 'spi': add driver rtc-m41t94
[   28.580349] initcall m41t94_init+0x0/0x12 returned 0 after 0 msecs
[   28.580352] calling  max6900_init+0x0/0x14
[   28.580353] bus: 'i2c': add driver max6900
[   28.580448] i2c-core: driver [max6900] registered
[   28.580451] initcall max6900_init+0x0/0x14 returned 0 after 0 msecs
[   28.580453] calling  pcf8563_init+0x0/0x14
[   28.580455] bus: 'i2c': add driver rtc-pcf8563
[   28.580571] i2c-core: driver [rtc-pcf8563] registered
[   28.580574] initcall pcf8563_init+0x0/0x14 returned 0 after 0 msecs
[   28.580576] calling  pcf8583_init+0x0/0x14
[   28.580578] bus: 'i2c': add driver pcf8583
[   28.580673] i2c-core: driver [pcf8583] registered
[   28.580676] initcall pcf8583_init+0x0/0x14 returned 0 after 0 msecs
[   28.580678] calling  r9701_init+0x0/0x12
[   28.580680] bus: 'spi': add driver rtc-r9701
[   28.580784] initcall r9701_init+0x0/0x12 returned 0 after 0 msecs
[   28.580786] calling  rs5c372_init+0x0/0x14
[   28.580788] bus: 'i2c': add driver rtc-rs5c372
[   28.580897] i2c-core: driver [rtc-rs5c372] registered
[   28.580900] initcall rs5c372_init+0x0/0x14 returned 0 after 0 msecs
[   28.580902] calling  s35390a_rtc_init+0x0/0x14
[   28.580904] bus: 'i2c': add driver rtc-s35390a
[   28.581002] i2c-core: driver [rtc-s35390a] registered
[   28.581005] initcall s35390a_rtc_init+0x0/0x14 returned 0 after 0 msecs
[   28.581007] calling  stk17ta8_init+0x0/0x12
[   28.581009] bus: 'platform': add driver stk17ta8
[   28.581116] initcall stk17ta8_init+0x0/0x12 returned 0 after 0 msecs
[   28.581119] calling  v3020_init+0x0/0x12
[   28.581121] bus: 'platform': add driver v3020
[   28.581248] initcall v3020_init+0x0/0x12 returned 0 after 0 msecs
[   28.581250] calling  x1205_init+0x0/0x14
[   28.581252] bus: 'i2c': add driver rtc-x1205
[   28.581347] i2c-core: driver [rtc-x1205] registered
[   28.581350] initcall x1205_init+0x0/0x14 returned 0 after 0 msecs
[   28.581352] calling  i2c_dev_init+0x0/0xa5
[   28.581353] i2c /dev entries driver
[   28.581366] device class 'i2c-dev': registering
[   28.581474] bus: 'i2c': add driver dev_driver
[   28.581585] i2c-core: driver [dev_driver] registered
[   28.581588] initcall i2c_dev_init+0x0/0xa5 returned 0 after 0 msecs
[   28.581590] calling  i2c_ali1535_init+0x0/0x1b
[   28.581598] bus: 'pci': add driver ali1535_smbus
[   28.581729] initcall i2c_ali1535_init+0x0/0x1b returned 0 after 0 msecs
[   28.581731] calling  ali1563_init+0x0/0x1b
[   28.581734] bus: 'pci': add driver ali1563_smbus
[   28.581868] initcall ali1563_init+0x0/0x1b returned 0 after 0 msecs
[   28.581870] calling  amd756_init+0x0/0x1b
[   28.581873] bus: 'pci': add driver amd756_smbus
[   28.582021] initcall amd756_init+0x0/0x1b returned 0 after 0 msecs
[   28.582024] calling  i2c_amd8111_init+0x0/0x1b
[   28.582027] bus: 'pci': add driver amd8111_smbus2
[   28.582157] initcall i2c_amd8111_init+0x0/0x1b returned 0 after 0 msecs
[   28.582159] calling  i2c_i801_init+0x0/0x1b
[   28.582162] bus: 'pci': add driver i801_smbus
[   28.582186] bus: 'pci': driver_probe_device: matched device 0000:00:1f.3 with driver i801_smbus
[   28.582188] bus: 'pci': really_probe: probing driver i801_smbus with device 0000:00:1f.3
[   28.582208] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   28.582253] device: 'i2c-0': device_add
[   28.582276] PM: Adding info for No Bus:i2c-0
[   28.582376] i2c-adapter i2c-0: adapter [SMBus I801 adapter at 4000] registered
[   28.582382] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
[   28.597420] device: 'i2c-0': device_add
[   28.597483] PM: Adding info for No Bus:i2c-0
[   28.597602] i2c-dev: adapter [SMBus I801 adapter at 4000] registered as minor 0
[   28.597606] driver: '0000:00:1f.3': driver_bound: bound to device 'i801_smbus'
[   28.597608] bus: 'pci': really_probe: bound device 0000:00:1f.3 to driver i801_smbus
[   28.597717] initcall i2c_i801_init+0x0/0x1b returned 0 after 14 msecs
[   28.597720] calling  i2c_sis630_init+0x0/0x1b
[   28.597723] bus: 'pci': add driver sis630_smbus
[   28.597848] initcall i2c_sis630_init+0x0/0x1b returned 0 after 0 msecs
[   28.597851] calling  i2c_sis96x_init+0x0/0x1b
[   28.597853] bus: 'pci': add driver sis96x_smbus
[   28.598004] initcall i2c_sis96x_init+0x0/0x1b returned 0 after 0 msecs
[   28.598007] calling  i2c_vt586b_init+0x0/0x1b
[   28.598009] bus: 'pci': add driver vt586b_smbus
[   28.598136] initcall i2c_vt586b_init+0x0/0x1b returned 0 after 0 msecs
[   28.598138] calling  i2c_vt596_init+0x0/0x1b
[   28.598141] bus: 'pci': add driver vt596_smbus
[   28.598265] initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 msecs
[   28.598268] calling  ocores_i2c_init+0x0/0x12
[   28.598270] bus: 'platform': add driver ocores-i2c
[   28.598395] initcall ocores_i2c_init+0x0/0x12 returned 0 after 0 msecs
[   28.598397] calling  i2c_adap_simtec_init+0x0/0x12
[   28.598399] bus: 'platform': add driver simtec-i2c
[   28.598510] initcall i2c_adap_simtec_init+0x0/0x12 returned 0 after 0 msecs
[   28.598513] calling  i2c_parport_init+0x0/0x160
[   28.598514] i2c-parport-light: adapter type unspecified
[   28.598516] initcall i2c_parport_init+0x0/0x160 returned -19 after 0 msecs
[   28.598518] calling  taos_init+0x0/0x1b
[   28.598520] bus: 'serio': add driver taos-evm
[   28.598624] initcall taos_init+0x0/0x1b returned 0 after 0 msecs
[   28.598627] calling  usb_i2c_tiny_usb_init+0x0/0x1b
[   28.598633] bus: 'usb': add driver i2c-tiny-usb
[   28.598773] usbcore: registered new interface driver i2c-tiny-usb
[   28.598777] initcall usb_i2c_tiny_usb_init+0x0/0x1b returned 0 after 0 msecs
[   28.598780] calling  i2c_pca_pf_init+0x0/0x12
[   28.598782] bus: 'platform': add driver i2c-pca-platform
[   28.598887] initcall i2c_pca_pf_init+0x0/0x12 returned 0 after 0 msecs
[   28.598890] calling  at24_init+0x0/0x3a
[   28.598892] bus: 'i2c': add driver at24
[   28.598990] i2c-core: driver [at24] registered
[   28.598993] initcall at24_init+0x0/0x3a returned 0 after 0 msecs
[   28.598996] calling  eeprom_init+0x0/0x14
[   28.598997] bus: 'i2c': add driver eeprom
[   28.599120] i2c-core: driver [eeprom] registered
[   28.599125] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
[   28.613409] i2c-adapter i2c-0: Creating eeprom at 0x50
[   28.613414] device: '0-0050': device_add
[   28.613422] bus: 'i2c': add device 0-0050
[   28.613437] PM: Adding info for i2c:0-0050
[   28.613447] i2c 0-0050: uevent
[   28.613536] bus: 'i2c': driver_probe_device: matched device 0-0050 with driver eeprom
[   28.613538] bus: 'i2c': really_probe: probing driver eeprom with device 0-0050
[   28.613545] eeprom 0-0050: probe
[   28.613549] driver: '0-0050': driver_bound: bound to device 'eeprom'
[   28.613551] bus: 'i2c': really_probe: bound device 0-0050 to driver eeprom
[   28.613563] i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0050
[   28.613565] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
[   28.621413] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
[   28.629413] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
[   28.637413] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
[   28.645414] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
[   28.653415] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
[   28.661415] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
[   28.669418] initcall eeprom_init+0x0/0x14 returned 0 after 67 msecs
[   28.669421] calling  pca9539_init+0x0/0x14
[   28.669423] bus: 'i2c': add driver pca9539
[   28.669533] i2c-core: driver [pca9539] registered
[   28.669540] initcall pca9539_init+0x0/0x14 returned 0 after 0 msecs
[   28.669543] calling  pcf8574_init+0x0/0x14
[   28.669544] bus: 'i2c': add driver pcf8574
[   28.669655] i2c-core: driver [pcf8574] registered
[   28.669662] initcall pcf8574_init+0x0/0x14 returned 0 after 0 msecs
[   28.669665] calling  pcf8575_init+0x0/0x14
[   28.669666] bus: 'i2c': add driver pcf8575
[   28.669763] i2c-core: driver [pcf8575] registered
[   28.669770] initcall pcf8575_init+0x0/0x14 returned 0 after 0 msecs
[   28.669772] calling  tsl2550_init+0x0/0x14
[   28.669774] bus: 'i2c': add driver tsl2550
[   28.669885] i2c-core: driver [tsl2550] registered
[   28.669888] initcall tsl2550_init+0x0/0x14 returned 0 after 0 msecs
[   28.669890] calling  asb100_init+0x0/0x14
[   28.669892] bus: 'i2c': add driver asb100
[   28.670012] i2c-core: driver [asb100] registered
[   28.670016] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   28.677420] initcall asb100_init+0x0/0x14 returned 0 after 7 msecs
[   28.677423] calling  sensors_w83627hf_init+0x0/0x14d
[   28.677434] w83627hf: Unsupported chip (DEVID=0x74)
[   28.677445] initcall sensors_w83627hf_init+0x0/0x14d returned -19 after 0 msecs
[   28.677447] calling  sensors_w83791d_init+0x0/0x14
[   28.677449] bus: 'i2c': add driver w83791d
[   28.677548] i2c-core: driver [w83791d] registered
[   28.677552] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   28.685418] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   28.693416] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   28.725419] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[   28.733422] initcall sensors_w83791d_init+0x0/0x14 returned 0 after 53 msecs
[   28.733425] calling  ad7414_init+0x0/0x14
[   28.733427] bus: 'i2c': add driver ad7414
[   28.733531] i2c-core: driver [ad7414] registered
[   28.733534] initcall ad7414_init+0x0/0x14 returned 0 after 0 msecs
[   28.733537] calling  ad7418_init+0x0/0x14
[   28.733539] bus: 'i2c': add driver ad7418
[   28.733649] i2c-core: driver [ad7418] registered
[   28.733652] initcall ad7418_init+0x0/0x14 returned 0 after 0 msecs
[   28.733654] calling  init_adcxx+0x0/0x7b
[   28.733656] bus: 'spi': add driver adcxx1s
[   28.733752] bus: 'spi': add driver adcxx2s
[   28.733853] bus: 'spi': add driver adcxx4s
[   28.733968] bus: 'spi': add driver adcxx8s
[   28.734065] initcall init_adcxx+0x0/0x7b returned 0 after 0 msecs
[   28.734067] calling  sensors_adm1021_init+0x0/0x14
[   28.734069] bus: 'i2c': add driver adm1021
[   28.734165] i2c-core: driver [adm1021] registered
[   28.734170] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[   28.741421] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[   28.749420] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[   28.757421] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   28.765422] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   28.773422] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   28.781423] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[   28.813425] adm1021: detect failed, chip not detected!
[   28.813426] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[   28.821425] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[   28.853428] adm1021: detect failed, chip not detected!
[   28.853432] initcall sensors_adm1021_init+0x0/0x14 returned 0 after 113 msecs
[   28.853435] calling  sensors_adm1025_init+0x0/0x14
[   28.853437] bus: 'i2c': add driver adm1025
[   28.853550] i2c-core: driver [adm1025] registered
[   28.853554] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   28.861429] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   28.869429] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   28.893430] i2c-adapter i2c-0: ADM1025 detection failed at 0x2e.
[   28.893435] initcall sensors_adm1025_init+0x0/0x14 returned 0 after 38 msecs
[   28.893437] calling  sensors_adm1029_init+0x0/0x14
[   28.893439] bus: 'i2c': add driver adm1029
[   28.893538] i2c-core: driver [adm1029] registered
[   28.893543] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[   28.901432] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   28.909431] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   28.917431] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   28.925432] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   28.933433] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   28.941434] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   28.981436] adm1029: Unsupported chip (man_id=0x00, chip_id=0x00)
[   28.981437] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[   28.989438] initcall sensors_adm1029_init+0x0/0x14 returned 0 after 91 msecs
[   28.989441] calling  sensors_adm1031_init+0x0/0x14
[   28.989443] bus: 'i2c': add driver adm1031
[   28.989542] i2c-core: driver [adm1031] registered
[   28.989546] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   28.997436] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.005437] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.029443] initcall sensors_adm1031_init+0x0/0x14 returned 0 after 38 msecs
[   29.029445] calling  sensors_adm9240_init+0x0/0x14
[   29.029447] bus: 'i2c': add driver adm9240
[   29.029566] i2c-core: driver [adm9240] registered
[   29.029571] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.037440] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.045440] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.061440] i2c-adapter i2c-0: detect fail: address match, 0x2e
[   29.061442] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[   29.069445] initcall sensors_adm9240_init+0x0/0x14 returned 0 after 38 msecs
[   29.069447] calling  sensors_ads7828_init+0x0/0x53
[   29.069449] bus: 'i2c': add driver ads7828
[   29.069560] i2c-core: driver [ads7828] registered
[   29.069564] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[   29.077442] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[   29.085442] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[   29.093442] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[   29.101447] initcall sensors_ads7828_init+0x0/0x53 returned 0 after 30 msecs
[   29.101449] calling  applesmc_init+0x0/0x557
[   29.101452] applesmc: supported laptop not found!
[   29.101453] applesmc: driver init failed (ret=-19)!
[   29.101455] initcall applesmc_init+0x0/0x557 returned -19 after 0 msecs
[   29.101457] calling  atxp1_init+0x0/0x14
[   29.101459] bus: 'i2c': add driver atxp1
[   29.101568] i2c-core: driver [atxp1] registered
[   29.101572] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x37
[   29.109444] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[   29.141450] initcall atxp1_init+0x0/0x14 returned 0 after 38 msecs
[   29.141452] calling  f71882fg_init+0x0/0xfd
[   29.141468] f71882fg: Not a Fintek device
[   29.141479] f71882fg: Not a Fintek device
[   29.141481] initcall f71882fg_init+0x0/0xfd returned -19 after 0 msecs
[   29.141483] calling  sensors_f75375_init+0x0/0x14
[   29.141485] bus: 'i2c': add driver f75375
[   29.141598] i2c-core: driver [f75375] registered
[   29.141603] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.149446] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.197448] i2c-adapter i2c-0: failed,FFFF,02,2222
[   29.197453] initcall sensors_f75375_init+0x0/0x14 returned 0 after 53 msecs
[   29.197455] calling  sensors_fscher_init+0x0/0x14
[   29.197457] bus: 'i2c': add driver fscher
[   29.197557] i2c-core: driver [fscher] registered
[   29.197561] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
[   29.205453] initcall sensors_fscher_init+0x0/0x14 returned 0 after 7 msecs
[   29.205455] calling  fschmd_init+0x0/0x14
[   29.205457] bus: 'i2c': add driver fschmd
[   29.205556] i2c-core: driver [fschmd] registered
[   29.205561] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
[   29.213454] initcall fschmd_init+0x0/0x14 returned 0 after 7 msecs
[   29.213456] calling  sm_fscpos_init+0x0/0x14
[   29.213458] bus: 'i2c': add driver fscpos
[   29.213577] i2c-core: driver [fscpos] registered
[   29.213582] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
[   29.221454] initcall sm_fscpos_init+0x0/0x14 returned 0 after 7 msecs
[   29.221456] calling  sensors_gl518sm_init+0x0/0x14
[   29.221458] bus: 'i2c': add driver gl518sm
[   29.221566] i2c-core: driver [gl518sm] registered
[   29.221570] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.229448] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.237454] initcall sensors_gl518sm_init+0x0/0x14 returned 0 after 15 msecs
[   29.237456] calling  sensors_gl520sm_init+0x0/0x14
[   29.237458] bus: 'i2c': add driver gl520sm
[   29.237558] i2c-core: driver [gl520sm] registered
[   29.237562] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.245453] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.253456] initcall sensors_gl520sm_init+0x0/0x14 returned 0 after 15 msecs
[   29.253458] calling  sm_it87_init+0x0/0x299
[   29.253480] it87: Unsupported chip (DEVID=0x7401)
[   29.253485] initcall sm_it87_init+0x0/0x299 returned -19 after 0 msecs
[   29.253487] calling  k8temp_init+0x0/0x1b
[   29.253495] bus: 'pci': add driver k8temp
[   29.253646] initcall k8temp_init+0x0/0x1b returned 0 after 0 msecs
[   29.253648] calling  sensors_lm75_init+0x0/0x14
[   29.253650] bus: 'i2c': add driver lm75
[   29.253747] i2c-core: driver [lm75] registered
[   29.253751] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[   29.261454] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[   29.269453] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[   29.277454] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[   29.285455] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[   29.325457] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[   29.333458] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[   29.373460] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
[   29.381465] initcall sensors_lm75_init+0x0/0x14 returned 0 after 121 msecs
[   29.381467] calling  sensors_lm77_init+0x0/0x14
[   29.381469] bus: 'i2c': add driver lm77
[   29.381578] i2c-core: driver [lm77] registered
[   29.381583] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[   29.389462] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[   29.397462] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[   29.405462] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[   29.413465] initcall sensors_lm77_init+0x0/0x14 returned 0 after 30 msecs
[   29.413467] calling  sm_lm78_init+0x0/0x329
[   29.413469] bus: 'i2c': add driver lm78
[   29.413589] i2c-core: driver [lm78] registered
[   29.413591] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[   29.421463] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   29.429464] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   29.437464] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   29.445465] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.453464] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.461465] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.485468] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[   29.493487] initcall sm_lm78_init+0x0/0x329 returned 0 after 76 msecs
[   29.493489] calling  sensors_lm80_init+0x0/0x14
[   29.493491] bus: 'i2c': add driver lm80
[   29.493600] i2c-core: driver [lm80] registered
[   29.493604] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
[   29.501468] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   29.509469] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   29.517469] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   29.525469] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.533470] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.541470] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.573473] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
[   29.581477] initcall sensors_lm80_init+0x0/0x14 returned 0 after 83 msecs
[   29.581479] calling  sensors_lm83_init+0x0/0x14
[   29.581481] bus: 'i2c': add driver lm83
[   29.581581] i2c-core: driver [lm83] registered
[   29.581585] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[   29.589473] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[   29.597474] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[   29.605475] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   29.613474] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   29.621475] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   29.629476] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[   29.653478] i2c-adapter i2c-0: LM83 detection failed at 0x4c.
[   29.653479] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[   29.661478] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[   29.685479] i2c-adapter i2c-0: LM83 detection failed at 0x4e.
[   29.685484] initcall sensors_lm83_init+0x0/0x14 returned 0 after 99 msecs
[   29.685486] calling  sm_lm85_init+0x0/0x14
[   29.685488] bus: 'i2c': add driver lm85
[   29.685601] i2c-core: driver [lm85] registered
[   29.685604] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.693481] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.701480] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.725482] i2c-adapter i2c-0: Detecting device at 0,0x2e with COMPANY: 0x5c and VERSTEP: 0x68
[   29.725484] i2c-adapter i2c-0: Autodetecting device at 0,0x2e ...
[   29.725486] i2c-adapter i2c-0: lm85: Detected SMSC chip
[   29.725487] i2c-adapter i2c-0: lm85: Unrecognized version/stepping 0x68 Defaulting to Generic LM85.
[   29.725490] device: '0-002e': device_add
[   29.725499] bus: 'i2c': add device 0-002e
[   29.725514] PM: Adding info for i2c:0-002e
[   29.725521] driver: '0-002e': driver_bound: bound to device 'lm85'
[   29.725524] i2c-adapter i2c-0: client [lm85] registered with bus id 0-002e
[   29.741534] device: 'hwmon0': device_add
[   29.741562] PM: Adding info for No Bus:hwmon0
[   29.741666] initcall sm_lm85_init+0x0/0x14 returned 0 after 53 msecs
[   29.741669] calling  sensors_lm87_init+0x0/0x14
[   29.741671] bus: 'i2c': add driver lm87
[   29.741769] i2c-core: driver [lm87] registered
[   29.741774] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.749484] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.757484] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.757490] initcall sensors_lm87_init+0x0/0x14 returned 0 after 15 msecs
[   29.757492] calling  sensors_lm92_init+0x0/0x14
[   29.757494] bus: 'i2c': add driver lm92
[   29.757608] i2c-core: driver [lm92] registered
[   29.757612] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
[   29.765485] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
[   29.773485] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
[   29.781486] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
[   29.789489] initcall sensors_lm92_init+0x0/0x14 returned 0 after 30 msecs
[   29.789492] calling  sensors_max1619_init+0x0/0x14
[   29.789494] bus: 'i2c': add driver max1619
[   29.789594] i2c-core: driver [max1619] registered
[   29.789599] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
[   29.797488] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
[   29.805507] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
[   29.813488] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
[   29.821488] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
[   29.829489] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
[   29.837489] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
[   29.869491] i2c-adapter i2c-0: MAX1619 detection failed at 0x4c.
[   29.869493] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
[   29.877491] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
[   29.909493] i2c-adapter i2c-0: MAX1619 detection failed at 0x4e.
[   29.909497] initcall sensors_max1619_init+0x0/0x14 returned 0 after 114 msecs
[   29.909500] calling  pc87360_init+0x0/0x191
[   29.909516] pc87360: PC8736x not detected, module not inserted.
[   29.909517] initcall pc87360_init+0x0/0x191 returned -19 after 0 msecs
[   29.909519] calling  pc87427_init+0x0/0x11b
[   29.909537] initcall pc87427_init+0x0/0x11b returned -19 after 0 msecs
[   29.909539] calling  sm_sis5595_init+0x0/0x1b
[   29.909543] bus: 'pci': add driver sis5595
[   29.909682] initcall sm_sis5595_init+0x0/0x1b returned 0 after 0 msecs
[   29.909684] calling  smsc47b397_init+0x0/0x18a
[   29.909695] initcall smsc47b397_init+0x0/0x18a returned -19 after 0 msecs
[   29.909697] calling  sm_smsc47m1_init+0x0/0x1f0
[   29.909708] initcall sm_smsc47m1_init+0x0/0x1f0 returned -19 after 0 msecs
[   29.909710] calling  smsc47m192_init+0x0/0x14
[   29.909712] bus: 'i2c': add driver smsc47m192
[   29.909829] i2c-core: driver [smsc47m192] registered
[   29.909834] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
[   29.917495] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
[   29.925497] initcall smsc47m192_init+0x0/0x14 returned 0 after 15 msecs
[   29.925500] calling  sm_via686a_init+0x0/0x1b
[   29.925502] bus: 'pci': add driver via686a
[   29.925629] initcall sm_via686a_init+0x0/0x1b returned 0 after 0 msecs
[   29.925631] calling  vt1211_init+0x0/0x150
[   29.925652] initcall vt1211_init+0x0/0x150 returned -19 after 0 msecs
[   29.925654] calling  sensors_w83627ehf_init+0x0/0x150
[   29.925686] initcall sensors_w83627ehf_init+0x0/0x150 returned -19 after 0 msecs
[   29.925689] calling  sensors_w83l785ts_init+0x0/0x14
[   29.925691] bus: 'i2c': add driver w83l785ts
[   29.925788] i2c-core: driver [w83l785ts] registered
[   29.925793] i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
[   29.925798] initcall sensors_w83l785ts_init+0x0/0x14 returned 0 after 0 msecs
[   29.925801] calling  usb_pcwd_init+0x0/0x4b
[   29.925806] bus: 'usb': add driver pcwd_usb
[   29.925929] usbcore: registered new interface driver pcwd_usb
[   29.925932] pcwd_usb: Berkshire USB-PC Watchdog driver v1.02 (21 Jan 2007)
[   29.925935] initcall usb_pcwd_init+0x0/0x4b returned 0 after 0 msecs
[   29.925937] calling  advwdt_init+0x0/0x5f
[   29.925938] WDT driver for Advantech single board computer initialising.
[   29.925940] bus: 'platform': add driver advantechwdt
[   29.926048] Registering platform device 'advantechwdt'. Parent at platform
[   29.926050] device: 'advantechwdt': device_add
[   29.926059] bus: 'platform': add device advantechwdt
[   29.926080] PM: Adding info for platform:advantechwdt
[   29.926177] bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
[   29.926179] bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
[   29.926192] device: 'watchdog': device_add
[   29.926267] PM: Adding info for No Bus:watchdog
[   29.926369] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[   29.926371] driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
[   29.926373] bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
[   29.926377] initcall advwdt_init+0x0/0x5f returned 0 after 0 msecs
[   29.926379] calling  alim7101_wdt_init+0x0/0x18e
[   29.926380] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   29.926391] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   29.926392] initcall alim7101_wdt_init+0x0/0x18e returned -16 after 0 msecs
[   29.926395] initcall alim7101_wdt_init+0x0/0x18e returned with error code -16 
[   29.926397] calling  ibwdt_init+0x0/0x5f
[   29.926398] ib700wdt: WDT driver for IB700 single board computer initialising.
[   29.926400] bus: 'platform': add driver ib700wdt
[   29.926511] Registering platform device 'ib700wdt'. Parent at platform
[   29.926512] device: 'ib700wdt': device_add
[   29.926520] bus: 'platform': add device ib700wdt
[   29.926533] PM: Adding info for platform:ib700wdt
[   29.926629] bus: 'platform': driver_probe_device: matched device ib700wdt with driver ib700wdt
[   29.926630] bus: 'platform': really_probe: probing driver ib700wdt with device ib700wdt
[   29.926640] ib700wdt: START method I/O 443 is not available.
[   29.926650] ib700wdt: probe of ib700wdt failed with error -5
[   29.926654] initcall ibwdt_init+0x0/0x5f returned 0 after 0 msecs
[   29.926656] calling  ibmasr_init+0x0/0x264
[   29.926658] initcall ibmasr_init+0x0/0x264 returned -19 after 0 msecs
[   29.926661] calling  wafwdt_init+0x0/0x162
[   29.926662] WDT driver for Wafer 5823 single board computer initialising.
[   29.926666] Wafer 5823 WDT: I/O address 0x0443 already in use
[   29.926669] initcall wafwdt_init+0x0/0x162 returned -5 after 0 msecs
[   29.926672] initcall wafwdt_init+0x0/0x162 returned with error code -5 
[   29.926674] calling  iTCO_wdt_init_module+0x0/0x6e
[   29.926675] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   29.926677] bus: 'platform': add driver iTCO_wdt
[   29.926807] Registering platform device 'iTCO_wdt'. Parent at platform
[   29.926809] device: 'iTCO_wdt': device_add
[   29.926823] bus: 'platform': add device iTCO_wdt
[   29.926836] PM: Adding info for platform:iTCO_wdt
[   29.926929] bus: 'platform': driver_probe_device: matched device iTCO_wdt with driver iTCO_wdt
[   29.926931] bus: 'platform': really_probe: probing driver iTCO_wdt with device iTCO_wdt
[   29.926997] iTCO_wdt: No card detected
[   29.927007] initcall iTCO_wdt_init_module+0x0/0x6e returned 0 after 0 msecs
[   29.927009] calling  iTCO_vendor_init_module+0x0/0x1c
[   29.927011] iTCO_vendor_support: vendor-support=0
[   29.927012] initcall iTCO_vendor_init_module+0x0/0x1c returned 0 after 0 msecs
[   29.927015] calling  it8712f_wdt_init+0x0/0x1ac
[   29.927052] initcall it8712f_wdt_init+0x0/0x1ac returned -19 after 0 msecs
[   29.927054] calling  hpwdt_init+0x0/0x1b
[   29.927058] bus: 'pci': add driver hpwdt
[   29.927199] initcall hpwdt_init+0x0/0x1b returned 0 after 0 msecs
[   29.927201] calling  pc87413_init+0x0/0x92
[   29.927202] pc87413 WDT: Version 1.1 at io 0x2E
[   29.927204] pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
[   29.927206] initcall pc87413_init+0x0/0x92 returned -16 after 0 msecs
[   29.927208] initcall pc87413_init+0x0/0x92 returned with error code -16 
[   29.927210] calling  sbc60xxwdt_init+0x0/0x17d
[   29.927214] sbc60xxwdt: I/O address 0x0443 already in use
[   29.927216] initcall sbc60xxwdt_init+0x0/0x17d returned -5 after 0 msecs
[   29.927218] initcall sbc60xxwdt_init+0x0/0x17d returned with error code -5 
[   29.927220] calling  sbc8360_init+0x0/0x19e
[   29.927223] sbc8360: failed to register misc device
[   29.927228] initcall sbc8360_init+0x0/0x19e returned -16 after 0 msecs
[   29.927230] initcall sbc8360_init+0x0/0x19e returned with error code -16 
[   29.927234] calling  cpu5wdt_init_module+0x0/0x134
[   29.927238] cpu5wdt: sorry, was my fault
[   29.927239] cpu5wdt: misc_register failed
[   29.927242] initcall cpu5wdt_init_module+0x0/0x134 returned -16 after 0 msecs
[   29.927244] initcall cpu5wdt_init_module+0x0/0x134 returned with error code -16 
[   29.927246] calling  wdt_init+0x0/0x1c9
[   29.927247] w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
[   29.927250] w83697hf/hg WDT: Looking for watchdog at address 0x2e
[   29.927268] w83697hf/hg WDT: watchdog not found at address 0x2e
[   29.927271] w83697hf/hg WDT: No W83697HF/HG could be found
[   29.927272] initcall wdt_init+0x0/0x1c9 returned -5 after 0 msecs
[   29.927275] initcall wdt_init+0x0/0x1c9 returned with error code -5 
[   29.927276] calling  w83977f_wdt_init+0x0/0x116
[   29.927278] W83977F WDT: W83977F WDT driver, v1.00
[   29.927280] W83977F WDT: cannot register miscdev on minor=130 (err=-16)
[   29.927283] initcall w83977f_wdt_init+0x0/0x116 returned -16 after 0 msecs
[   29.927286] initcall w83977f_wdt_init+0x0/0x116 returned with error code -16 
[   29.927288] calling  zf_init+0x0/0x160
[   29.927289] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   29.927292] machzwd: no ZF-Logic found
[   29.927293] initcall zf_init+0x0/0x160 returned -19 after 0 msecs
[   29.927296] calling  watchdog_init+0x0/0xb5
[   29.927298] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   29.927301] initcall watchdog_init+0x0/0xb5 returned -16 after 0 msecs
[   29.927303] initcall watchdog_init+0x0/0xb5 returned with error code -16 
[   29.927305] calling  watchdog_init+0x0/0xb5
[   29.927307] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   29.927309] initcall watchdog_init+0x0/0xb5 returned -16 after 0 msecs
[   29.927311] initcall watchdog_init+0x0/0xb5 returned with error code -16 
[   29.927313] calling  telephony_init+0x0/0x4c
[   29.927314] Linux telephony interface: v1.00
[   29.927320] initcall telephony_init+0x0/0x4c returned 0 after 0 msecs
[   29.927322] calling  dm_init+0x0/0x49
[   29.927848] device-mapper: uevent: version 1.0.3
[   29.928089] device: 'device-mapper': device_add
[   29.928134] PM: Adding info for No Bus:device-mapper
[   29.928224] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   29.928227] initcall dm_init+0x0/0x49 returned 0 after 0 msecs
[   29.928229] calling  dm_crypt_init+0x0/0x69
[   29.928404] initcall dm_crypt_init+0x0/0x69 returned 0 after 0 msecs
[   29.928407] calling  dm_delay_init+0x0/0xc0
[   29.928677] initcall dm_delay_init+0x0/0xc0 returned 0 after 0 msecs
[   29.928679] calling  dm_snapshot_init+0x0/0x1ef
[   29.929205] initcall dm_snapshot_init+0x0/0x1ef returned 0 after 0 msecs
[   29.929208] calling  dm_mirror_init+0x0/0x2f
[   29.929220] initcall dm_mirror_init+0x0/0x2f returned 0 after 0 msecs
[   29.929222] calling  dm_dirty_log_init+0x0/0x59
[   29.929234] initcall dm_dirty_log_init+0x0/0x59 returned 0 after 0 msecs
[   29.929236] calling  hci_usb_init+0x0/0x54
[   29.929237] Bluetooth: HCI USB driver ver 2.10
[   29.929243] bus: 'usb': add driver hci_usb
[   29.929364] usbcore: registered new interface driver hci_usb
[   29.929368] initcall hci_usb_init+0x0/0x54 returned 0 after 0 msecs
[   29.929371] calling  vhci_init+0x0/0x5b
[   29.929372] Bluetooth: Virtual HCI driver ver 1.2
[   29.929376] device: 'vhci': device_add
[   29.929406] PM: Adding info for No Bus:vhci
[   29.929517] initcall vhci_init+0x0/0x5b returned 0 after 0 msecs
[   29.929519] calling  hci_uart_init+0x0/0xdd
[   29.929520] Bluetooth: HCI UART driver ver 2.2
[   29.929523] initcall hci_uart_init+0x0/0xdd returned 0 after 0 msecs
[   29.929525] calling  bcm203x_init+0x0/0x54
[   29.929526] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
[   29.929529] bus: 'usb': add driver bcm203x
[   29.929654] usbcore: registered new interface driver bcm203x
[   29.929659] initcall bcm203x_init+0x0/0x54 returned 0 after 0 msecs
[   29.929661] calling  bpa10x_init+0x0/0x30
[   29.929662] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
[   29.929664] bus: 'usb': add driver bpa10x
[   29.929785] usbcore: registered new interface driver bpa10x
[   29.929790] initcall bpa10x_init+0x0/0x30 returned 0 after 0 msecs
[   29.929792] calling  isdn_init+0x0/0x326
[   29.930983] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
[   29.930988] initcall isdn_init+0x0/0x326 returned 0 after 1 msecs
[   29.930990] calling  isdn_bsdcomp_init+0x0/0x2f
[   29.930991] PPP BSD Compression module registered
[   29.930993] initcall isdn_bsdcomp_init+0x0/0x2f returned 0 after 0 msecs
[   29.930995] calling  kcapi_init+0x0/0x98
[   29.931053] CAPI Subsystem Rev 1.1.2.8
[   29.931054] initcall kcapi_init+0x0/0x98 returned 0 after 0 msecs
[   29.931057] calling  capi_init+0x0/0x2aa
[   29.931063] device class 'capi': registering
[   29.931188] device: 'capi': device_add
[   29.931232] PM: Adding info for No Bus:capi
[   29.931351] device: 'capi0': device_add
[   29.931489] PM: Adding info for No Bus:capi0
[   29.931587] device: 'capi1': device_add
[   29.931630] PM: Adding info for No Bus:capi1
[   29.931738] device: 'capi2': device_add
[   29.931772] PM: Adding info for No Bus:capi2
[   29.931870] device: 'capi3': device_add
[   29.931904] PM: Adding info for No Bus:capi3
[   29.931994] device: 'capi4': device_add
[   29.932028] PM: Adding info for No Bus:capi4
[   29.932132] device: 'capi5': device_add
[   29.932173] PM: Adding info for No Bus:capi5
[   29.932267] device: 'capi6': device_add
[   29.932301] PM: Adding info for No Bus:capi6
[   29.932391] device: 'capi7': device_add
[   29.932425] PM: Adding info for No Bus:capi7
[   29.932538] device: 'capi8': device_add
[   29.932579] PM: Adding info for No Bus:capi8
[   29.932678] device: 'capi9': device_add
[   29.932726] PM: Adding info for No Bus:capi9
[   29.932826] device: 'capi10': device_add
[   29.932878] PM: Adding info for No Bus:capi10
[   29.932982] device: 'capi11': device_add
[   29.933019] PM: Adding info for No Bus:capi11
[   29.933110] device: 'capi12': device_add
[   29.933150] PM: Adding info for No Bus:capi12
[   29.933241] device: 'capi13': device_add
[   29.933274] PM: Adding info for No Bus:capi13
[   29.933383] device: 'capi14': device_add
[   29.933417] PM: Adding info for No Bus:capi14
[   29.933517] device: 'capi15': device_add
[   29.933551] PM: Adding info for No Bus:capi15
[   29.933642] device: 'capi16': device_add
[   29.933683] PM: Adding info for No Bus:capi16
[   29.933804] device: 'capi17': device_add
[   29.933839] PM: Adding info for No Bus:capi17
[   29.933933] device: 'capi18': device_add
[   29.933967] PM: Adding info for No Bus:capi18
[   29.934057] device: 'capi19': device_add
[   29.934091] PM: Adding info for No Bus:capi19
[   29.934194] device: 'capi20': device_add
[   29.934235] PM: Adding info for No Bus:capi20
[   29.934325] device: 'capi21': device_add
[   29.934360] PM: Adding info for No Bus:capi21
[   29.934459] device: 'capi22': device_add
[   29.934494] PM: Adding info for No Bus:capi22
[   29.934597] device: 'capi23': device_add
[   29.934647] PM: Adding info for No Bus:capi23
[   29.934745] device: 'capi24': device_add
[   29.934779] PM: Adding info for No Bus:capi24
[   29.934870] device: 'capi25': device_add
[   29.934904] PM: Adding info for No Bus:capi25
[   29.935022] device: 'capi26': device_add
[   29.935057] PM: Adding info for No Bus:capi26
[   29.935151] device: 'capi27': device_add
[   29.935193] PM: Adding info for No Bus:capi27
[   29.935284] device: 'capi28': device_add
[   29.935318] PM: Adding info for No Bus:capi28
[   29.935422] device: 'capi29': device_add
[   29.935457] PM: Adding info for No Bus:capi29
[   29.935551] device: 'capi30': device_add
[   29.935585] PM: Adding info for No Bus:capi30
[   29.935675] device: 'capi31': device_add
[   29.935717] PM: Adding info for No Bus:capi31
[   29.935833] capi20: Rev 1.1.2.7: started up with major 68 (middleware+capifs)
[   29.935836] initcall capi_init+0x0/0x2aa returned 0 after 4 msecs
[   29.935838] calling  capifs_init+0x0/0xd4
[   29.935901] capifs: Rev 1.1.2.3
[   29.935903] initcall capifs_init+0x0/0xd4 returned 0 after 0 msecs
[   29.935905] calling  divadidd_init+0x0/0xf4
[   29.935907] Eicon DIVA - DIDD table (http://www.melware.net)
[   29.935908] divadidd: Rel:2.0  Rev:1.13.6.4  Build:102-51(local)
[   29.935935] initcall divadidd_init+0x0/0xf4 returned 0 after 0 msecs
[   29.935938] calling  divas_init+0x0/0x16d
[   29.935939] Eicon DIVA Server driver (http://www.melware.net)
[   29.935940] divas: Rel:2.0  Rev:1.55.4.6  Build: 102-52(local)
[   29.935942] divas: support for: BRI/PCI PRI/PCI adapters
[   29.935973] bus: 'pci': add driver divas
[   29.936133] divas: started with major 247
[   29.936135] initcall divas_init+0x0/0x16d returned 0 after 0 msecs
[   29.936137] calling  divert_init+0x0/0x64
[   29.936147] dss1_divert module successfully installed
[   29.936149] initcall divert_init+0x0/0x64 returned 0 after 0 msecs
[   29.936151] calling  HiSax_init+0x0/0x35d
[   29.936152] HiSax: Linux Driver for passive ISDN cards
[   29.936153] HiSax: Version 3.5 (kernel)
[   29.936154] HiSax: Layer1 Revision 2.46.2.5
[   29.936156] HiSax: Layer2 Revision 2.30.2.4
[   29.936157] HiSax: TeiMgr Revision 2.20.2.3
[   29.936158] HiSax: Layer3 Revision 2.22.2.3
[   29.936159] HiSax: LinkLayer Revision 2.59.2.4
[   29.936179] HiSax: Total 1 card defined
[   29.936206] HiSax: Card 1 Protocol EDSS1 Id=HiSax (0)
[   29.936208] Gazel: Driver Revision 2.19.2.4
[   29.936209] Gazel: ISA PnP card automatic recognition
[   29.936213] Gazel: Card ISA R647/R648 found
[   29.936214] Gazel: config irq:15 isac:0x8180  cfg:0xC180
[   29.936215] Gazel: hscx A:0x180  hscx B:0x4180
[   29.986800] Gazel: ISAC version (ff): 2085 V2.3
[   29.986803] Gazel: HSCX version A: ???  B: ???
[   29.986804] Gazel: wrong HSCX versions check IO address
[   29.986858] HiSax: Card Gazel not installed !
[   29.986860] initcall HiSax_init+0x0/0x35d returned -19 after 48 msecs
[   29.986862] calling  st5481_usb_init+0x0/0x58
[   29.986863] hisax_st5481: ST5481 USB ISDN driver $Revision: 2.4.2.3 $
[   29.986877] bus: 'usb': add driver st5481_usb
[   29.986999] usbcore: registered new interface driver st5481_usb
[   29.987004] initcall st5481_usb_init+0x0/0x58 returned 0 after 0 msecs
[   29.987006] calling  hfc_usb_mod_init+0x0/0x8a
[   29.987008] HFC-S USB: driver module revision 2.3.2.24 date 2007/10/14 loaded, (debug=0)
[   29.987011] bus: 'usb': add driver hfc_usb
[   29.987132] usbcore: registered new interface driver hfc_usb
[   29.987136] initcall hfc_usb_mod_init+0x0/0x8a returned 0 after 0 msecs
[   29.987138] calling  hfc4s8s_module_init+0x0/0x62
[   29.987140] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
[   29.987141] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
[   29.987145] bus: 'pci': add driver hfc4s8s_l1
[   29.987270] HFC-4S/8S: found 0 cards
[   29.987272] initcall hfc4s8s_module_init+0x0/0x62 returned 0 after 0 msecs
[   29.987274] calling  hisax_isac_init+0x0/0x56
[   29.987275] hisax_isac: ISAC-S/ISAC-SX ISDN driver v0.1.0
[   29.987280] initcall hisax_isac_init+0x0/0x56 returned 0 after 0 msecs
[   29.987282] calling  hisax_fcpcipnp_init+0x0/0x59
[   29.987284] hisax_fcpcipnp: Fritz!Card PCI/PCIv2/PnP ISDN driver v0.0.1
[   29.987287] bus: 'pci': add driver fcpci
[   29.987422] pnp: the driver 'fcpnp' has been registered
[   29.987425] bus: 'pnp': add driver fcpnp
[   29.987561] initcall hisax_fcpcipnp_init+0x0/0x59 returned 0 after 0 msecs
[   29.987564] calling  init_ladder+0x0/0x12
[   29.987572] cpuidle: using governor ladder
[   29.987574] initcall init_ladder+0x0/0x12 returned 0 after 0 msecs
[   29.987576] calling  init_menu+0x0/0x12
[   29.987578] cpuidle: using governor menu
[   29.987579] initcall init_menu+0x0/0x12 returned 0 after 0 msecs
[   29.987581] calling  mmc_blk_init+0x0/0x27
[   29.987585] bus: 'mmc': add driver mmcblk
[   29.987683] initcall mmc_blk_init+0x0/0x27 returned 0 after 0 msecs
[   29.987685] calling  mmc_test_init+0x0/0x12
[   29.987687] bus: 'mmc': add driver mmc_test
[   29.987784] initcall mmc_test_init+0x0/0x12 returned 0 after 0 msecs
[   29.987787] calling  sdio_uart_init+0x0/0xf2
[   29.987804] bus: 'sdio': add driver sdio_uart
[   29.987916] initcall sdio_uart_init+0x0/0xf2 returned 0 after 0 msecs
[   29.987919] calling  sdhci_drv_init+0x0/0x24
[   29.987920] sdhci: Secure Digital Host Controller Interface driver
[   29.987921] sdhci: Copyright(c) Pierre Ossman
[   29.987922] initcall sdhci_drv_init+0x0/0x24 returned 0 after 0 msecs
[   29.987925] calling  tifm_sd_init+0x0/0x12
[   29.987927] bus: 'tifm': add driver tifm_sd
[   29.988026] initcall tifm_sd_init+0x0/0x12 returned 0 after 0 msecs
[   29.988028] calling  mmc_spi_init+0x0/0x12
[   29.988032] bus: 'spi': add driver mmc_spi
[   29.988143] initcall mmc_spi_init+0x0/0x12 returned 0 after 0 msecs
[   29.988146] calling  pca9532_init+0x0/0x14
[   29.988153] bus: 'i2c': add driver pca9532
[   29.988294] i2c-core: driver [pca9532] registered
[   29.988297] initcall pca9532_init+0x0/0x14 returned 0 after 0 msecs
[   29.988300] calling  pca955x_leds_init+0x0/0x14
[   29.988302] bus: 'i2c': add driver leds-pca955x
[   29.988408] i2c-core: driver [leds-pca955x] registered
[   29.988411] initcall pca955x_leds_init+0x0/0x14 returned 0 after 0 msecs
[   29.988413] calling  heartbeat_trig_init+0x0/0x12
[   29.988436] initcall heartbeat_trig_init+0x0/0x12 returned 0 after 0 msecs
[   29.988439] calling  defon_trig_init+0x0/0x12
[   29.988442] initcall defon_trig_init+0x0/0x12 returned 0 after 0 msecs
[   29.988444] calling  ib_core_init+0x0/0x44
[   29.988445] device class 'infiniband': registering
[   29.988559] initcall ib_core_init+0x0/0x44 returned 0 after 0 msecs
[   29.988561] calling  ib_mad_init_module+0x0/0xa3
[   29.988773] initcall ib_mad_init_module+0x0/0xa3 returned 0 after 0 msecs
[   29.988776] calling  ib_sa_init+0x0/0x9b
[   29.988840] initcall ib_sa_init+0x0/0x9b returned 0 after 0 msecs
[   29.988842] calling  ib_cm_init+0x0/0x159
[   29.988856] device class 'infiniband_cm': registering
[   29.989047] initcall ib_cm_init+0x0/0x159 returned 0 after 0 msecs
[   29.989050] calling  iw_cm_init+0x0/0x33
[   29.989094] initcall iw_cm_init+0x0/0x33 returned 0 after 0 msecs
[   29.989098] calling  addr_init+0x0/0x49
[   29.989162] initcall addr_init+0x0/0x49 returned 0 after 0 msecs
[   29.989164] calling  cma_init+0x0/0xe7
[   29.989218] initcall cma_init+0x0/0xe7 returned 0 after 0 msecs
[   29.989221] calling  ib_umad_init+0x0/0xcc
[   29.989224] device class 'infiniband_mad': registering
[   29.989327] initcall ib_umad_init+0x0/0xcc returned 0 after 0 msecs
[   29.989330] calling  ib_uverbs_init+0x0/0x151
[   29.989333] device class 'infiniband_verbs': registering
[   29.989467] initcall ib_uverbs_init+0x0/0x151 returned 0 after 0 msecs
[   29.989470] calling  ib_ucm_init+0x0/0xa6
[   29.989475] initcall ib_ucm_init+0x0/0xa6 returned 0 after 0 msecs
[   29.989477] calling  ucma_init+0x0/0x54
[   29.989490] device: 'rdma_cm': device_add
[   29.989555] PM: Adding info for No Bus:rdma_cm
[   29.989649] initcall ucma_init+0x0/0x54 returned 0 after 0 msecs
[   29.989651] calling  mthca_init+0x0/0x153
[   29.989701] bus: 'pci': add driver ib_mthca
[   29.989849] initcall mthca_init+0x0/0x153 returned 0 after 0 msecs
[   29.989852] calling  infinipath_init+0x0/0xc5
[   29.989874] bus: 'pci': add driver ib_ipath
[   29.990005] initcall infinipath_init+0x0/0xc5 returned 0 after 0 msecs
[   29.990007] calling  mlx4_ib_init+0x0/0x12
[   29.990016] initcall mlx4_ib_init+0x0/0x12 returned 0 after 0 msecs
[   29.990018] calling  nes_init_module+0x0/0x143
[   29.990196] bus: 'pci': add driver iw_nes
[   29.990371] initcall nes_init_module+0x0/0x143 returned 0 after 0 msecs
[   29.990374] calling  srp_init_module+0x0/0xf2
[   29.990379] device class 'infiniband_srp': registering
[   29.990483] initcall srp_init_module+0x0/0xf2 returned 0 after 0 msecs
[   29.990485] calling  iser_init+0x0/0x125
[   29.990674] device: 'iser': device_add
[   29.990688] PM: Adding info for No Bus:iser
[   29.990797] iscsi: registered transport (iser)
[   29.990799] initcall iser_init+0x0/0x125 returned 0 after 0 msecs
[   29.990802] calling  dcdrbu_init+0x0/0x156
[   29.990806] Registering platform device 'dell_rbu'. Parent at platform
[   29.990808] device: 'dell_rbu': device_add
[   29.990817] bus: 'platform': add device dell_rbu
[   29.990832] PM: Adding info for platform:dell_rbu
[   29.990940] initcall dcdrbu_init+0x0/0x156 returned 0 after 0 msecs
[   29.990943] calling  hifn_init+0x0/0xb3
[   29.990947] bus: 'pci': add driver hifn795x
[   29.991094] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   29.991096] initcall hifn_init+0x0/0xb3 returned 0 after 0 msecs
[   29.991099] calling  dmatest_init+0x0/0x28
[   29.991102] initcall dmatest_init+0x0/0x28 returned 0 after 0 msecs
[   29.991104] calling  ioat_init_module+0x0/0x1b
[   29.991107] bus: 'pci': add driver ioatdma
[   29.991234] initcall ioat_init_module+0x0/0x1b returned 0 after 0 msecs
[   29.991237] calling  dca_init+0x0/0x20
[   29.991238] dca service started, version 1.4
[   29.991240] device class 'dca': registering
[   29.991332] initcall dca_init+0x0/0x20 returned 0 after 0 msecs
[   29.991335] calling  hid_init+0x0/0x8
[   29.991336] initcall hid_init+0x0/0x8 returned 0 after 0 msecs
[   29.991338] calling  hid_init+0x0/0x61
[   29.991346] bus: 'usb': add driver hiddev
[   29.991480] usbcore: registered new interface driver hiddev
[   29.991485] bus: 'usb': add driver usbhid
[   29.991593] usbcore: registered new interface driver usbhid
[   29.991597] usbhid: v2.6:USB HID core driver
[   29.991599] initcall hid_init+0x0/0x61 returned 0 after 0 msecs
[   29.991601] calling  usb_mouse_init+0x0/0x38
[   29.991604] bus: 'usb': add driver usbmouse
[   29.991712] usbcore: registered new interface driver usbmouse
[   29.991716] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   29.991718] initcall usb_mouse_init+0x0/0x38 returned 0 after 0 msecs
[   29.991721] calling  oprofile_init+0x0/0x63
[   29.991725] Registering sysdev class 'oprofile'
[   29.991832] Registering sys device of class 'oprofile'
[   29.991837] Registering sys device 'oprofile0'
[   29.991930] oprofile: using NMI interrupt.
[   29.991936] initcall oprofile_init+0x0/0x63 returned 0 after 0 msecs
[   29.991938] calling  sysctl_core_init+0x0/0x25
[   29.991962] initcall sysctl_core_init+0x0/0x25 returned 0 after 0 msecs
[   29.991965] calling  flow_cache_init+0x0/0x1b7
[   29.992147] initcall flow_cache_init+0x0/0x1b7 returned 0 after 0 msecs
[   29.992150] calling  llc_init+0x0/0x20
[   29.992153] initcall llc_init+0x0/0x20 returned 0 after 0 msecs
[   29.992155] calling  llc2_init+0x0/0xca
[   29.992184] NET: Registered protocol family 26
[   29.992186] initcall llc2_init+0x0/0xca returned 0 after 0 msecs
[   29.992188] calling  snap_init+0x0/0x31
[   29.992199] initcall snap_init+0x0/0x31 returned 0 after 0 msecs
[   29.992202] calling  blackhole_module_init+0x0/0x12
[   29.992205] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992207] calling  cbq_module_init+0x0/0x12
[   29.992209] initcall cbq_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992212] calling  hfsc_init+0x0/0x12
[   29.992214] initcall hfsc_init+0x0/0x12 returned 0 after 0 msecs
[   29.992216] calling  red_module_init+0x0/0x12
[   29.992218] initcall red_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992221] calling  gred_module_init+0x0/0x12
[   29.992223] initcall gred_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992225] calling  sfq_module_init+0x0/0x12
[   29.992227] initcall sfq_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992230] calling  tbf_module_init+0x0/0x12
[   29.992232] initcall tbf_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992234] calling  prio_module_init+0x0/0x12
[   29.992236] initcall prio_module_init+0x0/0x12 returned 0 after 0 msecs
[   29.992239] calling  init_u32+0x0/0x2e
[   29.992240] u32 classifier
[   29.992241]     input device check on 
[   29.992248] initcall init_u32+0x0/0x2e returned 0 after 0 msecs
[   29.992250] calling  init_route4+0x0/0x12
[   29.992252] initcall init_route4+0x0/0x12 returned 0 after 0 msecs
[   29.992254] calling  init_rsvp+0x0/0x12
[   29.992256] initcall init_rsvp+0x0/0x12 returned 0 after 0 msecs
[   29.992259] calling  init_tcindex+0x0/0x12
[   29.992261] initcall init_tcindex+0x0/0x12 returned 0 after 0 msecs
[   29.992263] calling  init_basic+0x0/0x12
[   29.992265] initcall init_basic+0x0/0x12 returned 0 after 0 msecs
[   29.992268] calling  cls_flow_init+0x0/0x12
[   29.992270] initcall cls_flow_init+0x0/0x12 returned 0 after 0 msecs
[   29.992272] calling  init_em_meta+0x0/0x12
[   29.992279] initcall init_em_meta+0x0/0x12 returned 0 after 0 msecs
[   29.992281] calling  init_em_text+0x0/0x12
[   29.992283] initcall init_em_text+0x0/0x12 returned 0 after 0 msecs
[   29.992285] calling  nfnetlink_init+0x0/0x5d
[   29.992286] Netfilter messages via NETLINK v0.30.
[   29.992298] initcall nfnetlink_init+0x0/0x5d returned 0 after 0 msecs
[   29.992300] calling  nfnetlink_log_init+0x0/0xa5
[   29.992320] initcall nfnetlink_log_init+0x0/0xa5 returned 0 after 0 msecs
[   29.992322] calling  nf_conntrack_standalone_init+0x0/0xe4
[   29.992357] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[   29.992717] initcall nf_conntrack_standalone_init+0x0/0xe4 returned 0 after 0 msecs
[   29.992719] calling  ctnetlink_init+0x0/0x76
[   29.992720] ctnetlink v0.93: registering with nfnetlink.
[   29.992723] initcall ctnetlink_init+0x0/0x76 returned 0 after 0 msecs
[   29.992725] calling  nf_conntrack_ftp_init+0x0/0x1a0
[   29.992736] initcall nf_conntrack_ftp_init+0x0/0x1a0 returned 0 after 0 msecs
[   29.992738] calling  xt_init+0x0/0xe8
[   29.992748] initcall xt_init+0x0/0xe8 returned 0 after 0 msecs
[   29.992750] calling  tcpudp_mt_init+0x0/0x17
[   29.992760] initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 msecs
[   29.992762] calling  mark_tg_init+0x0/0x17
[   29.992766] initcall mark_tg_init+0x0/0x17 returned 0 after 0 msecs
[   29.992768] calling  nflog_tg_init+0x0/0x17
[   29.992771] initcall nflog_tg_init+0x0/0x17 returned 0 after 0 msecs
[   29.992773] calling  conntrack_mt_init+0x0/0x17
[   29.992776] initcall conntrack_mt_init+0x0/0x17 returned 0 after 0 msecs
[   29.992778] calling  mark_mt_init+0x0/0x17
[   29.992781] initcall mark_mt_init+0x0/0x17 returned 0 after 0 msecs
[   29.992783] calling  policy_mt_init+0x0/0x17
[   29.992785] initcall policy_mt_init+0x0/0x17 returned 0 after 0 msecs
[   29.992787] calling  state_mt_init+0x0/0x17
[   29.992789] initcall state_mt_init+0x0/0x17 returned 0 after 0 msecs
[   29.992791] calling  sysctl_ipv4_init+0x0/0x4e
[   29.992803] initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 msecs
[   29.992805] calling  ah4_init+0x0/0x68
[   29.992808] initcall ah4_init+0x0/0x68 returned 0 after 0 msecs
[   29.992810] calling  xfrm4_beet_init+0x0/0x17
[   29.992812] initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 msecs
[   29.992814] calling  xfrm4_transport_init+0x0/0x17
[   29.992816] initcall xfrm4_transport_init+0x0/0x17 returned 0 after 0 msecs
[   29.992819] calling  xfrm4_mode_tunnel_init+0x0/0x17
[   29.992821] initcall xfrm4_mode_tunnel_init+0x0/0x17 returned 0 after 0 msecs
[   29.992824] calling  ipv4_netfilter_init+0x0/0x17
[   29.992832] initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 0 msecs
[   29.992834] calling  ip_vs_init+0x0/0xa5
[   29.992867] IPVS: Registered protocols (TCP, UDP, ESP)
[   29.993052] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
[   29.993053] IPVS: Each connection entry needs 264 bytes at least
[   29.993103] IPVS: ipvs loaded.
[   29.993105] initcall ip_vs_init+0x0/0xa5 returned 0 after 0 msecs
[   29.993107] calling  ip_vs_wrr_init+0x0/0x12
[   29.993113] IPVS: [wrr] scheduler registered.
[   29.993115] initcall ip_vs_wrr_init+0x0/0x12 returned 0 after 0 msecs
[   29.993117] calling  ip_vs_wlc_init+0x0/0x12
[   29.993119] IPVS: [wlc] scheduler registered.
[   29.993120] initcall ip_vs_wlc_init+0x0/0x12 returned 0 after 0 msecs
[   29.993122] calling  ip_vs_lblc_init+0x0/0x47
[   29.993127] IPVS: [lblc] scheduler registered.
[   29.993129] initcall ip_vs_lblc_init+0x0/0x47 returned 0 after 0 msecs
[   29.993131] calling  ip_vs_dh_init+0x0/0x12
[   29.993132] IPVS: [dh] scheduler registered.
[   29.993134] initcall ip_vs_dh_init+0x0/0x12 returned 0 after 0 msecs
[   29.993136] calling  ip_vs_sh_init+0x0/0x12
[   29.993137] IPVS: [sh] scheduler registered.
[   29.993139] initcall ip_vs_sh_init+0x0/0x12 returned 0 after 0 msecs
[   29.993141] calling  ip_vs_sed_init+0x0/0x12
[   29.993142] IPVS: [sed] scheduler registered.
[   29.993144] initcall ip_vs_sed_init+0x0/0x12 returned 0 after 0 msecs
[   29.993146] calling  ip_vs_ftp_init+0x0/0x93
[   29.993160] IPVS: ftp: loaded support on port[0] = 21
[   29.993162] initcall ip_vs_ftp_init+0x0/0x93 returned 0 after 0 msecs
[   29.993164] calling  inet_diag_init+0x0/0x69
[   29.993173] initcall inet_diag_init+0x0/0x69 returned 0 after 0 msecs
[   29.993175] calling  tcp_diag_init+0x0/0x12
[   29.993183] initcall tcp_diag_init+0x0/0x12 returned 0 after 0 msecs
[   29.993185] calling  bictcp_register+0x0/0x12
[   29.993187] TCP bic registered
[   29.993188] initcall bictcp_register+0x0/0x12 returned 0 after 0 msecs
[   29.993191] calling  cubictcp_register+0x0/0x68
[   29.993192] TCP cubic registered
[   29.993193] initcall cubictcp_register+0x0/0x68 returned 0 after 0 msecs
[   29.993196] calling  tcp_westwood_register+0x0/0x12
[   29.993197] TCP westwood registered
[   29.993199] initcall tcp_westwood_register+0x0/0x12 returned 0 after 0 msecs
[   29.993201] calling  hstcp_register+0x0/0x12
[   29.993202] TCP highspeed registered
[   29.993203] initcall hstcp_register+0x0/0x12 returned 0 after 0 msecs
[   29.993206] calling  htcp_register+0x0/0x12
[   29.993207] TCP htcp registered
[   29.993208] initcall htcp_register+0x0/0x12 returned 0 after 0 msecs
[   29.993210] calling  tcp_vegas_register+0x0/0x14
[   29.993212] TCP vegas registered
[   29.993213] initcall tcp_vegas_register+0x0/0x14 returned 0 after 0 msecs
[   29.993215] calling  tcp_veno_register+0x0/0x14
[   29.993217] TCP veno registered
[   29.993218] initcall tcp_veno_register+0x0/0x14 returned 0 after 0 msecs
[   29.993220] calling  tcp_yeah_register+0x0/0x14
[   29.993221] TCP yeah registered
[   29.993223] initcall tcp_yeah_register+0x0/0x14 returned 0 after 0 msecs
[   29.993225] calling  tcp_illinois_register+0x0/0x12
[   29.993226] TCP illinois registered
[   29.993228] initcall tcp_illinois_register+0x0/0x12 returned 0 after 0 msecs
[   29.993230] calling  inet6_init+0x0/0x342
[   29.994194] NET: Registered protocol family 10
[   29.995812] initcall inet6_init+0x0/0x342 returned 0 after 2 msecs
[   29.995814] calling  ah6_init+0x0/0x68
[   29.995817] initcall ah6_init+0x0/0x68 returned 0 after 0 msecs
[   29.995819] calling  esp6_init+0x0/0x68
[   29.995821] initcall esp6_init+0x0/0x68 returned 0 after 0 msecs
[   29.995823] calling  tunnel6_init+0x0/0x68
[   29.995826] initcall tunnel6_init+0x0/0x68 returned 0 after 0 msecs
[   29.995828] calling  xfrm6_mode_tunnel_init+0x0/0x17
[   29.995830] initcall xfrm6_mode_tunnel_init+0x0/0x17 returned 0 after 0 msecs
[   29.995832] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x11a
[   29.995868] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x11a returned 0 after 0 msecs
[   29.995871] calling  ip6_tunnel_init+0x0/0xa2
[   29.995908] device: 'ip6tnl0': device_add
[   29.996006] PM: Adding info for No Bus:ip6tnl0
[   29.996299] initcall ip6_tunnel_init+0x0/0xa2 returned 0 after 0 msecs
[   29.996302] calling  packet_init+0x0/0x47
[   29.996304] NET: Registered protocol family 17
[   29.996323] initcall packet_init+0x0/0x47 returned 0 after 0 msecs
[   29.996325] calling  ipsec_pfkey_init+0x0/0x8c
[   29.996327] NET: Registered protocol family 15
[   29.996338] initcall ipsec_pfkey_init+0x0/0x8c returned 0 after 0 msecs
[   29.996340] calling  atalk_init+0x0/0x8d
[   29.996342] NET: Registered protocol family 5
[   35.597887] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   35.605870] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   35.635422] device: 'input0': device_add
[   35.637944] initcall atalk_init+0x0/0x8d returned 0 after 5380 msecs
[   35.637947] calling  nr_proto_init+0x0/0x259
[   35.637964] device: 'nr0': device_add
[   35.638072] PM: Adding info for No Bus:nr0
[   35.638294] device: 'nr1': device_add
[   35.638382] PM: Adding info for No Bus:nr1
[   35.638516] device: 'nr2': device_add
[   35.638598] PM: Adding info for No Bus:nr2
[   35.638746] device: 'nr3': device_add
[   35.638860] PM: Adding info for No Bus:nr3
[   35.638986] NET: Registered protocol family 6
[   35.639075] initcall nr_proto_init+0x0/0x259 returned 0 after 1 msecs
[   35.639078] calling  ax25_init+0x0/0xad
[   35.639079] NET: Registered protocol family 3
[   35.639105] initcall ax25_init+0x0/0xad returned 0 after 0 msecs
[   35.639107] calling  can_init+0x0/0xf3
[   35.639108] can: controller area network core (rev 20071116 abi 8)
[   35.639379] NET: Registered protocol family 29
[   35.639383] initcall can_init+0x0/0xf3 returned 0 after 0 msecs
[   35.639386] calling  raw_module_init+0x0/0x3d
[   35.639387] can: raw protocol (rev 20071116)
[   35.639395] initcall raw_module_init+0x0/0x3d returned 0 after 0 msecs
[   35.639397] calling  irlan_init+0x0/0x23d
[   35.639422] device: 'irlan0': device_add
[   35.639510] PM: Adding info for No Bus:irlan0
[   35.639827] initcall irlan_init+0x0/0x23d returned 0 after 0 msecs
[   35.639830] calling  ircomm_init+0x0/0x9a
[   35.639836] IrCOMM protocol (Dag Brattli)
[   35.639838] initcall ircomm_init+0x0/0x9a returned 0 after 0 msecs
[   35.639840] calling  ircomm_tty_init+0x0/0x134
[   35.639853] device: 'ircomm0': device_add
[   35.640120] PM: Adding info for No Bus:ircomm0
[   35.640218] device: 'ircomm1': device_add
[   35.640255] PM: Adding info for No Bus:ircomm1
[   35.640346] device: 'ircomm2': device_add
[   35.640387] PM: Adding info for No Bus:ircomm2
[   35.640477] device: 'ircomm3': device_add
[   35.640512] PM: Adding info for No Bus:ircomm3
[   35.640602] device: 'ircomm4': device_add
[   35.640646] PM: Adding info for No Bus:ircomm4
[   35.640740] device: 'ircomm5': device_add
[   35.640775] PM: Adding info for No Bus:ircomm5
[   35.640865] device: 'ircomm6': device_add
[   35.640907] PM: Adding info for No Bus:ircomm6
[   35.640997] device: 'ircomm7': device_add
[   35.641032] PM: Adding info for No Bus:ircomm7
[   35.641121] device: 'ircomm8': device_add
[   35.641156] PM: Adding info for No Bus:ircomm8
[   35.641249] device: 'ircomm9': device_add
[   35.641291] PM: Adding info for No Bus:ircomm9
[   35.641381] device: 'ircomm10': device_add
[   35.641416] PM: Adding info for No Bus:ircomm10
[   35.641506] device: 'ircomm11': device_add
[   35.641541] PM: Adding info for No Bus:ircomm11
[   35.641632] device: 'ircomm12': device_add
[   35.641667] PM: Adding info for No Bus:ircomm12
[   35.641769] device: 'ircomm13': device_add
[   35.641811] PM: Adding info for No Bus:ircomm13
[   35.641911] device: 'ircomm14': device_add
[   35.641946] PM: Adding info for No Bus:ircomm14
[   35.642037] device: 'ircomm15': device_add
[   35.642072] PM: Adding info for No Bus:ircomm15
[   35.642177] device: 'ircomm16': device_add
[   35.642221] PM: Adding info for No Bus:ircomm16
[   35.642315] device: 'ircomm17': device_add
[   35.642357] PM: Adding info for No Bus:ircomm17
[   35.642447] device: 'ircomm18': device_add
[   35.642483] PM: Adding info for No Bus:ircomm18
[   35.642581] device: 'ircomm19': device_add
[   35.642616] PM: Adding info for No Bus:ircomm19
[   35.642706] device: 'ircomm20': device_add
[   35.642742] PM: Adding info for No Bus:ircomm20
[   35.642835] device: 'ircomm21': device_add
[   35.642877] PM: Adding info for No Bus:ircomm21
[   35.642975] device: 'ircomm22': device_add
[   35.643011] PM: Adding info for No Bus:ircomm22
[   35.643101] device: 'ircomm23': device_add
[   35.643146] PM: Adding info for No Bus:ircomm23
[   35.643235] device: 'ircomm24': device_add
[   35.643278] PM: Adding info for No Bus:ircomm24
[   35.643384] device: 'ircomm25': device_add
[   35.643420] PM: Adding info for No Bus:ircomm25
[   35.643509] device: 'ircomm26': device_add
[   35.643545] PM: Adding info for No Bus:ircomm26
[   35.643648] device: 'ircomm27': device_add
[   35.643684] PM: Adding info for No Bus:ircomm27
[   35.643783] device: 'ircomm28': device_add
[   35.643825] PM: Adding info for No Bus:ircomm28
[   35.643919] device: 'ircomm29': device_add
[   35.643955] PM: Adding info for No Bus:ircomm29
[   35.644044] device: 'ircomm30': device_add
[   35.644080] PM: Adding info for No Bus:ircomm30
[   35.644188] device: 'ircomm31': device_add
[   35.644225] PM: Adding info for No Bus:ircomm31
[   35.644320] initcall ircomm_tty_init+0x0/0x134 returned 0 after 4 msecs
[   35.644322] calling  l2cap_init+0x0/0xe4
[   35.644349] Bluetooth: L2CAP ver 2.11
[   35.644350] Bluetooth: L2CAP socket layer initialized
[   35.644352] initcall l2cap_init+0x0/0xe4 returned 0 after 0 msecs
[   35.644354] calling  sco_init+0x0/0xea
[   35.644364] Bluetooth: SCO (Voice Link) ver 0.6
[   35.644365] Bluetooth: SCO socket layer initialized
[   35.644367] initcall sco_init+0x0/0xea returned 0 after 0 msecs
[   35.644369] calling  rfcomm_init+0x0/0xbe
[   35.644428] Bluetooth: RFCOMM socket layer initialized
[   35.644441] Bluetooth: RFCOMM TTY layer initialized
[   35.644443] Bluetooth: RFCOMM ver 1.10
[   35.644445] initcall rfcomm_init+0x0/0xbe returned 0 after 0 msecs
[   35.644447] calling  init_sunrpc+0x0/0x5d
[   35.645207] RPC: Registered udp transport module.
[   35.645209] RPC: Registered tcp transport module.
[   35.645213] initcall init_sunrpc+0x0/0x5d returned 0 after 0 msecs
[   35.645215] calling  init_rpcsec_gss+0x0/0x38
[   35.645258] initcall init_rpcsec_gss+0x0/0x38 returned 0 after 0 msecs
[   35.645260] calling  init_kerberos_module+0x0/0x2f
[   35.645286] initcall init_kerberos_module+0x0/0x2f returned 0 after 0 msecs
[   35.645288] calling  init_spkm3_module+0x0/0x2f
[   35.645294] initcall init_spkm3_module+0x0/0x2f returned 0 after 0 msecs
[   35.645296] calling  xprt_rdma_init+0x0/0xbc
[   35.645298] RPC: Registered rdma transport module.
[   35.645302] initcall xprt_rdma_init+0x0/0xbc returned 0 after 0 msecs
[   35.645306] calling  svc_rdma_init+0x0/0x14d
[   35.645635] initcall svc_rdma_init+0x0/0x14d returned 0 after 0 msecs
[   35.645638] calling  af_rxrpc_init+0x0/0x19c
[   35.646048] NET: Registered protocol family 33
[   35.646067] initcall af_rxrpc_init+0x0/0x19c returned 0 after 0 msecs
[   35.646069] calling  rxkad_init+0x0/0x68
[   35.646163] RxRPC: Registered security type 2 'rxkad'
[   35.646165] initcall rxkad_init+0x0/0x68 returned 0 after 0 msecs
[   35.646168] calling  decnet_init+0x0/0x90
[   35.646169] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   35.646697] DECnet: Routing cache hash table of 1024 buckets, 56Kbytes
[   35.646906] NET: Registered protocol family 12
[   35.646920] initcall decnet_init+0x0/0x90 returned 0 after 0 msecs
[   35.646923] calling  dccp_init+0x0/0x395
[   35.650032] initcall dccp_init+0x0/0x395 returned 0 after 2 msecs
[   35.650036] calling  dccp_v4_init+0x0/0x84
[   36.278390] PM: Adding info for No Bus:input0
[   36.282898] input: AT Translated Set 2 keyboard as /class/input/input0
[   36.298917] initcall dccp_v4_init+0x0/0x84 returned 0 after 618 msecs
[   36.305405] calling  dccp_v6_init+0x0/0x84
[   36.310043] initcall dccp_v6_init+0x0/0x84 returned 0 after 0 msecs
[   36.316357] calling  dccp_diag_init+0x0/0x12
[   36.320646] initcall dccp_diag_init+0x0/0x12 returned 0 after 0 msecs
[   36.327133] calling  ccid3_module_init+0x0/0x12
[   36.332000] CCID: Registered CCID 3 (TCP-Friendly Rate Control)
[   36.337936] initcall ccid3_module_init+0x0/0x12<7>evbug.c: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   36.341921] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   36.341923] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   36.363728]  returned 0 after 5 msecs
[   36.367407] calling  ccid2_module_init+0x0/0x12
[   36.372288] CCID: Registered CCID 2 (TCP-like)
[   36.376751] initcall ccid2_module_init+0x0/0x12 returned 0 after 4 msecs
[   36.383498] calling  tfrc_module_init+0x0/0x3a
[   36.388421] initcall tfrc_module_init+0x0/0x3a returned 0 after 0 msecs
[   36.395085] calling  sctp_init+0x0/0x789
[   36.400762] SCTP: Hash tables configured (established 18724 bind 18724)
[   36.442291] initcall sctp_init+0x0/0x789 returned 0 after 41 msecs
[   36.448521] calling  ieee80211_init+0x0/0xb3
[   36.452828] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   36.459454] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   36.467821] initcall ieee80211_init+0x0/0xb3 returned 0 after 14 msecs
[   36.474397] calling  ieee80211_crypto_init+0x0/0x12
[   36.479298] ieee80211_crypt: registered algorithm 'NULL'
[   36.484624] initcall ieee80211_crypto_init+0x0/0x12 returned 0 after 5 msecs
[   36.491718] calling  ieee80211_crypto_wep_init+0x0/0x12
[   36.496956] ieee80211_crypt: registered algorithm 'WEP'
[   36.502197] initcall ieee80211_crypto_wep_init+0x0/0x12 returned 0 after 4 msecs
[   36.509641] calling  ieee80211_crypto_tkip_init+0x0/0x12
[   36.514967] ieee80211_crypt: registered algorithm 'TKIP'
[   36.520293] initcall ieee80211_crypto_tkip_init+0x0/0x12 returned 0 after 5 msecs
[   36.527824] calling  tipc_init+0x0/0xb6
[   36.531683] TIPC: Activated (version 1.6.4 compiled Sep 10 2008 13:51:10)
[   36.539232] NET: Registered protocol family 30
[   36.543696] TIPC: Started in single node mode
[   36.548069] initcall tipc_init+0x0/0xb6 returned 0 after 15 msecs
[   36.554218] calling  hpet_insert_resource+0x0/0x23
[   36.559026] initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 msecs
[   36.566035] calling  update_mp_table+0x0/0x476
[   36.570495] initcall update_mp_table+0x0/0x476 returned 0 after 0 msecs
[   36.577153] calling  lapic_insert_resource+0x0/0x40
[   36.582048] initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
[   36.589139] calling  init_lapic_nmi_sysfs+0x0/0x38
[   36.593945] initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
[   36.600950] calling  ioapic_insert_resources+0x0/0x4f
[   36.606017] initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
[   36.613286] calling  io_apic_bug_finalize+0x0/0x1b
[   36.618095] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 msecs
[   36.625100] calling  check_early_ioremap_leak+0x0/0x3d
[   36.630253] ------------[ cut here ]------------
[   36.634884] WARNING: at arch/x86/mm/ioremap.c:577 check_early_ioremap_leak+0x28/0x3d()
[   36.642811] Debug warning: early ioremap leak of 1 areas detected.
[   36.649003] Pid: 1, comm: swapper Not tainted 2.6.27-rc6-tip-00189-gafeef79-dirty #1
[   36.656758] Call Trace:
[   36.659229]  [<ffffffff8024ad3b>] warn_slowpath+0xae/0xd7
[   36.664643]  [<ffffffff80269872>] ? register_lock_class+0x20/0x2b5
[   36.670836]  [<ffffffff8025cf89>] ? core_kernel_text+0x9/0x44
[   36.676596]  [<ffffffff80270255>] ? __print_symbol+0x32/0x3e
[   36.682268]  [<ffffffff8024ba80>] ? printk+0x6c/0x6e
[   36.687247]  [<ffffffff802506a5>] ? insert_resource+0x38/0x48
[   36.693008]  [<ffffffff802183e1>] ? paravirt_read_tsc+0x17/0x1a
[   36.698939]  [<ffffffff80218451>] ? get_cycles+0x9/0xb
[   36.704092]  [<ffffffff8021845c>] ? read_tsc+0x9/0x1c
[   36.709159]  [<ffffffff802640a0>] ? clocksource_read+0xc/0xe
[   36.714831]  [<ffffffff8026428f>] ? getnstimeofday+0x41/0xa3
[   36.720503]  [<ffffffff802614e9>] ? ktime_set+0x9/0x32
[   36.725656]  [<ffffffff80261584>] ? timespec_to_ktime+0x1a/0x1c
[   36.731589]  [<ffffffff81277f15>] ? check_early_ioremap_leak+0x0/0x3d
[   36.738042]  [<ffffffff81277f3d>] check_early_ioremap_leak+0x28/0x3d
[   36.744408]  [<ffffffff8020a05c>] do_one_initcall+0x4c/0x151
[   36.750082]  [<ffffffff80548f42>] ? __next_cpu_nr+0x22/0x2b
[   36.755669]  [<ffffffff81261a19>] kernel_init+0x1ba/0x22b
[   36.761082]  [<ffffffff80212089>] child_rip+0xa/0x11
[   36.766060]  [<ffffffff8126185f>] ? kernel_init+0x0/0x22b
[   36.771472]  [<ffffffff8021207f>] ? child_rip+0x0/0x11
[   36.776629] ---[ end trace f0f435d790e14276 ]---
[   36.781262] please boot with early_ioremap_debug and report the dmesg.
[   36.787799] initcall check_early_ioremap_leak+0x0/0x3d returned 1 after 150 msecs
[   36.795329] initcall check_early_ioremap_leak+0x0/0x3d returned with error code 1 
[   36.802946] calling  sched_init_debug+0x0/0x24
[   36.807430] initcall sched_init_debug+0x0/0x24 returned 0 after 0 msecs
[   36.814093] calling  init_oops_id+0x0/0x28
[   36.818205] initcall init_oops_id+0x0/0x28 returned 0 after 0 msecs
[   36.824516] calling  disable_boot_consoles+0x0/0x3a
[   36.829409] initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
[   36.836500] calling  pm_qos_power_init+0x0/0x61
[   36.841053] device: 'cpu_dma_latency': device_add
[   36.845981] PM: Adding info for No Bus:cpu_dma_latency
[   36.851226] device: 'network_latency': device_add
[   36.855981] PM: Adding info for No Bus:network_latency
[   36.861219] device: 'network_throughput': device_add
[   36.866225] PM: Adding info for No Bus:network_throughput
[   36.871721] initcall pm_qos_power_init+0x0/0x61 returned 0 after 29 msecs
[   36.878556] calling  taskstats_init+0x0/0x95
[   36.882858] registered taskstats version 1
[   36.886971] initcall taskstats_init+0x0/0x95 returned 0 after 3 msecs
[   36.893456] calling  random32_reseed+0x0/0x9e
[   36.897841] initcall random32_reseed+0x0/0x9e returned 0 after 0 msecs
[   36.904412] calling  pci_sysfs_init+0x0/0x4c
[   36.908953] initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
[   36.915441] calling  acpi_wakeup_device_init+0x0/0xb1
[   36.920522] initcall acpi_wakeup_device_init+0x0/0xb1 returned 0 after 0 msecs
[   36.927793] calling  acpi_sleep_proc_init+0x0/0x9b
[   36.932637] initcall acpi_sleep_proc_init+0x0/0x9b returned 0 after 0 msecs
[   36.939643] calling  boot_wait_for_devices+0x0/0x19
[   36.944535] initcall boot_wait_for_devices+0x0/0x19 returned 0 after 0 msecs
[   36.951628] calling  seqgen_init+0x0/0xf
[   36.955574] initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
[   36.961715] calling  scsi_complete_async_scans+0x0/0x11c
[   36.967042] initcall scsi_complete_async_scans+0x0/0x11c returned 0 after 0 msecs
[   36.974573] calling  rtc_hctosys+0x0/0x176
[   36.978686] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   36.984964] initcall rtc_hctosys+0x0/0x176 returned -19 after 5 msecs
[   36.991454] calling  memmap_init+0x0/0xa3
[   36.995570] initcall memmap_init+0x0/0xa3 returned 0 after 0 msecs
[   37.001796] calling  pci_mmcfg_late_insert_resources+0x0/0x159
[   37.007650] initcall pci_mmcfg_late_insert_resources+0x0/0x159 returned 0 after 0 msecs
[   37.015701] calling  tcp_congestion_default+0x0/0x12
[   37.020680] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
[   37.027911] driver_probe_done: probe_count = 0
[   37.061138] kjournald starting.  Commit interval 5 seconds
[   37.066655] EXT3-fs: mounted filesystem with ordered data mode.
[   37.072609] VFS: Mounted root (ext3 filesystem) readonly.
[   37.078053] debug: unmapping init memory ffffffff81261000..ffffffff813d0000
[   37.085180] Write protecting the kernel read-only data: 14808k
[   37.116453] device: 'vcs1': device_add
[   37.116530] PM: Adding info for No Bus:vcs1
[   37.131526] device: 'vcsa1': device_add
[   37.131586] PM: Adding info for No Bus:vcsa1
[   37.382360] device: 'vcs1': device_unregister
[   37.382363] PM: Removing info for No Bus:vcs1
[   37.382555] device: 'vcs1': device_create_release
[   37.382561] device: 'vcsa1': device_unregister
[   37.382562] PM: Removing info for No Bus:vcsa1
[   37.382675] device: 'vcsa1': device_create_release
[   37.409898] device: 'vcs1': device_add
[   37.409931] PM: Adding info for No Bus:vcs1
[   37.410023] device: 'vcsa1': device_add
[   37.410048] PM: Adding info for No Bus:vcsa1
[   37.426250] device: 'vcs1': device_unregister
[   37.426251] PM: Removing info for No Bus:vcs1
[   37.426366] device: 'vcs1': device_create_release
[   37.426371] device: 'vcsa1': device_unregister
[   37.426372] PM: Removing info for No Bus:vcsa1
[   37.426482] device: 'vcsa1': device_create_release
[   37.476855] device: 'vcs1': device_add
[   37.476904] PM: Adding info for No Bus:vcs1
[   37.477047] device: 'vcsa1': device_add
[   37.477072] PM: Adding info for No Bus:vcsa1
[   37.493301] device: 'vcs1': device_unregister
[   37.493302] PM: Removing info for No Bus:vcs1
[   37.493417] device: 'vcs1': device_create_release
[   37.493421] device: 'vcsa1': device_unregister
[   37.493422] PM: Removing info for No Bus:vcsa1
[   37.493533] device: 'vcsa1': device_create_release
[   37.520749] device: 'vcs1': device_add
[   37.520775] PM: Adding info for No Bus:vcs1
[   37.520864] device: 'vcsa1': device_add
[   37.520889] PM: Adding info for No Bus:vcsa1
[   37.537141] device: 'vcs1': device_unregister
[   37.537142] PM: Removing info for No Bus:vcs1
[   37.537255] device: 'vcs1': device_create_release
[   37.537260] device: 'vcsa1': device_unregister
[   37.537261] PM: Removing info for No Bus:vcsa1
[   37.537371] device: 'vcsa1': device_create_release
[   37.564585] device: 'vcs1': device_add
[   37.564611] PM: Adding info for No Bus:vcs1
[   37.564700] device: 'vcsa1': device_add
[   37.564725] PM: Adding info for No Bus:vcsa1
[   37.580979] device: 'vcs1': device_unregister
[   37.580980] PM: Removing info for No Bus:vcs1
[   37.581092] device: 'vcs1': device_create_release
[   37.581096] device: 'vcsa1': device_unregister
[   37.581097] PM: Removing info for No Bus:vcsa1
[   37.581208] device: 'vcsa1': device_create_release
[   37.630420] device: 'vcs1': device_add
[   37.630454] PM: Adding info for No Bus:vcs1
[   37.630548] device: 'vcsa1': device_add
[   37.630574] PM: Adding info for No Bus:vcsa1
[   39.536960] device: 'device:00': dev_uevent: bus uevent() returned -12
[   39.543714] device: 'device:01': dev_uevent: bus uevent() returned -12
[   39.551307] device: 'device:02': dev_uevent: bus uevent() returned -12
[   39.558957] device: 'device:03': dev_uevent: bus uevent() returned -12
[   39.566059] device: 'device:04': dev_uevent: bus uevent() returned -12
[   39.572649] device: 'device:05': dev_uevent: bus uevent() returned -12
[   39.579250] device: 'device:06': dev_uevent: bus uevent() returned -12
[   39.586251] device: 'device:07': dev_uevent: bus uevent() returned -12
[   39.592880] device: 'device:08': dev_uevent: bus uevent() returned -12
[   39.600030] device: 'device:09': dev_uevent: bus uevent() returned -12
[   39.606621] device: 'device:0a': dev_uevent: bus uevent() returned -12
[   39.613214] device: 'device:0b': dev_uevent: bus uevent() returned -12
[   39.620202] device: 'device:0c': dev_uevent: bus uevent() returned -12
[   39.626795] device: 'device:0d': dev_uevent: bus uevent() returned -12
[   39.633910] device: 'device:0e': dev_uevent: bus uevent() returned -12
[   39.640500] device: 'device:0f': dev_uevent: bus uevent() returned -12
[   39.647097] device: 'device:10': dev_uevent: bus uevent() returned -12
[   39.654075] device: 'device:11': dev_uevent: bus uevent() returned -12
[   39.660666] device: 'device:12': dev_uevent: bus uevent() returned -12
[   39.667772] device: 'device:13': dev_uevent: bus uevent() returned -12
[   39.674361] device: 'device:14': dev_uevent: bus uevent() returned -12
[   39.680958] device: 'device:15': dev_uevent: bus uevent() returned -12
[   39.687951] device: 'device:16': dev_uevent: bus uevent() returned -12
[   39.694542] device: 'device:17': dev_uevent: bus uevent() returned -12
[   39.701650] device: 'device:18': dev_uevent: bus uevent() returned -12
[   39.708241] device: 'device:19': dev_uevent: bus uevent() returned -12
[   39.714838] device: 'device:1a': dev_uevent: bus uevent() returned -12
[   39.722708] usb usb1: uevent
[   39.725662] usb 1-0:1.0: uevent
[   39.728949] usb usb2: uevent
[   39.731906] usb 2-0:1.0: uevent
[   39.735134] usb usb3: uevent
[   39.738087] usb 3-0:1.0: uevent
[   39.742168] usb usb4: uevent
[   39.745122] usb 4-0:1.0: uevent
[   39.748352] usb usb5: uevent
[   39.751821] usb 5-0:1.0: uevent
[   44.179107] EXT3 FS on sda1, internal journal
[   44.281452] kjournald starting.  Commit interval 5 seconds
[   44.281685] EXT3 FS on sdb1, internal journal
[   44.281689] EXT3-fs: mounted filesystem with ordered data mode.
[   44.938966] Adding 8193140k swap on /dev/sda2.  Priority:-1 extents:1 across:8193140k
[   45.058680] device: 'vcs1': device_unregister
[   45.058682] PM: Removing info for No Bus:vcs1
[   45.058852] device: 'vcs1': device_create_release
[   45.058860] device: 'vcsa1': device_unregister
[   45.058861] PM: Removing info for No Bus:vcsa1
[   45.058920] device: 'vcsa1': device_create_release
[   45.112959] device: 'vcs1': device_add
[   45.113057] PM: Adding info for No Bus:vcs1
[   45.113086] device: 'vcsa1': device_add
[   45.113111] PM: Adding info for No Bus:vcsa1
[   45.129777] device: 'vcs1': device_unregister
[   45.129779] PM: Removing info for No Bus:vcs1
[   45.129832] device: 'vcs1': device_create_release
[   45.129837] device: 'vcsa1': device_unregister
[   45.129838] PM: Removing info for No Bus:vcsa1
[   45.129885] device: 'vcsa1': device_create_release
[   45.157654] device: 'vcs1': device_add
[   45.157684] PM: Adding info for No Bus:vcs1
[   45.157707] device: 'vcsa1': device_add
[   45.157733] PM: Adding info for No Bus:vcsa1
[   45.174232] device: 'vcs1': device_unregister
[   45.174233] PM: Removing info for No Bus:vcs1
[   45.174288] device: 'vcs1': device_create_release
[   45.174293] device: 'vcsa1': device_unregister
[   45.174294] PM: Removing info for No Bus:vcsa1
[   45.174341] device: 'vcsa1': device_create_release
[   45.201860] device: 'vcs1': device_add
[   45.201896] PM: Adding info for No Bus:vcs1
[   45.201920] device: 'vcsa1': device_add
[   45.201945] PM: Adding info for No Bus:vcsa1
[   45.218444] device: 'vcs1': device_unregister
[   45.218446] PM: Removing info for No Bus:vcs1
[   45.218502] device: 'vcs1': device_create_release
[   45.218506] device: 'vcsa1': device_unregister
[   45.218508] PM: Removing info for No Bus:vcsa1
[   45.218554] device: 'vcsa1': device_create_release
[   45.246967] device: 'vcs1': device_add
[   45.247009] PM: Adding info for No Bus:vcs1
[   45.247031] device: 'vcsa1': device_add
[   45.247057] PM: Adding info for No Bus:vcsa1
[   46.233159] device: 'bpq0': device_add
[   46.237028] PM: Adding info for No Bus:bpq0
[   46.241336] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   49.136944] 0000:04:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   49.145241] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
