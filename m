Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYDRUWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYDRUWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYDRUWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:22:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYDRUWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:22:33 -0400
Message-ID: <48090307.6070003@redhat.com>
Date: Fri, 18 Apr 2008 16:22:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>
Subject: Huge lockdep trace then system freeze after docking laptop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=441622

... on a Thinkpad X41T when docking a running laptop.

======================================================
[ INFO: hard-safe -> hard-unsafe lock order detected ]
2.6.25-0.195.rc8.git1.fc9.i686 #1
------------------------------------------------------
kacpi_notify/64 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (sequence_lock){--..}, at: [kobject_uevent_env+379/867]
kobject_uevent_env+0x17b/0x363

and this task is already holding:
 (&host->lock){++..}, at: [<e01cd052>] ata_acpi_handle_hotplug+0x34/0x1b9 [libata]
which would create a new lock dependency:
 (&host->lock){++..} -> (sequence_lock){--..}

but this new dependency connects a hard-irq-safe lock:
 (&host->lock){++..}
... which became hard-irq-safe at:
  [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
  [lock_acquire+106/144] lock_acquire+0x6a/0x90
  [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
  [<e01bf5d6>] ata_interrupt+0x13/0x1df [libata]
  [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
  [handle_edge_irq+200/265] handle_edge_irq+0xc8/0x109
  [do_IRQ+152/197] do_IRQ+0x98/0xc5
  [<ffffffff>] 0xffffffff

to a hard-irq-unsafe lock:
 (sequence_lock){--..}
... which became hard-irq-unsafe at:
...  [__lock_acquire+1314/3089] __lock_acquire+0x522/0xc11
  [lock_acquire+106/144] lock_acquire+0x6a/0x90
  [_spin_lock+28/73] _spin_lock+0x1c/0x49
  [kobject_uevent_env+379/867] kobject_uevent_env+0x17b/0x363
  [kobject_uevent+10/12] kobject_uevent+0xa/0xc
  [kset_register+46/52] kset_register+0x2e/0x34
  [bus_register+142/476] bus_register+0x8e/0x1dc
  [platform_bus_init+30/51] platform_bus_init+0x1e/0x33
  [driver_init+28/40] driver_init+0x1c/0x28
  [kernel_init+333/755] kernel_init+0x14d/0x2f3
  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff

other info that might help us debug this:

4 locks held by kacpi_notify/64:
 #0:  (kacpi_notify){--..}, at: [run_workqueue+145/417] run_workqueue+0x91/0x1a1
 #1:  (&dpc->work){--..}, at: [run_workqueue+145/417] run_workqueue+0x91/0x1a1
 #2:  (&dock_station->hp_lock){--..}, at: [hotplug_dock_devices+27/227]
hotplug_dock_devices+0x1b/0xe3
 #3:  (&host->lock){++..}, at: [<e01cd052>] ata_acpi_handle_hotplug+0x34/0x1b9
[libata]

the hard-irq-safe lock's dependencies:
-> (&host->lock){++..} ops: 0 {
   initial-use  at:
                        [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                        [lock_acquire+106/144] lock_acquire+0x6a/0x90
                        [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                        [<e01bcfc0>] ata_dev_init+0x24/0x68 [libata]
                        [<e01bd05a>] ata_link_init+0x56/0x81 [libata]
                        [<e01bd8fa>] ata_port_alloc+0x174/0x180 [libata]
                        [<e01bd983>] ata_host_alloc+0x7d/0xae [libata]
                        [<e01bd9c7>] ata_host_alloc_pinfo+0x13/0x96 [libata]
                        [<e01c7131>] ata_pci_prepare_sff_host+0x3b/0xaf [libata]
                        [<e00cdc69>] piix_init_one+0x232/0x579 [ata_piix]
                        [pci_device_probe+57/89] pci_device_probe+0x39/0x59
                        [driver_probe_device+160/316] driver_probe_device+0xa0/0x13c
                        [__driver_attach+124/181] __driver_attach+0x7c/0xb5
                        [bus_for_each_dev+62/104] bus_for_each_dev+0x3e/0x68
                        [driver_attach+20/22] driver_attach+0x14/0x16
                        [bus_add_driver+163/451] bus_add_driver+0xa3/0x1c3
                        [driver_register+71/167] driver_register+0x47/0xa7
                        [__pci_register_driver+67/113] __pci_register_driver+0x43/0x71
                        [<e0042017>] iTCO_wdt_set_NO_REBOOT_bit+0x17/0x5e [iTCO_wdt]
                        [sys_init_module+6080/6396] sys_init_module+0x17c0/0x18fc
                        [syscall_call+7/11] syscall_call+0x7/0xb
                        [<ffffffff>] 0xffffffff
   in-hardirq-W at:
                        [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                        [lock_acquire+106/144] lock_acquire+0x6a/0x90
                        [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                        [<e01bf5d6>] ata_interrupt+0x13/0x1df [libata]
                        [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                        [handle_edge_irq+200/265] handle_edge_irq+0xc8/0x109
                        [do_IRQ+152/197] do_IRQ+0x98/0xc5
                        [<ffffffff>] 0xffffffff
   in-softirq-W at:
                        [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                        [lock_acquire+106/144] lock_acquire+0x6a/0x90
                        [_spin_lock+28/73] _spin_lock+0x1c/0x49
                        [<e01c62a0>] ata_scsi_queuecmd+0x30/0x1b6 [libata]
                        [<e019d83d>] scsi_dispatch_cmd+0x1a3/0x220 [scsi_mod]
                        [<e01a1d70>] scsi_request_fn+0x2a5/0x36e [scsi_mod]
                        [blk_run_queue+61/113] blk_run_queue+0x3d/0x71
                        [<e01a15ad>] scsi_run_queue+0x193/0x19b [scsi_mod]
                        [<e01a1fca>] scsi_next_command+0x28/0x34 [scsi_mod]
                        [<e01a2153>] scsi_end_request+0x6a/0x74 [scsi_mod]
                        [<e01a2650>] scsi_io_completion+0x153/0x316 [scsi_mod]
                        [<e019d548>] scsi_finish_command+0xad/0xb5 [scsi_mod]
                        [<e01a2a29>] scsi_softirq_done+0xc4/0xcc [scsi_mod]
                        [blk_done_softirq+109/122] blk_done_softirq+0x6d/0x7a
                        [__do_softirq+132/266] __do_softirq+0x84/0x10a
                        [do_softirq+121/218] do_softirq+0x79/0xda
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<e01db2ac>] __key.34306+0x0/0xffff21d2 [libata]
 -> (shost->host_lock){.+..} ops: 0 {
    initial-use  at:
                          [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [<e01a11c8>] scsi_schedule_eh+0xf/0x4f [scsi_mod]
                          [<e01ca40e>] ata_port_schedule_eh+0x37/0x3a [libata]
                          [<e01c362f>] ata_host_register+0x1d0/0x227 [libata]
                          [<e01c6df4>] ata_pci_activate_sff_host+0x179/0x19f [libata]
                          [<e00cdf9d>] piix_init_one+0x566/0x579 [ata_piix]
                          [pci_device_probe+57/89] pci_device_probe+0x39/0x59
                          [driver_probe_device+160/316] driver_probe_device+0xa0/0x13c
                          [__driver_attach+124/181] __driver_attach+0x7c/0xb5
                          [bus_for_each_dev+62/104] bus_for_each_dev+0x3e/0x68
                          [driver_attach+20/22] driver_attach+0x14/0x16
                          [bus_add_driver+163/451] bus_add_driver+0xa3/0x1c3
                          [driver_register+71/167] driver_register+0x47/0xa7
                          [__pci_register_driver+67/113] __pci_register_driver+0x43/0x71
                          [<e0042017>] iTCO_wdt_set_NO_REBOOT_bit+0x17/0x5e [iTCO_wdt]
                          [sys_init_module+6080/6396] sys_init_module+0x17c0/0x18fc
                          [syscall_call+7/11] syscall_call+0x7/0xb
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [<e01a285c>] scsi_device_unbusy+0x12/0x78 [scsi_mod]
                          [<e019d4ae>] scsi_finish_command+0x13/0xb5 [scsi_mod]
                          [<e01a2a29>] scsi_softirq_done+0xc4/0xcc [scsi_mod]
                          [blk_done_softirq+109/122] blk_done_softirq+0x6d/0x7a
                          [__do_softirq+132/266] __do_softirq+0x84/0x10a
                          [do_softirq+121/218] do_softirq+0x79/0xda
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<e01bad94>] __key.23037+0x0/0xfffebd8a [scsi_mod]
  -> (&rq->rq_lock_key){++..} ops: 0 {
     initial-use  at:
                            [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                            [rq_attach_root+19/199] rq_attach_root+0x13/0xc7
                            [sched_init+523/896] sched_init+0x20b/0x380
                            [start_kernel+391/877] start_kernel+0x187/0x36d
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock+28/73] _spin_lock+0x1c/0x49
                            [scheduler_tick+67/644] scheduler_tick+0x43/0x284
                            [update_process_times+61/73] update_process_times+0x3d/0x49
                            [tick_periodic+102/114] tick_periodic+0x66/0x72
                            [tick_handle_periodic+25/105] tick_handle_periodic+0x19/0x69
                            [timer_interrupt+71/78] timer_interrupt+0x47/0x4e
                            [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                            [handle_level_irq+128/200] handle_level_irq+0x80/0xc8
                            [do_IRQ+152/197] do_IRQ+0x98/0xc5
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock+28/73] _spin_lock+0x1c/0x49
                            [task_rq_lock+73/115] task_rq_lock+0x49/0x73
                            [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
                            [wake_up_process+15/17] wake_up_process+0xf/0x11
                            [process_timeout+8/10] process_timeout+0x8/0xa
                            [run_timer_softirq+315/411] run_timer_softirq+0x13b/0x19b
                            [__do_softirq+132/266] __do_softirq+0x84/0x10a
                            [do_softirq+121/218] do_softirq+0x79/0xda
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c1739a84>] 0xc1739a84
  ... acquired at:
   [__lock_acquire+2713/3089] __lock_acquire+0xa99/0xc11
   [lock_acquire+106/144] lock_acquire+0x6a/0x90
   [_spin_lock+28/73] _spin_lock+0x1c/0x49
   [task_rq_lock+73/115] task_rq_lock+0x49/0x73
   [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
   [wake_up_process+15/17] wake_up_process+0xf/0x11
   [<e01a10a1>] scsi_eh_wakeup+0x1e/0x38 [scsi_mod]
   [<e01a11f7>] scsi_schedule_eh+0x3e/0x4f [scsi_mod]
   [<e01ca40e>] ata_port_schedule_eh+0x37/0x3a [libata]
   [<e01c362f>] ata_host_register+0x1d0/0x227 [libata]
   [<e01c6df4>] ata_pci_activate_sff_host+0x179/0x19f [libata]
   [<e00cdf9d>] piix_init_one+0x566/0x579 [ata_piix]
   [pci_device_probe+57/89] pci_device_probe+0x39/0x59
   [driver_probe_device+160/316] driver_probe_device+0xa0/0x13c
   [__driver_attach+124/181] __driver_attach+0x7c/0xb5
   [bus_for_each_dev+62/104] bus_for_each_dev+0x3e/0x68
   [driver_attach+20/22] driver_attach+0x14/0x16
   [bus_add_driver+163/451] bus_add_driver+0xa3/0x1c3
   [driver_register+71/167] driver_register+0x47/0xa7
   [__pci_register_driver+67/113] __pci_register_driver+0x43/0x71
   [<e0042017>] iTCO_wdt_set_NO_REBOOT_bit+0x17/0x5e [iTCO_wdt]
   [sys_init_module+6080/6396] sys_init_module+0x17c0/0x18fc
   [syscall_call+7/11] syscall_call+0x7/0xb
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [__lock_acquire+2713/3089] __lock_acquire+0xa99/0xc11
   [lock_acquire+106/144] lock_acquire+0x6a/0x90
   [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
   [<e01a11c8>] scsi_schedule_eh+0xf/0x4f [scsi_mod]
   [<e01ca40e>] ata_port_schedule_eh+0x37/0x3a [libata]
   [<e01c362f>] ata_host_register+0x1d0/0x227 [libata]
   [<e01c6df4>] ata_pci_activate_sff_host+0x179/0x19f [libata]
   [<e00cdf9d>] piix_init_one+0x566/0x579 [ata_piix]
   [pci_device_probe+57/89] pci_device_probe+0x39/0x59
   [driver_probe_device+160/316] driver_probe_device+0xa0/0x13c
   [__driver_attach+124/181] __driver_attach+0x7c/0xb5
   [bus_for_each_dev+62/104] bus_for_each_dev+0x3e/0x68
   [driver_attach+20/22] driver_attach+0x14/0x16
   [bus_add_driver+163/451] bus_add_driver+0xa3/0x1c3
   [driver_register+71/167] driver_register+0x47/0xa7
   [__pci_register_driver+67/113] __pci_register_driver+0x43/0x71
   [<e0042017>] iTCO_wdt_set_NO_REBOOT_bit+0x17/0x5e [iTCO_wdt]
   [sys_init_module+6080/6396] sys_init_module+0x17c0/0x18fc
   [syscall_call+7/11] syscall_call+0x7/0xb
   [<ffffffff>] 0xffffffff

 -> (&q->lock){++..} ops: 0 {
    initial-use  at:
                          [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irq+43/88] _spin_lock_irq+0x2b/0x58
                          [wait_for_common+47/258] wait_for_common+0x2f/0x102
                          [wait_for_completion+18/20] wait_for_completion+0x12/0x14
                          [kthread_create+105/146] kthread_create+0x69/0x92
                          [migration_call+52/1080] migration_call+0x34/0x438
                          [migration_init+28/69] migration_init+0x1c/0x45
                          [kernel_init+66/755] kernel_init+0x42/0x2f3
                          [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [__wake_up+21/59] __wake_up+0x15/0x3b
                          [acpi_ec_gpe_handler+42/127] acpi_ec_gpe_handler+0x2a/0x7f
                          [acpi_ev_gpe_dispatch+78/274] acpi_ev_gpe_dispatch+0x4e/0x112
                          [acpi_ev_gpe_detect+154/225] acpi_ev_gpe_detect+0x9a/0xe1
                          [acpi_ev_sci_xrupt_handler+21/27] acpi_ev_sci_xrupt_handler+0x15/0x1b
                          [acpi_irq+14/35] acpi_irq+0xe/0x23
                          [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                          [handle_fasteoi_irq+125/182] handle_fasteoi_irq+0x7d/0xb6
                          [do_IRQ+152/197] do_IRQ+0x98/0xc5
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [__wake_up+21/59] __wake_up+0x15/0x3b
                          [acpi_ec_gpe_handler+42/127] acpi_ec_gpe_handler+0x2a/0x7f
                          [acpi_ev_gpe_dispatch+78/274] acpi_ev_gpe_dispatch+0x4e/0x112
                          [acpi_ev_gpe_detect+154/225] acpi_ev_gpe_detect+0x9a/0xe1
                          [acpi_ev_sci_xrupt_handler+21/27] acpi_ev_sci_xrupt_handler+0x15/0x1b
                          [acpi_irq+14/35] acpi_irq+0xe/0x23
                          [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                          [handle_fasteoi_irq+125/182] handle_fasteoi_irq+0x7d/0xb6
                          [do_IRQ+152/197] do_IRQ+0x98/0xc5
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [__key.14475+0/8] __key.14475+0x0/0x8
  -> (&rq->rq_lock_key){++..} ops: 0 {
     initial-use  at:
                            [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                            [rq_attach_root+19/199] rq_attach_root+0x13/0xc7
                            [sched_init+523/896] sched_init+0x20b/0x380
                            [start_kernel+391/877] start_kernel+0x187/0x36d
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock+28/73] _spin_lock+0x1c/0x49
                            [scheduler_tick+67/644] scheduler_tick+0x43/0x284
                            [update_process_times+61/73] update_process_times+0x3d/0x49
                            [tick_periodic+102/114] tick_periodic+0x66/0x72
                            [tick_handle_periodic+25/105] tick_handle_periodic+0x19/0x69
                            [timer_interrupt+71/78] timer_interrupt+0x47/0x4e
                            [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                            [handle_level_irq+128/200] handle_level_irq+0x80/0xc8
                            [do_IRQ+152/197] do_IRQ+0x98/0xc5
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock+28/73] _spin_lock+0x1c/0x49
                            [task_rq_lock+73/115] task_rq_lock+0x49/0x73
                            [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
                            [wake_up_process+15/17] wake_up_process+0xf/0x11
                            [process_timeout+8/10] process_timeout+0x8/0xa
                            [run_timer_softirq+315/411] run_timer_softirq+0x13b/0x19b
                            [__do_softirq+132/266] __do_softirq+0x84/0x10a
                            [do_softirq+121/218] do_softirq+0x79/0xda
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c1739a84>] 0xc1739a84
  ... acquired at:
   [__lock_acquire+2713/3089] __lock_acquire+0xa99/0xc11
   [lock_acquire+106/144] lock_acquire+0x6a/0x90
   [_spin_lock+28/73] _spin_lock+0x1c/0x49
   [task_rq_lock+73/115] task_rq_lock+0x49/0x73
   [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
   [default_wake_function+11/13] default_wake_function+0xb/0xd
   [__wake_up_common+53/91] __wake_up_common+0x35/0x5b
   [complete+43/62] complete+0x2b/0x3e
   [kthread+31/97] kthread+0x1f/0x61
   [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  -> (&ep->lock){.+..} ops: 0 {
     initial-use  at:
                            [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                            [sys_epoll_ctl+582/1034] sys_epoll
   [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [__queue_work+15/45] __queue_work+0xf/0x2d
                          [queue_work+62/72] queue_work+0x3e/0x48
                          [schedule_work+15/17] schedule_work+0xf/0x11
                          [schedule_console_callback+13/15] schedule_console_callback+0xd/0xf
                          [kbd_event+1398/1406] kbd_event+0x576/0x57e
                          [input_pass_event+117/178] input_pass_event+0x75/0xb2
                          [input_handle_event+853/892] input_handle_event+0x355/0x37c
                          [input_event+75/95] input_event+0x4b/0x5f
                          [atkbd_interrupt+508/1212] atkbd_interrupt+0x1fc/0x4bc
                          [serio_interrupt+51/105] serio_interrupt+0x33/0x69
                          [i8042_interrupt+466/483] i8042_interrupt+0x1d2/0x1e3
                          [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                          [handle_edge_irq+200/265] handle_edge_irq+0xc8/0x109
                          [do_IRQ+152/197] do_IRQ+0x98/0xc5
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [__queue_work+15/45] __queue_work+0xf/0x2d
                          [delayed_work_timer_fn+44/46] delayed_work_timer_fn+0x2c/0x2e
                          [run_timer_softirq+315/411] run_timer_softirq+0x13b/0x19b
                          [__do_softirq+132/266] __do_softirq+0x84/0x10a
                          [do_softirq+121/218] do_softirq+0x79/0xda
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [__key.14314+0/8] __key.14314+0x0/0x8
  -> (&q->lock){++..} ops: 0 {
     initial-use  at:
                            [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                            [lock_acquire+106/144] lock_acquire+0x6a/0x90
                            [_spin_lock_irq+43/88] _spin_lock_irq+0x2b/0x58
                            [wait_for_common+47/258] wait_for_common+0x2f/0x102
                            [wait_for_completion+18/20] wait_for_completion+0x12/0x14
                            [kthread_create+105/146] kthread_create+0x69/0x92
                            [migration_call+52/1080] migration_call+0x34/0x438
                            [migration_init+28/69] migration_init+0x1c/0x45
                            [<>   [<e01c51d7>] ata_scsi_rbuf_fill+0xe6/0xee [libata]
   [<e01c538c>] ata_scsi_simulate+0x1ad/0x1fd [libata]
   [<e01c63e8>] ata_scsi_queuecmd+0x178/0x1b6 [libata]
   [<e019d83d>] scsi_dispatch_cmd+0x1a3/0x220 [scsi_mod]
   [<e01a1d70>] scsi_request_fn+0x2a5/0x36e [scsi_mod]
   [__generic_unplug_device+29/32] __generic_unplug_device+0x1d/0x20
   [blk_execute_rq_nowait+98/118] blk_execute_rq_nowait+0x62/0x76
   [blk_execute_rq+182/210] blk_execute_rq+0xb6/0xd2
   [<e01a2e1e>] scsi_execute+0xc8/0xdd [scsi_mod]
   [<e01a2e85>] scsi_execute_req+0x52/0x7a [scsi_mod]
   [<e01a397f>] scsi_probe_and_add_lun+0x1f9/0x987 [scsi_mod]
   [<e01a4fc3>] __scsi_add_device+0x85/0xb4 [scsi_mod]
   [<e01c5b4a>] ata_scsi_scan_host+0x8a/0x212 [libata]
   [<e01c3669>] ata_host_register+0x20a/0x227 [libata]
   [<e01c6df4>] ata_pci_activate_sff_host+0x179/0x19f [libata]
   [<e00cdf9d>] piix_init_one+0x566/0x579 [ata_piix]
   [pci_device_probe+57/89] pci_device_probe+0x39/0x59
   [driver_probe_device+160/316] driver_probe_device+0xa0/0x13c
   [__driver_attach+124/181] __driver_attach+0x7c/0xb5
   [bus_for_each_dev+62/104] bus_for_each_dev+0x3e/0x68
   [driver_attach+20/22] driver_attach+0x14/0x16
   [bus_add_driver+163/451] bus_add_driver+0xa3/0x1c3
   [driver_register+71/167] driver_register+0x47/0xa7
   [__pci_register_driver+67/113] __pci_register_driver+0x43/0x71
   [<e0042017>] iTCO_wdt_set_NO_REBOOT_bit+0x17/0x5e [iTCO_wdt]
   [sys_init_module+6080/6396] sys_init_module+0x17c0/0x18fc
   [syscall_call+7/11] syscall_call+0x7/0xb
   [<ffffffff>] 0xffffffff

 -> (&rq->rq_lock_key){++..} ops: 0 {
    initial-use  at:
                          [__lock_acquire+1370/3089] __lock_acquire+0x55a/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock_irqsave+56/104] _spin_lock_irqsave+0x38/0x68
                          [rq_attach_root+19/199] rq_attach_root+0x13/0xc7
                          [sched_init+523/896] sched_init+0x20b/0x380
                          [start_kernel+391/877] start_kernel+0x187/0x36d
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [__lock_acquire+1180/3089] __lock_acquire+0x49c/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock+28/73] _spin_lock+0x1c/0x49
                          [scheduler_tick+67/644] scheduler_tick+0x43/0x284
                          [update_process_times+61/73] update_process_times+0x3d/0x49
                          [tick_periodic+102/114] tick_periodic+0x66/0x72
                          [tick_handle_periodic+25/105] tick_handle_periodic+0x19/0x69
                          [timer_interrupt+71/78] timer_interrupt+0x47/0x4e
                          [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
                          [handle_level_irq+128/200] handle_level_irq+0x80/0xc8
                          [do_IRQ+152/197] do_IRQ+0x98/0xc5
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [__lock_acquire+1216/3089] __lock_acquire+0x4c0/0xc11
                          [lock_acquire+106/144] lock_acquire+0x6a/0x90
                          [_spin_lock+28/73] _spin_lock+0x1c/0x49
                          [task_rq_lock+73/115] task_rq_lock+0x49/0x73
                          [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
                          [wake_up_process+15/17] wake_up_process+0xf/0x11
                          [process_timeout+8/10] process_timeout+0x8/0xa
                          [run_timer_softirq+315/411] run_timer_softirq+0x13b/0x19b
                          [__do_softirq+132/266] __do_softirq+0x84/0x10a
                          [do_softirq+121/218] do_softirq+0x79/0xda
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c1739a84>] 0xc1739a84
 ... acquired at:
   [__lock_acquire+2713/3089] __lock_acquire+0xa99/0xc11
   [lock_acquire+106/144] lock_acquire+0x6a/0x90
   [_spin_lock+28/73] _spin_lock+0x1c/0x49
   [task_rq_lock+73/115] task_rq_lock+0x49/0x73
   [try_to_wake_up+25/413] try_to_wake_up+0x19/0x19d
   [wake_up_process+15/17] wake_up_process+0xf/0x11
   [raise_softirq_irqoff+80/82] raise_softirq_irqoff+0x50/0x52
   [blk_complete_request+84/129] blk_complete_request+0x54/0x81
   [<e019d58f>] __scsi_done+0x3f/0x41 [scsi_mod]
   [<e019d5a7>] scsi_done+0x16/0x19 [scsi_mod]
   [<eACPI: \_SB_.PCI0.IDE0.SCND.MSTR: Bay event
