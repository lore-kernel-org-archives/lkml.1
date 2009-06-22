Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZFVLoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZFVLoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZFVLn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:43:27 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43832 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbZFVLnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rLIS2XxIKMaOMAeMTsz11YCXD18rg0Xtvd95ElPRVIBnhCj7XLaiuVez36js9V4TOn
         GPZfrSWYCLM30laUrJT/NkccauYh4IuWr2sHeW1mc+4Cj8qWkcstg+v6Ofe9oq0cUU2Y
         TBLbVUDEPa5nWbZlFF4nOG3fjg1ohi6lodZdA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
Date: Mon, 22 Jun 2009 12:50:36 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1245650973.30547.3.camel@ht.satnam>
In-Reply-To: <1245650973.30547.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906221250.36318.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 08:09:33 Jaswinder Singh Rajput wrote:

> @@ -248,8 +250,9 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
>  		page = nth_page(page, (offset >> PAGE_SHIFT));
>  		offset %= PAGE_SIZE;
>  
> -		if (PageHighMem(page))
> -			local_irq_save(flags);
> +#ifdef CONFIG_HIGHMEM
> +		local_irq_save(flags);
> +#endif
>  
>  		buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
>  
> @@ -269,8 +272,9 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
>  
>  		kunmap_atomic(buf, KM_BIO_SRC_IRQ);
>  
> -		if (PageHighMem(page))
> -			local_irq_restore(flags);
> +#ifdef CONFIG_HIGHMEM
> +		local_irq_restore(flags);
> +#endif

This part is incorrect (adds a performance regression for low-mem pages
w/ HIGHMEM=y) and seems to be accidental (nothing about it in the patch
description).

Besides I would suggest splitting the patch on fix and cleanup parts.
