Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbXDRQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbXDRQHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXDRQHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:07:38 -0400
Received: from holomorphy.com ([66.93.40.71]:41705 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbXDRQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:07:38 -0400
Date: Wed, 18 Apr 2007 09:07:22 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "S.??a??lar Onur" <caglar@pardus.org.tr>,
       Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418160722.GB31925@holomorphy.com>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com> <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418154811.GA16842@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 05:48:11PM +0200, Ingo Molnar wrote:
>  static void requeue_task_fair(struct rq *rq, struct task_struct *p)
>  {
>  	dequeue_task_fair(rq, p);
>  	p->on_rq = 0;
> -	enqueue_task_fair(rq, p);
> +	/*
> +	 * Temporarily insert at the last position of the tree:
> +	 */
> +	p->fair_key = LLONG_MAX;
> +	__enqueue_task_fair(rq, p);
>  	p->on_rq = 1;
> +
> +	/*
> +	 * Update the key to the real value, so that when all other
> +	 * tasks from before the rightmost position have executed,
> +	 * this task is picked up again:
> +	 */
> +	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;

At this point you might as well call the requeue operation something
having to do with yield. I also suspect what goes on during the timer
tick may eventually become something different from requeueing the
current task, and furthermore class-dependent.


-- wli
