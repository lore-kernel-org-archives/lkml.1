Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYKNHt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYKNHt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYKNHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:49:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48557 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKNHtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:49:18 -0500
Date: Fri, 14 Nov 2008 16:48:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
Message-Id: <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491D2C21.5000600@linux.vnet.ibm.com>
References: <20081113164201.GV29067@bolzano.suse.de>
	<20081113191837.18ed2ade.akpm@linux-foundation.org>
	<491CF609.3050203@cn.fujitsu.com>
	<20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>
	<491D2C21.5000600@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 13:13:29 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > How about this one ?
> > tested on x86-64 + mmotm-Nov10, works well. 
> > (test on other arch is welcome.)
> > 
> > -Kame
> > ==
> > As  Jan Blunck <jblunck@suse.de> pointed out, allocating
> > per-cpu stat for memcg to the size of NR_CPUS is not good.
> > 
> > This patch changes mem_cgroup's cpustat allocation not based
> > on NR_CPUS but based on nr_cpu_ids.
> > 
> > From: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > ---
> >  mm/memcontrol.c |   34 ++++++++++++++++++----------------
> >  1 file changed, 18 insertions(+), 16 deletions(-)
> > 
> > Index: mmotm-2.6.28-Nov10/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-2.6.28-Nov10.orig/mm/memcontrol.c
> > +++ mmotm-2.6.28-Nov10/mm/memcontrol.c
> > @@ -60,7 +60,7 @@ struct mem_cgroup_stat_cpu {
> >  } ____cacheline_aligned_in_smp;
> > 
> >  struct mem_cgroup_stat {
> > -	struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
> > +	struct mem_cgroup_stat_cpu cpustat[0];
> >  };
> > 
> >  /*
> > @@ -129,11 +129,10 @@ struct mem_cgroup {
> > 
> >  	int	prev_priority;	/* for recording reclaim priority */
> >  	/*
> > -	 * statistics.
> > +	 * statistics. This must be placed at the end of memcg.
> >  	 */
> >  	struct mem_cgroup_stat stat;
> >  };
> > -static struct mem_cgroup init_mem_cgroup;
> > 
> >  enum charge_type {
> >  	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
> > @@ -1292,42 +1291,45 @@ static void free_mem_cgroup_per_zone_inf
> >  	kfree(mem->info.nodeinfo[node]);
> >  }
> > 
> > +static int mem_cgroup_size(void)
> 
> inline this function?
> 
necessary ? 

> Other than that, I think the cont->parent check for freeing has already been
> spotted and pointed out
> 
Ah, yes. fixed in v2.

Thanks,
-Kame

