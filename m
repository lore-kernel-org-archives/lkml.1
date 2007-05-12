Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbXELTge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbXELTge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbXELTg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:36:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58953 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760237AbXELTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:36:25 -0400
Date: Sun, 13 May 2007 01:06:09 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070512193609.GA31426@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705122017.32792.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705122017.32792.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 08:17:31PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Having considered the issue of freezing (or not freezing) kernel threads for a
> longer while I tend to agree with Linus that we shouldn't be freezing as many
> kernel threads as we currently freeze, but there's one thing that he doesn't
> seem to take into account.  Namely, there may be some kernel threads that
> actually *want* (or need) to be frozen. :-)
> 
> For the suspend they may be kernel threads that otherwise would need some
> special synchronization with some device drivers' .suspend() and .resume()
> callbacks or fs-related kernel threads.  For the CPU hotplug they might be
> kernel threads that otherwise would interfere with the removal or addition of
> CPUs.  

While it is definitely a good idea, since it would reduce the
freeze_time, it also raises some concerns, atleast from cpu-hotplug
perspective. 

Having been through the whole global lock_cpu_hotplug()
and the per-subsystem cpu-hotplug-lock mess, I have observed one other
thing about these locks. Not only might they result in deadlocks, but
they also make code maintainability more difficult.

For eg, a function foo() which does 

for_each_online_cpu() {
	/* do something */
}

needs hotplug protection. Thus any call chain leading to foo(), needs to
have be wrapped with some sort of a cpu-hotplug-mutex. This is what made it
more difficult to maintain, since we had to audit everytime someone
creates a new call chain leading to foo().

With the "freeze-limited-kernel-threads" scheme, we would still need
to perform this audit, since we now have to freeze only those kernel
threads which *may* end up calling foo().

So at the moment, I have some doubts if this scheme would help us solve
the maintainabilty problem which the locks had created. It defintely
needs some more thinking.

That said,  I agree that coarse-grained protection, though is effective
may not be flexible and my not yield the expected performance.
Eg: Waiting for kernel threads to freeze, which have nothing to do with 
cpu-hotplug only mean more latency for the cpu-hotplug operation.

>Still, in each case there seems to be a limited group of kernel threads
> that may want to be frozen and the remaining kernel threads that shouldn't be
> involved in any freezer-related actions at all.  However, we currently require
> all kernel threads to take part in the freezing mechanism, which doesn't seem to
> be correct.
> 
> It seems to me that, instead of asking *all* kernel threads to either set
> PF_NOFREEZE or call try_to_freeze() in a suitable place, we should introduce
> some mechanism allowing the kernel threads that *want* to freeze to register
> with the freezer.  For example, we can use a per-task flag, say PF_FREEZABLE,
> to indicate that given task is a kernel thread which wants (or needs) to be
> frozen (for simplicity, I'll call it a 'freezable thread' from now on).
> Alternatively, we can use a list of freezable kernel threads.  Regardless of
> what actual mechanism is used, the freezer will only set TIF_FREEZE for
> freezable kernel threads and these threads will be expected to call
> try_to_freeze().  The remaining kernel threads (I'll call them 'normal') won't
> need to do anything.
> 
> If this approach is used, the entire freezing-related complexity will only
> affect the freezable kernel threads.  Moreover, it seems that we can precisely
> define and document the rules to be followed by the freezable kernel threads
> (for example, IMO it's reasonable to require a freezable kernel thread to
> unregister from the freezer before it stops etc.) while the normal kernel
> threads can be left in peace.
> 
> It also seems that we can transition from the current apporach to the one
> outlined above in a quite straightforward way.  Namely, for this purpose we
> need to identify the kernel threads that should be freezable, make them use the
> new interface, and remove PF_NOFREEZE and try_to_freeze() from the remaining
> kernel threads.  Later, if testing shows that we've overlooked some kernel
> threads which need to be made freezable, we'll be able to add the "ability to
> freeze" to these threads quite easily.
> 
> Of course, that would also require us to rewrite the freezer itself quite a
> bit, but IMO it's worthy of doing.
> 
> Thoughts?
> 
> Rafael
Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
