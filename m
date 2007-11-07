Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbXKGXo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbXKGXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXKGXou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:44:50 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:38836
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbXKGXot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:44:49 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 18:44:49 EST
X-Authority-Analysis: v=1.0 c=1 a=nC8wNrFDaxoL5NeRbdEA:9 a=cMBJlfT9c5yBcPcNrAgA:7 a=GYE9Ro36lc6mDo8FuAzFGXYE2nYA:4 a=7DSvI1NPTFQA:10 a=JTUSPwgBgNAA:10 a=oCUJXWGl-OwA:10
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Willy Tarreau <w@1wt.eu>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	<1194259886.6927.9.camel@localhost>
	<20071105132218.495f244e@poseidon.drzeus.cx>
	<1194270393.27789.2.camel@localhost>
	<20071105162633.09e54290@poseidon.drzeus.cx>
	<1194343121.6953.6.camel@rukbat> <20071106195148.GD1045@1wt.eu>
	<1194385693.12938.5.camel@rukbat> <1194387459.5205.2.camel@rukbat>
	<1194472374.7176.4.camel@rukbat>
From: Roland Dreier <roland@digitalvampire.org>
Date: Wed, 07 Nov 2007 15:37:46 -0800
In-Reply-To: <1194472374.7176.4.camel@rukbat> (Romano Giannetti's message of "Wed, 07 Nov 2007 22:52:54 +0100")
Message-ID: <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Well, I spent the last 36 hours (more or less) trying to bisect the SD
 > problem. The method I used was to insert the card, umount it, and make 8 dd
 > in a row; the kernel is "bad" if they differs, "good" if they are the same. 
 > 
 > I could not finish the bisect. The last pair good/bad were:
 > 
 > bad:   [7aeacf982203fb4dea2f3434eefdc268cfd5d6d9] 
 >        [BLOCK] blk_rq_map_sg: force clear termination bit
 > good:  [e38f981758118d829cd40cfe9c09e3fa81e422aa] 
 >        exportfs: update documentation

Thanks, that helps.  I read over the mmc changes in between those two
commits, and I think I found the problem... could you please try the
patch below (on top of the latest kernel) and report back how it
works?  Unfortunately I am traveling and I don't have an SD card with
me to test on my laptop...

Pierre, assuming Romano tests this patch successfully, please apply!

Thanks,
  Roland

<-- patch below -->

mmc: Fix sg helper copy-and-paste error

Commit 45711f1a ("[SG] Update drivers to use sg helpers") had the
following bogus change in drivers/mmc/card/queue.c:

    > -			src_buf = page_address(src->page) + src->offset;
    > +			src_buf = sg_virt(dst);

(Notice that "src" is converted to "dst").  Turn this "dst" back into
the intended "src".

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Roland Dreier <roland@digitalvampire.org>
---
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 9203a0b..1b9c9b6 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -310,7 +310,7 @@ static void copy_sg(struct scatterlist *dst, unsigned int dst_len,
 		}
 
 		if (src_size == 0) {
-			src_buf = sg_virt(dst);
+			src_buf = sg_virt(src);
 			src_size = src->length;
 		}
 
