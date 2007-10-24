Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXJYBnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXJYBnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXJYBnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:43:12 -0400
Received: from excu-mxob-1.symantec.com ([198.6.49.12]:52916 "EHLO
	excu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbXJYBnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:43:11 -0400
X-Greylist: delayed 24080 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 21:43:11 EDT
Date: Wed, 24 Oct 2007 20:01:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
Message-ID: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_32 CONFIG_HIGHMEM64G with 5GB RAM hung when booting, after issuing
some "request_module: runaway loop modprobe binfmt-0000" messages in
trying to exec /sbin/init.

The binprm buf doesn't see the right ".ELF" header because sg_phys()
is providing the wrong physical addresses for high pages: a 32-bit
unsigned long is too small in this case, we need to use dma_addr_t.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Whether this is a complete patch, suitable for all architectures,
I'm not sure: it builds, boots and runs correctly on the x86_32 box
in question, but you'll be a lot wiser than me about using dma_addr_t
for everyone.  (Seems a bit of a shame to include <asm/types.h> here,
when I think all arches already get to include it one way or another,
typically via asm/scatterlist.h; but I guess it's safest to repeat it.)

 include/linux/scatterlist.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.24-rc1/include/linux/scatterlist.h	2007-10-24 12:42:16.000000000 +0100
+++ linux/include/linux/scatterlist.h	2007-10-24 19:17:13.000000000 +0100
@@ -1,6 +1,7 @@
 #ifndef _LINUX_SCATTERLIST_H
 #define _LINUX_SCATTERLIST_H
 
+#include <asm/types.h>
 #include <asm/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/string.h>
@@ -237,7 +238,7 @@ static inline void sg_init_table(struct 
  *   on the sg page.
  *
  **/
-static inline unsigned long sg_phys(struct scatterlist *sg)
+static inline dma_addr_t sg_phys(struct scatterlist *sg)
 {
 	return page_to_phys(sg_page(sg)) + sg->offset;
 }
