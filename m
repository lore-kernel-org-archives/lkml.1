Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXJWVb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXJWVb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXJWVbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:31:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:2241 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXJWVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=jWFvEQM+T+LO3nHB7AnRvOCNlzh5iArEWaGDImqF/pR6f+b1NJNd7Lkfm8LU8FFVbh4qxpv50gWx2ZjJG0qgU6FhcinRpncSzKY/dEIZrALCRcITTPUEmi+lbMooEXsT/MdKQbXq911u0GP8+AmQeFppr1F/HbQdrU2/2XqiDCw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH]: Fix IDE host_flags regression.
Date: Tue, 23 Oct 2007 21:50:14 +0200
User-Agent: KMail/1.9.7
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20071022.020900.41634188.davem@davemloft.net>
In-Reply-To: <20071022.020900.41634188.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710232150.14284.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Thanks for debugging & fixing this.

On Monday 22 October 2007, David Miller wrote:
> 
> Bart, please test your changes.

Well, I do.  However due to hardware diversity it is not practically
possible to test them all myself...

> Thank you.
> 
> [IDE]: Expand hwif->host_flags so that it fits new flags.
> 
> This fixes regressions added by:
> 238e4f142c33bb34440cc64029dde7b9fbc4e65f

Yeah, sorry for that.  ->host flags were expanded in struct ide_pci_device_s
(now struct ide_port_info) but not in struct hwif_s.  This went unnoticed
because majority of new flags are used only through struct ide_pci_device_s.

The exceptions are:
- IDE_HFLAG_NO_LBA48 (only user is trm290, exotic hardware)
- IDE_HFLAG_NO_LBA48_DMA (only user is alim15x3, revisions <= 0xC4)
- IDE_HFLAG_ERROR_STOPS_FIFO (the error path of pdc202xx_{old,new}) 

What worries me a bit is that commit 238e4f142c33bb34440cc64029dde7b9fbc4e65f
was in -mm since 2.6.23-rc4-mm1 (released on Sep 1 2007) and nobody reported
the issue earlier... 

> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index 2e4b8dd..4ed4777 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -667,7 +667,7 @@ typedef struct hwif_s {
>  	u8 straight8;	/* Alan's straight 8 check */
>  	u8 bus_state;	/* power state of the IDE bus */
>  
> -	u16 host_flags;
> +	u32 host_flags;
>  
>  	u8 pio_mask;
