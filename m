Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZFBKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZFBKOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZFBKOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 06:14:05 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40735 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZFBKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 06:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Q6n8rsK+14kAiGgBTnvGsxfUVLLZTU3m6byAYHVT8ofF02fGsstsJpG/JGT/CauQDq
         SXfLRDq+bGC6I0/mvoecfK+ew3wmhF0z0U4qdnMNZO2BbxZfeRywFzfM31YRjfae5QMz
         pE3iuxMAL44nI35gjhTtkygoT5EbOeV/JB0wg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically
Date: Tue, 2 Jun 2009 12:18:33 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com> <1243926308-32385-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1243926308-32385-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906021218.33787.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 02 June 2009 09:05:07 Borislav Petkov wrote:
> There are two sites where the flag is being changed: ide_retry_pc
> and idetape_do_request. Both codepaths are protected by hwif->busy
> (ide_lock_port) and therefore we shouldn't need the atomic accesses. The
> only problem would be the compiler reordering the accesses, therefore the
> optimization barrier.
> 
> Spotted-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

[...]

> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -656,15 +656,24 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  
>  	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
>  	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
> -		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
> +		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
>  
>  	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
> -		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
> +		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
>  		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
>  	}
>  
> -	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
> -	    (stat & ATA_DSC) == 0) {
> +	/*
> +	 * This is a precaution for IDE_AFLAG_IGNORE_DSC being conditionally set
> +	 * above. We don't need a stronger enforcement of ordering because the
> +	 * read below cannot precede the earlier write out-of-order since it is
> +	 * to the same location. Also, since we have the ide port locked during
> +	 * the ->do_request(), we only have to be aware of gcc reordering stuff.
> +	 */
> +	barrier();

Are you seeing a real problem with gcc here?  No sane compiler should need
a barrier() here (we would probably need zillions of them in kernel if it
really does).
