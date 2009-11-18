Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbZKRO07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbZKRO07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbZKRO05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:26:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46407 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757177AbZKRO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:26:55 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/7] tty_port: Add IO_ERROR bit handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:10:31 +0000
Message-ID: <20091118141027.2798.51296.stgit@localhost.localdomain>
In-Reply-To: <20091118140935.2798.32517.stgit@localhost.localdomain>
References: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To propogate tty_port_open/close to a few other devices we need to start
handling the IO_ERROR flag on the tty. We can do this pretty trivially.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 8825255..beaf599 100644
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
@@ -377,6 +379,7 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
 	tty_port_shutdown(port);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 	tty_port_close_end(port, tty);
 	tty_port_tty_set(port, NULL);
 }
@@ -408,6 +411,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			}
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 	mutex_unlock(&port->mutex);
 	return tty_port_block_til_ready(port, tty, filp);

