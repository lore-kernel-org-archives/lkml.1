Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZK3GBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZK3GBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZK3GBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:01:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47253 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZK3GBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:01:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 1/9] ksm: fix mlockfreed to munlocked
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
References: <20091126162011.GG13095@csn.ul.ie> <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
Message-Id: <20091130143915.5BD1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Nov 2009 15:01:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 26 Nov 2009, Mel Gorman wrote:
> > On Tue, Nov 24, 2009 at 04:40:55PM +0000, Hugh Dickins wrote:
> > > When KSM merges an mlocked page, it has been forgetting to munlock it:
> > > that's been left to free_page_mlock(), which reports it in /proc/vmstat
> > > as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
> > > whinges "Page flag mlocked set for process" in mmotm, whereas mainline
> > > is silently forgiving).  Call munlock_vma_page() to fix that.
> > > 
> > > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > 
> > Acked-by: Mel Gorman <mel@csn.ul.ie>
> 
> Rik & Mel, thanks for the Acks.
> 
> But please clarify: that patch was for mmotm and hopefully 2.6.33,
> but the vmstat issue (minus warning message) is there in 2.6.32-rc.
> Should I
> 
> (a) forget it for 2.6.32
> (b) rush Linus a patch for 2.6.32 final
> (c) send a patch for 2.6.32.stable later on

I personally prefer (3). though I don't know ksm so detail.


> 
> ? I just don't have a feel for how important this is.
> 
> Typically, these pages are immediately freed, and the only issue is
> which stats they get added to; but if fork has copied them into other
> mms, then such pages might stay unevictable indefinitely, despite no
> longer being in any mlocked vma.
> 
> There's a remark in munlock_vma_page(), apropos a different issue,
> 			/*
> 			 * We lost the race.  let try_to_unmap() deal
> 			 * with it.  At least we get the page state and
> 			 * mlock stats right.  However, page is still on
> 			 * the noreclaim list.  We'll fix that up when
> 			 * the page is eventually freed or we scan the
> 			 * noreclaim list.
> 			 */
> which implies that sometimes we scan the unevictable list and resolve
> such cases.  But I wonder if that's nowadays the case?

We don't scan unevictable list at all. munlock_vma_page() logic is.

  1) clear PG_mlock always anyway
  2) isolate page
  3) scan related vma and remark PG_mlock if necessary

So, as far as I understand, the above comment describe the case when (2) is
failed. it mean another task already isolated the page. it makes the task
putback the page to evictable list and vmscan's try_to_unmap() move 
the page to unevictable list again.



