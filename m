Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311Ab0AZWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0AZWRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969Ab0AZWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:17:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0AZWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=0jSYshFzokIA:10 a=VwQbUJbxAAAA:8 a=FSsOwSkDrWw3f6DzWBIA:9 a=WVzGUYmIzSFy6FH4mmQA:7 a=EYWhc0pbrkeGckKt5V4wIys9V2AA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126220923.534282809@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5][GIT PULL][v2.6.33] tracing: fixes and documentation updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I found that reading the trace file and the raw_trace_pipe using
splice, at the same time could cause a kernel oops. Not a major one,
that is, the oops only crashes the user task that is performing
the read of the trace file. But still urgent enough to go into
2.6.33.

The issue is with the iterator that is stored to access multiple
reads of the ring buffer without consuming the data. If a user
process starts reading the contents of the ring buffer with the
iterator, and in the mean time a consuming read is done, then
the iterator can become stale and return a bogus entry.

The first patch fixes the pid to cmdline mapping function to not
crash when given a negative pid (which happened when we had a
bogus entry).

The next two patches fix the ring buffer to detect when a consuming
read is done and to reset the iterator.

Since I'm pushing these patches up, I've also incuded two
documentation changes. One of the patches touches a Kconfig file
but only the help portion of it.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Mike Frysinger (1):
      tracing/documentation: Cover new frame pointer semantics

Steven Rostedt (3):
      tracing: Prevent kernel oops with corrupted buffer
      ring-buffer: Check if ring buffer iterator has stale data
      ring-buffer: Check for end of page in iterator

Yang Hongyang (1):
      tracing/documentation: Fix a typo in ftrace.txt

----
 Documentation/trace/ftrace-design.txt |   26 +++++++++++++++++++++++---
 Documentation/trace/ftrace.txt        |    2 +-
 kernel/trace/Kconfig                  |    4 +---
 kernel/trace/ring_buffer.c            |   24 +++++++++++++++++++++---
 kernel/trace/trace.c                  |    5 +++++
 5 files changed, 51 insertions(+), 10 deletions(-)

