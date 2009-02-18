Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbZBRMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbZBRMGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZBRMFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:50723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZBRMFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:33 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Date: Wed, 18 Feb 2009 21:04:26 +0900
Message-Id: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:04:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset implements dynamic percpu allocator.  As I wrote before,
the percpu areas are organized in chunks which in turn are composed of
num_possible_cpus() units.  As offsets of units against the first unit
stay the same regardless of where the chunk is, arch code can directly
access each percpu area by setting up percpu access such that each cpu
translates the same percpu address unit size apart.

Statically declared percpu area for the kernel which is setup early
during boot is also served by the same allocator but it needs special
init path as it needs to be up and running way before regular memory
management is initialized.

Percpu areas are allocated from the vmalloc space and managed directly
by the percpu code.  Chunks start empty and are populated with pages
as they're allocated.  As there are many small allocations and
allocations often need much smaller alignment (no need for cacheline
alignment), the allocator tries to maximize chunk utilization and put
allocations in fuller chunks.

There have been several concerns regarding this approach.

* On 64bit, no need for chunks.  We can just allocate contiguous
  areas.

  For 32bit, with the overcrowded address space, consolidating percpu
  allocations into vmalloc (or other) area is a big win as no space
  needs to be further set aside for percpu variables and with
  relatively small number of possible cpus, the chunks can be at
  manageable size (e.g. 128k chunks for 4way smp wouldn't be too bad)
  and it can achieve reasonable scalability.

  So, I think the question becomes whether it makes sense to use
  different allocation scheme for 32 and 64bits.  The added overhead
  of chunk handling itself isn't anything which can warrant separate
  implementations.  If there's a way to solve some other issues nicely
  with larger address space, maybe, but I really think it would be
  best to stick with one implementation.

* It adds to TLB pressure.

  Yeah, unfortunately, it does.  Currently it adds a number of kernel
  4k pages into circulation (cold/high pages, so unlikely to affect
  other large mappings).  There are several different varieties of
  this issue.

  The unit size and thus the chunk size is pretty flexible (it
  currently requires power of 2 but that restriction can be lifted
  easily).  With vm area allocation with larger alignment, using large
  page for chunk (non-NUMA) or unit (large, large NUMA) shouldn't be
  too difficult for highends but for mid range stuff, it looks like
  there isn't much else to do than sticking with 4k mappings.

  The TLB pressure problem would be there regardless of address layout
  as long as we want to grow the percpu area dynamically.
  Page-granual growth will add 4k pressures.  Large-page-granuality is
  likely to waste lots of space.

  One trick we can do is to reserve the initial chunk in non-vmalloc
  area so that at least the static cpu ones and whatever gets
  allocated in the first chunk is served by regular large page
  mappings.  Given that those are most frequent visited ones, this
  could be a nice compromise - no noticeable penalty for usual cases
  yet allowing scalability for unusual cases.  If this is something
  which can be agreed on, I'll pursue this.

The percpu allocator is optional feature which can be selected by each
arch by setting HAVE_DYNAMIC_PER_CPU_AREA configuration variable.
Currently only x86_32 an 64 use it.

Ah.. I also left out cpu hotplugging stuff for now.  This largely
isn't an issue on most machines where num_possible_cpus() doesn't
deviate much from num_online_cpus().  Are there cases where this is
critical?  Currently, no user of percpu allocation, static or dynamic,
cares about this and it has been like this for a long time, so I'm a
little bit skeptical about it.

This patchset contains the following ten patches.

  0001-vmalloc-call-flush_cache_vunmap-from-unmap_kernel.patch
  0002-module-fix-out-of-range-memory-access.patch
  0003-module-reorder-module-pcpu-related-functions.patch
  0004-alloc_percpu-change-percpu_ptr-to-per_cpu_ptr.patch
  0005-alloc_percpu-add-align-argument-to-__alloc_percpu.patch
  0006-percpu-kill-percpu_alloc-and-friends.patch
  0007-vmalloc-implement-vm_area_register_early.patch
  0008-vmalloc-add-un-map_kernel_range_noflush.patch
  0009-percpu-implement-new-dynamic-percpu-allocator.patch
  0010-x86-convert-to-the-new-dynamic-percpu-allocator.patch

0001-0003 contain fixes and trivial prep.  0004-0006 clean up percpu.
0007-0008 add stuff to vmalloc which will be used by the new
allocator.  0009-0010 implement and use the new allocator.

This patchset is on top of the current x86/core/percpu[1] and can be
fetched from the following git vector.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

diffstat follows.

 arch/alpha/mm/init.c                       |   20 
 arch/x86/Kconfig                           |    3 
 arch/x86/include/asm/percpu.h              |    8 
 arch/x86/include/asm/pgtable.h             |    1 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 
 arch/x86/kernel/setup_percpu.c             |   62 +-
 arch/x86/mm/init_32.c                      |   10 
 arch/x86/mm/init_64.c                      |   19 
 block/blktrace.c                           |    2 
 drivers/acpi/processor_perflib.c           |    4 
 include/linux/percpu.h                     |   65 +-
 include/linux/vmalloc.h                    |    4 
 kernel/module.c                            |   78 +-
 kernel/sched.c                             |    6 
 kernel/stop_machine.c                      |    2 
 mm/Makefile                                |    4 
 mm/allocpercpu.c                           |   32 -
 mm/percpu.c                                |  876 +++++++++++++++++++++++++++++
 mm/vmalloc.c                               |   84 ++
 net/ipv4/af_inet.c                         |    4 
 20 files changed, 1183 insertions(+), 103 deletions(-)

Thanks.

--
tejun

[1] 58105ef1857112a186696c9b8957020090226a28
