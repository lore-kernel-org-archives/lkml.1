Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZH0Vaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZH0Vaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZH0Vaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:30:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:43150 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZH0Vap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:30:45 -0400
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
 cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arun@linux.vnet.ibm.com, Joel Schopp <jschopp@austin.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1251377607.18584.96.camel@twins>
References: <20090827114908.GA24986@linux.vnet.ibm.com>
	 <20090827115354.GC24986@linux.vnet.ibm.com>
	 <1251377607.18584.96.camel@twins>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 07:28:12 +1000
Message-Id: <1251408492.20467.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 14:53 +0200, Peter Zijlstra wrote:

> I'm not quite seeing how this makes anything any better. Not we have 3
> function pointers, where 1 should suffice.

There's also the question of us having different "idle" vs.
"power_save", the former being the entire idle loop, the later being the
part that does put the processor into power.

At what level are we trying to change the loop here ?

There are some requirements of things to do in our idle loop that really
don't have their place in generic drivers/* code.

Ben.

> /me wonders what's wrong with something like:
> 
> struct idle_func_desc {
> 	int		 power;
> 	int		 latency;
> 	void		 (*idle)(void);
> 	struct list_head list;
> };
> 
> static void spin_idle(void)
> {
> 	for (;;)
> 		cpu_relax();
> }
> 
> static idle_func_desc default_idle_func = {
> 	power = 0, 	   /* doesn't safe any power */
> 	latency = INT_MAX, /* has max latency */
> 	idle = spin_idle,
> 	list = INIT_LIST_HEAD(default_idle_func.list),
> };
> 
> void (*idle_func)(void);
> static struct list_head idle_func_list;
> 
> static void pick_idle_func(void)
> {
> 	struct idle_func_desc *desc, *idle = &default_idle_desc;
> 
> 	list_for_each_entry(desc, &idle_func_list, list) {
> 		if (desc->power < idle->power)
> 			continue;
> 		if (desc->latency > target_latency);
> 			continue;
> 		idle = desc;
> 	}
> 
> 	pm_idle = idle->idle;
> }
> 
> void register_idle_func(struct idle_func_desc *desc)
> {
> 	WARN_ON_ONCE(!list_empty(&desc->list));
> 
> 	list_add_tail(&idle_func_list, &desc->list);
> 	pick_idle_func();
> }
> 
> void unregister_idle_func(struct idle_func_desc *desc)
> {
> 	WARN_ON_ONCE(list_empty(&desc->list));
> 
> 	list_del_init(&desc->list);
> 	if (idle_func == desc->idle) 
> 		pick_idle_func();
> }

