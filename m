Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZCFNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZCFNa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZCFNan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:43 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:59775
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbZCFNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:42 -0500
X-BigFish: VPS-14(zz1528M154dM1a09Mzzzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UR-02-TL0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH 0/18] DMA-API debugging facility v4
Date: Fri, 6 Mar 2009 14:30:11 +0100
Message-ID: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 06 Mar 2009 13:30:29.0995 (UTC) FILETIME=[B7D39BB0:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is version 4 of the patchset which introduces code to debug drivers
usage of the DMA-API. Many thanks to all the reviewers and the useful
comments on the previous versions of this patchset. Appended is a
changelog, the shortlog and the diff-stat.

Changes from v3 -> v4:

- a patch from David Woodhouse adds printing of the mapping path
  stacktrace on an unmap error
- another patch from David added a function which drivers can use to
  dump their DMA mappings
- two new checks in the sync-path check if the dma memory was mapped for
  the requested sync direction
- a check for mapping requests of memory on kernel stacks was added
  (thanks to Arndt Bergmann)
- A bug in the handling of dma_map_sg/dma_unmap_sg pointed out by
  FUJITA Tomonori was fixed
- As a result of the previous fix a check was added to find if a driver
  unmaps different count of sg entries than it mapped
- Various changes to the hash (larger hash size, hash function uses
  lower bits than before)
- Some minor fixes pointed out by reviewers

Changes from v2 -> v3:

- rebased patches against tip/core/iommu branch
- changed storage of virtual address to physical address in
  struct dma_debug_entry (thanks Fujita)
- removed usage of x86 specific bad_dma_address (thanks Fujita)
- changed a error log message to be more clear (thanks Roel)
- fixed a bug with wrong handling of map_page/unmap_page requests
  (thanks Michael)
- various improvements and fixes suggested by Ingo, thanks
- added more comments

Changes from v1 -> v2:

- moved code to lib/ and include/linux to make it usable for all
  architectures
- more fine grained hash locking (locking is now per hash
  bucket, no global lock anymore)
- dma_debug_entries are preallocated
- per default the code will only print one warning and is
  silent then
- added a debugfs interface to see some statistics and to
  enable more verbose error reporting in the kernel log
- added command line parameter to disable debugging code
- allocation errors are now handled correctly
- added documentation about this facility for driver developers


	Joerg

Shortlog:

David Woodhouse (2):
      dma-debug: add function to dump dma mappings
      dma-debug: print stacktrace of mapping path on unmap error

Joerg Roedel (16):
      dma-debug: add Kconfig entry
      dma-debug: add header file and core data structures
      dma-debug: add hash functions for dma_debug_entries
      dma-debug: add allocator code
      dma-debug: add initialization code
      dma-debug: add kernel command line parameters
      dma-debug: add debugfs interface
      dma-debug: add core checking functions
      dma-debug: add checking for map/unmap_page/single
      dma-debug: add add checking for map/unmap_sg
      dma-debug: add checking for [alloc|free]_coherent
      dma-debug: add checks for sync_single_*
      dma-debug: add checks for sync_single_range_*
      dma-debug: add checks for sync_single_sg_*
      dma-debug: x86 architecture bindings
      dma-debug: Documentation update

Diffstat:

 Documentation/DMA-API.txt           |  106 +++++
 Documentation/kernel-parameters.txt |   10 +
 arch/Kconfig                        |    2 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/dma-mapping.h  |   45 ++-
 arch/x86/kernel/pci-dma.c           |    6 +
 include/linux/dma-debug.h           |  167 +++++++
 lib/Kconfig.debug                   |   11 +
 lib/Makefile                        |    2 +
 lib/dma-debug.c                     |  870 +++++++++++++++++++++++++++++++++++
 10 files changed, 1214 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/dma-debug.h
 create mode 100644 lib/dma-debug.c



