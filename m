Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZAUVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZAUVKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZAUVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:10:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:3177 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbZAUVKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:10:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,302,1231142400"; 
   d="scan'208";a="380417683"
Subject: [git pull] async_tx/dmaengine fixes and new drivers for 2.6.29-rc3
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yuri Tikhonov <yur@emcraft.com>, Guennadi Liakhovetski <lg@denx.de>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Ira Snyder <iws@ovro.caltech.edu>,
       Ingo Molnar <mingo@elte.hu>, Li Yang <leoli@freescale.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 14:09:58 -0700
Message-Id: <1232572198.2029.31.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Atsushi Nemoto (1):
      dmatest: Use custom map/unmap for destination buffer

Dan Williams (3):
      fsldma: use a valid 'device' for dma_pool_create
      dmaengine: kill some dubious WARN_ONCEs
      dmaengine: dma_issue_pending_all == nop when CONFIG_DMA_ENGINE=n

Guennadi Liakhovetski (3):
      dmaengine: add async_tx_clear_ack() macro
      i.MX31: Image Processing Unit DMA and IRQ drivers
      i.MX31: framebuffer driver

Peter Korsgaard (2):
      fsldma: check for NO_IRQ in fsl_dma_chan_remove()
      fsldma: print correct IRQ on mpc83xx

Yuri Tikhonov (1):
      dmaengine: fix dependency chaining

1/ Fix async_tx dependency chaining.  This currently impacts an out of
tree driver, but that driver is approaching mainline inclusion.
2/ Some fsldma fixups including one regression fix
3/ A fix for dmatest to catch errant dma-memcpy operations
4/ Core dmaengine fixups to address Bug #12511 on Rafael's list
5/ New drivers from Guennadi.  The dma driver is a low regression risk
because all of its channels are tagged DMA_PRIVATE which means they will
not be picked up by NET_DMA or MD RAID.  The framebuffer driver is
included as a consumer of the new dma channels.  It is a bit odd to see
drivers/video/ in a dmaengine pull request but I included it because:
	a) drivers/video/ does not appear to have an active maintainer
	b) merging the dma driver without an in-tree user is pointless
	c) i.MX31 maintainer, Sascha, has acked both drivers

 arch/arm/plat-mxc/include/mach/ipu.h   |  181 ++++
 arch/arm/plat-mxc/include/mach/irqs.h  |   10 +-
 arch/arm/plat-mxc/include/mach/mx3fb.h |   38 +
 drivers/dma/Kconfig                    |   19 +
 drivers/dma/Makefile                   |    1 +
 drivers/dma/dmaengine.c                |    8 +-
 drivers/dma/dmatest.c                  |   35 +-
 drivers/dma/fsldma.c                   |    8 +-
 drivers/dma/ipu/Makefile               |    1 +
 drivers/dma/ipu/ipu_idmac.c            | 1740 ++++++++++++++++++++++++++++++++
 drivers/dma/ipu/ipu_intern.h           |  176 ++++
 drivers/dma/ipu/ipu_irq.c              |  413 ++++++++
 drivers/video/Kconfig                  |   12 +
 drivers/video/Makefile                 |    1 +
 drivers/video/mx3fb.c                  | 1555 ++++++++++++++++++++++++++++
 include/linux/dmaengine.h              |   11 +-
 16 files changed, 4194 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/ipu.h
 create mode 100644 arch/arm/plat-mxc/include/mach/mx3fb.h
 create mode 100644 drivers/dma/ipu/Makefile
 create mode 100644 drivers/dma/ipu/ipu_idmac.c
 create mode 100644 drivers/dma/ipu/ipu_intern.h
 create mode 100644 drivers/dma/ipu/ipu_irq.c
 create mode 100644 drivers/video/mx3fb.c

