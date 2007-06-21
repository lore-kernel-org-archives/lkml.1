Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXFUPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXFUPOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXFUPN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:13:58 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:42825 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXFUPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:13:57 -0400
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 11:13:55 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
Date: Thu, 21 Jun 2007 16:54:30 +0200
User-Agent: KMail/1.9.5
Cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <467A4532.40301@rfo.atmel.com>
In-Reply-To: <467A4532.40301@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211654.31463.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas!

Good news!

I think I've found the problem, this seems to work (tested with SLUB and SLAB).

If you're in the cleanup stage, I think the whole kmap and kunmap can be in the 'if (cpu_is_at91rm9200())',
we have no reason to kmap data we don't touch :-D

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
+		kunmap_atomic(buffer - sg->buffer, KM_BIO_SRC_IRQ);
 		flush_dcache_page(sg->page);
 	}

