Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZKDOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZKDOba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZKDOb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233AbZKDOb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:31:28 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-3-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 09:30:34 -0500
In-Reply-To: <1257291837-6246-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:39 -0500")
Message-ID: <x49d43yuzud.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o Currently CFQ provides priority scaled time slices to processes. If a process
>   does not use the time slice, either because process did not have sufficient
>   IO to do or because think time of process is large and CFQ decided to disable
>   idling, then processes looses it time slice share.
                           ^^^^^^
loses

> o One possible way to handle this is implement CFS like time stamping of the
>   cfq queues and keep track of vtime. Next queue for execution will be selected
>   based on the one who got lowest vtime. This patch implemented time stamping
>   mechanism of cfq queues based on disk time used.
>
> o min_vdisktime represents the minimum vdisktime of the queue, either being
                                                          ^^^^^
>   serviced or leftmost element on the serviec tree.

queue or service tree?  The latter seems to make more sense to me.

> +static inline u64
> +cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
> +{
> +	const int base_slice = cfqq->cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
> +
> +	return delta + (base_slice/CFQ_SLICE_SCALE * (cfqq->ioprio - 4));
> +}

cfq_scale_delta might be a better name.


> +static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
> +{
> +	s64 delta = (s64)(vdisktime - min_vdisktime);
> +	if (delta > 0)
> +		min_vdisktime = vdisktime;
> +
> +	return min_vdisktime;
> +}
> +
> +static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
> +{
> +	s64 delta = (s64)(vdisktime - min_vdisktime);
> +	if (delta < 0)
> +		min_vdisktime = vdisktime;
> +
> +	return min_vdisktime;
> +}

Is there a reason you've reimplemented min and max?

> +	/*
> +	 * Maintain a cache of leftmost tree entries (it is frequently
> +	 * used)
> +	 */

You make it sound like there is a cache of more than one entry.  Please
fix the comment.

> +static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
> +{
> +	/*
> +	 * We don't want to charge more than allocated slice otherwise this
> +	 * queue can miss one dispatch round doubling max latencies. On the
> +	 * other hand we don't want to charge less than allocated slice as
> +	 * we stick to CFQ theme of queue loosing its share if it does not
                                          ^^^^^^^
losing


> +/*
> + * Handles three operations.
> + * Addition of a new queue to service tree, when a new request comes in.
> + * Resorting of an expiring queue (used after slice expired)
> + * Requeuing a queue at the front (used during preemption).
> + */
> +static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> +				bool add_front, unsigned long service)

service?  Can we come up with a better name that actually hints at what
this is?  service_time, maybe?


Mostly this looks pretty good and is fairly easy to read.

Cheers,
Jeff
