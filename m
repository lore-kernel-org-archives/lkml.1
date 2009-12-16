Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbZLPFCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbZLPFCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZLPFCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:02:51 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:53597 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZLPFCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:02:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
Date: Wed, 16 Dec 2009 10:32:46 +0530
Message-ID: <9F4C7D19E8361D4C94921B95BE08B81BA08D59@zin33exm22.fsl.freescale.net>
In-Reply-To: <4B27D87D.5070908@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
Thread-Index: Acp9tjfZB7rai7bPRBmj1fS0nDtdCQAVjRfQ
References: <4B27D87D.5070908@gmail.com>
From: "Kumar Gopalpet-B05799" <B05799@freescale.com>
To: "Roel Kluin" <roel.kluin@gmail.com>, <netdev@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>interruptTransmit, -Receive and -Error are unsigned so the 
>tests did not work.
>
>This also changes that if irq_of_parse_and_map(np, 0) returns 
>NO_IRQ, that
>gfar_parse_group() returns an -EINVAL.
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>---
>Found using coccinelle: http://coccinelle.lip6.fr/
>
>diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c 
>index 6850dc0..c411682 100644
>--- a/drivers/net/gianfar.c
>+++ b/drivers/net/gianfar.c
>@@ -522,6 +522,7 @@ static int gfar_parse_group(struct 
>device_node *np,  {
> 	u32 *queue_mask;
> 	u64 addr, size;
>+	int irq;
> 
> 	addr = of_translate_address(np,
> 			of_get_address(np, 0, &size, NULL)); @@ 
>-530,20 +531,22 @@ static int gfar_parse_group(struct device_node *np,
> 	if (!priv->gfargrp[priv->num_grps].regs)
> 		return -ENOMEM;
> 
>-	priv->gfargrp[priv->num_grps].interruptTransmit =
>-			irq_of_parse_and_map(np, 0);
>+	irq = irq_of_parse_and_map(np, 0);
>+	if (irq < 0)
>+		return -EINVAL;
>+	priv->gfargrp[priv->num_grps].interruptTransmit = irq;
> 
> 	/* If we aren't the FEC we have multiple interrupts */
> 	if (model && strcasecmp(model, "FEC")) {
>-		priv->gfargrp[priv->num_grps].interruptReceive =
>-			irq_of_parse_and_map(np, 1);
>-		priv->gfargrp[priv->num_grps].interruptError =
>-			irq_of_parse_and_map(np,2);
>-		if 
>(priv->gfargrp[priv->num_grps].interruptTransmit < 0 ||
>-			
>priv->gfargrp[priv->num_grps].interruptReceive < 0 ||
>-			
>priv->gfargrp[priv->num_grps].interruptError < 0) {
>+		irq = irq_of_parse_and_map(np, 1);
>+		if (irq < 0)
> 			return -EINVAL;
>-		}
>+		priv->gfargrp[priv->num_grps].interruptReceive = irq;
>+
>+		irq = irq_of_parse_and_map(np, 2);
>+		if (irq < 0)
>+			return -EINVAL;
>+		priv->gfargrp[priv->num_grps].interruptError = irq;
> 	}
> 
> 	priv->gfargrp[priv->num_grps].grp_id = priv->num_grps;


Won't it be better to change types of interruptTransmit, -Receive and
-Error
in  struct gfar_priv_grp itself. Something like this:

struct gfar_priv_grp {
....
-	unsigned int interruptTransmit;
-	unsigned int interruptReceive;
-	unsigned int interruptError;

+	unsigned int interruptTransmit;
+	unsigned int interruptReceive;
+	unsigned int interruptError;
....
}

--

Thanks
Sandeep
