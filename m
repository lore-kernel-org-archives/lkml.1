Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbXHJHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbXHJHGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXHJHGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:06:15 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1562 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbXHJHGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:06:12 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm1: irq lock inversion dependency detected
Date: Fri, 10 Aug 2007 09:06:06 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708100906.07111.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	And the winner of today is ...



=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.23-rc2-mm1 #7
---------------------------------------------------------
runscript.sh/5843 just changed the state of lock:
 (_xmit_ETHER){-+..}, at: [<c03cbe79>] dev_watchdog+0x17/0xcc
but this lock took another, soft-irq-unsafe lock in the past:
 (&tp->lock){--..}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by runscript.sh/5843.

the first lock's dependencies:
-> (_xmit_ETHER){-+..} ops: 21 {
   initial-use  at:
                        [<c01387b9>] __lock_acquire+0x217/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c045303a>] _spin_lock_bh+0x3a/0x47
                        [<c03bc936>] dev_set_rx_mode+0x14/0x3b
                        [<c03bce3f>] dev_change_flags+0x68/0x190
                        [<c03fd37c>] devinet_ioctl+0x4af/0x652
                        [<c03fdc62>] inet_ioctl+0x56/0x71
                        [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                        [<c0178b42>] do_ioctl+0x22/0x71
                        [<c0178be6>] vfs_ioctl+0x55/0x29e
                        [<c0178e62>] sys_ioctl+0x33/0x69
                        [<c01041aa>] sysenter_past_esp+0x5f/0x99
                        [<ffffffff>] 0xffffffff
   in-softirq-W at:
                        [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c0452ff3>] _spin_lock+0x35/0x42
                        [<c03cbe79>] dev_watchdog+0x17/0xcc
                        [<c0122587>] run_timer_softirq+0x14b/0x1a9
                        [<c011ee12>] __do_softirq+0x5b/0xb2
                        [<c011eeb6>] do_softirq+0x4d/0x4f
                        [<c011f19b>] irq_exit+0x48/0x4a
                        [<c0105a18>] do_IRQ+0x98/0xd0
                        [<c010441e>] common_interrupt+0x2e/0x34
                        [<c0453922>] error_code+0x6a/0x70
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c0138ce0>] __lock_acquire+0x73e/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c045303a>] _spin_lock_bh+0x3a/0x47
                        [<c03bc936>] dev_set_rx_mode+0x14/0x3b
                        [<c03bce3f>] dev_change_flags+0x68/0x190
                        [<c03fd37c>] devinet_ioctl+0x4af/0x652
                        [<c03fdc62>] inet_ioctl+0x56/0x71
                        [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                        [<c0178b42>] do_ioctl+0x22/0x71
                        [<c0178be6>] vfs_ioctl+0x55/0x29e
                        [<c0178e62>] sys_ioctl+0x33/0x69
                        [<c01041aa>] sysenter_past_esp+0x5f/0x99
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c087aae8>] netdev_xmit_lock_key+0x8/0x1c0
 -> (&tp->lock){--..} ops: 44 {
    initial-use  at:
                          [<c01387b9>] __lock_acquire+0x217/0x11ac
                          [<c01397e7>] lock_acquire+0x99/0xb2
                          [<c0452ff3>] _spin_lock+0x35/0x42
                          [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                          [<c01484a2>] request_irq+0xba/0x108
                          [<de84e5f6>] rtl8139_open+0x2f/0x1e2 [8139too]
                          [<c03bf09d>] dev_open+0x37/0x76
                          [<c03bce65>] dev_change_flags+0x8e/0x190
                          [<c03fd37c>] devinet_ioctl+0x4af/0x652
                          [<c03fdc62>] inet_ioctl+0x56/0x71
                          [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                          [<c0178b42>] do_ioctl+0x22/0x71
                          [<c0178be6>] vfs_ioctl+0x55/0x29e
                          [<c0178e62>] sys_ioctl+0x33/0x69
                          [<c01041aa>] sysenter_past_esp+0x5f/0x99
                          [<ffffffff>] 0xffffffff
    softirq-on-W at:
                          [<c0138d09>] __lock_acquire+0x767/0x11ac
                          [<c01397e7>] lock_acquire+0x99/0xb2
                          [<c0452ff3>] _spin_lock+0x35/0x42
                          [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                          [<c01480fd>] free_irq+0x11b/0x146
                          [<de84ed59>] rtl8139_close+0x8a/0x14a [8139too]
                          [<c03bde63>] dev_close+0x57/0x74
                          [<c03bce65>] dev_change_flags+0x8e/0x190
                          [<c03fd37c>] devinet_ioctl+0x4af/0x652
                          [<c03fdc62>] inet_ioctl+0x56/0x71
                          [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                          [<c0178b42>] do_ioctl+0x22/0x71
                          [<c0178be6>] vfs_ioctl+0x55/0x29e
                          [<c0178e62>] sys_ioctl+0x33/0x69
                          [<c01041aa>] sysenter_past_esp+0x5f/0x99
                          [<ffffffff>] 0xffffffff
    hardirq-on-W at:
                          [<c0138ce0>] __lock_acquire+0x73e/0x11ac
                          [<c01397e7>] lock_acquire+0x99/0xb2
                          [<c0452ff3>] _spin_lock+0x35/0x42
                          [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                          [<c01480fd>] free_irq+0x11b/0x146
                          [<de84ed59>] rtl8139_close+0x8a/0x14a [8139too]
                          [<c03bde63>] dev_close+0x57/0x74
                          [<c03bce65>] dev_change_flags+0x8e/0x190
                          [<c03fd37c>] devinet_ioctl+0x4af/0x652
                          [<c03fdc62>] inet_ioctl+0x56/0x71
                          [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                          [<c0178b42>] do_ioctl+0x22/0x71
                          [<c0178be6>] vfs_ioctl+0x55/0x29e
                          [<c0178e62>] sys_ioctl+0x33/0x69
                          [<c01041aa>] sysenter_past_esp+0x5f/0x99
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<de852390>] __key.20003+0x0/0xffffd291 [8139too]
 ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<de84d275>] rtl8139_set_rx_mode+0x1e/0x166 [8139too]
   [<c03bc702>] __dev_set_rx_mode+0x24/0x85
   [<c03bc948>] dev_set_rx_mode+0x26/0x3b
   [<c03bf0c0>] dev_open+0x5a/0x76
   [<c03bce65>] dev_change_flags+0x8e/0x190
   [<c03fd37c>] devinet_ioctl+0x4af/0x652
   [<c03fdc62>] inet_ioctl+0x56/0x71
   [<c03b1dba>] sock_ioctl+0xa5/0x1d4
   [<c0178b42>] do_ioctl+0x22/0x71
   [<c0178be6>] vfs_ioctl+0x55/0x29e
   [<c0178e62>] sys_ioctl+0x33/0x69
   [<c01041aa>] sysenter_past_esp+0x5f/0x99
   [<ffffffff>] 0xffffffff

 -> (&priv->lock){+...} ops: 103 {
    initial-use  at:
                          [<c01387b9>] __lock_acquire+0x217/0x11ac
                          [<c01397e7>] lock_acquire+0x99/0xb2
                          [<c04531dc>] _spin_lock_irq+0x3b/0x48
                          [<ded03256>] orinoco_init+0x8f5/0xbbd [orinoco]
                          [<c03be46e>] register_netdevice+0x13a/0x3f8
                          [<c03be75e>] register_netdev+0x32/0x3f
                          [<ded2d4bb>] orinoco_cs_probe+0x368/0x3df [orinoco_cs]
                          [<ded378d9>] pcmcia_device_probe+0xc9/0x14c [pcmcia]
                          [<c02f38bf>] driver_probe_device+0xa6/0x198
                          [<c02f3b02>] __driver_attach+0xa2/0xa4
                          [<c02f2d8a>] bus_for_each_dev+0x43/0x61
                          [<c02f3741>] driver_attach+0x19/0x1b
                          [<c02f30f9>] bus_add_driver+0x7e/0x1a5
                          [<c02f3caf>] driver_register+0x45/0x75
                          [<ded38560>] pcmcia_register_driver+0xdb/0x12f [pcmcia]
                          [<de84b024>] 0xde84b024
                          [<c0140357>] sys_init_module+0xc4/0x1622
                          [<c01041aa>] sysenter_past_esp+0x5f/0x99
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c0138eeb>] __lock_acquire+0x949/0x11ac
                          [<c01397e7>] lock_acquire+0x99/0xb2
                          [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                          [<ded03bb4>] orinoco_interrupt+0x3f/0x1219 [orinoco]
                          [<c0147a5d>] handle_IRQ_event+0x28/0x59
                          [<c01493ca>] handle_level_irq+0xad/0x10b
                          [<c0105a13>] do_IRQ+0x93/0xd0
                          [<c010441e>] common_interrupt+0x2e/0x34
                          [<ded06a99>] orinoco_get_wireless_stats+0xeb/0x140 [orinoco]
                          [<c042baea>] get_wireless_stats+0x1a/0x21
                          [<c042c799>] wireless_seq_show+0x20/0x143
                          [<c0187387>] seq_read+0x1af/0x2b8
                          [<c01a1ec2>] proc_reg_read+0x57/0x78
                          [<c016d7f1>] vfs_read+0xaa/0x147
                          [<c016dc16>] sys_read+0x3d/0x7b
                          [<c01041aa>] sysenter_past_esp+0x5f/0x99
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<ded0a298>] __key.20617+0x0/0xffffc9cd [orinoco]
  -> (lweventlist_lock){+...} ops: 8 {
     initial-use  at:
                            [<c01387b9>] __lock_acquire+0x217/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c03c80eb>] linkwatch_add_event+0x10/0x31
                            [<c03c81ca>] linkwatch_fire_event+0x35/0x37
                            [<c03cbb7a>] netif_carrier_off+0x19/0x20
                            [<ded023b5>] alloc_orinocodev+0x181/0x19c [orinoco]
                            [<ded2d170>] orinoco_cs_probe+0x1d/0x3df [orinoco_cs]
                            [<ded378d9>] pcmcia_device_probe+0xc9/0x14c [pcmcia]
                            [<c02f38bf>] driver_probe_device+0xa6/0x198
                            [<c02f3b02>] __driver_attach+0xa2/0xa4
                            [<c02f2d8a>] bus_for_each_dev+0x43/0x61
                            [<c02f3741>] driver_attach+0x19/0x1b
                            [<c02f30f9>] bus_add_driver+0x7e/0x1a5
                            [<c02f3caf>] driver_register+0x45/0x75
                            [<ded38560>] pcmcia_register_driver+0xdb/0x12f [pcmcia]
                            [<de84b024>] 0xde84b024
                            [<c0140357>] sys_init_module+0xc4/0x1622
                            [<c01041aa>] sysenter_past_esp+0x5f/0x99
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0138eeb>] __lock_acquire+0x949/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c03c80eb>] linkwatch_add_event+0x10/0x31
                            [<c03c81ca>] linkwatch_fire_event+0x35/0x37
                            [<c03cbbaa>] netif_carrier_on+0x29/0x2b
                            [<ded04bdc>] orinoco_interrupt+0x1067/0x1219 [orinoco]
                            [<c0147a5d>] handle_IRQ_event+0x28/0x59
                            [<c01493ca>] handle_level_irq+0xad/0x10b
                            [<c0105a13>] do_IRQ+0x93/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c0370d2b>] cpuidle_idle_call+0x74/0x99
                            [<c01023e7>] cpu_idle+0x87/0x89
                            [<c044fa24>] rest_init+0x60/0x62
                            [<c05f8ad5>] start_kernel+0x23a/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c05df370>] lweventlist_lock+0x10/0x20
  ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<c03c80eb>] linkwatch_add_event+0x10/0x31
   [<c03c81ca>] linkwatch_fire_event+0x35/0x37
   [<c03cbbaa>] netif_carrier_on+0x29/0x2b
   [<ded04bdc>] orinoco_interrupt+0x1067/0x1219 [orinoco]
   [<c0147a5d>] handle_IRQ_event+0x28/0x59
   [<c01493ca>] handle_level_irq+0xad/0x10b
   [<c0105a13>] do_IRQ+0x93/0xd0
   [<c010441e>] common_interrupt+0x2e/0x34
   [<c0370d2b>] cpuidle_idle_call+0x74/0x99
   [<c01023e7>] cpu_idle+0x87/0x89
   [<c044fa24>] rest_init+0x60/0x62
   [<c05f8ad5>] start_kernel+0x23a/0x2c5
   [<00000000>] 0x0
   [<ffffffff>] 0xffffffff

  -> (&cwq->lock){++..} ops: 10212 {
     initial-use  at:
                            [<c01387b9>] __lock_acquire+0x217/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c01290d2>] __queue_work+0xf/0x2d
                            [<c012916f>] queue_work+0x57/0x90
                            [<c01287e4>] call_usermodehelper_exec+0xce/0xe1
                            [<c0265745>] kobject_uevent_env+0x34d/0x449
                            [<c026584b>] kobject_uevent+0xa/0xf
                            [<c0264f29>] kset_register+0x32/0x38
                            [<c0264f37>] subsystem_register+0x8/0xa
                            [<c02f330a>] bus_register+0x65/0x1f3
                            [<c060de66>] platform_bus_init+0x23/0x38
                            [<c060debc>] driver_init+0x1c/0x31
                            [<c05f868d>] kernel_init+0x5d/0x26b
                            [<c010451b>] kernel_thread_helper+0x7/0x1c
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0138eeb>] __lock_acquire+0x949/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c01290d2>] __queue_work+0xf/0x2d
                            [<c012916f>] queue_work+0x57/0x90
                            [<c0292b4a>] acpi_os_execute+0xae/0xcb
                            [<c02aa9da>] acpi_ec_gpe_handler+0x4d/0x5e
                            [<c0298701>] acpi_ev_gpe_dispatch+0x4b/0x115
                            [<c0298a03>] acpi_ev_gpe_detect+0x9a/0xe1
                            [<c0297139>] acpi_ev_sci_xrupt_handler+0x15/0x1d
                            [<c029225e>] acpi_irq+0xe/0x18
                            [<c0147a5d>] handle_IRQ_event+0x28/0x59
                            [<c01493ca>] handle_level_irq+0xad/0x10b
                            [<c0105a13>] do_IRQ+0x93/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c01023e7>] cpu_idle+0x87/0x89
                            [<c044fa24>] rest_init+0x60/0x62
                            [<c05f8ad5>] start_kernel+0x23a/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c01290d2>] __queue_work+0xf/0x2d
                            [<c0129114>] delayed_work_timer_fn+0x24/0x28
                            [<c0122587>] run_timer_softirq+0x14b/0x1a9
                            [<c011ee12>] __do_softirq+0x5b/0xb2
                            [<c011eeb6>] do_softirq+0x4d/0x4f
                            [<c011f19b>] irq_exit+0x48/0x4a
                            [<c0105a18>] do_IRQ+0x98/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c0451778>] mutex_lock+0x1c/0x1f
                            [<c01ab52c>] sysfs_addrm_start+0x24/0x8a
                            [<c01aade2>] sysfs_add_file+0x40/0x93
                            [<c01ad2f9>] sysfs_create_group+0xa5/0x15c
                            [<c016aa1d>] sysfs_slab_add+0xae/0x155
                            [<c016b150>] kmem_cache_create+0xc2/0x1d2
                            [<c0608b8e>] cfq_init+0x5a/0xc6
                            [<c05f86c7>] kernel_init+0x97/0x26b
                            [<c010451b>] kernel_thread_helper+0x7/0x1c
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0653ae8>] __key.11154+0x0/0x8
   -> (&q->lock){++..} ops: 209326 {
      initial-use  at:
                              [<c01387b9>] __lock_acquire+0x217/0x11ac
                              [<c01397e7>] lock_acquire+0x99/0xb2
                              [<c04531dc>] _spin_lock_irq+0x3b/0x48
                              [<c0450505>] wait_for_completion+0x24/0xb5
                              [<c012c2a1>] kthread_create+0x69/0xa8
                              [<c0602fcc>] cpu_callback+0x48/0xa3
                              [<c0603043>] spawn_ksoftirqd+0x1c/0x4e
                              [<c05f866c>] kernel_init+0x3c/0x26b
                              [<c010451b>] kernel_thread_helper+0x7/0x1c
                              [<ffffffff>] 0xffffffff
      in-hardirq-W at:
                              [<c0138eeb>] __lock_acquire+0x949/0x11ac
                              [<c01397e7>] lock_acquire+0x99/0xb2
                              [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                              [<c0113d44>] __wake_up+0x15/0x42
                              [<c02aa9b3>] acpi_ec_gpe_handler+0x26/0x5e
                              [<c0298701>] acpi_ev_gpe_dispatch+0x4b/0x115
                              [<c0298a03>] acpi_ev_gpe_detect+0x9a/0xe1
                              [<c0297139>] acpi_ev_sci_xrupt_handler+0x15/0x1d
                              [<c029225e>] acpi_irq+0xe/0x18
                              [<c0147a5d>] handle_IRQ_event+0x28/0x59
                              [<c01493ca>] handle_level_irq+0xad/0x10b
                              [<c0105a13>] do_IRQ+0x93/0xd0
                              [<c010441e>] common_interrupt+0x2e/0x34
                              [<c01023e7>] cpu_idle+0x87/0x89
                              [<c044fa24>] rest_init+0x60/0x62
                              [<c05f8ad5>] start_kernel+0x23a/0x2c5
                              [<00000000>] 0x0
                              [<ffffffff>] 0xffffffff
      in-softirq-W at:
                              [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                              [<c01397e7>] lock_acquire+0x99/0xb2
                              [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                              [<c0113c85>] complete+0x15/0x4b
                              [<c0129f8e>] wakeme_after_rcu+0xb/0xd
                              [<c012a0e3>] __rcu_process_callbacks+0x69/0x1cf
                              [<c012a25b>] rcu_process_callbacks+0x12/0x23
                              [<c011eef3>] tasklet_action+0x3b/0x7b
                              [<c011ee12>] __do_softirq+0x5b/0xb2
                              [<c011eeb6>] do_softirq+0x4d/0x4f
                              [<c011f19b>] irq_exit+0x48/0x4a
                              [<c0105a18>] do_IRQ+0x98/0xd0
                              [<c010441e>] common_interrupt+0x2e/0x34
                              [<c01023e7>] cpu_idle+0x87/0x89
                              [<c044fa24>] rest_init+0x60/0x62
                              [<c05f8ad5>] start_kernel+0x23a/0x2c5
                              [<00000000>] 0x0
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c0653f30>] __key.11659+0x0/0x8
    -> (&rq->rq_lock_key){++..} ops: 1722217 {
       initial-use  at:
                                [<c01387b9>] __lock_acquire+0x217/0x11ac
                                [<c01397e7>] lock_acquire+0x99/0xb2
                                [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                                [<c060264a>] init_idle+0x40/0x6d
                                [<c06027e0>] sched_init+0x169/0x17c
                                [<c05f8970>] start_kernel+0xd5/0x2c5
                                [<00000000>] 0x0
                                [<ffffffff>] 0xffffffff
       in-hardirq-W at:
                                [<c0138eeb>] __lock_acquire+0x949/0x11ac
                                [<c01397e7>] lock_acquire+0x99/0xb2
                                [<c0452ff3>] _spin_lock+0x35/0x42
                                [<c01157fe>] scheduler_tick+0x20/0x187
                                [<c0122d01>] update_process_times+0x43/0x62
                                [<c0133c35>] tick_periodic+0x24/0x75
                                [<c0133c9e>] tick_handle_periodic+0x18/0x7a
                                [<c01065ce>] timer_interrupt+0xe/0x15
                                [<c0147a5d>] handle_IRQ_event+0x28/0x59
                                [<c01493ca>] handle_level_irq+0xad/0x10b
                                [<c0105a13>] do_IRQ+0x93/0xd0
                                [<c010441e>] common_interrupt+0x2e/0x34
                                [<c014821a>] setup_irq+0xf2/0x20d
                                [<c060256f>] time_init_hook+0x19/0x1b
                                [<c05fbcc8>] hpet_time_init+0xd/0x15
                                [<c05f8a70>] start_kernel+0x1d5/0x2c5
                                [<00000000>] 0x0
                                [<ffffffff>] 0xffffffff
       in-softirq-W at:
                                [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                                [<c01397e7>] lock_acquire+0x99/0xb2
                                [<c0452ff3>] _spin_lock+0x35/0x42
                                [<c01157fe>] scheduler_tick+0x20/0x187
                                [<c0122d01>] update_process_times+0x43/0x62
                                [<c0133c35>] tick_periodic+0x24/0x75
                                [<c0133c9e>] tick_handle_periodic+0x18/0x7a
                                [<c01065ce>] timer_interrupt+0xe/0x15
                                [<c0147a5d>] handle_IRQ_event+0x28/0x59
                                [<c01493ca>] handle_level_irq+0xad/0x10b
                                [<c0105a13>] do_IRQ+0x93/0xd0
                                [<c010441e>] common_interrupt+0x2e/0x34
                                [<c011b680>] delayed_put_task_struct+0x2e/0x48
                                [<c012a0e3>] __rcu_process_callbacks+0x69/0x1cf
                                [<c012a25b>] rcu_process_callbacks+0x12/0x23
                                [<c011eef3>] tasklet_action+0x3b/0x7b
                                [<c011ee12>] __do_softirq+0x5b/0xb2
                                [<c011eeb6>] do_softirq+0x4d/0x4f
                                [<c011f19b>] irq_exit+0x48/0x4a
                                [<c0105a18>] do_IRQ+0x98/0xd0
                                [<c010441e>] common_interrupt+0x2e/0x34
                                [<c029d74c>] acpi_ex_system_io_space_handler+0x3f/0x45
                                [<c0296dd2>] acpi_ev_address_space_dispatch+0x12f/0x170
                                [<c029ab38>] acpi_ex_access_region+0x1a7/0x1b9
                                [<c029ac5b>] acpi_ex_field_datum_io+0x111/0x198
                                [<c029afd6>] acpi_ex_write_with_update_rule+0xf7/0x100
                                [<c029b25b>] acpi_ex_insert_into_field+0x27c/0x289
                                [<c029998c>] acpi_ex_write_data_to_field+0x207/0x21f
                                [<c029d9bc>] acpi_ex_store_object_to_node+0x70/0xa5
                                [<c029db4b>] acpi_ex_store+0xd5/0x216
                                [<c029baaa>] acpi_ex_opcode_1A_1T_1R+0x3a8/0x504
                                [<c0294734>] acpi_ds_exec_end_op+0xc1/0x3bd
                                [<c02a29fc>] acpi_ps_parse_loop+0x539/0x6d9
                                [<c02a1ebe>] acpi_ps_parse_aml+0x68/0x235
                                [<c02a30e0>] acpi_ps_execute_method+0x111/0x1b5
                                [<c02a051f>] acpi_ns_evaluate+0x93/0xe8
                                [<c02a0190>] acpi_evaluate_object+0x123/0x1bf
                                [<c0292dfb>] acpi_evaluate_integer+0x71/0xa4
                                [<c02a8de5>] acpi_bus_get_status+0x31/0x83
                                [<c02a990b>] acpi_add_single_object+0x1cb/0xab0
                                [<c02aa2ea>] acpi_bus_scan+0xfa/0x163
                                [<c060b0c5>] acpi_scan_init+0xcd/0xe9
                                [<c05f86c7>] kernel_init+0x97/0x26b
                                [<c010451b>] kernel_thread_helper+0x7/0x1c
                                [<ffffffff>] 0xffffffff
     }
     ... key      at: [<c0631d28>] per_cpu__runqueues+0x468/0x470
    ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c0452ff3>] _spin_lock+0x35/0x42
   [<c0114ecb>] task_rq_lock+0x28/0x40
   [<c0115054>] try_to_wake_up+0x18/0x96
   [<c01150dd>] default_wake_function+0xb/0xd
   [<c011284b>] __wake_up_common+0x39/0x59
   [<c0113caa>] complete+0x3a/0x4b
   [<c012c107>] kthread+0x1f/0x58
   [<c010451b>] kernel_thread_helper+0x7/0x1c
   [<ffffffff>] 0xffffffff

   ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<c0113d44>] __wake_up+0x15/0x42
   [<c0128d3b>] insert_work+0x60/0x75
   [<c01290e2>] __queue_work+0x1f/0x2d
   [<c012916f>] queue_work+0x57/0x90
   [<c01287e4>] call_usermodehelper_exec+0xce/0xe1
   [<c0265745>] kobject_uevent_env+0x34d/0x449
   [<c026584b>] kobject_uevent+0xa/0xf
   [<c0264f29>] kset_register+0x32/0x38
   [<c0264f37>] subsystem_register+0x8/0xa
   [<c02f330a>] bus_register+0x65/0x1f3
   [<c060de66>] platform_bus_init+0x23/0x38
   [<c060debc>] driver_init+0x1c/0x31
   [<c05f868d>] kernel_init+0x5d/0x26b
   [<c010451b>] kernel_thread_helper+0x7/0x1c
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<c01290d2>] __queue_work+0xf/0x2d
   [<c012916f>] queue_work+0x57/0x90
   [<c012957f>] queue_delayed_work+0x27/0x48
   [<c01295c2>] schedule_delayed_work+0x22/0x26
   [<c03c814c>] linkwatch_schedule_work+0x40/0x89
   [<c03c81b9>] linkwatch_fire_event+0x24/0x37
   [<c03cbbaa>] netif_carrier_on+0x29/0x2b
   [<ded04bdc>] orinoco_interrupt+0x1067/0x1219 [orinoco]
   [<c0147a5d>] handle_IRQ_event+0x28/0x59
   [<c01493ca>] handle_level_irq+0xad/0x10b
   [<c0105a13>] do_IRQ+0x93/0xd0
   [<c010441e>] common_interrupt+0x2e/0x34
   [<c0370d2b>] cpuidle_idle_call+0x74/0x99
   [<c01023e7>] cpu_idle+0x87/0x89
   [<c044fa24>] rest_init+0x60/0x62
   [<c05f8ad5>] start_kernel+0x23a/0x2c5
   [<00000000>] 0x0
   [<ffffffff>] 0xffffffff

  -> (base_lock_keys + cpu){++..} ops: 1561679 {
     initial-use  at:
                            [<c01387b9>] __lock_acquire+0x217/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c0122ac6>] lock_timer_base+0x41/0x66
                            [<c0122b88>] __mod_timer+0x3b/0xc5
                            [<c0122cba>] mod_timer+0x47/0x4b
                            [<c060d141>] con_init+0x24b/0x27e
                            [<c060c815>] console_init+0x20/0x2e
                            [<c05f8a30>] start_kernel+0x195/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0138eeb>] __lock_acquire+0x949/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c0122ac6>] lock_timer_base+0x41/0x66
                            [<c0122b17>] del_timer+0x2c/0x62
                            [<c030312b>] ide_intr+0x72/0x1f0
                            [<c0147a5d>] handle_IRQ_event+0x28/0x59
                            [<c01493ca>] handle_level_irq+0xad/0x10b
                            [<c0105a13>] do_IRQ+0x93/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c01023e7>] cpu_idle+0x87/0x89
                            [<c044fa24>] rest_init+0x60/0x62
                            [<c05f8ad5>] start_kernel+0x23a/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c04531dc>] _spin_lock_irq+0x3b/0x48
                            [<c0122465>] run_timer_softirq+0x29/0x1a9
                            [<c011ee12>] __do_softirq+0x5b/0xb2
                            [<c011eeb6>] do_softirq+0x4d/0x4f
                            [<c011f19b>] irq_exit+0x48/0x4a
                            [<c0105a18>] do_IRQ+0x98/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c014821a>] setup_irq+0xf2/0x20d
                            [<c060256f>] time_init_hook+0x19/0x1b
                            [<c05fbcc8>] hpet_time_init+0xd/0x15
                            [<c05f8a70>] start_kernel+0x1d5/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0653a96>] base_lock_keys+0x0/0xa
  ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<c0122ac6>] lock_timer_base+0x41/0x66
   [<c0122b88>] __mod_timer+0x3b/0xc5
   [<c0122cba>] mod_timer+0x47/0x4b
   [<c03cb677>] __netdev_watchdog_up+0x37/0x50
   [<c03cbba0>] netif_carrier_on+0x1f/0x2b
   [<ded04bdc>] orinoco_interrupt+0x1067/0x1219 [orinoco]
   [<c0147a5d>] handle_IRQ_event+0x28/0x59
   [<c01493ca>] handle_level_irq+0xad/0x10b
   [<c0105a13>] do_IRQ+0x93/0xd0
   [<c010441e>] common_interrupt+0x2e/0x34
   [<c0370d2b>] cpuidle_idle_call+0x74/0x99
   [<c01023e7>] cpu_idle+0x87/0x89
   [<c044fa24>] rest_init+0x60/0x62
   [<c05f8ad5>] start_kernel+0x23a/0x2c5
   [<00000000>] 0x0
   [<ffffffff>] 0xffffffff

  -> (&list->lock#2){.+..} ops: 12 {
     initial-use  at:
                            [<c01387b9>] __lock_acquire+0x217/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c03b794b>] skb_queue_tail+0x14/0x33
                            [<c042beab>] wireless_send_event+0x348/0x369
                            [<c042c1e9>] ioctl_standard_call+0x1b2/0x34d
                            [<c042c6de>] wext_handle_ioctl+0x35a/0x3e4
                            [<c03beff5>] dev_ioctl+0x31e/0x325
                            [<c03b1dcc>] sock_ioctl+0xb7/0x1d4
                            [<c0178b42>] do_ioctl+0x22/0x71
                            [<c0178be6>] vfs_ioctl+0x55/0x29e
                            [<c0178e62>] sys_ioctl+0x33/0x69
                            [<c01041aa>] sysenter_past_esp+0x5f/0x99
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c03b79fc>] skb_dequeue+0x12/0x50
                            [<c042bb5d>] wireless_nlevent_process+0x2d/0x33
                            [<c011eef3>] tasklet_action+0x3b/0x7b
                            [<c011ee12>] __do_softirq+0x5b/0xb2
                            [<c011eeb6>] do_softirq+0x4d/0x4f
                            [<c011f19b>] irq_exit+0x48/0x4a
                            [<c0105a18>] do_IRQ+0x98/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<ded028e3>] orinoco_ioctl_commit+0x8e/0x10c [orinoco]
                            [<c042bb20>] call_commit_handler+0x2f/0x3f
                            [<c042c202>] ioctl_standard_call+0x1cb/0x34d
                            [<c042c6de>] wext_handle_ioctl+0x35a/0x3e4
                            [<c03beff5>] dev_ioctl+0x31e/0x325
                            [<c03b1dcc>] sock_ioctl+0xb7/0x1d4
                            [<c0178b42>] do_ioctl+0x22/0x71
                            [<c0178be6>] vfs_ioctl+0x55/0x29e
                            [<c0178e62>] sys_ioctl+0x33/0x69
                            [<c01041aa>] sysenter_past_esp+0x5f/0x99
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0880b80>] __key.13452+0x0/0x20
  ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<c03b794b>] skb_queue_tail+0x14/0x33
   [<c042beab>] wireless_send_event+0x348/0x369
   [<ded03b69>] orinoco_send_wevents+0x9a/0xa6 [orinoco]
   [<c0128bf8>] run_workqueue+0x110/0x1f3
   [<c0129718>] worker_thread+0x9a/0xf2
   [<c012c11e>] kthread+0x36/0x58
   [<c010451b>] kernel_thread_helper+0x7/0x1c
   [<ffffffff>] 0xffffffff

  -> (&rq->rq_lock_key){++..} ops: 1722217 {
     initial-use  at:
                            [<c01387b9>] __lock_acquire+0x217/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
                            [<c060264a>] init_idle+0x40/0x6d
                            [<c06027e0>] sched_init+0x169/0x17c
                            [<c05f8970>] start_kernel+0xd5/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0138eeb>] __lock_acquire+0x949/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c0452ff3>] _spin_lock+0x35/0x42
                            [<c01157fe>] scheduler_tick+0x20/0x187
                            [<c0122d01>] update_process_times+0x43/0x62
                            [<c0133c35>] tick_periodic+0x24/0x75
                            [<c0133c9e>] tick_handle_periodic+0x18/0x7a
                            [<c01065ce>] timer_interrupt+0xe/0x15
                            [<c0147a5d>] handle_IRQ_event+0x28/0x59
                            [<c01493ca>] handle_level_irq+0xad/0x10b
                            [<c0105a13>] do_IRQ+0x93/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c014821a>] setup_irq+0xf2/0x20d
                            [<c060256f>] time_init_hook+0x19/0x1b
                            [<c05fbcc8>] hpet_time_init+0xd/0x15
                            [<c05f8a70>] start_kernel+0x1d5/0x2c5
                            [<00000000>] 0x0
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c0138c94>] __lock_acquire+0x6f2/0x11ac
                            [<c01397e7>] lock_acquire+0x99/0xb2
                            [<c0452ff3>] _spin_lock+0x35/0x42
                            [<c01157fe>] scheduler_tick+0x20/0x187
                            [<c0122d01>] update_process_times+0x43/0x62
                            [<c0133c35>] tick_periodic+0x24/0x75
                            [<c0133c9e>] tick_handle_periodic+0x18/0x7a
                            [<c01065ce>] timer_interrupt+0xe/0x15
                            [<c0147a5d>] handle_IRQ_event+0x28/0x59
                            [<c01493ca>] handle_level_irq+0xad/0x10b
                            [<c0105a13>] do_IRQ+0x93/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c011b680>] delayed_put_task_struct+0x2e/0x48
                            [<c012a0e3>] __rcu_process_callbacks+0x69/0x1cf
                            [<c012a25b>] rcu_process_callbacks+0x12/0x23
                            [<c011eef3>] tasklet_action+0x3b/0x7b
                            [<c011ee12>] __do_softirq+0x5b/0xb2
                            [<c011eeb6>] do_softirq+0x4d/0x4f
                            [<c011f19b>] irq_exit+0x48/0x4a
                            [<c0105a18>] do_IRQ+0x98/0xd0
                            [<c010441e>] common_interrupt+0x2e/0x34
                            [<c029d74c>] acpi_ex_system_io_space_handler+0x3f/0x45
                            [<c0296dd2>] acpi_ev_address_space_dispatch+0x12f/0x170
                            [<c029ab38>] acpi_ex_access_region+0x1a7/0x1b9
                            [<c029ac5b>] acpi_ex_field_datum_io+0x111/0x198
                            [<c029afd6>] acpi_ex_write_with_update_rule+0xf7/0x100
                            [<c029b25b>] acpi_ex_insert_into_field+0x27c/0x289
                            [<c029998c>] acpi_ex_write_data_to_field+0x207/0x21f
                            [<c029d9bc>] acpi_ex_store_object_to_node+0x70/0xa5
                            [<c029db4b>] acpi_ex_store+0xd5/0x216
                            [<c029baaa>] acpi_ex_opcode_1A_1T_1R+0x3a8/0x504
                            [<c0294734>] acpi_ds_exec_end_op+0xc1/0x3bd
                            [<c02a29fc>] acpi_ps_parse_loop+0x539/0x6d9
                            [<c02a1ebe>] acpi_ps_parse_aml+0x68/0x235
                            [<c02a30e0>] acpi_ps_execute_method+0x111/0x1b5
                            [<c02a051f>] acpi_ns_evaluate+0x93/0xe8
                            [<c02a0190>] acpi_evaluate_object+0x123/0x1bf
                            [<c0292dfb>] acpi_evaluate_integer+0x71/0xa4
                            [<c02a8de5>] acpi_bus_get_status+0x31/0x83
                            [<c02a990b>] acpi_add_single_object+0x1cb/0xab0
                            [<c02aa2ea>] acpi_bus_scan+0xfa/0x163
                            [<c060b0c5>] acpi_scan_init+0xcd/0xe9
                            [<c05f86c7>] kernel_init+0x97/0x26b
                            [<c010451b>] kernel_thread_helper+0x7/0x1c
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0631d28>] per_cpu__runqueues+0x468/0x470
  ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c0452ff3>] _spin_lock+0x35/0x42
   [<c0114ecb>] task_rq_lock+0x28/0x40
   [<c0115054>] try_to_wake_up+0x18/0x96
   [<c01150fa>] wake_up_process+0xf/0x11
   [<c011f71c>] __tasklet_schedule+0x6d/0x6f
   [<c042bec7>] wireless_send_event+0x364/0x369
   [<ded03b69>] orinoco_send_wevents+0x9a/0xa6 [orinoco]
   [<c0128bf8>] run_workqueue+0x110/0x1f3
   [<c0129718>] worker_thread+0x9a/0xf2
   [<c012c11e>] kthread+0x36/0x58
   [<c010451b>] kernel_thread_helper+0x7/0x1c
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c013963d>] __lock_acquire+0x109b/0x11ac
   [<c01397e7>] lock_acquire+0x99/0xb2
   [<c045326f>] _spin_lock_irqsave+0x3e/0x4e
   [<ded03598>] orinoco_set_multicast_list+0x1b/0x5f [orinoco]
   [<c03bc702>] __dev_set_rx_mode+0x24/0x85
   [<c03bc948>] dev_set_rx_mode+0x26/0x3b
   [<c03bf0c0>] dev_open+0x5a/0x76
   [<c03bce65>] dev_change_flags+0x8e/0x190
   [<c03fd37c>] devinet_ioctl+0x4af/0x652
   [<c03fdc62>] inet_ioctl+0x56/0x71
   [<c03b1dba>] sock_ioctl+0xa5/0x1d4
   [<c0178b42>] do_ioctl+0x22/0x71
   [<c0178be6>] vfs_ioctl+0x55/0x29e
   [<c0178e62>] sys_ioctl+0x33/0x69
   [<c01041aa>] sysenter_past_esp+0x5f/0x99
   [<ffffffff>] 0xffffffff


