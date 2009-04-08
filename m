Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZDHIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZDHIzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZDHIzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:55:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44923 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZDHIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:55:40 -0400
Date: Wed, 8 Apr 2009 17:54:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-Id: <20090408175409.eb0818db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090408084952.GG7082@balbir.in.ibm.com>
References: <20090407080355.GS7082@balbir.in.ibm.com>
	<20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052904.GY7082@balbir.in.ibm.com>
	<20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408070401.GC7082@balbir.in.ibm.com>
	<20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408071115.GD7082@balbir.in.ibm.com>
	<20090408161824.26f47077.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408074809.GF7082@balbir.in.ibm.com>
	<20090408170341.437c215b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408084952.GG7082@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 14:19:52 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 17:03:41]:
> 
> > On Wed, 8 Apr 2009 13:18:09 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > > > 3. Using the above, we can then try to (using an algorithm you
> > > > > proposed), try to do some work for figuring out the shared percentage.
> > > > > 
> > > > This is the point. At last. Why "# of shared pages" is important ?
> > > > 
> > > 
> > > I posted this in my motivation yesterday. # of shared pages can help
> > > plan the system better and the size of the cgroup. A cgroup might have
> > > small usage_in_bytes but large number of shared pages. We need a
> > > metric that can help figure out the fair usage of the cgroup.
> > > 
> > I don't fully understand but NR_FILE_MAPPED is an information in /proc/meminfo.
> > I personally think I want to support information in /proc/meminfo per memcg.
> > 
> > Hmm ? then, if you add a hook, it seems
> > == mm/rmap.c
> >  689 void page_add_file_rmap(struct page *page)
> >  690 {
> >  691         if (atomic_inc_and_test(&page->_mapcount))
> >  692                 __inc_zone_page_state(page, NR_FILE_MAPPED);
> >  693 }
> > ==  page_remove_rmap(struct page *page)
> >  739                 __dec_zone_page_state(page,
> >  740                         PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
> > ==
> > 
> > Is good place to go, maybe.
> > 
> > page->page_cgroup->mem_cgroup-> inc/dec counter ?
> > 
> > Maybe the patch itself will be simple, overhead is unknown..
> 
> I thought of the same thing, but then moved to the following
> 
> ... mem_cgroup_charge_statistics(..) {
>  if (page_mapcount(page) == 0 && page_is_file_cache(page))
>     __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_RSS, val);
> 
> But I've not yet tested the end result
> 
I think 
 - at uncharge:
   charge_statistics is only called when FILE CACHE is removed from radix-tree.
   mem_cgroup_uncharge() is called only when PageAnon(page).
 - at charge:
   charge_statistics is only called when FILE CACHE is added to radix-tree.

This "checking only radix-tree insert/delete" help us to remove most of overheads
on FILE CACHE.

So, adding new hooks to page_add_file_rmap() and page_remove_rmap()
is a way to go. (and easy to understand because we account it at the same time
NR_FILE_MAPPED is modified.)


Thanks,
-Kame






