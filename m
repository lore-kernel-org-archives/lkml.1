Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYHVLsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYHVLsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYHVLsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:48:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50728 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYHVLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:48:15 -0400
Date: Fri, 22 Aug 2008 20:54:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>, ryov@valinux.co.jp
Subject: Re: [PATCH -mm][preview] memcg: a patch series for next [8/9]
Message-Id: <20080822205405.a08dda6d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080822192943.4009a7b5.nishimura@mxp.nes.nec.co.jp>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819174404.80dd5102.kamezawa.hiroyu@jp.fujitsu.com>
	<20080822192943.4009a7b5.nishimura@mxp.nes.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 19:29:43 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> I think you are making updated ones, I send comments so far.
> 
Ah, sorry. I just sent one ;(.

> On Tue, 19 Aug 2008 17:44:04 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Very experimental...
> > 
> > mem+swap controller prototype.
> > 
> > This patch adds CONFIG_CGROUP_MEM_RES_CTLR_SWAP as memory resource
> > controller's swap extension.
> > 
> > When enabling this, memory resource controller will have 2 limits.
> > 
> >  - memory.limit_in_bytes .... limit for pages
> >  - memory.memsw_limit_in_bytes .... limit for pages + swaps.
> > 
> > Following is (easy) accounting state transion after this patch.
> > 
> >    pages   swaps    pages_total   memsw_total
> >     +1       -           +1           +1        new page allocation.
> >     -1      +1           -1           -         swap out.
> >     +1      -1            0           -         swap in (*).
> >     -       -1           -            -1        swap_free.
> > 
> What do you mean by "pages_total"?
> 
On memory resource. 
  The sum of
  - mapped anonymous pages 
  - pages of file cache.
  - pages of swap cache.


> > At swap-out, swp_entry will be charged against the cgroup of the page.
> > At swap-in, the page will be charged when it's mapped.
> > (Maybe accounting at read_swap() will be beautiful but we can avoid some of
> >  error handling to delay accounting until mem_cgroup_charge().)
> > 
> > The charge against swap_entry will be uncharged when swap_entry is freed.
> > 
> > The parameter res.swaps just includes swaps not-on swap cache.
> > So, this doesn't show real usage of swp_entry just shows swp_entry on disk.
> > 
> IMHO, it would be better to "show" real usage of swp_entry.
> Otherwise, "sum of swap usage of all groups" != "swap usage of
> system shown by meminfo"(but it means adding another counter, hmm...).
> 
Yes it means to add another counter. I'd like to try it.

> Instead of showing the usage of disk_swap, how about showing
> the memsw total usage, which is to be limited by user.
> 

Yes, I feel the amount of disk_swap is not very useful in my test.
Ok, showing memsw total somewhere.


> > This patch doesn't include codes for control files.
> > 
> > TODO:
> >   - clean up. and add comments.
> >   - support vm_swap_full() under cgroup.
> Is it needed?
> 
maybe.

> In my swap controller, swap entries are limited per cgroup.
> So, to make swap_cgroup_charge() fail less frequently,
> vm_swap_full() should be calculated per cgroup so that
> vm can free swap entries in advance.
> 
> But I think in mem+swap controller the situation is different.
> 
Hmm, I'd like to postpone this until we ends the test.


> >   - find easier-to-understand protocol....
> >   - check force_empty....(maybe buggy)
> >   - support page migration.
> >   - test!!
> > 
> And,
> - move charge along with task move
yes and moving charge of on-memory-resource should be done, too.

> - hierarchy support
> 
> Of course, more basic features and stabilization should be done first.
> 
Yes ;)

> 
> I agree with this patch as a whole, but I'm worrying about race
> between swapout and swapin about the same entry(I should consider more...).
> 
> 
swapout/swapin race is guarded by the face I always handle swap-cache.

add_to_swap_cache/delete_from_swap_cache is under lock_page().
and do_swap_page()'s charging is moved under lock_page().

I saw race with force_empty ;(. I hope it's fixed in the latest version.

Thanks,
-Kame

