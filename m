Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZG1B0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZG1B0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZG1B0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:26:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45535 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG1B0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:26:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Jul 2009 10:24:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       y-goto@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Message-Id: <20090728102411.2a18c2e3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090728101157.9465b2e5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
	<20090724160936.a3b8ad29.akpm@linux-foundation.org>
	<337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
	<5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
	<9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
	<alpine.DEB.2.00.0907271047590.8408@chino.kir.corp.google.com>
	<20090728085810.f7ae678a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907271710590.27881@chino.kir.corp.google.com>
	<20090728092529.bb0d7e9c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907271731040.29815@chino.kir.corp.google.com>
	<20090728095453.1fe79de1.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0907271758170.29815@chino.kir.corp.google.com>
	<20090728101157.9465b2e5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 10:11:57 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 27 Jul 2009 18:02:50 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > On Tue, 28 Jul 2009, KAMEZAWA Hiroyuki wrote:
> > 
> > > > The problem originally reported here doesn't appear to have anything to do 
> > > > with hotplug, it looks like it is the result of Lee's observation that 
> > > > ia64 defaults top_cpuset's mems to N_POSSIBLE, which _should_ have been 
> > > > updated by cpuset_init_smp(). 
> > > cpuset_init_smp() just updates cpuset's mask.
> > > init's task->mems_allowed is intizialized independently from cpuset's mask.
> > > 
> > 
> > Presumably the bug is that N_HIGH_MEMORY is not a subset of N_ONLINE at 
> > this point on ia64.
> > 
> N_HIGH_MEMORY is must be subset of N_ONLINE, at the any moment. Hmm,
> I'll look into what happens in ia64 world.
> 

At quick look, N_HIGH_MEMORY is set here while init. (I ignore hoplug now.)

== before init==
  60 #ifndef CONFIG_NUMA
  61         [N_NORMAL_MEMORY] = { { [0] = 1UL } },
  62 #ifdef CONFIG_HIGHMEM
  63         [N_HIGH_MEMORY] = { { [0] = 1UL } },
  64 #endif
== 
3860 static unsigned long __init early_calculate_totalpages(void)
3861 {
  ....
3869                 if (pages)
3870                         node_set_state(early_node_map[i].nid, N_HIGH_MEMORY);
3871         }
==
4041 void __init free_area_init_nodes(unsigned long *max_zone_pfn)
4042 {
4105                 if (pgdat->node_present_pages)
4106                         node_set_state(nid, N_HIGH_MEMORY);
==


All of them are done while mem_init(). Then if N_HIGH_MEMORY is not correct at
kernel_init(). It's bug.

I think what Lee and Miao pointed out is just a hotplug problem.
Ok, I'll try some patch but it'll take some hours.

Thanks,
-Kame

