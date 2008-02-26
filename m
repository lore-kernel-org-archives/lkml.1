Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbYBZAzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYBZAzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYBZAzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:55:35 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:17633 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYBZAze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:55:34 -0500
Message-Id: <47C31B9E.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 25 Feb 2008 17:48:46 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 5/9] adaptive real-time lock support
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160103.11268.25579.stgit@novell1.haskins.net>
 <20080225220313.GG2659@elf.ucw.cz>
In-Reply-To: <20080225220313.GG2659@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 25, 2008 at  5:03 PM, in message
<20080225220313.GG2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> Hi!
> 
>> +/*
>> + * Adaptive-rtlocks will busywait when possible, and sleep only if
>> + * necessary. Note that the busyloop looks racy, and it is....but we do
>> + * not care. If we lose any races it simply means that we spin one more
>> + * time before seeing that we need to break-out on the next iteration.
>> + *
>> + * We realize this is a relatively large function to inline, but note that
>> + * it is only instantiated 1 or 2 times max, and it makes a measurable
>> + * performance different to avoid the call.
>> + *
>> + * Returns 1 if we should sleep
>> + *
>> + */
>> +static inline int
>> +adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
>> +	      struct adaptive_waiter *adaptive)
>> +{
>> +	int sleep = 0;
>> +
>> +	for (;;) {
>> +		/*
>> +		 * If the task was re-awoken, break out completely so we can
>> +		 * reloop through the lock-acquisition code.
>> +		 */
>> +		if (!waiter->task)
>> +			break;
>> +
>> +		/*
>> +		 * We need to break if the owner changed so we can reloop
>> +		 * and safely acquire the owner-pointer again with the
>> +		 * wait_lock held.
>> +		 */
>> +		if (adaptive->owner != rt_mutex_owner(lock))
>> +			break;
>> +
>> +		/*
>> +		 * If we got here, presumably the lock ownership is still
>> +		 * current.  We will use it to our advantage to be able to
>> +		 * spin without disabling preemption...
>> +		 */
>> +
>> +		/*
>> +		 * .. sleep if the owner is not running..
>> +		 */
>> +		if (!adaptive->owner->se.on_rq) {
>> +			sleep = 1;
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * .. or is running on our own cpu (to prevent deadlock)
>> +		 */
>> +		if (task_cpu(adaptive->owner) == task_cpu(current)) {
>> +			sleep = 1;
>> +			break;
>> +		}
>> +
>> +		cpu_relax();
>> +	}
>> +
>> +	put_task_struct(adaptive->owner);
>> +
>> +	return sleep;
>> +}
>> +
> 
> You want to inline this?

Yes.  As the comment indicates, there are 1-2 users tops, and it has a significant impact on throughput (> 5%) to take the hit with a call.  I don't think its actually much code anyway...its all comments.

> 
>> +static inline void
>> +prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter 
> *adaptive)
> ...
>> +#define prepare_adaptive_wait(lock, busy) {}
> 
> This is evil. Use empty inline function instead (same for the other
> function, there you can maybe get away with it).

Ok.


> 									Pavel



