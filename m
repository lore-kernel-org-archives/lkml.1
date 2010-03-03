Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0CCSpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:45:12 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34275 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Ha4RA2p4H1rH+U3TpGnAWYdPVtEed7S/b1PwMaw9j4YG5YKzNCagzBXkAkZOsaKmV3
         eTGrw5t6RnpmkiE0GBM3q4ufMu21tRcSNyaj6dZpCRGcBFqgByRwCQJ8e8tJQDFBrpSZ
         N04iNDnEkZhGsOnoT6SbNNUcFq9aThoJd6/r4=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
Date: Wed, 03 Mar 2010 21:45:05 +0300
In-Reply-To: <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	(Mike Snitzer's message of "Wed, 3 Mar 2010 13:20:23 -0500")
Message-ID: <87wrxtkzwu.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> On Tue, Mar 2, 2010 at 10:49 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>>
>>> On Sat, Feb 27 2010, Dmitry Monakhov wrote:
>>>> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
>>>> against this value. But in case of fs_optimization merge we compare
>>>> with wrong value. This patch must be included in
>>>>  b428cd6da7e6559aca69aa2e3a526037d3f20403
>>>> But accidentally i've forgot to add this in the initial patch.
>>>> To make things straight let's replace all such checks.
>>>> In fact this makes code easy to understand.
>>>
>>> Agree, applied.
>> Ohh.. as you already know this patch break dm-layer. Sorry.
>> This is because dm->merge may return more than requested. So correct
>> check must test against less what requested. Correct patch attached.
>
> Yes, it is quite common for dm_merge_bvec() to return greater than the
> requested length.
>
> But dm_merge_bvec() returning a maximum length, rather than requested,
> isn't special.  All the other blk_queue_merge_bvec() callers' merge
> functions appear to return "maximum amount of bytes we can accept at
> this offset" too.
What for? Does it allow us to make some optimization?
For example like follows:
bio_add_pageS(bio, **pages) {
   /* call merge_fn only one untill all space exhausted */                
   ret = merge_fn()  (this returns huge value (1024*1024))
   while (ret) { 
          bio->bi_io_vec[bio->bi_vcnt - 1].bv_page = page;
          ...
          ret -= PAGE_SIZE;
          bio->bi_vcnt++;
   }
}
IMHO the answer is *NO*, this code will unlikely to work.
>
> __bio_add_page() only needs to care about whether the
> 'q->merge_bvec_fn' return is _less than_ the requested length.
>
>> From 145fb49bf2251f445ca29c5218333367448932d6 Mon Sep 17 00:00:00 2001
>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>> Date: Wed, 3 Mar 2010 06:28:06 +0300
>> Subject: [PATCH] blkdev: fix merge_bvec_fn return value checks v2
>>
>> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
>> against this value. But in case of fs_optimization merge we compare
>> with wrong value. This patch must be included in
>>  b428cd6da7e6559aca69aa2e3a526037d3f20403
>> But accidentally i've forgot to add this in the initial patch.
>> To make things straight let's replace all such checks.
>> In fact this makes code easy to understand.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/bio.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index 88094af..975657a 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -557,7 +557,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>>                                        .bi_rw = bio->bi_rw,
>>                                };
>>
>> -                               if (q->merge_bvec_fn(q, &bvm, prev) < len) {
>> +                               if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
>>                                        prev->bv_len -= len;
>>                                        return 0;
>>                                }
>> @@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>>                 * merge_bvec_fn() returns number of bytes it can accept
>>                 * at this offset
>>                 */
>> -               if (q->merge_bvec_fn(q, &bvm, bvec) < len) {
>> +               if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
>>                        bvec->bv_page = NULL;
>>                        bvec->bv_len = 0;
>>                        bvec->bv_offset = 0;
>
> NOTE this 2nd hunk doesn't change anything at all because: bvec->bv_len = len;
Yess. IMHO this makes code more readable.
>
> Mike
