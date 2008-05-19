Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbYESNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbYESNec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbYESNVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:21:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45992 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761274AbYESNVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:21:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 48/57] txx9: Fix locking, switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:12 +0100
Message-ID: <20080519130912.31722.27701.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/txx9wdt.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)


diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 57cefef..b729cc4 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -45,27 +45,34 @@ static unsigned long txx9wdt_alive;
 static int expect_close;
 static struct txx9_tmr_reg __iomem *txx9wdt_reg;
 static struct clk *txx9_imclk;
+static DECLARE_LOCK(txx9_lock);
 
 static void txx9wdt_ping(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_start(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
 	__raw_writel(WD_TIMER_CCD, &txx9wdt_reg->ccdr);
 	__raw_writel(0, &txx9wdt_reg->tisr);	/* clear pending interrupt */
 	__raw_writel(TXx9_TMTCR_TCE | TXx9_TMTCR_CCDE | TXx9_TMTCR_TMODE_WDOG,
 		     &txx9wdt_reg->tcr);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_stop(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
 	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
 		     &txx9wdt_reg->tcr);
+	spin_unlock(&txx9_lock);
 }
 
 static int txx9wdt_open(struct inode *inode, struct file *file)
@@ -120,13 +127,13 @@ static ssize_t txx9wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int txx9wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -168,18 +175,18 @@ static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
 }
 
 static const struct file_operations txx9wdt_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	txx9wdt_write,
-	.ioctl =	txx9wdt_ioctl,
-	.open =		txx9wdt_open,
-	.release =	txx9wdt_release,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
+	.write		=	txx9wdt_write,
+	.unlocked_ioctl =	txx9wdt_ioctl,
+	.open		=	txx9wdt_open,
+	.release	=	txx9wdt_release,
 };
 
 static struct miscdevice txx9wdt_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&txx9wdt_fops,
+	.minor	=	WATCHDOG_MINOR,
+	.name	=	"watchdog",
+	.fops	=	&txx9wdt_fops,
 };
 
 static struct notifier_block txx9wdt_notifier = {

