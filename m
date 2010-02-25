Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0BYDEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:04:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:54898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718Ab0BYDEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:04:43 -0500
Message-ID: <4B85EAE8.8040104@kernel.org>
Date: Thu, 25 Feb 2010 12:13:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueues: change cancel_work_sync() to clear	work->data
References: <20100224202031.GA26987@redhat.com>
In-Reply-To: <20100224202031.GA26987@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 03:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 05:20 AM, Oleg Nesterov wrote:
> In short: change cancel_work_sync(work) to mark this work as "never
> queued" upon return.
> 
> When cancel_work_sync(work) succeeds, we know that this work can't be
> queued or running, and since we own WORK_STRUCT_PENDING nobody can change
> the bits in work->data under us. This means we can also clear the "cwq"
> part along with _PENDING bit lockless before return, unless the work is
> queued nobody can assume get_wq_data() is stable even under cwq->lock.
> 
> This change can speedup the subsequent cancel/flush requests, and as
> Dmitry pointed out this simplifies the usage of work_struct's which
> can be queued on different workqueues. Consider this pseudo code from
> the input subsystem:
> 
> 	struct workqueue_struct *WQ;
> 	struct work_struct *WORK;
> 
> 	for (;;) {
> 		WQ = create_workqueue();
> 		...
> 		if (condition())
> 			queue_work(WQ, WORK);
> 		...
> 		cancel_work_sync(WORK);
> 		destroy_workqueue(WQ);
> 	}
> 
> If condition() returns T and then F, cancel_work_sync() will crash the
> kernel because WORK->data still points to the already destroyed workqueue.
> With this patch the code like above becomes correct.
> 
> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Yeap, generally looks good to me and I've been doing similar things to
implement non-reentrant workqueues (records the last cpu a work was on
in work->dataa after the work is dispatched to a worker thread).  I'll
add this to the series.

Thank you.

-- 
tejun
