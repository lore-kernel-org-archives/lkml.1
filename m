Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYBVReo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYBVReo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbYBVReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:34:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:27431 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYBVReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rLmb0lUBKcmr4dCScNzvMEdLYKqIXBVjJR+A5+MF+bWht7R3BnBYXz1KSY2ReHCFnWhHJK8fKnLQWwsNs1+yKlmKPtpex4b7vsPdAlkH2ICqM/EGVnJDh53FLU3hrcTC8pbEPtVaWcXpNYcvuiak+lNmTlEiXCN7GCjlAW7i1HU=
Subject: [PATCH 2/2] char: fix possible double-unlock in esp.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 09:34:27 -0800
Message-Id: <1203701667.5962.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitting either of the break statements in the while loop would cause
a double-unlock of info->lock.  Add an out label and goto instead of
break to skip the unlock in those cases.

Noticed by sparse:
drivers/char/esp.c:2042:2: warning: context imbalance in 'rs_wait_until_sent' - unexpected unlock

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/esp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index 01fbddd..2b14814 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -2030,16 +2030,17 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 		msleep_interruptible(jiffies_to_msecs(char_time));
 
 		if (signal_pending(current))
-			break;
+			goto out;
 
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
-			break;
+			goto out;
 
 		spin_lock_irqsave(&info->lock, flags);
 		serial_out(info, UART_ESI_CMD1, ESI_NO_COMMAND);
 		serial_out(info, UART_ESI_CMD1, ESI_GET_TX_AVAIL);
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
+out:
 	set_current_state(TASK_RUNNING);
 }
 
-- 
1.5.4.2.200.g99e75

