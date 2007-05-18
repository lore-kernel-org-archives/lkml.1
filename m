Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXERAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXERAWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbXERAWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:22:12 -0400
Received: from ns.suse.de ([195.135.220.2]:45851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbXERAWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:22:10 -0400
From: Neil Brown <neilb@suse.de>
To: "Jeff Zheng" <Jeff.Zheng@endace.com>
Date: Fri, 18 May 2007 10:21:53 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17996.61857.486525.172950@notabene.brown>
Cc: <david@lang.hm>, "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
In-Reply-To: message from Jeff Zheng on Friday May 18
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm>
	<17995.57891.56738.592100@notabene.brown>
	<17995.59547.368508.202596@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B348A@gazelle.ad.endace.com>
	<659F626D666070439A4A5965CD6EBF406B352A@gazelle.ad.endace.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday May 18, Jeff.Zheng@endace.com wrote:
>  Fix confirmed, filled the whole 11T hard disk, without crashing.
> I presume this would go into 2.6.22

Yes, and probably 2.6.21.y, though the patch will be slightly
different, see below.
> 
> Thanks again.

And thank-you for pursuing this with me.

NeilBrown


---------------------------
Avoid overflow in raid0 calculation with large components.

If a raid0 has a component device larger than 4TB, and is accessed on
a 32bit machines, then as 'chunk' is unsigned lock,
   chunk << chunksize_bits
can overflow (this can be as high as the size of the device in KB).
chunk itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-17 10:33:30.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-17 16:14:12.000000000 +1000
@@ -415,7 +415,7 @@ static int raid0_make_request (request_q
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_q
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
