Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbZLPS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbZLPS2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762775AbZLPS2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:28:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:47491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbZLPS2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:28:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,407,1257148800"; 
   d="scan'208";a="579570616"
Subject: Re: [GIT PULL] dmaengine update for 2.6.33
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-raid <linux-raid@vger.kernel.org>
In-Reply-To: <1260941624.29274.44.camel@dwillia2-linux.ch.intel.com>
References: <1260941624.29274.44.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:28:20 -0700
Message-Id: <1260988100.31256.4.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 22:33 -0700, Williams, Dan J wrote:
> Hi Linus, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
> 
> ...to receive a couple new drivers, coh and ppc440spe-adma (raid offload
> engine), and a collection of fixes from Guennadi.  There are a few more
> shdma fixes pending from Guennadi, but the original driver author wanted
> a bit more time to review / test, so I'm obliging.  These have been in
> linux-next for a few releases.
> 
> Thanks,
> Dan

Looks like you haven't pulled yet, so I am appending one more
straightforward fix from Nicolas:

---
dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Correct a typo error in locking calls.

Cc: <stable@kernel.org>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/at_hdmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7585c41..c558fa1 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -815,7 +815,7 @@ atc_is_tx_complete(struct dma_chan *chan,
 	dev_vdbg(chan2dev(chan), "is_tx_complete: %d (d%d, u%d)\n",
 			cookie, done ? *done : 0, used ? *used : 0);
 
-	spin_lock_bh(atchan->lock);
+	spin_lock_bh(&atchan->lock);
 
 	last_complete = atchan->completed_cookie;
 	last_used = chan->cookie;
@@ -830,7 +830,7 @@ atc_is_tx_complete(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	spin_unlock_bh(atchan->lock);
+	spin_unlock_bh(&atchan->lock);
 
 	if (done)
 		*done = last_complete;

---
New combined diffstat is:

 .../powerpc/dts-bindings/4xx/ppc440spe-adma.txt    |   93 +
 arch/arm/mach-u300/include/mach/coh901318.h        |  281 ++
 arch/powerpc/include/asm/async_tx.h                |   47 +
 arch/powerpc/include/asm/dcr-regs.h                |   23 +
 drivers/dma/Kconfig                                |   18 +
 drivers/dma/Makefile                               |    2 +
 drivers/dma/at_hdmac.c                             |    4 +-
 drivers/dma/coh901318.c                            | 1325 ++++++
 drivers/dma/coh901318_lli.c                        |  318 ++
 drivers/dma/coh901318_lli.h                        |  124 +
 drivers/dma/dmatest.c                              |   16 +-
 drivers/dma/iop-adma.c                             |    4 +-
 drivers/dma/ppc4xx/Makefile                        |    1 +
 drivers/dma/ppc4xx/adma.c                          | 5027 ++++++++++++++++++++
 drivers/dma/ppc4xx/adma.h                          |  195 +
 drivers/dma/ppc4xx/dma.h                           |  223 +
 drivers/dma/ppc4xx/xor.h                           |  110 +
 drivers/dma/shdma.c                                |   36 +-
 drivers/dma/shdma.h                                |   14 +-
 include/linux/dmaengine.h                          |    2 +-
 20 files changed, 7830 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
 create mode 100644 arch/arm/mach-u300/include/mach/coh901318.h
 create mode 100644 arch/powerpc/include/asm/async_tx.h
 create mode 100644 drivers/dma/coh901318.c
 create mode 100644 drivers/dma/coh901318_lli.c
 create mode 100644 drivers/dma/coh901318_lli.h
 create mode 100644 drivers/dma/ppc4xx/Makefile
 create mode 100644 drivers/dma/ppc4xx/adma.c
 create mode 100644 drivers/dma/ppc4xx/adma.h
 create mode 100644 drivers/dma/ppc4xx/dma.h
 create mode 100644 drivers/dma/ppc4xx/xor.h



