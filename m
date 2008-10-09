Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYJIGvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYJIGvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbYJIGvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:51:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51275 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYJIGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:51:34 -0400
Date: Thu, 9 Oct 2008 15:51:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] memcg: lazy lru addition
Message-Id: <20081009155116.ccf0833d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081009152132.df6e54c4.nishimura@mxp.nes.nec.co.jp>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001170119.80a617b7.kamezawa.hiroyu@jp.fujitsu.com>
	<20081009152132.df6e54c4.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008 15:21:32 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 1 Oct 2008 17:01:19 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Delaying add_to_lru() and do it in batched manner like page_vec.
> > For doing that 2 flags PCG_USED and PCG_LRU.
> > 
> > Because __set_page_cgroup_lru() itself doesn't take lock_page_cgroup(),
> > we need a sanity check inside lru_lock().
> > 
> > And this delaying make css_put()/get() complicated. 
> > To make it clear,
> >  * css_get() is called from mem_cgroup_add_list().
> >  * css_put() is called from mem_cgroup_remove_list().
> >  * css_get()->css_put() is called while try_charge()->commit/cancel sequence.
> > is newly added.
> > 
> 
> I like this new policy, but
> 
> > @@ -710,17 +774,18 @@ static void __mem_cgroup_commit_charge(s
> 
> ===
>                 if (PageCgroupLRU(pc)) {
>                         ClearPageCgroupLRU(pc);
>                         __mem_cgroup_remove_list(mz, pc);
>                         css_put(&pc->mem_cgroup->css);
>                 }
>                 spin_unlock_irqrestore(&mz->lru_lock, flags);
>         }
> ===
> 
> Is this css_put needed yet?
> 
Oh, nice catch. it's unnecessary.
I'll fix this in the next. Thank you for review.


I'll post still-under-discuss set (v7), tomorrow.
includes
  - charge/commit/cancel
  - move account & force_empty
  - lazy lru free
  - lazy lru add
Currently works well under my test..

In the next week, I'd like to restart Mem+Swap series.

Thanks,
-Kame

