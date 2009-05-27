Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbZE0Sdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbZE0Sdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZE0SdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:33:24 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:45694 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZE0SdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:33:22 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: LOCK prefix on uni processor has its use
Date: Wed, 27 May 2009 13:33:18 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <87vdnmmnac.fsf@basil.nowhere.org> <200905271322.41768.lkml@morethan.org>
In-Reply-To: <200905271322.41768.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271333.21304.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Michael S. Zick wrote:
> On Wed May 27 2009, Andi Kleen wrote:
> > Harald Welte <HaraldWelte@viatech.com> writes:
> > > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> > >   interfering with a read-modify-write sequence
> > 
> > In theory yes, but not in Linux -- normal drivers simply don't use LOCK in any way
> > on a UP kernel.
> > 
> > We discussed exactly this in the earlier subthread :)
> > 
> > > Now the question is: Is this a valid operation of a driver?  Should the driver
> > > do such things, or is such a driver broken? 
> > 
> > The driver is broken because if it relies on this it will not work on a UP kernel.
> > Also it's not portable and in general a bad idea.
> > 
> > > When would that occur?  I'm trying
> > > to come up with a case, but typically you e.g. allocate some DMA buffer and
> > > then don't touch it until the hardware has processed it.
> > 
> > Is it known which driver has this problem?
> > 
> > -Andi (who finds hpa's "timing theory" to be more believable anyways)
> > 
> 
> I still have not come up with a solid, testable, theory to explain the
> order of magnitude in up-time before the kernel locks with/with-out 'lock'.
> 
> But we are definitely pecking around the edges of the problem.  ;)
> 
> Today's lockdep build has just passed its previous record by hard-coding
> the pci cache line size to be the same as the cpu's cache line size. (a WAFG).
> Until we hear back from the VIA-CPU people, I just guessed that since the
> chip set was designed for use with the processor...
> 

Ah, so - some information - - - 
(caused by un-plug/re-plug usb mouse while ehci-hcd was caught in its failure
reporting loop)

ehci_hcd 0000:00:10.4: port 6 resume error -19
hub 1-0:1.0: hub_port_status failed (err = -32)
hub 1-0:1.0: connect-debounce failed, port 6 disabled
hub 1-0:1.0: over-current change on port 1
ehci_hcd 0000:00:10.4: HC died; cleaning up
irq 23: nobody cared (try booting with the "irqpoll" option)
Pid: 2277, comm: syslogd Not tainted 2.6.30-rc7-ce1200v-09147lk-db #29
Call Trace:
 [<c015de14>] ? __report_bad_irq+0x24/0x90
 [<c015dfc5>] ? note_interrupt+0x145/0x180
 [<c015e39f>] ? handle_fasteoi_irq+0xaf/0xe0
 [<c0104eb7>] ? handle_irq+0x17/0x20
 [<c0104daa>] ? do_IRQ+0x3a/0xa0
 [<c0145a8b>] ? trace_hardirqs_on_caller+0x6b/0x170
 [<c01034ae>] ? common_interrupt+0x2e/0x34
 [<c0126082>] ? __do_softirq+0x42/0x110
 [<c0141294>] ? tick_program_event+0x14/0x20
 [<c01384cc>] ? hrtimer_interrupt+0xcc/0x1d0
 [<c0126195>] ? do_softirq+0x45/0x50
 [<c01264aa>] ? irq_exit+0x6a/0x80
 [<c0111109>] ? smp_apic_timer_interrupt+0x49/0x80
 [<c0103517>] ? apic_timer_interrupt+0x2f/0x34
 [<c014799e>] ? lock_acquire+0x8e/0xa0
 [<c01f4b8a>] ? start_this_handle+0x6a/0x3c0
 [<c05307bd>] ? _spin_lock+0x3d/0x70
 [<c01f4b8a>] ? start_this_handle+0x6a/0x3c0
 [<c01f4b8a>] ? start_this_handle+0x6a/0x3c0
 [<c018b598>] ? kmem_cache_alloc+0x98/0x100
 [<c0143c06>] ? lockdep_init_map+0x46/0x130
 [<c01f4f80>] ? journal_start+0xa0/0x100
 [<c0163780>] ? grab_cache_page_write_begin+0x30/0xc0
 [<c0138fb4>] ? up_read+0x14/0x30
 [<c01da348>] ? ext3_write_begin+0x98/0x200
 [<c0163a48>] ? generic_file_buffered_write+0x108/0x300
 [<c0125943>] ? current_fs_time+0x13/0x20
 [<c016526a>] ? __generic_file_aio_write_nolock+0x24a/0x550
 [<c052f520>] ? __mutex_lock_common+0x2f0/0x3f0
 [<c01655b9>] ? generic_file_aio_write+0x49/0xd0
 [<c01655ce>] ? generic_file_aio_write+0x5e/0xd0
 [<c0146359>] ? validate_chain+0xe9/0x1000
 [<c01d8680>] ? ext3_file_write+0x30/0xc0
 [<c01d8650>] ? ext3_file_write+0x0/0xc0
 [<c018e47f>] ? do_sync_readv_writev+0xbf/0x100
 [<c0144dae>] ? lock_release_holdtime+0x6e/0xf0
 [<c0135230>] ? autoremove_wake_function+0x0/0x50
 [<c017606f>] ? might_fault+0x4f/0xa0
 [<c0225c3c>] ? security_file_permission+0xc/0x10
 [<c018e746>] ? rw_verify_area+0x66/0xd0
 [<c018e30e>] ? rw_copy_check_uvector+0x7e/0x100
 [<c018f30a>] ? do_readv_writev+0xaa/0x190
 [<c01d8650>] ? ext3_file_write+0x0/0xc0
 [<c018f42c>] ? vfs_writev+0x3c/0x50
 [<c018f527>] ? sys_writev+0x47/0x80
 [<c0102e08>] ? sysenter_do_call+0x12/0x36
