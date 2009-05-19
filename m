Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZESCxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZESCxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 22:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZESCxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 22:53:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZESCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 22:53:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
In-Reply-To: <20090518034907.GF5869@localhost>
References: <20090513120729.5885.A69D9226@jp.fujitsu.com> <20090518034907.GF5869@localhost>
Message-Id: <20090519102634.4EB4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 11:53:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 13, 2009 at 12:08:12PM +0900, KOSAKI Motohiro wrote:
> > Subject: [PATCH] zone_reclaim_mode is always 0 by default
> > 
> > Current linux policy is, if the machine has large remote node distance,
> >  zone_reclaim_mode is enabled by default because we've be able to assume to 
> > large distance mean large server until recently.
> > 
> > Unfrotunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
> > memory controller. IOW it's NUMA from software view.
> > 
> > Some Core i7 machine has large remote node distance and zone_reclaim don't
> > fit desktop and small file server. it cause performance degression.
> 
> I can confirm this, Yanmin recently ran into exactly such a
> regression, which was fixed by manually disabling the zone reclaim
> mode. So I guess you can safely add an
> 
> Tested-by: "Zhang, Yanmin" <yanmin.zhang@intel.com>
> 
> > Thus, zone_reclaim == 0 is better by default. sorry, HPC gusy. 
> > you need to turn zone_reclaim_mode on manually now.
>  
> I guess the borderline will continue to blur up. It will be more
> dependent on workloads instead of physical NUMA capabilities. So
> 
> Acked-by: Wu Fengguang <fengguang.wu@intel.com> 

ok, I would explain zone reclaim design and performance tendency.

Firstly, we can make classification of linux eco system, roughly.
 - HPC
 - high-end server
 - volume server
 - desktop
 - embedded

it is separated by typical workload mainly.

Secondly, zone_reclaim mean "I strongly dislike remote node access than
disk access".
it is very fitting on HPC workload. it because 
  - HPC workload typically make the number of the same as cpus of processess (or thread).
    IOW, the workload typically use memory equally each node.
  - HPC workload is typically CPU bounded job. CPU migration is rare.
  - HPC workload is typically long lived. (possible >1 year)
    IOW, remote node allocation makes _very_ _very_ much remote node access.

but zone_reclaim don't fit typical server workload.
  - server workload often make thread pool and some thread is sleeping until
    a request receved.
    IOW, when thread waking-up, the thread might move another cpu. 
    node distance tendency don't make sense on weak cpu locality workload.

Plus, disk-cache is the file-server's identity. we shouldn't think it's not important.
Plus, DB software can consume almost system memory and (In general) RDB data makes
harder to split equally as hpc.

desktop workload is special. desktop peopole can run various workload beyond
our assumption. So, we shouldn't have any workload assumption to desktop people.
However, AFAIK almost desktop software use memory as UMA.

we don't need to care embedded. it is typically UMA.


IOW, the benefit of zone reclaim depend on "strong cpu locality" and
"workload is cpu bounded" and "thead is long lived".
but many workload don't fill above requirement. IOW, zone reclaim is
workload depended feature (as Wu said).


In general, the feature of workload depended don't fit default option.
we can't know end-user run what workload anyway.

Fortunately (or Unfortunately), typical workload and machine size had
significant mutuality.
Thus, the current default setting calculation had worked well in past days.

Now, it was breaked. What should we do?



Yanmin, We know 99% linux people use intel cpu and you are one of
most hard repeated testing guy in lkml and you have much test.
May I ask your tested machine and benchmark? 

if zone_reclaim=0 tendency workload is much than zone_reclaim=1 tendency workload,
 we can drop our afraid and we would prioritize your opinion, of cource.

thanks.


