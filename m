Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZEQGEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZEQGEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZEQGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:04:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbZEQGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:04:36 -0400
Date: Sat, 16 May 2009 23:03:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFC] mod_timer() helper functions?
Message-Id: <20090516230350.ec4fb487.akpm@linux-foundation.org>
In-Reply-To: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 00:36:15 -0700 Chris Peterson <cpeterso@cpeterso.com> wrote:

> Reviewing the kernel's nearly one-thousand calls to mod_timer(), there
> are three basic patterns:
> 
>  * multi-second timeouts
>  * millisecond timeouts
>  * +1 jiffie ASAP events
> 
> Few mod_timer() calls actually use the function's 'expires' deadline
> time without manually calculating 'jiffies + delay'. The following
> helper functions could provide a simpler, more descriptive interface
> than the low-level mod_timer() function. Also, when scheduling longer
> timers, these helper functions could use round_jiffies() to (secretly)
> batch timers on whole seconds to reduce power usage.
> 
> Any suggestions? Is there enough value to warrant adding helper
> function like these as an alternative to mod_timer()?
> 
> 
> chris
> 
> ---
> static inline int mod_timer_seconds(struct timer_list *timer, time_t seconds)
> {
> 	return mod_timer(timer, round_jiffies(jiffies + seconds * HZ));
> }
> 
> static inline int mod_timer_msecs(struct timer_list *timer, unsigned int msecs)
> {
> 	/* TODO? Round jiffies if within some epsilon of a whole second? */
> 	return mod_timer(timer, jiffies + msecs_to_jiffies(msecs));
> }
> 
> static inline int mod_timer_yield(struct timer_list *timer)
> {
> 	/* After these messages, we'll be right back. */
> 	return mod_timer(timer, jiffies + 1);
> }

I think it makes sense, yes.

I do think that the name should be changed to communicate the fact that
the change is relative.  advance_timer_foo(), perhaps.

Or, if you want to put lipstick on our pig, timer_advance_foo().  All
these API functions should have started with "timer_" but we screwed
that up ages ago.

I expect that most/all of these functions will be too large to inline,
btw.  Check the generated code and I expect you'll be surprised how
porky they are.
