Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbZJOInk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbZJOInk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbZJOInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:43:37 -0400
Received: from www.tglx.de ([62.245.132.106]:55050 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbZJOInf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:43:35 -0400
Message-Id: <20091015083933.856959433@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [patch 3/7] powerpc: Use unlocked ioctl in nvram_64
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline;
	filename=powerpc-use-unlocked-ioctl-in-nvram-64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl is only used for powermac systems and reads a partition
number from an array which is initialized at boot time way before the
nvram code is initialized. So it's safe to switch to unlocked_ioctl.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/nvram_64.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/powerpc/kernel/nvram_64.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/nvram_64.c
+++ linux-2.6-tip/arch/powerpc/kernel/nvram_64.c
@@ -139,8 +139,8 @@ out:
 
 }
 
-static int dev_nvram_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long dev_nvram_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
 	switch(cmd) {
 #ifdef CONFIG_PPC_PMAC
@@ -169,11 +169,11 @@ static int dev_nvram_ioctl(struct inode 
 }
 
 const struct file_operations nvram_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	dev_nvram_llseek,
-	.read =		dev_nvram_read,
-	.write =	dev_nvram_write,
-	.ioctl =	dev_nvram_ioctl,
+	.owner		= THIS_MODULE,
+	.llseek		= dev_nvram_llseek,
+	.read		= dev_nvram_read,
+	.write		= dev_nvram_write,
+	.unlocked_ioctl	= dev_nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {


