Return-Path: <linux-kernel-owner+w=401wt.eu-S934897AbZLKXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897AbZLKXeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934409AbZLKXeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:34:13 -0500
Received: from kroah.org ([198.145.64.141]:50461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392AbZLKX3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/58] tty: tty_port: Move the IO_ERROR clear
Date: Fri, 11 Dec 2009 15:28:22 -0800
Message-Id: <1260574122-10676-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Some devices want to set IO_ERROR in their activate methods so that you can
be handed a 'dead' port for operations like setserial. Thus we need to
clear the flag before activate so that activate can choose to set the flag
and still return 0.

This is fine as the file handle/tty are not accessible to the user yet.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 43a1907..84006de 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -409,6 +409,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 	mutex_lock(&port->mutex);
 
 	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
 			if (retval) {
@@ -417,7 +418,6 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 			}
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->flags);
-		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 	mutex_unlock(&port->mutex);
 	return tty_port_block_til_ready(port, tty, filp);
-- 
1.6.5.5

