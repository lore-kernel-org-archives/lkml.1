Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZFCV2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZFCV2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZFCV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:27:57 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35961 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZFCV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:27:57 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 17:27:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=InO8/vH/dNclXt1+EDdRwsemPqX44IQubHl3rPmNvColvnyqQNMQvhhlcjfxBZy7Uq
         Rvrrvf9psUv/61rbV7TgmWbNy50QbuoTEGiQdflyloG2I3rAWJtYRrPY3IyHSBR8VBba
         nqRjaRwGs08aHq8TLqQ3OHiGrJdslC/aLL+rY=
Message-ID: <4A270541.4050900@gmail.com>
Date: Thu, 04 Jun 2009 01:20:33 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: davem@davemloft.net, macro@linux-mips.org
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] serial: off by one
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zs_console_putchar() occurs:

	if (zs_transmit_drain(zport, irq))
		write_zsdata(zport, ch);

However if in zs_transmit_drain() no empty Tx Buffer occurs, limit reaches
-1 => true, and the write still occurs.

This patch changes postfix to prefix decrements in this and similar
functions to prevent similar mistakes in the future. This decreases the
iterations with one but the chosen loop count was arbitrary anyway.

In sunhv limit reaches -1, not 0, so the test is off by one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/serial/sb1250-duart.c |    6 +++---
 drivers/serial/sunhv.c        |    2 +-
 drivers/serial/zs.c           |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

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
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index a94a2ab..1df5325 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -461,7 +461,7 @@ static void sunhv_console_write_paged(struct console *con, const char *s, unsign
 					break;
 				udelay(1);
 			}
-			if (limit <= 0)
+			if (limit < 0)
 				break;
 			page_bytes -= written;
 			ra += written;
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
