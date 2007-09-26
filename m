Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbXIZTrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbXIZTrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbXIZTrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:47:45 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:38344 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbXIZTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:47:44 -0400
Message-ID: <46FAB75D.9020800@tiscali.nl>
Date: Wed, 26 Sep 2007 21:47:41 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] dmapool: Validate parameters to dma_pool_create
References: <20070926185757.GM3899@parisc-linux.org> <11908332793750-git-send-email-willy@linux.intel.com>
In-Reply-To: <11908332793750-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Check that 'align' is a power of two, like the API specifies.
> Align 'size' to 'align' correctly -- the current code has an off-by-one.
> The ALIGN macro in kernel.h doesn't.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  mm/dmapool.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index a359b5e..f5d12a7 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -107,17 +107,18 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  {
>  	struct dma_pool *retval;
>  
> -	if (align == 0)
> +	if (align == 0) {
>  		align = 1;
> -	if (size == 0)
> +	} else if (align & (align - 1)) {
>  		return NULL;
> -	else if (size < align)
> -		size = align;
> -	else if ((size % align) != 0) {
> -		size += align + 1;
> -		size &= ~(align - 1);
>  	}
>  
> +	if (size == 0)
> +		return NULL;

The brackets in the first if/else are not required, and you could combine the two statements:

	if (align == 0)
		align = 1;
	else if (align & (align - 1) || size == 0)
		return NULL;
> +
> +	if ((size % align) != 0)
> +		size = ALIGN(size, align);
> +
>  	if (allocation == 0) {
>  		if (PAGE_SIZE < size)
>  			allocation = size;

