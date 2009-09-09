Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZIIIqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZIIIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZIIIqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:46:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57885 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZIIIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pBcRPe5URM3EaEq7oyC0ap9MJyrgdHhqyoVpRDK9vtViIEj8R3pGctMAl6N7L/4Jqz
         Nd71uxPwoo0KsdL5bsdMibk3Ew+umQ+CDO9uExnM/I6clFw5guYvyjuqqnuqMZxus5YY
         EQ6Et6eTbMV2/men47LW9bwnd5xccTERjNz+U=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 12:46:35 +0400
Message-ID: <d960726f0909090146n7c96e143le137cd74c23dc065@mail.gmail.com>
Subject: [patch] md: Fix non-zero bio->bi_size in MD's bi_end_io callback.
From: Max Lapan <max.lapan@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

bi_size value in MD's BIO object passed in bi_end_io callback is not
null for successfully completed
BIOs. This may confuse upper layer which may check for bi_size (at the
moment, the only confused FS is GPFS).

    Signed-off-by: Max Lapan <max.lapan@gmail.com>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8726fd7..b95e9a2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -242,6 +242,8 @@ static void raid_end_bio_io(r1bio_t *r1_bio)
 			(unsigned long long) bio->bi_sector +
 				(bio->bi_size >> 9) - 1);

+		if (test_bit(R1BIO_Uptodate, &r1_bio->state))
+			bio->bi_size = 0;
 		bio_endio(bio,
 			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
 	}
@@ -364,6 +366,7 @@ static void raid1_end_write_request(struct bio
*bio, int error)
 					       (unsigned long long) mbio->bi_sector,
 					       (unsigned long long) mbio->bi_sector +
 					       (mbio->bi_size >> 9) - 1);
+					mbio->bi_size = 0;
 					bio_endio(mbio, 0);
 				}
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3d9020c..ebe883b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -235,6 +235,8 @@ static void raid_end_bio_io(r10bio_t *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;

+	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
+		bio->bi_size = 0;
 	bio_endio(bio,
 		test_bit(R10BIO_Uptodate, &r10_bio->state) ? 0 : -EIO);
 	free_r10bio(r10_bio);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b8a2c5d..fb9560d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3446,6 +3446,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 	rdev_dec_pending(rdev, conf->mddev);

 	if (!error && uptodate) {
+		raid_bi->bi_size = 0;
 		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_stripe);
@@ -3747,7 +3748,7 @@ static int make_request(struct request_queue *q,
struct bio * bi)

 		if ( rw == WRITE )
 			md_write_end(mddev);
-
+		bi->bi_size = 0;
 		bio_endio(bi, 0);
 	}
 	return 0;
@@ -4121,8 +4122,10 @@ static int  retry_aligned_read(raid5_conf_t
*conf, struct bio *raid_bio)
 	spin_lock_irq(&conf->device_lock);
 	remaining = raid5_dec_bi_phys_segments(raid_bio);
 	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0)
+	if (remaining == 0) {
+		raid_bio->bi_size = 0;
 		bio_endio(raid_bio, 0);
+	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
 	return handled;
