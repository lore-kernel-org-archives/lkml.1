Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYECW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYECW1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYECW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:26:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYECW06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:26:58 -0400
Date: Sun, 4 May 2008 00:26:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor_core@ameritech.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch] irda: fix !PNP support for drivers/net/irda/smsc-ircc2.c
Message-ID: <20080503222646.GA13814@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86.git testing found this build bug on v2.6.26-rc1:

  ERROR: "pnp_get_resource" [drivers/net/irda/smsc-ircc2.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

the driver did not anticipate the case of !CONFIG_PNP which is rare but 
still possible. Instead of restricting the driver to PNP-only in the 
Kconfig space, add the (trivial) dummy struct pnp_driver - this is that 
other drivers use in the !PNP case too.

The driver itself can in theory be initialized on !PNP too in certain 
cases, via smsc_ircc_legacy_probe().

Patch only minimally build tested, i dont have this hardware.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/smsc-ircc2.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/net/irda/smsc-ircc2.c
===================================================================
--- linux.orig/drivers/net/irda/smsc-ircc2.c
+++ linux/drivers/net/irda/smsc-ircc2.c
@@ -376,6 +376,7 @@ MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_t
 
 static int pnp_driver_registered;
 
+#ifdef CONFIG_PNP
 static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
@@ -402,7 +403,9 @@ static struct pnp_driver smsc_ircc_pnp_d
 	.id_table	= smsc_ircc_pnp_table,
 	.probe		= smsc_ircc_pnp_probe,
 };
-
+#else /* CONFIG_PNP */
+static struct pnp_driver smsc_ircc_pnp_driver;
+#endif
 
 /*******************************************************************************
  *