the second lock's dependencies:
-> (&tp->lock){--..} ops: 44 {
   initial-use  at:
                        [<c01387b9>] __lock_acquire+0x217/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c0452ff3>] _spin_lock+0x35/0x42
                        [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                        [<c01484a2>] request_irq+0xba/0x108
                        [<de84e5f6>] rtl8139_open+0x2f/0x1e2 [8139too]
                        [<c03bf09d>] dev_open+0x37/0x76
                        [<c03bce65>] dev_change_flags+0x8e/0x190
                        [<c03fd37c>] devinet_ioctl+0x4af/0x652
                        [<c03fdc62>] inet_ioctl+0x56/0x71
                        [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                        [<c0178b42>] do_ioctl+0x22/0x71
                        [<c0178be6>] vfs_ioctl+0x55/0x29e
                        [<c0178e62>] sys_ioctl+0x33/0x69
                        [<c01041aa>] sysenter_past_esp+0x5f/0x99
                        [<ffffffff>] 0xffffffff
   softirq-on-W at:
                        [<c0138d09>] __lock_acquire+0x767/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c0452ff3>] _spin_lock+0x35/0x42
                        [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                        [<c01480fd>] free_irq+0x11b/0x146
                        [<de84ed59>] rtl8139_close+0x8a/0x14a [8139too]
                        [<c03bde63>] dev_close+0x57/0x74
                        [<c03bce65>] dev_change_flags+0x8e/0x190
                        [<c03fd37c>] devinet_ioctl+0x4af/0x652
                        [<c03fdc62>] inet_ioctl+0x56/0x71
                        [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                        [<c0178b42>] do_ioctl+0x22/0x71
                        [<c0178be6>] vfs_ioctl+0x55/0x29e
                        [<c0178e62>] sys_ioctl+0x33/0x69
                        [<c01041aa>] sysenter_past_esp+0x5f/0x99
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c0138ce0>] __lock_acquire+0x73e/0x11ac
                        [<c01397e7>] lock_acquire+0x99/0xb2
                        [<c0452ff3>] _spin_lock+0x35/0x42
                        [<de84d6e0>] rtl8139_interrupt+0x27/0x46b [8139too]
                        [<c01480fd>] free_irq+0x11b/0x146
                        [<de84ed59>] rtl8139_close+0x8a/0x14a [8139too]
                        [<c03bde63>] dev_close+0x57/0x74
                        [<c03bce65>] dev_change_flags+0x8e/0x190
                        [<c03fd37c>] devinet_ioctl+0x4af/0x652
                        [<c03fdc62>] inet_ioctl+0x56/0x71
                        [<c03b1dba>] sock_ioctl+0xa5/0x1d4
                        [<c0178b42>] do_ioctl+0x22/0x71
                        [<c0178be6>] vfs_ioctl+0x55/0x29e
                        [<c0178e62>] sys_ioctl+0x33/0x69
                        [<c01041aa>] sysenter_past_esp+0x5f/0x99
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<de852390>] __key.20003+0x0/0xffffd291 [8139too]

stack backtrace:
 [<c0104869>] show_trace_log_lvl+0x1a/0x30
 [<c01053ad>] show_trace+0x12/0x14
 [<c0105515>] dump_stack+0x15/0x17
 [<c0136d72>] print_irq_inversion_bug+0x101/0x123
 [<c01376c1>] check_usage_forwards+0x3e/0x45
 [<c0137877>] mark_lock+0x1af/0x70c
 [<c0138c94>] __lock_acquire+0x6f2/0x11ac
 [<c01397e7>] lock_acquire+0x99/0xb2
 [<c0452ff3>] _spin_lock+0x35/0x42
 [<c03cbe79>] dev_watchdog+0x17/0xcc
 [<c0122587>] run_timer_softirq+0x14b/0x1a9
 [<c011ee12>] __do_softirq+0x5b/0xb2
 [<c011eeb6>] do_softirq+0x4d/0x4f
 [<c011f19b>] irq_exit+0x48/0x4a
 [<c0105a18>] do_IRQ+0x98/0xd0
 [<c010441e>] common_interrupt+0x2e/0x34
 [<c0453922>] error_code+0x6a/0x70
 =======================
Clocksource tsc unstable (delta = 9373003303 ns)



Really no idea who to CC here ;)

Regards,

	Mariusz
