Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZKDT2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZKDT2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZKDT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbZKDT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:28:02 -0500
Date: Wed, 4 Nov 2009 14:27:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 15/20] blkio: Take care of preemptions across groups
Message-ID: <20091104192725.GM2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-16-git-send-email-vgoyal@redhat.com> <x49d43yt8ry.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d43yt8ry.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:00:33PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > +static bool cfq_should_preempt_group(struct cfq_data *cfqd,
> > +		struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
> > +{
> > +	struct cfq_entity *cfqe = &cfqq->entity;
> > +	struct cfq_entity *new_cfqe = &new_cfqq->entity;
> > +
> > +	if (cfqq_to_cfqg(cfqq) != &cfqd->root_group)
> > +		cfqe = parent_entity(&cfqq->entity);
> > +
> > +	if (cfqq_to_cfqg(new_cfqq) != &cfqd->root_group)
> > +		new_cfqe = parent_entity(&new_cfqq->entity);
> > +
> > +	/*
> > +	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> > +	 */
> > +
> > +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_RT
> > +	    && cfqe->ioprio_class != IOPRIO_CLASS_RT)
> > +		return true;
> > +	/*
> > +	 * Allow an BE request to pre-empt an ongoing IDLE clas timeslice.
> > +	 */
> > +
> > +	if (new_cfqe->ioprio_class == IOPRIO_CLASS_BE
> > +	    && cfqe->ioprio_class == IOPRIO_CLASS_IDLE)
> > +		return true;
> > +
> > +	return false;
> > +}
> 
> What was the motivation for this?  It seems like this would really break
> isolation.  What if one group has all RT priority tasks, will it starve
> out the other groups?
> 

It will not as we traverse up the hierarchy and look for the ioprio class
of the group entity.

So if you got following configuration where G1 and G2 are two groups. G1
is prio class RT and G2 is prio class BE, then any queue in G1 will
preempt any queue in G2 as at highest level, G1 and G2 are different class
altogether.

			root
			/  \
		       G1  G2

Normal cfqq preemption checks will not catch this. So if G2 has some BE
cfqq running, and some BE queue gets backlogged in G1, this new queue wil
not preempt the queue in G2 and it should have.

That's why preemption checks at group level.

Secondly if G1 and G2 are of ioprioclass BE and all the jobs in G1 are of
RT nature, they will not preempt the queues in G2, hence providing
isolation.

Thanks
Vivek
