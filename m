Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0CCDtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:49:50 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60364 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0CCDts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=uNY+r66xzJ42tK8EFyybkRbwmqytFMBDFtSSPLUlpZSUskL6dpJrs2LgjKCPfJD1um
         wK6PgamQzXXOFQ/5G4KAzG2GL2NsY3sal0oh483a0l+nEMb5FPyAgO9zoHCSVv3ujwY2
         bA1byZCHp3+P1fw+9KHLx+bLz1dN+8O/6FLwc=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk>
Date: Wed, 03 Mar 2010 06:49:43 +0300
In-Reply-To: <20100228184634.GI5768@kernel.dk> (Jens Axboe's message of "Sun,
	28 Feb 2010 19:46:34 +0100")
Message-ID: <874okyf4iw.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Jens Axboe <jens.axboe@oracle.com> writes:

> On Sat, Feb 27 2010, Dmitry Monakhov wrote:
>> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
>> against this value. But in case of fs_optimization merge we compare
>> with wrong value. This patch must be included in
>>  b428cd6da7e6559aca69aa2e3a526037d3f20403
>> But accidentally i've forgot to add this in the initial patch.
>> To make things straight let's replace all such checks.
>> In fact this makes code easy to understand.
>
> Agree, applied.
Ohh.. as you already know this patch break dm-layer. Sorry.
This is because dm->merge may return more than requested. So correct
check must test against less what requested. Correct patch attached.


--=-=-=
Content-Disposition: inline;
 filename=0001-blkdev-fix-merge_bvec_fn-return-value-checks-v2.patch

>From 145fb49bf2251f445ca29c5218333367448932d6 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 3 Mar 2010 06:28:06 +0300
Subject: [PATCH] blkdev: fix merge_bvec_fn return value checks v2

merge_bvec_fn() returns bvec->bv_len on success. So we have to check
against this value. But in case of fs_optimization merge we compare
with wrong value. This patch must be included in
 b428cd6da7e6559aca69aa2e3a526037d3f20403
But accidentally i've forgot to add this in the initial patch.
To make things straight let's replace all such checks.
In fact this makes code easy to understand.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 88094af..975657a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -557,7 +557,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 					.bi_rw = bio->bi_rw,
 				};
 
-				if (q->merge_bvec_fn(q, &bvm, prev) < len) {
+				if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
 					prev->bv_len -= len;
 					return 0;
 				}
@@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		 * merge_bvec_fn() returns number of bytes it can accept
 		 * at this offset
 		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < len) {
+		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
 			bvec->bv_page = NULL;
 			bvec->bv_len = 0;
 			bvec->bv_offset = 0;
-- 
1.6.6


--=-=-=--
