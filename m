Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbXJAQtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbXJAQtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJAQt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:49:28 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3471 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXJAQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:49:27 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Mon, 1 Oct 2007 09:49:35 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071001162507.GA22791@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 09:49:36 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 09:49:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> * Jarek Poplawski <jarkao2@o2.pl> wrote:
>
> > BTW, it looks like risky to criticise sched_yield too much: some
> > people can misinterpret such discussions and stop using this at all,
> > even where it's right.

> Really, i have never seen a _single_ mainstream app where the use of
> sched_yield() was the right choice.

It can occasionally be an optimization. You may have a case where you can do
something very efficiently if a lock is not held, but you cannot afford to
wait for the lock to be released. So you check the lock, if it's held, you
yield and then check again. If that fails, you do it the less optimal way
(for example, dispatching it to a thread that *can* afford to wait).

It is also sometimes used in the implementation of spinlock-type primitives.
After spinning fails, yielding is tried.

I think it's also sometimes appropriate when a thread may monopolize a
mutex. For example, consider a rarely-run task that cleans up some expensive
structures. It may need to hold locks that are only held during this complex
clean up.

One example I know of is a defragmenter for a multi-threaded memory
allocator, and it has to lock whole pools. When it releases these locks, it
calls yield before re-acquiring them to go back to work. The idea is to "go
to the back of the line" if any threads are blocking on those mutexes.

There are certainly other ways to do these things, but I have seen cases
where, IMO, yielding was the best solution. Doing nothing would have been
okay too.

> Fortunately, the sched_yield() API is already one of the most rarely
> used scheduler functionalities, so it does not really matter. [ In my
> experience a Linux scheduler is stabilizing pretty well when the
> discussion shifts to yield behavior, because that shows that everything
> else is pretty much fine ;-) ]

Can you explain what the current sched_yield behavior *is* for CFS and what
the tunable does to change it?

The desired behavior is for the current thread to not be rescheduled until
every thread at the same static priority as this thread has had a chance to
be scheduled.

Of course, it's not clear exactly what a "chance" is.

The semantics with respect to threads at other static priority levels is not
clear. Ditto for SMP issues. It's also not clear whether threads that yield
should be rewarded or punished for doing so.

DS


