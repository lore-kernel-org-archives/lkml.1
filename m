Return-Path: <linux-kernel-owner+w=401wt.eu-S1763740AbYCUWux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763740AbYCUWux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbYCUWqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34772 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506AbYCUWqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:35 -0400
Message-Id: <20080321224452.773832037@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:44:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Quentin Barnes <qbarnes+linux@yahoo-inc.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 72/76] aio: bad AIO race in aio_complete() leads to process hang
Content-Disposition: inline; filename=aio-bad-aio-race-in-aio_complete-leads-to-process-hang.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Quentin Barnes <qbarnes+linux@yahoo-inc.com>

My group ran into a AIO process hang on a 2.6.24 kernel with the process
sleeping indefinitely in io_getevents(2) waiting for the last wakeup to come
and it never would.

We ran the tests on x86_64 SMP.  The hang only occurred on a Xeon box
("Clovertown") but not a Core2Duo ("Conroe").  On the Xeon, the L2 cache isn't
shared between all eight processors, but is L2 is shared between between all
two processors on the Core2Duo we use.

My analysis of the hang is if you go down to the second while-loop
in read_events(), what happens on processor #1:
	1) add_wait_queue_exclusive() adds thread to ctx->wait
	2) aio_read_evt() to check tail
	3) if aio_read_evt() returned 0, call [io_]schedule() and sleep

In aio_complete() with processor #2:
	A) info->tail = tail;
	B) waitqueue_active(&ctx->wait)
	C) if waitqueue_active() returned non-0, call wake_up()

The way the code is written, step 1 must be seen by all other processors
before processor 1 checks for pending events in step 2 (that were recorded by
step A) and step A by processor 2 must be seen by all other processors
(checked in step 2) before step B is done.

The race I believed I was seeing is that steps 1 and 2 were
effectively swapped due to the __list_add() being delayed by the L2
cache not shared by some of the other processors.  Imagine:
proc 2: just before step A
proc 1, step 1: adds to ctx->wait, but is not visible by other processors yet
proc 1, step 2: checks tail and sees no pending events
proc 2, step A: updates tail
proc 1, step 3: calls [io_]schedule() and sleeps
proc 2, step B: checks ctx->wait, but sees no one waiting, skips wakeup
                so proc 1 sleeps indefinitely

My patch adds a memory barrier between steps A and B.  It ensures that the
update in step 1 gets seen on processor 2 before continuing.  If processor 1
was just before step 1, the memory barrier makes sure that step A (update
tail) gets seen by the time processor 1 makes it to step 2 (check tail).

Before the patch our AIO process would hang virtually 100% of the time.  After
the patch, we have yet to see the process ever hang.

Signed-off-by: Quentin Barnes <qbarnes+linux@yahoo-inc.com>
Reviewed-by: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: <stable@kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ We should probably disallow that "if (waitqueue_active()) wake_up()"
  coding pattern, because it's so often buggy wrt memory ordering ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/aio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -997,6 +997,14 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
+	/*
+	 * We have to order our ring_info tail store above and test
+	 * of the wait list below outside the wait lock.  This is
+	 * like in wake_up_bit() where clearing a bit has to be
+	 * ordered with the unlocked test.
+	 */
+	smp_mb();
+
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 

-- 
