Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZEPHgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZEPHgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 03:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZEPHgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 03:36:15 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:39699 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZEPHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 03:36:15 -0400
MIME-Version: 1.0
Date: Sat, 16 May 2009 00:36:15 -0700
Message-ID: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
Subject: [RFC] mod_timer() helper functions?
From: Chris Peterson <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewing the kernel's nearly one-thousand calls to mod_timer(), there
are three basic patterns:

 * multi-second timeouts
 * millisecond timeouts
 * +1 jiffie ASAP events

Few mod_timer() calls actually use the function's 'expires' deadline
time without manually calculating 'jiffies + delay'. The following
helper functions could provide a simpler, more descriptive interface
than the low-level mod_timer() function. Also, when scheduling longer
timers, these helper functions could use round_jiffies() to (secretly)
batch timers on whole seconds to reduce power usage.

Any suggestions? Is there enough value to warrant adding helper
function like these as an alternative to mod_timer()?


chris

---
static inline int mod_timer_seconds(struct timer_list *timer, time_t seconds)
{
	return mod_timer(timer, round_jiffies(jiffies + seconds * HZ));
}

static inline int mod_timer_msecs(struct timer_list *timer, unsigned int msecs)
{
	/* TODO? Round jiffies if within some epsilon of a whole second? */
	return mod_timer(timer, jiffies + msecs_to_jiffies(msecs));
}

static inline int mod_timer_yield(struct timer_list *timer)
{
	/* After these messages, we'll be right back. */
	return mod_timer(timer, jiffies + 1);
}
