Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZKRO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZKRO3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZKRO3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:29:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40575 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753780AbZKRO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:29:24 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] tty_port: handle the nonblocking open of a dead port corner
	case
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:12:58 +0000
Message-ID: <20091118141254.3304.85805.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers allow O_NDELAY of a dead port (eg for setserial to work). In that
situation we must not try to raise the carrier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
---

 drivers/char/tty_port.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index da12fae..5e2ac57 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -241,8 +241,11 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* if non-blocking mode is set we can pass directly to open unless
 	   the port has just hung up or is in another error state */
-	if ((filp->f_flags & O_NONBLOCK) ||
-			(tty->flags & (1 << TTY_IO_ERROR))) {
+	if (tty->flags & (1 << TTY_IO_ERROR)) {
+		port->flags |= ASYNC_NORMAL_ACTIVE;
+		return 0;
+	}
+	if (filp->f_flags & O_NONBLOCK) {
 		/* Indicate we are open */
 		if (tty->termios->c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);

