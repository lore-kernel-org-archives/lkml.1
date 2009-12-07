Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZLGAON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZLGAON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbZLGAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:59 -0500
Received: from kroah.org ([198.145.64.141]:34677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbZLGANr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:57 2009
Message-Id: <20091207000656.889070773@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [091/119] tty_port: handle the nonblocking open of a dead port corner case
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=tty_port-handle-the-nonblocking-open-of-a-dead-port-corner-case.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 8627b96dd80dca440d91fbb1ec733be25912d0dd upstream.

Some drivers allow O_NDELAY of a dead port (eg for setserial to work). In that
situation we must not try to raise the carrier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_port.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -217,8 +217,11 @@ int tty_port_block_til_ready(struct tty_
 
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


