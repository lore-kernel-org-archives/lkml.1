Return-Path: <linux-kernel-owner+w=401wt.eu-S1765381AbYBMHE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765381AbYBMHE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYBMHEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:04:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:11330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbYBMHEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:04:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,344,1199692800"; 
   d="scan'208";a="298083046"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4] async_tx: fix dependency handling and related cleanups
To: linux-kernel@vger.kernel.org
Cc: hskinnemoen@atmel.com, shannon.nelson@intel.com, olof@lixom.net,
       yur@emcraft.com
Date: Wed, 13 Feb 2008 00:02:52 -0700
Message-ID: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Injecting channel-switch-interrupts has been broken for a while now.  It
has not been a problem in practice because the only in-tree driver that
relied on this functionality was the iop3xx version of iop-adma, and it
had a bug-masking local workaround.  Three side benefits arise from this
fix:

1/ dma_async_tx_descriptor sheds two list_heads
2/ Locking is made sane in that dma drivers no longer need to directly
   touch dma_async_tx_descriptor.lock
3/ dma_device.device_dependency_added is no longer needed

Testing shows that iop-adma now gets by without the 'watchdog'
workaround.

---

Dan Williams (4):
      iop-adma: remove the workaround for missed interrupts on iop3xx
      async_tx: kill ->device_dependency_added
      async_tx: fix multiple dependency submission
      async_tx: checkpatch says s/__FUNCTION__/__func__/g


 crypto/async_tx/async_memcpy.c         |    6 -
 crypto/async_tx/async_memset.c         |    6 -
 crypto/async_tx/async_tx.c             |  203 ++++++++++++++++++++++++++------
 crypto/async_tx/async_xor.c            |   12 +-
 drivers/dma/dmaengine.c                |    3 
 drivers/dma/ioat_dma.c                 |   12 --
 drivers/dma/iop-adma.c                 |   21 +--
 include/asm-arm/arch-iop13xx/adma.h    |    5 -
 include/asm-arm/hardware/iop3xx-adma.h |    8 -
 include/asm-arm/hardware/iop_adma.h    |    2 
 include/linux/dmaengine.h              |   11 --
 11 files changed, 185 insertions(+), 104 deletions(-)

-- 
Dan
