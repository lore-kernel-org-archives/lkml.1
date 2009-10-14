Return-Path: <linux-kernel-owner+w=401wt.eu-S934661AbZJNPuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661AbZJNPuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbZJNPuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:50:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:34146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZJNPuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:50:05 -0400
Date: Wed, 14 Oct 2009 15:48:53 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, gregkh@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gregkh@suse.de, tglx@linutronix.de
In-Reply-To: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
References: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] nvram: Drop the bkl from nvram_llseek()
Message-ID: <tip-6783b9cd7104470a3afab51c205c5aea53a2858f@git.kernel.org>
Git-Commit-ID: 6783b9cd7104470a3afab51c205c5aea53a2858f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6783b9cd7104470a3afab51c205c5aea53a2858f
Gitweb:     http://git.kernel.org/tip/6783b9cd7104470a3afab51c205c5aea53a2858f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 9 Oct 2009 21:20:30 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:49 +0200

nvram: Drop the bkl from nvram_llseek()

There is nothing to protect inside nvram_llseek(), the file
offset doesn't need to be protected and nvram_len is only
initialized from an __init path.

It's safe to remove the big kernel lock there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/generic_nvram.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index ef31738..fda4181 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -19,7 +19,6 @@
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/nvram.h>
 #ifdef CONFIG_PPC_PMAC
@@ -32,7 +31,6 @@ static ssize_t nvram_len;
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
@@ -41,12 +39,11 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += nvram_len;
 		break;
 	}
-	if (offset < 0) {
-		unlock_kernel();
+	if (offset < 0)
 		return -EINVAL;
-	}
+
 	file->f_pos = offset;
-	unlock_kernel();
+
 	return file->f_pos;
 }
 
