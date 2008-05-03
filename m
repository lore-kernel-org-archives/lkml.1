Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYECTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYECTcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYECTci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:32:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYECTch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:32:37 -0400
Date: Sat, 3 May 2008 21:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: samuel@sortiz.org, Dmitry Torokhov <dtor_core@ameritech.net>
Subject: [patch] irda: fix !PNP support in drivers/net/irda/nsc-ircc.c
Message-ID: <20080503193222.GA23373@elte.hu>
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


x86.git testing found the following build failure in latest -git:

 drivers/built-in.o: In function `nsc_ircc_pnp_probe':
 nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
 drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references to `pnp_get_resource' follow
 make: *** [.tmp_vmlinux1] Error 1

triggered via this config:

  http://redhat.com/~mingo/misc/config-Sat_May__3_20_53_13_CEST_2008.bad

while generally most users will have PNP enabled, drivers can support
non-PNP build mode too - and most drivers implement it. That is typically
done by providing a dummy pnp_driver structure that will not probe anything.

The fallback routines in the driver will handle this dumber mode of
operation too.

This patch implements that. I have not tested whether this actually
works on real hardware so take care. It does resolve the build bug.

[ Another solution that is used by a few drivers is to exclude the driver
  in the Kconfig if PNP is disabled, via "depends on PNP", but this would
  limit the availability of the driver needlessly. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/nsc-ircc.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/net/irda/nsc-ircc.c
===================================================================
--- linux.orig/drivers/net/irda/nsc-ircc.c
+++ linux/drivers/net/irda/nsc-ircc.c
@@ -100,7 +100,9 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 static int nsc_ircc_init_108(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_338(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info);
+#ifdef CONFIG_PNP
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
+#endif
 
 /* These are the known NSC chips */
 static nsc_chip_t chips[] = {
@@ -156,9 +158,11 @@ static const struct pnp_device_id nsc_ir
 MODULE_DEVICE_TABLE(pnp, nsc_ircc_pnp_table);
 
 static struct pnp_driver nsc_ircc_pnp_driver = {
+#ifdef CONFIG_PNP
 	.name = "nsc-ircc",
 	.id_table = nsc_ircc_pnp_table,
 	.probe = nsc_ircc_pnp_probe,
+#endif
 };
 
 /* Some prototypes */
@@ -916,6 +920,7 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 	return 0;
 }
 
+#ifdef CONFIG_PNP
 /* PNP probing */
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id)
 {
@@ -952,6 +957,7 @@ static int nsc_ircc_pnp_probe(struct pnp
 
 	return 0;
 }
+#endif
 
 /*
  * Function nsc_ircc_setup (info)
