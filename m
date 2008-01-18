Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYARBdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYARBdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYARBc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:32:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756258AbYARBcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:32:55 -0500
Date: Thu, 17 Jan 2008 17:31:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.00.0801171724520.2957@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, Steven Rostedt wrote:
>
> Calling printk with interrupts disabled should only be done for
> emergencies and debugging anyway.

Agreed, I think this is sane.

> And with this patch, my code ran fine ;-)

Patch looks fine, but I'm saddened:

> +	/*
> +	 * If we try to wake up klogd while printing with the runqueue lock
> +	 * held, this will deadlock. We don't have access to the runqueue
> +	 * lock from here, but just checking for interrupts disabled
> +	 * should be enough.
> +	 */
> +	if (!irqs_disabled() && wake_klogd)
>  		wake_up_klogd();

..because we actually *have* the old hardware irq enable/disable value in 
in that "flags" parameter we just restored, so it's more than a bit sad to 
then ask again whether they were disabled or not!

IOW, I think this should be

	if (raw_irqs_disabled_flags(flags) && wake_klogd)
		wake_up_klogd();

Of course, not all architectures seem to suport that thing (it's currently 
only used by the CONFIG_TRACE_IRQFLAGS config option).

Damn. So close, yet so far away.

			Linus
