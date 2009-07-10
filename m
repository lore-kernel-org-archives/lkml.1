Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZGJQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZGJQ7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZGJQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:7780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZGJQ7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777307"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 00/10] x86, PAT: PAT patchset
Date: Fri, 10 Jul 2009 09:57:31 -0700
Message-Id: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another PAT patchset. Apart from minor cleanups, there are 3
relatively big changes here.
* Adding memtype tracking to io_mapping_* APIs. Currently these APIs hardcoded
the type to WC.
* An rbtree added to keep track of PAT entries. This will avoid worst case
latency with PAT entry lookup.
* Tracking of RAM pages using 2 bits in page struct. This will give us the
ability to lookup the type of any physical address.

This patchset covers almost all the items in our PAT todo list, except for:
* Make PAT APIs to take try MTRR setup internally when pat is disabled.
* Need a set_pages_array_wc interface.

These patches are targeted for .32 and hoping to get some extended test
until the merge upstream. I have tested this with some of my test programs
and also with regressions tests in Eric's intel-gpu-tools here
http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/

Venkatesh Pallipadi (10):
  x86, PAT: keep identity maps consistent with mmaps even when
    pat_disabled
  x86, PAT: ioremap to follow same PAT restrictions as other PAT users
  x86, PAT: New i/f for driver to request memtype for IO regions
  x86, PAT: Add PAT reserve free to io_mapping* APIs
  x86, PAT: Add rbtree to do quick lookup in memtype tracking
  x86, PAT: Generalize the use of page flag PG_uncached
  x86, PAT: Use page flags to track memtypes of RAM pages
  x86, PAT: Add lookup_memtype to get the current memtype of a paddr
  x86, PAT: lookup the protection from memtype list on vm_insert_pfn()
  x86, PAT: Sanity check remap_pfn_range for RAM region

 arch/ia64/Kconfig                 |    4 +
 arch/x86/Kconfig                  |    4 +
 arch/x86/include/asm/cacheflush.h |   54 ++++++-
 arch/x86/include/asm/iomap.h      |    9 +-
 arch/x86/include/asm/pat.h        |    5 +
 arch/x86/mm/iomap_32.c            |   27 +++-
 arch/x86/mm/ioremap.c             |   17 +--
 arch/x86/mm/pat.c                 |  352 +++++++++++++++++++++++++++----------
 include/linux/io-mapping.h        |   17 ++-
 include/linux/page-flags.h        |    4 +-
 10 files changed, 376 insertions(+), 117 deletions(-)

