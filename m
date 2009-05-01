Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbZEACtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbZEACtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZEACtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:49:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZEACtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:49:41 -0400
Date: Thu, 30 Apr 2009 22:45:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: nauman@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
Message-ID: <20090501024527.GA3730@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49FA4F91.204@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FA4F91.204@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 06:25:37PM -0700, Divyesh Shah wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is another posting for IO controller patches. Last time I had posted
> > RFC patches for an IO controller which did bio control per cgroup.
> > 
> > http://lkml.org/lkml/2008/11/6/227
> > 
> > One of the takeaway from the discussion in this thread was that let us
> > implement a common layer which contains the proportional weight scheduling
> > code which can be shared by all the IO schedulers.
> > 
> > Implementing IO controller will not cover the devices which don't use
> > IO schedulers but it should cover the common case.
> > 
> > There were more discussions regarding 2 level vs 1 level IO control at
> > following link.
> > 
> > https://lists.linux-foundation.org/pipermail/containers/2009-January/015402.html
> > 
> > So in the mean time we took the discussion off the list and spent time on
> > making the 1 level control apporoach work where majority of the proportional
> > weight control is shared by the four schedulers instead of each one having
> > to replicate the code. We make use of BFQ code for fair queuing as posted
> > by Paolo and Fabio here.
> > 
> > http://lkml.org/lkml/2008/11/11/148
> > 
> > Details about design and howto have been put in documentation patch.
> > 
> > I have done very basic testing of running 2 or 3 "dd" threads in different
> > cgroups. Wanted to get the patchset out for feedback/review before we dive
> > into more bug fixing, benchmarking, optimizations etc.
> > 
> > Your feedback/comments are welcome.
> > 
> > Patch series contains 10 patches. It should be compilable and bootable after
> > every patch. Intial 2 patches implement flat fair queuing (no cgroup
> > support) and make cfq to use that. Later patches introduce hierarchical
> > fair queuing support in elevator layer and modify other IO schdulers to use
> > that.
> > 
> > Thanks
> > Vivek
> 
> Hi Vivek,
>    While testing these patches along with the bio-cgroup patches I noticed that for the case of 2 buffered writers (dd) with different weights, one of them would be able to use up a very large timeslice (I've seen upto 500ms) when the other queue is empty and not be accounted for it. This is due to the check in cfq_dispatch_requests() where  a given cgroup can empty its entire queue (100 IOs or more) within its timeslice and have them sit in the dispatch queue ready for the disk driver to pick up. Moreover, this huge timeslice is not accounted for as this cgroup is charged only for the length of the intended timeslice and not the actual time taken.
>   The following patch fixes this by not optimizing on the single busy queue fact inside cfq_dispatch_requests. Note that this does not hurt throughput in any sense but just causes more IOs to be dispatched only when the drive is ready for them thus leading to better accounting too.

Hi Divyesh,

Thanks for the testing and noticing the issue. I also had noticed this
issue.

Couple of points.

- In 30-rc3 jens has fixed the huge dispatch problem. Now in case of single
  ioq doing dispatch, in one round upto 4*quantum request can be dispatched.
  So that means in default configuration with single queue, maximum request on
  diaptch list can be 16.

- Secondly, in my tree, now I have modified the patches to charge for
  actual consumption of the slice instead of capping it to budget. In a
  week's time I should be able to post V2 of the patches. Please do try
  it out then

Thanks
Vivek

> 
> Fix bug where a given ioq can run through all its requests at once.
> 
> Signed-off-by: Divyesh Shah <dpshah@google.com>
> ---
> diff --git a/2.6.26/block/cfq-iosched.c b/2.6.26/block/cfq-iosched.c
> index 5a275a2..c0199a6 100644
> --- a/2.6.26/block/cfq-iosched.c
> +++ b/2.6.26/block/cfq-iosched.c
> @@ -848,8 +848,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
> 		if (cfq_class_idle(cfqq))
> 			max_dispatch = 1;
> 
> -		if (elv_ioq_nr_dispatched(cfqq->ioq) >= max_dispatch &&
> -			elv_nr_busy_ioq(q->elevator) > 1)
> +		if (elv_ioq_nr_dispatched(cfqq->ioq) >= max_dispatch)
> 			break;
> 
> 		if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
