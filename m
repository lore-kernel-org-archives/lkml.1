Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYDULNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYDULNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYDULM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:12:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43251 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYDULM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:12:57 -0400
Date: Mon, 21 Apr 2008 12:22:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, menage@google.com, xemul@openvz.org,
       shiwh@cn.fujitsu.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
In-Reply-To: <20080421064725.GA32214@balbir.in.ibm.com>
Message-ID: <Pine.LNX.4.64.0804211158001.10521@blonde.site>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804210004470.1630@blonde.site>
 <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
 <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com>
 <20080421064725.GA32214@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, Balbir Singh wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> [2008-04-21 12:14:28]:
> > Andrew Morton wrote:
> > >> On Mon, 21 Apr 2008 09:30:59 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >> On Mon, 21 Apr 2008 00:51:30 +0100 (BST)
> > >> Hugh Dickins <hugh@veritas.com> wrote:
> > >>>>  disable-the-memory-controller-by-default-v3.patch
> > >>>>  disable-the-memory-controller-by-default-v3-fix.patch
> > >>> If those are to go in, then the sooner the better, yes.
> > >>>
> > >>> But though I argued for cgroup_disable=memory (or some such),
> > >>> I think myself that taking it even further now (requiring an
> > >>> additional cgroup_enable=memory at boottime to get the memcg
> > >>> stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
> > >>> confusing overkill, just messing around.
> > > 
> > > Yes, it does sound a bit silly.  I'd say just enable it, and provide a
> > > cgroup_disable.

And 2.6.25 does already have that cgroup_disable=memory bootoption to
disable the config-enabled MEM_RES_CTLR and almost all of its overhead
(just leaving the extra pointer in struct page).

> OK, fair enough. Andi Kleen spoke about the overhead and how distros would
> be impacted if they enabled CONFIG_MEM_RES_CTLR and it was not disabled by
> default. I think the enable/disable is good. I just need to turn on/off
> mem_cgroup_subsys.disabled. The patch is as simple as
>  
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

That's a simple patch on top of:
disable-the-memory-controller-by-default-v3.patch
disable-the-memory-controller-by-default-v3-fix.patch

But even simpler is just to drop those patches, yes?
What's the point of adding cgroup_enable if nothing uses it?
And especially not for going into -stable.

I've added Andi to the Cc's, I don't want to sneak away something
he's expecting there.  If 2.6.25 had gone out with a convention that
controller infrastructure gets compiled in, but has then to be enabled
at boottime or runtime, okay; but switching back and forth between
defaults of enabled and disabled between releases (and between
controllers, as you seem to envisage) bothers me.

The config helptext (along with some misinformation) does conclude
	  Only enable when you're ok with these trade offs and really
	  sure you need the memory resource controller.
so I don't see why we now need to switch to disabled by default both
in config and at bootime - too many hurdles to my mind.

Hugh

> ---
> 
>  mm/memcontrol.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -puN mm/memcontrol.c~memcg-dont-disable-by-default mm/memcontrol.c
> --- linux-2.6.25/mm/memcontrol.c~memcg-dont-disable-by-default	2008-04-21 12:11:31.000000000 +0530
> +++ linux-2.6.25-balbir/mm/memcontrol.c	2008-04-21 12:11:40.000000000 +0530
> @@ -1108,5 +1108,4 @@ struct cgroup_subsys mem_cgroup_subsys =
>  	.populate = mem_cgroup_populate,
>  	.attach = mem_cgroup_move_task,
>  	.early_init = 0,
> -	.disabled = 1,
>  };
> _
> 
> This would enable the memory controller by default, it can be disabled
> using cgroup_disable=memory at boot time.
>  
>  
> > >>> Others think differently.  A compromise would be to improve the
> > >>> helptext for CGROUP_MEM_RES_CTLR (some of it is presently nonsense,
> > >>> isn't it?  Certainly there's a significant overhead, but it's the
> > >>> 32-bit struct page not the 64-bit which then suffers from crossing
> > >>> cacheline boundaries).  Not much point in mentioning
> > >>> cgroup_disable=memory if those patches go in, but needs to say
> > >>> cgroup_enable=memory bootoption also needed.
> > >>>
> > >> My concern around this is "default" action of cgroups may be different
> > >> from each otther. It's confusing...
