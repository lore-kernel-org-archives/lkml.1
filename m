Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbZJJPid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbZJJPid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbZJJPiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:09 -0400
Received: from www.tglx.de ([62.245.132.106]:55466 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761974AbZJJPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:06 -0400
Message-Id: <20091010153349.499835683@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline;
	filename=nvram-drop-the-bkl-from-nvram_llseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing to protect inside nvram_llseek(), the file
offset doesn't need to be protected and nvram_len is only
initialized from an __init path.

It's safe to remove the big kernel lock there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <gregkh@suse.de>
LKML-Reference: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/generic_nvram.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/drivers/char/generic_nvram.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/generic_nvram.c
+++ linux-2.6-tip/drivers/char/generic_nvram.c
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
@@ -41,12 +39,11 @@ static loff_t nvram_llseek(struct file *
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
 


