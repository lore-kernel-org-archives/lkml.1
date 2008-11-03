Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYKCVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYKCVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYKCVHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:07:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33930 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754956AbYKCVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:07:49 -0500
Date: Mon, 3 Nov 2008 15:07:48 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081103210748.GC9937@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When load balancing gets switched off for a set of cpus via the
sched_load_balance flag in cpusets, those cpus wind up with the
globally defined def_root_domain attached.  The def_root_domain is
attached when partition_sched_domains calls detach_destroy_domains().
A new root_domain is never allocated or attached as a sched domain
will never be attached by __build_sched_domains() for the non-load
balanced processors.

The problem with this scenario is that on systems with a large number
of processors with load balancing switched off, we start to see the
cpupri->pri_to_cpu->lock in the def_root_domain becoming contended.
This starts to become much more apparent above 8 waking RT threads
(with each RT thread running on it's own cpu, blocking and waking up
continuously).

I'm wondering if this is, in fact, the way things were meant to work,
or should we have a root domain allocated for each cpu that is not to
be part of a sched domain?  Note the the def_root_domain spans all of
the non-load-balanced cpus in this case.  Having it attached to cpus
that should not be load balancing doesn't quite make sense to me.


Here's where we've often seen this lock contention occur:

0xa0000001006df1e0 _spin_lock_irqsave+0x40
        args (0xa000000101f8e1c8)
0xa00000010014b150 cpupri_set+0x290
        args (0x16, 0x2c, 0x16, 0xa000000101f8e1c8, 0xa000000101f8b518, 0x1, 0x2c,
0xa000000100092ee0, 0x48c)
0xa000000100092ee0 __enqueue_rt_entity+0x300
        args (0xe00000b4730401a0, 0xe0000b300316b510, 0xe0000b300316ba10, 0x500,
0xe0000b300316b518, 0x50, 0xa000000100093bc0, 0x286, 0x4f)
0xa000000100093bc0 enqueue_rt_entity+0xe0
        args (0xe00000b4730401a0, 0x0, 0xa000000100093c50, 0x307, 0xe00000b4730401a0)
0xa000000100093c50 enqueue_task_rt+0x30
        args (0xe0000b300316b400, 0xe00000b473040000, 0x1, 0xa0000001000848d0, 0x309,
0xa000000101122134)
0xa0000001000848d0 enqueue_task+0xd0
        args (0xe0000b300316b400, 0xe00000b473040000, 0x1, 0xa000000100084ba0, 0x309,
0xa0000001013079b0)
0xa000000100084ba0 activate_task+0x60
        args (0xe0000b300316b400, 0xe00000b473040000, 0x1, 0xa00000010009a270, 0x58e,
0xa000000100099ec0)
0xa00000010009a270 try_to_wake_up+0x530
        args (0xe00000b473040000, 0x1, 0xe0000b300316b400, 0x49c6, 0xe0000b300316bc10,
0xe0000b300316bcac, 0xe00000b473040078, 0xe0000b300316bc38, 0xa00000010009a4d0)
0xa00000010009a4d0 wake_up_process+0x30
