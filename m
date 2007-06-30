Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbXF3LqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbXF3LqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 07:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXF3LqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 07:46:08 -0400
Received: from mail.screens.ru ([213.234.233.54]:55477 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbXF3LqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 07:46:07 -0400
Date: Sat, 30 Jun 2007 15:46:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070630114658.GA344@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183190728.7932.43.camel@earth4>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Ingo Molnar wrote:
>
> On Thu, 2007-06-28 at 19:33 +0200, Johannes Berg wrote:
> > No, that's not right either, but Arjan just helped me a bit with how
> > lockdep works and I think I have the right idea now. Ignore this for
> > now, I'll send a new patch in a few days.
> 
> ok. But in general, this is a very nice idea!
> 
> i've Cc:-ed Oleg. Oleg, what do you think? I think we should keep all
> the workqueue APIs specified in a form that makes them lockdep coverable
> like Johannes did. This debug mechanism could have helped with the
> recent DVB lockup that Thomas Sattler reported.

I think this idea is great!

Johannes, could you change wait_on_work() as well? Most users of
flush_workqueue() should be converted to use it.

> @@ -342,6 +351,9 @@ static int flush_cpu_workqueue(struct cp
>         } else {
>                 struct wq_barrier barr;
>
> +               lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +               lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
> +
>                 active = 0;
>                 spin_lock_irq(&cwq->lock);

I am not sure why you skip "if (cwq->thread == current)" case, it can
deadlock in the same way.

But, perhaps we should not change flush_cpu_workqueue(). If we detect the
deadlock, we will have num_online_cpus() reports, yes?

And,

>                 if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
> @@ -376,6 +388,8 @@ void fastcall flush_workqueue(struct wor
>         int cpu;
>
>         might_sleep();
> +       lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> +       lock_release(&wq->lockdep_map, 0, _THIS_IP_);

one of the 2 callers was already modified. Perhaps it is better to add
lock_acquire() into the second caller, cleanup_workqueue_thread(), but
skip flush_cpu_workqueue() ?

Oleg.

