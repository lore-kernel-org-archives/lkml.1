Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858Ab0AFDtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0AFDtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636Ab0AFDtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:49:41 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36474 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0AFDtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:49:40 -0500
Date: Wed, 6 Jan 2010 09:19:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Shared Page accounting for memory cgroup (v2)
Message-ID: <20100106034934.GK3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100105185226.GG3059@balbir.in.ibm.com>
 <20100106090708.f3ec9fd8.kamezawa.hiroyu@jp.fujitsu.com>
 <20100106030752.GI3059@balbir.in.ibm.com>
 <20100106121836.40f3b3c0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100106121836.40f3b3c0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 12:18:36]:

> On Wed, 6 Jan 2010 08:37:52 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 09:07:08]:
> > 
> > > On Wed, 6 Jan 2010 00:22:26 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > Hi, All,
> > > > 
> > > > No major changes from v1, except for the use of get_mm_rss().
> > > > Kamezawa-San felt that this can be done in user space and I responded
> > > > to him with my concerns of doing it in user space. The thread
> > > > can be found at http://thread.gmane.org/gmane.linux.kernel.mm/42367.
> > > > 
> > > > If there are no major objections, can I ask for a merge into -mm.
> > > > Andrew, the patches are against mmotm 10 December 2009, if there
> > > > are some merge conflicts, please let me know, I can rebase after
> > > > you release the next mmotm.
> > > > 
> > > 
> > > The problem is that this isn't "shared" uasge but "considered to be shared"
> > > usage. Okay ?
> > >
> > 
> > Could you give me your definition of "shared". From the mem cgroup
> > perspective, total_rss (which is accumulated) subtracted from the
> > count of pages in the LRU which are RSS and FILE_MAPPED is shared, no?
> 
> You consider only "mapped" pages are shared page. That's wrong.
> And let's think about your "total_rss - RSS+MAPPED"
> 
> In this typical case,
> 	fork()  ---- process(A)
> 	-> fork() --- process(B)
> 	  -> process(C)
> 
> total_rss = rss(A) + rss(B) + rss(C) = 3 * rss(A)
> Then, 
> 
> total_rss - RSS_MAPPED = 2 * rss(A).
> 
> How we call this number ? Is this "shared usage" ? I think no.

Why not? The pages in LRU is rss(A) and the total usage is 3*rss(A),
shared does not imply shared outside the cgroup. Why do you say it is
not shared?

> If you want to do this, scan LRU and count the number of really shared pages.

A page walk for large number of cases is expensive for a large memory
cgroup.

> It's much better than detecting "shared pages" via process and will have no
> big issue if implemented in proper way.
> 

A walk is not cheap, specifically since the list is protected by zone
lru lock and there are now 5 lists.

> > I understand that some of the pages that might be shared, show up
> > in our LRU and accounting. These are not treated as shared by
> > our cgroup, but by other cgroups.
> >  
> > > Then I don't want to provide this misleading value as "official report" from
> > > the kernel. And this can be done in userland.
> > >
> > 
> > I explained some of the issues of doing this from user space, would
> > you be OK if I called them "non-private" pages?
> > 
> 
> I think I explained there is no issue to do this in user-land.
>

You did not respond back to the last message of (I thought I convinced
you) http://thread.gmane.org/gmane.linux.kernel.mm/42367 

-- 
	Balbir
