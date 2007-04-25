Return-Path: <linux-kernel-owner+w=401wt.eu-S2992567AbXDYK2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992567AbXDYK2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXDYK2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:28:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53934 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992567AbXDYK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:28:51 -0400
Date: Wed, 25 Apr 2007 12:27:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, OVZDL <devel@openvz.org>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Message-ID: <20070425102748.GT9715@kernel.dk>
References: <1177422791.435404.4031.nullmailer@me> <20070425065822.GG9715@kernel.dk> <1177501827.988228.3870.nullmailer@me> <20070425075725.GK9715@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425075725.GK9715@kernel.dk>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Jens Axboe wrote:
> On Wed, Apr 25 2007, Vasily Tarasov wrote:
> > >> @@ -1806,7 +1765,11 @@ static int cfq_may_queue(request_queue_t
> > >>  	 * so just lookup a possibly existing queue, or return 'may queue'
> > >>  	 * if that fails
> > >>  	 */
> > >> -	cfqq = cfq_find_cfq_hash(cfqd, key, tsk->ioprio);
> > >> +	cic = cfq_get_io_context_noalloc(cfqd, tsk);
> > >> +	if (!cic)
> > >> +		return ELV_MQUEUE_MAY; 
> > >> +
> > >> +	cfqq = cic->cfqq[rw & REQ_RW_SYNC];
> > >>  	if (cfqq) {
> > >>  		cfq_init_prio_data(cfqq);
> > >>  		cfq_prio_boost(cfqq);
> > > 
> > > Ahem, how well did you test this patch?
> > 
> > Ugh, again: bio_sync() returns not only 0/1
> > Sorry for giving so much trouble...
> 
> Right, and REQ_RW_SYNC isn't 1 either, so it returns a large number if
> set.

This is also needed, you can't just rely on bio_sync(), a check for a
READ is needed as well.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 17e4660..b793817 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -215,6 +215,18 @@ static inline void cic_set_cfqq(struct cfq_io_context *cic,
 }
 
 /*
+ * We regard a request as SYNC, if it's either a read or has the SYNC bit
+ * set (in which case it could also be direct WRITE).
+ */
+static inline int cfq_bio_sync(struct bio *bio)
+{
+	if (bio_data_dir(bio) == READ || bio_sync(bio))
+		return 1;
+
+	return 0;
+}
+
+/*
  * scheduler run of queue, if there are requests pending and no one in the
  * driver that will restart queueing
  */
@@ -594,7 +606,7 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 	if (!cic)
 		return NULL;
 
-	cfqq =  cic_to_cfqq(cic, bio_sync(bio));
+	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	if (cfqq) {
 		sector_t sector = bio->bi_sector + bio_sectors(bio);
 
@@ -694,7 +706,7 @@ static int cfq_allow_merge(request_queue_t *q, struct request *rq,
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
-	if ((bio_data_dir(bio) == READ || bio_sync(bio)) && !rq_is_sync(rq))
+	if (cfq_bio_sync(bio) && !rq_is_sync(rq))
 		return 0;
 
 	/*
@@ -705,7 +717,7 @@ static int cfq_allow_merge(request_queue_t *q, struct request *rq,
 	if (!cic)
 		return 0;
 
-	cfqq = cic_to_cfqq(cic, bio_sync(bio));
+	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	if (cfqq == RQ_CFQQ(rq))
 		return 1;
 

-- 
Jens Axboe

