Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZENWsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZENWsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZENWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:24 -0400
Received: from kroah.org ([198.145.64.141]:51585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZENWmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:23 2009
Message-Id: <20090514223522.855364966@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Lubomir Rintel <lkundrak@v3.sk>,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/51] ne2k-pci: Do not register device until initialized.
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=ne2k-pci-do-not-register-device-until-initialized.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit 379b026ecc20c4657d37e40ead789f7f28f1a1c1 upstream.

Doing it in reverse order causes uevent to be sent before
we have a MAC address, which confuses udev.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ne2k-pci.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ne2k-pci.c
+++ b/drivers/net/ne2k-pci.c
@@ -373,18 +373,17 @@ static int __devinit ne2k_pci_init_one (
 	dev->ethtool_ops = &ne2k_pci_ethtool_ops;
 	NS8390_init(dev, 0);
 
+	memcpy(dev->dev_addr, SA_prom, 6);
+	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
+
 	i = register_netdev(dev);
 	if (i)
 		goto err_out_free_netdev;
 
-	for(i = 0; i < 6; i++)
-		dev->dev_addr[i] = SA_prom[i];
 	printk("%s: %s found at %#lx, IRQ %d, %pM.\n",
 	       dev->name, pci_clone_list[chip_idx].name, ioaddr, dev->irq,
 	       dev->dev_addr);
 
-	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
-
 	return 0;
 
 err_out_free_netdev:


