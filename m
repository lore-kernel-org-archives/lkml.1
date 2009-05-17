Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZEQIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZEQIFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZEQIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:04:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbZEQIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:04:46 -0400
Date: Sun, 17 May 2009 01:03:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFC] mod_timer() helper functions?
Message-Id: <20090517010347.f25843f9.akpm@linux-foundation.org>
In-Reply-To: <a24804730905170050m16bfb81cj6c9ee4c99ac9d08f@mail.gmail.com>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
	<20090516230350.ec4fb487.akpm@linux-foundation.org>
	<a24804730905170050m16bfb81cj6c9ee4c99ac9d08f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 00:50:55 -0700 Chris Peterson <cpeterso@cpeterso.com> wrote:

> >> Reviewing the kernel's nearly one-thousand calls to mod_timer(), there
> >> are three basic patterns:
> >>
> >> __* multi-second timeouts
> >> __* millisecond timeouts
> >> __* +1 jiffie ASAP events
> >>
> 
> Is there a functional difference between the following "expire this
> timer ASAP" statements?
> 
> mod_timer(timer, jiffies + 1); /* 48 uses */
> mod_timer(timer, jiffies); /* 44 uses */
> mod_timer(timer, jiffies - 1); /* 6 uses */

That's something which has always worried me.  Lots of code does:

	mod_timer(timer, jiffies + 1);

(for varying values of "1").  What happens if this thread of control
then gets stalled for a couple of jiffies.  Say it gets preempted or
there's a long interrupt or whatever.  So there's a several-jiffy
interval between the caller evaluating jiffies+1 and the entry to
mod_timer().


>From my reading, we'll hit

		int i;
		/* If the timeout is larger than 0xffffffff on 64-bit
		 * architectures then we use the maximum timeout:
		 */
		if (idx > 0xffffffffUL) {
			idx = 0xffffffffUL;
			expires = idx + base->timer_jiffies;
		}
		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
		vec = base->tv5.vec + i;

and the timer gets scheduled at some time in the far-distant future!

But this is such a glaring and huge problem that surely it cannot
exist.  But I don't know why not.

If the bug _does_ exist then mod_timer(timer, jiffies - 1) will set the
timer to go off in the far future.  mod_timer(timer, jiffies) will
usually make it go off real soon now, but it's scary.  mod_timer(timer,
jiffies + 1) is safer, but still vulnerable.


