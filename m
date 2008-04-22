Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYDVE07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYDVE07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYDVE0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:26:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65416 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYDVE0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:26:48 -0400
X-Greylist: delayed 3624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 00:26:48 EDT
Message-Id: <200804220325.m3M3Pqkx002242@www262.sakura.ne.jp>
Subject: [PATCH] serial: access-after-NULL-check-at-uart_flush_buffer
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Apr 2008 12:25:52 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that

  static void uart_flush_buffer(struct tty_struct *tty)
  {
  	struct uart_state *state = tty->driver_data;
  	struct uart_port *port = state->port;
  	unsigned long flags;
  	
  	/*
  	 * This means you called this function _after_ the port was
  	 * closed.  No cookie for you.
  	 */
  	if (!state || !state->info) {
  		WARN_ON(1);
  		return;
  	}

is too late for checking state != NULL.
This change applies to kernels from 2.6.16 till 2.6.25.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/serial/serial_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.25.orig/drivers/serial/serial_core.c
+++ linux-2.6.25/drivers/serial/serial_core.c
@@ -535,7 +535,7 @@ static int uart_chars_in_buffer(struct t
 static void uart_flush_buffer(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->port;
+	struct uart_port *port;
 	unsigned long flags;
 
 	/*
@@ -547,6 +547,7 @@ static void uart_flush_buffer(struct tty
 		return;
 	}
 
+	port = state->port;
 	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
