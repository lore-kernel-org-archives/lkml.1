Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZIAHOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZIAHOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZIAHOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:14:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45575 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZIAHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:14:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Sep 2009 16:12:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-Id: <20090901161228.9fb33234.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090901064652.GA20342@localhost>
References: <20090831102640.092092954@intel.com>
	<20090901084626.ac4c8879.kamezawa.hiroyu@jp.fujitsu.com>
	<20090901022514.GA11974@localhost>
	<20090901113214.60e7ae32.kamezawa.hiroyu@jp.fujitsu.com>
	<20090901064652.GA20342@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 14:46:52 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Sep 01, 2009 at 10:32:14AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Tue, 1 Sep 2009 10:25:14 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > 4. I can't understand why you need this. I wonder you can get pfn via
> > > >    /proc/<pid>/????. And this may insert HWPOISON to page-cache of shared
> > > >    library and "unexpected" process will be poisoned.
> > > 
> > > Sorry I should have explained this. It's mainly for correctness.
> > > When a user space tool queries the task PFNs in /proc/pid/pagemap and
> > > then send to /debug/hwpoison/corrupt-pfn, there is a racy window that
> > > the page could be reclaimed and allocated by some one else. It would
> > > be awkward to try to pin the pages in user space. So we need the
> > > guarantees provided by /debug/hwpoison/corrupt-filter-memcg, which
> > > will be checked inside the page lock with elevated reference count.
> > > 
> > 
> > memcg never holds refcnt for a page and the kernel::vmscan.c can reclaim
> > any pages under memcg whithout checking anything related to memcg.
> > *And*, your code has no "pin" code.
> > This patch sed does no jobs for your concern.
> 
> We grabbed page here, which is not in the scope of this patchset:
> 
>         static int try_memory_failure(unsigned long pfn)
>         {      
>                 struct page *p;
>                 int res = -EINVAL;
> 
>                 if (!pfn_valid(pfn))
>                         return res;
> 
>                 p = pfn_to_page(pfn);
>                 if (!get_page_unless_zero(compound_head(p)))
>                         return res;
> 
>                 lock_page_nosync(compound_head(p));
> 
>                 if (hwpoison_filter(p))
>                         goto out;
> 
>                 res = __memory_failure(pfn, 18,
>                                        MEMORY_FAILURE_FLAG_COUNTED |
>                                        MEMORY_FAILURE_FLAG_LOCKED);
>         out:
>                 unlock_page(p);
>                 return res;
>         }

Hmm. maybe off-topic but why lock_page() is necessary ?


> > I recommend you to add
> >   /debug/hwpoizon/pin-pfn
> > 
> > Then,
> > 	echo pfn > /debug/hwpoizon/pin-pfn
> >         # add pfn for hwpoison debug's watch list. and elevate refcnt
> > 	check 'pfn' is still used.
> >  	echo pfn > /debug/hwpoison/corrupt-pfn
> > 	# check 'watch list' and make it corrupt and release refcnt.
> > or some.
> 
> Looks like a good alternative. At least no more memcg dependency..
> 

My point is that memcg can show 'owner' of pages but the page may
be shared with something important task _and_ if a task is migrated,
its pages' memcg information is not updated now. Then, you can kill
a task which is not in memcg.

Then, I don't recommend to use memcg. I think you'll see too much
pitfalls.

Thanks,
-Kame


