Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXCYIRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXCYIRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXCYIRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:17:38 -0400
Received: from www.osadl.org ([213.239.205.134]:51813 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932228AbXCYIRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:17:36 -0400
Subject: [BUG] __copy_to_user_inatomic broken on non Pentium machines
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stable Kernel Team <stable@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 10:07:04 +0200
Message-Id: <1174810024.10840.477.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Environment: Pre Pentium systems, (boot_cpu_data.wp_works_ok == 0)
Last known working kernel: 2.6.18 (did not try 2.6.19 yet)

Enabling CONFIG_PREEMPT on latest mainline as well as 2.6.20 trigger

[   14.150000] BUG: sleeping function called from invalid context at /home/tglx/work/kernel/vanilla/linux-2.6.20/kernel/rwsem.c:20
[   14.160000] in_atomic():1, irqs_disabled():0
[   14.160000] no locks held by init/1.
[   14.170000]  [<c0103346>] show_trace_log_lvl+0x1a/0x2f
[   14.180000]  [<c0103441>] show_trace+0x12/0x14
[   14.190000]  [<c0103cf5>] dump_stack+0x16/0x18
[   14.190000]  [<c010aa62>] __might_sleep+0xc7/0xcd
[   14.200000]  [<c01213a1>] down_read+0x18/0x47
[   14.210000]  [<c01a01e4>] __copy_to_user_ll+0x5e/0x1b6
[   14.220000]  [<c012cf85>] file_read_actor+0x10b/0x149
[   14.230000]  [<c012d7b2>] do_generic_mapping_read+0x187/0x433
[   14.240000]  [<c012f64b>] generic_file_aio_read+0x191/0x1ca
[   14.240000]  [<c0141657>] do_sync_read+0xc2/0xff
[   14.250000]  [<c0141eb6>] vfs_read+0x90/0x145
[   14.260000]  [<c014227e>] sys_read+0x3f/0x63
[   14.270000]  [<c0102fb0>] syscall_call+0x7/0xb
[   14.270000]  =======================

and 

[   22.660000] BUG: scheduling while atomic: e2fsck/0x10000001/272
[   22.670000] 1 lock held by e2fsck/272:
[   22.680000]  #0:  (&mm->mmap_sem){----}, at: [<c01a01e4>] __copy_to_user_ll+0x5e/0x1b6
[   22.690000]  [<c0103346>] show_trace_log_lvl+0x1a/0x2f
[   22.700000]  [<c0103441>] show_trace+0x12/0x14
[   22.710000]  [<c0103cf5>] dump_stack+0x16/0x18
[   22.720000]  [<c024a189>] __sched_text_start+0x71/0x57f
[   22.720000]  [<c010b49f>] __cond_resched+0x21/0x3b
[   22.730000]  [<c024aca7>] cond_resched+0x26/0x31
[   22.740000]  [<c0137ae5>] get_user_pages+0x1e1/0x23c
[   22.750000]  [<c01a021e>] __copy_to_user_ll+0x98/0x1b6
[   22.760000]  [<c012cf85>] file_read_actor+0x10b/0x149
[   22.770000]  [<c012d7b2>] do_generic_mapping_read+0x187/0x433
[   22.780000]  [<c012f64b>] generic_file_aio_read+0x191/0x1ca
[   22.790000]  [<c0141657>] do_sync_read+0xc2/0xff
[   22.790000]  [<c0141eb6>] vfs_read+0x90/0x145
[   22.800000]  [<c014227e>] sys_read+0x3f/0x63
[   22.810000]  [<c0102fb0>] syscall_call+0x7/0xb
[   22.820000]  =======================

which is not surprising. 

int file_read_actor(read_descriptor_t *desc, struct page *page,
                        unsigned long offset, unsigned long size)
{
....
        /*
         * Faults on the destination of a read are common, so do it before
         * taking the kmap.
         */
        if (!fault_in_pages_writeable(desc->arg.buf, size)) {
                kaddr = kmap_atomic(page, KM_USER0);
---->           left = __copy_to_user_inatomic(desc->arg.buf,
                                                kaddr + offset, size);

	is called with preempt_count == 1, due to the kmap_atomic() above.

Now __copy_to_user_ll() takes the (boot_cpu_data.wp_works_ok == 0) path,
which in turn calls 

down_read(current->mm->mmap_sem) - which might sleep

and

get_user_pages() - which has a cond_resched() inside.

Not sure how to fix that.

	tglx


