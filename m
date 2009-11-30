Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZK3Lzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZK3Lzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZK3Lzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:55:49 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:61554 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbZK3Lzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:55:49 -0500
X-Trace: 299078163/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBACZBE0tPRTgw/2dsb2JhbAAI1UCEMQQ
X-IronPort-AV: E=Sophos;i="4.47,314,1257120000"; 
   d="scan'208";a="299078163"
Date: Mon, 30 Nov 2009 11:55:53 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
In-Reply-To: <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911301141010.20054@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241640590.25288@sister.anvils>
 <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> Hmm. I'm not sure how many pages are shared in a system but
> can't we add some threshold for avoidng too much scan against shared pages ?
> (in vmscan.c)
> like..
>       
>        if (page_mapcount(page) > (XXXX >> scan_priority))
> 		return 1;
> 
> I saw terrible slow downs in shmem-swap-out in old RHELs (at user support).
> (Added kosaki to CC.)
> 
> After this patch, the number of shared swappable page will be unlimited.

I don't think KSM swapping changes the story here at all: I don't
think it significantly increases the likelihood of pages with very
high mapcounts on the LRUs.  You've met the issue with shmem, okay,
I've always thought shared library text pages would be a problem.

I've often thought that some kind of "don't bother if the mapcount is
too high" check in vmscan.c might help - though I don't think I've
ever noticed the bugreport it would help with ;)

I used to imagine doing up to a certain number inside the rmap loops
and then breaking out (that would help with those reports of huge
anon_vma lists); but that would involve starting the next time from
where we left off, which would be difficult with the prio_tree.

Your proposal above (adjusting the limit according to scan_priority,
yes that's important) looks very promising to me.

Hugh
