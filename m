Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYLKTnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYLKTnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbYLKTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:26 -0500
Received: from kroah.org ([198.145.64.141]:56699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757637AbYLKTTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:23 -0500
Date: Thu, 11 Dec 2008 11:16:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Brian King <brking@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 71/83] sched: CPU remove deadlock fix
Message-ID: <20081211191626.GS5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-cpu-remove-deadlock-fix.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 9a2bd244e18ffbb96c8b783210fda4eded7c7e6f upstream.

Impact: fix possible deadlock in CPU hot-remove path

This patch fixes a possible deadlock scenario in the CPU remove path.
migration_call grabs rq->lock, then wakes up everything on rq->migration_queue
with the lock held. Then one of the tasks on the migration queue ends up
calling tg_shares_up which then also tries to acquire the same rq->lock.

[c000000058eab2e0] c000000000502078 ._spin_lock_irqsave+0x98/0xf0
[c000000058eab370] c00000000008011c .tg_shares_up+0x10c/0x20c
[c000000058eab430] c00000000007867c .walk_tg_tree+0xc4/0xfc
[c000000058eab4d0] c0000000000840c8 .try_to_wake_up+0xb0/0x3c4
[c000000058eab590] c0000000000799a0 .__wake_up_common+0x6c/0xe0
[c000000058eab640] c00000000007ada4 .complete+0x54/0x80
[c000000058eab6e0] c000000000509fa8 .migration_call+0x5fc/0x6f8
[c000000058eab7c0] c000000000504074 .notifier_call_chain+0x68/0xe0
[c000000058eab860] c000000000506568 ._cpu_down+0x2b0/0x3f4
[c000000058eaba60] c000000000506750 .cpu_down+0xa4/0x108
[c000000058eabb10] c000000000507e54 .store_online+0x44/0xa8
[c000000058eabba0] c000000000396260 .sysdev_store+0x3c/0x50
[c000000058eabc10] c0000000001a39b8 .sysfs_write_file+0x124/0x18c
[c000000058eabcd0] c00000000013061c .vfs_write+0xd0/0x1bc
[c000000058eabd70] c0000000001308a4 .sys_write+0x68/0x114
[c000000058eabe30] c0000000000086b4 syscall_exit+0x0/0x40

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6500,7 +6500,9 @@ migration_call(struct notifier_block *nf
 			req = list_entry(rq->migration_queue.next,
 					 struct migration_req, list);
 			list_del_init(&req->list);
+			spin_unlock_irq(&rq->lock);
 			complete(&req->done);
+			spin_lock_irq(&rq->lock);
 		}
 		spin_unlock_irq(&rq->lock);
 		break;

