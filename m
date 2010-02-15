Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0BOWUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:20:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab0BOWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:20:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Y7vVpGLhVv81NemK6DFZpeB1LNcm36+5v07BuuL58UAOGflKwMIhcbnEgORVhYMuk
	TDZZtQgcuOvutRhAHN68A==
Date: Mon, 15 Feb 2010 14:19:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch -mm 0/9 v2] oom killer rewrite
Message-ID: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a rewrite of the out of memory killer to address several
issues that have been raised recently.  The most notable change is a
complete rewrite of the badness heuristic that determines which task is
killed; the goal was to make it as simple and predictable as possible
while still addressing issues that plague the VM.

Changes from version 1:

 - updated to mmotm-2010-02-11-21-55

 - when iterating the tasklist for mempolicy-constrained oom conditions,
   the node of the cpu that a MPOL_F_LOCAL task is running on is now
   intersected with the page allocator's nodemask to determine whether it
   should be a candidate for oom kill.

 - added: [patch 4/9] oom: remove compulsory panic_on_oom mode

 - /proc/pid/oom_score_adj was added to prevent ABI breakage for
   applications using /proc/pid/oom_adj.  /proc/pid/oom_adj may still be
   used with the old range but it is then scaled to oom_score_adj units
   for a rough linear approximation.  There is no loss in functionality
   from the old interface.

 - added: [patch 6/9] oom: deprecate oom_adj tunable

This patchset is based on mmotm-2010-02-11-21-55 because of the following
dependencies:

	[patch 5/9] oom: badness heuristic rewrite:
		mm-count-swap-usage.patch

	[patch 7/9] oom: replace sysctls with quick mode:
		sysctl-clean-up-vm-related-variable-delcarations.patch

To apply to mainline, download 2.6.33-rc8 and apply

	mm-clean-up-mm_counter.patch
	mm-avoid-false-sharing-of-mm_counter.patch
	mm-avoid-false_sharing-of-mm_counter-checkpatch-fixes.patch
	mm-count-swap-usage.patch
	mm-count-swap-usage-checkpatch-fixes.patch
	mm-introduce-dump_page-and-print-symbolic-flag-names.patch
	sysctl-clean-up-vm-related-variable-declarations.patch
	sysctl-clean-up-vm-related-variable-declarations-fix.patch

from http://userweb.kernel.org/~akpm/mmotm/broken-out.tar.gz first.
---
 Documentation/feature-removal-schedule.txt |   30 +
 Documentation/filesystems/proc.txt         |  100 +++---
 Documentation/sysctl/vm.txt                |   71 +---
 fs/proc/base.c                             |  106 ++++++
 include/linux/mempolicy.h                  |   13 
 include/linux/oom.h                        |   24 +
 include/linux/sched.h                      |    3 
 kernel/fork.c                              |    1 
 kernel/sysctl.c                            |   15 
 mm/mempolicy.c                             |   39 ++
 mm/oom_kill.c                              |  479 ++++++++++++++---------------
 mm/page_alloc.c                            |    3 
 12 files changed, 553 insertions(+), 331 deletions(-)
