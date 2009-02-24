Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZBXDNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZBXDNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbZBXDNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:58437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbZBXDNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:01 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: [PATCHSET x86/core/percpu] improve the first percpu chunk allocation
Date: Tue, 24 Feb 2009 12:11:31 +0900
Message-Id: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset improves the first percpu chunk allocation.  The problem
is that the dynamic percpu area allocation maps the whole percpu area
into vmalloc area using 4k mappings which adds considerable amount of
TLB pressure.

This patchset modularizes the first percpu chunk allocation and uses
different allocation schemes to optimize TLB usage.

* On !NUMA, the first chunk is allocated directly using
  alloc_bootmem() thus adding no TLB pressure whatsoever.

* On NUMA, the first chunk is remapped using large pages and whatever
  is left in the large page is given back to the bootmem allocator.
  This makes each cpu use an additional large TLB entry for the first
  chunk but still is much better than using many 4k TLB entries.

This patchset contains the following ten patches.

  0001-percpu-fix-pcpu_chunk_struct_size.patch
  0002-bootmem-clean-up-arch-specific-bootmem-wrapping.patch
  0003-bootmem-reorder-interface-functions-and-add-a-missi.patch
  0004-vmalloc-add-align-to-vm_area_register_early.patch
  0005-x86-update-populate_extra_pte-and-add-populate_ex.patch
  0006-percpu-remove-unit_size-power-of-2-restriction.patch
  0007-percpu-give-more-latitude-to-arch-specific-first-ch.patch
  0008-x86-separate-out-setup_pcpu_4k-from-setup_per_cpu.patch
  0009-x86-add-embedding-percpu-first-chunk-allocator.patch
  0010-x86-add-remapping-percpu-first-chunk-allocator.patch

0001 fixes a bug introduced by earlier patch.  0002-0006 prepares for
better first chunk allocation.  0007 updates make percpu allocator
initialization more flexible.  0008-0010 modularizes and adds better
allocation schemes for x86.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Diffstat follows.

 arch/alpha/mm/init.c             |    2 
 arch/avr32/Kconfig               |    2 
 arch/x86/Kconfig                 |    2 
 arch/x86/include/asm/mmzone_32.h |   43 ----
 arch/x86/include/asm/pgtable.h   |    3 
 arch/x86/kernel/setup_percpu.c   |  373 ++++++++++++++++++++++++++++++++++-----
 arch/x86/mm/init_32.c            |   13 +
 arch/x86/mm/init_64.c            |   75 ++++---
 include/linux/bootmem.h          |   36 +--
 include/linux/percpu.h           |   39 +++-
 include/linux/vmalloc.h          |    2 
 mm/bootmem.c                     |   14 +
 mm/percpu.c                      |  178 +++++++++++++-----
 mm/vmalloc.c                     |   11 -
 14 files changed, 607 insertions(+), 186 deletions(-)

Thanks.

--
tejun
