Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYKGO1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYKGO1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYKGO1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:27:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYKGO1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:27:34 -0500
Date: Fri, 7 Nov 2008 09:27:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 1/4] io controller: documentation
Message-ID: <20081107142715.GD21884@redhat.com>
References: <20081106153022.215696930@redhat.com> <20081106153135.743458085@redhat.com> <20081107113209.a6011c67.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107113209.a6011c67.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:32:09AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 06 Nov 2008 10:30:23 -0500
> vgoyal@redhat.com wrote:
> > +ISSUES
> > +======
> > +- IO controller can buffer the bios if suffcient tokens were not available
> > +  at the time of bio submission. Once the tokens are available, these bios
> > +  are dispatched to elevator/lower layers in first come first serve manner.
> > +  And this has potential to break CFQ where a RT tasks should be able to
> > +  dispatch the bio first or a high priority task should be able to release
> > +  more bio as compared to low priority task in same cgroup.
> > +
> > +  Not sure how to fix it. May be we need to maintain another rb-tree and
> > +  keep track of RT tasks and tasks priorities and dispatch accordingly. This
> > +  is equivalent of duplicating lots of CFQ logic and not sure how would it
> > +  impact AS behaviour.
> > 
> Why you don't isolate RT tasks into other cgroup ?
>    /cgroup/bio-cgroup/group_for_usual/...usual tasks.
>                      /group_for_RT/ ...RT tasks. you can use high-speed path.
> 
> How about adding RT flag to bio-cgroup and skip buffering at bio-cgroup if RT
> flag is set ? I think handling an usual process and RT process in "a" cgroup
> just makes the code complex.
> 
> Looking into a cpu-scheduler, which is the first module handling RT, it has
> some tweaks to handle RT in the system.
>  - special RT scheduler.
>  - isolated RT domain
>  - maximum execution time allowed to RT
>  ....
> 
> Maybe handling RT in following way is usual way...(if we do something in this layer)
> 
>   - Allow RT-bio-cgroup to skip limit check.
>   - But RT-bio-cgroup calculates io-throuput, execution time, statistics...
>   - When RT tasks in RT-bio-cgroup does excessive I/O which starves the whole system
>     too long, raise safeguard-limitter. and tell users Warning or kill it.
> 
> Hmm ?

Hi Kame,

Looking at CFQ, there are two issues.

- RT tasks (and RT priorities with in that)
- Best Effort class tasks (and priorities with in that).

To make sure we don't break underlying CFQ elevator, we need to take care of 
both the things in higher level scheduler. This will mean practically we
will end up copying code from CFQ in higher level scheduler.

Even if I do that (Keep track of RT tasks and Best effort class tasks and 
their proirities and do dispatch accordingly), I am not sure will it have
any negative impact when a user is using AS IO scheduler on the leaf node.

That forces me to think that if we can let go the idea of doing
proportionate bandwidth allocation at higher level logical device and just
do it for leaf nodes, then we can drop the idea of two level scheduler and
try to bring unification among four IO schedulers such that with least 
code copying they can also support proportional weight policies.

Thanks
Vivek
