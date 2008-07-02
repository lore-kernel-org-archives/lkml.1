Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYGBEKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYGBEKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYGBEKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:10:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981AbYGBEKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:10:20 -0400
Date: Wed, 2 Jul 2008 00:09:22 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080626070723.GL20851@kernel.dk>
Message-ID: <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
 <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
 <20080626070723.GL20851@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, that wont work of course. Completions are typically done through
> a softirq, so it is not currently done with hard interrupts disabled.

I thought, from hardirq - that's what IDE is doing. And they are called 
with interrupts disabled (maybe unless you specify unmaskirq, which is not 
default). What block driver does completions with softirq? ... and why?

> So it's a bit of a shame to impose this extra restriction, bio unrolling 
> is necessarily a really short operation. We could reenable around the 
> bi_end_io() call, but then we'd need to save and restore for each bio.

I found another weird thing --- why does local_irq_save() execute that 
microcoded "cli" instruction even if interrupts are already disabled? That 
could be definitely optimized.

And does local_irq_restore() need to execute even more costy "popf" when 
it makes a transition from disabled to disabled state? What's 
local_irq_restore semantics --- is it allowed to use local_irq_restore for 
transition from interrupt-enabled state into interrupt-disabled state?

> Please make that
>
>        bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>        bio->bi_phys_segments = error;

OK, here is the updated patch:

Avoid recursion on bio_endio. bio_endio calls bio->bi_end_io which may in turn
call bio_endio again. When this recursion happens, put the new bio to the queue
and process it later, from the top-level bio_endio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
  fs/bio.c            |   39 ++++++++++++++++++++++++++++++++++++---
  include/linux/bio.h |    3 +++
  2 files changed, 39 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc8-devel/fs/bio.c
===================================================================
--- linux-2.6.26-rc8-devel.orig/fs/bio.c	2008-07-02 04:20:43.000000000 +0200
+++ linux-2.6.26-rc8-devel/fs/bio.c	2008-07-02 04:22:15.000000000 +0200
@@ -1166,15 +1166,48 @@ void bio_check_pages_dirty(struct bio *b
   *   bio unless they own it and thus know that it has an end_io
   *   function.
   **/
+static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };
+
  void bio_endio(struct bio *bio, int error)
  {
+	struct bio ***bio_end_queue_ptr;
+	struct bio *bio_queue;
+
+	unsigned long flags;
+
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+	bio->bi_phys_segments = error;
  	if (error)
  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+		bio->bi_phys_segments = -EIO;
+
+	local_irq_save(flags);
+	bio_end_queue_ptr = &__get_cpu_var(bio_end_queue);
+
+	if (*bio_end_queue_ptr) {
+		**bio_end_queue_ptr = bio;
+		*bio_end_queue_ptr = &bio->bi_next;
+		bio->bi_next = NULL;
+	} else {
+		bio_queue = NULL;
+		*bio_end_queue_ptr = &bio_queue;
+
+next_bio:
+		if (bio->bi_end_io)
+			bio->bi_end_io(bio, (short)bio->bi_phys_segments);
+
+		if (bio_queue) {
+			bio = bio_queue;
+			bio_queue = bio->bi_next;
+			if (!bio_queue)
+				*bio_end_queue_ptr = &bio_queue;
+			goto next_bio;
+		}
+		*bio_end_queue_ptr = NULL;
+	}

-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	local_irq_restore(flags);
  }

  void bio_pair_release(struct bio_pair *bp)
Index: linux-2.6.26-rc8-devel/include/linux/bio.h
===================================================================
--- linux-2.6.26-rc8-devel.orig/include/linux/bio.h	2008-07-02 04:20:43.000000000 +0200
+++ linux-2.6.26-rc8-devel/include/linux/bio.h	2008-07-02 04:21:16.000000000 +0200
@@ -86,6 +86,9 @@ struct bio {

  	/* Number of segments in this BIO after
  	 * physical address coalescing is performed.
+	 *
+	 * When ending a bio request in bio_endio, this field is temporarily
+	 * (ab)used to keep the error code.
  	 */
  	unsigned short		bi_phys_segments;

