Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYEOBww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYEOBww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYEOBwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:52:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39994 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYEOBwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:52:41 -0400
Date: Thu, 15 May 2008 10:57:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/6] memcg: remove refcnt
Message-Id: <20080515105740.66e210db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <482B950C.2060408@cn.fujitsu.com>
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20080514170703.db2d9802.kamezawa.hiroyu@jp.fujitsu.com>
	<482B950C.2060408@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 09:42:36 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >  /*
> > - * Uncharging is always a welcome operation, we never complain, simply
> > - * uncharge.
> > + * uncharge if !page_mapped(page)
> >   */
> > -void mem_cgroup_uncharge_page(struct page *page)
> > +void __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
> 
> static void ?
> 
Ah yes. will fix.

> > Index: linux-2.6.26-rc2/include/linux/memcontrol.h
> > ===================================================================
> > --- linux-2.6.26-rc2.orig/include/linux/memcontrol.h
> > +++ linux-2.6.26-rc2/include/linux/memcontrol.h
> > @@ -35,6 +35,8 @@ extern int mem_cgroup_charge(struct page
> >  extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> >  					gfp_t gfp_mask);
> >  extern void mem_cgroup_uncharge_page(struct page *page);
> > +extern void mem_cgroup_uncharge_cache_page(struct page *page);
> > +extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
> 
> This function is defined and used in the 4th patch, so the declaration
> should be moved to that patch.
Ouch, I'll fix.


> 
> >  extern void mem_cgroup_move_lists(struct page *page, bool active);
> >  extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
> >  					struct list_head *dst,
> > @@ -53,7 +55,6 @@ extern struct mem_cgroup *mem_cgroup_fro
> >  extern int
> >  mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
> >  extern void mem_cgroup_end_migration(struct page *page);
> > -extern int mem_cgroup_getref(struct page *page);
> >  
> >  /*
> >   * For memory reclaim.
> > @@ -97,6 +98,14 @@ static inline int mem_cgroup_cache_charg
> >  static inline void mem_cgroup_uncharge_page(struct page *page)
> >  {
> >  }
> 
> need a blank line here
> 
ok.

> > +static inline void mem_cgroup_uncharge_cache_page(struct page *page)
> > +{
> > +}
> > +
> 
> [..snip..]
> 
> >  #ifdef CONFIG_DEBUG_VM
> > Index: linux-2.6.26-rc2/mm/shmem.c
> > ===================================================================
> > --- linux-2.6.26-rc2.orig/mm/shmem.c
> > +++ linux-2.6.26-rc2/mm/shmem.c
> > @@ -961,13 +961,14 @@ found:
> >  		shmem_swp_unmap(ptr);
> >  	spin_unlock(&info->lock);
> >  	radix_tree_preload_end();
> > -uncharge:
> > -	mem_cgroup_uncharge_page(page);
> >  out:
> >  	unlock_page(page);
> >  	page_cache_release(page);
> >  	iput(inode);		/* allows for NULL */
> >  	return error;
> > +uncharge:
> > +	mem_cgroup_uncharge_cache_page(page);
> > +	goto out;
> >  }
> >  
> 
> Seems the logic is changed here. is it intended ?
> 
intended. (if success, uncharge is not necessary because there is no refcnt.
I'll add comment.

Thanks,
-Kame

