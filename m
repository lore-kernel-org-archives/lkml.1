Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZBCPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZBCPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZBCPQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:16:51 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:48616 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZBCPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:16:51 -0500
Date: Tue, 3 Feb 2009 20:46:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v2)
Message-ID: <20090203151635.GC918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090203072013.GU918@balbir.in.ibm.com> <20090203072701.GV918@balbir.in.ibm.com> <20090203170427.c6070cda.kamezawa.hiroyu@jp.fujitsu.com> <20090203101921.GY918@balbir.in.ibm.com> <20090203192819.0c1e0544.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090203192819.0c1e0544.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-03 19:28:19]:

> On Tue, 3 Feb 2009 15:49:21 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-03 17:04:27]:
> > 
> > > On Tue, 3 Feb 2009 12:57:01 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > Checkpatch caught an additional space, so here is the patch again
> > > > 
> > > > 
> > > > Description: Add RSS and swap to OOM output from memcg
> > > > 
> > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > 
> > > > Changelog v2..v1:
> > > > 
> > > > 1. Add more information about task's memcg and the memcg
> > > >    over it's limit
> > > > 2. Print data in KB
> > > > 3. Move the print routine outside task_lock()
> > > > 4. Use rcu_read_lock() around cgroup_path, strictly speaking it
> > > >    is not required, but relying on the current memcg implementation
> > > >    is not a good idea.
> > > > 
> > > > 
> > > > This patch displays memcg values like failcnt, usage and limit
> > > > when an OOM occurs due to memcg.
> > > > 
> > > > Thanks go out to Johannes Weiner, Li Zefan, David Rientjes,
> > > > Kamezawa Hiroyuki, Daisuke Nishimura and KOSAKI Motohiro for
> > > > review.
> > > > 
> > > 
> > > IIUC, this oom_kill is serialized by memcg_tasklist mutex.
> > > Then, you don't have to allocate buffer on stack.
> > > 
> > > 
> > > > +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg, struct task_struct *p)
> > > > +{
> > > > +	struct cgroup *task_cgrp;
> > > > +	struct cgroup *mem_cgrp;
> > > > +	/*
> > > > +	 * Need a buffer on stack, can't rely on allocations.
> > > > +	 */
> > > > +	char task_memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> > > > +	char memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> > > > +	int ret;
> > > > +
> > > 
> > > making this as
> > > 
> > > static char task_memcg_name[PATH_MAX];
> > > static char memcg_name[PATH_MAX];
> > > 
> > > is ok, I think. and the patch will be more simple.
> > >
> > 
> > I am having second thoughts about this one. It introduces a standard
> > overhead of 2 pages on x86*, while the first one will work for most
> > cases and all the overhead is on stack, which disappears quickly.
> > That is the reason I did not do it in the first place and put it as a
> > NOTE.
> >  
> But *128* is tooooooo short ;)
> And, your patch makes "OOM Message Format" unstable.
> >From system administration view, it's unacceptable.
> Not printing name at all is better than "printed out sometimes you lucky"
>

OK, I have the code with PATH_MAX ready. I'll send that out.
 
-- 
	Balbir
