Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbYJEQe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbYJEQe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbYJEQZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:25:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34347 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756258AbYJEQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:25:31 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 75/76] usb: fix pl2303 initialization
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:25:31 +0100
Message-ID: <20081005162528.1997.50026.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

This patch removes the private check for the termios_initialized for
the pl2303 usb driver.  It forced the baud to 9600 on the first call
to pl2303_set_termios()

Based on the tty changes in the 2.6.27 kernel, the termios passed to
the *_set_termios functions is always populated the first time.

This means there is no need to privately initialize the settings the
first time, and doing so will not allow the use of the kernel
parameter "console=ttyUSB0,115200" as an example.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/pl2303.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index ba74424..9084378 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -154,7 +154,6 @@ struct pl2303_private {
 	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
-	u8 termios_initialized;
 	enum pl2303_type type;
 };
 
@@ -526,16 +525,6 @@ static void pl2303_set_termios(struct tty_struct *tty,
 
 	dbg("%s -  port %d", __func__, port->number);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!priv->termios_initialized) {
-		*(tty->termios) = tty_std_termios;
-		tty->termios->c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-		tty->termios->c_ispeed = 9600;
-		tty->termios->c_ospeed = 9600;
-		priv->termios_initialized = 1;
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	/* The PL2303 is reported to lose bytes if you change
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */

