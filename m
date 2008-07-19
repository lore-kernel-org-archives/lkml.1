Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYGSVkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYGSVkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYGSVj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:39:56 -0400
Received: from hel.is.scarlet.be ([193.74.71.26]:34491 "EHLO hel.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbYGSVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:39:55 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jul 2008 17:39:54 EDT
Message-ID: <48825DD0.5000308@scarlet.be>
Date: Sat, 19 Jul 2008 21:34:08 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ccio_clear_io_tlb() don't need to compute io page number
 a second time.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC--Metrics: hel 0; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kyle,

In ccio-dma.c, I noticed that eventhought the prototype of the function ccio_clear_io_tlb() is:
static CCIO_INLINE void
ccio_clear_io_tlb(struct ioc *ioc, dma_addr_t iovp, size_t byte_cnt)

i.e. the second arg being iovp (afaik the io virtual page number) deduced from the iova (io virtual address)

it's so useless to:
         iovp &= IOVP_MASK;      /* clear offset bits, just want pagenum */

and the only place where it's called is:
         ccio_clear_io_tlb(ioc, CCIO_IOVP(iova), saved_byte_cnt);

it's well an iovp given the macro definition:
#define CCIO_IOVP(iova) ((iova) & IOVP_MASK)

May I so suggest following patch:
--- a/drivers/parisc/ccio-dma.c	2008-07-19 21:17:37.000000000 +0000
+++ b/drivers/parisc/ccio-dma.c	2008-07-19 21:32:54.000000000 +0000
@@ -643,7 +643,6 @@
  {
  	u32 chain_size = 1 << ioc->chainid_shift;

-	iovp &= IOVP_MASK;	/* clear offset bits, just want pagenum */
  	byte_cnt += chain_size;

  	while(byte_cnt > chain_size) {
=== <> ===

Tia,
	J.
