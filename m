Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYCJXNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYCJXNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYCJXNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:13:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:52219 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbYCJXM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=DGZJ/E6o0B8jEuFHnCK+XJjI7KbX1R/rqQlNtKXjQ3NTF6ZxALeec+ibP0TXczEpsOQveSOLbwrm7yABCixNSZb4AnRv9jO3FT84iwvawxlPinmuFr/l8CzluRLi2MRJKRmy/+gW9FL20HvkZrEk0q8fE19sU3QrAf4DCtK2jAM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/4] ide-tape: remove tape->cache_stage
Date: Tue, 11 Mar 2008 00:24:51 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <1205082632-3418-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205082632-3418-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803110024.51339.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008, Borislav Petkov wrote:
> Prior to allocating a new pipeline stage, the code checked for the existence of
> a cached pipeline stage to use. Do away with and stick to normal pipeline
> stages only.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

I modified it slightly while merging since AFAICS we still need to check
'tape->nr_stages >= tape_max_stages' for idetape_add_chrdev_write_request().

From: Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH 1/4] ide-tape: remove tape->cache_stage

Prior to allocating a new pipeline stage, the code checked for the existence of
a cached pipeline stage to use. Do away with and stick to normal pipeline
stages only.

[bart: keep idetape_kmalloc_stage() for now]

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -365,8 +365,6 @@ typedef struct ide_tape_obj {
 	idetape_stage_t *next_stage;
 	/* New requests will be added to the pipeline here */
 	idetape_stage_t *last_stage;
-	/* Optional free stage which we can use */
-	idetape_stage_t *cache_stage;
 	int pages_per_stage;
 	/* Wasted space in each stage */
 	int excess_bh_size;
@@ -1686,16 +1684,10 @@ abort:
 
 static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 {
-	idetape_stage_t *cache_stage = tape->cache_stage;
-
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (tape->nr_stages >= tape->max_stages)
 		return NULL;
-	if (cache_stage != NULL) {
-		tape->cache_stage = NULL;
-		return cache_stage;
-	}
 	return __idetape_kmalloc_stage(tape, 0, 0);
 }
 
@@ -3245,10 +3237,7 @@ static int idetape_chrdev_release(struct
 		else
 			idetape_wait_for_pipeline(drive);
 	}
-	if (tape->cache_stage != NULL) {
-		__idetape_kfree_stage(tape->cache_stage);
-		tape->cache_stage = NULL;
-	}
+
 	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
