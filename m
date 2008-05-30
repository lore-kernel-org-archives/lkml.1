Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYE3Mor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYE3Mor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYE3Moj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:44:39 -0400
Received: from mail.atmel.fr ([81.80.104.162]:59566 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYE3Moh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:44:37 -0400
Message-ID: <483FF6AF.20803@atmel.com>
Date: Fri, 30 May 2008 14:44:31 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] mmc: at91_mci: show timeouts
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Pignat <marc.pignat@hevs.ch>

Detect command timeout (or mci controller hangs).

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
drivers/mmc/host/at91_mci.c |   35 +++++++++++++++++++++++++++++++++--
1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 543b64b..4b4518f 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -125,8 +125,33 @@ struct at91mci_host

	/* Latest in the scatterlist that has been enabled for transfer */
	int transfer_index;
+
+	/* Timer for timeouts */
+	struct timer_list timer;
};

+static void at91_timeout_timer(unsigned long data)
+{
+	struct at91mci_host *host;
+
+	host = (struct at91mci_host *)data;
+
+	if (host->request) {
+		dev_err(host->mmc->parent, "Timeout waiting end of packet\n");
+
+		if (host->cmd && host->cmd->data) {
+			host->cmd->data->error = -ETIMEDOUT;
+		} else {
+			if (host->cmd)
+				host->cmd->error = -ETIMEDOUT;
+			else
+				host->request->cmd->error = -ETIMEDOUT;
+		}
+
+		mmc_request_done(host->mmc, host->request);
+	}
+}
+
/*
  * Copy from sg to a dma block - used for transfers
  */
@@ -557,9 +582,10 @@ static void at91_mci_process_next(struct 
at91mci_host *host)
	else if ((!(host->flags & FL_SENT_STOP)) && host->request->stop) {
		host->flags |= FL_SENT_STOP;
		at91_mci_send_command(host, host->request->stop);
-	}
-	else
+	} else {
+		del_timer(&host->timer);
		mmc_request_done(host->mmc, host->request);
+	}
}

/*
@@ -618,6 +644,8 @@ static void at91_mci_request(struct mmc_host *mmc, 
struct mmc_request *mrq)
	host->request = mrq;
	host->flags = 0;

+	mod_timer(&host->timer, jiffies +  HZ);
+
	at91_mci_process_next(host);
}

@@ -940,6 +968,8 @@ static int __init at91_mci_probe(struct 
platform_device *pdev)

	mmc_add_host(mmc);

+	setup_timer(&host->timer, at91_timeout_timer, (unsigned long)host);
+
	/*
	 * monitor card insertion/removal if we can
	 */
@@ -1000,6 +1030,7 @@ static int __exit at91_mci_remove(struct 
platform_device *pdev)
	}

	at91_mci_disable(host);
+	del_timer_sync(&host->timer);
	mmc_remove_host(mmc);
	free_irq(host->irq, host);

-- 
1.5.3.7



