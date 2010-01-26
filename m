Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077Ab0AZORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0AZORU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012Ab0AZORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:17:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65466 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab0AZORJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JTEJ7vnYLLMoLT+spu9en0+v2D9wmTO8bYO+uZ562AeWQePNf719pVtow/FGDnDsZE
         CIRVDDlMWGcG0D7rP1SiTZuLAS18xzgGFns961VfAgsbfVZHKbEE/+1jaR80fBPKWu8z
         V78KOh47AqvZJauMpNFmZmGByfqpPWmLjkVrY=
MIME-Version: 1.0
In-Reply-To: <20100126132928.GI13771@kernel.dk>
References: <87hbq980tc.fsf@openvz.org> <20100126132928.GI13771@kernel.dk>
Date: Tue, 26 Jan 2010 17:17:07 +0300
X-Google-Sender-Auth: 60d60ba45c92a6ac
Message-ID: <c18d6aa21001260617y3ddad4deq139bf2afbc37d0be@mail.gmail.com>
Subject: Re: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn 
	case
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 4:29 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Jan 26 2010, Dmitry Monakhov wrote:
>> Hi, year ago I've sent a patch which fix false bio merge rejects, but
>> seems patch was missed. Currently the issue is still present.
>>
>
>> From 92a97ef181e15caa94bd56a1ade5c337db599b79 Mon Sep 17 00:00:00 2001
>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>> Date: Tue, 26 Jan 2010 16:01:34 +0300
>> Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case
>>
>> We have to properly decrease bi_size in order to merge_bvec_fn return
>> right result.  Otherwise this result in false merge rejects for two
>> absolutely valid bio_vecs.  This may cause significant performance penalty
>> for example Itanium: page_size == 16k, fs_block_size == 1k and block device
>> is raid with small chunk_size.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/bio.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index 76e6713..9f8e517 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -548,7 +548,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>>                               struct bvec_merge_data bvm = {
>>                                       .bi_bdev = bio->bi_bdev,
>>                                       .bi_sector = bio->bi_sector,
>> -                                     .bi_size = bio->bi_size,
>> +                                     .bi_size = bio->bi_size -
>> +                                                     (prev->bv_len - len),
>>                                       .bi_rw = bio->bi_rw,
>>                               };
>
> Hmm confused. why isn't this just bio->bi_size - len?
because we have following scenario:
0) old_bv_len = prev->bv_len ;
1) prev->bv_len += len;
2)->merge_bvec_fn()
      usually it looks like follows
      if (bio->bv_len + bvm->bi_size > max_chunk_size)
          goto fail
     So formally we detach last bvec increase it size and try to
attach it to bio.

     but old_bv_len is already accounted in bi_size, so we have to decrease
    bi_size to this value, and old_bv_len = (prev->bv_len - len) at
that moment.
    I've used math manipuation in order to avoid temporary variable
    because stack size is matter on block layer.
>
> --
> Jens Axboe
>
>
