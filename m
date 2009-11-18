Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZKRO1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZKRO1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZKRO1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:27:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46411 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757173AbZKRO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:27:03 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/7] tty_port: Move the IO_ERROR clear
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:10:39 +0000
Message-ID: <20091118141036.2798.89845.stgit@localhost.localdomain>
In-Reply-To: <20091118140935.2798.32517.stgit@localhost.localdomain>
References: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices want to set IO_ERROR in their activate methods so that you can
be handed a 'dead' port for operations like setserial. Thus we need to
clear the flag before activate so that activate can choose to set the flag
and still return 0.

This is fine as the file handle/tty are not accessible to the user yet.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index beaf599..a413db4 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -403,6 +403,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 	mutex_lock(&port->mutex);
 
 	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
 			if (retval) {
@@ -411,7 +412,6 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			}
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->flags);
-		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 	mutex_unlock(&port->mutex);
 	return tty_port_block_til_ready(port, tty, filp);

