Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZJKWjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZJKWjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZJKWjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:39:43 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48865 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZJKWjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mPC2HxAxEI8hkM4FFM/JFtwfnzr3xSh6AaTiXwQoOZfbsvqW9JIXwt3jDcbxCJklyG
         WAuyQ53EPyi3ZP/5Zs5qPYcwXfotPLsJNwWBnHyqQXtXnGw/bSSYONAqkLvPqe0N8M8c
         hDngYFsIVHFb0GgBE9li42w07F374tGwTszE4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2] generic_nvram: Turn nvram_ioctl into an unlocked ioctl
Date: Mon, 12 Oct 2009 00:39:02 +0200
Message-Id: <1255300742-8863-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <200910120025.05208.arnd@arndb.de>
References: <200910120025.05208.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nvram_ioctl is a bkl locked ioctl, but it can be an unlocked ioctl.

- part is provided by the user
- offset is provided by pmac_get_partition() which is safe as it only
  touches nvram_partitions, an array inistialized on __init time and
  read-only the rest of the time.
- nvram_sync() only relies on core99_nvram_sync() which checks
  is_core_99, nvram_data, nvram_image. Those are variables initialized
  on __init time only and their direct values are not touched further.
  The rest modifies the nvram image header, protected by nv_lock
  already.

So it's safe to call nvram_ioctl without the big kernel lock held.

v2: Fix nvram_ioctl to fit unlocked_ioctl signature.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/generic_nvram.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index c49200e..866d04d 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -85,8 +85,7 @@ static ssize_t write_nvram(struct file *file, const char __user *buf,
 	return p - buf;
 }
 
-static int nvram_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static int nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch(cmd) {
 #ifdef CONFIG_PPC_PMAC
@@ -118,11 +117,11 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 }
 
 const struct file_operations nvram_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= nvram_llseek,
-	.read		= read_nvram,
-	.write		= write_nvram,
-	.ioctl		= nvram_ioctl,
+	.owner			= THIS_MODULE,
+	.llseek			= nvram_llseek,
+	.read			= read_nvram,
+	.write			= write_nvram,
+	.unlocked_ioctl		= nvram_ioctl,
 };
 
 static struct miscdevice nvram_dev = {
-- 
1.6.2.3

