Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0BJQcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:32:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0BJQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:32:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=xd5a8HBLRmULJ6/EXpvQQap0HpT5KJjzrmTgrkFEx/BxRdVz85NlFHtz/zIQ0qJU+
	GB7PKzr+5+Ex9bi3pbh2Q==
Date: Wed, 10 Feb 2010 08:32:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/7 -mm] oom killer rewrite
Message-ID: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
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

This patchset is based on mmotm-2010-02-05-15-06 because of the following
dependencies:

	[patch 4/7] oom: badness heuristic rewrite:
		mm-count-swap-usage.patch

	[patch 5/7] oom: replace sysctls with quick mode:
		sysctl-clean-up-vm-related-variable-delcarations.patch

To apply to mainline, download 2.6.33-rc7 and apply

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
 Documentation/filesystems/proc.txt |   78 ++++---
 Documentation/sysctl/vm.txt        |   51 ++---
 fs/proc/base.c                     |   13 +-
 include/linux/mempolicy.h          |   13 +-
 include/linux/oom.h                |   18 +-
 kernel/sysctl.c                    |   15 +-
 mm/mempolicy.c                     |   39 +++
 mm/oom_kill.c                      |  455 +++++++++++++++++++-----------------
 mm/page_alloc.c                    |    3 +
 9 files changed, 383 insertions(+), 302 deletions(-)
