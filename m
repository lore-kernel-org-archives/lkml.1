Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZBCK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZBCK3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZBCK3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:29:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48740 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBCK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:29:32 -0500
Date: Tue, 3 Feb 2009 19:28:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v2)
Message-Id: <20090203192819.0c1e0544.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090203101921.GY918@balbir.in.ibm.com>
References: <20090203072013.GU918@balbir.in.ibm.com>
	<20090203072701.GV918@balbir.in.ibm.com>
	<20090203170427.c6070cda.kamezawa.hiroyu@jp.fujitsu.com>
	<20090203101921.GY918@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 15:49:21 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-03 17:04:27]:
> 
> > On Tue, 3 Feb 2009 12:57:01 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Checkpatch caught an additional space, so here is the patch again
> > > 
> > > 
> > > Description: Add RSS and swap to OOM output from memcg
> > > 
> > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > 
> > > Changelog v2..v1:
> > > 
> > > 1. Add more information about task's memcg and the memcg
> > >    over it's limit
> > > 2. Print data in KB
> > > 3. Move the print routine outside task_lock()
> > > 4. Use rcu_read_lock() around cgroup_path, strictly speaking it
> > >    is not required, but relying on the current memcg implementation
> > >    is not a good idea.
> > > 
> > > 
> > > This patch displays memcg values like failcnt, usage and limit
> > > when an OOM occurs due to memcg.
> > > 
> > > Thanks go out to Johannes Weiner, Li Zefan, David Rientjes,
> > > Kamezawa Hiroyuki, Daisuke Nishimura and KOSAKI Motohiro for
> > > review.
> > > 
> > 
> > IIUC, this oom_kill is serialized by memcg_tasklist mutex.
> > Then, you don't have to allocate buffer on stack.
> > 
> > 
> > > +void mem_cgroup_print_mem_info(struct mem_cgroup *memcg, struct task_struct *p)
> > > +{
> > > +	struct cgroup *task_cgrp;
> > > +	struct cgroup *mem_cgrp;
> > > +	/*
> > > +	 * Need a buffer on stack, can't rely on allocations.
> > > +	 */
> > > +	char task_memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> > > +	char memcg_name[MEM_CGROUP_OOM_BUF_SIZE];
> > > +	int ret;
> > > +
> > 
> > making this as
> > 
> > static char task_memcg_name[PATH_MAX];
> > static char memcg_name[PATH_MAX];
> > 
> > is ok, I think. and the patch will be more simple.
> >
> 
> I am having second thoughts about this one. It introduces a standard
> overhead of 2 pages on x86*, while the first one will work for most
> cases and all the overhead is on stack, which disappears quickly.
> That is the reason I did not do it in the first place and put it as a
> NOTE.
>  
But *128* is tooooooo short ;)
And, your patch makes "OOM Message Format" unstable.
>From system administration view, it's unacceptable.
Not printing name at all is better than "printed out sometimes you lucky"

Thanks,
-Kame



