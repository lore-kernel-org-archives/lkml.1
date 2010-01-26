Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539Ab0AZX3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0AZX3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722Ab0AZX3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:29:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112Ab0AZX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:29:46 -0500
Date: Tue, 26 Jan 2010 15:28:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timekeeping:  move xtime_cache to be in the same
 cache line as the lock
Message-Id: <20100126152822.d05b5487.akpm@linux-foundation.org>
In-Reply-To: <1264088361.2082.45.camel@localhost>
References: <1264088361.2082.45.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 15:39:21 +0000
Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> move xtime_cache to be in the same cache line as the lock
>     
> allowing current_kernel_time() to access only one cache line

Sentences start with capital letters, please.

> when running fio write tests on a 2 core machine, on some of the runs
> 'perf record -e cache_misses' shows current_kernel_time near the top of
> the list of cache_misses with 5.5%.
> On the other runs it's down at 0.05% so I'm assuming that the difference
> is just down to which core the test client get run on.
> 
> This patch moves the xtime_cache variable near to the lock so that it
> only need to access one cache line.
> With this applied it drops the current_kernel_time cache_misses in the
> slow case to 4.5%
> 

I don't know how reliable this is.  I _think_ the compiler and linker
are free to place variables of this nature in any old place.  Whether
any of the current tools actually do that I don't know.  Note that one
of these variables has file-static scope and the other does not, which
perhaps increases the risk that the compiler or linker will go and
fiddle with them.

To do this reliably one would need to put them in a struct:

time.h:

extern struct xtime_stuff {
	seqlock_t _xtime_lock,
	struct timespec _xtime_cache,
} xtime_stuff;

#define xtime_lock xtime_stuff._xtime_lock


timekeeping.c:

struct xtime_stuff {
	._xtime_lock = __SEQLOCK_UNLOCKED(xtime_stuff._xtime_lock),
};

> BTW on 64 bit timespec is a 16 byte structure so the aligned 16 doesn't
> do much, and on 32bit timepec is 8bytes so this just seems to spread
> these variables across more cache lines than necessary. Any ideas what
> this is here for?

Dunno.  I had a bit of a peek in the git history but it got complicated
and people rarely bother explaining things like this anyway :(

