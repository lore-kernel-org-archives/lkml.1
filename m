Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYKSPs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYKSPs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYKSPsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:48:51 -0500
Received: from ms01.sssup.it ([193.205.80.99]:48311 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbYKSPsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:48:50 -0500
Date: Wed, 19 Nov 2008 16:52:11 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Divyesh Shah <dpshah@google.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081119155211.GE20915@gandalf.sssup.it>
References: <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <20081118211442.GG15268@gandalf.sssup.it> <20081119143006.GI26308@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119143006.GI26308@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, Nov 19, 2008 03:30:07PM +0100
>
> On Tue, Nov 18 2008, Fabio Checconi wrote:
...
> >   - In cfq_exit_single_io_context() and in changed_ioprio(), cic->key
> >     is dereferenced without holding any lock.  As I reported in [1]
> >     this seems to be a problem when an exit() races with a cfq_exit_queue()
> >     and in a few other cases.  In BFQ we used a somehow involved
> >     mechanism to avoid that, abusing rcu (of course we'll have to wait
> >     the patch to talk about it :) ), but given my lack of understanding
> >     of some parts of the block layer, I'd be interested in knowing if
> >     the race is possible and/or if there is something more involved
> >     going on that can cause the same effects.
> 
> OK, I'm assuming this is where Nikanth got his idea for the patch from?

I think so.


> It does seem racy in spots, we can definitely proceed on getting that
> tightened up some more.
> 
> >   - set_task_ioprio() in fs/ioprio.c doesn't seem to have a write
> >     memory barrier to pair with the dependent read one in
> >     cfq_get_io_context().
> 
> Agree, that needs fixing.
> 
> >   - CFQ_MIN_TT is 2ms, this can result, depending on the value of
> >     HZ in timeouts of one jiffy, that may expire too early, so we are
> >     just wasting time and do not actually wait for the task to present
> >     its new request.  Dealing with seeky traffic we've seen a lot of
> >     early timeouts due to one jiffy timers expiring too early, is
> >     it worth fixing or can we live with that?
> 
> We probably just need to enfore a '2 jiffies minimum' rule for that.
> 
> >   - To detect hw tagging in BFQ we consider a sample valid iff the
> >     number of requests that the scheduler could have dispatched (given
> >     by cfqd->rb_queued + cfqd->rq_in_driver, i.e., the ones still into
> >     the scheduler plus the ones into the driver) is higher than the
> >     CFQ_HW_QUEUE_MIN threshold.  This obviously caused no problems
> >     during testing, but the way CFQ uses now seems a little bit
> >     strange.
> 
> Not sure this matters a whole lot, but your approach makes sense. Have
> you seen the later change to the CFQ logic from Aaron?
> 

Yes, we started from his code.  As Aaron reported, on BFQ our change
to the CIC_SEEKY logic has a bad interaction with the hw tag detection
on some workloads, but that problem should be easy to solve (test patch
posted in http://lkml.org/lkml/2008/11/19/100).


> >   - Initially, cic->last_request_pos is zero, so the sdist charged
> >     to a task for its first seek depends on the position on the disk
> >     that is accessed first, independently from its seekiness.  Even
> >     if there is a cap on that value, we choose to not charge the first
> >     seek to processes; that resulted in less wrong predictions for
> >     purely sequential loads.
> 
> Agreed, that's is definitely off.
> 
> >   - From my understanding, with shared I/O contexts, two different
> >     tasks may concurrently lookup for a cfqd into the same ioc.
> >     This may result in cfq_drop_dead_cic() being called two times
> >     for the same cic.  Am I missing something that prevents that from
> >     happening?
> 
> That also looks problematic. I guess we need to recheck that under the
> lock when in cfq_drop_dead_cic().
> 
> > Regarding the code splitup, do you think you'll go for the CFS(BFQ) way,
> > using a single compilation unit and including the .c files, or a layout
> > with different compilation units (like the ll_rw_blk.c splitup)?
> 
> Different compilation units would be my preferred choice.
> 

Ok, thank you, I'll try to put together and test some patches, and to
post them for discussion in the next few days.
