Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbXGUSMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbXGUSMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXGUSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:11:54 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:7652 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXGUSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:11:52 -0400
Date: Sat, 21 Jul 2007 21:11:37 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070721181137.GH4152@rhun.haifa.ibm.com>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:19:58PM -0700, H. Peter Anvin wrote:
> Create an inline function for clflush(), with the proper arguments,
> and use it instead of hard-coding the instruction.
> 
> This also removes one instance of hard-coded wbinvd, based on a patch
> by Bauder de Oliveira Costa.
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Mostly looks good, but see below.

> diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
> index df8da72..41f46df 100644
> --- a/drivers/char/agp/efficeon-agp.c
> +++ b/drivers/char/agp/efficeon-agp.c
> @@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
>  		SetPageReserved(virt_to_page((char *)page));
>  
>  		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
> -			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
> +			clflush((char *)page+offset);

The original code flushes (*(page+offset)) whereas the new code
flushes (pagee+offset). Assuming this is a bug-fix, it should go as a
separate patch.

> @@ -268,15 +268,16 @@ static int efficeon_insert_memory(struct agp_memory * mem, off_t pg_start, int t
>  		*page = insert;
>  
>  		/* clflush is slow, so don't clflush until we have to */
> -		if ( last_page &&
> -		     ((unsigned long)page^(unsigned long)last_page) & clflush_mask )
> -		    asm volatile("clflush %0" : : "m" (*last_page));
> +		if (last_page &&
> +		    (((unsigned long)page^(unsigned long)last_page) &
> +		     clflush_mask))
> +			clflush(last_page);

Same thing.


>  		last_page = page;
>  	}
>  
>  	if ( last_page )
> -		asm volatile("clflush %0" : : "m" (*last_page));
> +		clflush(last_page);

Here too.

Cheers,
Muli
