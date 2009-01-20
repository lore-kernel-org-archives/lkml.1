Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZATVzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZATVzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZATVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:54:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55637 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZATVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CCtVt6WFKJWFtAL61BVPNv8lwJ0lnlL4RdnN6GLZMKuqETFr1GPvWgbf/fDr9sO07R
         9PWyt/f+k/7296KV2hv56EIl9Kfbdp1y5ZqVsqFu/mStCOifv6Uw2XipJwsNLITgG14M
         g4vcuFbsjqDki4pkQDxeMvG+uDzZv8ejtpAQU=
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 21:48:00 +0000
Message-ID: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
Subject: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
From: Adrian McMenamin <lkmladrian@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this code compares a size in bytes with a size in pages.
This patch makes both sides of the comparison bytes.


Previous code (introduced in commit
58c6d3dfe436eb8cfb451981d8fdc9044eaf42da) brakes Dreamcast, this code
has been tested and works on the Dreamcast.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index 0387074..8114dd7 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -112,13 +112,13 @@ int dma_alloc_from_coherent(struct device *dev,
ssize_t size,
 	struct dma_coherent_mem *mem;
 	int order = get_order(size);
 	int pageno;

 	if (!dev)
 		return 0;
 	mem = dev->dma_mem;
 	if (!mem)
 		return 0;
-	if (unlikely(size > mem->size))
+	if (unlikely(size > mem->size << PAGE_SHIFT))
  		return 0;

 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
