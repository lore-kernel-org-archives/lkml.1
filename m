Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbZDOEK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbZDOEK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZDOEKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:10:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34162 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZDOEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:10:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: meminfo Committed_AS underflows
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Mel Gorman <mel@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090415033455.GS7082@balbir.in.ibm.com>
References: <20090415105033.AC29.A69D9226@jp.fujitsu.com> <20090415033455.GS7082@balbir.in.ibm.com>
Message-Id: <20090415130042.AC3D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 13:10:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-04-15 11:04:59]:
> 
> >  	committed = atomic_long_read(&vm_committed_space);
> > +	if (committed < 0)
> > +		committed = 0;
> 
> Isn't this like pushing the problem under the rug?

global_page_state() already has same logic.
IOW almost meminfo filed has this one (except Commited_AS).


> >  	allowed = ((totalram_pages - hugetlb_total_pages())
> >  		* sysctl_overcommit_ratio / 100) + total_swap_pages;
> > 
> > Index: b/mm/swap.c
> > ===================================================================
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -519,7 +519,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
> >   * We tolerate a little inaccuracy to avoid ping-ponging the counter between
> >   * CPUs
> >   */
> > -#define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
> > +#define ACCT_THRESHOLD	max_t(long, 16, num_online_cpus() * 2)
> >
> 
> Hmm.. this is a one time expansion, free of CPU hotplug.
> 
> Should we use nr_cpu_ids or num_possible_cpus()?

#define num_online_cpus()       cpumask_weight(cpu_online_mask)
#define num_possible_cpus()     cpumask_weight(cpu_possible_mask)

num_possible_cpus() have the same calculation cost.
nr_cpu_ids isn't proper value.
it point to valid cpu-id range, no related number of online nor possible cpus.




