Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbZJKWN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbZJKWN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZJKWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:13:26 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:49738 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZJKWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s4z9OLPxrnaQP/DApEjtfUGW7AwNhqS9TASEm0vK/6I/k+GybTOVfFCgh3YgR7P3VQ
         UIzx8oqYigPyW6p4UwEAvtiiMkHvY4uQE7HVU9NXgDsVy071PAMcUD8cpUvgRLucxtUC
         v1us9w+O6vFN3v5tWWVNCDGU5IMcbFS+U1juU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] generic_nvram: Turn nvram_ioctl into an unlocked ioctl
Date: Mon, 12 Oct 2009 00:12:45 +0200
Message-Id: <1255299165-8618-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <200910112131.40608.arnd@arndb.de>
References: <200910112131.40608.arnd@arndb.de>
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

Reported-by: Arnd Bergmann <arndbergmann@googlemail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/generic_nvram.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index c49200e..fd448aa 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -118,11 +118,11 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
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

