Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZKRBEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZKRBEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZKRBEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:04:36 -0500
Received: from kroah.org ([198.145.64.141]:38458 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566AbZKRBEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:04:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] tty_port: If we are opened non blocking we still need to raise the carrier
Date: Tue, 17 Nov 2009 17:01:29 -0800
Message-Id: <1258506090-16802-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091118010047.GA16719@kroah.com>
References: <20091118010047.GA16719@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index a4bbb28..2e8552d 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -221,6 +221,9 @@ int tty_port_block_til_ready(struct tty_port *port,
 	   the port has just hung up or is in another error state */
 	if ((filp->f_flags & O_NONBLOCK) ||
 			(tty->flags & (1 << TTY_IO_ERROR))) {
+		/* Indicate we are open */
+		if (tty->termios->c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
-- 
1.6.4.2

