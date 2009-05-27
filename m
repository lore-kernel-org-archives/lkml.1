Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbZE0AG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbZE0AG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZE0AGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:06:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:59166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZE0AGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:06:17 -0400
Message-ID: <4A1C8444.9040605@kernel.org>
Date: Wed, 27 May 2009 09:07:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com>
In-Reply-To: <4A1C316C.9040201@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060703090806060908080901"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 00:06:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703090806060908080901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Niel Lambrechts wrote:
> On 05/26/2009 03:33 PM, Tejun Heo wrote:
>> Niel Lambrechts wrote:
>>   
>>> If you send some patches I'll make every effort to test, it beats having
>>> to re-install, my installation is just too customized. :)
>>>      
>> First, let's make sure we aren't balking up the wrong tree.  Can you
>> please apply the attached patch and report the kernel log?
> 
> Hi Tejun,
> 
> Okay it took 5 attempts, some of during which I played audio, did 'find
> /'  etc. but I still do not have a clue whether the extra activity
> helped trigger it or not.

Thanks for testing.

 XXX scmd->result=0x8000002 ff_t=4 ff_dev=2 ff_drv=8
 XXX DID_OK
 XXX CHECK_CONDITION, returning ff_dev
 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
 sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
 Descriptor sense data with sense descriptors (in hex):
	 72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
	 09 b8 71 d1 
 sd 0:0:0:0: [sda] Add. Sense: No additional sense information
 end_request: I/O error, dev sda, sector 242190447

The above is the offending failure and all three failfast bits are
set.  This corresponds to the following ATA exception.

 ata1.00: cmd 60/08:18:6f:88:6f/01:00:0e:00:00/40 tag 3 ncq 135168 in
	  res 50/00:40:d1:71:b8/00:00:09:00:00/40 Emask 0x10 (ATA bus error)

It's 33 page long read command.  Looking at the code the only way all
three fastfail bits can be set seems to be if the request is readahead
- the first part of block/blk-core.c::init_request_from_bio().  Now,
the failure of a readahead request isn't supposed to cause any
problem.  If it fails, well, it fails and things should go on as if
nothing happened.

Can you please try the attached patch?  It takes suspend/resume cycle
out of the equation and simply induces artificial failure to readahead
requests.  It's currently set to fail every 40th readahead.  Feel free
to adjust the frequency as you see fit.  catting files into /dev/null
would trigger readahead to kick in.  Can you reproduce filesystem
failure with this alone?

Thanks.

-- 
tejun

--------------060703090806060908080901
Content-Type: text/x-patch;
 name="fail-readahead.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fail-readahead.patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..9b11aea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -163,8 +163,18 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		if (bio_integrity(bio))
 			bio_integrity_advance(bio, nbytes);
 
-		if (bio->bi_size == 0)
+		if (bio->bi_size == 0) {
+			static unsigned cnt;
+			if (bio_rw_ahead(bio) && !error && !(++cnt % 40)) {
+				printk("XXX %s: failing readahead bio, "
+				       "sec=%llu f=0x%lx rw=0x%lx\n",
+				       rq->rq_disk ? rq->rq_disk->disk_name : "?",
+				       (unsigned long long)bio->bi_sector,
+				       bio->bi_flags, bio->bi_rw);
+				error = -EIO;
+			}
 			bio_endio(bio, error);
+		}
 	} else {
 
 		/*

--------------060703090806060908080901--
