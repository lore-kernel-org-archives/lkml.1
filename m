Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbYF0IrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbYF0IrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYF0IrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:47:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbYF0IrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:47:04 -0400
Date: Fri, 27 Jun 2008 17:52:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [-mm][PATCH 8/10] fix shmem page migration incorrectness on
 memcgroup
Message-Id: <20080627175201.cbe86a06.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360806270057w2b2d3e56ob4dde9aacf42327b@mail.gmail.com>
References: <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360806262208i6791d67at446f7323ded16206@mail.gmail.com>
	<20080627142950.7A83.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360806270057w2b2d3e56ob4dde9aacf42327b@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 16:57:56 +0900
"MinChan Kim" <minchan.kim@gmail.com> wrote:

> On Fri, Jun 27, 2008 at 2:41 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> > mem_cgroup_uncharge() against old page is done after radix-tree-replacement.
> >> > And there were special handling to ingore swap-cache page. But, shmem can
> >> > be swap-cache and file-cache at the same time. Chekcing PageSwapCache() is
> >> > not correct here. Check PageAnon() instead.
> >>
> >> When/How shmem can be both swap-cache and file-cache ?
> >> I can't understand that situation.
> >
> > Hi
> >
> > see,
> >
> > shmem_writepage()
> >   -> add_to_swap_cache()
> >      -> SetPageSwapCache()
> >
> >
> > BTW: his file-cache mean !Anon, not mean !SwapBacked.
> 
> Hi KOSAKI-san.
> Thanks for explaining.
> 
> In the migrate_page_move_mapping, the page was already locked in unmap_and_move.
> Also, we have a lock for that page for calling shmem_writepage.
> 
> So I think race problem between shmem_writepage and
> migrate_page_move_mapping don't occur.
> But I am not sure I am right.
> 
> If I am wrong, could you tell me when race problem happen ? :)
> 
You are right. I misundestood the swap/shmem code. there is no race.
Hmm...

But situation is a bit complicated.
- shmem's page is charged as file-cache.
- shmem's swap cache is still charged by mem_cgroup_cache_charge() because
  it's implicitly (to memcg) converted to swap cache. 
- anon's swap cache is charged by mem_cgroup_uncharge_cache_page()

So, uncharging swap-cache of shmem by mem_cgroup_uncharge_cache_page() is valid.
Checking PageSwapCache() was bad and Cheking PageAnon() is good.
(From maintainance view)

I think the patch is valid but my patch description contains wrong information.
Andrew, could you drop this ? I'll rewrite the patch description.

Sorry,
-Kame

