Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZFAFtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZFAFtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZFAFto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:49:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53125 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZFAFto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:49:44 -0400
Date: Mon, 1 Jun 2009 13:49:40 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Subject: Re: [RFC] Low overhead patches for the memory cgroup controller
	(v2)
Message-ID: <20090601054940.GB6120@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <b7dd123f0a15fff62150bc560747d7f0.squirrel@webmail-b.css.fujitsu.com> <20090517041543.GA5156@balbir.in.ibm.com> <20090601132505.2fe9c870.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090601132505.2fe9c870.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2009-06-01 13:25:05]:

> I'm sorry for my very late reply.
> 
> I've been working on the stale swap cache problem for a long time as you know :)
> 
> On Sun, 17 May 2009 12:15:43 +0800, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-16 02:45:03]:
> > 
> > > I think set/clear flag here adds race condtion....because pc->flags is
> > > modfied by
> > >   pc->flags = pcg_dafault_flags[ctype] in commit_charge()
> > > you have to modify above lines to be
> > > 
> > >   SetPageCgroupCache(pc) or some..
> > >   ...
> > >   SetPageCgroupUsed(pc)
> > > 
> > > Then, you can use set_bit() without lock_page_cgroup().
> > > (Currently, pc->flags is modified only under lock_page_cgroup(), so,
> > >  non atomic code is used.)
> > >
> > 
> > Here is the next version of the patch
> > 
> > 
> > Feature: Remove the overhead associated with the root cgroup
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > This patch changes the memory cgroup and removes the overhead associated
> > with accounting all pages in the root cgroup. As a side-effect, we can
> > no longer set a memory hard limit in the root cgroup.
> > 
> I agree to this idea itself.
>

Thanks!
 
> > A new flag is used to track page_cgroup associated with the root cgroup
> > pages. A new flag to track whether the page has been accounted or not
> > has been added as well. Flags are now set atomically for page_cgroup,
> > pcg_default_flags is now obsolete, but I've not removed it yet. It
> > provides some readability to help the code.
> > 
> > Tests:
> > 1. Tested lightly, previous versions showed good performance improvement 10%.
> > 
> You should test current version :)
> And I think you should test this patch under global memory pressure too
> to check whether it doesn't cause bug or under/over flow of something, etc.
> memcg's LRU handling about SwapCache is different from usual one.
> 

OK, I've tested it using my stress tool, but I'll modify to add some
of the things you've pointed out.

> > NOTE:
> > I haven't got the time right now to run oprofile and get detailed test results,
> > since I am in the middle of travel.
> > 
> > Please review the code for functional correctness and if you can test
> > it even better. I would like to push this in, especially if the %
> > performance difference I am seeing is reproducible elsewhere as well.
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > ---
> > 
> >  include/linux/page_cgroup.h |   12 ++++++++++++
> >  mm/memcontrol.c             |   42 ++++++++++++++++++++++++++++++++++++++----
> >  mm/page_cgroup.c            |    1 -
> >  3 files changed, 50 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> > index 7339c7b..ebdae9a 100644
> > --- a/include/linux/page_cgroup.h
> > +++ b/include/linux/page_cgroup.h
> > @@ -26,6 +26,8 @@ enum {
> >  	PCG_LOCK,  /* page cgroup is locked */
> >  	PCG_CACHE, /* charged as cache */
> >  	PCG_USED, /* this object is in use. */
> > +	PCG_ROOT, /* page belongs to root cgroup */
> > +	PCG_ACCT, /* page has been accounted for */
> >  };
> >  
> Those new flags are protected by zone->lru_lock, right ?
> If so, please add some comments.
> And I'm not sure why you need 2 flags. Isn't PCG_ROOT enough for you ?
>

Nope.. the accounting is independent of charge/uncharge.
 
-- 
	Balbir
