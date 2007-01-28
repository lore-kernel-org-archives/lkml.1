Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXA1VSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXA1VSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbXA1VSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:18:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbXA1VSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:18:49 -0500
Date: Sun, 28 Jan 2007 22:17:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>
Subject: Re: lockmeter
Message-ID: <20070128211705.GA9596@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org> <45BCDF88.2020504@mbligh.org> <20070128180132.GA1647@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128180132.GA1647@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.3 required=5.9 tests=ALL_TRUSTED autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> My lock stat stuff shows dcache to a be a problem under -rt as well. 
> It is keyed off the same mechanism as lockdep. [...]

btw., while my plan is to prototype your lock-stat patch in -rt 
initially, it should be doable to extend it to be usable with the 
upstream kernel as well.

We can gather lock contention events when there is spinlock debugging 
enabled, from lib/spinlock_debug.c. For example __spin_lock_debug() does 
this:

static void __spin_lock_debug(spinlock_t *lock)
{
...
                for (i = 0; i < loops; i++) {
                        if (__raw_spin_trylock(&lock->raw_lock))
                                return;
                        __delay(1);
                }

where the __delay(1) call is done do we notice contention - and there 
you could drive the lock-stat code. Similarly, rwlocks have such natural 
points too where you could insert a lock-stat callback without impacting 
performance (or the code) all that much. mutexes and rwsems have natural 
contention points too (kernel/mutex.c:__mutex_lock_slowpath() and 
kernel/rwsem.c:rwsem_down_failed_common()), even with mutex debugging is 
off.

for -rt the natural point to gather contention events is in 
kernel/rtmutex.c, as you are doing it currently.

finally, you can enable lockdep's initialization/etc. wrappers so that 
infrastructure between lockdep and lock-stat is shared, but you dont 
have to call into the lock-tracking code of lockdep.c if LOCK_STAT is 
enabled and PROVE_LOCKING is disabled. That should give you the lockdep 
infrastructure for LOCK_STAT, without the lockdep overhead.

all in one, one motivation behind my interest in your patch for -rt is 
that i think it's useful for upstream too, and that it can merge with 
lockdep to a fair degree.

	Ingo
