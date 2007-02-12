Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbXBLFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbXBLFaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932995AbXBLFaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:30:24 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41039 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbXBLFaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:30:23 -0500
X-IronPort-AV: i="4.13,311,1167638400"; 
   d="scan'208"; a="111508546:sNHT48702924"
To: akpm@linux-foundation.org, tony.luck@intel.com
Cc: Jeff Garzik <jeff@garzik.org>, Al Viro <viro@ftp.linux.org.uk>,
       torvalds@linux-foundation.org, Tejun Heo <htejun@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH] ia64: Fix noncoherent DMA API so devres builds
X-Message-Flag: Warning: May contain useful information
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com>
	<20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com>
	<20070211063431.GS10050@ftp.linux.org.uk>
	<20070211153144.GA11547@osiris.ibm.com>
	<20070211154131.GW10050@ftp.linux.org.uk>
	<45CF3AF6.2060203@garzik.org> <adamz3kbarc.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 11 Feb 2007 21:30:21 -0800
In-Reply-To: <adamz3kbarc.fsf@cisco.com> (Roland Dreier's message of "Sun, 11 Feb 2007 14:16:39 -0800")
Message-ID: <adalkj49c42.fsf_-_@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Feb 2007 05:30:21.0656 (UTC) FILETIME=[E3AA2D80:01C74E66]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On ia64, drivers/base/dma-mapping.c doesn't build because it calls
dma_alloc_noncoherent() and dma_free_noncoherent(), which appear to be
terminally broken; the calls end up generating errors like

    drivers/base/dma-mapping.c: In function 'dmam_noncoherent_release':
    drivers/base/dma-mapping.c:32: error: 'struct ia64_machine_vector' has no member named 'platform_dma_free_coherent'

because the multiple levels of macro expansion in <asm/dma-mapping.h>
and <asm/machvec.h> end up turning a call to dma_free_noncoherent()
into ia64_mv.platform_dma_free_coherent (instead of the intended
ia64_mv.dma_free_coherent).

This patch fixes this by converting dma_{alloc,free}_noncoherent()
into inline functions that call the corresponding coherent functions,
instead of trying to do this with macros.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 include/asm-ia64/dma-mapping.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
index ebd5887..6299b51 100644
--- a/include/asm-ia64/dma-mapping.h
+++ b/include/asm-ia64/dma-mapping.h
@@ -8,9 +8,20 @@
 #include <asm/machvec.h>
 
 #define dma_alloc_coherent	platform_dma_alloc_coherent
-#define dma_alloc_noncoherent	platform_dma_alloc_coherent	/* coherent mem. is cheap */
+/* coherent mem. is cheap */
+static inline void *
+dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		      gfp_t flag)
+{
+	return dma_alloc_coherent(dev, size, dma_handle, flag);
+}
 #define dma_free_coherent	platform_dma_free_coherent
-#define dma_free_noncoherent	platform_dma_free_coherent
+static inline void
+dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
+		     dma_addr_t dma_handle)
+{
+	dma_free_coherent(dev, size, cpu_addr, dma_handle);
+}
 #define dma_map_single		platform_dma_map_single
 #define dma_map_sg		platform_dma_map_sg
 #define dma_unmap_single	platform_dma_unmap_single
