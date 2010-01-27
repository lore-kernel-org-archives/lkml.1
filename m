Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018Ab0A0VLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0A0VLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005Ab0A0VLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:11:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39059 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab0A0VLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=dqyRmsyfsadRQgE8pBP+FWjN49HXL40gmD1XtsJ8yS71IRRhN6NOeOsMb66GYjVzFY
         2Q69s3fArbPh7Z+FPZXAhxqiVMMYAfSvz5PZpBsV8TF8Ybh45LSWPMFx831VudFk+m+A
         nUGAIUYRFH3ijDBZaJzindr823Hw6CqcqCGWg=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn  case
References: <87hbq980tc.fsf@openvz.org> <20100126132928.GI13771@kernel.dk>
	<c18d6aa21001260617y3ddad4deq139bf2afbc37d0be@mail.gmail.com>
Date: Thu, 28 Jan 2010 00:11:37 +0300
In-Reply-To: <c18d6aa21001260617y3ddad4deq139bf2afbc37d0be@mail.gmail.com>
	(Dmitry Monakhov's message of "Tue, 26 Jan 2010 17:17:07 +0300")
Message-ID: <874om7jlrq.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> On Tue, Jan 26, 2010 at 4:29 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Tue, Jan 26 2010, Dmitry Monakhov wrote:
>>> Hi, year ago I've sent a patch which fix false bio merge rejects, but
>>> seems patch was missed. Currently the issue is still present.
>>>
>>
>>> From 92a97ef181e15caa94bd56a1ade5c337db599b79 Mon Sep 17 00:00:00 2001
>>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>>> Date: Tue, 26 Jan 2010 16:01:34 +0300
>>> Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_=
bvec_fn case
>>>
>>> We have to properly decrease bi_size in order to merge_bvec_fn return
>>> right result. =C2=A0Otherwise this result in false merge rejects for two
>>> absolutely valid bio_vecs. =C2=A0This may cause significant performance=
 penalty
>>> for example Itanium: page_size =3D=3D 16k, fs_block_size =3D=3D 1k and =
block device
>>> is raid with small chunk_size.
>>>
>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>> ---
>>> =C2=A0fs/bio.c | =C2=A0 =C2=A03 ++-
>>> =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/bio.c b/fs/bio.c
>>> index 76e6713..9f8e517 100644
>>> --- a/fs/bio.c
>>> +++ b/fs/bio.c
>>> @@ -548,7 +548,8 @@ static int __bio_add_page(struct request_queue *q, =
struct bio *bio, struct page
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct bvec_merge_data bvm =3D {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bi_bdev =3D=
 bio->bi_bdev,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bi_sector =
=3D bio->bi_sector,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bi_size =3D bio->=
bi_size,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bi_size =3D bio->=
bi_size -
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (prev->bv_len - len),
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bi_rw =3D b=
io->bi_rw,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
>>
>> Hmm confused. why isn't this just bio->bi_size - len?
I've attached more descriptive  version of the patch. Jens, please
clarify your opinion to the patch( do you like it or not?)
I don't want it miss again.

--=-=-=
Content-Disposition: inline;
 filename=0001-PATCH-block-fix-bio_add_page-for-non-trivial-merge_b.patch

>From 65ac8c9a2988310a79215b68e9c93b6dca6c6665 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 27 Jan 2010 22:44:36 +0300
Subject: [PATCH] [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case

We have to properly decrease bi_size in order to merge_bvec_fn return
right result.  Otherwise this result in false merge rejects for two
absolutely valid bio_vecs.  This may cause significant performance
penalty for example fs_block_size == 1k and block device is raid0 with
small chunk_size = 8k. Then it is impossible to merge 7-th fs-block in
to bio which already has 6 fs-blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 76e6713..7448c7d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -542,13 +542,18 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
+			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
 
 			if (q->merge_bvec_fn) {
 				struct bvec_merge_data bvm = {
+					/* prev_bvec is already charged in
+					   bi_size, discharge it in order to
+					   simulate merging updated prev_bvec
+					   as new bvec. */
 					.bi_bdev = bio->bi_bdev,
 					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size,
+					.bi_size = bio->bi_size - prev_bv_len,
 					.bi_rw = bio->bi_rw,
 				};
 
-- 
1.6.3.3


--=-=-=--
