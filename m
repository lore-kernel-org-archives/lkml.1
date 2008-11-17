Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYKQRGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYKQRGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYKQRGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:06:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbYKQRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:06:24 -0500
Date: Mon, 17 Nov 2008 09:06:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
In-Reply-To: <4921A1AF.1070909@redhat.com>
Message-ID: <alpine.LFD.2.00.0811170904160.3468@nehalem.linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115210039.537f59f5.akpm@linux-foundation.org> <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org> <49208E9A.5080801@redhat.com> <20081116204720.1b8cbe18.akpm@linux-foundation.org>
 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com> <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0811170830320.3468@nehalem.linux-foundation.org> <4921A1AF.1070909@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Rik van Riel wrote:

> Linus Torvalds wrote:
> 
> > Another thing strikes me: it looks like the logic in "get_scan_ratio()" has
> > a tendency to get unbalanced - if we end up deciding that we should scan a
> > lot of anonymous pages, the scan numbers for anonymous pages will go up, and
> > we get even _more_ eager to scan those. Of course, "rotate" events will then
> > make us less likely again, but for streaming loads, you wouldn't expect to
> > see those at all.
> 
> True for streaming loads - if we scan the file list and find
> mostly pages from streaming loads, we will become more eager
> to scan the file list.

The "count adding as activity" might hide that, but it does seem a big 
iffy.

> > There seems to be another bug there wrt the "aging" - we age anon page
> > events and file page events independently, which sounds like it would make
> > the math totally nonsensical. We do that whole
> > 
> > 	anon / (anon + file)
> 
> That's an outdated comment.  Andrew had a patch to update that
> comment, but it must have gotten lost somewhere.  I'll send you
> a patch to update it.
> 
> If you look at the actual calculation, you'l see that the
> scan percentages are keyed off just swappiness and the
> rotated/scanned ratios for each page category.

Ok, that makes sense. Yes, as ratios the math looks valid.

		Linus
