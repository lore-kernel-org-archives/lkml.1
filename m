Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZBPWt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZBPWt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZBPWtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:49:20 -0500
Received: from gw.goop.org ([64.81.55.164]:37771 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZBPWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:49:17 -0500
Message-ID: <4999ED6A.8000803@goop.org>
Date: Mon, 16 Feb 2009 14:49:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: (spurious?) lockdep warning on Xen boot
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing this warning appear early when I boot under Xen:

------------[ cut here ]------------
WARNING: at /home/jeremy/git/linux/kernel/lockdep.c:2185 trace_hardirqs_on_caller+0xbc/0x13c()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-rc4-tip #12
Call Trace:
 [<ffffffff8023da44>] warn_slowpath+0xd8/0x114
 [<ffffffff8020e9f9>] ? __raw_callee_save_xen_save_fl+0x11/0x1e
 [<ffffffff8020b882>] ? xen_mc_flush+0x1e2/0x21b
 [<ffffffff8025d424>] ? trace_hardirqs_off_caller+0x2e/0x8c
 [<ffffffff8025e26b>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80705c2c>] ? xen_setup_kernel_pagetable+0x442/0x4a4
 [<ffffffff8025f9d5>] trace_hardirqs_on_caller+0xbc/0x13c
 [<ffffffff8025fa62>] trace_hardirqs_on+0xd/0xf
 [<ffffffff80705c2c>] xen_setup_kernel_pagetable+0x442/0x4a4
 [<ffffffff80704d91>] xen_start_kernel+0x34e/0x4da
---[ end trace 4eaa2a86a8e2da22 ]---


Which corresponds to:

	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
		return;


The code in question is running before start_kernel, and ends up doing 
some local_irq_save(flags)/local_irq_restore(flags) calls, which result 
in interrupts being re-enabled.

I tried two approaches to fixing this.  One was to disable interrupts 
early, before calling anything that would try to change the interrupt 
state (which seems sane, since I guess head.S enters the kernel with 
interrupts disabled), and the other was to call early_boot_irqs_on() to 
suppress the warning.

Both cleared up the quoted warning, but then I got a huge lump of 
lockdep spew which seemed to be as a result of an interaction between 
usb and swiotlb via Xen (quoted below).  I'm not sure if this is a real 
report, or fallout from something going wrong in the early init stages 
of lockdep.

Or perhaps the second warning is real; in which case, where does the 
problem lie? (I guess another case of being bitten by calling 
__purge_vmap_area_lazy from interrupt context.)  And if this second 
warning is real, why does it get suppressed by the first warning?

Clues?

Thanks,
    J

/home/jeremy/git/linux/drivers/usb/core/inode.c: creating file '001'
xen: registering gsi 18 triggering 0 polarity 1
usb 1-3: new high speed USB device using ehci_hcd and address 2

======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
2.6.29-rc5-tip #22
------------------------------------------------------
khubd/158 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&retval->lock){......}, at: [<ffffffff802a89b8>] dma_pool_alloc+0x30/0x29d

and this task is already holding:
 (&ehci->lock){-.....}, at: [<ffffffff80464ba4>] ehci_urb_enqueue+0xab/0xe96
which would create a new lock dependency:
 (&ehci->lock){-.....} -> (&retval->lock){......}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&ehci->lock){-.....}
... which became HARDIRQ-irq-safe at:
  [<ffffffffffffffff>] 0xffffffffffffffff

