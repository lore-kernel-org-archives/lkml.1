Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0CBXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:24:57 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50604 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0CBXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:24:56 -0500
Date: Wed, 3 Mar 2010 08:21:07 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mmotm 3/3] memcg: dirty pages instrumentation
Message-Id: <20100303082107.a29562fa.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100302221823.GC2369@linux>
References: <1267478620-5276-1-git-send-email-arighi@develer.com>
	<1267478620-5276-4-git-send-email-arighi@develer.com>
	<20100302092309.bff454d7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302080056.GA1548@linux>
	<20100302172316.b959b04c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302135026.GH3212@balbir.in.ibm.com>
	<20100302221823.GC2369@linux>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 23:18:23 +0100, Andrea Righi <arighi@develer.com> wrote:
> On Tue, Mar 02, 2010 at 07:20:26PM +0530, Balbir Singh wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-02 17:23:16]:
> > 
> > > On Tue, 2 Mar 2010 09:01:58 +0100
> > > Andrea Righi <arighi@develer.com> wrote:
> > > 
> > > > On Tue, Mar 02, 2010 at 09:23:09AM +0900, KAMEZAWA Hiroyuki wrote:
> > > > > On Mon,  1 Mar 2010 22:23:40 +0100
> > > > > Andrea Righi <arighi@develer.com> wrote:
> > > > > 
> > > > > > Apply the cgroup dirty pages accounting and limiting infrastructure to
> > > > > > the opportune kernel functions.
> > > > > > 
> > > > > > Signed-off-by: Andrea Righi <arighi@develer.com>
> > > > > 
> > > > > Seems nice.
> > > > > 
> > > > > Hmm. the last problem is moving account between memcg.
> > > > > 
> > > > > Right ?
> > > > 
> > > > Correct. This was actually the last item of the TODO list. Anyway, I'm
> > > > still considering if it's correct to move dirty pages when a task is
> > > > migrated from a cgroup to another. Currently, dirty pages just remain in
> > > > the original cgroup and are flushed depending on the original cgroup
> > > > settings. That is not totally wrong... at least moving the dirty pages
> > > > between memcgs should be optional (move_charge_at_immigrate?).
> > > > 
> > > 
> > > My concern is 
> > >  - migration between memcg is already suppoted
> > >     - at task move
> > >     - at rmdir
> > > 
> > > Then, if you leave DIRTY_PAGE accounting to original cgroup,
> > > the new cgroup (migration target)'s Dirty page accounting may
> > > goes to be negative, or incorrect value. Please check FILE_MAPPED
> > > implementation in __mem_cgroup_move_account()
> > > 
> > > As
> > >        if (page_mapped(page) && !PageAnon(page)) {
> > >                 /* Update mapped_file data for mem_cgroup */
> > >                 preempt_disable();
> > >                 __this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> > >                 __this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> > >                 preempt_enable();
> > >         }
> > > then, FILE_MAPPED never goes negative.
> > >
> > 
> > Absolutely! I am not sure how complex dirty memory migration will be,
> > but one way of working around it would be to disable migration of
> > charges when the feature is enabled (dirty* is set in the memory
> > cgroup). We might need additional logic to allow that to happen. 
> 
> I've started to look at dirty memory migration. First attempt is to add
> DIRTY, WRITEBACK, etc. to page_cgroup flags and handle them in
> __mem_cgroup_move_account(). Probably I'll have something ready for the
> next version of the patch. I still need to figure if this can work as
> expected...
> 
I agree it's a right direction(in fact, I have been planning to post a patch
in that direction), so I leave it to you.
Can you add PCG_FILE_MAPPED flag too ? I think this flag can be handled in the
same way as other flags you're trying to add, and we can change
"if (page_mapped(page) && !PageAnon(page))" to "if (PageCgroupFileMapped(pc)"
in __mem_cgroup_move_account(). It would be cleaner than current code, IMHO.


Thanks,
Daisuke Nishimura.
