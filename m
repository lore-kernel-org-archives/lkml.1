Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYFFONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYFFONW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbYFFOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:12:55 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:59024 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754972AbYFFOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:12:54 -0400
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 1/3] memstick: allow "set_param" method to return an error code
Date: Fri,  6 Jun 2008 23:30:30 +1000
Message-Id: <1212759032-11793-2-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1212759032-11793-1-git-send-email-oakad@exemail.com.au>
References: <1212759032-11793-1-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Some controllers (Jmicron, for instance) can report temporal failure condition
during power-on. It is desirable to account for this using a return value of
"set_param" device method. The return value can also be handy to distinguish
between supported and unsupported device parameters in run time.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c  |   18 +++++++---
 drivers/memstick/host/jmb38x_ms.c |   69 ++++++++++++++++++++++++++----------
 drivers/memstick/host/tifm_ms.c   |   17 ++++-----
 include/linux/memstick.h          |    2 +-
 4 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 61b98c3..3c7d9a7 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -415,10 +415,14 @@ err_out:
 	return NULL;
 }
 
-static void memstick_power_on(struct memstick_host *host)
+static int memstick_power_on(struct memstick_host *host)
 {
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
-	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+	int rc = host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+
+	if (!rc)
+		rc = host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+
+	return rc;
 }
 
 static void memstick_check(struct work_struct *work)
