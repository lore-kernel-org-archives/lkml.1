Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZLALOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZLALOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZLALOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:14:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43027 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZLALOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:14:19 -0500
Date: Tue, 1 Dec 2009 11:14:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] ksm: fix mlockfreed to munlocked
Message-ID: <20091201111421.GC23491@csn.ul.ie>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils> <Pine.LNX.4.64.0911241638130.25288@sister.anvils> <20091126162011.GG13095@csn.ul.ie> <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 12:45:04PM +0000, Hugh Dickins wrote:
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
> 
> ? I just don't have a feel for how important this is.
> 

My ack was based on the view that pages should not be getting to the buddy
allocator with the mlocked bit set. It only warns in -mm because it's meant
to be harmless-if-incorrect in all cases. Based on my reading of your
patch, it looked like a reasonable way of clearing the locked bit that
deal with the same type of isolation races typically faced by reclaim.

I felt it would be a case that either the isolation failed and it would
end up back on the LRU list or it would remain on whatever unevitable
LRU list it previously existed on where it would be found there.

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
> 

My understanding was that if it failed to isolate then another process had
already done the necessary work and dropped the reference. The page would
then get properly freed at the last put_page. I did not double check this
assumption.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
