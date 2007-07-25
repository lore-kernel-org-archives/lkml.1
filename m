Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbXGYHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbXGYHP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXGYHPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:15:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:32827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764165AbXGYHPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:15:01 -0400
Date: Wed, 25 Jul 2007 02:14:12 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: sam@ravnborg.org
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Fleming <afleming@freescale.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: modpost warning question
Message-ID: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following warning:

WARNING: vmlinux.o(.init.text+0x1acdc): Section mismatch: reference to
.exit.text:gfar_mdio_exit (between 'gfar_init' and 'gfar_mdio_init')

I don't understand why its not ok to access .exit.text from .init.text

The following addresses the issue, however I don't particularly like it:

diff --git a/drivers/net/gianfar_mii.c b/drivers/net/gianfar_mii.c
index ac3596f..100bf41 100644
--- a/drivers/net/gianfar_mii.c
+++ b/drivers/net/gianfar_mii.c
@@ -245,7 +245,7 @@ int __init gfar_mdio_init(void)
 	return driver_register(&gianfar_mdio_driver);
 }

-void __exit gfar_mdio_exit(void)
+void gfar_mdio_exit(void)
 {
 	driver_unregister(&gianfar_mdio_driver);
 }
diff --git a/drivers/net/gianfar_mii.h b/drivers/net/gianfar_mii.h
index 5d34004..b373091 100644
--- a/drivers/net/gianfar_mii.h
+++ b/drivers/net/gianfar_mii.h
@@ -42,5 +42,5 @@ struct gfar_mii {
 int gfar_mdio_read(struct mii_bus *bus, int mii_id, int regnum);
 int gfar_mdio_write(struct mii_bus *bus, int mii_id, int regnum, u16 value);
 int __init gfar_mdio_init(void);
-void __exit gfar_mdio_exit(void);
+void gfar_mdio_exit(void);
 #endif /* GIANFAR_PHY_H */
