Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZJGO6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZJGO6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbZJGO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:57:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56340 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759424AbZJGO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:57:50 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/4] isicom: fix deadlock on shutdown
To: linux-kernel@vger.kernel.org, strakh@ispras.ru, jirislaby@gmail.com
Date: Wed, 07 Oct 2009 15:46:50 +0100
Message-ID: <20091007144643.14550.7683.stgit@localhost.localdomain>
In-Reply-To: <20091007144455.14550.95003.stgit@localhost.localdomain>
References: <20091007144455.14550.95003.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Alan Cox <alan@linux.intel.com>
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

