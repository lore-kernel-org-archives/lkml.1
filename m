Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbZKFLql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbZKFLql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZKFLql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:46:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48663 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757068AbZKFLqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:46:39 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] tty_port: If we are opened non blocking we still need to
	raise the carrier
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2009 11:32:48 +0000
Message-ID: <20091106113244.14699.17332.stgit@localhost.localdomain>
In-Reply-To: <20091106113159.14699.16040.stgit@localhost.localdomain>
References: <20091106113159.14699.16040.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_port code inherited a bug common to various drivers it was based
upon. If the tty is opened O_NONBLOCK we do not wait for the carrier to be
raised but we must still raise our modem lines if appropriate.

(There is a second question here about whether we should do so if CLOCAL is
 set but that can wait)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 0a35600..5e2ac57 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -241,8 +241,14 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* if non-blocking mode is set we can pass directly to open unless
 	   the port has just hung up or is in another error state */
-	if ((filp->f_flags & O_NONBLOCK) ||
-			(tty->flags & (1 << TTY_IO_ERROR))) {
+	if (tty->flags & (1 << TTY_IO_ERROR)) {
+		port->flags |= ASYNC_NORMAL_ACTIVE;
+		return 0;
+	}
+	if (filp->f_flags & O_NONBLOCK) {
+		/* Indicate we are open */
+		if (tty->termios->c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}

