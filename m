Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZDPUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZDPUjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZDPUjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:39:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34548 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDPUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vfnvSbFglPL7lEeGuczlz+gnPOnkZHsKaoxvkJkWHcSFwzcmszfws8fSXtQl5IckvG
         atP/LbxIPOZw1qGGRsu0/eQtfVejiT7nR6vTvsTEBVwY3CTcMyrCSdvU9zfggpzHKAD/
         4LJGo1wV7Q8nnAOQpELml/aONOiL+A/IZlooU=
Message-ID: <49E7976F.7020904@gmail.com>
Date: Thu, 16 Apr 2009 22:39:11 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: Z85C30: BCM1480: loops reach -1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement 'loops' reaches -1, which is subsequently returned.
In drivers/serial/zs.c, line 1137 it is considered as a boolean with 0
as failure:

if (zs_transmit_drain(zport, irq))
                write_zsdata(zport, ch);

so to use it as such loops should end at 0 after the loop rather than -1.
This also fixes similar loops in other functions.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/serial/sb1250-duart.c b/drivers/serial/sb1250-duart.c
index a4fb343..319e8b8 100644
--- a/drivers/serial/sb1250-duart.c
+++ b/drivers/serial/sb1250-duart.c
@@ -204,7 +204,7 @@ static int sbd_receive_drain(struct sbd_port *sport)
 {
 	int loops = 10000;
 
-	while (sbd_receive_ready(sport) && loops--)
+	while (sbd_receive_ready(sport) && --loops)
 		read_sbdchn(sport, R_DUART_RX_HOLD);
 	return loops;
 }
@@ -218,7 +218,7 @@ static int __maybe_unused sbd_transmit_drain(struct sbd_port *sport)
 {
 	int loops = 10000;
 
-	while (!sbd_transmit_ready(sport) && loops--)
+	while (!sbd_transmit_ready(sport) && --loops)
 		udelay(2);
 	return loops;
 }
@@ -232,7 +232,7 @@ static int sbd_line_drain(struct sbd_port *sport)
 {
 	int loops = 10000;
 
-	while (!sbd_transmit_empty(sport) && loops--)
+	while (!sbd_transmit_empty(sport) && --loops)
 		udelay(2);
 	return loops;
 }
diff --git a/drivers/serial/zs.c b/drivers/serial/zs.c
index 9e6a873..d8c2809 100644
--- a/drivers/serial/zs.c
+++ b/drivers/serial/zs.c
@@ -231,7 +231,7 @@ static int zs_receive_drain(struct zs_port *zport)
 {
 	int loops = 10000;
 
-	while ((read_zsreg(zport, R0) & Rx_CH_AV) && loops--)
+	while ((read_zsreg(zport, R0) & Rx_CH_AV) && --loops)
 		read_zsdata(zport);
 	return loops;
 }
@@ -241,7 +241,7 @@ static int zs_transmit_drain(struct zs_port *zport, int irq)
 	struct zs_scc *scc = zport->scc;
 	int loops = 10000;
 
-	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && loops--) {
+	while (!(read_zsreg(zport, R0) & Tx_BUF_EMP) && --loops) {
 		zs_spin_unlock_cond_irq(&scc->zlock, irq);
 		udelay(2);
 		zs_spin_lock_cond_irq(&scc->zlock, irq);
@@ -254,7 +254,7 @@ static int zs_line_drain(struct zs_port *zport, int irq)
 	struct zs_scc *scc = zport->scc;
 	int loops = 10000;
 
-	while (!(read_zsreg(zport, R1) & ALL_SNT) && loops--) {
+	while (!(read_zsreg(zport, R1) & ALL_SNT) && --loops) {
 		zs_spin_unlock_cond_irq(&scc->zlock, irq);
 		udelay(2);
 		zs_spin_lock_cond_irq(&scc->zlock, irq);
