Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYIZB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYIZB7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYIZB7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:59:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49384 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIZB7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:59:04 -0400
Date: Fri, 26 Sep 2008 11:05:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 9/12] memcg allocate all page_cgroup at boot
Message-Id: <20080926110550.2292287b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com>
	<20080925153206.281243dc.kamezawa.hiroyu@jp.fujitsu.com>
	<20080926100022.8bfb8d4d.nishimura@mxp.nes.nec.co.jp>
	<20080926104336.d96ab5bd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 10:43:36 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > -	/*
> > > -	 * Check if our page_cgroup is valid
> > > -	 */
> > > -	lock_page_cgroup(page);
> > > -	pc = page_get_page_cgroup(page);
> > > -	if (unlikely(!pc))
> > > -		goto unlock;
> > > -
> > > -	VM_BUG_ON(pc->page != page);
> > > +	pc = lookup_page_cgroup(page);
> > > +	if (unlikely(!pc || !PageCgroupUsed(pc)))
> > > +		return;
> > > +	preempt_disable();
> > > +	lock_page_cgroup(pc);
> > > +	if (unlikely(page_mapped(page))) {
> > > +		unlock_page_cgroup(pc);
> > > +		preempt_enable();
> > > +		return;
> > > +	}
> > Just for clarification, in what sequence will the page be mapped here?
> > mem_cgroup_uncharge_page checks whether the page is mapped.
> > 
> Please think about folloing situation.
> 
>    There is a SwapCache which is referred from 2 process, A, B.
>    A maps it.
>    B doesn't maps it.
> 
>    And now, process A exits.
> 
> 	CPU0(process A)				CPU1 (process B)
>  
>     zap_pte_range()
>     => page remove from rmap			=> charge() (do_swap_page)
> 	=> set page->mapcount->0          	
> 		=> uncharge()			=> set page->mapcount=1
> 
> This race is what patch 12/12 is fixed.
> This only happens on cursed SwapCache.
> 
Sorry, my brain seems to be sleeping.. above page_mapped() check doesn't
help this situation. Maybe this page_mapped() check is not necessary
because it's of no use.

I think this kind of problem will not be fixed until we handle SwapCache.


Thanks,
-Kame












