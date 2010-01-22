Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619Ab0AVNlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0AVNlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242Ab0AVNjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:39:22 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62753 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0AVNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:39:20 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 00/12] perf lock: New subcommand "perf lock", for analyzing lock statistics
Date: Fri, 22 Jan 2010 22:39:01 +0900
Message-Id: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new subcommand "perf lock" to perf.

I made this patch series on
latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
so please apply this series to perf/core.

Sorry for my slow work, Frederic and Ingo.
I have a lot of rest ToDos,
but finally perf lock can provide minimal functions for analyzing lock statistics.

This patch series has a serious problem,
this have to revert f5a2c3dce03621b55f84496f58adc2d1a87ca16f to work.

   ... Quoting description at 12/12 ...
This patch is required for making "perf lock rec" work.
The commit f5a2c3dce0 changes write_event() of builtin-record.c .
And changed write_event() sometimes doesn't stop with perf lock rec.

I'm researching what makes write_event() loop infinity,
and noticed that there are some events with event_t->header.size == 0.
But the detail of the problem,
like kind of these events, isn't clear...

If you know something related to this problem,
could you tell me, Arnaldo?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

Hitoshi Mitake (12):
  perf tools: Add __data_loc support
  perf: Add util/include/linuxhash.h to include hash.h of kernel
  lockdep: Add information of file and line where lock inited to struct
    lockdep_map
  lockdep: Add file and line to initialize sequence of spinlock
  lockdep: Add file and line to initialize sequence of rwlock
  lockdep:  Add file and line to initialize sequence of rwsem
  lockdep:  Add file and line to initialize sequence of rwsem (x86)
  lockdep: Add file and line to initialize sequence of mutex
  lockdep: Fix the way to initialize class_mutex for information of
    file and line
  perf lock: Enhance information of lock trace events
  perf lock: New subcommand "perf lock", for analyzing lock statistics
  Revert "perf record: Intercept all events"

 arch/x86/include/asm/rwsem.h        |    9 +-
 drivers/base/class.c                |    3 +-
 include/linux/lockdep.h             |   20 +-
 include/linux/mutex-debug.h         |    2 +-
 include/linux/mutex.h               |   12 +-
 include/linux/rwlock.h              |    6 +-
 include/linux/rwlock_types.h        |    6 +-
 include/linux/rwsem-spinlock.h      |   11 +-
 include/linux/spinlock.h            |    6 +-
 include/linux/spinlock_types.h      |    6 +-
 include/trace/events/lock.h         |   49 ++-
 kernel/lockdep.c                    |   10 +-
 kernel/mutex-debug.c                |    5 +-
 kernel/mutex-debug.h                |    3 +-
 kernel/mutex.c                      |    5 +-
 kernel/mutex.h                      |    2 +-
 lib/rwsem-spinlock.c                |    5 +-
 lib/rwsem.c                         |    5 +-
 lib/spinlock_debug.c                |   12 +-
 tools/perf/Makefile                 |    2 +
 tools/perf/builtin-lock.c           |  720 +++++++++++++++++++++++++++++++++++
 tools/perf/builtin-record.c         |   28 +-
 tools/perf/builtin.h                |    1 +
 tools/perf/perf.c                   |    1 +
 tools/perf/util/trace-event-parse.c |    7 +
 25 files changed, 871 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/builtin-lock.c

