Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbYF3R7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbYF3R7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYF3R73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:59:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYF3R72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:59:28 -0400
Date: Mon, 30 Jun 2008 19:59:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Discussions of testing linux 
	<ltc-linux-test@lists.linux.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
Message-ID: <20080630175925.GQ20826@kernel.dk>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48690385.7030500@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30 2008, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> next-20080630 kernel build fails x86 box 
> 
> fs/bio-integrity.c: In function `bio_integrity_add_page':
> include/linux/bio.h:368: sorry, unimplemented: inlining failed in call to 'bvec_nr_vecs': function body not available
> fs/bio-integrity.c:135: sorry, unimplemented: called from here
> make[1]: *** [fs/bio-integrity.o] Error 1
> make: *** [fs] Error 2

Gah, I can't believe gcc errors on that. This should fix it, I'll
integrate with the patchset.

diff --git a/fs/bio.c b/fs/bio.c
index bc865b1..7761c84 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -50,7 +50,7 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
  */
 struct bio_set *fs_bio_set;
 
-inline unsigned int bvec_nr_vecs(unsigned short idx)
+unsigned int bvec_nr_vecs(unsigned short idx)
 {
 	return bvec_slabs[idx].nr_vecs;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 62f0be9..0933a14 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -365,7 +365,7 @@ extern struct bio *bio_copy_user_iov(struct request_queue *, struct sg_iovec *,
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
-extern inline unsigned int bvec_nr_vecs(unsigned short idx);
+extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 /*
  * bio_set is used to allow other portions of the IO system to

-- 
Jens Axboe

