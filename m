Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0CBMSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:18:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab0CBMSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:18:34 -0500
Message-ID: <4B8D0489.6040806@kernel.org>
Date: Tue, 02 Mar 2010 21:28:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Amerigo Wang <amwang@redhat.com>
Subject: [GIT PULL] percpu changes for 2.6.34-rc1
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 12:17:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following percpu branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

The branch contains the following changes.

* Remove per_cpu__ prefix from static per-cpu variables and access the
  static and dynamic percpu variables the same way.  This allows
  handling and manipulating percpu addresses just like any other
  addresses.

* Implement __percpu sparse annotation which marks percpu addresses to
  belong to a different address space.  This replaces the per_cpu__
  prefix which used to protect illegal accesses to static percpu
  variables and also extends the protection such that it covers both
  static and dynamic percpu variables and any pointer which deals with
  percpu addresses.

* Add __percpu annotations to several subsystems.  Others are being
  routed through respective subsystem trees.

* Christoph Lameter's this_cpu_*() conversion series on allocator
  related stuff and local_t users.  Good part of local_t has been
  replaced with this_cpu_*() but the conversion isn't complete yet.
  The last remaining user is ringbuffer and it isn't clear whether
  it'll be possible to replace it completely with percpu variables.

* Now unused part of local_t has been removed.

* WANG Cong's pcpu_[de]populate_chunk() refactor patch.

Merging into 13dda80e48439b446d0bc9bab34b91484bc8f533 doesn't cause
any conflict.

Thanks.

==================
Summary of changes
==================

Christoph Lameter (7):
      local_t: Remove cpu_local_xx macros
      module: Use this_cpu_xx to dynamically allocate counters
      local_t: Move local.h include to ringbuffer.c and ring_buffer_benchmark.c
      percpu, x86: Generic inc / dec percpu instructions
      this_cpu: Page allocator conversion
      this_cpu: Remove pageset_notifier
      local_t: Remove leftover local.h

Rusty Russell (2):
      percpu: remove per_cpu__ prefix.
      percpu: add __percpu for sparse.

Tejun Heo (7):
      percpu: make access macros universal
      percpu: make accessors check for percpu pointer in sparse
      percpu: remove compile warnings caused by __verify_pcpu_ptr()
      Merge branch 'master' into percpu
      percpu: add __percpu sparse annotations to core kernel subsystems
      percpu: add __percpu sparse annotations to fs
      percpu: add __percpu sparse annotations to what's left

WANG Cong (1):
      percpu: refactor the code in pcpu_[de]populate_chunk()

 arch/alpha/include/asm/local.h       |   17 ---
 arch/blackfin/mach-common/entry.S    |    4 +-
 arch/cris/arch-v10/kernel/entry.S    |    2 +-
 arch/cris/arch-v32/mm/mmu.S          |    2 +-
 arch/ia64/include/asm/percpu.h       |    4 +-
 arch/ia64/kernel/ia64_ksyms.c        |    4 +-
 arch/ia64/mm/discontig.c             |    2 +-
 arch/m32r/include/asm/local.h        |   25 ----
 arch/microblaze/include/asm/entry.h  |    2 +-
 arch/mips/include/asm/local.h        |   25 ----
 arch/parisc/lib/fixup.S              |    8 +-
 arch/powerpc/include/asm/local.h     |   25 ----
 arch/sparc/kernel/nmi.c              |    7 +-
 arch/sparc/kernel/rtrap_64.S         |    8 +-
 arch/x86/include/asm/local.h         |   37 ------
 arch/x86/include/asm/percpu.h        |  119 +++++++++++++++------
 arch/x86/include/asm/system.h        |    8 +-
 arch/x86/kernel/apic/nmi.c           |    6 +-
 arch/x86/kernel/head_32.S            |    6 +-
 arch/x86/kernel/vmlinux.lds.S        |    4 +-
 arch/x86/xen/xen-asm_32.S            |    4 +-
 crypto/cryptd.c                      |    2 +-
 drivers/acpi/processor_perflib.c     |    2 +-
 drivers/dma/dmaengine.c              |    2 +-
 drivers/edac/amd64_edac.c            |    2 +-
 drivers/md/raid5.c                   |    2 +-
 drivers/md/raid5.h                   |    2 +-
 fs/ext4/ext4.h                       |    2 +-
 fs/nfs/iostat.h                      |    4 +-
 fs/xfs/xfs_mount.h                   |    2 +-
 include/acpi/processor.h             |    2 +-
 include/asm-generic/local.h          |   19 ---
 include/asm-generic/percpu.h         |   18 ++-
 include/linux/blktrace_api.h         |    4 +-
 include/linux/compiler.h             |    4 +-
 include/linux/dmaengine.h            |    2 +-
 include/linux/genhd.h                |    2 +-
 include/linux/kexec.h                |    2 +-
 include/linux/mm.h                   |    4 -
 include/linux/mmzone.h               |   12 +--
 include/linux/module.h               |   37 +++----
 include/linux/mount.h                |    2 +-
 include/linux/nfs_fs_sb.h            |    2 +-
 include/linux/percpu-defs.h          |   40 ++++---
 include/linux/percpu.h               |   44 +++++---
 include/linux/percpu_counter.h       |    2 +-
 include/linux/srcu.h                 |    2 +-
 include/linux/vmstat.h               |    8 +-
 kernel/kexec.c                       |    2 +-
 kernel/module.c                      |   29 +++---
 kernel/rcutorture.c                  |    8 +-
 kernel/sched.c                       |    4 +-
 kernel/stop_machine.c                |    2 +-
 kernel/trace/ring_buffer.c           |    1 +
 kernel/trace/ring_buffer_benchmark.c |    1 +
 kernel/trace/trace.c                 |    6 +-
 kernel/trace/trace_functions_graph.c |    4 +-
 mm/page_alloc.c                      |  202 ++++++++++++----------------------
 mm/percpu.c                          |   36 +++---
 mm/vmstat.c                          |   15 ++-
 60 files changed, 356 insertions(+), 499 deletions(-)

-- 
tejun
