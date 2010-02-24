Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0BXAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:23:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48330 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0BXAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:23:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Feb 2010 09:19:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrea Righi <arighi@develer.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Message-Id: <20100224091941.e2cc3d3a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100223151201.GB11930@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	<20100222142744.GB13823@redhat.com>
	<20100222173640.GG3063@balbir.in.ibm.com>
	<20100222175833.GB3096@redhat.com>
	<20100223090704.839d8bef.kamezawa.hiroyu@jp.fujitsu.com>
	<20100223151201.GB11930@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 10:12:01 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Feb 23, 2010 at 09:07:04AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 22 Feb 2010 12:58:33 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Mon, Feb 22, 2010 at 11:06:40PM +0530, Balbir Singh wrote:
> > > > * Vivek Goyal <vgoyal@redhat.com> [2010-02-22 09:27:45]:
> > > > 
> > > > 
> > > > > 
> > > > >   May be we can modify writeback_inodes_wbc() to check first dirty page
> > > > >   of the inode. And if it does not belong to same memcg as the task who
> > > > >   is performing balance_dirty_pages(), then skip that inode.
> > > > 
> > > > Do you expect all pages of an inode to be paged in by the same cgroup?
> > > 
> > > I guess at least in simple cases. Not sure whether it will cover majority
> > > of usage or not and up to what extent that matters.
> > > 
> > > If we start doing background writeout, on per page (like memory reclaim),
> > > the it probably will be slower and hence flusing out pages sequentially
> > > from inode makes sense. 
> > > 
> > > At one point I was thinking, like pages, can we have an inode list per
> > > memory cgroup so that writeback logic can traverse that inode list to
> > > determine which inodes need to be cleaned. But associating inodes to
> > > memory cgroup is not very intutive at the same time, we again have the
> > > issue of shared file pages from two differnent cgroups. 
> > > 
> > > But I guess, a simpler scheme would be to just check first dirty page from
> > > inode and if it does not belong to memory cgroup of task being throttled,
> > > skip it.
> > > 
> > > It will not cover the case of shared file pages across memory cgroups, but
> > > at least something relatively simple to begin with. Do you have more ideas
> > > on how it can be handeled better.
> > > 
> > 
> > If pagesa are "shared", it's hard to find _current_ owner.
> 
> Is it not the case that the task who touched the page first is owner of
> the page and task memcg is charged for that page. Subsequent shared users
> of the page get a free ride?

yes.

> 
> If yes, why it is hard to find _current_ owner. Will it not be the memory
> cgroup which brought the page into existence?
>  
Considering extreme case, a memcg's dirty ratio can be filled by
free riders.



> > Then, what I'm
> > thinking as memcg's update is a memcg-for-page-cache and pagecache
> > migration between memcg.
> > 
> > The idea is
> >   - At first, treat page cache as what we do now.
> >   - When a process touches page cache, check process's memcg and page cache's
> >     memcg. If process-memcg != pagecache-memcg, we migrate it to a special
> >     container as memcg-for-page-cache.
> > 
> > Then,
> >   - read-once page caches are handled by local memcg.
> >   - shared page caches are handled in specail memcg for "shared".
> > 
> > But this will add significant overhead in native implementation.
> > (We may have to use page flags rather than page_cgroup's....)
> > 
> > I'm now wondering about
> >   - set "shared flag" to a page_cgroup if cached pages are accessed.
> >   - sweep them to special memcg in other (kernel) daemon when we hit thresh
> >     or some.
> > 
> > But hmm, I'm not sure that memcg-for-shared-page-cache is accepptable
> > for anyone.
> 
> I have not understood the idea well hence few queries/thoughts.
> 
> - You seem to be suggesting that shared page caches can be accounted
>   separately with-in memcg. But one page still need to be associated
>   with one specific memcg and one can only do migration across memcg
>   based on some policy who used how much. But we probably are trying
>   to be too accurate there and it might not be needed.
> 
>   Can you elaborate a little more on what you meant by migrating pages
>   to special container memcg-for-page-cache? Is it a shared container
>   across memory cgroups which are sharing a page?
> 
    Assume cgroup, A, B, Share

	/A
	/B
	/Share

    - Pages touched by both of A and B are moved to Share.

    Then, libc etc...will be moved to Share.
    As far as I remember, solaris has similar concept of partitioning.
   
> - Current writeback mechanism is flushing per inode basis. I think
>   biggest advantage is faster writeout speed as contiguous pages
>   are dispatched to disk (irrespective to the memory cgroup differnt
>   pages can belong to), resulting in better merging and less seeks.
> 
>   Even if we can account shared pages well across memory cgroups, flushing
>   these pages to disk will probably become complicated/slow if we start going
>   through the pages of a memory cgroup and start flushing these out upon
>   hitting the dirty_background/dirty_ratio/dirty_bytes limits.
> 
    It's my bad to write this idea on this thread. I noticed my motivation is
    not related to dirty_ratio. please ignore.

Thanks,
-Kame

