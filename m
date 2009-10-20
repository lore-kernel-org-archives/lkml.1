Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbZJTA7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbZJTA7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbZJTA7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:59:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37646 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZJTA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:59:17 -0400
Date: Tue, 20 Oct 2009 02:59:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 4/5] cfq-iosched: enable idling for last queue on
	priority class
Message-ID: <20091020005921.GE10727@kernel.dk>
References: <200910192221.32158.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192221.32158.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> cfq can disable idling for queues in various circumstances.
> When workloads of different priorities are competing, if the higher
> priority queue has idling disabled, lower priority queues may steal
> its disk share. For example, in a scenario with an RT process
> performing seeky reads vs a BE process performing sequential reads,
> on an NCQ enabled hardware, with low_latency unset,
> the RT process will dispatch only the few pending requests every full
> slice of service for the BE process.
> 
> The patch solves this issue by always performing idle on the last
> queue at a given priority class > idle. If the same process, or one
> that can pre-empt it (so at the same priority or higher), submits a
> new request within the idle window, the lower priority queue won't
> dispatch, saving the disk bandwidth for higher priority ones.
> 
> Note: this doesn't touch the non_rotational + NCQ case (no hardware
> to test if this is a benefit in that case).
> 
> +static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	if (cfq_class_idle(cfqq))
> +		return false;
> +	if (cfq_cfqq_idle_window(cfqq))
> +		return true;
> +	{
> +		enum wl_prio_t prio = cfq_class_rt(cfqq) ? RT_WL : BE_WL;
> +		struct cfq_rb_root *service_tree = service_tree_for(prio, cfqd);
> +		return service_tree->count == 0 ||
> +			(service_tree->count == 1
> +			 && cfq_rb_first(service_tree) == cfqq);
> +	}
> +}

This, again, looks more like a debug patch than a piece of tested
production code. Fix it. And comment it!

-- 
Jens Axboe

