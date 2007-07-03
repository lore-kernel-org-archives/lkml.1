Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbXGCW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbXGCW3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXGCW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:29:15 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:57626 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbXGCW3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:29:14 -0400
Date: Tue, 3 Jul 2007 15:28:55 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dio: remove bogus refcounting BUG_ON
Message-ID: <20070703222855.GA6293@mami.zabbo.net>
References: <46832499.40807@us.ibm.com> <5A6608DF-EDC3-43C1-BFB7-58ACBF94DBCB@oracle.com> <46859DE2.9040604@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46859DE2.9040604@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Andrew, please apply the bug fix patch at the end of this reply
for .22.

> >>One of our perf. team ran into this while doing some runs.
> >>I didn't see anything obvious - it looks like we converted
> >>async IO to synchronous one. I didn't spend much time digging
> >>around.

OK, I think this BUG_ON() is just broken.  I wasn't able to find any
obvious bugs from reading the code which would cause the BUG_ON() to
fire.  If it's reproducible I'd love to hear what the recipe is.

I did notice that this BUG_ON() is evaluating dio after having dropped
it's ref :/.  So it's not completely absurd to fear that it's a race
with the dio's memory being reused, but that'd be a pretty tight race.

Let's remove this stupid BUG_ON and see if that test box still has
trouble.  It might just hit the valid BUG_ON a few lines down, but this
unsafe BUG_ON needs to go.

-------

dio: remove bogus refcounting BUG_ON

Badari Pulavarty reported a case of this BUG_ON is triggering during
testing.  It's completely bogus and should be removed.

It's trying to notice if we left references to the dio hanging around in
the sync case.  They should have been dropped as IO completed while this
path was in dio_await_completion().  This condition will also be
checked, via some twisty logic, by the BUG_ON(ret != -EIOCBQUEUED) a few
lines lower.  So to start this BUG_ON() is redundant.

More fatally, it's dereferencing dio-> after having dropped its
reference.  It's only safe to dereference the dio after releasing the
lock if the final reference was just dropped.  Another CPU might free
the dio in bio completion and reuse the memory after this path drops the
dio lock but before the BUG_ON() is evaluated.

This patch passed aio+dio regression unit tests and aio-stress on ext3.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>

diff -r 509ce354ae1b fs/direct-io.c
--- a/fs/direct-io.c	Sun Jul 01 22:00:49 2007 +0000
+++ b/fs/direct-io.c	Tue Jul 03 14:56:41 2007 -0700
@@ -1106,7 +1106,7 @@ direct_io_worker(int rw, struct kiocb *i
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	ret2 = --dio->refcount;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
-	BUG_ON(!dio->is_async && ret2 != 0);
+
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret);
 		kfree(dio);
