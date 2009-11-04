Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZKDQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZKDQiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbZKDQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:38:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZKDQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:38:13 -0500
Date: Wed, 4 Nov 2009 11:37:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091104163752.GB2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <x49d43yuzud.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d43yuzud.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 09:30:34AM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 

Thanks for the review Jeff.

> > o Currently CFQ provides priority scaled time slices to processes. If a process
> >   does not use the time slice, either because process did not have sufficient
> >   IO to do or because think time of process is large and CFQ decided to disable
> >   idling, then processes looses it time slice share.
>                            ^^^^^^
> loses
> 

Will fix it.

> > o One possible way to handle this is implement CFS like time stamping of the
> >   cfq queues and keep track of vtime. Next queue for execution will be selected
> >   based on the one who got lowest vtime. This patch implemented time stamping
> >   mechanism of cfq queues based on disk time used.
> >
> > o min_vdisktime represents the minimum vdisktime of the queue, either being
>                                                           ^^^^^
> >   serviced or leftmost element on the serviec tree.
> 
> queue or service tree?  The latter seems to make more sense to me.

Yes, it should be service tree. Will fix it.

> 
> > +static inline u64
> > +cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
> > +{
> > +	const int base_slice = cfqq->cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
> > +
> > +	return delta + (base_slice/CFQ_SLICE_SCALE * (cfqq->ioprio - 4));
> > +}
> 
> cfq_scale_delta might be a better name.
> 

cfq_scale_delta sounds good. Will use it in next version.

> 
> > +static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
> > +{
> > +	s64 delta = (s64)(vdisktime - min_vdisktime);
> > +	if (delta > 0)
> > +		min_vdisktime = vdisktime;
> > +
> > +	return min_vdisktime;
> > +}
> > +
> > +static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
> > +{
> > +	s64 delta = (s64)(vdisktime - min_vdisktime);
> > +	if (delta < 0)
> > +		min_vdisktime = vdisktime;
> > +
> > +	return min_vdisktime;
> > +}
> 
> Is there a reason you've reimplemented min and max?

I think you are referring to min_t and max_t. Will these macros take care
of wrapping too?

For example, if I used min_t(u64, A, B), then unsigned comparision will
not work right wrapping has just taken place for any of the A or B. So if
A=-1 and B=2, then min_t() would return B as minimum. This is not right
in our case.

If we do signed comparison (min_t(s64, A, B)), that also seems to be
broken in another case where a value of variable moves from 63bits to 64bits,
(A=0x7fffffffffffffff, B=0x8000000000000000). Above will return B as minimum but
in our scanario, vdisktime will progress from 0x7fffffffffffffff to
0x8000000000000000 and A should be returned as minimum (unsigned
comparison).

Hence I took these difnitions from CFS.

> 
> > +	/*
> > +	 * Maintain a cache of leftmost tree entries (it is frequently
> > +	 * used)
> > +	 */
> 
> You make it sound like there is a cache of more than one entry.  Please
> fix the comment.

Will fix it.

> 
> > +static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
> > +{
> > +	/*
> > +	 * We don't want to charge more than allocated slice otherwise this
> > +	 * queue can miss one dispatch round doubling max latencies. On the
> > +	 * other hand we don't want to charge less than allocated slice as
> > +	 * we stick to CFQ theme of queue loosing its share if it does not
>                                           ^^^^^^^
> losing
> 

Will fix it.

> 
> > +/*
> > + * Handles three operations.
> > + * Addition of a new queue to service tree, when a new request comes in.
> > + * Resorting of an expiring queue (used after slice expired)
> > + * Requeuing a queue at the front (used during preemption).
> > + */
> > +static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> > +				bool add_front, unsigned long service)
> 
> service?  Can we come up with a better name that actually hints at what
> this is?  service_time, maybe?

Ok, service_time sounds good. Will change it.

> 
> 
> Mostly this looks pretty good and is fairly easy to read.

Thanks
Vivek
