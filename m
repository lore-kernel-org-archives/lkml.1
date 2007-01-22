Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXAVTPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXAVTPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932379AbXAVTPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:15:36 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:55108 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXAVTPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:15:35 -0500
Date: Mon, 22 Jan 2007 14:15:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -rt] make spin_unlock to slab_spin_unlock
Message-ID: <Pine.LNX.4.58.0701221407060.24244@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I hit this bug on one of my work test machines. This bug is probably what
caused my laptop to crash ever so often too, but since I don't have a
serial or other debug output, my laptop never showed what was wrong.

Here's the call trace:

------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:649!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 2
[...]
Call Trace:
 [<ffffffff802661a7>] rt_spin_lock+0x1f/0x21
 [<ffffffff802df73b>] drain_freelist+0x4f/0xeb
 [<ffffffff802df941>] cache_reap+0x16a/0x26d
 [<ffffffff8024f29e>] run_workqueue+0x9f/0xf9
 [<ffffffff8024bbe3>] worker_thread+0x11b/0x152
 [<ffffffff80233fcb>] kthread+0xee/0x11a
 [<ffffffff802600f8>] child_rip+0xa/0x12


Seems that the goto out of the loop was not updated to be a
slab_spin_unlock, so there was a way out that would not unlock the slab
cpu lock.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.20-rc5-rt7/mm/slab.c
===================================================================
--- linux-2.6.20-rc5-rt7.orig/mm/slab.c	2007-01-22 14:05:35.000000000 -0500
+++ linux-2.6.20-rc5-rt7/mm/slab.c	2007-01-22 14:06:07.000000000 -0500
@@ -2564,7 +2564,7 @@ static int drain_freelist(struct kmem_ca
 		slab_spin_lock_irq(&l3->list_lock, this_cpu);
 		p = l3->slabs_free.prev;
 		if (p == &l3->slabs_free) {
-			spin_unlock_irq(&l3->list_lock);
+			slab_spin_unlock_irq(&l3->list_lock, this_cpu);
 			goto out;
 		}


