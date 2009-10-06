Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbZJFVjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbZJFVjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbZJFVjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260AbZJFVjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:39:02 -0400
Date: Tue, 6 Oct 2009 17:36:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO scheduler
	based IO controller V10)
Message-ID: <20091006213640.GC30131@redhat.com>
References: <20091002154020.GC4494@redhat.com> <12774.1254502217@turing-police.cc.vt.edu> <20091002195815.GE4494@redhat.com> <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com> <20091002222756.GG4494@redhat.com> <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com> <20091003133810.GC12925@redhat.com> <4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com> <20091004121122.GB18778@redhat.com> <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 02:46:44PM +0200, Corrado Zoccolo wrote:
> Hi Vivek,
> On Sun, Oct 4, 2009 at 2:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Sun, Oct 04, 2009 at 11:15:24AM +0200, Corrado Zoccolo wrote:
> >> Hi Vivek,
> >> My guess is that the formula that is used to handle this case is not
> >> very stable.
> >
> > In general I agree that formula to calculate the slice offset is very
> > puzzling as busy_queues varies and that changes the position of the task
> > sometimes.
> >
> > I am not sure what's the intent here by removing busy_queues stuff. I have
> > got two questions though.
> 
> In the ideal case steady state, busy_queues will be a constant. Since
> we are just comparing the values between themselves, we can just
> remove this constant completely.
> 
> Whenever it is not constant, it seems to me that it can cause wrong
> behaviour, i.e. when the number of processes with ready I/O reduces, a
> later coming request can jump before older requests.
> So it seems it does more harm than good, hence I suggest to remove it.
> 

I agree here. busy_queues can vary, especially given the fact that CFQ
removes the queue from service tree immediately after the dispatch, if the
queue is empty, and then it waits for request completion from the queue
and idles on the queue.

So consider following scenration where two thinking readers and one writer
are executing. Readers preempt the writers and writers gets back into the
tree. When writer gets backlogged, at that point of time busy_queues=2 
and when a readers gets backlogged, busy_queues=1 (most of the time,
because a reader is idling), and hence many a time readers gets placed ahead
of writer.

This is so subtle, that I am not sure it was the designed that way.

So dependence on busy_queues can change queue ordering in unpredicatable
ways.


> Moreover, I suggest removing also the slice_resid part, since its
> semantics doesn't seem consistent.
> When computed, it is not the residency, but the remaining time slice.
> Then it is used to postpone, instead of anticipate, the position of
> the queue in the RR, that seems counterintuitive (it would be
> intuitive, though, if it was actually a residency, not a remaining
> slice, i.e. you already got your full share, so you can wait longer to
> be serviced again).
> 
> >
> > - Why don't we keep it simple round robin where a task is simply placed at
> >  the end of service tree.
> 
> This should work for the idling case, since we provide service
> differentiation by means of time slice.
> For non-idling case, though, the appropriate placement of queues in
> the tree (as given by my formula) can still provide it.
> 

So for non-idling case, instead of providing service differentiation by 
number of times queue is scheduled to run then by providing a bigger slice
to the queue?

This will work only to an extent and depends on size of IO being
dispatched from each queue. If some queue is having bigger requests size
and some smaller size (can be easily driven by changing block size), then
again you will not see fairness numbers? In that case it might make sense
to provide fairness in terms of size of IO/number of IO. 

So to me it boils down to what is the seek cose of the underlying media.
If seek cost is high, provide fairness in terms of time slice and if seek
cost is really low, one can afford to faster switching of queues without
loosing too much on throughput side and in that case fairness in terms of
size of IO should be good.

Now if on good SSDs with NCQ, seek cost is low, I am wondering if it will
make sense to tweak CFQ to change mode dynamically and start providing
fairness in terms of size of IO/number of IO?

> >
> > - Secondly, CFQ provides full slice length to queues only which are
> >  idling (in case of sequenatial reader). If we do not enable idling, as
> >  in case of NCQ enabled SSDs, then CFQ will expire the queue almost
> >  immediately and put the queue at the end of service tree (almost).
> >
> > So if we don't enable idling, at max we can provide fairness, we
> > esseitially just let every queue dispatch one request and put  at the end
> > of the end of service tree. Hence no fairness....
> 
> We should distinguish the two terms fairness and service
> differentiation. Fairness is when every queue gets the same amount of
> service share.

Will it not be "proportionate amount of service share" instead of "same
amount of service share"

> This is not what we want when priorities are different
> (we want the service differentiation, instead), but is what we get if
> we do just round robin without idling.
> 
> To fix this, we can alter the placement in the tree, so that if we
> have Q1 with slice S1, and Q2 with slice S2, always ready to perform
> I/O, we get that Q1 is in front of the three with probability
> S1/(S1+S2), and Q2 is in front with probability S2/(S1+S2).
> This is what my formula should achieve.

I have yet to get into details but as I said, this sounds like fairness 
by frequency or by number of times a queue is scheduled to dispatch. So it
will help up to some extent on NCQ enabled SSDs but will become unfair is
size of IO each queue dispatches is very different.

Thanks
Vivek
