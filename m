Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXKIXtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXKIXtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXKIXte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:49:34 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57249 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbXKIXtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:49:33 -0500
Message-id: <259691270825982947.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC! 10/13] Char: nozomi, fix tty_flip_buffer_push
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:49:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Especially on this I would like to see feedback. Unlock and lock the
spinlock just around the tty_flip_buffer_push would be much more easier, but
won't it break anything?

--

nozomi, fix tty_flip_buffer_push

tty_flip_buffer_push call may deadlock when invoking it while holding
spinlock used in e.g. throttle too. Nozomi sets low_latency tty and that
means, that ldisc flush will be called immediately and it can call some
nozomi functions back. Solve it by invoking tty_flip_buffer_push after
releasing the spinlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2bd359aea85cf712d4d161a83e940fe5e1202ee8
tree 0de7cbb0d78d1ff24d6be957b85ee30d4fc01a63
parent 19a0196a97ed70efdc421b359e28684e058d7121
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 15:19:55 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 10 Nov 2007 00:14:41 +0100

 drivers/char/nozomi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 2c4d388..3e0b18e 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -414,7 +414,7 @@ struct port {
 /* Private data one for each card in the system */
 struct nozomi {
 	void __iomem *base_addr;
-	u8 closing;
+	u32 flip;
 
 	/* Pointers to registers */
 	void __iomem *reg_iir;
@@ -1000,7 +1000,7 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 		}
 	}
 
-	tty_flip_buffer_push(tty);
+	set_bit(index, &dc->flip);
 
 	return 1;
 }
@@ -1290,6 +1290,7 @@ static int handle_data_ul(struct nozomi *dc, enum port_type port, u16 read_iir)
 static irqreturn_t interrupt_handler(int irq, void *dev_id)
 {
 	struct nozomi *dc = dev_id;
+	unsigned int a;
 	u16 read_iir;
 
 	spin_lock(&dc->spin_mutex);
@@ -1397,6 +1398,9 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 
 exit_handler:
 	spin_unlock(&dc->spin_mutex);
+	for (a = 0; a < NOZOMI_MAX_PORTS; a++)
+		if (test_and_clear_bit(a, &dc->flip))
+			tty_flip_buffer_push(dc->port[a].tty);
 	return IRQ_HANDLED;
 none:
 	spin_unlock(&dc->spin_mutex);
@@ -1426,7 +1430,7 @@ static void nozomi_setup_private_data(struct nozomi *dc)
 	dc->reg_iir = (void __iomem *)(offset + R_IIR);
 	dc->reg_ier = (void __iomem *)(offset + R_IER);
 	dc->last_ier = 0;
-	dc->closing = 0;
+	dc->flip = 0;
 
 	dc->port[PORT_MDM].token_dl = MDM_DL;
 	dc->port[PORT_DIAG].token_dl = DIAG_DL;
