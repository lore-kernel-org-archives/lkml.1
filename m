Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZJ0UK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZJ0UK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZJ0UK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756739AbZJ0UKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:10:25 -0400
Date: Tue, 27 Oct 2009 13:09:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Kernel Testers List <kernel-testers@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>"@linux-foundation.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-Id: <20091027130924.fa903f5a.akpm@linux-foundation.org>
In-Reply-To: <1256650833-15516-3-git-send-email-mel@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
	<1256650833-15516-3-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 13:40:32 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.
> 
> [rientjes@google.com: Spotted the problem]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dfa4362..7f2aa3e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
>  		 */
>  		alloc_flags &= ~ALLOC_CPUSET;
> -	} else if (unlikely(rt_task(p)))
> +	} else if (unlikely(rt_task(p)) && !in_interrupt())
>  		alloc_flags |= ALLOC_HARDER;
>  
>  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {

What are the runtime-observeable effects of this change?

The description is a bit waffly-sounding for a -stable backportable
thing, IMO.  What reason do the -stable maintainers and users have to
believe that this patch is needed, and an improvement?

