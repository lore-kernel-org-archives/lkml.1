Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZCLETX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZCLETX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZCLETI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:19:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50035 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZCLETG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:19:06 -0400
Date: Thu, 12 Mar 2009 13:17:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH 1/5] memcg use correct scan number at reclaim
Message-Id: <20090312131739.296785da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312041414.GG23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312095516.53a2d029.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312034918.GB23583@balbir.in.ibm.com>
	<20090312125124.06af6ad9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312040054.GE23583@balbir.in.ibm.com>
	<20090312130556.68d03711.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312041414.GG23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:44:14 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 13:05:56]:
> 
> > On Thu, 12 Mar 2009 09:30:54 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 12:51:24]:
> > > 
> > > > On Thu, 12 Mar 2009 09:19:18 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:55:16]:
> > > > > 
> > > > > > Andrew, this [1/5] is a bug fix, others are not.
> > > > > > 
> > > > > > ==
> > > > > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > > > 
> > > > > > Even when page reclaim is under mem_cgroup, # of scan page is determined by
> > > > > > status of global LRU. Fix that.
> > > > > > 
> > > > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > > ---
> > > > > >  mm/vmscan.c |    2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > Index: mmotm-2.6.29-Mar10/mm/vmscan.c
> > > > > > ===================================================================
> > > > > > --- mmotm-2.6.29-Mar10.orig/mm/vmscan.c
> > > > > > +++ mmotm-2.6.29-Mar10/mm/vmscan.c
> > > > > > @@ -1470,7 +1470,7 @@ static void shrink_zone(int priority, st
> > > > > >  		int file = is_file_lru(l);
> > > > > >  		int scan;
> > > > > > 
> > > > > > -		scan = zone_page_state(zone, NR_LRU_BASE + l);
> > > > > > +		scan = zone_nr_pages(zone, sc, l);
> > > > > 
> > > > > I have the exact same patch in my patch queue. BTW, mem_cgroup_zone_nr_pages is
> > > > > buggy. We don't hold any sort of lock while extracting
> > > > > MEM_CGROUP_ZSTAT (ideally we need zone->lru_lock). Without that how do
> > > > > we guarantee that MEM_CGRUP_ZSTAT is not changing at the same time as
> > > > > we are reading it?
> > > > > 
> > > > Is it big problem ? We don't need very precise value and ZSTAT just have
> > > > increment/decrement. So, I tend to ignore this small race.
> > > > (and it's unsigned long, not long long.)
> > > >
> > > 
> > > The assumption is that unsigned long read is atomic even on 32 bit
> > > systems? What if we get pre-empted in the middle of reading the data
> > > and don't return back for long? The data can be highly in-accurate.
> > > No? 
> > > 
> > Hmm,  preempt_disable() is appropriate ?
> > 
> > But shrink_zone() itself works on the value which is read at this time and
> > dont' take care of changes in situation by preeemption...so it's not problem
> > of memcg.
> >
> 
> You'll end up reclaiming based on old stale data. shrink_zone itself
> maintains atomic data for zones.
> 
IIUC, # of pages to be scanned is just determined once, here.

Thanks,
-Kame

