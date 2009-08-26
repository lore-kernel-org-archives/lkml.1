Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZHZCcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZHZCcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZHZCcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:32:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56401 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZHZCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:32:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
Cc: kosaki.motohiro@jp.fujitsu.com,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <Pine.LNX.4.64.0908250947400.2872@sister.anvils>
References: <82e12e5f0908242146uad0f314hcbb02fcc999a1d32@mail.gmail.com> <Pine.LNX.4.64.0908250947400.2872@sister.anvils>
Message-Id: <20090826113622.9A29.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 11:32:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Yeah, GUP_FLAGS_NOFAULT is better.
> > 
> > Me too.
> > I will change this flag name.
> >... 
> > When I try to change __get_user_pages(), I got problem.
> > If remove NULLs from pages,
> > __mlock_vma_pages_range() cannot know how long __get_user_pages() readed.
> > So, I have to get the virtual address of the page from vma and page.
> > Because __mlock_vma_pages_range() have to call
> > __get_user_pages() many times with different `start' argument.
> > 
> > I try to use page_address_in_vma(), but it failed.
> > (page_address_in_vma() returned -EFAULT)
> > I cannot find way to solve this problem.
> > Are there good ideas?
> > Please give me some ideas.
> 
> I agree that this munlock issue needs to be addressed: it's not just a
> matter of speedup, I hit it when testing what happens when mlock takes
> you to OOM - which is currently a hanging disaster because munlock'ing
> in the exiting OOM-killed process gets stuck trying to fault in all
> those pages that couldn't be locked in the first place.

I agree too.


> I had intended to fix it by being more careful about splitting/merging
> vmas, noting how far the mlock had got, and munlocking just up to there.
> However, now that I've got in there, that looks wrong to me, given the
> traditional behaviour that mlock does its best, but pretends success
> to allow for later instantiation of the pages if necessary.
> 
> You ask for ideas.  My main idea is that so far we have added
> GUP_FLAGS_IGNORE_VMA_PERMISSIONS (Kosaki-san, what was that about?
>                                   we already had the force flag),

MAY_WRITE and MAY_READ might be turned off at some special case.
but munlock should turn off PG_mlock bit. otherwise the page never be reclaimed.
This problem was explained by Lee about a year ago.

However, To use follow_page() solove this issue and we will be able to
remove this ugly flag.

> GUP_FLAGS_IGNORE_SIGKILL, and now you propose
> GUP_FLAGS_NOFAULT, all for the sole use of munlock.
> 
> How about GUP_FLAGS_MUNLOCK, or more to the point, GUP_FLAGS_DONT_BE_GUP?
> By which I mean, don't all these added flags suggest that almost
> everything __get_user_pages() does is unsuited to the munlock case?
> 
> My advice (but I sure hate giving advice before I've tried it myself)
> is to put __mlock_vma_pages_range() back to handling just the mlock
> case, and do your own follow_page() loop in munlock_vma_pages_range().

Agreed. follow_page() is better.




