Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZHSObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZHSObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZHSObV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:31:21 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59691 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZHSObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:31:20 -0400
Date: Wed, 19 Aug 2009 19:57:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] memcg: move definitions to .h and inline some functions
Message-ID: <20090819142705.GN22626@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4A856467.6050102@redhat.com> <20090815054524.GB11387@localhost> <20090818224230.A648.A69D9226@jp.fujitsu.com> <20090819134036.GA7267@localhost> <f4131456fc4b1dd4f5b8d060e0cbef80.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <f4131456fc4b1dd4f5b8d060e0cbef80.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-19 23:18:01]:

> Wu Fengguang ?$B$5$s$O=q$-$^$7$?!'
> > On Tue, Aug 18, 2009 at 11:57:52PM +0800, KOSAKI Motohiro wrote:
> >>
> >> > > This one of the reasons why we unconditionally deactivate
> >> > > the active anon pages, and do background scanning of the
> >> > > active anon list when reclaiming page cache pages.
> >> > >
> >> > > We want to always move some pages to the inactive anon
> >> > > list, so it does not get too small.
> >> >
> >> > Right, the current code tries to pull inactive list out of
> >> > smallish-size state as long as there are vmscan activities.
> >> >
> >> > However there is a possible (and tricky) hole: mem cgroups
> >> > don't do batched vmscan. shrink_zone() may call shrink_list()
> >> > with nr_to_scan=1, in which case shrink_list() _still_ calls
> >> > isolate_pages() with the much larger SWAP_CLUSTER_MAX.
> >> >
> >> > It effectively scales up the inactive list scan rate by 10 times when
> >> > it is still small, and may thus prevent it from growing up for ever.
> >> >
> >> > In that case, LRU becomes FIFO.
> >> >
> >> > Jeff, can you confirm if the mem cgroup's inactive list is small?
> >> > If so, this patch should help.
> >>
> >> This patch does right thing.
> >> However, I would explain why I and memcg folks didn't do that in past
> >> days.
> >>
> >> Strangely, some memcg struct declaration is hide in *.c. Thus we can't
> >> make inline function and we hesitated to introduce many function calling
> >> overhead.
> >>
> >> So, Can we move some memcg structure declaration to *.h and make
> >> mem_cgroup_get_saved_scan() inlined function?
> >
> > OK here it is. I have to move big chunks to make it compile, and it
> > does reduced a dozen lines of code :)
> >
> > Is this big copy&paste acceptable? (memcg developers CCed).
> >
> > Thanks,
> > Fengguang
> 
> I don't like this. plz add hooks to necessary places, at this stage.
> This will be too big for inlined function, anyway.
> plz move this after you find overhead is too big.

Me too.. I want to abstract the implementation within memcontrol.c to
be honest (I am concerned that someone might include memcontrol.h and
access its structure members, which scares me). Hiding it within
memcontrol.c provides the right level of abstraction.

Could you please explain your motivation for this change? I got cc'ed
on to a few emails, is this for the patch that export nr_save_scanned
approach?

-- 
	Balbir
