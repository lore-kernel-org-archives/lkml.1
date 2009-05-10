Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZEJViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZEJViA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbZEJVgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:4536 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbZEJVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jKIV56FQUwklm2GTG5fJ78kMWVEtZj1fAFo6ZK8Jx5NmFHjEKR0/GDO+RVZ3yyPacF
         EpPuI8Y3VljySEb+w3zqFnn5g2jVRGJg5mZgZXAOvU/obMz+taZC7SUn+UB4GKZqfdy4
         ujyYYnu8Lo6T093WikGi00kumijs5765UZbuA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/14] ide: unify interrupt reason checking
Date: Sun, 10 May 2009 23:39:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-15-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-15-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905102339.38126.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 09:45:34 Borislav Petkov wrote:
> Add ide_check_ireason() function that handles all ATAPI devices. Move
> the ATAPI_COD check later in the if-else chain since the case for
> ATAPI_COD to be set is rather unlikely in a normal operation. Also, add
> a branch predictor hint for it. Generally, move all unlikely cases in
> ireason checking further down in the code path.
> 
> In addition, add PFX for printks originating from ide-atapi. Finally,
> remove ide_cd_check_ireason.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c |   94 ++++++++++++++++++++++++++++++++++-------------
>  drivers/ide/ide-cd.c    |   48 +-----------------------
>  include/linux/ide.h     |    2 +
>  3 files changed, 71 insertions(+), 73 deletions(-)

[...]

> @@ -324,6 +327,56 @@ void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
>  EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
>  
>  /*
> + * Check the contents of the interrupt reason register and attempt to recover if
> + * there are problems.
> + *
> + * Returns:
> + * - 0 if everything's ok
> + * - 1 if the request has to be terminated.
> + */
> +int ide_check_ireason(ide_drive_t *drive, struct request *rq, int len,
> +		      int ireason, int rw)
> +{
> +	ide_hwif_t *hwif = drive->hwif;
> +
> +	debug_log("ireason: 0x%x, rw: 0x%x\n", ireason, rw);
> +
> +	if (ireason == (!rw << 1))
> +		return 0;
> +	else if (ireason == (rw << 1)) {
> +		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
> +				drive->name, __func__);
> +
> +		if (dev_is_idecd(drive))
> +			ide_pad_transfer(drive, rw, len);
> +	}
> +	else if (!rw && ireason == ATAPI_COD) {

ERROR: else should follow close brace '}'
#90: FILE: drivers/ide/ide-atapi.c:353:
+       }
+       else if (!rw && ireason == ATAPI_COD) {

> +		if (dev_is_idecd(drive)) {
> +			/*
> +			 * some drives (ASUS) seem to tell us that status info

s/some/Some/

> +			 * is available.  Just get it and ignore.
> +			 */
> +			(void)hwif->tp_ops->read_status(hwif);
> +			return 0;
> +		}
> +	} else {
> +		if (unlikely(ireason & ATAPI_COD))
> +			printk(KERN_ERR PFX "%s: CoD != 0 in %s\n", drive->name,
> +					__func__);

This is redundant given printk() below and using unlikely() in error-only
code-paths is overdoing it a bit (putting it very mildly)...

> +		/* drive wants a command packet, or invalid ireason... */
> +		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
> +				drive->name, __func__, ireason);

> @@ -501,13 +543,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
>  
>  	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
>  		(ireason & ATAPI_IO))) {
> -		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
> +		printk(KERN_ERR PFX "%s: (IO,CoD != (0,1) while issuing "

WARNING: line over 80 characters
#203: FILE: drivers/ide/ide-atapi.c:625:
+                       printk(KERN_ERR PFX "%s: (IO,CoD) != (0,1) while issuing "

[ Please remember about checkpatch.pl. ]

> @@ -652,9 +608,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  		goto out_end;
>  	}
>  
> -	/* check which way to transfer data */
> -	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
> -	if (rc)
> +	if (ide_check_ireason(drive, rq, len, ireason, write))
>  		goto out_end;

This introduces a real bug -- we check rc's value in "out_end" path.
