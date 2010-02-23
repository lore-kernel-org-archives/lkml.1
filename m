Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0BWPNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:13:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab0BWPNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:13:40 -0500
Date: Tue, 23 Feb 2010 10:12:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrea Righi <arighi@develer.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Message-ID: <20100223151201.GB11930@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <20100222142744.GB13823@redhat.com> <20100222173640.GG3063@balbir.in.ibm.com> <20100222175833.GB3096@redhat.com> <20100223090704.839d8bef.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223090704.839d8bef.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 09:07:04AM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 22 Feb 2010 12:58:33 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Mon, Feb 22, 2010 at 11:06:40PM +0530, Balbir Singh wrote:
> > > * Vivek Goyal <vgoyal@redhat.com> [2010-02-22 09:27:45]:
> > > 
> > > 
> > > > 
> > > >   May be we can modify writeback_inodes_wbc() to check first dirty page
> > > >   of the inode. And if it does not belong to same memcg as the task who
> > > >   is performing balance_dirty_pages(), then skip that inode.
> > > 
> > > Do you expect all pages of an inode to be paged in by the same cgroup?
> > 
> > I guess at least in simple cases. Not sure whether it will cover majority
> > of usage or not and up to what extent that matters.
> > 
> > If we start doing background writeout, on per page (like memory reclaim),
> > the it probably will be slower and hence flusing out pages sequentially
> > from inode makes sense. 
> > 
> > At one point I was thinking, like pages, can we have an inode list per
> > memory cgroup so that writeback logic can traverse that inode list to
> > determine which inodes need to be cleaned. But associating inodes to
> > memory cgroup is not very intutive at the same time, we again have the
> > issue of shared file pages from two differnent cgroups. 
> > 
> > But I guess, a simpler scheme would be to just check first dirty page from
> > inode and if it does not belong to memory cgroup of task being throttled,
> > skip it.
> > 
> > It will not cover the case of shared file pages across memory cgroups, but
> > at least something relatively simple to begin with. Do you have more ideas
> > on how it can be handeled better.
> > 
> 
> If pagesa are "shared", it's hard to find _current_ owner.

Is it not the case that the task who touched the page first is owner of
the page and task memcg is charged for that page. Subsequent shared users
of the page get a free ride?

If yes, why it is hard to find _current_ owner. Will it not be the memory
cgroup which brought the page into existence?
 
> Then, what I'm
> thinking as memcg's update is a memcg-for-page-cache and pagecache
> migration between memcg.
> 
> The idea is
>   - At first, treat page cache as what we do now.
>   - When a process touches page cache, check process's memcg and page cache's
>     memcg. If process-memcg != pagecache-memcg, we migrate it to a special
>     container as memcg-for-page-cache.
> 
> Then,
>   - read-once page caches are handled by local memcg.
>   - shared page caches are handled in specail memcg for "shared".
> 
> But this will add significant overhead in native implementation.
> (We may have to use page flags rather than page_cgroup's....)
> 
> I'm now wondering about
>   - set "shared flag" to a page_cgroup if cached pages are accessed.
>   - sweep them to special memcg in other (kernel) daemon when we hit thresh
>     or some.
> 
> But hmm, I'm not sure that memcg-for-shared-page-cache is accepptable
> for anyone.

I have not understood the idea well hence few queries/thoughts.

- You seem to be suggesting that shared page caches can be accounted
  separately with-in memcg. But one page still need to be associated
  with one specific memcg and one can only do migration across memcg
  based on some policy who used how much. But we probably are trying
  to be too accurate there and it might not be needed.

  Can you elaborate a little more on what you meant by migrating pages
  to special container memcg-for-page-cache? Is it a shared container
  across memory cgroups which are sharing a page?

- Current writeback mechanism is flushing per inode basis. I think
  biggest advantage is faster writeout speed as contiguous pages
  are dispatched to disk (irrespective to the memory cgroup differnt
  pages can belong to), resulting in better merging and less seeks.

  Even if we can account shared pages well across memory cgroups, flushing
  these pages to disk will probably become complicated/slow if we start going
  through the pages of a memory cgroup and start flushing these out upon
  hitting the dirty_background/dirty_ratio/dirty_bytes limits.

Thanks
Vivek
