Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZK3M0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZK3M0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZK3M0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:26:31 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:18717 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbZK3M0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:26:31 -0500
X-Trace: 295763497/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBAONIE0tPRTgw/2dsb2JhbAAI1TWEMQQ
X-IronPort-AV: E=Sophos;i="4.47,314,1257120000"; 
   d="scan'208";a="295763497"
Date: Mon, 30 Nov 2009 12:26:34 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] ksm: fix mlockfreed to munlocked
In-Reply-To: <20091130143915.5BD1.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911301200060.24660@sister.anvils>
References: <20091126162011.GG13095@csn.ul.ie> <Pine.LNX.4.64.0911271214040.4167@sister.anvils>
 <20091130143915.5BD1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, KOSAKI Motohiro wrote:
> > 
> > But please clarify: that patch was for mmotm and hopefully 2.6.33,
> > but the vmstat issue (minus warning message) is there in 2.6.32-rc.
> > Should I
> > 
> > (a) forget it for 2.6.32
> > (b) rush Linus a patch for 2.6.32 final
> > (c) send a patch for 2.6.32.stable later on
> 
> I personally prefer (3). though I don't know ksm so detail.

Thanks, I think that would be my preference by now too.

> > There's a remark in munlock_vma_page(), apropos a different issue,
> > 			/*
> > 			 * We lost the race.  let try_to_unmap() deal
> > 			 * with it.  At least we get the page state and
> > 			 * mlock stats right.  However, page is still on
> > 			 * the noreclaim list.  We'll fix that up when
> > 			 * the page is eventually freed or we scan the
> > 			 * noreclaim list.
> > 			 */
> > which implies that sometimes we scan the unevictable list and resolve
> > such cases.  But I wonder if that's nowadays the case?
> 
> We don't scan unevictable list at all. munlock_vma_page() logic is.
> 
>   1) clear PG_mlock always anyway
>   2) isolate page
>   3) scan related vma and remark PG_mlock if necessary
> 
> So, as far as I understand, the above comment describe the case when (2) is
> failed. it mean another task already isolated the page. it makes the task
> putback the page to evictable list and vmscan's try_to_unmap() move 
> the page to unevictable list again.

That is the case it's addressing, yes; but both references to
"the noreclaim list" are untrue and misleading (now: they may well
have been accurate when the comment went in).  I'd like to correct
it, but cannot do so without spending the time to make sure that
what I'm saying instead isn't equally misleading...

Even "We lost the race" is worrying: which race? there might be several.

Hugh
