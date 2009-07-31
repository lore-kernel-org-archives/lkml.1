Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZGaNTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZGaNTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZGaNTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:19:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZGaNTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:19:39 -0400
Date: Fri, 31 Jul 2009 09:18:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use of flat
	elevator fair queuing
Message-ID: <20090731131813.GB3668@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-6-git-send-email-vgoyal@redhat.com> <4A713E10.2030204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A713E10.2030204@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:30:40PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  /*
> >   * Check if new_cfqq should preempt the currently active queue. Return 0 for
> > - * no or if we aren't sure, a 1 will cause a preempt.
> > + * no or if we aren't sure, a 1 will cause a preemption attempt.
> > + * Some of the preemption logic has been moved to common layer. Only cfq
> > + * specific parts are left here.
> >   */
> >  static int
> > -cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> > -		   struct request *rq)
> > +cfq_should_preempt(struct request_queue *q, void *new_cfqq, struct request *rq)
> >  {
> > -	struct cfq_queue *cfqq;
> > +	struct cfq_data *cfqd = q->elevator->elevator_data;
> > +	struct cfq_queue *cfqq = elv_active_sched_queue(q->elevator);
> >  
> > -	cfqq = cfqd->active_queue;
> >  	if (!cfqq)
> >  		return 0;
> >  
> > -	if (cfq_slice_used(cfqq))
> > +	if (elv_ioq_slice_used(cfqq->ioq))
> >  		return 1;
> >  
> >  	if (cfq_class_idle(new_cfqq))
> > @@ -2018,13 +1661,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> >  	if (rq_is_meta(rq) && !cfqq->meta_pending)
> >  		return 1;
> >  
> > -	/*
> > -	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> > -	 */
> > -	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> > -		return 1;
> > -
> > -	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> > +	if (!cfqd->active_cic || !elv_ioq_wait_request(cfqq->ioq))
> >  		return 0;
> >  
> >  	/*
> 
> Hi Vivek,
> 
> cfq_should_preempt() will do the check "if (cfq_rq_close(cfqd, rq)) to see whether
> it should preempt the current cfqq. From fairness point of view,  should we also 
> check "fairness" value, if it's set fairness == 1, don't allow to preempt the current
> cfqq?

Hi Gui,

In V7, fairness=1 means that we try to dispatch request only from one
queue at a time and wait for requests to finish from that queue before
next queue is scheduled in. This helps in better disk time accounting for the
queue.

But currently this is not true for preemption path. So if we decide to
preempt the current queue (either by elevator layer or by cfq), we expire
the queue immediately and bring in the new one. So this is just not
cfq_rq_close() but the whole preemption path.

Currently I will leave it as it is but if we run into significant issues, 
then we can fix it. It will require extra logic of keeping track that
current queue has been preempted. Also keep track who preempted etc and
as soon as last request from queue completes, expire it.

Thanks
Vivek
