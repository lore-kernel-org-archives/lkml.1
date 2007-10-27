Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbXJ0FVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbXJ0FVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXJ0FVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:21:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:36056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751575AbXJ0FVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:21:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6sgNOPxj6jp9jMXXY0KrNuaGdhu5MGwGvdZceP6
	tbDntxoN74m0LB
Subject: [2.6.23-rt3] NMI watchdog trace of deadlock
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1193245634.20679.8.camel@localhost.localdomain>
References: <1193245634.20679.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 07:21:34 +0200
Message-Id: <1193462494.25330.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

For quite a while now, RT kernels have been locking up on me
occasionally while my back is turned.  Yesterday, the little bugger
finally pounced while my serial console box was up and waiting.

[10138.162953] WARNING: at arch/i386/kernel/smp.c:581 native_smp_call_function_mask()
[10138.170583]  [<c01051da>] show_trace_log_lvl+0x1a/0x30
[10138.175796]  [<c0105de3>] show_trace+0x12/0x14
[10138.180291]  [<c0105dfb>] dump_stack+0x16/0x18
[10138.184769]  [<c011609f>] native_smp_call_function_mask+0x138/0x13d
[10138.191117]  [<c0117606>] smp_call_function+0x1e/0x24
[10138.196210]  [<c012f85c>] on_each_cpu+0x25/0x50
[10138.200807]  [<c0115c74>] flush_tlb_all+0x1e/0x20
[10138.205553]  [<c016caaf>] kmap_high+0x1b6/0x417
[10138.210118]  [<c011ec88>] kmap+0x4d/0x4f
[10138.214102]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
[10138.220163]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
[10138.225352]  [<c01a2b09>] bio_endio+0x42/0x6d
[10138.229769]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
[10138.235682]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
[10138.241052]  [<c0365943>] ide_end_request+0x55/0x10a
[10138.246058]  [<c036dae3>] ide_dma_intr+0x6f/0xac
[10138.250727]  [<c0366d83>] ide_intr+0x93/0x1e0
[10138.255125]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9
[10138.260113]  [<c015bcfd>] do_irqd+0x1fc/0x2ef
[10138.264514]  [<c013cdb2>] kthread+0x39/0x5b
[10138.268740]  [<c0104e33>] kernel_thread_helper+0x7/0x14
[10138.274006]  =======================
[10149.157158] NMI watchdog detected lockup on CPU#0 (5/5)
[10149.162445] 
[10149.163943] Pid: 880, comm:               IRQ-14
[10149.168612] EIP: 0060:[<c04c1ccf>] CPU: 0
[10149.172666] EIP is at __spin_lock+0x16/0x1f
[10149.176909]  EFLAGS: 00000086    Not tainted  (2.6.23.1-rt3-smp #117)
[10149.183403] EAX: c0640b00 EBX: 00000003 ECX: c060fc24 EDX: dff2b000
[10149.189751] ESI: c01161be EDI: 00000000 EBP: dff2bce4 DS: 007b ES: 007b FS: 00d8
[10149.197252] CR0: 8005003b CR2: b658217b CR3: 01a71000 CR4: 000006d0
[10149.203574] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[10149.209896] DR6: ffff0ff0 DR7: 00000400
[10149.213766]  [<c01051da>] show_trace_log_lvl+0x1a/0x30
[10149.218979]  [<c0105de3>] show_trace+0x12/0x14
[10149.223440]  [<c0102b27>] show_regs+0x1c4/0x1cb
[10149.228021]  [<c0118978>] nmi_watchdog_tick+0x1a5/0x226
[10149.233321]  [<c01062fd>] do_nmi+0x85/0x25f
[10149.237547]  [<c04c229b>] nmi_stack_correct+0x26/0x2b
[10149.242649]  [<c0115f8c>] native_smp_call_function_mask+0x25/0x13d
[10149.248893]  [<c0117606>] smp_call_function+0x1e/0x24
[10149.254002]  [<c012f85c>] on_each_cpu+0x25/0x50
[10149.258575]  [<c0115c74>] flush_tlb_all+0x1e/0x20
[10149.263331]  [<c016caaf>] kmap_high+0x1b6/0x417
[10149.267919]  [<c011ec88>] kmap+0x4d/0x4f
[10149.271878]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
[10149.277949]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
[10149.283120]  [<c01a2b09>] bio_endio+0x42/0x6d
[10149.287527]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
[10149.293417]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
[10149.298785]  [<c0365943>] ide_end_request+0x55/0x10a
[10149.303816]  [<c036dae3>] ide_dma_intr+0x6f/0xac
[10149.308521]  [<c0366d83>] ide_intr+0x93/0x1e0
[10149.312927]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9
[10149.317977]  [<c015bcfd>] do_irqd+0x1fc/0x2ef
[10149.322343]  [<c013cdb2>] kthread+0x39/0x5b
[10149.326568]  [<c0104e33>] kernel_thread_helper+0x7/0x14
[10149.331843]  =======================
[10150.156614] NMI show regs on CPU#1:
[10150.156616] NMI watchdog running again ...
[10150.164292] apic_timer_irqs: 3289514
[10150.167894] 
[10150.169403] Pid: 6317, comm:               smpppd
[10150.174157] EIP: 0060:[<c0115ffe>] CPU: 1
[10150.178203] EIP is at native_smp_call_function_mask+0x97/0x13d
[10150.184074]  EFLAGS: 00200202    Not tainted  (2.6.23.1-rt3-smp #117)
[10150.190594] EAX: ffffb300 EBX: 00000001 ECX: 00000001 EDX: 000008fb
[10150.196899] ESI: 00000001 EDI: 00000000 EBP: f69a4c6c DS: 007b ES: 007b FS: 00d8
[10150.204339] CR0: 8005003b CR2: b7f91000 CR3: 37221000 CR4: 000006d0
[10150.210636] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[10150.216940] DR6: ffff0ff0 DR7: 00000400
[10150.220784]  [<c01051da>] show_trace_log_lvl+0x1a/0x30
[10150.225980]  [<c0105de3>] show_trace+0x12/0x14
[10150.230502]  [<c0102b27>] show_regs+0x1c4/0x1cb
[10150.235084]  [<c01187c2>] irq_show_regs_callback+0x63/0x74
[10150.240668]  [<c011885a>] nmi_watchdog_tick+0x87/0x226
[10150.245856]  [<c01062fd>] do_nmi+0x85/0x25f
[10150.250074]  [<c04c229b>] nmi_stack_correct+0x26/0x2b
[10150.255201]  [<c0117606>] smp_call_function+0x1e/0x24
[10150.260336]  [<c012f85c>] on_each_cpu+0x25/0x50
[10150.264908]  [<c0115c74>] flush_tlb_all+0x1e/0x20
[10150.269706]  [<c016caaf>] kmap_high+0x1b6/0x417
[10150.274297]  [<c011ec88>] kmap+0x4d/0x4f
[10150.278289]  [<c0165b94>] get_page_from_freelist+0x247/0x32e
[10150.284023]  [<c0165cd9>] __alloc_pages+0x5e/0x2da
[10150.288863]  [<c016ec4e>] handle_mm_fault+0x368/0x62f
[10150.293991]  [<c011de93>] do_page_fault+0x180/0x61d
[10150.298919]  [<c04c21f2>] error_code+0x72/0x78
[10150.303422]  [<c02d5024>] copy_to_user+0x2a/0x36
[10150.308089]  [<c0199845>] seq_read+0x19b/0x296
[10150.312593]  [<c01b4dcb>] proc_reg_read+0x57/0x78
[10150.317374]  [<c018116f>] vfs_read+0x89/0x11d
[10150.321791]  [<c01815e1>] sys_read+0x3d/0x64
[10150.326095]  [<c0104242>] syscall_call+0x7/0xb
[10150.330608]  =======================


