Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYFXFWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYFXFWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYFXFWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:22:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYFXFWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:22:42 -0400
Date: Tue, 24 Jun 2008 01:22:33 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org
cc: axboe@kernel.dk
Subject: [PATCH 1/2] Avoid bio_endio recursion
Message-ID: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

bio_endio calls bi_end_io callback. In case of stacked devices (raid, dm), 
bio_end_io may call bio_endio again, up to an unspecified length.

The crash because of stack overflow was really observed on sparc64. And 
this recursion was one of the contributing factors (using 9 stack frames 
--- that is 1728 bytes).

This patch removes the recursion.

Mikulas

--

Avoid recursion on bio_endio. bio_endio calls bio->bi_end_io which may in turn
call bio_endio again. When this recursion happens, put the new bio to the queue
and process it later, from the top-level bio_endio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc5-devel/fs/bio.c
===================================================================
--- linux-2.6.26-rc5-devel.orig/fs/bio.c	2008-06-18 23:48:45.000000000 +0200
+++ linux-2.6.26-rc5-devel/fs/bio.c	2008-06-19 00:15:56.000000000 +0200
@@ -1168,6 +1168,27 @@
   **/
  void bio_endio(struct bio *bio, int error)
  {
+	static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };
+	struct bio ***bio_end_queue_ptr;
+	struct bio *bio_queue;
+
+	unsigned long flags;
+
+	local_irq_save(flags);
+	bio_end_queue_ptr = &__get_cpu_var(bio_end_queue);
+
+	if (*bio_end_queue_ptr) {
+		**bio_end_queue_ptr = bio;
+		*bio_end_queue_ptr = &bio->bi_next;
+		bio->bi_next = NULL;
+		goto ret;
+	}
+
+	bio_queue = NULL;
+queue_empty_next_bio:
+	*bio_end_queue_ptr = &bio_queue;
+next_bio:
+
  	if (error)
  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
@@ -1175,6 +1196,17 @@

  	if (bio->bi_end_io)
  		bio->bi_end_io(bio, error);
+
+	if (bio_queue) {
+		bio = bio_queue;
+		bio_queue = bio->bi_next;
+		if (!bio_queue) goto queue_empty_next_bio;
+		goto next_bio;
+	}
+	*bio_end_queue_ptr = NULL;
+
+ret:
+	local_irq_restore(flags);
  }

  void bio_pair_release(struct bio_pair *bp)
