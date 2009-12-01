Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZLASC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZLASC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZLASC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:02:26 -0500
Received: from kroah.org ([198.145.64.141]:52002 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZLASCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:02:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] tty_port: handle the nonblocking open of a dead port corner case
Date: Tue,  1 Dec 2009 09:59:04 -0800
Message-Id: <1259690346-12469-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091201174341.GB31972@kroah.com>
References: <20091201174341.GB31972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Some drivers allow O_NDELAY of a dead port (eg for setserial to work). In that
situation we must not try to raise the carrier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 2e8552d..c63f3d3 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -219,8 +219,11 @@ int tty_port_block_til_ready(struct tty_port *port,
 
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
-- 
1.6.4.2

