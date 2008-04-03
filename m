Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbYDCVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbYDCVvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYDCVuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:50:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:23350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760843AbYDCVuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=rQzrKum13PQ2FWuH6YfjE0EPoJgF2WiSqaptySdO2f6jr/dIsqNlDIXlCQnR6qMRgu6sCjRypDewtBFroOse9FUarham5ZN/qWzy3pZ7/3cmBHN2sisJ5nW/+CcE+BIAZyF6oOqdG4knQaa6Qz83D2KJmXxgJSjLuzkldvvfaBE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 4/5] ide-tape: improve buffer pages freeing strategy
Date: Thu, 3 Apr 2008 23:33:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com> <1206812769-10065-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1206812769-10065-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804032333.23513.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 March 2008, Borislav Petkov wrote:
> Instead of freeing pages one by one, free them 2^order-wise. Also, mv
> __idetape_kfree_stage() to ide_tape_kfree_buffer().
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   37 +++++++++++++++++++------------------
>  1 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index cf4351c..dcaefef 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -583,20 +583,21 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
>  	}
>  }
>  
> -/* Free a stage along with its related buffers completely. */
> -static void __idetape_kfree_stage(idetape_stage_t *stage)
> +/* Free data buffers completely. */
> +static void ide_tape_kfree_buffer(idetape_stage_t *stage)
>  {
>  	struct idetape_bh *prev_bh, *bh = stage->bh;
> -	int size;
> -
> -	while (bh != NULL) {
> -		if (bh->b_data != NULL) {
> -			size = (int) bh->b_size;
> -			while (size > 0) {
> -				free_page((unsigned long) bh->b_data);
> -				size -= PAGE_SIZE;
> -				bh->b_data += PAGE_SIZE;
> -			}
> +
> +	while (bh) {
> +		u32 size = bh->b_size;
> +
> +		while (size) {
> +			unsigned int order = fls(size >> PAGE_SHIFT)-1;
> +
> +			if (bh->b_data)
> +				free_pages((unsigned long)bh->b_data, order);
> +
> +			size &= (order-1);
>  		}

Hmmm, don't we also need to update bh->b_data?

[ I added the change below to the merged patch version for now: ]

@@ -598,6 +598,7 @@
 				free_pages((unsigned long)bh->b_data, order);
 
 			size &= (order-1);
+			bh->b_data += (1 << order) * PAGE_SIZE;
 		}
 		prev_bh = bh;
 		bh = bh->b_reqnext;
