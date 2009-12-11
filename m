Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbZLKXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbZLKXe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934867AbZLKXeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:34:15 -0500
Received: from kroah.org ([198.145.64.141]:50457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbZLKX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/58] tty: tty_port: Add IO_ERROR bit handling
Date: Fri, 11 Dec 2009 15:28:21 -0800
Message-Id: <1260574122-10676-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

To propogate tty_port_open/close to a few other devices we need to start
handling the IO_ERROR flag on the tty. We can do this pretty trivially.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 3ef644a..43a1907 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -122,8 +122,10 @@ void tty_port_hangup(struct tty_port *port)
 	spin_lock_irqsave(&port->lock, flags);
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
-	if (port->tty)
+	if (port->tty) {
+		set_bit(TTY_IO_ERROR, &port->tty->flags);
 		tty_kref_put(port->tty);
+	}
 	port->tty = NULL;
 	spin_unlock_irqrestore(&port->lock, flags);
 	wake_up_interruptible(&port->open_wait);
@@ -383,6 +385,7 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
 	tty_port_shutdown(port);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 	tty_port_close_end(port, tty);
 	tty_port_tty_set(port, NULL);
 }
@@ -414,6 +417,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			}
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 	mutex_unlock(&port->mutex);
 	return tty_port_block_til_ready(port, tty, filp);
-- 
1.6.5.5

