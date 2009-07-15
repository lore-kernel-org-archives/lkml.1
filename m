Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZGOMqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZGOMqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZGOMqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:46:08 -0400
Received: from cmpxchg.org ([85.214.51.133]:47694 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZGOMqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:46:08 -0400
Date: Wed, 15 Jul 2009 14:45:09 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set (resend)
Message-ID: <20090715124509.GA1854@cmpxchg.org>
References: <20090715104833.GB9267@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715104833.GB9267@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mel,

On Wed, Jul 15, 2009 at 11:48:34AM +0100, Mel Gorman wrote:
> When a page is freed with the PG_mlocked set, it is considered an unexpected
> but recoverable situation. A counter records how often this event happens
> but it is easy to miss that this event has occured at all. This patch warns
> once when PG_mlocked is set to prompt debuggers to check the counter to
> see how often it is happening.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  mm/page_alloc.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index caa9268..f8902e7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -495,8 +495,16 @@ static inline void free_page_mlock(struct page *page)
>  static void free_page_mlock(struct page *page) { }
>  #endif
>  
> -static inline int free_pages_check(struct page *page)
> -{
> +static inline int free_pages_check(struct page *page, int wasMlocked)
> +{
> +	if (unlikely(wasMlocked)) {
> +		WARN_ONCE(1, KERN_WARNING
> +			"Page flag mlocked set for process %s at pfn:%05lx\n"
> +			"page:%p flags:0x%lX\n",
> +			current->comm, page_to_pfn(page),
> +			page, page->flags|__PG_MLOCKED);

Since the warning is the only action in this branch, wouldn't
WARN_ONCE(wasMlocked, KERN_WARNING ...) be better?

	Hannes
