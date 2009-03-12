Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZCLJpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZCLJpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZCLJpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:45:38 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:35183 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZCLJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:45:37 -0400
Date: Thu, 12 Mar 2009 15:15:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH 1/5] memcg use correct scan number at reclaim
Message-ID: <20090312094529.GA4335@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090312041414.GG23583@balbir.in.ibm.com> <20090312131739.296785da.kamezawa.hiroyu@jp.fujitsu.com> <20090312164204.43B7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312164204.43B7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-03-12 16:45:59]:

> > On Thu, 12 Mar 2009 09:44:14 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 13:05:56]:
> > > 
> > > > On Thu, 12 Mar 2009 09:30:54 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 12:51:24]:
> > > > > 
> > > > > > On Thu, 12 Mar 2009 09:19:18 +0530
> > > > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > > > 
> > > > > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:55:16]:
> > > > > > > 
> > > > > > > > Andrew, this [1/5] is a bug fix, others are not.
> > > > > > > > 
> > > > > > > > ==
> > > > > > > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > > > > > 
> > > > > > > > Even when page reclaim is under mem_cgroup, # of scan page is determined by
> > > > > > > > status of global LRU. Fix that.
> > > > > > > > 
> > > > > > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > > > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > > > > ---
> > > > > > > >  mm/vmscan.c |    2 +-
> > > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > > 
> > > > > > > > Index: mmotm-2.6.29-Mar10/mm/vmscan.c
> > > > > > > > ===================================================================
> > > > > > > > --- mmotm-2.6.29-Mar10.orig/mm/vmscan.c
> > > > > > > > +++ mmotm-2.6.29-Mar10/mm/vmscan.c
> > > > > > > > @@ -1470,7 +1470,7 @@ static void shrink_zone(int priority, st
> > > > > > > >  		int file = is_file_lru(l);
> > > > > > > >  		int scan;
> > > > > > > > 
> > > > > > > > -		scan = zone_page_state(zone, NR_LRU_BASE + l);
> > > > > > > > +		scan = zone_nr_pages(zone, sc, l);
> > > > > > > 
> > > > > > > I have the exact same patch in my patch queue. BTW, mem_cgroup_zone_nr_pages is
> > > > > > > buggy. We don't hold any sort of lock while extracting
> > > > > > > MEM_CGROUP_ZSTAT (ideally we need zone->lru_lock). Without that how do
> > > > > > > we guarantee that MEM_CGRUP_ZSTAT is not changing at the same time as
> > > > > > > we are reading it?
> > > > > > > 
> > > > > > Is it big problem ? We don't need very precise value and ZSTAT just have
> > > > > > increment/decrement. So, I tend to ignore this small race.
> > > > > > (and it's unsigned long, not long long.)
> > > > > >
> > > > > 
> > > > > The assumption is that unsigned long read is atomic even on 32 bit
> > > > > systems? What if we get pre-empted in the middle of reading the data
> > > > > and don't return back for long? The data can be highly in-accurate.
> > > > > No? 
> > > > > 
> > > > Hmm,  preempt_disable() is appropriate ?
> > > > 
> > > > But shrink_zone() itself works on the value which is read at this time and
> > > > dont' take care of changes in situation by preeemption...so it's not problem
> > > > of memcg.
> > > >
> > > 
> > > You'll end up reclaiming based on old stale data. shrink_zone itself
> > > maintains atomic data for zones.
> > > 
> > IIUC, # of pages to be scanned is just determined once, here.
> 
> In this case, lockless is right behavior.
> lockless is valuable than precise ZSTAT. end user can't observe this race.
>

Lockless works fine provided the data is correctly aligned. I need to
check this out more thoroghly.

-- 
	Balbir
