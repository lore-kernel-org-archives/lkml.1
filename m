Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbXB1XOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbXB1XOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXB1XOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:14:24 -0500
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:25046 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926AbXB1XOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:14:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Disposition:Message-Id:Cc:Content-Type:Content-Transfer-Encoding;
  b=m4KTTqH39Cy6KP9pylAiy2HGNZKsTR/rk9gzUP5sSTYBIReM5F+iuUKx2jpU5tY+pkVLtLJlpFSiCbC90tplW4rvvp8h4BPUu+su6oaaNuTWADJDZUmbv9yuk8v17tViPvXzLZEVWGl4MiUtUdbNRKIRWDngRpgd39Leq1yonjQ=  ;
X-YMail-OSG: zBsT2QoVM1lSrJ0EkHI39.nvGVt.SLwI.BCTE0_VuCmjD3TqJM3d1o1AJ8CDBf1nF6pDHKl4nOR7nhzRNooe_qq_nevUITBx_9RhHuDOVl4k8MuJhRCdAJBC6EnHXrhbdxtmdhYJgm1O.g--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc2] init dma masks in pnp_dev
Date: Wed, 28 Feb 2007 15:14:01 -0800
User-Agent: KMail/1.7.1
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702281514.01521.david-b@pacbell.net>
Cc: Adam Belay <abelay@novell.com>, perex@suse.cz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PNP now initializes device dma masks, which prevents oopses when generic
dma calls are made using pnp device nodes.

This assumes PNP only uses ISA DMA, with 24 bit addresses; and that it's
safe to init those masks for all devices (rather than finding out which
devices have been assigned DMA channels, and handling only those).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/include/linux/pnp.h
===================================================================
--- g26.orig/include/linux/pnp.h	2007-02-12 00:31:26.000000000 -0800
+++ g26/include/linux/pnp.h	2007-02-18 20:18:55.000000000 -0800
@@ -177,6 +177,7 @@ static inline void pnp_set_card_drvdata 
 
 struct pnp_dev {
 	struct device dev;		/* Driver Model device interface */
+	u64 dma_mask;
 	unsigned char number;		/* used as an index, must be unique */
 	int status;
 
Index: g26/drivers/pnp/core.c
===================================================================
--- g26.orig/drivers/pnp/core.c	2005-11-12 22:24:18.000000000 -0800
+++ g26/drivers/pnp/core.c	2007-02-18 20:42:17.000000000 -0800
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <linux/dma-mapping.h>
 
 #include "base.h"
 
@@ -114,6 +115,8 @@ int __pnp_add_device(struct pnp_dev *dev
 	int ret;
 	pnp_fixup_device(dev);
 	dev->dev.bus = &pnp_bus_type;
+	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dma_mask = dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
 	dev->dev.release = &pnp_release_device;
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
