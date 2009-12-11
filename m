Return-Path: <linux-kernel-owner+w=401wt.eu-S934643AbZLKXb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643AbZLKXb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934369AbZLKX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:38 -0500
Received: from kroah.org ([198.145.64.141]:50466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934445AbZLKX33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/58] tty: isicom: fix deadlock on shutdown
Date: Fri, 11 Dec 2009 15:28:30 -0800
Message-Id: <1260574122-10676-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Alexander Strakh <strakh@ispras.ru> reported

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver drivers/char/isicom.c might sleep in atomic  context, because it
calls
tty_port_xmit_buf under spin_lock.

./drivers/char/isicom.c:
1307 static void isicom_hangup(struct tty_struct *tty)
1308 {
...
1315         spin_lock_irqsave(&port->card->card_lock, flags);
1316         isicom_shutdown_port(port);
...

Path to might_sleep macro from isicom_hangup:
1. isicom_hangup calls spin_lock_irqsave (drivers/char/isicom.c:1315) and
then
calls isicom_shutdown_port.
2. isiscom_shutdown_port calls tty_port_free_xmit_buf at
drivers/char/isicom.c:906
3. tty_port_free_xmit_buf calls mutex_lock at drivers/char/tty_port:48

Found by Linux Driver Verification Project.

Reported-by: Alexander Strakh <strakh@ispras.ru>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/isicom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 1e91c30..300d5bd 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -887,7 +887,6 @@ static void isicom_shutdown_port(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 
-	tty_port_free_xmit_buf(&port->port);
 	if (--card->count < 0) {
 		pr_dbg("isicom_shutdown_port: bad board(0x%lx) count %d.\n",
 			card->base, card->count);
@@ -927,6 +926,7 @@ static void isicom_shutdown(struct tty_port *port)
 	outw(card->port_status, card->base + 0x02);
 	isicom_shutdown_port(ip);
 	spin_unlock_irqrestore(&card->card_lock, flags);
+	tty_port_free_xmit_buf(port);
 }
 
 static void isicom_close(struct tty_struct *tty, struct file *filp)
-- 
1.6.5.5

