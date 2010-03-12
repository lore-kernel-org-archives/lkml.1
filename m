Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0CLCBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:01:08 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42033 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0CLCBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:01:06 -0500
Date: Thu, 11 Mar 2010 18:00:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: current_cpuset_is_being_rebound() need rcu lock
Message-ID: <20100312020056.GB6389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100311142035.94FD.A69D9226@jp.fujitsu.com> <20100311190759.GA6298@linux.vnet.ibm.com> <20100312085807.950B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312085807.950B.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:03:03AM +0900, KOSAKI Motohiro wrote:
> > On Thu, Mar 11, 2010 at 02:46:15PM +0900, KOSAKI Motohiro wrote:
> > > rcu lockdep detected cpuset have wrong rcu usage.
> > > the fixing is trivial. but I wonder why don't cpuset_being_rebound assignment
> > > and read need a memory barrier pairing?
> > 
> > The fix is in -tip, commit 99ee4ca746dda71326db7645463b4075ac1d665c.
> > 
> > This is an initialization-time use of rcu_dereference(), so no other
> > task has a reference to this data.  Hence it is constant.  Other uses
> > of this code operate on shared data structures, which might change at
> > any time.
> 
> thanks. I haven't notice such commit.
> 
> I think you are talking about task_cs(current) accessing and you are right
> in such point.
> but I'm talking cpuset_being_rebound global variable.
> 
> update_tasks_nodemask() has following code
> 
> static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
>                                  struct ptr_heap *heap)
> {
>         cpuset_being_rebound = cs;		/* start transaction */
>         cgroup_scan_tasks(&scan);
>         cpuset_being_rebound = NULL;		/* end transaction */
> }

Hmmm...  What commit are you looking at in what tree?  I instead see
a much larger function body for update_tasks_nodemask().  I am looking
in a number of places, including 522dba7134d6b2e5821d3457f7941ec34f668e6d
in Linus's git tree.

							Thanx, Paul
