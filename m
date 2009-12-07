Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZLGANE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZLGANE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbZLGANC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:02 -0500
Received: from kroah.org ([198.145.64.141]:34342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758377AbZLGAM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.604074717@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [039/119] tty_port: If we are opened non blocking we still need to raise the carrier
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=tty_port-if-we-are-opened-non-blocking-we-still-need-to-raise-the-carrier.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 4175f3e31cc7157669aa66d46dc79de6ae0126ce upstream.

Original discussion:
http://thread.gmane.org/gmane.linux.usb.general/23217/focus=23248
or
http://marc.info/?l=linux-usb&m=125553790714133&w=2

The tty_port code inherited a bug common to various drivers it was based
upon. If the tty is opened O_NONBLOCK we do not wait for the carrier to be
raised but we must still raise our modem lines if appropriate.

(There is a second question here about whether we should do so if CLOCAL is
 set but that can wait)

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Karl Hiramoto <karl@hiramoto.org>
Tested-by:  Karl Hiramoto <karl@hiramoto.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_port.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -219,6 +219,9 @@ int tty_port_block_til_ready(struct tty_
 	   the port has just hung up or is in another error state */
 	if ((filp->f_flags & O_NONBLOCK) ||
 			(tty->flags & (1 << TTY_IO_ERROR))) {
+		/* Indicate we are open */
+		if (tty->termios->c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}


