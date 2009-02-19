Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZBSDia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZBSDia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZBSDiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:38:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZBSDiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:38:21 -0500
Message-Id: <20090219033531.360862326@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 18 Feb 2009 22:35:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [git pull] tip updates for 2.6.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I found the cause of the hard lock up you were seeing. It is one
of those cases where a new patch does not create a bug, but unveils
one. The change that showed the bug was:

e68746a: ftrace: enable filtering only when a function is filtered on

The bug was there all along, but his change revealed it. There were
two bugs actually.

1) The function tracer is useless without KALLSYMS. Without KALLSYMS
   you will only get hex values for your funtion traces.
   This also totally breaks the dynamic function tracer. It depends
   on having names to compare to select functions.

2) In the self test, there is a while loop that consumes the buffer
  and will not end until the buffer is empty. If we still have a
  producer present, this becomes an infinite loop.

The above two bugs are needed for the lock up, as well as the
mentioned patch.  Without the patch, the function filter is activated
whenever we pass in a filter, even if we do not select any function.
The patch changes that to only activate the filter if we succeed in
selecting a function.

Back to the bugs.

Without KALLSYMS, we never select a function, but we still activate
the filter. This causes all functions to be disabled from tracing.
The dynamic ftrace self test fails because it never sees the selected
function get traced.

With the patch and without KALLSYMS selected, we now do not activate
the filter, because no function was selected (all compares of a given
name to a NULL pointer will fail).  Now all functions are still enabled
to be traced.

So, what happens?  The dynamic function tracer self test will call
the test routine while the tracer is still on. The self test will
start consuming all the cpu ring buffers to test them, and will not
end until they are all finished. But you also have RCU_TORTURE selected.
The RCU torture test will run, filling up the ring buffer on other
CPUS. The consumer will never catch up, and we run forever!

Both of these are true bugs that have been in ftrace for a long time.
I think they are candidates for getting in 29, even this late in
the game. You never know what other config combination can hit these
bugs.

The fixes are simple. One is to simply disable the ring buffer
while the consumer runs. This prevents any producer from keeping
the consumer from finishing. The other is to make the function
tracer select KALLSYMS.

And yes, this was a bitch to debug. This was all I did today :-(

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (2):
      tracing: disable tracing while testing ring buffer
      tracing: have function trace select kallsyms

----
 kernel/trace/Kconfig          |    2 ++
 kernel/trace/trace_selftest.c |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)
-- 
