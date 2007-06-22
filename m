Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbXFVG3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbXFVG3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXFVG3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:29:39 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:41407 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbXFVG3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:29:34 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: [PATCH] mmc-atmel : fix kunmap wrong usage
Date: Fri, 22 Jun 2007 08:28:18 +0200
User-Agent: KMail/1.9.5
Cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <467A4532.40301@rfo.atmel.com> <200706211657.49427.marc.pignat@hevs.ch> <467A9F43.1050007@rfo.atmel.com>
In-Reply-To: <467A9F43.1050007@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220828.18750.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from: Marc Pignat <marc.pignat@hevs.ch>

kunmap must be called on the pointer returned by kmap.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

---

N.B: This is the same patch as yesterday, with proper Signed-off-by and more 
comments.

The buffer variable is used this way:
		buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
So we can't do
		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
we must do
		kunmap_atomic(buffer - sg->offset, KM_BIO_SRC_IRQ);
		
Strangely this misuse showed no problem using CONFIG_SLAB, but oops using
CONFIG_SLUB, (lkml ''Oops in a driver while using SLUB as a SLAB allocator").

Regards

Marc

--- drivers/mmc/host/at91_mci.c-2.6.22-rc5.orig	2007-06-21 16:27:31.000000000 +0200
+++ drivers/mmc/host/at91_mci.c-2.6.22-rc5	2007-06-21 16:42:48.000000000 +0200
@@ -164,7 +164,7 @@ static inline void at91mci_sg_to_dma(str
 		else
 			memcpy(dmabuf, sgbuffer, amount);

-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer - sg->offset, KM_BIO_SRC_IRQ);

 		if (size == 0)
 			break;
@@ -293,7 +293,7 @@ static void at91mci_post_dma_read(struct
 				buffer[index] = swab32(buffer[index]);
 		}

-		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(buffer - sg->offset, KM_BIO_SRC_IRQ);
 		flush_dcache_page(sg->page);
 	}

