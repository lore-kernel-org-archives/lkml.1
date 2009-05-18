Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZERHOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZERHOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZERHO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:14:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZERHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:14:25 -0400
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFC] mod_timer() helper functions?
From: Andi Kleen <andi@firstfloor.org>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
Date: Mon, 18 May 2009 09:14:21 +0200
In-Reply-To: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com> (Chris Peterson's message of "Sat, 16 May 2009 00:36:15 -0700")
Message-ID: <87eiumq3w2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Peterson <cpeterso@cpeterso.com> writes:
>
> Any suggestions? Is there enough value to warrant adding helper
> function like these as an alternative to mod_timer()?

I like the basic idea. The opencoding has always annoyed me.
>
>
> chris
>
> ---
> static inline int mod_timer_seconds(struct timer_list *timer, time_t seconds)

I would prefer a name like mod_timer_in_secs() to make it clear it's relative

> {
> 	return mod_timer(timer, round_jiffies(jiffies + seconds * HZ));
> }

>
> static inline int mod_timer_msecs(struct timer_list *timer, unsigned int msecs)
> {
> 	/* TODO? Round jiffies if within some epsilon of a whole second? */
> 	return mod_timer(timer, jiffies + msecs_to_jiffies(msecs));

This is a bit misleading because depending on HZ the accuracy is far from
a millisecond (worst case 10ms error with HZ==100). Naming should make
that clearer. Or maybe these users should all switch to hrtimers,
but then those could be not available either.

I suspect you also want a helper for longer term delays that uses
deferred timers or more aggressive rounding.


> }
>
> static inline int mod_timer_yield(struct timer_list *timer)
> {
> 	/* After these messages, we'll be right back. */
> 	return mod_timer(timer, jiffies + 1);

Can't say I like the name here, although I don't have a better one.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
