Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZDQGgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZDQGgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDQGfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:35:45 -0400
Received: from gw.goop.org ([64.81.55.164]:36609 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751942AbZDQGfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:35:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing WIP patches
Date: Thu, 16 Apr 2009 23:35:35 -0700
Message-Id: <1239950139-1119-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the patches I have against the tip/tracing/core.  They
consist of:

- Move __DO_TRACE out of line, so that the inline code is just an
  if() and a call.  This reduces linux/tracepoint.h's include dependencies
  to just <linux/types.h>, which means its safe to include in any context
  at all.

- Remove the use of the global CREATE_TRACE_POINTS, and institute
  a set of CREATE_subsys_TRACE_POINTS variables to cause targeted
  instantiation of the tracepoint code and data.  Without this
  we end up in the situation where one
	#define CREATE_TRACE_POINTS
	#include <trace/events/foo.h>
  instantiates not only foo's events but also bar's, if foo.h ends
  up directly or indirectly including trace/events/bar.h
  Unfortunately it increases the amount of boilerplace in each
  events definition header by a bit.

- A followup, ot make out-lining __do_trace_##name work for
  direct users of DECLARE_TRACE/DEFINE_TRACE, as DEFINE_TRACE now needs
  a full arg and proto list.  This results if fairly ugly wholesale
  duplication of each tracepoint's arg lists.  This can be avoided if
  we migrate those users to use TRACE_EVENT(), etc.

I'll post my pvops patches for comment in a moment.  Unfortunately, even
with all this, I can't get the kernel to link due to duplicate kmem.h
events...

	J

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +-
 arch/x86/kernel/process.c                  |    9 +++-
 block/blk-core.c                           |   56 +++++++++++++++++++++++------
 block/elevator.c                           |   13 +++++-
 drivers/md/dm.c                            |    4 +-
 fs/bio.c                                   |    4 +-
 include/linux/tracepoint.h                 |   33 +++++++++--------
 include/trace/define_trace.h               |   10 ++---
 include/trace/events/irq.h                 |    5 ++
 include/trace/events/kmem.h                |    5 ++
 include/trace/events/lockdep.h             |    5 ++
 include/trace/events/sched.h               |    5 ++
 include/trace/events/skb.h                 |    6 +++
 include/trace/ftrace.h                     |    4 +-
 include/trace/instantiate_trace.h          |    7 +++
 kernel/irq/handle.c                        |    2 -
 kernel/lockdep.c                           |    2 -
 kernel/sched.c                             |    2 -
 kernel/tracepoint.c                        |    6 +++
 kernel/workqueue.c                         |   16 ++++++--
 mm/bounce.c                                |    4 +-
 mm/util.c                                  |    2 -
 net/core/net-traces.c                      |    2 -
 samples/trace_events/trace-events-sample.c |    2 -
 samples/trace_events/trace-events-sample.h |    6 +++
 25 files changed, 162 insertions(+), 52 deletions(-)

