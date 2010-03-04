Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0CDDsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:48:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53508 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0CDDsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:48:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 4 Mar 2010 12:45:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Greg@smtp1.linux-foundation.org,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-Id: <20100304124505.394a058e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100303220319.GA2706@linux>
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
	<1267478620-5276-4-git-send-email-arighi@develer.com>
	<20100303111238.7133f8af.nishimura@mxp.nes.nec.co.jp>
	<20100303122906.9c613ab2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100303150137.f56d7084.nishimura@mxp.nes.nec.co.jp>
	<20100303151549.5d3d686a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100303172132.fc6d9387.kamezawa.hiroyu@jp.fujitsu.com>
	<20100303220319.GA2706@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 23:03:19 +0100
Andrea Righi <arighi@develer.com> wrote:

> On Wed, Mar 03, 2010 at 05:21:32PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 3 Mar 2010 15:15:49 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> > +	preempt_disable();
> > +	lock_page_cgroup_migrate(pc);
> >  	page = pc->page;
> >  	if (page_mapped(page) && !PageAnon(page)) {
> >  		/* Update mapped_file data for mem_cgroup */
> > -		preempt_disable();
> >  		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> >  		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> > -		preempt_enable();
> >  	}
> >  	mem_cgroup_charge_statistics(from, pc, false);
> > +	move_acct_information(from, to, pc);
> 
> Kame-san, a question. According to is_target_pte_for_mc() it seems we
> don't move file pages across cgroups for now. 

yes. It's just in plan.

> If !PageAnon(page) we just return 0 and the page won't be selected for migration in
> mem_cgroup_move_charge_pte_range().
> 
> So, if I've understood well the code is correct in perspective, but
> right now it's unnecessary. File pages are not moved on task migration
> across cgroups and, at the moment, there's no way for file page
> accounted statistics to go negative.
> 
> Or am I missing something?
> 

At rmdir(), remainging file caches in a cgroup is moved to
its parent. Then, all file caches are moved to its parent at rmdir().

This behavior is for avoiding to lose too much file caches at removing cgroup.

Thanks,
-Kame


