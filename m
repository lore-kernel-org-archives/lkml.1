Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYKTGxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYKTGxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYKTGxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:53:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55312 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbYKTGxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:53:09 -0500
Date: Thu, 20 Nov 2008 07:56:32 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Nauman Rafique <nauman@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Divyesh Shah <dpshah@google.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081120065632.GB23647@gandalf.sssup.it>
References: <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <20081118211442.GG15268@gandalf.sssup.it> <4923716A.5090104@gelato.unsw.edu.au> <20081119101701.GA20915@gandalf.sssup.it> <20081119110655.GC20915@gandalf.sssup.it> <4924EB4E.7050600@gelato.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4924EB4E.7050600@gelato.unsw.edu.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
> Date: Thu, Nov 20, 2008 03:45:02PM +1100
>
> Fabio Checconi wrote:
> >>> Fabio Checconi wrote:
> >>>>   - To detect hw tagging in BFQ we consider a sample valid iff the
> >>>>     number of requests that the scheduler could have dispatched (given
> >>>>     by cfqd->rb_queued + cfqd->rq_in_driver, i.e., the ones still into
> >>>>     the scheduler plus the ones into the driver) is higher than the
> >>>>     CFQ_HW_QUEUE_MIN threshold.  This obviously caused no problems
> >>>>     during testing, but the way CFQ uses now seems a little bit
> >>>>     strange.
> >>> BFQ's tag detection logic is broken in the same way that CFQ's used to
> >>> be.  Explanation is in this patch:
> >>>
> >> If you look at bfq_update_hw_tag(), the logic introduced by the patch
> >> you mention is still there; BFQ starts with ->hw_tag = 1, and updates it
> 
> Yes, I missed that.  So which part of CFQ's hw_tag detection is strange?
> 

I just think that is rather counterintuitive to consider invalid
a sample when you have, say, rq_in_driver = 1,2,3 or 4 and other
4 queued requests.  Considering the actual number of requests that
could have been dispatched seemed more straightforward than
considering the two values separately.

Anyway I think the validity of the samples is a minor issue, while the
throughput loss you experienced was a more serious one.


> >> every 32 valid samples.  What changed WRT your patch, apart from the
> >> number of samples, is that the condition for a sample to be valid is:
> >>
> >>   bfqd->rq_in_driver + bfqd->queued >= 5
> >>
> >> while in your patch it is:
> >>
> >>   cfqd->rq_queued > 5 || cfqd->rq_in_driver > 5
> >>
> >> We preferred the first one because that sum better reflects the number
> >> of requests that could have been dispatched, and I don't think that this
> >> is wrong.
> 
> I think it's fine too.  CFQ's condition accounts for a few rare situations,
> such as the device stalling or hw_tag being updated right after a bunch of
> requests are queued.  They are probably irrelevant, but can't hurt.
> 
> >> There is a problem, but it's not within the tag detection logic itself.
> >> From some quick experiments, what happens is that when a process starts,
> >> CFQ considers it seeky (*), BFQ doesn't.  As a side effect BFQ does not
> >> always dispatch enough requests to correctly detect tagging.
> >>
> >> At the first seek you cannot tell if the process is going to bee seeky
> >> or not, and we have chosen to consider it sequential because it improved
> >> fairness in some sequential workloads (the CIC_SEEKY heuristic is used
> >> also to determine the idle_window length in [bc]fq_arm_slice_timer()).
> >>
> >> Anyway, we're dealing with heuristics, and they tend to favor some
> >> workload over other ones.  If recovering this thoughput loss is more
> >> important than a transient unfairness due to short idling windows assigned
> >> to sequential processes when they start, I've no problems in switching
> >> the CIC_SEEKY logic to consider a process seeky when it starts.
> >>
> >> Thank you for testing and for pointing out this issue, we missed it
> >> in our testing.
> >>
> >>
> >> (*) to be correct, the initial classification depends on the position
> >>     of the first accessed sector.
> > 
> > Sorry, I forgot the patch...  This seems to solve the problem with
> > your workload here, does it work for you?
> 
> Yes, it works fine now :)
> 

Thank you very much for trying it.


> However, hw_tag detection (in CFQ and BFQ) is still broken in a few ways:
>   * If you go from queue_depth=1 to queue_depth=large, it's possible that
>     the detection logic fails.  This could happen if setting queue_depth
>     to a larger value at boot, which seems a reasonable situation.

I think that the transition of hw_tag from 1 to 0 can be quite easy, and
may depend only on the workload, while getting back to 1 is more difficult,
because when hw_tag is 0 there may be too few dispatches to detect queueing...


>   * It depends too much on the hardware.  If you have a seekly load on a
>     fast disk with a unit queue depth, idling sucks for performance (I
>     imagine this is particularly bad on SSDs).  If you have any disk with
>     a deep queue, not idling sucks for fairness.

Agreed.  This fairness vs. throughput conflict is very workload
dependent too.


> I suppose CFQ's slice_resid is supposed to help here, but as far as I can
> tell, it doesn't do a thing.
> 
