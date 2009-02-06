Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZBFCTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZBFCTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZBFCT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:19:26 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54315 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBFCT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:19:26 -0500
Date: Fri, 6 Feb 2009 11:18:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID
Message-Id: <20090206111812.da1de0d8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <498B9B6C.3000808@cn.fujitsu.com>
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
	<498B9B6C.3000808@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 10:07:40 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > +/*
> > + * A helper function to get mem_cgroup from ID. must be called under
> > + * rcu_read_lock(). Because css_tryget() is called under this, css_put
> > + * should be called later.
> > + */
> > +static struct mem_cgroup *mem_cgroup_lookup_get(unsigned short id)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +
> > +	/* ID 0 is unused ID */
> > +	if (!id)
> > +		return NULL;
> > +	css = css_lookup(&mem_cgroup_subsys, id);
> > +	if (css && css_tryget(css))
> > +		return container_of(css, struct mem_cgroup, css);
> > +	return NULL;
> > +}
> 
> the returned mem_cgroup needn't be protected by rcu_read_lock(), so I
> think this is better:
> 	rcu_read_lock();
> 	css = css_lookup(&mem_cgroup_subsys, id);
> 	rcu_read_unlock();
> and no lock is needed when calling mem_cgroup_lookup_get().
> 
Hmm, maybe you're right.

> >   * Returns old value at success, NULL at failure.
> >   * (Of course, old value can be NULL.)
> >   */
> > -struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
> > +unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
> 
> kernel-doc needs to be updated
> 
ok.

> >   * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
> >   * @ent: swap entry to be looked up.
> >   *
> > - * Returns pointer to mem_cgroup at success. NULL at failure.
> > + * Returns CSS ID of mem_cgroup at success. NULL at failure.
> 
> s/NULL/0/
> 
yes.

Okay, thanks.

BTW, this patch is totally buggy ;( Sorry. Below is my memo.
==

 - mem_cgroup can by destroyed() while there are swap_cgroup point to mem_cgroup.
   If there are reference from swap_cgroup, kfree() is delayed.
 - But this patch just uses css_tryget(). css_tryget() returnes false if
   mem_cgroup is destroyed.
 - So, refcnt for destroyed mem_cgroup will not be decreased and memory for
   mem_cgroup will be never freed.

 - Even if we use ID instead of pointer, the situation does not change.
   we have to prevent ID to be reused....
 - One choice for removing all swap_account at destroy() is forget all swap
   accounts. But this may need "scan" all swap_cgroup in the system at rmdir().
   This will be unacceptably slow on large swap systems. 
==

I'll post v2 but it will be still tricky. 

Thanks,
-Kame


















