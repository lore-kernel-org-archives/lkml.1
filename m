Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043Ab0AFDVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0AFDVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247Ab0AFDVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:21:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55856 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0AFDVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:21:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jan 2010 12:18:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Shared Page accounting for memory cgroup (v2)
Message-Id: <20100106121836.40f3b3c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100106030752.GI3059@balbir.in.ibm.com>
References: <20100105185226.GG3059@balbir.in.ibm.com>
	<20100106090708.f3ec9fd8.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106030752.GI3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 08:37:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-06 09:07:08]:
> 
> > On Wed, 6 Jan 2010 00:22:26 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Hi, All,
> > > 
> > > No major changes from v1, except for the use of get_mm_rss().
> > > Kamezawa-San felt that this can be done in user space and I responded
> > > to him with my concerns of doing it in user space. The thread
> > > can be found at http://thread.gmane.org/gmane.linux.kernel.mm/42367.
> > > 
> > > If there are no major objections, can I ask for a merge into -mm.
> > > Andrew, the patches are against mmotm 10 December 2009, if there
> > > are some merge conflicts, please let me know, I can rebase after
> > > you release the next mmotm.
> > > 
> > 
> > The problem is that this isn't "shared" uasge but "considered to be shared"
> > usage. Okay ?
> >
> 
> Could you give me your definition of "shared". From the mem cgroup
> perspective, total_rss (which is accumulated) subtracted from the
> count of pages in the LRU which are RSS and FILE_MAPPED is shared, no?

You consider only "mapped" pages are shared page. That's wrong.
And let's think about your "total_rss - RSS+MAPPED"

In this typical case,
	fork()  ---- process(A)
	-> fork() --- process(B)
	  -> process(C)

total_rss = rss(A) + rss(B) + rss(C) = 3 * rss(A)
Then, 

total_rss - RSS_MAPPED = 2 * rss(A).

How we call this number ? Is this "shared usage" ? I think no.
If you want to do this, scan LRU and count the number of really shared pages.
It's much better than detecting "shared pages" via process and will have no
big issue if implemented in proper way.

> I understand that some of the pages that might be shared, show up
> in our LRU and accounting. These are not treated as shared by
> our cgroup, but by other cgroups.
>  
> > Then I don't want to provide this misleading value as "official report" from
> > the kernel. And this can be done in userland.
> >
> 
> I explained some of the issues of doing this from user space, would
> you be OK if I called them "non-private" pages?
> 

I think I explained there is no issue to do this in user-land.

Thanks,
-Kame


