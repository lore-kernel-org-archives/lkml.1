Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZK0MpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZK0MpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZK0MpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:45:23 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:64315 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbZK0MpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:45:22 -0500
X-Trace: 294345944/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooBANdYD0tPRTgw/2dsb2JhbAAI1HCEMQQ
X-IronPort-AV: E=Sophos;i="4.47,301,1257120000"; 
   d="scan'208";a="294345944"
Date: Fri, 27 Nov 2009 12:45:04 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] ksm: fix mlockfreed to munlocked
In-Reply-To: <20091126162011.GG13095@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241638130.25288@sister.anvils> <20091126162011.GG13095@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009, Mel Gorman wrote:
> On Tue, Nov 24, 2009 at 04:40:55PM +0000, Hugh Dickins wrote:
> > When KSM merges an mlocked page, it has been forgetting to munlock it:
> > that's been left to free_page_mlock(), which reports it in /proc/vmstat
> > as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
> > whinges "Page flag mlocked set for process" in mmotm, whereas mainline
> > is silently forgiving).  Call munlock_vma_page() to fix that.
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Rik & Mel, thanks for the Acks.

But please clarify: that patch was for mmotm and hopefully 2.6.33,
but the vmstat issue (minus warning message) is there in 2.6.32-rc.
Should I

(a) forget it for 2.6.32
(b) rush Linus a patch for 2.6.32 final
(c) send a patch for 2.6.32.stable later on

? I just don't have a feel for how important this is.

Typically, these pages are immediately freed, and the only issue is
which stats they get added to; but if fork has copied them into other
mms, then such pages might stay unevictable indefinitely, despite no
longer being in any mlocked vma.

There's a remark in munlock_vma_page(), apropos a different issue,
			/*
			 * We lost the race.  let try_to_unmap() deal
			 * with it.  At least we get the page state and
			 * mlock stats right.  However, page is still on
			 * the noreclaim list.  We'll fix that up when
			 * the page is eventually freed or we scan the
			 * noreclaim list.
			 */
which implies that sometimes we scan the unevictable list and resolve
such cases.  But I wonder if that's nowadays the case?

> 
> > ---
> > Is this a fix that I ought to backport to 2.6.32?  It does rely on part of
> > an earlier patch (moved unlock_page down), so does not apply cleanly as is.

Thanks,
Hugh
