Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFYM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFYM5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZFYM5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:57:47 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63856 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZFYM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=GZ1nYiemlC5Pf5UZtRtTYAZsBzO9g838rW1FbxfuExDLASjuGT7mSrzNkn4UpfshPB
         iM+mf3r/wfgmy4Vezkh8oHOqyaP8zmVHG48g5iw6ZDA/sr4i0qEOmnUliOR3IxTjha0b
         rUEdtYpdrr0y5qpPxvBsJNfR5uWJwllqTPBB8=
Message-ID: <4A437442.8000909@gmail.com>
Date: Thu, 25 Jun 2009 21:57:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com> <4A25EA78.7070705@kernel.org> <4A25FBD1.70000@gmail.com> <4A2A1521.5020407@gmai
 l.com>
In-Reply-To: <4A2A1521.5020407@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060108020901060306000506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060108020901060306000506
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sorry about the long delay.

Niel Lambrechts wrote:
> Morning Tejun,
> 
> Tejun Heo wrote:
>> Hello,
>>
>> Can you please do the followings?
>>
>> 1. Apply the attached patch, build & boot
>>   
> I chose 2.6.30-rc7...
>> 2. Trigger the problem and record dmesg
>>   
> It took 3 days and quite a few hibernate attempts ... :-)
> 
>> 3. On failed IO, the kernel will print the address of bi_endio.  Run
>>    "nm -n" on the vmlinux in the kernel build root and look up which
>>    function it is and post the dmesg and function name.
> I did not have that specific vmlinux.o file any more, but
> /boot/System.map-2.6.30-rc7-pae shows:
> c01a49fd t end_bio_bh_io_sync

So, it's coming from submit_bh()

> Hope this is sufficient to help you. Sorry if this is silly - being so
> inexperienced with the kernel - but I wondered if or why a dump_stack()
> in that debug patch would not be helpful?

The result is perfectly good and yeah dump_stack() on the issue path
would help but the problem is that block IO requests are processed
asynchronously so by the time we find out which request fail, the
requester stack is long gone.  We can either record the stack trace
with each request or trace it back one step at a time by chasing down
the completion callbacks.  The first requires more coding, so... :-)

Looks like the request gotta be coming from __breadahead().  The only
place this is used in ext4 is in __ext4_get_inode_loc().  Ah.. it also
contains the matching error message.  I still don't see how the READA
buffer reads can affect the synchronous path.  They're doing proper
exclusion via buffer lock.  Maybe they're getting merged?  Yeap, looks
like block code is merging READAs and regular READs.

Can you please try the attached patch and reproduce the problem and
report the kernel log?  Hopefully, this will be the last debug run.

Thanks.

-- 
tejun

--------------060108020901060306000506
Content-Type: text/x-patch;
 name="bio_endio-debug2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bio_endio-debug2.patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index b06cf5c..c8b3a6f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -155,8 +155,13 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		if (bio_integrity(bio))
 			bio_integrity_advance(bio, nbytes);
 
-		if (bio->bi_size == 0)
+		if (bio->bi_size == 0) {
+			if (error)
+				printk("XXX %s: failing bio %p bi_rw=0x%lx with %d\n",
+				       rq->rq_disk ? rq->rq_disk->disk_name : "?",
+				       bio, bio->bi_rw, error);
 			bio_endio(bio, error);
+		}
 	} else {
 
 		/*
diff --git a/fs/bio.c b/fs/bio.c
index 24c9140..007edb9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1390,13 +1390,24 @@ void bio_check_pages_dirty(struct bio *bio)
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

--------------060108020901060306000506--
