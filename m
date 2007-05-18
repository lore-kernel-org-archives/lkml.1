Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXERWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXERWdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbXERWdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:33:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbXERWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:33:16 -0400
Date: Fri, 18 May 2007 15:29:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, malitzke@metronets.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug 8501] udivdi3  absence with gcc-4.3.0 on kernels 2.6.20.11
 & 2.6.22.-rc1
Message-Id: <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
In-Reply-To: <200705181941.l4IJfOtf018049@fire-2.osdl.org>
References: <200705181941.l4IJfOtf018049@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 12:41:24 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8501

Problem.

gcc-4.3 appears to have cunningly converted this:

static inline void timespec_add_ns(struct timespec *a, u64 ns)
{
	ns += a->tv_nsec;
	while(unlikely(ns >= NSEC_PER_SEC)) {
		ns -= NSEC_PER_SEC;
		a->tv_sec++;
	}
	a->tv_nsec = ns;
}

into a divide-by-1000000000 operation, so it emits a call to udivdi3 and we
don't link.

I expect that this optimisation will remain in gcc-4.3 and we'll end up
having major kernel releases which don't build on i386 with major gcc
releases, which isn't altogether desirable.  I suspect we'll need to fix this
fairly urgently, and to backport the fix into a number of kernel releases.

We use the above idiom in several places.  A suitable fix might be to hunt
down those various sites and then make them call a helper function which
does

	if (unlikely(ns >= NSEC_PER_SEC)) {
		do_div(...)
	}

(Better would be to inline the comparison and to uninline the do_div(),
if it's a 32-bit arch.  Doing all this in a backportable fashion may
prove tricky)
