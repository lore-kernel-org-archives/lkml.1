Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYLOSpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYLOSpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYLOSpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:45:09 -0500
Received: from brick.kernel.dk ([93.163.65.50]:9603 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYLOSpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:45:07 -0500
Date: Mon, 15 Dec 2008 19:44:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20081215: kernel BUG at block/cfq-iosched.c:1243
Message-ID: <20081215184440.GI32491@kernel.dk>
References: <a4423d670812151029u5458f9b4iaa36316a5f210ff1@mail.gmail.com> <20081215183235.GG32491@kernel.dk> <a4423d670812151038p4bab739fo3a6f9afd1ad3e358@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670812151038p4bab739fo3a6f9afd1ad3e358@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15 2008, Alexander Beregalov wrote:
> 2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
> >> [   23.080733] kernel BUG at block/cfq-iosched.c:1243!
> >> [   23.080733] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> 
> > Odd, is it reproducible? What is your .config?
> Yes, it is
> 
> Config is in attach

It's weird, because the only change for CFQ in that area is the one
below. Does the oops go away if you back this out?


>From 030a3f02bb42fad91ae84c99924fe3ee162a634d Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 12 Dec 2008 15:56:31 +0100
Subject: [PATCH] cfq-iosched: fix race between exiting queue and exiting task

Original patch from Nikanth Karthikesan <knikanth@suse.de>

When a queue exits the queue lock is taken and cfq_exit_queue() would free all
the cic's associated with the queue.

But when a task exits, cfq_exit_io_context() gets cic one by one and then
locks the associated queue to call __cfq_exit_single_io_context. It looks like
between getting a cic from the ioc and locking the queue, the queue might have
exited on another cpu.

Fix this by rechecking the cfq_io_context queue key inside the queue lock
again, and not calling into __cfq_exit_single_io_context() if somebody
beat us to it.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee8a90c..8a2485d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1314,7 +1314,16 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
 		unsigned long flags;
 
 		spin_lock_irqsave(q->queue_lock, flags);
+
+		/*
+		 * Ensure we get a fresh copy of the ->key to prevent
+		 * race between exiting task and queue
+		 */
+		smp_read_barrier_depends();
+		if (cic->key)
+			__cfq_exit_single_io_context(cfqd, cic);
 		__cfq_exit_single_io_context(cfqd, cic);
+
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
-- 
1.6.0.4.755.g6e139


-- 
Jens Axboe