commit 86528da229a448577a8401a17c295883640d336c
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Wed Jan 21 10:32:34 2009 -0700

    i.MX31: framebuffer driver
    
    This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
    displays, vertical panning supported, no overlay support.
    
    Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5296b56d1b2000b60fb966be161c1f8fb629786b
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Mon Jan 19 15:36:21 2009 -0700

    i.MX31: Image Processing Unit DMA and IRQ drivers
    
    i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
    Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
    Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
    (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
    CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
    and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
    supported over dmaengine and irq-chip APIs respectively.
    
    IDMAC is a specialised DMA controller, its DMA channels cannot be used for
    general-purpose operations, even though it might be possible to configure
    a memory-to-memory channel for memcpy operation. This driver will not work
    with generic dmaengine clients, clients, wishing to use it must use
    respective wrapper structures, they also must specify which channels they
    require, as channels are hard-wired to specific IPU functions.
    
    Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ef560682a97491f62ef538931a4861b57d66c52c
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Mon Jan 19 15:36:21 2009 -0700

    dmaengine: add async_tx_clear_ack() macro
    
    To complete the DMA_CTRL_ACK handling API add a async_tx_clear_ack() macro.
    
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c50331e8be32eaba5e1949f98c70d50b891262db
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jan 19 15:33:14 2009 -0700

    dmaengine: dma_issue_pending_all == nop when CONFIG_DMA_ENGINE=n
    
    The device list will always be empty in this configuration, so no need
    to walk the list.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 83436a0560e9ef8af2f0796264dde4bed1415359
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jan 19 14:39:10 2009 -0700

    dmaengine: kill some dubious WARN_ONCEs
    
    dma_find_channel and dma_issue_pending_all are good places to warn about
    improper api usage.  However, warning correctly means synchronizing with
    dma_list_mutex, i.e. too much overhead for these fast-path calls.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 169d5f663759ec494aa74a552ce99486235e6e50
Author: Peter Korsgaard <jacmet@sunsite.dk>
Date:   Wed Jan 14 22:33:31 2009 -0700

    fsldma: print correct IRQ on mpc83xx
    
    The mpc83xx variant uses a shared IRQ for all channels, so the individual
    channel nodes don't have an interrupt property. Fix the code to print the
    controller IRQ instead if there isn't any for the channel.
    
    Acked-by: Timur Tabi <timur@freescale.com>
    Acked-by: Li Yang <leoli@freescale.com>
    Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6782dfe44acedf1e583d84e9e0d4f966d8e9befa
Author: Peter Korsgaard <jacmet@sunsite.dk>
Date:   Wed Jan 14 22:32:58 2009 -0700

    fsldma: check for NO_IRQ in fsl_dma_chan_remove()
    
    There's no per-channel IRQ on mpc83xx, so only call free_irq if we have one.
    
    Acked-by: Timur Tabi <timur@freescale.com>
    Acked-by: Li Yang <leoli@freescale.com>
    Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d86be86e9aab221089d72399072511f13fe2a771
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Tue Jan 13 09:22:20 2009 -0700

    dmatest: Use custom map/unmap for destination buffer
    
    The dmatest driver should use DMA_BIDIRECTIONAL on the destination buffer
    to ensure that the poison values are written to RAM and not just written
    to cache and discarded.
    
    Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6527de6d6d25ebfae7c7572cb7a4ed768e2e20a5
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jan 12 15:18:34 2009 -0700

    fsldma: use a valid 'device' for dma_pool_create
    
    The dmaengine sysfs implementation was fixed to support proper
    lifetime rules which means that the current:
    
    new_fsl_chan->dev = &new_fsl_chan->common.dev->device;
    
    ...retrieves a NULL pointer because new_fsl_chan->common.dev has not
    been allocated at this point.  So, set new_fsl_chan->dev to a valid
    device.
    
    Cc: Li Yang <leoli@freescale.com>
    Cc: Zhang Wei <zw@zh-kernel.org>
    Reported-by: Ira Snyder <iws@ovro.caltech.edu>
    Tested-by: Ira Snyder <iws@ovro.caltech.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dd59b8537f6cb53ab863fafad86a5828f1e889a2
Author: Yuri Tikhonov <yur@emcraft.com>
Date:   Mon Jan 12 15:17:20 2009 -0700

    dmaengine: fix dependency chaining
    
    In dmaengine we track the dependencies between the descriptors
    using the 'next' pointers of the structure. These pointers are
    set to NULL as soon as the corresponding descriptor has been
    submitted to the channel (in dma_run_dependencies()).
    
    But, the first 'next' in chain is still remaining set, regardless
    the fact, that tx->next has been already submitted. This may lead to
    multiple submissions of the same descriptor. This patch fixes this.
    
    Actually, some previous implementation of the xxx_run_dependencies()
    function already had this fix in place. The fdb..0eaf3 commit, beside the
    correct things, broke this.
    
    Cc: <stable@kernel.org>
    Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


