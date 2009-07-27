Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZG0Ohi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZG0Ohi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZG0Ohh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:37:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZG0Ohg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:37:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hvdmos4i8.wl%tiwai@suse.de>
References: <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com>
To: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Incorrect circular locking dependency?
Date: Mon, 27 Jul 2009 15:37:10 +0100
Message-ID: <24075.1248705430@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.30-test #7
> -------------------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&cwq->lock){-.-...}, at: [<c01519f3>] __queue_work+0x1f/0x4e
> 
> but task is already holding lock:
>  (&q->lock){-.-.-.}, at: [<c012cc9c>] __wake_up+0x26/0x5c
> 
> which lock already depends on the new lock.

Okay.  I think I understand this:

 (1) cachefiles_read_waiter() intercepts wake up events, and, as such, is run
     inside the waitqueue spinlock for the page bit waitqueue.

 (2) cachefiles_read_waiter() calls fscache_enqueue_retrieval() which calls
     fscache_enqueue_operation() which calls schedule_work() for fast
     operations, thus taking a per-CPU workqueue spinlock.

 (3) queue_work(), which is called by many things, calls __queue_work(), which
     takes the per-CPU workqueue spinlock.

 (4) __queue_work() then calls insert_work(), which calls wake_up(), which
     takes the waitqueue spinlock for the per-CPU workqueue waitqueue.

Even though the two waitqueues are separate, I think lockdep sees them as
having the same lock.

Ingo: Is there any way around this?

David
---
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&q->lock){-.-.-.}:
>        [<c0168746>] __lock_acquire+0xfd6/0x12d5
>        [<c0168afc>] lock_acquire+0xb7/0xeb
>        [<c03d1249>] _spin_lock_irqsave+0x3d/0x5e
>        [<c012cc9c>] __wake_up+0x26/0x5c
>        [<c0151053>] insert_work+0x7b/0x95
>        [<c0151a02>] __queue_work+0x2e/0x4e
>        [<c0151a5e>] delayed_work_timer_fn+0x3c/0x4f
>        [<c014925b>] run_timer_softirq+0x180/0x206
>        [<c01445cb>] __do_softirq+0xc3/0x18d
>        [<c01446d9>] do_softirq+0x44/0x7a
>        [<c0144823>] irq_exit+0x43/0x87
>        [<c0117cbd>] smp_apic_timer_interrupt+0x7c/0x9b
>        [<c0103956>] apic_timer_interrupt+0x36/0x40
>        [<c0101ed0>] cpu_idle+0xa2/0xbe
>        [<c03bcef6>] rest_init+0x66/0x79
>        [<c0537a98>] start_kernel+0x396/0x3ae
>        [<c053707f>] __init_begin+0x7f/0x98
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&cwq->lock){-.-...}:
>        [<c0168496>] __lock_acquire+0xd26/0x12d5
>        [<c0168afc>] lock_acquire+0xb7/0xeb
>        [<c03d1249>] _spin_lock_irqsave+0x3d/0x5e
>        [<c01519f3>] __queue_work+0x1f/0x4e
>        [<c0151ab9>] queue_work_on+0x48/0x63
>        [<c0151c1d>] queue_work+0x23/0x38
>        [<c0151c50>] schedule_work+0x1e/0x31
>        [<f7f9ed69>] fscache_enqueue_operation+0xc5/0x102 [fscache]
>        [<f80b6142>] cachefiles_read_waiter+0xb3/0xcd [cachefiles]
>        [<c01292ae>] __wake_up_common+0x4c/0x85
>        [<c012ccae>] __wake_up+0x38/0x5c
>        [<c015568f>] __wake_up_bit+0x34/0x4b
>        [<c01ad459>] unlock_page+0x55/0x6a
>        [<c020fb6b>] mpage_end_io_read+0x4e/0x71
>        [<c020a4da>] bio_endio+0x31/0x44
>        [<c027759c>] req_bio_endio+0xab/0xde
>        [<c027774c>] blk_update_request+0x17d/0x321
>        [<c0277912>] blk_update_bidi_request+0x22/0x62
>        [<c02792c4>] blk_end_bidi_request+0x25/0x6e
>        [<c0279371>] blk_end_request+0x1a/0x30
>        [<f82811da>] scsi_io_completion+0x193/0x3bb [scsi_mod]
>        [<f827a888>] scsi_finish_command+0xd9/0xf2 [scsi_mod]
>        [<f8281522>] scsi_softirq_done+0xf4/0x10d [scsi_mod]
>        [<c027fcdf>] blk_done_softirq+0x6f/0x8e
>        [<c01445cb>] __do_softirq+0xc3/0x18d
>        [<c01446d9>] do_softirq+0x44/0x7a
>        [<c0144823>] irq_exit+0x43/0x87
>        [<c01049fd>] do_IRQ+0x8d/0xb2
>        [<c0103595>] common_interrupt+0x35/0x40
>        [<c0101ed0>] cpu_idle+0xa2/0xbe
>        [<c03bcef6>] rest_init+0x66/0x79
>        [<c0537a98>] start_kernel+0x396/0x3ae
>        [<c053707f>] __init_begin+0x7f/0x98
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by swapper/0:
>  #0:  (&q->lock){-.-.-.}, at: [<c012cc9c>] __wake_up+0x26/0x5c
> 
> stack backtrace:
> Pid: 0, comm: swapper Not tainted 2.6.30-test #7
> Call Trace:
>  [<c03cde42>] ? printk+0x1d/0x33
>  [<c0167349>] print_circular_bug_tail+0xaf/0xcb
>  [<c0168496>] __lock_acquire+0xd26/0x12d5
>  [<c01519f3>] ? __queue_work+0x1f/0x4e
>  [<c0168afc>] lock_acquire+0xb7/0xeb
>  [<c01519f3>] ? __queue_work+0x1f/0x4e
>  [<c01519f3>] ? __queue_work+0x1f/0x4e
>  [<c03d1249>] _spin_lock_irqsave+0x3d/0x5e
>  [<c01519f3>] ? __queue_work+0x1f/0x4e
>  [<c01519f3>] __queue_work+0x1f/0x4e
>  [<c0151ab9>] queue_work_on+0x48/0x63
>  [<c0151c1d>] queue_work+0x23/0x38
>  [<c0151c50>] schedule_work+0x1e/0x31
>  [<f7f9ed69>] fscache_enqueue_operation+0xc5/0x102 [fscache]
>  [<f80b6142>] cachefiles_read_waiter+0xb3/0xcd [cachefiles]
>  [<c01292ae>] __wake_up_common+0x4c/0x85
>  [<c012ccae>] __wake_up+0x38/0x5c
>  [<c015568f>] __wake_up_bit+0x34/0x4b
>  [<c01ad459>] unlock_page+0x55/0x6a
>  [<c020fb6b>] mpage_end_io_read+0x4e/0x71
>  [<c020a4da>] bio_endio+0x31/0x44
>  [<c027759c>] req_bio_endio+0xab/0xde
>  [<c027774c>] blk_update_request+0x17d/0x321
>  [<c0277912>] blk_update_bidi_request+0x22/0x62
>  [<c02792c4>] blk_end_bidi_request+0x25/0x6e
>  [<c0279371>] blk_end_request+0x1a/0x30
>  [<f82811da>] scsi_io_completion+0x193/0x3bb [scsi_mod]
>  [<c0166b5b>] ? trace_hardirqs_on+0x19/0x2c
>  [<f8280f43>] ? scsi_device_unbusy+0x92/0xaa [scsi_mod]
>  [<f827a888>] scsi_finish_command+0xd9/0xf2 [scsi_mod]
>  [<f8281522>] scsi_softirq_done+0xf4/0x10d [scsi_mod]
>  [<c027fcdf>] blk_done_softirq+0x6f/0x8e
>  [<c01445cb>] __do_softirq+0xc3/0x18d
>  [<c01446d9>] do_softirq+0x44/0x7a
>  [<c0144823>] irq_exit+0x43/0x87
>  [<c01049fd>] do_IRQ+0x8d/0xb2
>  [<c0103595>] common_interrupt+0x35/0x40
>  [<c0109860>] ? mwait_idle+0x98/0xec
>  [<c0101ed0>] cpu_idle+0xa2/0xbe
>  [<c03bcef6>] rest_init+0x66/0x79
>  [<c0537a98>] start_kernel+0x396/0x3ae
>  [<c053707f>] __init_begin+0x7f/0x98
