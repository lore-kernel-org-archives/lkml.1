Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYCLQDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYCLQDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYCLQC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:02:59 -0400
Received: from dip4-fw.champ.corp.yahoo.com ([64.198.211.64]:47621 "EHLO
	enemycanmeet.champ.corp.yahoo.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751028AbYCLQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:02:58 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 12:02:58 EDT
Date: Wed, 12 Mar 2008 10:51:53 -0500
From: Quentin Barnes <qbarnes+linux@yahoo-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>
Subject: [PATCH] aio: Bad AIO race in aio_complete() leads to process hang
Message-ID: <20080312155153.GA28462@yahoo-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My group ran into a AIO process hang on a 2.6.24 kernel with the
process sleeping indefinitely in io_getevents(2) waiting for the
last wakeup to come and it never would.

We ran the tests on x86_64 SMP.  The hang only occurred on a Xeon box
("Clovertown") but not a Core2Duo ("Conroe").  On the Xeon, the L2
cache isn't shared between all eight processors, but is L2 is
shared between between all two processors on the Core2Duo we use.

My analysis of the hang is if you go down to the second while-loop
in read_events(), what happens on processor #1:
	1) add_wait_queue_exclusive() adds thread to ctx->wait
	2) aio_read_evt() to check tail
	3) if aio_read_evt() returned 0, call [io_]schedule() and sleep

In aio_complete() with processor #2:
	A) info->tail = tail;
	B) waitqueue_active(&ctx->wait)
	C) if waitqueue_active() returned non-0, call wake_up()

The way the code is written, step 1 must be seen by all other
processors before processor 1 checks for pending events in step 2
(that were recorded by step A) and step A by processor 2 must be
seen by all other processors (checked in step 2) before step B
is done.

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

My patch adds a memory barrier between steps A and B.  It ensures
that the update in step 1 gets seen on processor 2 before
continuing.  If processor 1 was just before step 1, the memory
barrier makes sure that step A (update tail) gets seen by the time
processor 1 makes it to step 2 (check tail).

Before the patch our AIO process would hang virtually 100% of the
time.  After the patch, we have yet to see the process ever hang.

I ran this patch and the analysis by the AIO mailing list
(linux-aio@kvack.org).  Zach Brown agreed and suggested I go ahead
and post the patch on here on linux-kernel.


Signed-off-by: Quentin Barnes <qbarnes+linux@yahoo-inc.com>
Reviewed-by: Zach Brown <zach.brown@oracle.com>


diff --git a/fs/aio.c b/fs/aio.c
index b74c567..6af9219 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -996,6 +996,14 @@ put_rq:
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
 
