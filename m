Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZGUK2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZGUK2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZGUK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:37115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbZGUK2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:12 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Subject: [PATCHSET percpu#for-next] implement and use sparse embedding first chunk allocator
Date: Tue, 21 Jul 2009 19:25:59 +0900
Message-Id: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset teaches percpu allocator how to manage very sparse
units, vmalloc how to allocate congruent sparse vmap areas and combine
them to extend the embedding allocator to allow embedding of sparse
unit addresses.  This basically implements Christoph's sparse
congruent allocator.

This allows NUMA configurations to use bootmem allocated memory
directly as non-NUMA machines do with the embedding allocator.
Setting up the first chunk is basically consisted of allocating memory
for each cpu and then build percpu configuration to so that the first
chunk is composed of those memory areas, which means that there can be
huge holes between units and chunks may overlap each other.

When further chunks are necessary pcpu_get_vm_areas() is called with
parameters to specify how many areas are necessary, how large each
should be and how apart they're from each other.  The function scans
vmalloc address space top down looking for matching holes and returns
array of vmap areas.  As the newly allocated areas are offset exactly
the same as the first chunk, the rest is pretty straight-forward.

This has the following benefits.

* No special remapping necessary.  Arch codes don't need change its
  address mapping or anything.  It just needs to inform percpu
  allocator how percpu areas ends up like.  percpu allocator will
  take any layout.

* No additional TLB pressure.  Both page and large page remapping adds
  TLB pressure.  With embedding, there's no overhead.  Whatever
  translations being used for linear mapping is used as-is.

* Removes dup-mapping.  Large page remapping ends up mapping the same
  page twice.  This causes subtle problem on x86 when page attribute
  needs to be changed.  The maps need to be looked up and split into
  page mappings, which is a bit fragile.  As embedding doesn't remap
  anything, this problem doesn't exist.

The only restriction is that the vmalloc area needs to be huge - at
least orders of magnitude larger than the distances between NUMA
nodes.  For 64bit machines, this isn't a problem but on 32bit NUMA
machines address space is a scarce resource.  For x86_32 NUMAs, the
page mapping allocator is used.  The reason for choosing page over
large page is because page is far simpler and the advantage of large
page isn't very clear.

 0001-percpu-fix-pcpu_reclaim-locking.patch
 0002-percpu-improve-boot-messages.patch
 0003-percpu-rename-4k-first-chunk-allocator-to-page.patch
 0004-percpu-build-first-chunk-allocators-selectively.patch
 0005-percpu-generalize-first-chunk-allocator-selection.patch
 0006-percpu-drop-static_size-from-first-chunk-allocator.patch
 0007-percpu-make-dyn_size-mandatory-for-pcpu_setup_firs.patch
 0008-percpu-add-align-to-pcpu_fc_alloc_fn_t.patch
 0009-percpu-move-pcpu_lpage_build_unit_map-and-pcpul_l.patch
 0010-percpu-introduce-pcpu_alloc_info-and-pcpu_group_inf.patch
 0011-percpu-add-pcpu_unit_offsets.patch
 0012-percpu-add-chunk-base_addr.patch
 0013-vmalloc-separate-out-insert_vmalloc_vm.patch
 0014-vmalloc-implement-pcpu_get_vm_areas.patch
 0015-percpu-use-group-information-to-allocate-vmap-areas.patch
 0016-percpu-update-embedding-first-chunk-allocator-to-ha.patch
 0017-x86-percpu-use-embedding-for-64bit-NUMA-and-page-fo.patch
 0018-percpu-kill-lpage-first-chunk-allocator.patch
 0019-sparc64-use-embedding-percpu-first-chunk-allocator.patch
 0020-powerpc64-convert-to-dynamic-percpu-allocator.patch

0001 fixes locking bug on reclaim path which was introduced by
2f39e637ea240efb74cf807d31c93a71a0b89174.

0002-0007 are misc changes.  4k allocator is renamed to page.
Messages are made prettier and more informative.  Avoid building
unused first chunk allocators and so on.  Nothing really drastic but
small cleanups to ease further changes.

0008-0009 prepares for later changes.  @align is added to
pcpu_fc_alloc and functions are relocated.

0010 changes how first chunk configuration is passed to
pcpu_setup_first_chunk().  All information is collected into
pcpu_alloc_info struct including the unit grouping information which
used to be lost in the process.  This change allows percpu allocator
to have enough information to allocate congruent vmap areas.

0011-0012 prepares percpu for sparse groups and units in them.  offset
information is added and used to calculate addresses.

0013-0014 implement pcpu_get_vm_areas() which allocate congruent vmap
areas.

0015-0016 teaches percpu how to use multiple vm areas to allow sparse
groups and extends embedding allocator so that it knows how to embed
sparse areas.

0017 converts x86_64 NUMA to use embedding and x86_32 NUMA page.

0018 kills now unused lpage allocator and the related page attribute
code.

0019 converts sparc64 to use embedding allocator.

0020 converts powerpc64 to dynamic percpu allocator using embedding
allocator.

After this series, only ia64 is left with the static allocator.  I
have the patch but don't have machine to verify it on.  Will post as
RFC patch.

This patchset is on top of

 linus#master (aea1f7964ae6cba5eb419a958956deb9016b3341)
 + [1] perpcu-fix-sparse-possible-cpu-map-handling patchset
 + pulled into percpu#for-next (457f82bac659745f6d5052e4c493d92d62722c9c)

and available in the following git tree.  Please note that the
following tree is temporary and will be rebased.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review

Diffstat follows.  Only 112 lines added.  :-)

 Documentation/kernel-parameters.txt |   11 
 arch/powerpc/Kconfig                |    4 
 arch/powerpc/kernel/setup_64.c      |   61 +
 arch/sparc/Kconfig                  |    3 
 arch/sparc/kernel/smp_64.c          |  124 ---
 arch/x86/Kconfig                    |    6 
 arch/x86/kernel/setup_percpu.c      |  201 +-----
 arch/x86/mm/pageattr.c              |   20 
 include/linux/percpu.h              |  105 +--
 include/linux/vmalloc.h             |    6 
 mm/percpu.c                         | 1139 +++++++++++++++++-------------------
 mm/vmalloc.c                        |  338 ++++++++++
 12 files changed, 1065 insertions(+), 953 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/867587
