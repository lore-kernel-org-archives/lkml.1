Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYL3Kod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYL3Kod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYL3KoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:44:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48472 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYL3KoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:44:23 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-m68k@vger.kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig can't build
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 30 Dec 2008 19:44:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I guess nobody don't test m68knommu at all last three month.
Do we still need to maintain this architecture?


==
Currently, m68knommu defconfig can't build. it cause following error.

net/built-in.o: In function `skb_dma_map':
: undefined reference to `dma_mapping_error'
net/built-in.o: In function `skb_dma_unmap':
: undefined reference to `dma_unmap_single'
net/built-in.o: In function `skb_dma_unmap':
: undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
: undefined reference to `dma_map_single'
net/built-in.o: In function `skb_dma_map':
: undefined reference to `dma_map_page'
net/built-in.o: In function `skb_dma_map':
: undefined reference to `dma_unmap_page'
net/built-in.o: In function `skb_dma_map':
: undefined reference to `dma_unmap_single'

because
 - CONFIG_DMA depend on !NO_DMA
 - m68knommu always doesn't turn on NO_DMA
 - if CONFIG_PCI=n, m68knommu/include/asm/dma-magging.h include
    asm-generic/dma-mapping-broken.h
 - dma-mapping-broken.h generate link time error.
 - m68knommu defconfig doesn't have CONFIG_PCI
 - On the other hand, net/core/skb_dma_map.c assume CONFIG_DMA=y mean
   dma related function is callable

So, we want to turn on CONFIG_DMA if CONFIG_PCI=y only.


CC: David S. Miller <davem@davemloft.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Roman Zippel <zippel@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: linux-m68k@lists.linux-m68k.org
---
 arch/m68knommu/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: b/arch/m68knommu/Kconfig
===================================================================
--- a/arch/m68knommu/Kconfig	2008-12-25 08:26:37.000000000 +0900
+++ b/arch/m68knommu/Kconfig	2008-12-28 21:09:58.000000000 +0900
@@ -73,6 +73,9 @@ config GENERIC_CLOCKEVENTS
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool !PCI
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"


