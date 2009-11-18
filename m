Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZKROhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZKROhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZKROhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:37:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35753 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757486AbZKROhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:37:03 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 10/11] sdio_uart: Fix the locking on "func" for new code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:20:38 +0000
Message-ID: <20091118142033.3582.90944.stgit@localhost.localdomain>
In-Reply-To: <20091118141802.3582.47363.stgit@localhost.localdomain>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new dtr_rts function didn't take the port->func lock as it should
so add use of the lock there.


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index f14338b..6d8f019 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -567,10 +567,14 @@ static void uart_dtr_rts(struct tty_port *tport, int onoff)
 {
 	struct sdio_uart_port *port =
 			container_of(tport, struct sdio_uart_port, port);
+	int ret = sdio_uart_claim_func(port);
+	if (ret)
+		return;
 	if (onoff == 0)
 		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	else
 		sdio_uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+	sdio_uart_release_func(port);
 }
 
 /**

