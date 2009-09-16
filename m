Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZIPMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZIPMvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZIPMvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:51:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZIPMvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:51:16 -0400
Date: Wed, 16 Sep 2009 14:51:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090916125116.GA12751@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

This is the generic VM part of the hwpoison memory error recovery 
code for Nehalem-EX. Nehalem-EX supports very large memory
sizes (multi TB even in small systems), so having good memory error 
handling is important. 

Right now it's only used on x86, but I expect it will be later
used on other MCA architectures (at least sparc64, IPF) too.
The high level code is fairly generic.

Andrew suggested to send it directly. The patchkit was originally
ready for 2.6.31.

In a nutshell memory-failure.c looks at a specific page that 
was hit by a uncorrected error and is poisoned and removes it from
further use. This includes unmapping, killing processes if needed and 
dropping the page. In many common cases (e.g. error hitting a clean 
cache page) this allows to continue without impacting any running process. 

It doesn't attempt to handle really hard cases, like dropping file system
metadata and kernel subsystem pages like dcache. But the majority of memory 
in common workloads is handled.

The patchkit adds a new concept of "HWpoisoned" pages that should
not be accessed anymore. There are a few checks in 
strategic places for those, but I minimized them so
very few kernel code needs to know about this. There are also
poisoned PTEs, but these are just extensions of the existing
swap and migration PTEs.

This has been extensively reviewed on the mailing lists and
looked at by various VM hackers. There were several iterations
to address all their concerns (especially getting through
Nick Piggin's review was though) 

The diffstat makes it look more intrusive than it really is.
The changes outside the new files are with very few exceptions 
either refactorings that are no-ops on their own, or if (poison) 
do something checks that do nothing without poison.

It was also needed to add per VFS hook "error_drop_page" 
so that file systems can opt in or out, to make sure they
all skip metadata correctly (metadata is too hard to handle
asynchronously, so it's skipped). This addressed on of the
review comments. This is very similar to the existing 
migrate_pages op.  The standard widely used filesystems all support 
it fine.

Ther is also a extensive test suite (mce-test) on kernel.org 
and the code has special test hooks to make testing easy.

The x86 specific low level code for the machine check handler
has been already merged in 2.6.31. There is one small
x86 change include to process the new error returns
from handle_mm_fault. I opted to include it here than
sending it through the x86 tree to avoid dependency hell.

The code has been in linux-next for some time and I didn't
hear any complaints about it. I tried to get acks from
everyone whose subsystem was touched, but some maintainers
didn't answer. However all their changes are quite simple.

The code is certainly not perfect yet, there are a few
known problems (e.g. missing huge page support or it runs
into limitations in the VFS error propagation for dirty pages), 
but none of them fatal.  I think it's good enough to be generally 
useful. I plan to improve it further in the future.

The work was mostly done by me and Fengguang Wu, but with
help and review from a lot of other people.

Please pull for 2.6.32

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

Andi Kleen (17):
      HWPOISON: Add page flag for poisoned pages
      HWPOISON: Export some rmap vma locking to outside world
      HWPOISON: Add support for poison swap entries v2
      HWPOISON: Add new SIGBUS error codes for hardware poison signals
      HWPOISON: Add basic support for poisoned pages in fault handler v3
      HWPOISON: Add poison check to page fault handling
      HWPOISON: x86: Add VM_FAULT_HWPOISON handling to x86 page fault handler v2
      HWPOISON: Use bitmask/action code for try_to_unmap behaviour
      HWPOISON: Handle hardware poisoned pages in try_to_unmap
      HWPOISON: Define a new error_remove_page address space op for async truncation
      HWPOISON: Add PR_MCE_KILL prctl to control early kill behaviour per process
      HWPOISON: The high level memory error handler in the VM v7
      HWPOISON: Enable .remove_error_page for migration aware file systems
      HWPOISON: Enable error_remove_page for NFS
      HWPOISON: Add madvise() based injector for hardware poisoned pages v4
      HWPOISON: Add simple debugfs interface to inject hwpoison on arbitary PFNs
      HWPOISON: Enable error_remove_page on btrfs

Nick Piggin (1):
      HWPOISON: Refactor truncate to allow direct truncating of page v2

Wu Fengguang (3):
      HWPOISON: check and isolate corrupted free pages v2
      HWPOISON: Add invalidate_inode_page
      HWPOISON: shmem: call set_page_dirty() with locked page

 Documentation/filesystems/vfs.txt |    7 +
 Documentation/sysctl/vm.txt       |   41 ++-
 arch/x86/mm/fault.c               |   19 +-
 fs/btrfs/inode.c                  |    1 +
 fs/ext2/inode.c                   |    2 +
 fs/ext3/inode.c                   |    3 +
 fs/ext4/inode.c                   |    4 +
 fs/gfs2/aops.c                    |    3 +
 fs/nfs/file.c                     |    1 +
 fs/ntfs/aops.c                    |    2 +
 fs/ocfs2/aops.c                   |    1 +
 fs/proc/meminfo.c                 |    9 +-
 fs/xfs/linux-2.6/xfs_aops.c       |    1 +
 include/asm-generic/mman-common.h |    1 +
 include/asm-generic/siginfo.h     |    8 +-
 include/linux/fs.h                |    1 +
 include/linux/mm.h                |   15 +-
 include/linux/page-flags.h        |   17 +-
 include/linux/prctl.h             |    2 +
 include/linux/rmap.h              |   21 +-
 include/linux/sched.h             |    2 +
 include/linux/swap.h              |   34 ++-
 include/linux/swapops.h           |   38 ++
 kernel/sys.c                      |   22 +
 kernel/sysctl.c                   |   25 ++
 mm/Kconfig                        |   14 +
 mm/Makefile                       |    2 +
 mm/filemap.c                      |    4 +
 mm/hwpoison-inject.c              |   41 ++
 mm/madvise.c                      |   30 ++
 mm/memory-failure.c               |  832 +++++++++++++++++++++++++++++++++++++
 mm/memory.c                       |   24 +-
 mm/migrate.c                      |    2 +-
 mm/page-writeback.c               |    7 +
 mm/page_alloc.c                   |   20 +-
 mm/rmap.c                         |   60 ++-
 mm/shmem.c                        |    5 +-
 mm/swapfile.c                     |    4 +-
 mm/truncate.c                     |   72 +++-
 mm/vmscan.c                       |    2 +-
 40 files changed, 1331 insertions(+), 68 deletions(-)
 create mode 100644 mm/hwpoison-inject.c
 create mode 100644 mm/memory-failure.c


Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
