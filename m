Return-Path: <linux-kernel-owner+w=401wt.eu-S936348AbYD1Qrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348AbYD1Qrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbYD1QrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:47:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936126AbYD1QrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:47:08 -0400
Date: Mon, 28 Apr 2008 09:40:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       balbir@in.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] [2/2] Simple stats for memory resource controller
Message-Id: <20080428094026.bc78ccc7.akpm@linux-foundation.org>
In-Reply-To: <200804282130.30188.balajirrao@gmail.com>
References: <200804052340.02386.balajirrao@gmail.com>
	<48036CB4.5050700@linux.vnet.ibm.com>
	<200804282130.30188.balajirrao@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 21:30:29 +0530 Balaji Rao <balajirrao@gmail.com> wrote:

> On Monday 14 April 2008 08:09:48 pm Balbir Singh wrote:
> > Balaji Rao wrote:
> > > This patch implements trivial statistics for the memory resource controller.
> > > 
> > > Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> > > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index a860765..ca98b21 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -47,6 +47,8 @@ enum mem_cgroup_stat_index {
> > >  	 */
> > >  	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> > >  	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
> > > +	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
> > > +	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
> > > 
> > >  	MEM_CGROUP_STAT_NSTATS,
> > >  };
> > > @@ -198,6 +200,13 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
> > >  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
> > >  	else
> > >  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
> > > +
> > > +	if (charge)
> > > +		__mem_cgroup_stat_add_safe(stat,
> > > +				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
> > > +	else
> > > +		__mem_cgroup_stat_add_safe(stat,
> > > +				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
> > >  }
> > > 
> > >  static struct mem_cgroup_per_zone *
> > > @@ -897,6 +906,8 @@ static const struct mem_cgroup_stat_desc {
> > >  } mem_cgroup_stat_desc[] = {
> > >  	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
> > >  	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
> > > +	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
> > > +	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
> > >  };
> > > 
> > >  static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
> > > 
> > 
> > Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Hi, Andrew,
> > 
> > Could you please include these statistics in -mm.
> > 
> > Balbir
> > 
> > 
> Hi Andrew,
> 
> Now that Balbir Singh has ACKed it, could you please include it in -mm ?

<looks>

I guess we can add this one, sure.  But [patch 1/2] needs work.

- The local_irq_save()-around-for_each_possible_cpu() locking doesn't
  make sense.

- indenting is busted in account_user_time() and account_system_time()

- The use of for_each_possible_cpu() can be grossly inefficient.  It
  would be preferred to use for_each_possible_cpu() and add a cpu-hotplug
  notifier.

- The proposed newly-added userspace interfaces are undocumented

- The changelogs don't explain why we might want this feature in Linux.

- Generally: there are a heck of a lot of different ways of accounting
  for things in core kernel and it's really sad to see yet another one
  being added.


Actually, [patch 2/2] adds new kerenl->user interfaces and doesn't document
them.  But afaict the existing memcgroup stats are secret too.

