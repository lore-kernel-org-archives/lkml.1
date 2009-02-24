Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZBXAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZBXAMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbZBXAL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:11:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49208 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbZBXAL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:11:57 -0500
Date: Tue, 24 Feb 2009 09:10:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID v2
Message-Id: <20090224091034.02c37682.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090223145828.d14ff015.nishimura@mxp.nes.nec.co.jp>
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090209145557.d0754a9f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090223145828.d14ff015.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 14:58:28 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> I'm sorry for my late reply.
> 
> It looks good basically, but I have 1 comment.
> 
> >  static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
> >  {
> > -	struct mem_cgroup *mem;
> > +	unsigned short id;
> > +	struct mem_cgroup *mem = NULL;
> >  	swp_entry_t ent;
> >  
> >  	if (!PageSwapCache(page))
> >  		return NULL;
> >  
> >  	ent.val = page_private(page);
> > -	mem = lookup_swap_cgroup(ent);
> > -	if (!mem)
> > -		return NULL;
> > +	id = lookup_swap_cgroup(ent);
> > +	rcu_read_lock();
> > +	mem = mem_cgroup_lookup(id);
> >  	if (!css_tryget(&mem->css))
> We should check whether "mem" is NULL or not before css_tryget, because
> "mem" can be NULL(or "id" can be 0) if the page is on swapcache,
> that is, remove_from_swap_cache has not been called yet.
> 
> Actually, I got NULL pointer dereference bug here.
> 
Okay, will fix.

Thanks,
-kame


> > -		return NULL;
> > +		mem = NULL;
> > +	rcu_read_unlock();
> >  	return mem;
> >  }
> >  
> 
> 
> Thanks,
> Daisuke Nishimura.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

