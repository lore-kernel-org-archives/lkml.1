Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZE0Rhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZE0Rhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZE0Rha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:37:30 -0400
Received: from www.tglx.de ([62.245.132.106]:49907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZE0Rh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:37:29 -0400
Date: Wed, 27 May 2009 19:36:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME?
In-Reply-To: <4A1D7512.9080604@nortel.com>
Message-ID: <alpine.LFD.2.00.0905271922470.3397@localhost.localdomain>
References: <4A1D6E71.90602@nortel.com> <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain> <4A1D7512.9080604@nortel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Chris Friesen wrote:

> Thomas Gleixner wrote:
> > On Wed, 27 May 2009, Chris Friesen wrote:
> > 
> > That's more a question for the glibc folks. CC'ed.
> 
> Actually, I'm looking at the kernel code here.  It looks like
> posix_cpu_clock_get() should be able to handle a per-task cpu clock for
> another thread within the same process.  However, it's only ever called
> by thread_cpu_clock_get(), which hardcodes a clock_id of THREAD_CLOCK,
> which corresponds to the current thread.

No, it's also called via the CLOCK_DISPATCH magic in posix_timers.c
 
> Similarly, invalid_clockid() will say that the clock_id is invalid if
> it's positive but greater than 15.  If my math is right, this means that
> any pid > 2 will result in invalid_clockid() failing.

posix_cpu_clock_get() does:

  const pid_t pid = CPUCLOCK_PID(which_clock);

CPUCLOCK_PID is defined as:

#define CPUCLOCK_PID(clock)  ((pid_t) ~((clock) >> 3))

include/linux/posix-timers.h has the helper macros to build the
clock_id value for posix_cpu_clock_get()

#define MAKE_PROCESS_CPUCLOCK(pid, clock) \
        ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
#define MAKE_THREAD_CPUCLOCK(tid, clock) \
        MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)

Hope that helps,

     tglx
