Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZETHLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZETHLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZETHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:11:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34097 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZETHLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <87eiumq3w2.fsf@basil.nowhere.org>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
	 <87eiumq3w2.fsf@basil.nowhere.org>
Date: Wed, 20 May 2009 00:11:37 -0700
Message-ID: <a24804730905200011l202733abh89f5d4feaf69610e@mail.gmail.com>
Subject: Re: [RFC] mod_timer() helper functions?
From: Chris Peterson <cpeterso@cpeterso.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like these helper functions?

The function names "timer_settime_msecs()" and "timer_settime_secs()"
are not fantastic, but they are inspired by the precedent set by the
POSIX Realtime function timer_settime().


/**
 * timer_settime_msecs - modify a timer's timeout
 * @timer: the timer to be modified
 * @msecs: minimum time in milliseconds to sleep for
 */
int timer_settime_msecs(struct timer_list *timer, int msecs)
{
	unsigned long expires = jiffies + msecs_to_jiffies(msecs);

	/* TODO? round_jiffies() if msecs parameter is large, say >= ~5000? */
        /* If people don't mind if timer_settime_msecs() rounds to
whole seconds, then timer_settime_secs() might be unnecessary. */

	return mod_timer(timer, expires);
}


/**
 * timer_settime_secs - modify a timer's timeout
 * @timer: the timer to be modified
 * @secs: approximate time in seconds to sleep for
 */
int timer_settime_secs(struct timer_list *timer, time_t secs)
{
	unsigned long expires = jiffies + (secs * HZ);

	/* If the caller doesn't mind waiting multiple seconds, then
	 * feel free to round up to whole seconds (to reduce wakeups).
	 */
	if (secs >= 2)
		expires = round_jiffies_up(expires);

	return mod_timer(timer, expires);
}
