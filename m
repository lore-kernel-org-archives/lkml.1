Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0CCPii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:38:38 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35833 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0CCPih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:38:37 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 0/5] Add multiple event support to perf report V2
Date: Wed,  3 Mar 2010 15:38:22 +0000
Message-Id: <cover.1267630395.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf report is unable to handle multiple events even though
perf record is capable of capturing such a stream.  For instance if we run
'perf record -e dtlb-misses -e cache-misses sleep 5'
today and then ask report to show the results we get:

# Samples: 18866
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
    47.52%    sleep  [kernel.kallsyms]  [k] page_fault
    32.93%    sleep  [kernel.kallsyms]  [k] locks_remove_posix
     8.52%    sleep  [kernel.kallsyms]  [k] acl_permission_check
     3.46%    sleep  [kernel.kallsyms]  [k] __wake_up_bit
     3.31%    sleep  [kernel.kallsyms]  [k] vfs_read
     3.23%    sleep  [kernel.kallsyms]  [k] kmem_cache_alloc
     0.56%    sleep  [kernel.kallsyms]  [k] get_page_from_freelist
     0.15%    sleep  [kernel.kallsyms]  [k] pipe_read
     0.13%    sleep  [kernel.kallsyms]  [k] pipe_lock_nested
     0.13%    sleep  [kernel.kallsyms]  [k] mm_alloc
     0.06%    sleep  [kernel.kallsyms]  [k] mm_init
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

Worse than only reporting on one of the events, perf report has
summed the two events. i.e. There is no distinguishing between
dtlb-misses and cache-misses.

This set of patches addresses this problem and now when perf report
is run with the same event stream that produced the above report, the
output is this:

# Samples: 8620 cache-misses
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
    72.06%    sleep  [kernel.kallsyms]  [k] locks_remove_posix
    18.64%    sleep  [kernel.kallsyms]  [k] acl_permission_check
     7.56%    sleep  [kernel.kallsyms]  [k] __wake_up_bit
     1.22%    sleep  [kernel.kallsyms]  [k] get_page_from_freelist
     0.34%    sleep  [kernel.kallsyms]  [k] pipe_read
     0.13%    sleep  [kernel.kallsyms]  [k] mm_init
     0.02%    sleep  [kernel.kallsyms]  [k] pipe_lock_nested
     0.01%    sleep  [kernel.kallsyms]  [k] mm_alloc
     0.01%    sleep  [kernel.kallsyms]  [k] kmem_cache_alloc


# Samples: 10246 dTLB-load-misses
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
    87.51%    sleep  [kernel.kallsyms]  [k] page_fault
     6.10%    sleep  [kernel.kallsyms]  [k] vfs_read
     5.94%    sleep  [kernel.kallsyms]  [k] kmem_cache_alloc
     0.22%    sleep  [kernel.kallsyms]  [k] mm_alloc
     0.22%    sleep  [kernel.kallsyms]  [k] pipe_lock_nested


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

Changlog:
>From V1:
-Removed STREAM_ID from recorded attributes
-Only record SAMPLE_ID if more than one event is requested

Eric B Munson (5):
  Add ID and to recorded event data when recording multiple events
  Change add_hist_entry to take the tree root instead of session
  Add storage for seperating event types in report
  Change perf_session post processing functions to take histogram tree
  Add multiple event support to perf report

 tools/perf/builtin-annotate.c |    6 +-
 tools/perf/builtin-diff.c     |   12 +++--
 tools/perf/builtin-record.c   |    3 +
 tools/perf/builtin-report.c   |  111 ++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/event.h       |    9 +++
 tools/perf/util/hist.c        |   45 +++++++++--------
 tools/perf/util/hist.h        |   12 +++--
 tools/perf/util/session.c     |    1 +
 tools/perf/util/session.h     |    1 +
 9 files changed, 153 insertions(+), 47 deletions(-)