to a HARDIRQ-irq-unsafe lock:
 (purge_lock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff80262dd9>] __lock_acquire+0x77d/0x16d9
  [<ffffffff80263d96>] lock_acquire+0x61/0x84
  [<ffffffff8053092c>] _spin_lock+0x31/0x3d
  [<ffffffff802a2c62>] __purge_vmap_area_lazy+0x50/0x1a8
  [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
  [<ffffffff8020d1fa>] xen_create_contiguous_region+0x49/0xef
  [<ffffffff803d867b>] xen_swiotlb_fixup+0x97/0xd0
  [<ffffffff80716637>] swiotlb_alloc_boot+0x3e/0x49
  [<ffffffff8071fe3e>] swiotlb_init_with_default_size+0x3c/0x120
  [<ffffffff8071ff30>] swiotlb_init+0xe/0x10
  [<ffffffff807165ec>] pci_swiotlb_init+0x6f/0x7c
  [<ffffffff8070d4f5>] pci_iommu_alloc+0x59/0x5d
  [<ffffffff807179d8>] mem_init+0xd/0xb7
  [<ffffffff80705cb5>] start_kernel+0x3c0/0x452
  [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
  [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
  [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by khubd/158:
 #0:  (usb_address0_mutex){+.+...}, at: [<ffffffff8044b51c>] hub_port_init+0x83/0x617
 #1:  (&ehci->lock){-.....}, at: [<ffffffff80464ba4>] ehci_urb_enqueue+0xab/0xe96

the HARDIRQ-irq-safe lock's dependencies:
-> (&ehci->lock){-.....} ops: 0 {
   IN-HARDIRQ-W at:
                        [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff80ecb800>] __key.31741+0x0/0x8
 -> (hcd_urb_list_lock){......} ops: 0 {
    INITIAL USE at:
                         [<ffffffff80262e6b>] __lock_acquire+0x80f/0x16d9
                         [<ffffffff80263d96>] lock_acquire+0x61/0x84
                         [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                         [<ffffffff8044f3d7>] usb_hcd_link_urb_to_ep+0x28/0xab
                         [<ffffffff804506bb>] usb_hcd_submit_urb+0x460/0xa8a
                         [<ffffffff80451333>] usb_submit_urb+0x2f8/0x315
                         [<ffffffff80452568>] usb_start_wait_urb+0x56/0x17b
                         [<ffffffff80452893>] usb_control_msg+0xd4/0xf6
                         [<ffffffff804537b8>] usb_get_descriptor+0x76/0xa6
                         [<ffffffff80453841>] usb_get_device_descriptor+0x59/0x88
                         [<ffffffff804500ae>] usb_add_hcd+0x4ad/0x64a
                         [<ffffffff8045b347>] usb_hcd_pci_probe+0x25c/0x30d
                         [<ffffffff803d3935>] local_pci_probe+0x17/0x1b
                         [<ffffffff803d406d>] pci_device_probe+0x61/0x8b
                         [<ffffffff80440e0e>] driver_probe_device+0xc9/0x177
                         [<ffffffff80440f23>] __driver_attach+0x67/0x91
                         [<ffffffff8044065f>] bus_for_each_dev+0x57/0x91
                         [<ffffffff80440c46>] driver_attach+0x21/0x23
                         [<ffffffff8043ff33>] bus_add_driver+0xbf/0x20c
                         [<ffffffff8044113a>] driver_register+0xb0/0x130
                         [<ffffffff803d4328>] __pci_register_driver+0x68/0xa0
                         [<ffffffff80725d66>] ehci_hcd_init+0xb8/0xe3
                         [<ffffffff8020a066>] do_one_initcall+0x5b/0x13e
                         [<ffffffff80705659>] kernel_init+0x134/0x18c
                         [<ffffffff8021360a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff806b32d8>] hcd_urb_list_lock+0x18/0x30
 ... acquired at:
   [<ffffffff802639b0>] __lock_acquire+0x1354/0x16d9
   [<ffffffff80263d96>] lock_acquire+0x61/0x84
   [<ffffffff8053092c>] _spin_lock+0x31/0x3d
   [<ffffffff8044f3d7>] usb_hcd_link_urb_to_ep+0x28/0xab
   [<ffffffff80464bcd>] ehci_urb_enqueue+0xd4/0xe96
   [<ffffffff80450c0b>] usb_hcd_submit_urb+0x9b0/0xa8a
   [<ffffffff80451333>] usb_submit_urb+0x2f8/0x315
   [<ffffffff80452568>] usb_start_wait_urb+0x56/0x17b
   [<ffffffff80452893>] usb_control_msg+0xd4/0xf6
   [<ffffffff8044b730>] hub_port_init+0x297/0x617
   [<ffffffff8044e0f8>] hub_thread+0xae5/0x1295
   [<ffffffff802540e2>] kthread+0x4e/0x7b
   [<ffffffff8021360a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff


the HARDIRQ-irq-unsafe lock's dependencies:
-> (purge_lock){+.+...} ops: 0 {
   HARDIRQ-ON-W at:
                        [<ffffffff80262dd9>] __lock_acquire+0x77d/0x16d9
                        [<ffffffff80263d96>] lock_acquire+0x61/0x84
                        [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                        [<ffffffff802a2c62>] __purge_vmap_area_lazy+0x50/0x1a8
                        [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
                        [<ffffffff8020d1fa>] xen_create_contiguous_region+0x49/0xef
                        [<ffffffff803d867b>] xen_swiotlb_fixup+0x97/0xd0
                        [<ffffffff80716637>] swiotlb_alloc_boot+0x3e/0x49
                        [<ffffffff8071fe3e>] swiotlb_init_with_default_size+0x3c/0x120
                        [<ffffffff8071ff30>] swiotlb_init+0xe/0x10
                        [<ffffffff807165ec>] pci_swiotlb_init+0x6f/0x7c
                        [<ffffffff8070d4f5>] pci_iommu_alloc+0x59/0x5d
                        [<ffffffff807179d8>] mem_init+0xd/0xb7
                        [<ffffffff80705cb5>] start_kernel+0x3c0/0x452
                        [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                        [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                        [<ffffffffffffffff>] 0xffffffffffffffff
   SOFTIRQ-ON-W at:
                        [<ffffffff80262e02>] __lock_acquire+0x7a6/0x16d9
                        [<ffffffff80263d96>] lock_acquire+0x61/0x84
                        [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                        [<ffffffff802a2c62>] __purge_vmap_area_lazy+0x50/0x1a8
                        [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
                        [<ffffffff8020d1fa>] xen_create_contiguous_region+0x49/0xef
                        [<ffffffff803d867b>] xen_swiotlb_fixup+0x97/0xd0
                        [<ffffffff80716637>] swiotlb_alloc_boot+0x3e/0x49
                        [<ffffffff8071fe3e>] swiotlb_init_with_default_size+0x3c/0x120
                        [<ffffffff8071ff30>] swiotlb_init+0xe/0x10
                        [<ffffffff807165ec>] pci_swiotlb_init+0x6f/0x7c
                        [<ffffffff8070d4f5>] pci_iommu_alloc+0x59/0x5d
                        [<ffffffff807179d8>] mem_init+0xd/0xb7
                        [<ffffffff80705cb5>] start_kernel+0x3c0/0x452
                        [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                        [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                        [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffff80262e6b>] __lock_acquire+0x80f/0x16d9
                       [<ffffffff80263d96>] lock_acquire+0x61/0x84
                       [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                       [<ffffffff802a2c62>] __purge_vmap_area_lazy+0x50/0x1a8
                       [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
                       [<ffffffff8020d1fa>] xen_create_contiguous_region+0x49/0xef
                       [<ffffffff803d867b>] xen_swiotlb_fixup+0x97/0xd0
                       [<ffffffff80716637>] swiotlb_alloc_boot+0x3e/0x49
                       [<ffffffff8071fe3e>] swiotlb_init_with_default_size+0x3c/0x120
                       [<ffffffff8071ff30>] swiotlb_init+0xe/0x10
                       [<ffffffff807165ec>] pci_swiotlb_init+0x6f/0x7c
                       [<ffffffff8070d4f5>] pci_iommu_alloc+0x59/0x5d
                       [<ffffffff807179d8>] mem_init+0xd/0xb7
                       [<ffffffff80705cb5>] start_kernel+0x3c0/0x452
                       [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                       [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff806962b8>] purge_lock.24514+0x18/0x30
 -> (vmap_area_lock){+.+...} ops: 0 {
    HARDIRQ-ON-W at:
                          [<ffffffff80262dd9>] __lock_acquire+0x77d/0x16d9
                          [<ffffffff80263d96>] lock_acquire+0x61/0x84
                          [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                          [<ffffffff802a2f25>] alloc_vmap_area+0x99/0x1ca
                          [<ffffffff802a3133>] __get_vm_area_node+0xdd/0x18d
                          [<ffffffff802a324d>] get_vm_area_caller+0x34/0x36
                          [<ffffffff802a3bee>] vmap+0x36/0x66
                          [<ffffffff8021819e>] text_poke+0x11c/0x1b2
                          [<ffffffff80218283>] alternatives_smp_unlock+0x4f/0x67
                          [<ffffffff80218514>] alternatives_smp_switch+0x15f/0x19e
                          [<ffffffff8070d71b>] alternative_instructions+0xf2/0x131
                          [<ffffffff8070df1f>] check_bugs+0xe/0x2d
                          [<ffffffff80705d2b>] start_kernel+0x436/0x452
                          [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                          [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                          [<ffffffffffffffff>] 0xffffffffffffffff
    SOFTIRQ-ON-W at:
                          [<ffffffff80262e02>] __lock_acquire+0x7a6/0x16d9
                          [<ffffffff80263d96>] lock_acquire+0x61/0x84
                          [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                          [<ffffffff802a2f25>] alloc_vmap_area+0x99/0x1ca
                          [<ffffffff802a3133>] __get_vm_area_node+0xdd/0x18d
                          [<ffffffff802a324d>] get_vm_area_caller+0x34/0x36
                          [<ffffffff802a3bee>] vmap+0x36/0x66
                          [<ffffffff8021819e>] text_poke+0x11c/0x1b2
                          [<ffffffff80218283>] alternatives_smp_unlock+0x4f/0x67
                          [<ffffffff80218514>] alternatives_smp_switch+0x15f/0x19e
                          [<ffffffff8070d71b>] alternative_instructions+0xf2/0x131
                          [<ffffffff8070df1f>] check_bugs+0xe/0x2d
                          [<ffffffff80705d2b>] start_kernel+0x436/0x452
                          [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                          [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80262e6b>] __lock_acquire+0x80f/0x16d9
                         [<ffffffff80263d96>] lock_acquire+0x61/0x84
                         [<ffffffff8053092c>] _spin_lock+0x31/0x3d
                         [<ffffffff802a2f25>] alloc_vmap_area+0x99/0x1ca
                         [<ffffffff802a3133>] __get_vm_area_node+0xdd/0x18d
                         [<ffffffff802a324d>] get_vm_area_caller+0x34/0x36
                         [<ffffffff802a3bee>] vmap+0x36/0x66
                         [<ffffffff8021819e>] text_poke+0x11c/0x1b2
                         [<ffffffff80218283>] alternatives_smp_unlock+0x4f/0x67
                         [<ffffffff80218514>] alternatives_smp_switch+0x15f/0x19e
                         [<ffffffff8070d71b>] alternative_instructions+0xf2/0x131
                         [<ffffffff8070df1f>] check_bugs+0xe/0x2d
                         [<ffffffff80705d2b>] start_kernel+0x436/0x452
                         [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
                         [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80696278>] vmap_area_lock+0x18/0x30
 ... acquired at:
   [<ffffffff802639b0>] __lock_acquire+0x1354/0x16d9
   [<ffffffff80263d96>] lock_acquire+0x61/0x84
   [<ffffffff8053092c>] _spin_lock+0x31/0x3d
   [<ffffffff802a2d69>] __purge_vmap_area_lazy+0x157/0x1a8
   [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
   [<ffffffff8020e190>] xen_alloc_ptpage+0xa8/0xd9
   [<ffffffff8020e1fe>] xen_alloc_pte+0x13/0x15
   [<ffffffff8029947c>] __pte_alloc_kernel+0x5b/0xb1
   [<ffffffff802a36f5>] vmap_page_range+0x19b/0x30f
   [<ffffffff802a389b>] map_vm_area+0x32/0x46
   [<ffffffff802a3c05>] vmap+0x4d/0x66
   [<ffffffff8021819e>] text_poke+0x11c/0x1b2
   [<ffffffff80218283>] alternatives_smp_unlock+0x4f/0x67
   [<ffffffff80218514>] alternatives_smp_switch+0x15f/0x19e
   [<ffffffff8070d71b>] alternative_instructions+0xf2/0x131
   [<ffffffff8070df1f>] check_bugs+0xe/0x2d
   [<ffffffff80705d2b>] start_kernel+0x436/0x452
   [<ffffffff807052bf>] x86_64_start_reservations+0xaa/0xae
   [<ffffffff80708f27>] xen_start_kernel+0x4e4/0x4eb
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&q->lock#2){-.....} ops: 0 {
    IN-HARDIRQ-W at:
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff80262e6b>] __lock_acquire+0x80f/0x16d9
                         [<ffffffff80263d96>] lock_acquire+0x61/0x84
                         [<ffffffff80530a0a>] _spin_lock_irqsave+0x47/0x5b
                         [<ffffffff80268591>] generic_exec_single+0x41/0x8f
                         [<ffffffff80268735>] smp_call_function_single+0x10e/0x127
                         [<ffffffff80268813>] smp_call_function_many+0xc5/0x1f8
                         [<ffffffff8026896b>] smp_call_function+0x25/0x29
                         [<ffffffff80244ee0>] on_each_cpu+0x1d/0x48
                         [<ffffffff802ada09>] kmem_cache_shrink+0x5a/0x1c8
                         [<ffffffff803dc219>] acpi_os_purge_cache+0xe/0x12
                         [<ffffffff803f4ac5>] acpi_purge_cached_objects+0x15/0x3d
                         [<ffffffff803f4b55>] acpi_initialize_objects+0x4e/0x59
                         [<ffffffff80721660>] acpi_init+0x91/0x234
                         [<ffffffff8020a066>] do_one_initcall+0x5b/0x13e
                         [<ffffffff80705659>] kernel_init+0x134/0x18c
                         [<ffffffff8021360a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff80e72e60>] __key.12205+0x0/0x8
 ... acquired at:
   [<ffffffff802639b0>] __lock_acquire+0x1354/0x16d9
   [<ffffffff80263d96>] lock_acquire+0x61/0x84
   [<ffffffff80530a0a>] _spin_lock_irqsave+0x47/0x5b
   [<ffffffff80268591>] generic_exec_single+0x41/0x8f
   [<ffffffff80268735>] smp_call_function_single+0x10e/0x127
   [<ffffffff80268813>] smp_call_function_many+0xc5/0x1f8
   [<ffffffff8026896b>] smp_call_function+0x25/0x29
   [<ffffffff80244ee0>] on_each_cpu+0x1d/0x48
   [<ffffffff80230f58>] flush_tlb_all+0x1c/0x1e
   [<ffffffff802a2d54>] __purge_vmap_area_lazy+0x142/0x1a8
   [<ffffffff802a4485>] vm_unmap_aliases+0x1a9/0x1b8
   [<ffffffff8020d83d>] __xen_pgd_pin+0x1d/0x19d
   [<ffffffff8020da1e>] xen_activate_mm+0x2a/0x37
   [<ffffffff802b4c88>] flush_old_exec+0x32d/0x72c
   [<ffffffff802e7853>] load_elf_binary+0x397/0x1940
   [<ffffffff802b473a>] search_binary_handler+0xbc/0x261
   [<ffffffff802b594a>] do_execve+0x1b9/0x269
   [<ffffffff80210a14>] sys_execve+0x43/0x65
   [<ffffffff80213688>] kernel_execve+0x68/0xd0
   [<ffffffff8021360a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 158, comm: khubd Not tainted 2.6.29-rc5-tip #22
Call Trace:
 [<ffffffff80262586>] check_usage+0x3d6/0x3e7
 [<ffffffff802620ab>] ? check_noncircular+0xe8/0x11d
 [<ffffffff802625f8>] check_irq_usage+0x61/0xc5
 [<ffffffff802636ea>] __lock_acquire+0x108e/0x16d9
 [<ffffffff802165fe>] ? print_context_stack+0xf8/0x116
 [<ffffffff8021577e>] ? dump_trace+0x265/0x277
 [<ffffffff80263d96>] lock_acquire+0x61/0x84
 [<ffffffff802a89b8>] ? dma_pool_alloc+0x30/0x29d
 [<ffffffff80530a0a>] _spin_lock_irqsave+0x47/0x5b
 [<ffffffff802a89b8>] ? dma_pool_alloc+0x30/0x29d
 [<ffffffff802a89b8>] dma_pool_alloc+0x30/0x29d
 [<ffffffff80263c52>] ? __lock_acquire+0x15f6/0x16d9
 [<ffffffff80263c52>] ? __lock_acquire+0x15f6/0x16d9
 [<ffffffff80464163>] ehci_qh_alloc+0x28/0xbd
 [<ffffffff8020f132>] ? check_events+0x12/0x20
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff80464237>] qh_append_tds+0x3f/0x581
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff8026426b>] ? lock_release+0x164/0x171
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff8044f3d7>] ? usb_hcd_link_urb_to_ep+0x28/0xab
 [<ffffffff80464bf2>] ehci_urb_enqueue+0xf9/0xe96
 [<ffffffff803c218f>] ? string+0x3d/0xa1
 [<ffffffff803c2ac9>] ? vsnprintf+0x8d6/0x930
 [<ffffffff8021577e>] ? dump_trace+0x265/0x277
 [<ffffffff803d82b0>] ? xen_range_needs_mapping+0xe/0x10
 [<ffffffff80229918>] ? swiotlb_arch_range_needs_mapping+0x19/0x1b
 [<ffffffff80450c0b>] usb_hcd_submit_urb+0x9b0/0xa8a
 [<ffffffff8020ea4d>] ? xen_force_evtchn_callback+0xd/0xf
 [<ffffffff803cd8e3>] ? swiotlb_map_page+0x0/0x1a1
 [<ffffffff8026026a>] ? lockdep_init_map+0x92/0x529
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff80261ab2>] ? debug_check_no_locks_freed+0x13a/0x147
 [<ffffffff80451333>] usb_submit_urb+0x2f8/0x315
 [<ffffffff80452568>] usb_start_wait_urb+0x56/0x17b
 [<ffffffff8020f132>] ? check_events+0x12/0x20
 [<ffffffff80451710>] ? usb_init_urb+0x27/0x37
 [<ffffffff80452893>] usb_control_msg+0xd4/0xf6
 [<ffffffff802ac4af>] ? kmem_cache_alloc+0xc1/0xe5
 [<ffffffff8044b730>] hub_port_init+0x297/0x617
 [<ffffffff8044e0f8>] hub_thread+0xae5/0x1295
 [<ffffffff80261976>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff802544b6>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff805307ef>] ? _spin_unlock_irqrestore+0x53/0x58
 [<ffffffff8044d613>] ? hub_thread+0x0/0x1295
 [<ffffffff8044d613>] ? hub_thread+0x0/0x1295
 [<ffffffff802540e2>] kthread+0x4e/0x7b
 [<ffffffff8021360a>] child_rip+0xa/0x20
 [<ffffffff80212fd0>] ? restore_args+0x0/0x30
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff8020f11f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff80213600>] ? child_rip+0x0/0x20


