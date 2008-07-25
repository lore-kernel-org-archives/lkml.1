Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYGYRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYGYRap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYGYRad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:30:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56760 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751440AbYGYRac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:30:32 -0400
Date: Fri, 25 Jul 2008 18:09:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [build failure] hp-plus.c: (.text+0xd7c1a): undefined reference
 to `ei_close'
Message-ID: <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724052603.GA8744@elte.hu>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
	<20080721191519.GA15843@elte.hu>
	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>
	<20080722072334.GA25241@elte.hu>
	<48865899.3030209@garzik.org>
	<20080723104520.GA20672@elte.hu>
	<20080724052603.GA8744@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 07:26:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> not sure it's known but despite all the fixes i still get:
> 
>  drivers/built-in.o: In function `ne_drv_resume':
>  ne.c:(.text+0x146ba4): undefined reference to `NS8390_init'
>  drivers/built-in.o: In function `ne_block_output':
>  ne.c:(.text+0x146e00): undefined reference to `NS8390_init'

This should do the trick. I can't test it currently as that configuration
now fails to build with mm errors in current git head..

mm/hugetlb.c: In function ‘hugetlb_acct_memory’: mm/hugetlb.c:1507:
error: implicit declaration of function ‘cpuset_mems_nr’

8390: Fix various compile errors

From: Alan Cox <alan@redhat.com>

Some of the original patches got lost along the way, so sort out the
remaining stuff
---

 drivers/net/Makefile |    2 +-
 drivers/net/ne.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 7629c90..f66b79b 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -111,7 +111,7 @@ obj-$(CONFIG_EL2) += 3c503.o 8390p.o
 obj-$(CONFIG_NE2000) += ne.o 8390p.o
 obj-$(CONFIG_NE2_MCA) += ne2.o 8390p.o
 obj-$(CONFIG_HPLAN) += hp.o 8390p.o
-obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
+obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_ULTRAMCA) += smc-mca.o 8390.o
 obj-$(CONFIG_ULTRA32) += smc-ultra32.o 8390.o
diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index 2fec612..4a8a4b1 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = eip_poll;
 #endif
-	NS8390_init(dev, 0);
+	NS8390p_init(dev, 0);
 
 	ret = register_netdev(dev);
 	if (ret)
@@ -794,7 +794,7 @@ retry:
 		if (time_after(jiffies, dma_start + 2*HZ/100)) {		/* 20ms */
 			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ne_reset_8390(dev);
-			NS8390_init(dev,1);
+			NS8390p_init(dev,1);
 			break;
 		}
 
@@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform_device *pdev)
 
 	if (netif_running(dev)) {
 		ne_reset_8390(dev);
-		NS8390_init(dev, 1);
+		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
 	}
 	return 0;
