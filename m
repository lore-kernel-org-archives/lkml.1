Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbXIWOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbXIWOk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 10:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbXIWOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 10:40:12 -0400
Received: from main.gmane.org ([80.91.229.2]:41342 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbXIWOkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 10:40:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: trem <tremyfr@yahoo.fr>
Subject: Re: 2.6.23-rc6-mm1 -- ipg.c don't compile on i386 with CONFIG_HIGHMEM64G
Date: Sun, 23 Sep 2007 16:19:05 +0200
Message-ID: <fd5skp$ctk$1@sea.gmane.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919164348.GC2519@shadowen.org> <Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com> <20070919224409.24baa75b@lappy> <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com> <390426111.11400@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: atoulouse-256-1-144-195.w90-45.abo.wanadoo.fr
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
In-Reply-To: <390426111.11400@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've tried to compile 2.6.23-rc6-mm1, but it fails on ipg.c with the error :
Setup is 10964 bytes (padded to 11264 bytes).
System is 1640 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 2030 modules
WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0
ERROR: "__udivdi3" [drivers/net/ipg.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
error: Bad exit status from /home/trem/rpm/tmp/rpm-tmp.23895 (%build)

I've instigated a bit, and I've found this code in ipg.c :

static void ipg_nic_txfree(struct net_device *dev)
{
       struct ipg_nic_private *sp = netdev_priv(dev);
       void __iomem *ioaddr = sp->ioaddr;
       const unsigned int curr = ipg_r32(TFD_LIST_PTR_0) -
               (sp->txd_map / sizeof(struct ipg_tx)) - 1;
       unsigned int released, pending;



sp->txd_map is an u64
because :
	dma_addr_t txd_map;

And in asm-i386/types.h, I see :
#ifdef CONFIG_HIGHMEM64G
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif
I my config, I use CONFIG_HIGHMEM64G

sizeof(struct ipg_tx) is an u32
So the div failed on i386 because of u64 / u32.

I propose the following patch :

--- linux-2.6.22.old/drivers/net/ipg.c  2007-09-21 20:28:57.000000000 -0400
+++ linux-2.6.22.new/drivers/net/ipg.c  2007-09-21 20:22:15.000000000 -0400
@@ -837,7 +837,7 @@ static void ipg_nic_txfree(struct net_de
        struct ipg_nic_private *sp = netdev_priv(dev);
        void __iomem *ioaddr = sp->ioaddr;
        const unsigned int curr = ipg_r32(TFD_LIST_PTR_0) -
-               (sp->txd_map / sizeof(struct ipg_tx)) - 1;
+               do_div(sp->txd_map , sizeof(struct ipg_tx)) - 1;
        unsigned int released, pending;

        IPG_DEBUG_MSG("_nic_txfree\n");


With this patch, it compiles on i386 and x86_64, but I haven't tested if
this network card works (I don't have it).


regards,
trem

