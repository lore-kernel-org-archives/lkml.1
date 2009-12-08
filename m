Return-Path: <linux-kernel-owner+w=401wt.eu-S935841AbZLHG1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841AbZLHG1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935828AbZLHG1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:27:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37747 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935791AbZLHG1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:27:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [early RFC][PATCH 8/7] vmscan: Don't deactivate many touched page
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <4B1D4513.1020206@redhat.com>
References: <20091207203427.E955.A69D9226@jp.fujitsu.com> <4B1D4513.1020206@redhat.com>
Message-Id: <20091208093134.B578.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 15:27:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/07/2009 06:36 AM, KOSAKI Motohiro wrote:
> >
> > Andrea, Can you please try following patch on your workload?
> >
> >
> >  From a7758c66d36a136d5fbbcf0b042839445f0ca522 Mon Sep 17 00:00:00 2001
> > From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> > Date: Mon, 7 Dec 2009 18:37:20 +0900
> > Subject: [PATCH] [RFC] vmscan: Don't deactivate many touched page
> >
> > Changelog
> >   o from andrea's original patch
> >     - Rebase topon my patches.
> >     - Use list_cut_position/list_splice_tail pair instead
> >       list_del/list_add to make pte scan fairness.
> >     - Only use max young threshold when soft_try is true.
> >       It avoid wrong OOM sideeffect.
> >     - Return SWAP_AGAIN instead successful result if max
> >       young threshold exceed. It prevent the pages without clear
> >       pte young bit will be deactivated wrongly.
> >     - Add to treat ksm page logic
> 
> I like the concept and your changes, and really only
> have a few small nitpicks :)
> 
> First, the VM uses a mix of "referenced", "accessed" and
> "young".  We should probably avoid adding "active" to that
> mix, and may even want to think about moving to just one
> or two terms :)

Ah yes, certainly.


> > +#define MAX_YOUNG_BIT_CLEARED 64
> > +/*
> > + * if VM pressure is low and the page have too many active mappings, there isn't
> > + * any reason to continue clear young bit of other ptes. Otherwise,
> > + *  - Makes meaningless cpu wasting, many touched page sholdn't be reclaimed.
> > + *  - Makes lots IPI for pte change and it might cause another sadly lock
> > + *    contention.
> > + */
> 
> If VM pressure is low and the page has lots of active users, we only
> clear up to MAX_YOUNG_BIT_CLEARED accessed bits at a time.  Clearing
> accessed bits takes CPU time, needs TLB invalidate IPIs and could
> cause lock contention.  Since a heavily shared page is very likely
> to be used again soon, the cost outweighs the benefit of making such
> a heavily shared page a candidate for eviction.

Thanks. Will fix.


> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index cfda0a0..f4517f3 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -473,6 +473,21 @@ static int wipe_page_reference_anon(struct page *page,
> >   		ret = wipe_page_reference_one(page, refctx, vma, address);
> >   		if (ret != SWAP_SUCCESS)
> >   			break;
> > +		if (too_many_young_bit_found(refctx)) {
> > +			LIST_HEAD(tmp_list);
> > +
> > +			/*
> > +			 * The scanned ptes move to list tail. it help every ptes
> > +			 * on this page will be tested by ptep_clear_young().
> > +			 * Otherwise, this shortcut makes unfair thing.
> > +			 */
> > +			list_cut_position(&tmp_list,
> > +					&vma->anon_vma_node,
> > +					&anon_vma->head);
> > +			list_splice_tail(&tmp_list,&vma->anon_vma_node);
> > +			ret = SWAP_AGAIN;
> > +			break;
> > +		}
> 
> I do not understand the unfairness here, since all a page needs
> to stay on the active list is >64 referenced PTEs.  It does not
> matter which of the PTEs mapping the page were recently referenced.
> 
> However, rotating the anon vmas around may help spread out lock
> pressure in the VM and help things that way, so the code looks
> useful to me.

agreed. I have to rewrite the comment.


> In short, you can give the next version of this patch my
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> 
> All I have are comment nitpicks :)

No. It's really worth.

Thank you.


