Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbYJAEje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbYJAEje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 00:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYJAEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 00:39:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYJAEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 00:39:10 -0400
Message-Id: <20081001042951.412019606@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 00:29:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 0/2] ring_buffer: updates for linux-tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch is just a lockdep clean up of the ring buffer.

The next patch is a new locking design. It is not lockless (yet) but
the locking is a bit cleaner than the original. The basic idea is
that the reader now has its own page to read from that is not in
the ring buffer. When the reader (a consumer) finishes a page, it
then grabs a lock to pull out a new page from the ring buffer and
replace it with the one that it just finished reading.

The writer only locks when it needs to go to the next page. We still
disable interrupts, but it would not be too hard to allow
interrupts to take place on writes. But I will leave that for
version 2 (or 1.2)

The iterator (non consuming read) still expects the tracer to
be disabled when iterating the loop (no locks taken).

The ring_buffer_{un}lock is now no longer around and not needed.

I ran this with lockdep on and it ran fine.

I did lots of testing of trace_pipe (consuming reader) while running
the function trace. The function trace with out a doubt will stress
the consumer/producer reads since the producer is much faster than the
consumer.

Tomorrow, I'll change the buffer_page from being a page_frame to
something that is allocated separately.

-- Steve

