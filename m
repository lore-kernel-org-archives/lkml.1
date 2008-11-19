Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYKSLDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYKSLDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 06:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYKSLDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 06:03:38 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43648 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbYKSLDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 06:03:38 -0500
Date: Wed, 19 Nov 2008 12:06:55 +0100
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
Message-ID: <20081119110655.GC20915@gandalf.sssup.it>
References: <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <20081118211442.GG15268@gandalf.sssup.it> <4923716A.5090104@gelato.unsw.edu.au> <20081119101701.GA20915@gandalf.sssup.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119101701.GA20915@gandalf.sssup.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Fabio Checconi <fchecconi@gmail.com>
> Date: Wed, Nov 19, 2008 11:17:01AM +0100
>
> > From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
> > Date: Wed, Nov 19, 2008 12:52:42PM +1100
> >
> > Fabio Checconi wrote:
> > >   - To detect hw tagging in BFQ we consider a sample valid iff the
> > >     number of requests that the scheduler could have dispatched (given
> > >     by cfqd->rb_queued + cfqd->rq_in_driver, i.e., the ones still into
> > >     the scheduler plus the ones into the driver) is higher than the
> > >     CFQ_HW_QUEUE_MIN threshold.  This obviously caused no problems
> > >     during testing, but the way CFQ uses now seems a little bit
> > >     strange.
> > 
> > BFQ's tag detection logic is broken in the same way that CFQ's used to
> > be.  Explanation is in this patch:
> > 
> 
> If you look at bfq_update_hw_tag(), the logic introduced by the patch
> you mention is still there; BFQ starts with ->hw_tag = 1, and updates it
> every 32 valid samples.  What changed WRT your patch, apart from the
> number of samples, is that the condition for a sample to be valid is:
> 
>   bfqd->rq_in_driver + bfqd->queued >= 5
> 
> while in your patch it is:
> 
>   cfqd->rq_queued > 5 || cfqd->rq_in_driver > 5
> 
> We preferred the first one because that sum better reflects the number
> of requests that could have been dispatched, and I don't think that this
> is wrong.
> 
> There is a problem, but it's not within the tag detection logic itself.
> From some quick experiments, what happens is that when a process starts,
> CFQ considers it seeky (*), BFQ doesn't.  As a side effect BFQ does not
> always dispatch enough requests to correctly detect tagging.
> 
> At the first seek you cannot tell if the process is going to bee seeky
> or not, and we have chosen to consider it sequential because it improved
> fairness in some sequential workloads (the CIC_SEEKY heuristic is used
> also to determine the idle_window length in [bc]fq_arm_slice_timer()).
> 
> Anyway, we're dealing with heuristics, and they tend to favor some
> workload over other ones.  If recovering this thoughput loss is more
> important than a transient unfairness due to short idling windows assigned
> to sequential processes when they start, I've no problems in switching
> the CIC_SEEKY logic to consider a process seeky when it starts.
> 
> Thank you for testing and for pointing out this issue, we missed it
> in our testing.
> 
> 
> (*) to be correct, the initial classification depends on the position
>     of the first accessed sector.

Sorry, I forgot the patch...  This seems to solve the problem with
your workload here, does it work for you?

[ The magic number would not appear in a definitive fix... ]


---
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 83e90e9..e9b010f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1322,10 +1322,12 @@ static void bfq_update_io_seektime(struct bfq_data *bfqd,
 
 	/*
 	 * Don't allow the seek distance to get too large from the
-	 * odd fragment, pagein, etc.
+	 * odd fragment, pagein, etc.  The first request is not
+	 * really a seek, but we consider a cic seeky on creation
+	 * to make the hw_tag detection logic work better.
 	 */
-	if (cic->seek_samples == 0) /* first request, not really a seek */
-		sdist = 0;
+	if (cic->seek_samples == 0)
+		sdist = 8 * 1024 + 1;
 	else if (cic->seek_samples <= 60) /* second&third seek */
 		sdist = min(sdist, (cic->seek_mean * 4) + 2*1024*1024);
 	else
