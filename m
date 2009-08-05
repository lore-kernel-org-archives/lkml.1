Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbZHEEPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbZHEEPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZHEEPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:15:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35902 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZHEEPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:15:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090805024058.GA8886@localhost>
References: <20090805024058.GA8886@localhost>
Message-Id: <20090805130936.5BAD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 13:15:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Greetings,
> 
> Jeff Dike found that many KVM pages are being refaulted in 2.6.29:
> 
> "Lots of pages between discarded due to memory pressure only to be
> faulted back in soon after. These pages are nearly all stack pages.
> This is not consistent - sometimes there are relatively few such pages
> and they are spread out between processes."

I suprise this result really.

  - Why this issue happened only on kvm?
  - Why shrink_inactive_list() can't find pte young bit?
    Is this really unused stack?

> 
> The refaults can be drastically reduced by the following patch, which
> respects the referenced bit of all anonymous pages (including the KVM
> pages).
> 
> However it risks reintroducing the problem addressed by commit 7e9cd4842
> (fix reclaim scalability problem by ignoring the referenced bit,
> mainly the pte young bit). I wonder if there are better solutions?
> 
> Thanks,
> Fengguang
> 
> ---
>  mm/vmscan.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- linux.orig/mm/vmscan.c
> +++ linux/mm/vmscan.c
> @@ -1288,12 +1288,12 @@ static void shrink_active_list(unsigned 
>  			 * Identify referenced, file-backed active pages and
>  			 * give them one more trip around the active list. So
>  			 * that executable code get better chances to stay in
> -			 * memory under moderate memory pressure.  Anon pages
> -			 * are not likely to be evicted by use-once streaming
> -			 * IO, plus JVM can create lots of anon VM_EXEC pages,
> -			 * so we ignore them here.
> +			 * memory under moderate memory pressure.
> +			 *
> +			 * Also protect anon pages: swapping could be costly,
> +			 * and KVM guest's referenced bit is helpful.
>  			 */
> -			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> +			if ((vm_flags & VM_EXEC) || PageAnon(page)) {
>  				list_add(&page->lru, &l_active);
>  				continue;
>  			}



