Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbXJWRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbXJWRKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXJWRKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:10:23 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19879 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753950AbXJWRKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:10:21 -0400
Message-ID: <471E2A96.7050304@panasas.com>
Date: Tue, 23 Oct 2007 19:08:38 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 17:08:02.0548 (UTC) FILETIME=[45362340:01C81597]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007 at 20:11 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> Change the page member of the scatterlist structure to be an unsigned
> long, and encode more stuff in the lower bits:
> 
> - Bits 0 and 1 zero: this is a normal sg entry. Next sg entry is located
>   at sg + 1.
> - Bit 0 set: this is a chain entry, the next real entry is at ->page_link
>   with the two low bits masked off.
> - Bit 1 set: this is the final entry in the sg entry. sg_next() will return
>   NULL when passed such an entry.
> 
> It's thus important that sg table users use the proper accessors to get
> and set the page member.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
<snip>
>  
>  /**
>   * sg_set_page - Set sg entry to point at given page
> @@ -20,11 +37,20 @@
>   **/
>  static inline void sg_set_page(struct scatterlist *sg, struct page *page)
>  {
> -	sg->page = page;
> +	unsigned long page_link = sg->page_link & 0x3;
> +
You might want to put a BUG_ON(page & 0x3); Make sure
you're not loosing information. (The m68k problem)

> +	sg->page_link = page_link | (unsigned long) page;
>  }
>  
> -#define sg_page(sg)	((sg)->page)
> +#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
>  
<snip>

Boaz
