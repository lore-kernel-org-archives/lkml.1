Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYGEUwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYGEUwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 16:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYGEUwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 16:52:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbYGEUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 16:52:04 -0400
Date: Sat, 5 Jul 2008 13:51:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dbrownell@users.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
In-Reply-To: <200807051108.20183.arvidjaar@mail.ru>
Message-ID: <alpine.LFD.1.10.0807051317450.2815@woody.linux-foundation.org>
References: <200807051108.20183.arvidjaar@mail.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem seems to be:

On Sat, 5 Jul 2008, Andrey Borzenkov wrote:
> [   58.320025] modprobe      R running      0  1054   1053
> [   58.320025]        00000000 de094560 00000000 deae9c48 00000046 c02e9588 deae9be8 c013b68d 
> [   58.320025]        de094560 00000000 00000000 000002db 00000246 00000046 deae9c10 c0104a28 
> [   58.320025]        deae9000 deae9c20 00000000 c0158120 deae9c18 c0121115 deae9c40 c0104c1d 
> [   58.320025] Call Trace:
> [   58.320025]  [<c02e9588>] ? mutex_unlock+0x8/0x10
> [   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
> [   58.320025]  [<c0104a28>] ? do_softirq+0x38/0xd0
> [   58.320025]  [<c0158120>] ? handle_level_irq+0x0/0xe0
> [   58.320025]  [<c0121115>] ? irq_exit+0x65/0x90
> [   58.320025]  [<c0104c1d>] ? do_IRQ+0x9d/0x110
> [   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
> [   58.320025]  [<c010342e>] ? common_interrupt+0x2e/0x34
> [   58.320025]  [<dfc5007b>] ? agp_3_5_enable+0x46b/0x7b0 [agpgart]
> [   58.320025]  [<c0130000>] ? __kfifo_put+0x60/0x90
> [   58.320025]  [<c02ea967>] ? _spin_unlock_irqrestore+0x37/0x60
> [   58.320025]  [<dfc752cb>] ? ohci_hub_status_data+0x26b/0x470 [ohci_hcd]
> [   58.320025]  [<c01c3528>] ? sysfs_add_file_mode+0x58/0x90
> [   58.320025]  [<df855d15>] ? usb_hcd_poll_rh_status+0x45/0x150 [usbcore]
> [   58.320025]  [<df8561f8>] ? usb_add_hcd+0x3d8/0x650 [usbcore]
> [   58.320025]  [<c027683f>] ? pcibios_set_master+0x1f/0x90
> [   58.320025]  [<df8617a1>] ? usb_hcd_pci_probe+0x131/0x2c0 [usbcore]
> [   58.320025]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
> [   58.320025]  [<df861670>] ? usb_hcd_pci_probe+0x0/0x2c0 [usbcore]
...

ie it looks like modprobe is stuck in some endless loop thanks to some 
OHCI probe thing.

There's a lot of other processes then in 'D' state. Some are waiting for 
some IO to complete, others look like they are waiting for some semaphore. 
But those issues look like they may be a secondary result of the primary 
issue (for example, softirq's aren't completing due to the lockup looking 
like it may be in a irq/softirq handler, and the semaphore they are 
waiting for seems to be the device layer semaphore that is held by the 
probing routine already)

There are in fact several runnable tasks, but only the above one is the 
one that seems to be actually hogging the CPU constantly:

> [   58.320026] runnable tasks:
> [   58.320026]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [   58.320026] ----------------------------------------------------------------------------------------------------------
> [   58.320026]       watchdog/0     4         1.212733         8     0         1.212733         0.393162         0.029773
> [   58.320026]         events/0     5     11120.115860       123   115     11120.115860         9.492749     52205.957266
> [   58.320026]        kblockd/0    39     11124.304754       744   115     11124.304754        36.535713     28226.864834
> [   58.320026]           kacpid    41     11100.368286         5   115     11100.368286         6.311670     43931.786247
> [   58.320026]            udevd   960     11149.105542       248   116     11149.105542       460.966881       258.525566
> [   58.320026] R       modprobe  1054     30153.604213        29   118     30153.604213     29795.168980      1057.612071
> [   58.320026]         modprobe  1066     11129.105542        83   118     11129.105542       174.110297      2749.024671
> [   58.320026]       udevsettle  1075     11120.368286        68   120     11120.368286        12.454980      3387.241480
> [   58.320026]         modprobe  1079     11123.455590        75   118     11123.455590        74.767454      3152.972631
> [   58.320026]         modprobe  1083     11122.877599        73   118     11122.877599        62.496969      2977.616936
> [   58.320026]            udevd  1253     11148.798902         2   118     11148.798902         1.495564         0.000000
> [   58.320026] 
> [   67.677809] SysRq : HELP : loglevel0-8 reBoot show-all-locks(D) tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
> [   77.361220] SysRq : Show Locks Held

It's also a bit sad that the core device infrastructure uses the old-style 
semaphores rather than mutexes, because if it used mutexes the "locks 
held" debugging would show those locks too. As it is, it is silent about 
it, and only points out some relatively uninteresting stuff. But that 
event lock is perhaps relevant:

> [   77.363356] Showing all locks held in the system:
> [   77.363356] 5 locks held by modprobe/1054:
> [   77.363356]  #0:  (&serio->lock){++..}, at: [<c0267d11>] serio_interrupt+0x21/0x80
> [   77.363356]  #1:  (&dev->event_lock){++..}, at: [<c026c498>] input_event+0x48/0x80
> [   77.363356]  #2:  (rcu_read_lock){..--}, at: [<c026ab80>] input_pass_event+0x0/0xb0
> [   77.363356]  #3:  (sysrq_key_table_lock){++..}, at: [<c025015a>] __handle_sysrq+0x1a/0x150
> [   77.363356]  #4:  (tasklist_lock){..??}, at: [<c013c157>] debug_show_all_locks+0x37/0x190

Anyway, the "show registers" one is the smoking gun, since it shows the 
same modprobe one still running, and still in that same area:

> [   96.044467] SysRq : Show Regs
> [   96.046699] 
> [   96.046699] Pid: 1054, comm: modprobe Not tainted (2.6.26-rc8-1avb #6)
> [   96.046699] EIP: 0060:[<c01215a3>] EFLAGS: 00000206 CPU: 0
> [   96.046699] EIP is at __do_softirq+0x43/0xc0
> [   96.046699] EAX: 000027d2 EBX: c0431400 ECX: 00000000 EDX: 00000001
> [   96.046699] ESI: 00000102 EDI: 0000000a EBP: c0406ff8 ESP: c0406fec
> [   96.046699]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   96.046699] CR0: 8005003b CR2: 080559cd CR3: 1e089000 CR4: 00000690
> [   96.046699] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   96.046699] DR6: ffff0ff0 DR7: 00000400
> [   96.046699]  [<c0104a7e>] do_softirq+0x8e/0xd0
> [   96.046699]  [<c0158120>] ? handle_level_irq+0x0/0xe0
> [   96.046699]  [<c0121115>] irq_exit+0x65/0x90
> [   96.046699]  [<c0104c1d>] do_IRQ+0x9d/0x110
> [   96.046699]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
> [   96.046699]  [<c010342e>] common_interrupt+0x2e/0x34
> [   96.046699]  [<dfc5007b>] ? agp_3_5_enable+0x46b/0x7b0 [agpgart]
> [   96.046699]  [<c0130000>] ? __kfifo_put+0x60/0x90
> [   96.046699]  [<c02ea967>] ? _spin_unlock_irqrestore+0x37/0x60
> [   96.046699]  [<dfc752cb>] ohci_hub_status_data+0x26b/0x470 [ohci_hcd]
> [   96.046699]  [<c01c3528>] ? sysfs_add_file_mode+0x58/0x90
> [   96.046699]  [<df855d15>] usb_hcd_poll_rh_status+0x45/0x150 [usbcore]
> [   96.046699]  [<df8561f8>] usb_add_hcd+0x3d8/0x650 [usbcore]
> [   96.046699]  [<c027683f>] ? pcibios_set_master+0x1f/0x90
> [   96.046699]  [<df8617a1>] usb_hcd_pci_probe+0x131/0x2c0 [usbcore]

It really looks lik it's some endless loop - possibly due to endless 
interrupts happening while in ohci_hub_status_data().

And I don't think this is due to the recently fixed IRQF_DISABLED bug. 
Admittedly, that bug would likely never show up on UP unless you have 
spinlock debugging enabled, which you obviously do have. That might 
explain why the Mandriva cooker kernel binary works for you. But if it's 
the IRQF_DISABLED thing, any lockup would probably show up as spinning 
recursively on a spinlock, which is not the case for you.

If it _is_ the IRQF_DISABLED bug, then it's fixed in commit 
de85422b94ddb23c021126815ea49414047c13dc, which isn't in any released -rc 
yet (I'm doing -rc9 today which will have it), but has been in the last 
few daily snapshots and obviously is in the current -git tree.

That said, it really looks like it's stuck in some endless loop in 
__do_softirq(). Not that that should be possible (there's an explicit 
loop limit there). So the only "endless" softirq thing would be if 
there are endless hardirqs re-raising it.

So it smells a bit like an interrupt flood to me.

Alan - if it _is_ an interrupt flood, it looks like it basically starts 
just as ohci_hub_status_data() does that spin_unlock_irqrestore() to 
re-enable interrupts. And there has been some changes to 
ohci_root_hub_state_changes() recently, and that OHCI_INTR_RHSC enable 
logic in particular.

That root hub status interrupt changing thing is commit e872154921a6b5 
("USB: don't explicitly reenable root-hub status interrupts"), and it 
_did_ happen after 2.6.25.

Hmm? Alan? Greg?

		Linus
