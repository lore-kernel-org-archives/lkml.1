Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbZENMua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbZENMua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZENMuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:50:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbZENMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:50:15 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
Date: Thu, 14 May 2009 21:49:46 +0900
Message-Id: <1242305390-21958-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 12:49:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr

This patchset fixes subtile bug in pageattr handling when remap percpu
first chunk allocator is in use and implements percpu_alloc kernel
parameter so that allocator can be selected from boot prompt.

This problem was spotted by Jan Beulich.

The remap allocator allocates a PMD page per cpu, returns whatever is
unnecessary to the page allocator and remaps the PMD page into vmalloc
area to construct the first percpu chunk.  This is to take advantage
of large page mapping.  However this creates active aliases for the
recycled pages.  When some user allocates the recycled pages and tries
to change pageattr on it, remapped PMD alias might end up having
different attributes with the regular page mapped addresses which can
lead to subtle data corruption according to Andi.

Similar problem exists for the high mapped area of x86_64 kernel which
is handled by detecting the alias and splitting up the high map PMD
and applying the same attributes there.  This patch implements the
same workaround for remapped first chunk.

Also, it's still unclear whether the remap allocator is worth the
trouble.  Andi thinks it would be better to simply use 4k mapping on
NUMA machines as PMD TLB is much more precious resource than PTE TLB.
To ease testing, this patch implements percpu_alloc kernel parameter
which allows explicitly selecting which allocator to use.

This patchset contains the following four patches.

 0001-x86-prepare-setup_pcpu_remap-for-pageattr-fix.patch
 0002-x86-simplify-cpa_process_alias.patch
 0003-x86-fix-pageattr-handling-for-remap-percpu-allocato.patch
 0004-x86-implement-percpu_alloc-kernel-parameter.patch

0001-0002 preps for pageattr fix.  0003 fixes the pageattr bug.  0004
implements percpu_alloc kernel parameter.

This patchset is on top of the current linux-2.6#master
(210af919c949a7d6bd330916ef376cec2907d81e) and contains the following
changes.

 Documentation/kernel-parameters.txt |    6 +
 arch/x86/include/asm/percpu.h       |    9 +
 arch/x86/kernel/setup_percpu.c      |  186 ++++++++++++++++++++++++++----------
 arch/x86/mm/pageattr.c              |   59 +++++++----
 mm/percpu.c                         |   13 +-
 5 files changed, 197 insertions(+), 76 deletions(-)

Thanks.

--
tejun
