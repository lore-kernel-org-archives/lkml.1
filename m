Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZFCE2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZFCE2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZFCE2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:28:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:37823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZFCE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=F6C2x76J+S8HvUCngw20XFPg8i3LAMK9mf4juwSFQfhUdBvg2gjaKO6Js9njTHkj4o
         EJuE2pBB8Ecxq2pOH3sicpgBGJN8qhy6W7G8zWdNYpFZYbz88ntbAm2eQ5X0qM/eCedH
         VFkOgwvvUm/pyyUYvmW/QWJrsOirfERB1PMeA=
Message-ID: <4A25FBD1.70000@gmail.com>
Date: Wed, 03 Jun 2009 13:28:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com> <4A25EA78.7070705@kernel.org>
In-Reply-To: <4A25EA78.7070705@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010401030508020306030503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010401030508020306030503
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

Can you please do the followings?

1. Apply the attached patch, build & boot

2. Trigger the problem and record dmesg

3. On failed IO, the kernel will print the address of bi_endio.  Run
   "nm -n" on the vmlinux in the kernel build root and look up which
   function it is and post the dmesg and function name.

Thanks.

-- 
tejun

--------------010401030508020306030503
Content-Type: text/x-patch;
 name="bio_endio-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bio_endio-debug.patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..6c03f54 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -163,8 +163,13 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		if (bio_integrity(bio))
 			bio_integrity_advance(bio, nbytes);
 
-		if (bio->bi_size == 0)
+		if (bio->bi_size == 0) {
+			if (error)
+				printk("XXX %s: failing bio %p with %d\n",
+				       rq->rq_disk ? rq->rq_disk->disk_name : "?",
+				       bio, error);
 			bio_endio(bio, error);
+		}
 	} else {
 
 		/*
diff --git a/fs/bio.c b/fs/bio.c
index 9871164..c26364a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1391,13 +1391,24 @@ void bio_check_pages_dirty(struct bio *bio)
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	char name[BDEVNAME_SIZE] = "?";
+
+	if (bio->bi_bdev)
+		bdevname(bio->bi_bdev, name);
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+		printk("XXX %s: !uptodate on bio %p\n", name, bio);
 		error = -EIO;
+	}
 
-	if (bio->bi_end_io)
+	if (bio->bi_end_io) {
+		if (error)
+			printk("XXX %s: bio=%p error=%d bi_end_io=%p\n",
+			       name, bio, error, bio->bi_end_io);
 		bio->bi_end_io(bio, error);
+	}
 }
 
 void bio_pair_release(struct bio_pair *bp)

--------------010401030508020306030503--
