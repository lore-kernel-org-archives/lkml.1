Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZIHL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZIHL5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZIHL5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:57:48 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:8313 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbZIHL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:57:48 -0400
X-Trace: 256080574/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.109.190/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.109.190
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADDjpUpQKW2+/2dsb2JhbACBU9hhhBgF
X-IronPort-AV: E=Sophos;i="4.44,352,1249254000"; 
   d="scan'208";a="256080574"
Date: Tue, 8 Sep 2009 12:56:57 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm: reinstate ZERO_PAGE
In-Reply-To: <20090908113734.869cdad7.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909081231480.25652@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909072238320.15430@sister.anvils>
 <20090908113734.869cdad7.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, KAMEZAWA Hiroyuki wrote:
> 
> A nitpick but this was a concern you shown, IIUC.
> 
> == __get_user_pages()..
> 
>                         if (pages) {
>                                 pages[i] = page;
> 
>                                 flush_anon_page(vma, page, start);
>                                 flush_dcache_page(page);
>                         }
> ==
> 
> This part will call flush_dcache_page() even when ZERO_PAGE is found.
> 
> Don't we need to mask this ?

No, it's okay to flush_dcache_page() on ZERO_PAGE: we always used to
do that there, and the arches I remember offhand won't do anything
with it anyway, once they see page->mapping NULL.

What you're remembering, that I did object to, was the way your
FOLL_NOZERO ended up doing
				pages[i] = NULL;
				flush_anon_page(vma, NULL, start);
				flush_dcache_page(NULL);

which would cause an oops when those arches look at page->mapping.

I should take another look at your FOLL_NOZERO: I may have dismissed
it too quickly, after seeing that bug, and oopsing on x86 when
mlocking a readonly anonymous area.

Though I like that we don't _need_ to change mlock.c for reinstated
ZERO_PAGE, this morning I'm having trouble persuading myself that
mlocking a readonly anonymous area is too silly to optimize for.

Maybe the very people who persuaded you to bring back the anonymous
use of ZERO_PAGE, are also doing a huge mlock of the area first?
So if two or more are starting up at the same time on the same box,
more bouncing than is healthy (and more than they would have seen
in the old days of ZERO_PAGE but no lock_page on it there).

I'd like to persuade myself not to bother,
but may want to add a further patch for that later.

Hugh
