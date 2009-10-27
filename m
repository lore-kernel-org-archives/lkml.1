Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZJ0KRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZJ0KRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZJ0KRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:17:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:58635 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZJ0KRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:17:05 -0400
Date: Tue, 27 Oct 2009 19:15:59 +0900
To: JBeulich@novell.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, yinghai@kernel.org,
       tglx@linutronix.de, tiwai@suse.de, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent	 allocations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4AE6CFC4020000780001BF75@vpn.id2.novell.com>
References: <4AE6CA2A020000780001BF51@vpn.id2.novell.com>
	<20091027183658A.fujita.tomonori@lab.ntt.co.jp>
	<4AE6CFC4020000780001BF75@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027191544S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 19:16:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 09:47:32 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> >>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> 27.10.09 10:37 >>>
> >On Tue, 27 Oct 2009 09:23:38 +0000
> >"Jan Beulich" <JBeulich@novell.com> wrote:
> >
> >> Because there's quite a few of them - just search for callers of
> >> dma_alloc_coherent() passing NULL as the first argument. Of course
> >> I'd rather see the fallback gone, but I think this requires cooperation
> >> from/action taken by the driver maintainers first. A first step might be
> >> to add a WRN_ON() for that case, but I don't see it being reasonable
> >> to eliminate the fallback right away. Hence, with it having got broken
> >> in .26 I think it is reasonable to fix it for the time being.
> >
> >Well, the most of them are drivers that nobody cares about (uses).
> >
> >What drivers did you hit this problem with?
> 
> drivers/firmware/dell_rbu.c (on .27.x, and in particular with the derivation
> of __GFP_NORETRY from __GFP_DMA, which fortunately doesn't exist in
> newer kernels anymore).

I don't know anything about this driver (and even I'm not sure why
this driver uses dma_alloc_coherent) but why can't this driver use
rbu_device with dma API?


diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index b4704e1..481b009 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -372,8 +372,8 @@ static void img_update_free(void)
 	memset(rbu_data.image_update_buffer, 0,
 		rbu_data.image_update_buffer_size);
 	if (rbu_data.dma_alloc == 1)
-		dma_free_coherent(NULL, rbu_data.bios_image_size,
-			rbu_data.image_update_buffer, dell_rbu_dmaaddr);
+		dma_free_coherent(&rbu_device->dev, rbu_data.bios_image_size,
+				  rbu_data.image_update_buffer, dell_rbu_dmaaddr);
 	else
 		free_pages((unsigned long) rbu_data.image_update_buffer,
 			rbu_data.image_update_ordernum);
@@ -443,7 +443,7 @@ static int img_update_realloc(unsigned long size)
 	if (img_buf_phys_addr > BIOS_SCAN_LIMIT) {
 		free_pages((unsigned long) image_update_buffer, ordernum);
 		ordernum = -1;
-		image_update_buffer = dma_alloc_coherent(NULL, size,
+		image_update_buffer = dma_alloc_coherent(&rbu_device->dev, size,
 			&dell_rbu_dmaaddr, GFP_KERNEL);
 		dma_alloc = 1;
 	}
@@ -699,6 +699,8 @@ static int __init dcdrbu_init(void)
 			"failed\n", __func__);
 		return PTR_ERR(rbu_device);
 	}
+	rbu_device->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	rbu_device->dev.dma_mask = &rbu_device->dev.coherent_dma_mask;
 
 	rc = sysfs_create_bin_file(&rbu_device->dev.kobj, &rbu_data_attr);
 	if (rc)
