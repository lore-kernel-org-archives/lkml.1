Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbZE2Sez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbZE2Sez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZE2Sed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:34:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:64745 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZE2Seb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:34:31 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/2] pl2303 usb_serial: implement sysrq handling on break
Date: Fri, 29 May 2009 13:34:16 -0500
Message-Id: <1243622057-17671-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 May 2009 18:36:24.0874 (UTC) FILETIME=[5EE2E0A0:01C9E08C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add callbacks to process the sysrq when using a pl2303 usb device as a
console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/pl2303.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 751a533..c5a8745 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -946,6 +946,8 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->line_status = data[status_idx];
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (priv->line_status & UART_BREAK_ERROR)
+		usb_serial_handle_break(port);
 	wake_up_interruptible(&priv->delta_msr_wait);
 }
 
@@ -1056,7 +1058,8 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 		if (line_status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 		for (i = 0; i < urb->actual_length; ++i)
-			tty_insert_flip_char(tty, data[i], tty_flag);
+			if (!usb_serial_handle_sysrq_char(port, data[i]))
+				tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
-- 
1.6.3.1.9.g95405b

