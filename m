Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0BTD5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 22:57:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44586 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0BTD5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 22:57:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Sat, 20 Feb 2010 12:53:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 09/12] Add /proc trigger for memory compaction
Message-Id: <20100220125339.1b9874b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100219141641.GJ30258@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	<1266516162-14154-10-git-send-email-mel@csn.ul.ie>
	<20100219094326.e725f8e8.kamezawa.hiroyu@jp.fujitsu.com>
	<20100219141641.GJ30258@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010 14:16:41 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Feb 19, 2010 at 09:43:26AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 18 Feb 2010 18:02:39 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> > > value is written to the file, all zones are compacted. The expected user
> > > of such a trigger is a job scheduler that prepares the system before the
> > > target application runs.
> > > 
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > > Acked-by: Rik van Riel <riel@redhat.com>
> > 
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Nitpick:
> > Hmm.. Is this necessary if we have per-node trigger in sysfs ?
> > 
> 
> What does !NUMA do?
> 
.... I missed that. please ignore my comment.
(And I missed that we already have famous trigger as drop_caches in sysctl..)

Thanks,
-Kame


> > Thanks,
> > -Kame
> > 
> > 
> > > ---
> > >  Documentation/sysctl/vm.txt |   11 ++++++++
> > >  include/linux/compaction.h  |    5 +++
> > >  kernel/sysctl.c             |   11 ++++++++
> > >  mm/compaction.c             |   60 +++++++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 87 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> > > index fc5790d..92b5b00 100644
> > > --- a/Documentation/sysctl/vm.txt
> > > +++ b/Documentation/sysctl/vm.txt
> > > @@ -19,6 +19,7 @@ files can be found in mm/swap.c.
> > >  Currently, these files are in /proc/sys/vm:
> > >  
> > >  - block_dump
> > > +- compact_memory
> > >  - dirty_background_bytes
> > >  - dirty_background_ratio
> > >  - dirty_bytes
> > > @@ -64,6 +65,16 @@ information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
> > >  
> > >  ==============================================================
> > >  
> > > +compact_memory
> > > +
> > > +Available only when CONFIG_COMPACTION is set. When an arbitrary value
> > > +is written to the file, all zones are compacted such that free memory
> > > +is available in contiguous blocks where possible. This can be important
> > > +for example in the allocation of huge pages although processes will also
> > > +directly compact memory as required.
> > > +
> > > +==============================================================
> > > +
> > >  dirty_background_bytes
> > >  
> > >  Contains the amount of dirty memory at which the pdflush background writeback
> > > diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> > > index 6201371..facaa3d 100644
> > > --- a/include/linux/compaction.h
> > > +++ b/include/linux/compaction.h
> > > @@ -5,4 +5,9 @@
> > >  #define COMPACT_INCOMPLETE	0
> > >  #define COMPACT_COMPLETE	1
> > >  
> > > +#ifdef CONFIG_COMPACTION
> > > +extern int sysctl_compaction_handler(struct ctl_table *table, int write,
> > > +			void __user *buffer, size_t *length, loff_t *ppos);
> > > +#endif /* CONFIG_COMPACTION */
> > > +
> > >  #endif /* _LINUX_COMPACTION_H */
> > > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > > index 8a68b24..a02c816 100644
> > > --- a/kernel/sysctl.c
> > > +++ b/kernel/sysctl.c
> > > @@ -50,6 +50,7 @@
> > >  #include <linux/ftrace.h>
> > >  #include <linux/slow-work.h>
> > >  #include <linux/perf_event.h>
> > > +#include <linux/compaction.h>
> > >  
> > >  #include <asm/uaccess.h>
> > >  #include <asm/processor.h>
> > > @@ -80,6 +81,7 @@ extern int pid_max;
> > >  extern int min_free_kbytes;
> > >  extern int pid_max_min, pid_max_max;
> > >  extern int sysctl_drop_caches;
> > > +extern int sysctl_compact_memory;
> > >  extern int percpu_pagelist_fraction;
> > >  extern int compat_log;
> > >  extern int latencytop_enabled;
> > > @@ -1109,6 +1111,15 @@ static struct ctl_table vm_table[] = {
> > >  		.mode		= 0644,
> > >  		.proc_handler	= drop_caches_sysctl_handler,
> > >  	},
> > > +#ifdef CONFIG_COMPACTION
> > > +	{
> > > +		.procname	= "compact_memory",
> > > +		.data		= &sysctl_compact_memory,
> > > +		.maxlen		= sizeof(int),
> > > +		.mode		= 0200,
> > > +		.proc_handler	= sysctl_compaction_handler,
> > > +	},
> > > +#endif /* CONFIG_COMPACTION */
> > >  	{
> > >  		.procname	= "min_free_kbytes",
> > >  		.data		= &min_free_kbytes,
> > > diff --git a/mm/compaction.c b/mm/compaction.c
> > > index 14ba0ac..22f223f 100644
> > > --- a/mm/compaction.c
> > > +++ b/mm/compaction.c
> > > @@ -11,6 +11,7 @@
> > >  #include <linux/migrate.h>
> > >  #include <linux/compaction.h>
> > >  #include <linux/mm_inline.h>
> > > +#include <linux/sysctl.h>
> > >  #include "internal.h"
> > >  
> > >  /*
> > > @@ -345,3 +346,62 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
> > >  	return ret;
> > >  }
> > >  
> > > +/* Compact all zones within a node */
> > > +static int compact_node(int nid)
> > > +{
> > > +	int zoneid;
> > > +	pg_data_t *pgdat;
> > > +	struct zone *zone;
> > > +
> > > +	if (nid < 0 || nid > nr_node_ids || !node_online(nid))
> > > +		return -EINVAL;
> > > +	pgdat = NODE_DATA(nid);
> > > +
> > > +	/* Flush pending updates to the LRU lists */
> > > +	lru_add_drain_all();
> > > +
> > > +	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
> > > +		struct compact_control cc;
> > > +
> > > +		zone = &pgdat->node_zones[zoneid];
> > > +		if (!populated_zone(zone))
> > > +			continue;
> > > +
> > > +		cc.nr_freepages = 0;
> > > +		cc.nr_migratepages = 0;
> > > +		cc.zone = zone;
> > > +		INIT_LIST_HEAD(&cc.freepages);
> > > +		INIT_LIST_HEAD(&cc.migratepages);
> > > +
> > > +		compact_zone(zone, &cc);
> > > +
> > > +		VM_BUG_ON(!list_empty(&cc.freepages));
> > > +		VM_BUG_ON(!list_empty(&cc.migratepages));
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Compact all nodes in the system */
> > > +static int compact_nodes(void)
> > > +{
> > > +	int nid;
> > > +
> > > +	for_each_online_node(nid)
> > > +		compact_node(nid);
> > > +
> > > +	return COMPACT_COMPLETE;
> > > +}
> > > +
> > > +/* The written value is actually unused, all memory is compacted */
> > > +int sysctl_compact_memory;
> > > +
> > > +/* This is the entry point for compacting all nodes via /proc/sys/vm */
> > > +int sysctl_compaction_handler(struct ctl_table *table, int write,
> > > +			void __user *buffer, size_t *length, loff_t *ppos)
> > > +{
> > > +	if (write)
> > > +		return compact_nodes();
> > > +
> > > +	return 0;
> > > +}
> > > -- 
> > > 1.6.5
> > > 
> > > --
> > > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > > the body to majordomo@kvack.org.  For more info on Linux MM,
> > > see: http://www.linux-mm.org/ .
> > > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > > 
> > 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> 

