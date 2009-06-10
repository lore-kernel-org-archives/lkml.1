Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbZFJMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbZFJMLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZFJMIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:45 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:41768 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbZFJMIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:44 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Char: tty, remove sleep_on
Date: Wed, 10 Jun 2009 14:08:03 +0200
Message-Id: <1244635684-8318-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wait_event instead of sleep_on in tty_block_til_ready.

Wait for ASYNC_CLOSING flag being 0.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/tty_port.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 4d08b6d..931af10 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -198,7 +198,8 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
-		interruptible_sleep_on(&port->close_wait);
+		wait_event_interruptible(port->close_wait,
+				!(port->flags & ASYNC_CLOSING));
 		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
-- 
1.6.3.2

