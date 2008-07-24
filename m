Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYGXPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYGXPPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGXPPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:15:07 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:12523 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYGXPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=kx3F2FAVo/uNeG7a983R1Ccst6JlJwUQu3I5uVBoWvG9u4Yc/nTaMlOkQXApmaSS5I
         U6CWwODRX5QIAMI4P6NmQ4oBuZG8/gicdSrsNTIWOXOYBip/Q6YJKG2YeAtK0Ilc3OXE
         gCEbhMQNfaGmfhvZKw5cCaaHDRYg+yBCV4akc=
Date: Thu, 24 Jul 2008 16:13:25 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, jdike@addtoit.com, alan@redhat.com
Subject: [Resend Patch] uml: fix a build error about tty
Message-ID: <20080724151325.GP2993@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixed this error:

  CC      arch/um/drivers/line.o
  /home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c: In
function ‘line_write_interrupt’:
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:366: error:
‘struct tty_ldisc’ has no member named ‘write_wakeup’
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:367: error:
‘struct tty_ldisc’ has no member named ‘write_wakeup’


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: jdike@addtoit.com
Acked-by: Alan Cox <alan@redhat.com>

---
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 5047490..d741f35 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -362,19 +362,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	if (tty == NULL)
 		return IRQ_NONE;
 
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
-	   (tty->ldisc.write_wakeup != NULL))
-		(tty->ldisc.write_wakeup)(tty);
-
-	/*
-	 * BLOCKING mode
-	 * In blocking mode, everything sleeps on tty->write_wait.
-	 * Sleeping in the console driver would break non-blocking
-	 * writes.
-	 */
-
-	if (waitqueue_active(&tty->write_wait))
-		wake_up_interruptible(&tty->write_wait);
+	tty_wakeup(tty);
 	return IRQ_HANDLED;
 }
 
