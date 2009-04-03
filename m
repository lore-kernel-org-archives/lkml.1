Return-Path: <linux-kernel-owner+w=401wt.eu-S936215AbZDCSi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936215AbZDCSi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbZDCSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:38:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:36670 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbZDCSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,320,1235980800"; 
   d="scan'208";a="444817722"
Subject: [GIT PULL]: dmaengine update for 2.6.30
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Guennadi Liakhovetski <lg@denx.de>,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 11:38:34 -0700
Message-Id: <1238783914.25347.2.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from...

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive: 

Atsushi Nemoto (1):
      dmaengine: Add privatecnt to revert DMA_PRIVATE property

Dan Williams (7):
      dmaengine: fail device registration if channel registration fails
      dmaengine: initialize tx_list in dma_async_tx_descriptor_init
      dmaengine: kill some unused headers
      async_tx: provide __async_inline for HAS_DMA=n archs
      dmaengine: allow dma support for async_tx to be toggled
      dmatest: add xor test
      dmatest: add dma interrupts and callbacks

Guennadi Liakhovetski (4):
      dma: ipu_idmac driver cosmetic clean-up
      dma: improve section assignment in i.MX31 IPU DMA driver
      dma: i.MX31 IPU DMA robustness improvements
      dma: Add SoF and EoF debugging to ipu_idmac.c, minor cleanup

Hans-Christian Egtvedt (1):
      dw_dmac: add cyclic API to DW DMA driver

Nothing too exciting this time around, just some driver updates, xor
support for dmatest, and some cleanups.  All but the last two have had
exposure in -next, at least long enough for Guennadi to spot and fix a
regression before it hit mainline.

Commit "dw_dmac: add cyclic API to DW DMA driver" was applied recently,
but it comes with an Ack from Haavard and only adds new functionality.

Commit "dma: Add SoF and EoF debugging to ipu_idmac.c, minor cleanup" is
also a bit late but appears to be harmless.

 crypto/async_tx/async_tx.c  |    6 +-
 crypto/async_tx/async_xor.c |    7 +-
 drivers/dma/Kconfig         |   11 ++
 drivers/dma/dmaengine.c     |   60 ++++++--
 drivers/dma/dmatest.c       |  307 +++++++++++++++++++++++++-----------
 drivers/dma/dw_dmac.c       |  333 ++++++++++++++++++++++++++++++++++++++-
 drivers/dma/dw_dmac_regs.h  |    7 +-
 drivers/dma/fsldma.c        |    1 -
 drivers/dma/ioat_dma.c      |    1 -
 drivers/dma/iop-adma.c      |    1 -
 drivers/dma/ipu/ipu_idmac.c |  371 +++++++++++++++++++++++++++++--------------
 drivers/dma/ipu/ipu_irq.c   |    2 +-
 drivers/dma/mv_xor.c        |    1 -
 include/linux/async_tx.h    |    9 +
 include/linux/dmaengine.h   |   30 +++-
 include/linux/dw_dmac.h     |   19 +++
 16 files changed, 925 insertions(+), 241 deletions(-)

Thanks,
Dan


