Return-Path: <linux-kernel-owner+w=401wt.eu-S934488AbZGQPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488AbZGQPHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934137AbZGQPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 11:07:42 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:60897 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZGQPHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 11:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=QSVh9ZgoKhSD+x128uiZ9mxAjztXS7nTgUCa4ago27u3gDXdLHf4g95iTZS8na8QDv
         HTlPi8sdTQAGfvUxzyQjc1wXGWGty1gOVNONyE9uHQqVz/vTmdik8j9wnD1hb0jBy4X6
         pbZI9UsUQT/Qs7NecBkMZlAHT2epCHR8PXmng=
Date: Fri, 17 Jul 2009 23:07:20 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: joerg.roedel@amd.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] ARM:dma-mapping:Support DMA-API debugging facility
 on ARM
Message-ID: <20090717230720.0e486907@linux-lm>
In-Reply-To: <20090717081149.GB3174@n2100.arm.linux.org.uk>
References: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com>
	<d82e647a0907161702v19b4b3f2j44ea9b051eef9e18@mail.gmail.com>
	<20090717081149.GB3174@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 09:11:49 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> I don't think it's suitable, because our implementation calls back
> into the DMA API for dma_map_sg() - this means that the debugging
> code will end up seeing each scatterlist entry twice.  I'm not sure
> what effect that will have, but it's probably not good.

Thank you for the review, and does the patch fix the problem?
If yes, I'll sumbmit the v2 version if necessary or you can use it directly.

>From cd2ef8fc869a2e3442fc37d695ca95d286ac6a4d Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 17 Jul 2009 22:54:01 +0800
Subject: [PATCH 4/4] ARM:dma-mapping:fix dma_map_sg and dma_unmap_sg

This patch removes unnecessary calling of debug_dma_map_page
and debug_dma_unmap_page in dma_map_sg and dma_unmap_sg.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/mm/dma-mapping.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 64e5d82..584018c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -610,7 +610,7 @@ int __dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i, j;
 
 	for_each_sg(sg, s, nents, i) {
-		s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+		s->dma_address = __dma_map_page(dev, sg_page(s), s->offset,
 						s->length, dir);
 		if (dma_mapping_error(dev, s->dma_address))
 			goto bad_mapping;
@@ -619,7 +619,7 @@ int __dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
  bad_mapping:
 	for_each_sg(sg, s, i, j)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+		__dma_unmap_single(dev, sg_dma_address(s), sg_dma_len(s), dir);
 	return 0;
 }
 EXPORT_SYMBOL(__dma_map_sg);
@@ -641,7 +641,7 @@ void __dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+		__dma_unmap_single(dev, sg_dma_address(s), sg_dma_len(s), dir);
 }
 EXPORT_SYMBOL(__dma_unmap_sg);
 
-- 
1.6.0.GIT




-- 
Lei Ming
