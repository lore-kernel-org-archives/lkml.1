Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbZFJML3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbZFJML3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZFJMIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:47 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:41769 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbZFJMIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] Char: tty, use prepare/finish_wait
Date: Wed, 10 Jun 2009 14:08:04 +0200
Message-Id: <1244635684-8318-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1244635684-8318-1-git-send-email-jirislaby@gmail.com>
References: <1244635684-8318-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use prepare_to_wait and finish_wait instead of add_wait_queue and
remove_wait_queue.

This avoids us setting a task state.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/tty_port.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 931af10..62dadfc 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -222,7 +222,6 @@ int tty_port_block_til_ready(struct tty_port *port,
 	   before the next open may complete */
 
 	retval = 0;
-	add_wait_queue(&port->open_wait, &wait);
 
 	/* The port lock protects the port counts */
 	spin_lock_irqsave(&port->lock, flags);
@@ -236,7 +235,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 		if (tty->termios->c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 
-		set_current_state(TASK_INTERRUPTIBLE);
+		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
 		/* Check for a hangup or uninitialised port. Return accordingly */
 		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			if (port->flags & ASYNC_HUP_NOTIFY)
@@ -257,8 +256,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 		}
 		schedule();
 	}
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->open_wait, &wait);
+	finish_wait(&port->open_wait, &wait);
 
 	/* Update counts. A parallel hangup will have set count to zero and
 	   we must not mess that up further */
-- 
1.6.3.2

