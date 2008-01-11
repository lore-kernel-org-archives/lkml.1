Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbYALO0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbYALO0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYALO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:26:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:50604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118AbYALO0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=NbIgWYM3hR/qlgMfPOWvV2FhophvNUqehi2O6AZ1h8jV1lL5QigoUC+3nOJUsUN2LURxr8g9sjibzJff/dEi0DfJg+KZryCibLFtyYf11cYu+cii6XZaWYFZHJXo/rak+Yz/2XQi1Z5KSG4zRz6N+JvsHpyOz9dwRD3vvUh7D1M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 04/21] ide-floppy: cleanup and unify debugging macro calls
Date: Sat, 12 Jan 2008 00:56:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801120056.21033.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> * some debug_log() calls were not using "ide-floppy: " prefix
> 
> * a few used printk levels different than KERN_INFO (KERN_NOTICE
>   and KERN_ERR, which is the default one if no level is given)
> 
> There should be no functional change resulting from this patch.

Hmm, but there are functional changes as noted above, I removed this line
from the patch description.

> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---

with IDEFLOPPY_DEBUG_LOG set to 1:

drivers/ide/ide-floppy.c: In function ‘idefloppy_pc_intr’:
drivers/ide/ide-floppy.c:704: warning: too many arguments for format
drivers/ide/ide-floppy.c: In function ‘idefloppy_do_request’:
drivers/ide/ide-floppy.c:1126: error: ‘struct request’ has no member named ‘flags’
make[1]: *** [drivers/ide/ide-floppy.o] Error 1
make: *** [drivers/ide/ide-floppy.o] Error 2

which translate to:

[...]

>  		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
>  			/* Error detected */
> -			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
> -				drive->name);
> +			debug_log("I/O error\n", drive->name);

"%s: I/O error\n"

[...]

> -	debug_log(KERN_INFO "dev: %s, flags: %lx, errors: %d\n",
> +	debug_log("dev: %s, flags: %lx, errors: %d\n",
>  			rq->rq_disk ? rq->rq_disk->disk_name : "?",
>  			rq->flags, rq->errors);

This was broken before this patch by rq->flags -> rq->cmd_type change
(so your patch is not to blame for breaking IDEFLOPPY_DEBUG_LOG ;).

I fixed the above issues while merging the patch.
