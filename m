Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZASOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZASOwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZASOr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:28 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:39313 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZASOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:24 -0500
X-BigFish: VPS-7(zz1528M1a09Mzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QF-03-6AB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org
Subject: [PATCH 0/16] DMA-API debugging facility v3
Date: Mon, 19 Jan 2009 15:46:47 +0100
Message-ID: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0751 (UTC) FILETIME=[CAEAA570:01C97A44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is version 3 of the patchset which introduces code to debug drivers
usage of the DMA-API. Many thanks to all the reviewers and the useful
comments on the previous versions of this patchset. Tests with hardware
IOMMUs have shown several bugs in drivers regarding the usage of that
API.

These bugs often don't show up or have any negative impact if there is
no hardware IOMMU in use in the system. But with an hardware IOMMU these
bugs turn the hardware unusable or, in the worst case, cause data
corruption on devices which are managed by other (good) drivers.

With the code these patches introduce driver developers can find several
bugs of misusing the DMA-API in their drivers. But be aware, it can not
find all possible bugs. What it can not find are use-after-free bugs.

If anyone wants to try this stuff and don't want to apply them one by
one, they can also be pulled from (branch is based on tip/core/iommu)

git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-api/debug

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
- more fine grained hash locking (locking is now per hash bucket, no
  global lock anymore)
- dma_debug_entries are preallocated
- per default the code will only print one warning and is silent then
- added a debugfs interface to see some statistics and to enable more
  verbose error reporting in the kernel log
- added command line parameter to disable debugging code
- allocation errors are now handled correctly
- added documentation about this facility for driver developers

Here is the diffstat:

 Documentation/DMA-API.txt           |  106 +++++
 Documentation/kernel-parameters.txt |   10 +
 arch/Kconfig                        |    2 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/dma-mapping.h  |   45 ++-
 arch/x86/kernel/pci-dma.c           |    6 +
 include/linux/dma-debug.h           |  160 ++++++++
 lib/Kconfig.debug                   |   11 +
 lib/Makefile                        |    2 +
 lib/dma-debug.c                     |  753 +++++++++++++++++++++++++++++++++++
 10 files changed, 1090 insertions(+), 6 deletions(-)



