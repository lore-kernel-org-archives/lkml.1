Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZIWFG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZIWFG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 01:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZIWFGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 01:06:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:60371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZIWFGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 01:06:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic percpu and drop the old one, take#2
Date: Wed, 23 Sep 2009 14:06:17 +0900
Message-Id: <1253682382-24740-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 05:06:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the second take of convert-ia64-to-dynamic-percpu patchset.
Changes from the last take[L] are

* 0001 now updates ia64 to not define VMALLOC_END as a macro to
  vmalloc_end instead of disallowing vmalloc_end as a variable name as
  suggested by Christoph.

* 0002 added to initialize cpu maps early.  This is necessary to get
  contig memory model working.

* 0004 updated so that dyn_size is calculated correctly for contig
  model.

This patchset contains the following five patches.

 0001-ia64-don-t-alias-VMALLOC_END-to-vmalloc_end.patch
 0002-ia64-initialize-cpu-maps-early.patch
 0003-ia64-allocate-percpu-area-for-cpu0-like-percpu-areas.patch
 0004-ia64-convert-to-dynamic-percpu-allocator.patch
 0005-percpu-kill-legacy-percpu-allocator.patch

0001 is misc prep to avoid macro / local variable collision.  0002
makes ia64 arch code initialize cpu possible and present maps before
memory initialization.  0003 makes ia64 allocate percpu area for cpu0
in the same way it does for other cpus.  0004 converts ia64 to dynamic
percpu allocator and 0005 drops now unused legacy allocator.

Contig memory model was tested on a 16p Tiger4 machine.  Discontig and
sparse tested on 4-way SGI altix.  ski seems to be happy with contig
up/smp.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git convert-ia64

The new commit ID is dcc91f19c6662b24f1f4e5878d773244f1079724 and it's
on top of today's Linus 7fa07729e439a6184bd824746d06a49cca553f15.

Thanks.

 arch/ia64/Kconfig              |    3 
 arch/ia64/kernel/setup.c       |   12 --
 arch/ia64/kernel/vmlinux.lds.S |   11 +-
 arch/ia64/mm/contig.c          |   87 ++++++++++++++++----
 arch/ia64/mm/discontig.c       |  120 +++++++++++++++++++++++++--
 include/linux/percpu.h         |   24 -----
 kernel/module.c                |  150 ----------------------------------
 mm/Makefile                    |    4 
 mm/allocpercpu.c               |  177 -----------------------------------------
 mm/percpu.c                    |    2 
 mm/vmalloc.c                   |   16 +--
 11 files changed, 193 insertions(+), 413 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.ports.ia64/20812