@@ -573,11 +577,15 @@ EXPORT_SYMBOL(memstick_suspend_host);
  */
 void memstick_resume_host(struct memstick_host *host)
 {
+	int rc = 0;
+
 	mutex_lock(&host->lock);
 	if (host->card)
-		memstick_power_on(host);
+		rc = memstick_power_on(host);
 	mutex_unlock(&host->lock);
-	memstick_detect_change(host);
+
+	if (!rc)
+		memstick_detect_change(host);
 }
 EXPORT_SYMBOL(memstick_resume_host);
 
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index a054668..10be6f3 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -609,36 +609,68 @@ static void jmb38x_ms_request(struct memstick_host *msh)
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_reset(struct jmb38x_ms_host *host)
+static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
 {
-	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
+	int cnt;
 
-	writel(HOST_CONTROL_RESET_REQ, host->addr + HOST_CONTROL);
+	writel(HOST_CONTROL_RESET_REQ | HOST_CONTROL_CLOCK_EN
+	       | readl(host->addr + HOST_CONTROL),
+	       host->addr + HOST_CONTROL);
+	mmiowb();
+
+	for (cnt = 0; cnt < 20; ++cnt) {
+		if (!(HOST_CONTROL_RESET_REQ
+		      & readl(host->addr + HOST_CONTROL)))
+			goto reset_next;
 
-	while (HOST_CONTROL_RESET_REQ
-	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {
 		ndelay(20);
-		dev_dbg(&host->chip->pdev->dev, "reset %08x\n", host_ctl);
 	}
+	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
+	return -EIO;
 
-	writel(HOST_CONTROL_RESET, host->addr + HOST_CONTROL);
+reset_next:
+	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
+	       | readl(host->addr + HOST_CONTROL),
+	       host->addr + HOST_CONTROL);
+	mmiowb();
+
+	for (cnt = 0; cnt < 20; ++cnt) {
+		if (!(HOST_CONTROL_RESET
+		      & readl(host->addr + HOST_CONTROL)))
+			goto reset_ok;
+
+		ndelay(20);
+	}
+	dev_dbg(&host->chip->pdev->dev, "reset timeout\n");
+	return -EIO;
+
+reset_ok:
 	mmiowb();
 	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
 	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+	return 0;
 }
 
-static void jmb38x_ms_set_param(struct memstick_host *msh,
-				enum memstick_param param,
-				int value)
+static int jmb38x_ms_set_param(struct memstick_host *msh,
+			       enum memstick_param param,
+			       int value)
 {
 	struct jmb38x_ms_host *host = memstick_priv(msh);
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
 	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
+	int rc = 0;
 
-	switch (param) {
+	switch(param) {
 	case MEMSTICK_POWER:
 		if (value == MEMSTICK_POWER_ON) {
-			jmb38x_ms_reset(host);
+			rc = jmb38x_ms_reset(host);
+			if (rc)
+				return rc;
+
+			host_ctl = 7;
+			host_ctl |= HOST_CONTROL_POWER_EN
+				 | HOST_CONTROL_CLOCK_EN;
+			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
 					: PAD_PU_PD_ON_MS_SOCK0,
@@ -647,11 +679,7 @@ static void jmb38x_ms_set_param(struct memstick_host *msh,
 			writel(PAD_OUTPUT_ENABLE_MS,
 			       host->addr + PAD_OUTPUT_ENABLE);
 
-			host_ctl = 7;
-			host_ctl |= HOST_CONTROL_POWER_EN
-				 | HOST_CONTROL_CLOCK_EN;
-			writel(host_ctl, host->addr + HOST_CONTROL);
-
+			msleep(10);
 			dev_dbg(&host->chip->pdev->dev, "power on\n");
 		} else if (value == MEMSTICK_POWER_OFF) {
 			host_ctl &= ~(HOST_CONTROL_POWER_EN
@@ -660,7 +688,8 @@ static void jmb38x_ms_set_param(struct memstick_host *msh,
 			writel(0, host->addr + PAD_OUTPUT_ENABLE);
 			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
 			dev_dbg(&host->chip->pdev->dev, "power off\n");
-		}
+		} else
+			return -EINVAL;
 		break;
 	case MEMSTICK_INTERFACE:
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
@@ -686,12 +715,14 @@ static void jmb38x_ms_set_param(struct memstick_host *msh,
 			host_ctl &= ~HOST_CONTROL_REI;
 			clock_ctl = CLOCK_CONTROL_60MHZ;
 			clock_delay = 0;
-		}
+		} else
+			return -EINVAL;
 		writel(host_ctl, host->addr + HOST_CONTROL);
 		writel(clock_ctl, host->addr + CLOCK_CONTROL);
 		writel(clock_delay, host->addr + CLOCK_DELAY);
 		break;
 	};
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 8577de4..1445876 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -489,15 +489,12 @@ static void tifm_ms_request(struct memstick_host *msh)
 	return;
 }
 
-static void tifm_ms_set_param(struct memstick_host *msh,
-			      enum memstick_param param,
-			      int value)
+static int tifm_ms_set_param(struct memstick_host *msh,
+			     enum memstick_param param,
+			     int value)
 {
 	struct tifm_ms *host = memstick_priv(msh);
 	struct tifm_dev *sock = host->dev;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sock->lock, flags);
 
 	switch (param) {
 	case MEMSTICK_POWER:
@@ -512,7 +509,8 @@ static void tifm_ms_set_param(struct memstick_host *msh,
 			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
 			       sock->addr + SOCK_MS_SYSTEM);
 			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
-		}
+		} else
+			return -EINVAL;
 		break;
 	case MEMSTICK_INTERFACE:
 		if (value == MEMSTICK_SERIAL) {
@@ -525,11 +523,12 @@ static void tifm_ms_set_param(struct memstick_host *msh,
 			writel(TIFM_CTRL_FAST_CLK
 			       | readl(sock->addr + SOCK_CONTROL),
 			       sock->addr + SOCK_CONTROL);
-		}
+		} else
+			return -EINVAL;
 		break;
 	};
 
-	spin_unlock_irqrestore(&sock->lock, flags);
+	return 0;
 }
 
 static void tifm_ms_abort(unsigned long data)
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 37a5cdb..2fe599c 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -284,7 +284,7 @@ struct memstick_host {
 	/* Notify the host that some requests are pending. */
 	void                (*request)(struct memstick_host *host);
 	/* Set host IO parameters (power, clock, etc).     */
-	void                (*set_param)(struct memstick_host *host,
+	int                 (*set_param)(struct memstick_host *host,
 					 enum memstick_param param,
 					 int value);
 	unsigned long       private[0] ____cacheline_aligned;
-- 
1.5.3.6

