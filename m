Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYK2MmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYK2MmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 07:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYK2Mlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 07:41:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:60587 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYK2Mlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 07:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=x4orZ0iAxa2Ksr6GO4XW9K5bJY4JfqOpBV4lSOOe054JWreFveTr81RnEXlCC2BE5U
         ATpO6BdygwmJn/kuCK2j4dDqH/M6K1MbnW8Kte5penCtR6ylCTAmXH29FxnAiWY9wY1O
         PnZMUDnBm8gWVu5nYYkJoU9nLzrvLSNjVv/zc=
Message-ID: <4931387C.4000001@gmail.com>
Date: Sat, 29 Nov 2008 07:41:32 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: hvc_close() unsigned hp->count cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned hp->count cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Similar to the previous patch but with lock. For hvc_struct, see
vi drivers/char/hvc_console.h +47

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 5b819b1..337f6c6 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -366,7 +366,8 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 	hp = tty->driver_data;
 	spin_lock_irqsave(&hp->lock, flags);
 
-	if (--hp->count == 0) {
+	if (hp->count == 1) {
+		hp->count--;
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
@@ -384,7 +385,9 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 	} else {
-		if (hp->count < 0)
+		if (hp->count > 1)
+			hp->count--;
+		else
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
 				hp->vtermno, hp->count);
 		spin_unlock_irqrestore(&hp->lock, flags);

