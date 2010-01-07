Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794Ab0AGOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0AGOab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554Ab0AGOab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0AGOaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:30:30 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe\@oracle.com" <jens.axboe@oracle.com>,
       "Zhang\, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as  close
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	<4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	<20091228020348.GB28115@sli10-desk.sh.intel.com>
	<4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	<20091228084659.GA31389@sli10-desk.sh.intel.com>
	<4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	<20091228092844.GA9710@sli10-desk.sh.intel.com>
	<x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Jan 2010 09:30:21 -0500
In-Reply-To: <4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 7 Jan 2010 14:44:32 +0100")
Message-ID: <x49hbqy3s3m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Tue, Jan 5, 2010 at 10:16 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> For now, I'm leaning towards asking Jens to revert this.  It may still
>> be worth making sure that we don't merge a seeky queue with a non-seeky
>> queue.  I have a patch for that if folks are interested.
> Jeff, can you send this patch to Yanmin, that is investigating a
> regression apparently caused by excessive queue merge?
>
> http://lkml.org/lkml/2010/1/4/194


You first have to back out Shaohua's patch, then apply this one.

Cheers,
Jeff

cfq-iosched: don't allow merging with seeky queues

Shaohua Li noticed that cfq currently can merge with seeky queues, which
causes unwanted merge/unmerge activity.  We already know that the
cur_cfqq is not seeky, so this patch just makes sure that the non-seeky
queue is not merged with a seeky one.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8df4fe5..3db9050 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1677,6 +1677,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_dist_from_last(cfqd, rq) <= sdist;
 }
 
+/*
+ * Search for a cfqq that is issuing non-seeky I/Os within the seek
+ * mean of the current cfqq.
+ */
 static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 				    struct cfq_queue *cur_cfqq)
 {
@@ -1701,7 +1705,14 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	 * will contain the closest sector.
 	 */
 	__cfqq = rb_entry(parent, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
+	/*
+	 * If the cfqq does not have enough seek samples, assume it is
+	 * sequential until proven otherwise.  If it is assumed that the
+	 * queue is seeky first, then the close cooperator detection logic
+	 * may never trigger as one queue strays further from the other(s).
+	 */
+	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
+	    (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
 		return __cfqq;
 
 	if (blk_rq_pos(__cfqq->next_rq) < sector)
@@ -1712,7 +1723,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 		return NULL;
 
 	__cfqq = rb_entry(node, struct cfq_queue, p_node);
-	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
+	if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
+	    (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
 		return __cfqq;
 
 	return NULL;
