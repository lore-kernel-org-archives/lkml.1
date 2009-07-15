Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZGOOc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZGOOc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZGOOc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:32:26 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53491 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbZGOOc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:32:26 -0400
Date: Wed, 15 Jul 2009 10:31:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Johannes Weiner <hannes@cmpxchg.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
 V2
In-Reply-To: <20090715125822.GB29749@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0907151027410.23643@gentwo.org>
References: <20090715125822.GB29749@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Mel Gorman wrote:

> -static inline int free_pages_check(struct page *page)
> +static inline int free_pages_check(struct page *page, int wasMlocked)
>  {
> +	WARN_ONCE(wasMlocked, KERN_WARNING
> +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> +		"page:%p flags:0x%lX\n",
> +		current->comm, page_to_pfn(page),
> +		page, page->flags|__PG_MLOCKED);
> +
>  	if (unlikely(page_mapcount(page) |

There is already a free_page_mlocked() that is only called if the mlock
bit is set. Move it into there to avoid having to run two checks in the
hot codee path?

Also __free_pages_ok() now has a TestClearMlocked in the hot code path.
Would it be possible to get rid of the unconditional use of an atomic
operation? Just check the bit and clear it later in free_page_mlocked()?

