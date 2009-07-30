Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZG3RjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZG3RjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZG3RjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:39:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:14179 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZG3RjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,296,1246863600"; 
   d="scan'208";a="537301161"
Subject: [git pull] dmaengine/async_tx update for 2.6.31-rc5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, Li Yang <leoli@freescale.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 10:39:09 -0700
Message-Id: <1248975549.12301.16.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

Dan Williams (1):
      dmaengine: move HIGHMEM64G restriction to ASYNC_TX_DMA

Ira Snyder (2):
      fsldma: enable external start for the 83xx controller
      fsldma: do not clear bandwidth control bits on the 83xx controller

Ira W. Snyder (1):
      fsldma: use PCI Read Multiple command

Joe Perches (2):
      drivers/dma/fsldma.c: Remove unnecessary semicolons
      drivers/dma: Remove unnecessary semicolons

Nicolas Ferre (4):
      dmaengine: dmatest: add a maximum number of test iterations
      dmaengine: dmatest: correct thread_count while using multiple thread per channel
      dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
      dmaengine: at_hdmac: add DMA slave transfers

 arch/arm/mach-at91/include/mach/at_hdmac.h |  102 +++
 crypto/async_tx/async_xor.c                |    2 +-
 drivers/dma/Kconfig                        |   12 +-
 drivers/dma/Makefile                       |    1 +
 drivers/dma/at_hdmac.c                     | 1213 ++++++++++++++++++++++++++++
 drivers/dma/at_hdmac_regs.h                |  353 ++++++++
 drivers/dma/dmatest.c                      |   21 +-
 drivers/dma/fsldma.c                       |   17 +-
 drivers/dma/fsldma.h                       |    1 +
 drivers/dma/mv_xor.c                       |    2 +-
 10 files changed, 1711 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at_hdmac.h
 create mode 100644 drivers/dma/at_hdmac.c
 create mode 100644 drivers/dma/at_hdmac_regs.h

These patches have had exposure in linux-next and include:

1/ Some fsldma fixups from Ira that I have been sitting on for too long

2/ A loosening of the Kconfig dependencies for the DMADEVICES menu.  

3/ A new dma driver from Nicolas, with some fixes to dmatest.

4/ Some trivial cleanups from Joe.

Thanks,
Dan

commit a7aea373b4ca428f1be2c1fedd2f26c8e3f2864d
Author: Ira W. Snyder <iws@ovro.caltech.edu>
Date:   Thu Apr 23 16:17:54 2009 -0700

    fsldma: use PCI Read Multiple command
    
    By default, the Freescale 83xx DMA controller uses the PCI Read Line
    command when reading data over the PCI bus. Setting the controller to use
    the PCI Read Multiple command instead allows the controller to read much
    larger bursts of data, which provides a drastic speed increase.
    
    The slowdown due to using PCI Read Line was only observed when a PCI-to-PCI
    bridge was between the devices trying to communicate.
    
    A simple test driver showed an increase from 4MB/sec to 116MB/sec when
    performing DMA over the PCI bus. Using DMA to transfer between blocks of
    local SDRAM showed no change in performance with this patch. The dmatest
    driver was also used to verify the correctness of the transfers, and showed
    no errors.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Acked-by: Timur Tabi <timur@freescale.com>
    Acked-by: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit be30b226f2ae618cd719e40267d9923db1db9001
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu May 28 09:20:42 2009 +0000

    fsldma: enable external start for the 83xx controller
    
    The 83xx controller has external start capability, but lacks external pause
    capability. Hook up the external start function pointer for the 83xx
    controller.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 43a1a3ed6bf5a1b9ae197b4f5f20033baf19db61
Author: Ira Snyder <iws@ovro.caltech.edu>
Date:   Thu May 28 09:26:40 2009 +0000

    fsldma: do not clear bandwidth control bits on the 83xx controller
    
    The 83xx controller does not support the external pause feature. The bit
    in the mode register that controls external pause on the 85xx controller
    happens to be part of the bandwidth control settings for the 83xx
    controller.
    
    This patch fixes the driver so that it only clears the external pause bit
    if the hardware is the 85xx controller. When driving the 83xx controller,
    the bit is left untouched. This follows the existing convention that mode
    registers settings are not touched unless necessary.
    
    Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit daf4219dbcbb2efcd638fcd3c29a622e1c18cc38
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jul 1 16:12:53 2009 -0700

    dmaengine: move HIGHMEM64G restriction to ASYNC_TX_DMA
    
    On HIGHMEM64G systems dma_addr_t is known to be larger than (void *)
    which precludes async_xor from performing dma address conversions by
    reusing the input parameter address list.  However, other parts of the
    dmaengine infrastructure do not suffer this constraint, so the
    HIGHMEM64G restriction can be down-levelled.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e3d433040ee6077e33d4ad22e2f60a38b085786d
Author: Joe Perches <joe@perches.com>
Date:   Sun Jun 28 09:26:20 2009 -0700

    drivers/dma/fsldma.c: Remove unnecessary semicolons
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c019894efc9c9ba5939948caa78c133b1ec8ae63
Author: Joe Perches <joe@perches.com>
Date:   Sun Jun 28 09:26:21 2009 -0700

    drivers/dma: Remove unnecessary semicolons
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0a2ff57d6fba92842272889b4bca447344cd9d36
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Fri Jul 3 19:26:51 2009 +0200

    dmaengine: dmatest: add a maximum number of test iterations
    
    The dmatest usually waits for the killing of its kthreads to stop
    running tests.  This patch adds a parameter that sets a maximum
    number of test iterations.
    
    This feature is quite interesting for debugging when you set a lot of
    traces in your dmaengine controller driver.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Mon Jul 6 18:19:44 2009 +0200

    dmaengine: dmatest: correct thread_count while using multiple thread per channel
    
    It seems that thread_count is not properly calculated in dmatest.
    In fact the thread count number that is returned from dmatest_add_threads() is
    not correctly added to the thread_count and thus not properly printed.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dc78baa2b90b289590911b40b6800f77d0dc935a
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Fri Jul 3 19:24:33 2009 +0200

    dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
    
    This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
    at91sam9rl chip. It will be used on other products in the future.
    
    This first release covers only the memory-to-memory tranfer type. This is the
    only tranfer type supported by this chip.  On other products, it will be used
    also for peripheral DMA transfer (slave API support to come).
    
    I used dmatest client without problem in different configurations to test it.
    
    Full documentation for this controller can be found in the SAM9RL datasheet:
    http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 808347f6a31792079e345ec865e9cfcb6e8ae6b2
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Jul 22 20:04:45 2009 +0200

    dmaengine: at_hdmac: add DMA slave transfers
    
    This patch for at_hdmac adds the slave transfers capability to the Atmel DMA
    controller available on some AT91 SOCs. This allow peripheral to memory and
    memory to peripheral transfers with hardware handshaking.
    
    Slave structure for controller specific information is passed through channel
    private data. This at_dma_slave structure is defined in at_hdmac.h header file
    and relative hardware definition are moved to this file from at_hdmac_regs.h.
    Doing this we allow the channel configuration from platform definition code.
    
    This work is intensively based on dw_dmac and several slave implementations.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


