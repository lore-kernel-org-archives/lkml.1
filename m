Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYCKGkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYCKGkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYCKGkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:40:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10308 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYCKGkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=aSA9FUxSXvWkSlR30D8yBNdGoENdQGC87303kV4zSM/ABoYILC5y0U35yabtBarHCyAiQAx5iE9540seJF8Hja+zYOctdFctb6DmAE/3HYEZsEXD5n9Pz8yOCSMX7U+wBVYpdgect7nTGXkjNxsxhXfm8UbeGH8w5sQDDOrHuBk=
Date: Tue, 11 Mar 2008 07:40:10 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] ide-tape: remove tape->cache_stage
Message-ID: <20080311064010.GA4266@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <1205082632-3418-2-git-send-email-petkovbb@gmail.com> <200803110024.51339.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803110024.51339.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 12:24:51AM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 09 March 2008, Borislav Petkov wrote:
> > Prior to allocating a new pipeline stage, the code checked for the existence of
> > a cached pipeline stage to use. Do away with and stick to normal pipeline
> > stages only.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> I modified it slightly while merging since AFAICS we still need to check
> 'tape->nr_stages >= tape_max_stages' for idetape_add_chrdev_write_request().

Yep, thanks for spotting that landmine. By the way this driver is full of it :).

> From: Borislav Petkov <petkovbb@googlemail.com>
> Subject: [PATCH 1/4] ide-tape: remove tape->cache_stage
> 
> Prior to allocating a new pipeline stage, the code checked for the existence of
> a cached pipeline stage to use. Do away with and stick to normal pipeline
> stages only.
> 
> [bart: keep idetape_kmalloc_stage() for now]
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> Index: b/drivers/ide/ide-tape.c
> ===================================================================
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -365,8 +365,6 @@ typedef struct ide_tape_obj {
>  	idetape_stage_t *next_stage;
>  	/* New requests will be added to the pipeline here */
>  	idetape_stage_t *last_stage;
> -	/* Optional free stage which we can use */
> -	idetape_stage_t *cache_stage;
>  	int pages_per_stage;
>  	/* Wasted space in each stage */
>  	int excess_bh_size;
> @@ -1686,16 +1684,10 @@ abort:
>  
>  static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
>  {
> -	idetape_stage_t *cache_stage = tape->cache_stage;
> -
>  	debug_log(DBG_PROCS, "Enter %s\n", __func__);
>  
>  	if (tape->nr_stages >= tape->max_stages)
>  		return NULL;
> -	if (cache_stage != NULL) {
> -		tape->cache_stage = NULL;
> -		return cache_stage;
> -	}
>  	return __idetape_kmalloc_stage(tape, 0, 0);
>  }
>  
> @@ -3245,10 +3237,7 @@ static int idetape_chrdev_release(struct
>  		else
>  			idetape_wait_for_pipeline(drive);
>  	}
> -	if (tape->cache_stage != NULL) {
> -		__idetape_kfree_stage(tape->cache_stage);
> -		tape->cache_stage = NULL;
> -	}
> +
>  	if (minor < 128 && test_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags))
>  		(void) idetape_rewind_tape(drive);
>  	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {

-- 
Regards/Gruﬂ,
    Boris.
