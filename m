Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZFVQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZFVQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZFVQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:43:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37480 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbZFVQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:43:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/15] serial: fix off by one errors
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:41:56 +0100
Message-ID: <20090622174152.25341.62978.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

In zs_console_putchar() occurs:

	if (zs_transmit_drain(zport, irq))
		write_zsdata(zport, ch);

However if in zs_transmit_drain() no empty Tx Buffer occurs, limit reaches
-1 => true, and the write still occurs.

This patch changes postfix to prefix decrements in this and similar
functions to prevent similar mistakes in the future.  This decreases the
iterations with one but the chosen loop count was arbitrary anyway.

In sunhv limit reaches -1, not 0, so the test is off by one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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

