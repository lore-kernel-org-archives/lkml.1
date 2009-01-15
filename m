Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZAOCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZAOCax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZAOCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:30:44 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33451 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZAOCao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:30:44 -0500
Date: Thu, 15 Jan 2009 11:14:20 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "LKML" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>
Subject: Re: [RFC][PATCH 5/4] memcg: don't call res_counter_uncharge when
 obsolete
Message-Id: <20090115111420.8559bdb3.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090115110044.3a863af8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<7602a77a9fc6b1e8757468048fde749a.squirrel@webmail-b.css.fujitsu.com>
	<20090115100330.37d89d3d.nishimura@mxp.nes.nec.co.jp>
	<20090115110044.3a863af8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > To handle the problem "parent may be obsolete",
> > > 
> > > call mem_cgroup_get(parent) at create()
> > > call mem_cgroup_put(parent) at freeing memcg.
> > >      (regardless of use_hierarchy.)
> > > 
> > > is clearer way to go, I think.
> > > 
> > > I wonder whether there is  mis-accounting problem or not..
> > > 
> > > So, adding css_tryget() around problematic code can be a fix.
> > > --
> > >   mem = swap_cgroup_record();
> > >   if (css_tryget(&mem->css)) {
> > >       res_counter_uncharge(&mem->memsw, PAZE_SIZE);
> > >       css_put(&mem->css)
> > >   }
> > > --
> > > I like css_tryget() rather than mem_cgroup_obsolete().
> > I agree.
> > The updated version is attached.
> > 
> > 
> > Thanks,
> > Daisuke nishimura.
> > 
> > > To be honest, I'd like to remove memcg special stuff when I can.
> > > 
> > > Thanks,
> > > -Kame
> > > 
> > ===
> > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > 
> > mem_cgroup_get ensures that the memcg that has been got can be accessed
> > even after the directory has been removed, but it doesn't ensure that parents
> > of it can be accessed: parents might have been freed already by rmdir.
> > 
> > This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
> > climb up the tree.
> > 
> > Check if the memcg is obsolete by css_tryget, and don't call
> > res_counter_uncharge when obsole.
> > 
> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> seems nice loock.
> 
> 
> > ---
> >  mm/memcontrol.c |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index fb62b43..4e3b100 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1182,7 +1182,10 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> >  		/* avoid double counting */
> >  		mem = swap_cgroup_record(ent, NULL);
> >  		if (mem) {
> > -			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
> > +			if (!css_tryget(&mem->css)) {
> > +				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
> > +				css_put(&mem->css);
> > +			}
> >  			mem_cgroup_put(mem);
> >  		}
> >  	}
> 
> I think css_tryget() returns "ture" at success....
> 
> So,
> ==
> 	if (mem && css_tryget(&mem->css))
> 		res_counter....
> 
> is correct.
> 
> -Kame
> 
Ooops! you are right.
Sorry for my silly mistake..

"mem" is checked beforehand, so I think css_tryget would be enough.
I'm now testing the attached one.


Thanks,
Daisuke Nishimura.
===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_get ensures that the memcg that has been got can be accessed
even after the directory has been removed, but it doesn't ensure that parents
of it can be accessed: parents might have been freed already by rmdir.

This causes a bug in case of use_hierarchy==1, because res_counter_uncharge
climb up the tree.

Check if the memcg is obsolete by css_tryget, and don't call
res_counter_uncharge when obsole.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fb62b43..b9d5271 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1182,7 +1182,10 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 		/* avoid double counting */
 		mem = swap_cgroup_record(ent, NULL);
 		if (mem) {
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			if (css_tryget(&mem->css)) {
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+				css_put(&mem->css);
+			}
 			mem_cgroup_put(mem);
 		}
 	}
@@ -1252,7 +1255,10 @@ void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
 		if (memcg) {
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			if (css_tryget(&memcg->css)) {
+				res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+				css_put(&memcg->css);
+			}
 			mem_cgroup_put(memcg);
 		}
 
@@ -1397,7 +1403,10 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 
 	memcg = swap_cgroup_record(ent, NULL);
 	if (memcg) {
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		if (css_tryget(&memcg->css)) {
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+			css_put(&memcg->css);
+		}
 		mem_cgroup_put(memcg);
 	}
 }
