Return-Path: <linux-kernel-owner+w=401wt.eu-S1031685AbXEHTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031685AbXEHTrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031678AbXEHTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:47:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031665AbXEHTrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:47:22 -0400
Date: Tue, 8 May 2007 20:47:12 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <hjm@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [2.6.22 PATCH 14/26] dm io: delay dec_count
Message-ID: <20070508194712.GU24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <hjm@redhat.com>, Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <hjm@redhat.com>

Delay decrementing the 'struct io' reference count until after the bio has
been freed so that a bio destructor function may reference it.
Required by a later patch.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
---

 drivers/md/dm-io.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.21/drivers/md/dm-io.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-io.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-io.c	2007-05-01 17:40:52.000000000 +0100
@@ -126,7 +126,8 @@ static void dec_count(struct io *io, uns
 
 static int endio(struct bio *bio, unsigned int done, int error)
 {
-	struct io *io = (struct io *) bio->bi_private;
+	struct io *io;
+	unsigned region;
 
 	/* keep going until we've finished */
 	if (bio->bi_size)
@@ -135,10 +136,17 @@ static int endio(struct bio *bio, unsign
 	if (error && bio_data_dir(bio) == READ)
 		zero_fill_bio(bio);
 
-	dec_count(io, bio_get_region(bio), error);
+	/*
+	 * The bio destructor in bio_put() may use the io object.
+	 */
+	io = bio->bi_private;
+	region = bio_get_region(bio);
+
 	bio->bi_max_vecs++;
 	bio_put(bio);
 
+	dec_count(io, region, error);
+
 	return 0;
 }
 
