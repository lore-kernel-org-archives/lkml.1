Return-Path: <linux-kernel-owner+w=401wt.eu-S937822AbYBWAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937822AbYBWAzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937495AbYBWAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:52:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:48061 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841AbYBWAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pmjkFUzwf+c9ipzE5sPOEIESLPZ0edIrVzslX+5gH6Lh+frWbv8FOOi9WOHhMZuV9+qsYGNuocykjMWY5ZwnDdeOFzs6LQNVIMVt+w7m7KAKbNymV/lXjKyF6mqB27Ntfiwv/IImMWOjExL2xMCKd3d8LA2/gn8TGFrE6qeZIqs=
Subject: [PATCHv2 2/2] char: fix possible double-unlock in esp.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47BF20B0.6090203@gmail.com>
References: <1203701667.5962.4.camel@brick>  <47BF20B0.6090203@gmail.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 16:52:30 -0800
Message-Id: <1203727952.5962.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitting either of the break statements in the while loop would cause
a double-unlock of info->lock.

[Jiri Slaby suggested simply returning is safe here, rather than a goto]

Noticed by sparse:
drivers/char/esp.c:2042:2: warning: context imbalance in 'rs_wait_until_sent' - unexpected unlock

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/esp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index 01fbddd..0a33d09 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -2030,10 +2030,10 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 		msleep_interruptible(jiffies_to_msecs(char_time));
 
 		if (signal_pending(current))
-			break;
+			return;
 
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
-			break;
+			return;
 
 		spin_lock_irqsave(&info->lock, flags);
 		serial_out(info, UART_ESI_CMD1, ESI_NO_COMMAND);
-- 
1.5.4.2.200.g99e75



