Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZFWCQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZFWCQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWCPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:15:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:58284 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZFWCPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:15:51 -0400
Date: Tue, 23 Jun 2009 11:14:22 +0900
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 2/2] Blackfin: fix dma-mapping build errors
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1245722086-13340-2-git-send-email-vapier@gentoo.org>
References: <1245722086-13340-1-git-send-email-vapier@gentoo.org>
	<1245722086-13340-2-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090623111430D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 23 Jun 2009 11:14:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 21:54:46 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> The recent deprecation of dma_sync_{sg,single} ironically broke Blackfin
> systems.

Oops, sorry about that.


> This is because we don't define dma_sync_sg_for_cpu at all, so
> until the DMA asm-generic conversion/cleanup is done after the next
> release, simply redirect the dma_sync_sg_for_cpu to the debug version.

This doesn't look correct (though it works). dma-debug.h is supposed
to be used by architectures that support DMA_API_DEBUG feature
(blackfin doesn't support it). dma_sync_sg_for_cpu is not the
debug version of dma_sync_sg_for_cpu.

I think that simply adding dummy dma_sync_single_for_device() is a
proper solution (as blackfin already does wrt dma_sync_single_for_cpu
and dma_sync_single_for_device).

Architectures are also supposed to have dma_sync_sg_for_cpu and
dma_sync_sg_for_device, so let's add both.


diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index d7d9148..6997836 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -95,4 +95,17 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					enum dma_data_direction dir)
 {
 }
+
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+				       struct scatterlist *sg,
+				       int nents, enum dma_data_direction dir)
+{
+}
+
+static inline void dma_sync_sg_for_device(struct device *dev,
+					  struct scatterlist *sg,
+					  int nents, enum dma_data_direction dir)
+{
+}
+
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
