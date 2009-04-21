Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZDUHqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZDUHqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDUHqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:46:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57195 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZDUHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:46:24 -0400
Subject: Re: [PATCH 12/25] Remove a branch by assuming __GFP_HIGH ==
 ALLOC_HIGH
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-13-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-13-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:46:22 +0300
Message-Id: <1240299982.771.48.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> Allocations that specify __GFP_HIGH get the ALLOC_HIGH flag. If these
> flags are equal to each other, we can eliminate a branch.
> 
> [akpm@linux-foundation.org: Suggested the hack]

Yikes!

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 51e1ded..b13fc29 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1639,8 +1639,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
>  	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
>  	 */
> -	if (gfp_mask & __GFP_HIGH)
> -		alloc_flags |= ALLOC_HIGH;
> +	VM_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
> +	alloc_flags |= (gfp_mask & __GFP_HIGH);

Shouldn't you then also change ALLOC_HIGH to use __GFP_HIGH or at least
add a comment somewhere?

>  
>  	if (!wait) {
>  		alloc_flags |= ALLOC_HARDER;

