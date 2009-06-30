Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZF3V6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZF3V6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZF3V6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:58:08 -0400
Received: from mail.open.by ([193.232.92.17]:53264 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZF3V6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:58:05 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8889 [Jun 30 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {HEADERS: header Content-Type found without required header Content-Transfer-Encoding}
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 1 Jul 2009 00:59:49 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090630215949.GA3194@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
 <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
 <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
 <20090629162853.GB3461@localdomain.by>
 <20090629221509.1d307184@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629221509.1d307184@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

rc1-git6. Hope this will help.


dmesg | ./scripts/markup_oops.pl

 	*__get_cpu_var(tasklet_vec).tail = t; 
 	__get_cpu_var(tasklet_vec).tail = &(t->next); 
 	raise_softirq_irqoff(TASKLET_SOFTIRQ); 
 	local_irq_restore(flags); 
 c104c4fb:	f7 c6 00 02 00 00    	test   $0x200,%esi 
 c104c501:	74 1d                	je     c104c520 <__tasklet_schedule+0x80> 
 c104c503:	e8 78 b5 02 00       	call   c1077a80 <trace_hardirqs_on> 
 	return flags; 
 } 
  
 static inline void native_restore_fl(unsigned long flags) 
 { 
 	asm volatile("push %0 ; popf" 
 c104c508:	56                   	push   %esi                |  %esi => 200246 
 c104c509:	9d                   	popf    
 } 
*c104c50a:	8b 45 f4             	mov    -0xc(%ebp),%eax     |  %eax = 0 <--- faulting instruction
 c104c50d:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax 
 c104c514:	75 13                	jne    c104c529 <__tasklet_schedule+0x89> 
 c104c516:	83 c4 04             	add    $0x4,%esp 
 c104c519:	5b                   	pop    %ebx 
 c104c51a:	5e                   	pop    %esi 
 c104c51b:	c9                   	leave   
 c104c51c:	c3                   	ret     
 c104c51d:	8d 76 00             	lea    0x0(%esi),%esi 
 c104c520:	56                   	push   %esi 
 c104c521:	9d                   	popf    
 	local_irq_save(flags); 
 	t->next = NULL; 
 	*__get_cpu_var(tasklet_vec).tail = t; 
 	__get_cpu_var(tasklet_vec).tail = &(t->next); 
 	raise_softirq_irqoff(TASKLET_SOFTIRQ); 
 	local_irq_restore(flags); 
 c104c522:	e8 29 7d 02 00       	call   c1074250 <trace_hardirqs_off> 
 c104c527:	eb e1                	jmp    c104c50a <__tasklet_schedule+0x6a> 
 } 
 c104c529:	e8 c2 85 ff ff       	call   c1044af0 <__stack_chk_fail> 
 c104c52e:	66 90                	xchg   %ax,%ax 
  
 c104c530 <raise_softirq>: 
 	if (!in_interrupt())



syslog:

kernel: [47080.294012] BUG: scheduling while atomic: pptpgw/6053/0x10000400
kernel: [47080.294022] INFO: lockdep is turned off.
kernel: [47080.294028] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr psmouse snd i2c_i801 rng_core serio_raw soundcore snd_page_alloc
asus_laptop evdev sg usbhid sr_mod hid cdrom sd_mod ata_generic pata_acpi ata_piix ricoh_mmc sdhci_pci sdhci ide_pci_generic uhci_hcd mmc_core led_class ehci_hcd usbcore r8169 mii
kernel: [47080.294165] 
kernel: [47080.294175] Pid: 6053, comm: pptpgw Not tainted (2.6.31-rc1-dbgnv-git6 #1) F3JC                
kernel: [47080.294184] EIP: 0060:[<c104c50a>] EFLAGS: 00200246 CPU: 0
kernel: [47080.294198] EIP is at __tasklet_schedule+0x6a/0x90
kernel: [47080.294205] EAX: 00000000 EBX: c31cf17c ECX: 00000000 EDX: 00000000
kernel: [47080.294213] ESI: 00200246 EDI: 00000fff EBP: c3271e60 ESP: c3271e54
kernel: [47080.294220]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [47080.294228] CR0: 8005003b CR2: b7462000 CR3: 29de4000 CR4: 000006d0
kernel: [47080.294235] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [47080.294242] DR6: ffff0ff0 DR7: 00000400
kernel: [47080.294248] Call Trace:
kernel: [47080.294263]  [<f80b238b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [47080.294276]  [<c12dea72>] tty_wakeup+0x72/0x90
kernel: [47080.294287]  [<c12e7603>] pty_unthrottle+0x23/0x50
kernel: [47080.294296]  [<c12e4072>] tty_unthrottle+0x42/0x70
kernel: [47080.294306]  [<c12e254f>] n_tty_read+0x48f/0x730
kernel: [47080.294320]  [<c1039f20>] ? default_wake_function+0x0/0x40
kernel: [47080.294332]  [<c12dd1b0>] tty_read+0xa0/0xe0
kernel: [47080.294341]  [<c12e20c0>] ? n_tty_read+0x0/0x730
kernel: [47080.294352]  [<c10fb30b>] vfs_read+0xbb/0x1c0
kernel: [47080.294362]  [<c12dd110>] ? tty_read+0x0/0xe0
kernel: [47080.294372]  [<c10fbad8>] sys_read+0x58/0xa0
kernel: [47080.294383]  [<c100339b>] sysenter_do_call+0x12/0x32
kernel: [47080.294401] BUG: scheduling while atomic: pptpgw/6053/0x00000400
kernel: [47080.294408] INFO: lockdep is turned off.
kernel: [47080.294413] Modules linked in: ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr psmouse snd i2c_i801 rng_core serio_raw soundcore snd_page_alloc
asus_laptop evdev sg usbhid sr_mod hid cdrom sd_mod ata_generic pata_acpi ata_piix ricoh_mmc sdhci_pci sdhci ide_pci_generic uhci_hcd mmc_core led_class ehci_hcd usbcore r8169 mii
kernel: [47080.294548] 
kernel: [47080.294555] Pid: 6053, comm: pptpgw Not tainted (2.6.31-rc1-dbgnv-git6 #1) F3JC                
kernel: [47080.294564] EIP: 0060:[<c104c50a>] EFLAGS: 00200246 CPU: 0
kernel: [47080.294572] EIP is at __tasklet_schedule+0x6a/0x90
kernel: [47080.294579] EAX: 00000000 EBX: c31cf17c ECX: 00000000 EDX: 00000000
kernel: [47080.294586] ESI: 00200246 EDI: 00000fff EBP: c3271e60 ESP: c3271e54
kernel: [47080.294593]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [47080.294600] CR0: 8005003b CR2: b7462000 CR3: 29de4000 CR4: 000006d0
kernel: [47080.294607] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
kernel: [47080.294614] DR6: ffff0ff0 DR7: 00000400
kernel: [47080.294619] Call Trace:
kernel: [47080.294631]  [<f80b238b>] ppp_asynctty_wakeup+0x6b/0x80 [ppp_async]
kernel: [47080.294641]  [<c12dea72>] tty_wakeup+0x72/0x90
kernel: [47080.294651]  [<c12e7603>] pty_unthrottle+0x23/0x50
kernel: [47080.294661]  [<c12e4072>] tty_unthrottle+0x42/0x70
kernel: [47080.294670]  [<c12e254f>] n_tty_read+0x48f/0x730
kernel: [47080.294683]  [<c1039f20>] ? default_wake_function+0x0/0x40
kernel: [47080.294695]  [<c12dd1b0>] tty_read+0xa0/0xe0
kernel: [47080.294704]  [<c12e20c0>] ? n_tty_read+0x0/0x730
kernel: [47080.294714]  [<c10fb30b>] vfs_read+0xbb/0x1c0
kernel: [47080.294724]  [<c12dd110>] ? tty_read+0x0/0xe0
kernel: [47080.294733]  [<c10fbad8>] sys_read+0x58/0xa0
kernel: [47080.294744]  [<c100339b>] sysenter_do_call+0x12/0x32
pptp[6064]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
kernel: [47113.649464] INFO: RCU detected CPU 1 stall (t=14044096/3000 jiffies)
kernel: [47113.649464] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47113.649464] Call Trace:
kernel: [47113.649464]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47113.649464]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47113.649464]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47113.649464]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47113.649464]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47113.649464]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47113.649464]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47113.649464]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47113.649464]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47113.649464]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47113.649464]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47113.649464]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47113.649464]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47113.649464]  [<c1257c46>] ? delay_tsc+0x26/0x80
kernel: [47113.649464]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47113.649464]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47113.649464]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47113.649464]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47113.649464]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47113.649464]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47113.649464]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47113.649464]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47113.649464]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47113.649464]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47113.649464]  [<c100339b>] sysenter_do_call+0x12/0x32
/USR/SBIN/CRON[6450]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
kernel: [47143.649461] INFO: RCU detected CPU 1 stall (t=14053096/12000 jiffies)
kernel: [47143.649461] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47143.649461] Call Trace:
kernel: [47143.649461]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47143.649461]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47143.649461]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47143.649461]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47143.649461]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47143.649461]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47143.649461]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47143.649461]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47143.649461]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47143.649461]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47143.649461]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47143.649461]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47143.649461]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47143.649461]  [<c1257c65>] ? delay_tsc+0x45/0x80
kernel: [47143.649461]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47143.649461]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47143.649461]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47143.649461]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47143.649461]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47143.649461]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47143.649461]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47143.649461]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47143.649461]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47143.649461]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47143.649461]  [<c100339b>] sysenter_do_call+0x12/0x32
pptp[6064]: anon log[logecho:pptp_ctrl.c:677]: Echo Reply received.
pptp[6064]: anon log[logecho:pptp_ctrl.c:679]: no more Echo Reply/Request packets will be reported.
kernel: [47173.649458] INFO: RCU detected CPU 1 stall (t=14062096/21000 jiffies)
kernel: [47173.649458] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47173.649458] Call Trace:
kernel: [47173.649458]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47173.649458]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47173.649458]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47173.649458]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47173.649458]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47173.649458]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47173.649458]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47173.649458]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47173.649458]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47173.649458]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47173.649458]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47173.649458]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47173.649458]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47173.649458]  [<c1257c65>] ? delay_tsc+0x45/0x80
kernel: [47173.649458]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47173.649458]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47173.649458]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47173.649458]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47173.649458]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47173.649458]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47173.649458]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47173.649458]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47173.649458]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47173.649458]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47173.649458]  [<c100339b>] sysenter_do_call+0x12/0x32
kernel: [47203.649454] INFO: RCU detected CPU 1 stall (t=14071096/30000 jiffies)
kernel: [47203.649456] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47203.649456] Call Trace:
kernel: [47203.649456]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47203.649456]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47203.649456]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47203.649456]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47203.649456]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47203.649456]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47203.649456]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47203.649456]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47203.649456]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47203.649456]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47203.649456]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47203.649456]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47203.649456]  [<c1257c65>] ? delay_tsc+0x45/0x80
kernel: [47203.649456]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47203.649456]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47203.649456]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47203.649456]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47203.649456]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47203.649456]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47203.649456]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47203.649456]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47203.649456]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47203.649456]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47203.649456]  [<c100339b>] sysenter_do_call+0x12/0x32
kernel: [47233.649451] INFO: RCU detected CPU 1 stall (t=14080096/39000 jiffies)
kernel: [47233.649452] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47233.649452] Call Trace:
kernel: [47233.649452]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47233.649452]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47233.649452]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47233.649452]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47233.649452]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47233.649452]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47233.649452]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47233.649452]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47233.649452]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47233.649452]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47233.649452]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47233.649452]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47233.649452]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47233.649452]  [<c1257c63>] ? delay_tsc+0x43/0x80
kernel: [47233.649452]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47233.649452]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47233.649452]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47233.649452]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47233.649452]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47233.649452]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47233.649452]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47233.649452]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47233.649452]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47233.649452]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47233.649452]  [<c100339b>] sysenter_do_call+0x12/0x32
kernel: [47263.649448] INFO: RCU detected CPU 1 stall (t=14089096/48000 jiffies)
kernel: [47263.649449] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47263.649449] Call Trace:
kernel: [47263.649449]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47263.649449]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47263.649449]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47263.649449]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47263.649449]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47263.649449]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47263.649449]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47263.649449]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47263.649449]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47263.649449]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47263.649449]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47263.649449]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47263.649449]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47263.649449]  [<c1257c65>] ? delay_tsc+0x45/0x80
kernel: [47263.649449]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47263.649449]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47263.649449]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47263.649449]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47263.649449]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47263.649449]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47263.649449]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47263.649449]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47263.649449]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47263.649449]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47263.649449]  [<c100339b>] sysenter_do_call+0x12/0x32
kernel: [47293.649445] INFO: RCU detected CPU 1 stall (t=14098096/57000 jiffies)
kernel: [47293.649446] Pid: 6052, comm: pppd Not tainted 2.6.31-rc1-dbgnv-git6 #1
kernel: [47293.649446] Call Trace:
kernel: [47293.649446]  [<c1417a58>] ? printk+0x23/0x36
kernel: [47293.649446]  [<c10a8220>] __rcu_pending+0x140/0x210
kernel: [47293.649446]  [<c10a831a>] rcu_pending+0x2a/0x70
kernel: [47293.649446]  [<c1051bdf>] update_process_times+0x3f/0x80
kernel: [47293.649446]  [<c10714df>] tick_sched_timer+0x6f/0xf0
kernel: [47293.649446]  [<c10640f6>] __run_hrtimer+0x56/0xe0
kernel: [47293.649446]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47293.649446]  [<c1071470>] ? tick_sched_timer+0x0/0xf0
kernel: [47293.649446]  [<c1064af5>] hrtimer_interrupt+0x145/0x270
kernel: [47293.649446]  [<c1070ea6>] ? tick_program_event+0x36/0x60
kernel: [47293.649446]  [<c101c4bc>] smp_apic_timer_interrupt+0x5c/0xb0
kernel: [47293.649446]  [<c12582b8>] ? trace_hardirqs_off_thunk+0xc/0x14
kernel: [47293.649446]  [<c1003e36>] apic_timer_interrupt+0x36/0x3c
kernel: [47293.649446]  [<c1257c48>] ? delay_tsc+0x28/0x80
kernel: [47293.649446]  [<c1257ba8>] __delay+0x18/0x30
kernel: [47293.649446]  [<c125d956>] _raw_spin_lock+0xf6/0x170
kernel: [47293.649446]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47293.649446]  [<c141b3d2>] _spin_lock_bh+0x62/0x90
kernel: [47293.649446]  [<f8097e94>] ? ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47293.649446]  [<f8097e94>] ppp_channel_push+0x24/0xd0 [ppp_generic]
kernel: [47293.649446]  [<f8098057>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [47293.649446]  [<c10fafae>] vfs_write+0xbe/0x1c0
kernel: [47293.649446]  [<f8097f80>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [47293.649446]  [<c10fba38>] sys_write+0x58/0xa0
kernel: [47293.649446]  [<c100339b>] sysenter_do_call+0x12/0x32


	Sergey