handlers:
[<c035d480>] (usb_hcd_irq+0x0/0x90)
Disabling IRQ #23
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: connect-debounce failed, port 1 disabled
hub 1-0:1.0: cannot disable port 1 (err = -19)
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: hub_port_status failed (err = -19)
usb 1-5: USB disconnect, address 3
ehci_hcd 0000:00:10.4: force halt; handhake dc724014 00004000 00004000 -> -19

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc7-ce1200v-09147lk-db #29
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
hd-audio0/51 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&irq_desc_lock_class){?.-...}, at: [<c015dc81>] try_one_irq+0x21/0x130
{IN-HARDIRQ-W} state was registered at:
  [<ffffffff>] 0xffffffff
irq event stamp: 95629480
hardirqs last  enabled at (95629480): [<c05310a0>] _spin_unlock_irq+0x20/0x40
hardirqs last disabled at (95629479): [<c053086d>] _spin_lock_irq+0xd/0x70
softirqs last  enabled at (95626922): [<c0126195>] do_softirq+0x45/0x50
softirqs last disabled at (95629475): [<c0126195>] do_softirq+0x45/0x50

other info that might help us debug this:
3 locks held by hd-audio0/51:
 #0:  ((bus->workq_name)){+.+...}, at: [<c0131912>] worker_thread+0x192/0x2d0
 #1:  (&chip->irq_pending_work){+.+...}, at: [<c0131912>] worker_thread+0x192/0x2d0
 #2:  (kernel/irq/spurious.c:21){+.-...}, at: [<c012a4d0>] run_timer_softirq+0xe0/0x1f0

stack backtrace:
Pid: 51, comm: hd-audio0 Not tainted 2.6.30-rc7-ce1200v-09147lk-db #29
Call Trace:
 [<c0145254>] ? print_usage_bug+0x174/0x1c0
 [<c014583b>] ? mark_lock+0x59b/0x5d0
 [<c01463b8>] ? validate_chain+0x148/0x1000
 [<c0144fc0>] ? check_usage_backwards+0x0/0x90
 [<c01474a7>] ? __lock_acquire+0x237/0x6a0
 [<c014798b>] ? lock_acquire+0x7b/0xa0
 [<c015dc81>] ? try_one_irq+0x21/0x130
 [<c05307bd>] ? _spin_lock+0x3d/0x70
 [<c015dc81>] ? try_one_irq+0x21/0x130
 [<c015dc81>] ? try_one_irq+0x21/0x130
 [<c015ddd3>] ? poll_spurious_irqs+0x43/0x60
 [<c012a55b>] ? run_timer_softirq+0x16b/0x1f0
 [<c012a4d0>] ? run_timer_softirq+0xe0/0x1f0
 [<c015dd90>] ? poll_spurious_irqs+0x0/0x60
 [<c01260a8>] ? __do_softirq+0x68/0x110
 [<c0141294>] ? tick_program_event+0x14/0x20
 [<c01384cc>] ? hrtimer_interrupt+0xcc/0x1d0
 [<c0126195>] ? do_softirq+0x45/0x50
 [<c01264aa>] ? irq_exit+0x6a/0x80
 [<c0111109>] ? smp_apic_timer_interrupt+0x49/0x80
 [<c0103517>] ? apic_timer_interrupt+0x2f/0x34
 [<c05310a6>] ? _spin_unlock_irq+0x26/0x40
 [<c0419422>] ? azx_irq_pending_work+0x92/0x120
 [<c0131912>] ? worker_thread+0x192/0x2d0
 [<c0419390>] ? azx_irq_pending_work+0x0/0x120
 [<c0131975>] ? worker_thread+0x1f5/0x2d0
 [<c0131912>] ? worker_thread+0x192/0x2d0
 [<c0135230>] ? autoremove_wake_function+0x0/0x50
 [<c0131780>] ? worker_thread+0x0/0x2d0
 [<c0134ee7>] ? kthread+0x47/0x80
 [<c0134ea0>] ? kthread+0x0/0x80
 [<c0103627>] ? kernel_thread_helper+0x7/0x10

Enjoy

