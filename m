Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXITVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXITVZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXITVZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:25:29 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36259 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXITVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:25:28 -0400
Message-ID: <46F2E54C.3070504@free.fr>
Date: Thu, 20 Sep 2007 23:25:32 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: [PATCH] pktcdvd: don't rely on bio_init() preserving bio->bi_destructor
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46E5A6D1.3050704@free.fr> <46E9BEB1.3060504@free.fr> <20070914093358.GB25592@kernel.dk> <20070914110606.GJ25592@kernel.dk> <46EADB35.7000309@free.fr>
In-Reply-To: <46EADB35.7000309@free.fr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14.09.2007 21:04, Laurent Riffard a écrit :
> Le 14.09.2007 13:06, Jens Axboe a écrit :
>> On Fri, Sep 14 2007, Jens Axboe wrote:
>>> On Fri, Sep 14 2007, Laurent Riffard wrote:
>>>> Le 10.09.2007 22:19, Laurent Riffard a écrit :
>>>>> Jens,
>>>>>
>>>>> git-block.patch broke pktcdvd, I've got an Oops while syncing:
>>>>>
> [snip]
>>>> I dig through git-block.patch and the culprit seems to be commit
>>>> c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
>>>> bio_init()".
>>>>
>>>> Maybe the real bug is a bad bio initialization in pktcdvd driver,
>>>> which is revealed by this commit ?
>>> At least pktcdvd doesn't expect bio->bi_io_vec[] to be cleared, that's
>>> why it's oopsing now. I'll revert this bit for now, thanks for the
>>> report.
>> Rethinking this, I think bio_init() is doing the right thing, only
>> pktcdvd seems to rely on it preserving some members. So I'd rather fixup
>> pktcdvd instead.
>>
>> Does this work for you?
> 
> Well, it's better: I was able to mount the DVD-RW, sync, and write data,
> but kernel oopsed when I unmounted the drive:

Jens,

this patch, applied on top of your previous patch, solved it.



pktcdvd: don't rely on bio_init() preserving bio->bi_destructor

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
---
 drivers/block/pktcdvd.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-mm/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6-mm.orig/drivers/block/pktcdvd.c
+++ linux-2.6-mm/drivers/block/pktcdvd.c
@@ -1156,6 +1156,7 @@ static void pkt_gather_data(struct pktcd
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
 		bio->bi_io_vec = vec;
+		bio->bi_destructor = pkt_bio_destructor;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1453,6 +1454,7 @@ static void pkt_start_write(struct pktcd
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
 	pkt->w_bio->bi_io_vec = bvec;
+	pkt->w_bio->bi_destructor = pkt_bio_destructor;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();




