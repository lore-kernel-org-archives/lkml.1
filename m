Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYJMD76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYJMD76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYJMD7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:59:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47111
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYJMD7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:59:48 -0400
Date: Sun, 12 Oct 2008 20:59:24 -0700 (PDT)
Message-Id: <20081012.205924.215555653.davem@davemloft.net>
To: pvp-lsts@fs.ru.acad.bg
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       ivecera@redhat.com, ilpo.jarvinen@helsinki.fi
Subject: Re: [NET][r8169 regression] Linux "v2.6.27-2721-gfd04808" panics
 on boot - reverting commit 7bf6bf4803df1adc927f585168d2135fb019c698 fixes
 it
From: David Miller <davem@davemloft.net>
In-Reply-To: <courier.48F24D51.00004EAC@fs.ru.acad.bg>
References: <courier.48F24D51.00004EAC@fs.ru.acad.bg>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date: Sun, 12 Oct 2008 22:17:37 +0300

> Hello! 
> 
> The latest stable snapshot of Linus' tree panics during boot for me.
> "git describe" says "v2.6.27-2721-gfd04808".
> I was only able to take a picture of the panic with my phone camera,
> see [1] and [2] (sorry for the awful quality).
> After looking around, I marked a few commits, and I think I got lucky -
> reverted the first one, and my machine booted up normally.
> The commit I reverted is : 

This is fixed by the following patch by Petr:

r8169: NULL pointer dereference on r8169 load

mmio_addr in r8169 needs to be initialized before use

Maybe that all tp-> initialization should be moved before rtl_init_mac_address call,
but this is enough to get rid of crash in rtl_rar_set due to mmio_addr being uninitialized.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/r8169.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index bdae2c5..c821da2 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2154,6 +2154,8 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	spin_lock_init(&tp->lock);
 
+	tp->mmio_addr = ioaddr;
+
 	rtl_init_mac_address(tp, ioaddr);
 
 	/* Get MAC address */
@@ -2186,7 +2188,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	tp->intr_mask = 0xffff;
-	tp->mmio_addr = ioaddr;
 	tp->align = cfg->align;
 	tp->hw_start = cfg->hw_start;
 	tp->intr_event = cfg->intr_event;
-- 
1.5.6.5

