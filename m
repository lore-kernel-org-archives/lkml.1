Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZLOSkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZLOSkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZLOSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:40:22 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48264 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZLOSkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VYJdMHTbW8ibHy5iK62rVomXk092r+BkorbfJer4JfgGJaYio76Hr/SyQ6Y2AB8i/9
         uZsiDOBses55ZeRit5xHwLfdYg3SJL2NngIUfdxsz1/bD2Wtf2emYK7GvBREKTS44b3N
         E/OoreWvBHNksO55YmP6lWDzEc+D3ymQiLy80=
Message-ID: <4B27D87D.5070908@gmail.com>
Date: Tue, 15 Dec 2009 19:42:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptTransmit, -Receive and -Error are unsigned so the tests did not work.

This also changes that if irq_of_parse_and_map(np, 0) returns NO_IRQ, that
gfar_parse_group() returns an -EINVAL.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 6850dc0..c411682 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -522,6 +522,7 @@ static int gfar_parse_group(struct device_node *np,
 {
 	u32 *queue_mask;
 	u64 addr, size;
+	int irq;
 
 	addr = of_translate_address(np,
 			of_get_address(np, 0, &size, NULL));
@@ -530,20 +531,22 @@ static int gfar_parse_group(struct device_node *np,
 	if (!priv->gfargrp[priv->num_grps].regs)
 		return -ENOMEM;
 
-	priv->gfargrp[priv->num_grps].interruptTransmit =
-			irq_of_parse_and_map(np, 0);
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq < 0)
+		return -EINVAL;
+	priv->gfargrp[priv->num_grps].interruptTransmit = irq;
 
 	/* If we aren't the FEC we have multiple interrupts */
 	if (model && strcasecmp(model, "FEC")) {
-		priv->gfargrp[priv->num_grps].interruptReceive =
-			irq_of_parse_and_map(np, 1);
-		priv->gfargrp[priv->num_grps].interruptError =
-			irq_of_parse_and_map(np,2);
-		if (priv->gfargrp[priv->num_grps].interruptTransmit < 0 ||
-			priv->gfargrp[priv->num_grps].interruptReceive < 0 ||
-			priv->gfargrp[priv->num_grps].interruptError < 0) {
+		irq = irq_of_parse_and_map(np, 1);
+		if (irq < 0)
 			return -EINVAL;
-		}
+		priv->gfargrp[priv->num_grps].interruptReceive = irq;
+
+		irq = irq_of_parse_and_map(np, 2);
+		if (irq < 0)
+			return -EINVAL;
+		priv->gfargrp[priv->num_grps].interruptError = irq;
 	}
 
 	priv->gfargrp[priv->num_grps].grp_id = priv->num_grps;
