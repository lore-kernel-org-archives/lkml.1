Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZFXTGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZFXTGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZFXTGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:06:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZFXTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:06:38 -0400
Date: Wed, 24 Jun 2009 12:06:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624120617.1e6799b5.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>
	<20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	<20090624105517.904f93da.akpm@linux-foundation.org>
	<4A426825.80905@cs.helsinki.fi>
	<20090624113037.7d72ed59.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 11:42:33 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I'd suggest just doing this..
> 
> 			Linus
> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index aecc9cd..5d714f8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1153,10 +1153,10 @@ again:
>  			 * properly detect and handle allocation failures.
>  			 *
>  			 * We most definitely don't want callers attempting to
> -			 * allocate greater than single-page units with
> +			 * allocate greater than order-1 page units with
>  			 * __GFP_NOFAIL.
>  			 */
> -			WARN_ON_ONCE(order > 0);
> +			WARN_ON_ONCE(order > 1);
>  		}
>  		spin_lock_irqsave(&zone->lock, flags);
>  		page = __rmqueue(zone, order, migratetype);

Well.  What is our overall objective here?

My original patch was motiviated by the horror at discovering that
we're using this thing (which was _never_ supposed to have new users)
for order>0 allocations.  We've gone backwards.

Ideally, we'd fix all callers to handle allocation faliures then remove
__GFP_NOFAIL.  But I don't know how to fix JBD.

So perhaps we should just revert that WARN_ON altogether, and I can go
on a little grep-empowered rampage, see if we can remove some of these
callsites.

It's not a huge problem, btw.  I don't think I've ever seen a report of
a machine getting stuck in a __GFP_NOFAIL allocation attempt.  But from
a design perspective it's Just Wrong.


