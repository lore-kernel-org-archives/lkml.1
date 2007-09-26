Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbXIZUMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbXIZUMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXIZUMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:12:33 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:40735 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbXIZUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:12:32 -0400
Message-ID: <46FABD2B.40901@tiscali.nl>
Date: Wed, 26 Sep 2007 22:12:27 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] dmapool: Improve memory usage for devices which can't
 cross boundaries
References: <20070926185757.GM3899@parisc-linux.org> <11908332791548-git-send-email-willy@linux.intel.com>
In-Reply-To: <11908332791548-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

[...]

> @@ -142,14 +144,13 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  	if ((size % align) != 0)
>  		size = ALIGN(size, align);
>  
> -	if (allocation == 0) {
> -		if (PAGE_SIZE < size)
> -			allocation = size;
> -		else
> -			allocation = PAGE_SIZE;
> -		// FIXME: round up for less fragmentation
> -	} else if (allocation < size)
> +	allocation = max_t(size_t, size, PAGE_SIZE);
> +
> +	if (!boundary) {
> +		boundary = allocation;
> +	} else if ((boundary < size) || (boundary & (boundary - 1))) {
>  		return NULL;
> +	}

	if (!boundary)
		boundary = allocation;
	else if (boundary < size || boundary & (boundary - 1))
		return NULL;

[...]

> @@ -190,11 +192,14 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
>  {
>  	unsigned int offset = 0;
> +	unsigned int next_boundary = pool->boundary;
>  
>  	do {
>  		unsigned int next = offset + pool->size;
> -		if (unlikely((next + pool->size) >= pool->allocation))
> -			next = pool->allocation;
> +		if (unlikely((next + pool->size) >= next_boundary)) {

		if (unlikely(next + pool->size >= next_boundary)) {

[...]
