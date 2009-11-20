Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZKTTTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZKTTTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZKTTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:19:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:55110 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZKTTTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=t5BRbaI5ClOXA4hVJ5bo9KUEn0NlVqwRU7VmUAuIKgv/cxdCuwnDXK1wzIHA9PFviL
         EUL/Mu9TMq+JWR8RA/Ot0EBlM+PnGkWaENZ1SACdCMelN4fvaUM6Axg1e0Gd8FLbAPqg
         HLVJ17YLn8wnDSFWy55Zki+Tzek5XeT4z/7bs=
MIME-Version: 1.0
Date: Fri, 20 Nov 2009 20:19:10 +0100
X-Google-Sender-Auth: 32aa3d0f0c20c28c
Message-ID: <10f740e80911201119h6db1e2e1t2c6d40ef1e614094@mail.gmail.com>
Subject: [PATCH] net: ETHOC should depend on HAS_DMA (was: Re: [PATCH] ETHOC: 
	fix build breakage on s390)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:30, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Let driver depend on HAS_IOMEM to avoid build breakage on s390:
>
>  CC      drivers/net/ethoc.o
> drivers/net/ethoc.c: In function 'ethoc_read':
> drivers/net/ethoc.c:221: error: implicit declaration of function 'ioread32'
> drivers/net/ethoc.c: In function 'ethoc_write':
> drivers/net/ethoc.c:226: error: implicit declaration of function 'iowrite32'
> drivers/net/ethoc.c: In function 'ethoc_rx':
> drivers/net/ethoc.c:405: error: implicit declaration of function 'memcpy_fromio'
> drivers/net/ethoc.c: In function 'ethoc_start_xmit':
> drivers/net/ethoc.c:828: error: implicit declaration of function 'memcpy_toio'
>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/net/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/net/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/net/Kconfig
> +++ linux-2.6/drivers/net/Kconfig
> @@ -974,7 +974,7 @@ config ENC28J60_WRITEVERIFY
>
>  config ETHOC
>        tristate "OpenCores 10/100 Mbps Ethernet MAC support"
> -       depends on NET_ETHERNET
> +       depends on NET_ETHERNET && HAS_IOMEM

This is not sufficient, it has to depend on HAS_DMA, too:

>From cdb6fc81662e9afd6019221acc7f56d2d7dcd161 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 20 Nov 2009 20:07:09 +0100
Subject: [PATCH] net: ETHOC should depend on HAS_DMA

When building for Sun 3:

drivers/net/ethoc.c:1091: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `ethoc_probe':
drivers/net/ethoc.c:965: undefined reference to `dma_alloc_coherent'
drivers/net/ethoc.c:1063: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 8015ecc..9e7c76e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -993,7 +993,7 @@ config ENC28J60_WRITEVERIFY

 config ETHOC
 	tristate "OpenCores 10/100 Mbps Ethernet MAC support"
-	depends on NET_ETHERNET && HAS_IOMEM
+	depends on NET_ETHERNET && HAS_IOMEM && HAS_DMA
 	select MII
 	select PHYLIB
 	select CRC32
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
