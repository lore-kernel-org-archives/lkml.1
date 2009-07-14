Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbZGNWL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbZGNWL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZGNWL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:11:56 -0400
Received: from server1.wserver.cz ([82.113.45.157]:43682 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZGNWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:11:55 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: nozomi, fix tty refcounting bug
Date: Wed, 15 Jul 2009 00:11:51 +0200
Message-Id: <1247609511-19848-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to drop a tty refererence on fail paths in
receive_data().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/nozomi.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 574f1c7..280b41c 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -828,7 +828,7 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 	struct port *port = &dc->port[index];
 	void __iomem *addr = port->dl_addr[port->toggle_dl];
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	int i;
+	int i, ret;
 
 	if (unlikely(!tty)) {
 		DBG1("tty not open for port: %d?", index);
@@ -844,12 +844,14 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 
 		/* disable interrupt in downlink... */
 		disable_transmit_dl(index, dc);
-		return 0;
+		ret = 0;
+		goto put;
 	}
 
 	if (unlikely(size == 0)) {
 		dev_err(&dc->pdev->dev, "size == 0?\n");
-		return 1;
+		ret = 1;
+		goto put;
 	}
 
 	tty_buffer_request_room(tty, size);
@@ -871,8 +873,10 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 	}
 
 	set_bit(index, &dc->flip);
+	ret = 1;
+put:
 	tty_kref_put(tty);
-	return 1;
+	return ret;
 }
 
 /* Debug for interrupts */
-- 
1.6.3.2

