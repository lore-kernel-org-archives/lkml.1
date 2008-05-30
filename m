Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYE3Mp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYE3Mp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYE3MpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:45:11 -0400
Received: from mail.atmel.fr ([81.80.104.162]:60380 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYE3MpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:45:09 -0400
Message-ID: <483FF6CD.4040801@atmel.com>
Date: Fri, 30 May 2008 14:45:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] mmc: at91_mci: avoid timeouts
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Pignat <marc.pignat@hevs.ch>

The at91 mci controller internal state machine seems to often crash. 
This can
be fixed by resetting the controller after each command for at91rm9200 
and by
setting the MCI_BLKR register on at91sam926*.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
drivers/mmc/host/at91_mci.c          |   48 
++++++++++++++++++++++++++++++++++
include/asm-arm/arch-at91/at91_mci.h |    4 +++
2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 4b4518f..6b9662e 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -130,6 +130,43 @@ struct at91mci_host
	struct timer_list timer;
};

+/*
+ * Reset the controller and restore most of the state
+ */
+static void at91_reset_host(struct at91mci_host *host)
+{
+	unsigned long flags;
+	u32 mr;
+	u32 sdcr;
+	u32 dtor;
+	u32 imr;
+
+	local_irq_save(flags);
+	imr = at91_mci_read(host, AT91_MCI_IMR);
+
+	at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
+
+	/* save current state */
+	mr = at91_mci_read(host, AT91_MCI_MR) & 0x7fff;
+	sdcr = at91_mci_read(host, AT91_MCI_SDCR);
+	dtor = at91_mci_read(host, AT91_MCI_DTOR);
+
+	/* reset the controller */
+	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIDIS | AT91_MCI_SWRST);
+
+	/* restore state */
+	at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
+	at91_mci_write(host, AT91_MCI_MR, mr);
+	at91_mci_write(host, AT91_MCI_SDCR, sdcr);
+	at91_mci_write(host, AT91_MCI_DTOR, dtor);
+	at91_mci_write(host, AT91_MCI_IER, imr);
+
+	/* make sure sdio interrupts will fire */
+	at91_mci_read(host, AT91_MCI_SR);
+
+	local_irq_restore(flags);
+}
+
static void at91_timeout_timer(unsigned long data)
{
	struct at91mci_host *host;
@@ -148,6 +185,7 @@ static void at91_timeout_timer(unsigned long data)
				host->request->cmd->error = -ETIMEDOUT;
		}

+		at91_reset_host(host);
		mmc_request_done(host->mmc, host->request);
	}
}
@@ -512,6 +550,11 @@ static void at91_mci_send_command(struct 
at91mci_host *host, struct mmc_command
		mr |= AT91_MCI_PDCMODE;
		at91_mci_write(host, AT91_MCI_MR, mr);

+		if (!cpu_is_at91rm9200())
+			at91_mci_write(host, AT91_MCI_BLKR,
+				AT91_MCI_BLKR_BCNT(blocks) |
+				AT91_MCI_BLKR_BLKLEN(block_length));
+
		/*
		 * Disable the PDC controller
		 */
@@ -584,6 +627,11 @@ static void at91_mci_process_next(struct 
at91mci_host *host)
		at91_mci_send_command(host, host->request->stop);
	} else {
		del_timer(&host->timer);
+		/* the at91rm9200 mci controller hangs after some transfers,
+		 * and the workaround is to reset it after each transfer.
+		 */
+		if (cpu_is_at91rm9200())
+			at91_reset_host(host);
		mmc_request_done(host->mmc, host->request);
	}
}
diff --git a/include/asm-arm/arch-at91/at91_mci.h 
b/include/asm-arm/arch-at91/at91_mci.h
index 1551fc2..400ec10 100644
--- a/include/asm-arm/arch-at91/at91_mci.h
+++ b/include/asm-arm/arch-at91/at91_mci.h
@@ -75,6 +75,10 @@
#define			AT91_MCI_TRTYP_MULTIPLE	(1 << 19)
#define			AT91_MCI_TRTYP_STREAM	(2 << 19)

+#define AT91_MCI_BLKR		0x18		/* Block Register */
+#define		AT91_MCI_BLKR_BCNT(n)	((0xffff & (n)) << 0)	/* Block count */
+#define		AT91_MCI_BLKR_BLKLEN(n)	((0xffff & (n)) << 16)	/* Block lenght */
+
#define AT91_MCI_RSPR(n)	(0x20 + ((n) * 4))	/* Response Registers 0-3 */
#define AT91_MCR_RDR		0x30		/* Receive Data Register */
#define AT91_MCR_TDR		0x34		/* Transmit Data Register */
-- 
1.5.3.7



