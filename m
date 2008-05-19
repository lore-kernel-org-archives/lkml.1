Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYESN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYESN25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYESNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756775AbYESNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 33/57] pnx4008_wdt: unlocked_ioctl setup
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:48 +0100
Message-ID: <20080519130748.31722.42247.stgit@core>
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

 drivers/watchdog/pnx4008_wdt.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6b8483d..8cd0d53 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -30,8 +30,8 @@
 #include <linux/spinlock.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define MODULE_NAME "PNX4008-WDT: "
 
@@ -144,9 +144,8 @@ static int pnx4008_wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-pnx4008_wdt_write(struct file *file, const char *data, size_t len,
-		  loff_t * ppos)
+static ssize_t pnx4008_wdt_write(struct file *file, const char *data,
+					size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -169,15 +168,14 @@ pnx4008_wdt_write(struct file *file, const char *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 	    WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PNX4008 Watchdog",
 };
 
-static int
-pnx4008_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -238,7 +236,7 @@ static const struct file_operations pnx4008_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = pnx4008_wdt_write,
-	.ioctl = pnx4008_wdt_ioctl,
+	.unlocked_ioctl = pnx4008_wdt_ioctl,
 	.open = pnx4008_wdt_open,
 	.release = pnx4008_wdt_release,
 };

