Return-Path: <linux-kernel-owner+w=401wt.eu-S1030758AbXAZQr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758AbXAZQr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030804AbXAZQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:47:56 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58667 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030758AbXAZQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:47:55 -0500
Date: Fri, 26 Jan 2007 17:47:52 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] cpcmd with vmalloc addresses.
Message-ID: <20070126164752.GE11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <cborntra@de.ibm.com>

[S390] cpcmd with vmalloc addresses.

Change the bounce buffer logic of cpcmd. diag8 needs _real_ memory below
2GB. Therefore vmalloced data does not work. As the data might cross a
page boundary, we cannot use virt_to_page either. The solution is to use
virt_to_page only in the check for a bounce buffer.

There was a redundant check for response==NULL. response < 2GB contains
this check as well.

I also removed the rlen==0 check, since rlen=0 and response!=NULL would
be a caller bug and response==NULL is already checked.

Signed-off-by: Christian Borntraeger <cborntra@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/cpcmd.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/cpcmd.c linux-2.6-patched/arch/s390/kernel/cpcmd.c
--- linux-2.6/arch/s390/kernel/cpcmd.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/cpcmd.c	2007-01-26 17:27:50.000000000 +0100
@@ -16,6 +16,7 @@
 #include <asm/ebcdic.h>
 #include <asm/cpcmd.h>
 #include <asm/system.h>
+#include <asm/io.h>
 
 static DEFINE_SPINLOCK(cpcmd_lock);
 static char cpcmd_buf[241];
@@ -88,13 +89,8 @@ int cpcmd(const char *cmd, char *respons
 	int len;
 	unsigned long flags;
 
-	if ((rlen == 0) || (response == NULL)
-	    || !((unsigned long)response >> 31)) {
-		spin_lock_irqsave(&cpcmd_lock, flags);
-		len = __cpcmd(cmd, response, rlen, response_code);
-		spin_unlock_irqrestore(&cpcmd_lock, flags);
-	}
-	else {
+	if ((virt_to_phys(response) != (unsigned long) response) ||
+			(((unsigned long)response + rlen) >> 31)) {
 		lowbuf = kmalloc(rlen, GFP_KERNEL | GFP_DMA);
 		if (!lowbuf) {
 			printk(KERN_WARNING
@@ -106,6 +102,10 @@ int cpcmd(const char *cmd, char *respons
 		spin_unlock_irqrestore(&cpcmd_lock, flags);
 		memcpy(response, lowbuf, rlen);
 		kfree(lowbuf);
+	} else {
+		spin_lock_irqsave(&cpcmd_lock, flags);
+		len = __cpcmd(cmd, response, rlen, response_code);
+		spin_unlock_irqrestore(&cpcmd_lock, flags);
 	}
 	return len;
 }
