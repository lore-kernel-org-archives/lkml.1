Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYDPEXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYDPEXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 00:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYDPEWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 00:22:53 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:41513
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbYDPEWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 00:22:52 -0400
X-Authority-Analysis: v=1.0 c=1 a=YSWQqB5pQ2wA:10 a=26HdPeMOMtQA:10
 a=vGK5CW9ijm8SuqUrLw8A:9 a=09X17OGoLUk09lSJMqgA:7
 a=k_3eVp-4zJYpRCH2X5XbKbXvRZEA:4 a=jEp0ucaQiEUA:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer
From: Tom Zanussi <zanussi@comcast.net>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
In-Reply-To: <4804C95F.2080204@redhat.com>
References: <4804C95F.2080204@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 23:22:49 -0500
Message-Id: <1208319769.7893.16.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 11:27 -0400, Masami Hiramatsu wrote:
> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
> when the array size is bigger than one page. This enables relayfs to support
> bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> This is useful for a 64-bit system which has a plenty of memory (tens of
> giga bytes) and a large kernel memory space.
> 
> I tested it on x86-64 and ia64.
> 

Hi,

It looks ok to me, but it might be a little cleaner and avoid some
duplication if you add the new code as a couple of functions instead.
Just a suggestion...

Tom

>  kernel/relay.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> Index: 2.6.25-rc8-mm2/kernel/relay.c
> ===================================================================
> --- 2.6.25-rc8-mm2.orig/kernel/relay.c
> +++ 2.6.25-rc8-mm2/kernel/relay.c
> @@ -104,12 +104,20 @@ static int relay_mmap_buf(struct rchan_b
>  static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
>  {
>  	void *mem;
> -	unsigned int i, j, n_pages;
> +	unsigned int i, j, n_pages, pa_size;
> 
>  	*size = PAGE_ALIGN(*size);
>  	n_pages = *size >> PAGE_SHIFT;
> +	pa_size = n_pages * sizeof(struct page *);
> 
> -	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
> +	if (pa_size > PAGE_SIZE) {
> +		buf->page_array = vmalloc(pa_size);
> +		if (buf->page_array)
> +			memset(buf->page_array, 0, pa_size);
> +	} else {
> +		buf->page_array = kcalloc(n_pages, sizeof(struct page *),
> +					  GFP_KERNEL);
> +	}
>  	if (!buf->page_array)
>  		return NULL;
> 
> @@ -130,7 +138,10 @@ static void *relay_alloc_buf(struct rcha
>  depopulate:
>  	for (j = 0; j < i; j++)
>  		__free_page(buf->page_array[j]);
> -	kfree(buf->page_array);
> +	if (pa_size > PAGE_SIZE)
> +		vfree(buf->page_array);
> +	else
> +		kfree(buf->page_array);
>  	return NULL;
>  }
> 
> @@ -189,7 +200,10 @@ static void relay_destroy_buf(struct rch
>  		vunmap(buf->start);
>  		for (i = 0; i < buf->page_count; i++)
>  			__free_page(buf->page_array[i]);
> -		kfree(buf->page_array);
> +		if (buf->page_count * sizeof(struct page *) > PAGE_SIZE)
> +			vfree(buf->page_array);
> +		else
> +			kfree(buf->page_array);
>  	}
>  	chan->buf[buf->cpu] = NULL;
>  	kfree(buf->padding);

