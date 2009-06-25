Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZFYHSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZFYHSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFYHRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:17:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58503 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZFYHRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:17:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=GGJD5b2Oib+a7vXHmGAsMkGGXKHofOl5Tmkl6AXQbYUs8ZwpQjibbSuS8EoAEU6+6
	wvJ3j3tGxMsq3BxyjSxoA==
From: Paul Menage <menage@google.com>
Subject: [PATCH] UML: Fix some apparent bitrot
To: torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, jdike@addtoit.com,
       sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org
Date: Thu, 25 Jun 2009 00:17:15 -0700
Message-ID: <20090625071715.20355.80952.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML: Fix some apparent bitrot

- migration of net_device methods into net_device_ops
- dma_sync_single() changes

Signed-off-by: Paul Menage <menage@google.com>

--

This version is split from my earlier patch, including just the
portions that ar required for Linus' tree.

Fixes the following compile errors:

include/linux/dma-mapping.h:113: error: redefinition of 'dma_sync_single'
arch/um/include/asm/dma-mapping.h:84: error: previous definition of 'dma_sync_single' was here
include/linux/dma-mapping.h: In function 'dma_sync_single':
include/linux/dma-mapping.h:117: error: implicit declaration of function 'dma_sync_single_for_cpu'
include/linux/dma-mapping.h: At top level:
include/linux/dma-mapping.h:120: error: redefinition of 'dma_sync_sg'
arch/um/include/asm/dma-mapping.h:91: error: previous definition of 'dma_sync_sg' was here
include/linux/dma-mapping.h: In function 'dma_sync_sg':
include/linux/dma-mapping.h:124: error: implicit declaration of function 'dma_sync_sg_for_cpu'


arch/um/drivers/slirp_kern.c: In function 'slirp_init':
arch/um/drivers/slirp_kern.c:35: error: 'struct net_device' has no member named 'init'

---

 arch/um/drivers/slip_kern.c       |    1 -
 arch/um/drivers/slirp_kern.c      |    1 -
 arch/um/include/asm/dma-mapping.h |    4 ++--
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
index 5ec1756..dd2aadc 100644
--- a/arch/um/drivers/slip_kern.c
+++ b/arch/um/drivers/slip_kern.c
@@ -30,7 +30,6 @@ static void slip_init(struct net_device *dev, void *data)
 
 	slip_proto_init(&spri->slip);
 
-	dev->init = NULL;
 	dev->hard_header_len = 0;
 	dev->header_ops = NULL;
 	dev->addr_len = 0;
diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
index f15a6e7..e376284 100644
--- a/arch/um/drivers/slirp_kern.c
+++ b/arch/um/drivers/slirp_kern.c
@@ -32,7 +32,6 @@ void slirp_init(struct net_device *dev, void *data)
 
 	slip_proto_init(&spri->slip);
 
-	dev->init = NULL;
 	dev->hard_header_len = 0;
 	dev->header_ops = NULL;
 	dev->addr_len = 0;
diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
index 90fc708..378de4b 100644
--- a/arch/um/include/asm/dma-mapping.h
+++ b/arch/um/include/asm/dma-mapping.h
@@ -79,14 +79,14 @@ dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 }
 
 static inline void
-dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
 		enum dma_data_direction direction)
 {
 	BUG();
 }
 
 static inline void
-dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 	    enum dma_data_direction direction)
 {
 	BUG();

