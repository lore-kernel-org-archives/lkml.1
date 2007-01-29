Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbXA2F2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbXA2F2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933136AbXA2F2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:28:14 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:59718
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135AbXA2F2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:28:13 -0500
Date: Sun, 28 Jan 2007 21:27:45 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: lockmeter
Message-ID: <20070129052745.GA5218@gnuppy.monkey.org>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org> <45BCDF88.2020504@mbligh.org> <20070128180132.GA1647@gnuppy.monkey.org> <20070128211705.GA9596@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128211705.GA9596@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 10:17:05PM +0100, Ingo Molnar wrote:
> btw., while my plan is to prototype your lock-stat patch in -rt 
> initially, it should be doable to extend it to be usable with the 
> upstream kernel as well.
> 
> We can gather lock contention events when there is spinlock debugging 
> enabled, from lib/spinlock_debug.c. For example __spin_lock_debug() does 
> this:
> 
> static void __spin_lock_debug(spinlock_t *lock)
> {
> ...
>                 for (i = 0; i < loops; i++) {
>                         if (__raw_spin_trylock(&lock->raw_lock))
>                                 return;
>                         __delay(1);
>                 }
> 
> where the __delay(1) call is done do we notice contention - and there 
> you could drive the lock-stat code. Similarly, rwlocks have such natural 
> points too where you could insert a lock-stat callback without impacting 
> performance (or the code) all that much. mutexes and rwsems have natural 
> contention points too (kernel/mutex.c:__mutex_lock_slowpath() and 
> kernel/rwsem.c:rwsem_down_failed_common()), even with mutex debugging is 
> off.
> 
> for -rt the natural point to gather contention events is in 
> kernel/rtmutex.c, as you are doing it currently.
> 
> finally, you can enable lockdep's initialization/etc. wrappers so that 
> infrastructure between lockdep and lock-stat is shared, but you dont 
> have to call into the lock-tracking code of lockdep.c if LOCK_STAT is 
> enabled and PROVE_LOCKING is disabled. That should give you the lockdep 
> infrastructure for LOCK_STAT, without the lockdep overhead.
> 
> all in one, one motivation behind my interest in your patch for -rt is 
> that i think it's useful for upstream too, and that it can merge with 
> lockdep to a fair degree.

Fantastic. I'm going to try and finish up your suggested changes tonight
and get it to work with CONFIG_LOCK_STAT off. It's been challenging to
find time to do Linux these days, so I don't mind handing it off to you
after this point so that you and tweek it to your heart's content.

Yeah, one of the major motivations behind it was to see if Solaris style
locks were useful and to either validate or invalidate their usefulness.
Because of this patch, we have an idea of what's going on with regard to
adaptive spinning and such. The sensible conclusion is that it's not
sophistication of the lock, but parallelizing the code in the first
place to prevent the contention in the first place that's the key
philosophical drive.

I forward merged it into rc6-rt2 and you can expect a drop tonight of
what I have regardless whether it's perfect or not.

bill

