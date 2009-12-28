Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZL1WCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZL1WCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZL1WCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:02:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61514 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZL1WCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lOYhgtlgrsfekjOY/xKxE5k/NGHoyckcKES/v4acxxVE62Vj9X1bRfccwg+MEIzNwn
         7cO5zyMX5LlbO96OlRXeqSTFKVEl7NNtidgU6TqOuwNz/HPPqwX5CI/vSyBpCFp/KH2N
         a8jaY9l8LkND9dMK4F0BmceKeFFe+ejtQgJdM=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 02/14] USB: ch341: fix DMA buffer on stack
Date: Mon, 28 Dec 2009 23:01:46 +0100
Message-Id: <1262037718-31424-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ch341.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 5e455f4..2942c6d 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -392,16 +392,22 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	struct usb_serial_port *port = tty->driver_data;
 	int r;
 	uint16_t reg_contents;
-	uint8_t break_reg[2];
+	uint8_t *break_reg;
 
 	dbg("%s()", __func__);
 
+	break_reg = kmalloc(2, GFP_KERNEL);
+	if (!break_reg) {
+		dev_err(&port->dev, "%s - kmalloc failed\n", __func__);
+		return;
+	}
+
 	r = ch341_control_in(port->serial->dev, CH341_REQ_READ_REG,
-			ch341_break_reg, 0, break_reg, sizeof(break_reg));
+			ch341_break_reg, 0, break_reg, 2);
 	if (r < 0) {
 		dev_err(&port->dev, "%s - USB control read error (%d)\n",
 				__func__, r);
-		return;
+		goto out;
 	}
 	dbg("%s - initial ch341 break register contents - reg1: %x, reg2: %x",
 			__func__, break_reg[0], break_reg[1]);
@@ -422,6 +428,8 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	if (r < 0)
 		dev_err(&port->dev, "%s - USB control write error (%d)\n",
 				__func__, r);
+out:
+	kfree(break_reg);
 }
 
 static int ch341_tiocmset(struct tty_struct *tty, struct file *file,
-- 
1.6.6

