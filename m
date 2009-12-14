Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZLNRxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZLNRxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbZLNRxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:53:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45277 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbZLNRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZRV6veIgNefgkSAVrWMbblIvve9WuJI/5PMCNMNNzF3tXXMh85I/gGdavx1brai4Hx
         0HLXrnEL0G7yskbh9WlVzB4PTqepNRZ+oIkPejEEv8L+df3zuqHT51ceUbZvwnQaX3xv
         yJOAw3iYfPzhFD0qKi08qgvmkpfnhf2DPwhu4=
Subject: [PATCH 4/4] regulator: mc13783-regulator: correct the probing time.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <1260811598.2022.144.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
	 <1260811598.2022.144.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 18:53:35 +0100
Message-ID: <1260813215.2022.171.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the mc13783-regulator driver is built in kernel, probing it during
the regulator subsystem initialisation result in a fault.

That is because regulator subsystem is planned to be initialised very early
in the boot process, before the mfd subsystem initialisation.

The mc12783-regulator probing process need to access to the mc13783-core
functionality to read/write mc13783 registers and so must be called after
the mc13783-core driver initialisation.

The way to do this is to let the kernel probe the mc13783-regulator driver when 
mc13783-core register his regulator subdevice.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 3d5d349..a40e35a 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -509,12 +509,12 @@ static struct platform_driver mc13783_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.remove		= __devexit_p(mc13783_regulator_remove),
+	.probe		= mc13783_regulator_probe,
 };
 
 static int __init mc13783_regulator_init(void)
 {
-	return platform_driver_probe(&mc13783_regulator_driver,
-			mc13783_regulator_probe);
+	return platform_driver_register(&mc13783_regulator_driver);
 }
 subsys_initcall(mc13783_regulator_init);
 
-- 
1.6.3.3



