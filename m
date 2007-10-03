Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXJCSfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXJCSfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXJCSff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:35:35 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43531 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbXJCSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:35:34 -0400
Date: Wed, 03 Oct 2007 20:34:57 +0200 (CEST)
Message-Id: <20071003.203457.87343300.anders@bostrom.dyndns.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org, cebbert@redhat.com
Subject: Re: PROBLEM: high load average when idle
From: Anders =?iso-8859-1?Q?Bostr=F6m?= <anders@bostrom.dyndns.org>
In-Reply-To: <20071002150748.906970bc.akpm@linux-foundation.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
	<20071002150748.906970bc.akpm@linux-foundation.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.250.207.59
X-Scan-Result: No virus found in message 1Id94G-0005JR-6a.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Id94G-0005JR-6a 64fdd0c485b652638b494893b638aab0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AM" == Andrew Morton <akpm@linux-foundation.org> writes:

 AM> On Tue, 02 Oct 2007 23:37:31 +0200 (CEST)
 AM> Anders Bostr__m <anders@bostrom.dyndns.org> wrote:

 >> My computer suffers from high load average when the system is idle,
 >> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .
 >> 
 >> Long story:
 >> 
 >> 2.6.20 and all later versions I've tested, including 2.6.21 and
 >> 2.6.22, make the load average high. Even when the computer is totally
 >> idle (I've tested in single user mode), the load average end up
 >> at ~0.30. The computer is still responsive, and the only fault seems
 >> to be the too high load average. All versions up to and including
 >> 2.6.19.7 is fine, and don't suffer from the problem.
 >> 
 >> I git bisect between 2.6.19 and 2.6.20 gave me
 >> 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 "[PATCH] user of the jiffies
 >> rounding code: JBD" as the first patch with the
 >> problem. 2.6.20 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 reverted
 >> works fine. 2.6.23-rc8 with 44d306e1508fef6fa7a6eb15a1aba86ef68389a6
 >> reverted also works fine.
 >> 
 >> This fixes the problem:
 >> 
 >> -------------------------- fs/jbd/transaction.c -----------------------------
 >> index cceaf57..d38e0d5 100644
 >> @@ -55,7 +55,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
 >> spin_lock_init(&transaction->t_handle_lock);
 >> 
 >> /* Set up the commit timer for the new transaction. */
 >> -	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
 >> +	journal->j_commit_timer.expires = transaction->t_expires;
 >> add_timer(&journal->j_commit_timer);
 >> 
 >> J_ASSERT(journal->j_running_transaction == NULL);
 >> 
 >> 
 >> I've only seen this problem on my home desktop computer. My work
 >> desktop computer and several other computers at work don't suffer from
 >> this problem. However, all other computers I've tested on is using
 >> AMD64 as architecture, and not i386 as my home desktop computer.
 >> 
 >> Please let me know how I can assist in further debugging of this, if
 >> needed.

 AM> This is unexpected.  High load average is due to either a task chewing a
 AM> lot of CPU time or a task stuck in uninterruptible sleep.

 AM> Can you please work out which of these is happening?  Run `top' on an idle
 AM> system.  Is the CPU less than 1% loaded?

Yes, top typically show 99.3% idle .

 AM> Run

 AM> 	ps aux | grep " D"

 AM> or something like that on an idle system, see if you can spot a task which
 AM> is spending time in D state.

 AM> If there's a task whcih is spending time in D state, try running

 AM>  echo w > /proc/sysrq-trigger ; dmesg -c > foo

 AM> the check "foo" to see if it has a task in D state (search foo for " D "). 
 AM> If it's not there, do the sysrq again, repeat until you've managed to
 AM> capture a trace of the blocked task.

 AM> If it turns out that the CPU really is spending excess amounts of time
 AM> being busy then a kernel profile would be a good way of finding out where
 AM> it is spinning.  Or run sysrq-P from the keyboard a few times.

Well, there are some kernel threads in the D state. I've seen 
md1_raid1, kjournald and pdflush in the D state. I had a very hard
time trying the catch it to the "foo" file, but take a look at this:

SysRq : Show Blocked State

                         free                        sibling
  task             PC    stack   pid father child younger older
pdflush       D C157CC68     0   151      6           152   150 (L-TLB)
       dfebacd8 00000046 c151afa4 c157cc68 c0112559 00000000 0ee62d80 000000d5 
       0000000a dfeb7070 0ee62d80 000000d5 00000000 dfeb717c 00000000 00000000 
       c1580000 c1580000 c158013c 00000008 000000ff c02730ff 00000000 dfeb7070 
Call Trace:
 [<c0112559>] __wake_up_common+0x39/0x60
 [<c02730ff>] md_write_start+0x9f/0x110
 [<c01275a0>] autoremove_wake_function+0x0/0x50
 [<c026c58b>] make_request+0x3b/0x5e0
 [<c01b2231>] generic_make_request+0xe1/0x150
 [<c01b469e>] submit_bio+0x3e/0xb0
 [<c0170481>] bio_alloc_bioset+0x81/0x160
 [<c016f2b0>] end_buffer_async_write+0x0/0xc0
 [<c016d4c9>] submit_bh+0xb9/0x100
 [<c016e91f>] __block_write_full_page+0x16f/0x2d0
 [<c0172580>] blkdev_get_block+0x0/0x60
 [<c016ed10>] block_write_full_page+0xb0/0xe0
 [<c0172580>] blkdev_get_block+0x0/0x60
 [<c013a30e>] generic_writepages+0x20e/0x350
 [<c01717d0>] blkdev_writepage+0x0/0x10
 [<c013a47b>] do_writepages+0x2b/0x50
 [<c0169b2a>] __writeback_single_inode+0x8a/0x370
 [<c010d251>] smp_apic_timer_interrupt+0x41/0x50
 [<c016a141>] sync_sb_inodes+0x161/0x210
 [<c016a522>] writeback_inodes+0x62/0x80
 [<c013ac70>] pdflush+0x0/0x180
 [<c013a8d4>] wb_kupdate+0x74/0xe0
 [<c013ad35>] pdflush+0xc5/0x180
 [<c013a860>] wb_kupdate+0x0/0xe0
 [<c0127318>] kthread+0xa8/0xe0
 [<c0127270>] kthread+0x0/0xe0
 [<c010376b>] kernel_thread_helper+0x7/0x1c
 =======================
md2_raid1     D 00000001     0   363      6           368   331 (L-TLB)
       c151ae14 00000046 00000001 00000001 00001000 00000001 00000000 00000001 
       0000000a c1505570 0ee62d80 000000d5 00000000 c150567c c152fc00 d5463b20 
       d5463b60 c1580000 c158013c 00000000 c1580000 c0270c7f 00000000 c1505570 
Call Trace:
 [<c0270c7f>] md_super_wait+0x9f/0xc0
 [<c01275a0>] autoremove_wake_function+0x0/0x50
 [<c0271480>] md_update_sb+0x1f0/0x3f0
 [<c02756a2>] md_check_recovery+0x1d2/0x450
 [<c01b3195>] __generic_unplug_device+0x25/0x30
 [<c01b3c96>] generic_unplug_device+0x6/0x10
 [<c026b83d>] unplug_slaves+0x4d/0x90
 [<c0276ee0>] md_thread+0x0/0x110
 [<c026d1d4>] raid1d+0x24/0xcd0
 [<c0133e30>] handle_fasteoi_irq+0x0/0x90
 [<c01053dd>] do_IRQ+0x6d/0xb0
 [<c011738e>] profile_tick+0x3e/0x80
 [<c010d251>] smp_apic_timer_interrupt+0x41/0x50
 [<c0103618>] apic_timer_interrupt+0x28/0x30
 [<c0101df4>] __switch_to+0x134/0x1b0
 [<c0301187>] __sched_text_start+0x277/0x5b0
 [<c010d251>] smp_apic_timer_interrupt+0x41/0x50
 [<c0276ee0>] md_thread+0x0/0x110
 [<c0301b55>] schedule_timeout+0x75/0xc0
 [<c0276ee0>] md_thread+0x0/0x110
 [<c0276ee0>] md_thread+0x0/0x110
 [<c0276f0f>] md_thread+0x2f/0x110
 [<c01275a0>] autoremove_wake_function+0x0/0x50
 [<c0276ee0>] md_thread+0x0/0x110
 [<c0127318>] kthread+0xa8/0xe0
 [<c0127270>] kthread+0x0/0xe0
 [<c010376b>] kernel_thread_helper+0x7/0x1c
 =======================

Both md2_raid1 and pdflush is in the D state at the same time. I've
also seen md1_raid1 and kjournald in the D state at the same time when
running this: ps aux | awk '// { if ($8 ~ "^D") print $0 }' . Most of
the time, no processes are in the D state, and then two at the same
time...

/ Anders
