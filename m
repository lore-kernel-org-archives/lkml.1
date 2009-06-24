Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbZFXNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbZFXNbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFXNap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:30:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:50444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZFXNan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:30:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       cl@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Date: Wed, 24 Jun 2009 22:30:06 +0900
Message-Id: <1245850216-31653-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 13:30:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is combination of the following two patchsets.

[1] x86,percpu: generalize 4k and lpage allocator
[2] percpu: teach lpage allocator about NUMA

Changes from the last postings are

* updated to be on top of the current percpu#for-next(bf4bb2b1)

* sparc64 was converted to dynamic percpu allocator and using
  pcpu_setup_first_chunk() which is changed by this patchset.  sparc64
  updated accordingly.

This patchset contains the following patches.

  0001-x86-make-pcpu_chunk_addr_search-matching-stricter.patch
  0002-percpu-drop-unit_size-from-embed-first-chunk-alloc.patch
  0003-x86-percpu-generalize-4k-first-chunk-allocator.patch
  0004-percpu-make-4k-first-chunk-allocator-map-memory.patch
  0005-x86-percpu-generalize-lpage-first-chunk-allocator.patch
  0006-percpu-simplify-pcpu_setup_first_chunk.patch
  0007-percpu-reorder-a-few-functions-in-mm-percpu.c.patch
  0008-percpu-drop-pcpu_chunk-page.patch
  0009-percpu-allow-non-linear-sparse-cpu-unit-mappin.patch
  0010-percpu-teach-large-page-allocator-about-NUMA.patch

0001-0006 generalizes first chunk allocators.  0007-0010 improves
lpage allocator such that NUMA is handled more intelligently.

This patchset first generalizes first chunk allocators, makes the
percpu allocator to be able to use non-linear and/or sparse cpu ->
unit mapping and then make lpage allocator consider CPU topology and
group CPUs in LOCAL_DISTANCE into the same large pages.  For example,
on an 4/4 NUMA machine, the original code used up 16MB for each chunk
but the new code uses only 4MB - one large page for each NUMA node.
The grouping code is quite robust and will try to minimize space
wastage even when the CPU topology is asymmetric.

David, sparc64 should be able to use lpage (renamed from remap)
allocator the same way x86_64 does.  Well, at least that was my
intention, if something doesn't work or needs improvements for
sparc64, please let me know.

This patchset is available in the following git tree and will be
published in for-next if there's no major objection.  It might get
rebased before going into for-next.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git lpage-numa

diffstat follows.

 arch/sparc/kernel/smp_64.c     |   42 -
 arch/x86/include/asm/percpu.h  |    9 
 arch/x86/kernel/setup_percpu.c |  297 ++-------
 arch/x86/mm/pageattr.c         |    1 
 include/linux/percpu.h         |   68 +-
 mm/percpu.c                    | 1276 +++++++++++++++++++++++++++++++----------
 6 files changed, 1139 insertions(+), 554 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/853114
[2] http://lkml.org/lkml/2009/6/17/14
