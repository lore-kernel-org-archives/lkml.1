Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZIAI4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZIAI4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZIAI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:56:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:5130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZIAI4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182704462"
Date: Tue, 1 Sep 2009 16:55:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-ID: <20090901085549.GA4454@localhost>
References: <20090831102640.092092954@intel.com> <20090901084626.ac4c8879.kamezawa.hiroyu@jp.fujitsu.com> <20090901022514.GA11974@localhost> <20090901113214.60e7ae32.kamezawa.hiroyu@jp.fujitsu.com> <20090901064652.GA20342@localhost> <20090901161228.9fb33234.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901161228.9fb33234.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 03:12:28PM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 1 Sep 2009 14:46:52 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Tue, Sep 01, 2009 at 10:32:14AM +0800, KAMEZAWA Hiroyuki wrote:
> > > On Tue, 1 Sep 2009 10:25:14 +0800
> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > 4. I can't understand why you need this. I wonder you can get pfn via
> > > > >    /proc/<pid>/????. And this may insert HWPOISON to page-cache of shared
> > > > >    library and "unexpected" process will be poisoned.
> > > > 
> > > > Sorry I should have explained this. It's mainly for correctness.
> > > > When a user space tool queries the task PFNs in /proc/pid/pagemap and
> > > > then send to /debug/hwpoison/corrupt-pfn, there is a racy window that
> > > > the page could be reclaimed and allocated by some one else. It would
> > > > be awkward to try to pin the pages in user space. So we need the
> > > > guarantees provided by /debug/hwpoison/corrupt-filter-memcg, which
> > > > will be checked inside the page lock with elevated reference count.
> > > > 
> > > 
> > > memcg never holds refcnt for a page and the kernel::vmscan.c can reclaim
> > > any pages under memcg whithout checking anything related to memcg.
> > > *And*, your code has no "pin" code.
> > > This patch sed does no jobs for your concern.
> > 
> > We grabbed page here, which is not in the scope of this patchset:
> > 
> >         static int try_memory_failure(unsigned long pfn)
> >         {      
> >                 struct page *p;
> >                 int res = -EINVAL;
> > 
> >                 if (!pfn_valid(pfn))
> >                         return res;
> > 
> >                 p = pfn_to_page(pfn);
> >                 if (!get_page_unless_zero(compound_head(p)))
> >                         return res;
> > 
> >                 lock_page_nosync(compound_head(p));
> > 
> >                 if (hwpoison_filter(p))
> >                         goto out;
> > 
> >                 res = __memory_failure(pfn, 18,
> >                                        MEMORY_FAILURE_FLAG_COUNTED |
> >                                        MEMORY_FAILURE_FLAG_LOCKED);
> >         out:
> >                 unlock_page(p);
> >                 return res;
> >         }
> 
> Hmm. maybe off-topic but why lock_page() is necessary ?

Because we also have filter for testing page flags, which requires
lock_page() to be correct.

> 
> > > I recommend you to add
> > >   /debug/hwpoizon/pin-pfn
> > > 
> > > Then,
> > > 	echo pfn > /debug/hwpoizon/pin-pfn
> > >         # add pfn for hwpoison debug's watch list. and elevate refcnt
> > > 	check 'pfn' is still used.
> > >  	echo pfn > /debug/hwpoison/corrupt-pfn
> > > 	# check 'watch list' and make it corrupt and release refcnt.
> > > or some.
> > 
> > Looks like a good alternative. At least no more memcg dependency..
> > 
> 
> My point is that memcg can show 'owner' of pages but the page may
> be shared with something important task _and_ if a task is migrated,
> its pages' memcg information is not updated now. Then, you can kill
> a task which is not in memcg.

Ah thanks! I'm not aware of that tricky fact, and it does make a
very good reason not to use memcg, although I guess locked page won't
be migrated.

> Then, I don't recommend to use memcg. I think you'll see too much
> pitfalls.

Thanks,
Fengguang
