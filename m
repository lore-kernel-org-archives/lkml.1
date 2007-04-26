Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXDZRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXDZRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXDZRBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39790 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbXDZRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:39 -0400
Date: Thu, 26 Apr 2007 09:57:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 32/33] cfq-iosched: fix alias + front merge bug
Message-ID: <20070426165719.GG1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cfq-iosched-fix-alias-front-merge-bug.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

There's a really rare and obscure bug in CFQ, that causes a crash in
cfq_dispatch_insert() due to rq == NULL. One example of that is seen
here:

http://lkml.org/lkml/2007/4/15/41

Neil correctly diagnosed the situation for how this can happen, read
that analysis here:

http://lkml.org/lkml/2007/4/25/57

This looks like it requires md to trigger, even though it should
potentially be possible to due with O_DIRECT (at least if you edit the
kernel and doctor some of the unplug calls).

The fix is to move the ->next_rq update to when we add a request to the
rbtree. Then we remove the possibility for a request to exist in the
rbtree code, but not have ->next_rq correctly updated.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -462,6 +462,12 @@ static void cfq_add_rq_rb(struct request
 
 	if (!cfq_cfqq_on_rr(cfqq))
 		cfq_add_cfqq_rr(cfqd, cfqq);
+
+	/*
+	 * check if this request is a better next-serve candidate
+	 */
+	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
+	BUG_ON(!cfqq->next_rq);
 }
 
 static inline void
@@ -1623,12 +1629,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 		cfqq->meta_pending++;
 
 	/*
-	 * check if this request is a better next-serve candidate)) {
-	 */
-	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
-	BUG_ON(!cfqq->next_rq);
-
-	/*
 	 * we never wait for an async request and we don't allow preemption
 	 * of an async request. so just return early
 	 */

-- 
