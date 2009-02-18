Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZBRVNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZBRVNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZBRVNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:13:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZBRVM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:12:59 -0500
Date: Wed, 18 Feb 2009 22:09:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, mingo@redhat.com, shemminger@vyatta.com, kaber@trash.net,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Q: timer_stats_account_xtimer() should reset ->start_site?
Message-ID: <20090218210940.GA8094@redhat.com>
References: <tip-74019224ac34b044b44a31dd89a54e3477db4896@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-74019224ac34b044b44a31dd89a54e3477db4896@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Ingo Molnar wrote:
>
> +__mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
>  {
>  	struct tvec_base *base, *new_base;
>  	unsigned long flags;
> -	int ret = 0;
> +	int ret;
> +
> +	ret = 0;
>
>  	timer_stats_timer_set_start_info(timer);
>  	BUG_ON(!timer->function);
> @@ -603,6 +606,9 @@ int __mod_timer(struct timer_list *timer, unsigned long expires)
>  	if (timer_pending(timer)) {
>  		detach_timer(timer, 0);
>  		ret = 1;
> +	} else {
> +		if (pending_only)
> +			goto out_unlock;

At first glance, I thought this is not exactly right wrt timer stats when
__mod_timer(pending_only => true) fails.

But it turns out, I just can't understand the behaviour of /proc/timer_stats.

The first task which does __mod_timer() fills ->start_site/etc, this info
is cleared by del_timer(). This looks correct.

But when __run_hrtimer/__run_timers report this timer to /proc/timer_stats
we don't clear this info. If the timer expires, and then another task uses
the same timer, timer_stats will report the same ->start_site/pid twice.

Is it correct? Perhaps timer_stats_account_timer() should reset start_site?

Or we can kill the "if (timer->start_site)" in _set_start_info().

Or I missed something. Hmm... and del_timer_sync() doesn't clear start_site.

Confused, please help.

Oleg.

