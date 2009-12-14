Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZLNMNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZLNMNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZLNMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:12:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52385 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbZLNMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:12:57 -0500
Date: Mon, 14 Dec 2009 13:12:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] Please pull hwpoison updates for 2.6.33
Message-ID: <20091214121247.GA10160@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

Please pull the hwpoison updates for 2.6.33 from

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

This touches some code outside hwpoison,  like the page flags
reporting code and some fixes for memcg to implement the memcg hwpoison
filter.  All these changes are straight-forward, and have been reviewed.

Major new features:
- "soft offline" Offline a page without killing a process.
This allows to implement predictive failure analysis for memory, by
watching error trends per page and offlining a page that has too many
corrected errors.  The policy is all in user space; the kernel just 
offlines the page and reports the errors.
The current git mcelog has support for using this interface.
- Be more aggressive at flushing caches to get access to a page
- Various fixes for the core memory_failure path
- Handle free memory better by detecting higher-order buddy pages
reliably too.
- Provide a new sysfs interface for both hard and soft offlining.
The existing debugfs interface is still there.
- unpoison support
Unpoison a page. This is mainly for testing to let the stress tester
run longer.
- hwpoison filter
Various filters to the hwpoison PFN error injection, including 
memcg, page type, block device and others.
This is used by the mce-test stress suite to protect the test suite itself

Testing:
There are test cases for soft offlining in mce-test.

Andi Kleen (12):
      HWPOISON: Add Andi Kleen as hwpoison maintainer to MAINTAINERS
      HWPOISON: Be more aggressive at freeing non LRU caches
      HWPOISON: Turn ref argument into flags argument
      HWPOISON: add memory cgroup filter
      HWPOISON: Use get_user_page_fast in hwpoison madvise
      HWPOISON: mention HWPoison in Kconfig entry
      HWPOISON: Use correct name for MADV_HWPOISON in documentation
      HWPOISON: Use new shake_page in memory_failure
      HWPOISON: Undefine short-hand macros after use to avoid namespace conflict
      HWPOISON: Add soft page offline support
      HWPOISON: Add a madvise() injector for soft page offlining
      HWPOISON: Don't do early filtering if filter is disabled

Haicheng Li (1):
      HWPOISON: add an interface to switch off/on all the page filters

Wu Fengguang (19):
      page-types: add standard GPL license header
      HWPOISON: remove the anonymous entry
      HWPOISON: return ENXIO on invalid page number
      HWPOISON: avoid grabbing the page count multiple times during madvise injection
      HWPOISON: abort on failed unmap
      HWPOISON: comment the possible set_page_dirty() race
      HWPOISON: comment dirty swapcache pages
      HWPOISON: introduce delete_from_lru_cache()
      HWPOISON: remove the free buddy page handler
      HWPOISON: detect free buddy pages explicitly
      HWPOISON: Add unpoisoning support
      HWPOISON: make semantics of IGNORED/DELAYED clear
      HWPOISON: return 0 to indicate success reliably
      HWPOISON: add fs/device filters
      HWPOISON: limit hwpoison injector to known page types
      mm: export stable page flags
      HWPOISON: add page flags filter
      memcg: rename and export try_get_mem_cgroup_from_page()
      memcg: add accessor to mem_cgroup.css

 .../ABI/testing/sysfs-memory-page-offline          |   44 ++
 Documentation/vm/hwpoison.txt                      |   52 ++-
 Documentation/vm/page-types.c                      |   15 +-
 MAINTAINERS                                        |    9 +
 drivers/base/memory.c                              |   61 +++
 fs/proc/page.c                                     |   45 +--
 include/asm-generic/mman-common.h                  |    1 +
 include/linux/kernel-page-flags.h                  |   46 ++
 include/linux/memcontrol.h                         |   13 +
 include/linux/mm.h                                 |    8 +-
 include/linux/page-flags.h                         |    4 +-
 mm/Kconfig                                         |    3 +-
 mm/hwpoison-inject.c                               |  113 ++++-
 mm/internal.h                                      |   12 +
 mm/madvise.c                                       |   21 +-
 mm/memcontrol.c                                    |   16 +-
 mm/memory-failure.c                                |  558 ++++++++++++++++++--
 mm/memory.c                                        |    4 +
 mm/page_alloc.c                                    |   21 +
 19 files changed, 921 insertions(+), 125 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-memory-page-offline
 create mode 100644 include/linux/kernel-page-flags.h
-- 
ak@linux.intel.com -- Speaking for myself only.
