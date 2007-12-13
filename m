Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbXLMOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbXLMOng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXLMOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:43:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbXLMOnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:43:24 -0500
Date: Thu, 13 Dec 2007 14:43:05 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>, stable@kernel.org, dm-crypt@saout.de
Subject: [2.6.24 PATCH 03/06] dm crypt: fix write endio
Message-ID: <20071213144305.GV24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>, stable@kernel.org, dm-crypt@saout.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Fix BIO_UPTODATE test for write io.

Cc: stable@kernel.org
Cc: dm-crypt@saout.de
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.24-rc5/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-crypt.c	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-crypt.c	2007-12-12 15:43:11.000000000 +0000
@@ -511,6 +511,9 @@ static void crypt_endio(struct bio *clon
 	struct crypt_config *cc = io->target->private;
 	unsigned read_io = bio_data_dir(clone) == READ;
 
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
 	/*
 	 * free the processed pages
 	 */
@@ -519,10 +522,8 @@ static void crypt_endio(struct bio *clon
 		goto out;
 	}
 
-	if (unlikely(!bio_flagged(clone, BIO_UPTODATE))) {
-		error = -EIO;
+	if (unlikely(error))
 		goto out;
-	}
 
 	bio_put(clone);
 	kcryptd_queue_crypt(io);
