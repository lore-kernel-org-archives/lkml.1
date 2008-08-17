Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYHQXCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYHQXCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHQXB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:01:59 -0400
Received: from xenotime.net ([66.160.160.81]:58700 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750930AbYHQXB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:01:59 -0400
Date: Sun, 17 Aug 2008 16:02:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <cborntra@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking
 waiting
Message-Id: <20080817160227.cfe6e40c.rdunlap@xenotime.net>
In-Reply-To: <48A70185.2020600@goop.org>
References: <48A70185.2020600@goop.org>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 09:34:13 -0700 Jeremy Fitzhardinge wrote:

> --- /dev/null
> +++ b/include/linux/trigger.h
> @@ -0,0 +1,145 @@
> +#ifndef _LINUX_TRIGGER_H
> +#define _LINUX_TRIGGER_H
> +
> +
> +
> +/**
> + * trigger_init - Initialize a trigger for use
> + * @t - trigger to be initialized

kernel-doc format for function parameters is like:

 * @t: trigger to be initialized

so please change all occurrences to be like that.  Thanks.


> + */
> +static inline void trigger_init(trigger_t *t)
> +{
> +	__raw_trigger_init(t);
> +}
> +
> +/**
> + * trigger_reset - reset a trigger
> + * @t - trigger to be reset
> + *
> + * This resets the trigger state, allowing a trigger_wait to block.
> + * Note that preemption must be disabled between trigger_reset() and
> + * trigger_finish().
> + *
> + * The use of these functions is:
> + *	trigger_reset(&t);
> + *	while(!condition)
> + *		trigger_wait(&t);
> + *	trigger_finish(&t);
> + *
> + * and where the condition is set:
> + *	condition = true;
> + *	trigger_kick(&t);
> + */
> +static inline void trigger_reset(trigger_t *t)
> +{
> +	__raw_trigger_reset(t);
> +}
> +
> +/**
> + * trigger_wait - wait for a trigger to be kicked
> + * @t - trigger to be waited on
> + *
> + * This blocks until the trigger has been kicked.  If the trigger has
> + * already been kicked, it will return immediately.  It may also
> + * return without the trigger having been kicked at all; the caller
> + * must test the condition before calling trigger_wait() again.
> + *
> + * trigger_wait() acts as a read barrier.
> + *
> + * On return, the trigger will have always be reset.
> + */
> +static inline void trigger_wait(trigger_t *t)
> +{
> +	__raw_trigger_wait(t);
> +}
> +
> +/**
> + * trigger_kick - kick a trigger
> + * @t - trigger to kick
> + *
> + * This causes anyone waiting in trigger_wait to continue.  It may be
> + * called in any context.
> + *
> + * trigger_kick() acts as a write barrier.
> + */
> +static inline void trigger_kick(trigger_t *t)
> +{
> +	__raw_trigger_kick(t);
> +}
> +
> +/**
> + * trigger_finish - clean up trigger
> + * @t - trigger to be cleaned up
> + *
> + * This cleans up any implementation trigger state once we've finished
> + * with it.
> + */
> +static inline void trigger_finish(trigger_t *t)
> +{
> +	__raw_trigger_finish(t);
> +}
> +#endif	/* _LINUX_TRIGGER_H */


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
