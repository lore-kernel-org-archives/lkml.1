Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0CBNue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:50:34 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57916 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CBNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:50:32 -0500
Date: Tue, 2 Mar 2010 19:20:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>, Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-ID: <20100302135026.GH3212@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
 <1267478620-5276-4-git-send-email-arighi@develer.com>
 <20100302092309.bff454d7.kamezawa.hiroyu@jp.fujitsu.com>
 <20100302080056.GA1548@linux>
 <20100302172316.b959b04c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100302172316.b959b04c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-02 17:23:16]:

> On Tue, 2 Mar 2010 09:01:58 +0100
> Andrea Righi <arighi@develer.com> wrote:
> 
> > On Tue, Mar 02, 2010 at 09:23:09AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Mon,  1 Mar 2010 22:23:40 +0100
> > > Andrea Righi <arighi@develer.com> wrote:
> > > 
> > > > Apply the cgroup dirty pages accounting and limiting infrastructure to
> > > > the opportune kernel functions.
> > > > 
> > > > Signed-off-by: Andrea Righi <arighi@develer.com>
> > > 
> > > Seems nice.
> > > 
> > > Hmm. the last problem is moving account between memcg.
> > > 
> > > Right ?
> > 
> > Correct. This was actually the last item of the TODO list. Anyway, I'm
> > still considering if it's correct to move dirty pages when a task is
> > migrated from a cgroup to another. Currently, dirty pages just remain in
> > the original cgroup and are flushed depending on the original cgroup
> > settings. That is not totally wrong... at least moving the dirty pages
> > between memcgs should be optional (move_charge_at_immigrate?).
> > 
> 
> My concern is 
>  - migration between memcg is already suppoted
>     - at task move
>     - at rmdir
> 
> Then, if you leave DIRTY_PAGE accounting to original cgroup,
> the new cgroup (migration target)'s Dirty page accounting may
> goes to be negative, or incorrect value. Please check FILE_MAPPED
> implementation in __mem_cgroup_move_account()
> 
> As
>        if (page_mapped(page) && !PageAnon(page)) {
>                 /* Update mapped_file data for mem_cgroup */
>                 preempt_disable();
>                 __this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
>                 __this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
>                 preempt_enable();
>         }
> then, FILE_MAPPED never goes negative.
>

Absolutely! I am not sure how complex dirty memory migration will be,
but one way of working around it would be to disable migration of
charges when the feature is enabled (dirty* is set in the memory
cgroup). We might need additional logic to allow that to happen. 

-- 
	Three Cheers,
	Balbir
