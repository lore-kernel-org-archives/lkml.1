Return-Path: <linux-kernel-owner+w=401wt.eu-S1761037AbYARB7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037AbYARB7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbYARB7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:59:05 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61269 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYARB7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:59:03 -0500
Date: Thu, 17 Jan 2008 20:57:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       adobriyan@openvz.org, dev@sw.ru
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <20080117171950.ca4ea87f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0801172052580.1073@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
 <20080117171950.ca4ea87f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jan 2008, Andrew Morton wrote:
>
> A "well-known" problem which few know about ;)

And now I feel less ignorant.

>
> Anyway you should be developing with all debug options enabled and that
> includes NMI watchdog so there.

hehe, I did have NMI on the whole time. It's that I also had modifications
in try_to_wakeup, so seeing that in the backtrace, I thought I was the one
screwing up. But I was still certain that it was my code locking up.


> >
> > Calling printk with interrupts disabled should only be done for
> > emergencies and debugging anyway.
> >

> > +	 * held, this will deadlock. We don't have access to the runqueue
> > +	 * lock from here, but just checking for interrupts disabled
> > +	 * should be enough.
> > +	 */
> > +	if (!irqs_disabled() && wake_klogd)
> >  		wake_up_klogd();
> >  }
> >  EXPORT_SYMBOL(release_console_sem);
>
> this looks fairly foul.  Might cause problems if one CPU is stuck with
> interrupts off spewing printks?

Well, we have more than one problem if that is happening.

>
> Couldn't you maintain a sched-hackers-only printk patch which adds a
> sched_printk() which avoids the wakeup or something like that?
>

Actually, the code that did trigger it was part of the latency_tracer
code doing the wakeup latency timings. Theres a printk that happens when
we trigger the max latency, and it prints from the scheduler.

So this was perfect to lock up every time.

-- Steve

