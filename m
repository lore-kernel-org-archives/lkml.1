Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZFWEyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZFWEyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFWEx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:53:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47903 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZFWExz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:53:55 -0400
Date: Tue, 23 Jun 2009 10:23:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kamezawa.hiroyuki@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com, menage@google.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Low overhead patches for the memory cgroup controller (v5)
Message-ID: <20090623045316.GF8642@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090615043900.GF23577@balbir.in.ibm.com> <20090622154343.9cdbf23a.akpm@linux-foundation.org> <20090623090116.556d4f97.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090623090116.556d4f97.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-23 09:01:16]:

> On Mon, 22 Jun 2009 15:43:43 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 15 Jun 2009 10:09:00 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > >
> > > ...
> > > 
> > > This patch changes the memory cgroup and removes the overhead associated
> > > with accounting all pages in the root cgroup. As a side-effect, we can
> > > no longer set a memory hard limit in the root cgroup.
> > > 
> > > A new flag to track whether the page has been accounted or not
> > > has been added as well. Flags are now set atomically for page_cgroup,
> > > pcg_default_flags is now obsolete and removed.
> > > 
> > > ...
> > >
> > > @@ -1114,9 +1121,22 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
> > >  		css_put(&mem->css);
> > >  		return;
> > >  	}
> > > +
> > >  	pc->mem_cgroup = mem;
> > >  	smp_wmb();
> > > -	pc->flags = pcg_default_flags[ctype];
> > > +	switch (ctype) {
> > > +	case MEM_CGROUP_CHARGE_TYPE_CACHE:
> > > +	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
> > > +		SetPageCgroupCache(pc);
> > > +		SetPageCgroupUsed(pc);
> > > +		break;
> > > +	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> > > +		ClearPageCgroupCache(pc);
> > > +		SetPageCgroupUsed(pc);
> > > +		break;
> > > +	default:
> > > +		break;
> > > +	}
> > 
> > Do we still need the smp_wmb()?
> > 
> > It's hard to say, because we forgot to document it :(
> > 
> Sorry for lack of documentation.
> 
> pc->mem_cgroup should be visible before SetPageCgroupUsed(). Othrewise,
> A routine believes USED bit will see bad pc->mem_cgroup.
> 
> I'd like to  add a comment later (againt new mmotm.)
>

Thanks Kamezawa! We do use the barrier Andrew, an easy way to find
affected code is to look at the smp_rmb()'s we have. But it is better
documented.

-- 
	Balbir