commit 8c6db1bbf80123839ec87bdd6cb364aea384623d
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Thu Apr 2 11:36:58 2009 +0200

    dma: Add SoF and EoF debugging to ipu_idmac.c, minor cleanup
    
    Add Start-of-Frame and End-of-Frame debugging to ipu_idmac.c, in the
    future it might also be needed for the actual video processing in
    mx3-camera, at which point, the ISRs will have to be transferred to
    mx3_camera.c, for which ipu_irq_map() and ipu_irq_unmap() functions will
    have to be exported.
    
    Also simplify a couple of pointer-dereferences.
    
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d9de451989a88a2003ca06e524aca4665c0c7f06
Author: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date:   Wed Apr 1 15:47:02 2009 +0200

    dw_dmac: add cyclic API to DW DMA driver
    
    This patch adds a cyclic DMA interface to the DW DMA driver. This is
    very useful if you want to use the DMA controller in combination with a
    sound device which uses cyclic buffers.
    
    Using a DMA channel for cyclic DMA will disable the possibility to use
    it as a normal DMA engine until the user calls the cyclic free function
    on the DMA channel. Also a cyclic DMA list can not be prepared if the
    channel is already active.
    
    Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
    Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0f571515c332e00b3515dbe0859ceaa30ab66e00
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Fri Mar 6 20:07:14 2009 +0900

    dmaengine: Add privatecnt to revert DMA_PRIVATE property
    
    Currently dma_request_channel() set DMA_PRIVATE capability but never
    clear it.  So if a public channel was once grabbed by
    dma_request_channel(), the device stay PRIVATE forever.  Add
    privatecnt member to dma_device to correctly revert it.
    
    [lg@denx.de: fix bad usage of 'chan' in dma_async_device_register]
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e44e0aa3cfa97cddff01704751a4b25151830c72
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:25 2009 -0700

    dmatest: add dma interrupts and callbacks
    
    Use the callback infrastructure to report driver/hardware hangs or
    missed interrupts.  Since this makes the test threads much more
    aggressive (from: explicit 1ms sleep to: wait_for_completion) we set the
    nice value to 10 so as to not swamp legitimate tasks.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b54d5cb9156868fb4f27ccd46a3afb0bf3ef8e0c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:25 2009 -0700

    dmatest: add xor test
    
    Extend dmatest to launch a thread per supported operation type and add
    an xor test.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 729b5d1b8ec72c28e99840b3f300ba67726e3ab9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:25 2009 -0700

    dmaengine: allow dma support for async_tx to be toggled
    
    Provide a config option for blocking the allocation of dma channels to
    the async_tx api.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 06164f3194e01ea4c76941ac60f541d656c8975f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:25 2009 -0700

    async_tx: provide __async_inline for HAS_DMA=n archs
    
    To allow an async_tx routine to be compiled away on HAS_DMA=n arch it
    needs to be declared __always_inline otherwise the compiler may emit
    code and cause a link error.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 54aee6a5f560d0e1bf3f39987c6ebe06daeb0ce1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:24 2009 -0700

    dmaengine: kill some unused headers
    
    The dmaengine redux left some unneeded headers in
    include/linux/dmaengine.h, clean them up.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ccccce229c633a92c42cd1a40c0738d7b0d12644
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:24 2009 -0700

    dmaengine: initialize tx_list in dma_async_tx_descriptor_init
    
    Centralize this common initialization (and one case where ipu_idmac is
    duplicating ->chan initialization).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8d47bae004f062630f69f7f83d098424252e232d
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Wed Mar 25 09:13:24 2009 -0700

    dma: i.MX31 IPU DMA robustness improvements
    
    Add DMA error handling to the ISR, move common code fragments to functions, fix
    scatter-gather element queuing in the ISR, survive channel freeing and
    re-allocation in a quick succession.
    
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 234f2df56f5b05756c444edc9879145deddf69f4
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Wed Mar 25 09:13:24 2009 -0700

    dma: improve section assignment in i.MX31 IPU DMA driver
    
    The i.MX31 IPU DMA driver is a platform driver, but doesn't need hotplug, so we
    can use __init and __exit function attributes.
    
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0149f7d5dc66dcffbb044ba005a5378a5864d2a3
Author: Guennadi Liakhovetski <lg@denx.de>
Date:   Wed Mar 25 09:13:23 2009 -0700

    dma: ipu_idmac driver cosmetic clean-up
    
    Remove superfluous semicolons, update comments.
    
    Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 257b17ca030387cb17314cd1851507bdd1b4ddd5
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 25 09:13:23 2009 -0700

    dmaengine: fail device registration if channel registration fails
    
    Atsushi points out:
    "If alloc_percpu or kzalloc failed, chan_id does not match with its
    position in device->channels list.
    
    And above "continue" looks buggy anyway.  Keeping incomplete channels
    in device->channels list looks very dangerous..."
    
    Also, fix up leakage of idr_ref in the idr_pre_get() and channel init
    fail cases.
    
    Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


