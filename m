Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbXKIXnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbXKIXnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761447AbXKIXnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:43:32 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57196 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbXKIXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:43:31 -0500
Message-id: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 1/13] Char: nozomi, remove unneded stuff
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:43:31 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank, could you comment (and test) following changes to the nozomi driver?
I did them before you post the updated version and rediffed them a while
ago, I hope I haven't done any mistake while doing it.

Thanks.

--

nozomi, remove unneded stuff

- tty_termios* are set to tty struct, but tty_register_driver overwrites it
  with its own values (or NULLs), no need to have these pointers stored
- [rt]x_data are updated but never used

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 79aeb51662902086507927cb7fcd682ae319630a
tree 157e1fcc2b57542d831bcb80a6328edbfe6ed231
parent 9d50b0aba24ca0b601820663939987990db134c6
author Jiri Slaby <jirislaby@gmail.com> Mon, 29 Oct 2007 11:01:49 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:52:10 +0100

 drivers/char/nozomi.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 93b48b4..458e70b 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -412,8 +412,6 @@ struct port {
 	wait_queue_head_t tty_wait;
 	struct async_icount tty_icount;
 	int tty_index;
-	u32 rx_data, tx_data;
-
 };
 
 /* Private data one for each card in the system */
@@ -435,8 +433,6 @@ struct nozomi {
 
 	struct tty_driver *tty_driver;
 
-	struct ktermios *tty_termios[NTTY_TTY_MINORS];
-	struct ktermios *tty_termios_locked[NTTY_TTY_MINORS];
 	spinlock_t spin_mutex;	/* secures access to registers and tty */
 
 	u32 open_ttys;
@@ -1012,8 +1008,6 @@ static int send_data(enum port_type index, struct nozomi *dc)
 		return 0;
 	}
 
-	port->tx_data += size;
-
 	/* DUMP(buf, size); */
 
 	/* Write length + data */
@@ -1059,8 +1053,6 @@ static int receive_data(enum port_type index, struct nozomi *dc)
 		return 1;
 	}
 
-	port->rx_data += size;
-
 	tty_buffer_request_room(tty, size);
 
 	while (size > 0) {
@@ -1517,7 +1509,6 @@ static void nozomi_get_card_type(struct nozomi *dc)
 static void nozomi_setup_private_data(struct nozomi *dc)
 {
 	void __iomem *offset = dc->base_addr + dc->card_type / 2;
-	int i;
 
 	dc->reg_fcr = (void __iomem *)(offset + R_FCR);
 	dc->reg_iir = (void __iomem *)(offset + R_IIR);
@@ -1529,11 +1520,6 @@ static void nozomi_setup_private_data(struct nozomi *dc)
 	dc->port[PORT_DIAG].token_dl = DIAG_DL;
 	dc->port[PORT_APP1].token_dl = APP1_DL;
 	dc->port[PORT_APP2].token_dl = APP2_DL;
-
-	for (i = PORT_MDM; i < MAX_PORT; ++i) {
-		dc->port[i].rx_data = 0;
-		dc->port[i].tx_data = 0;
-	}
 }
 
 static ssize_t card_type_show(struct device *dev, struct device_attribute *attr,
@@ -1871,8 +1857,6 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 		tty->driver_data = port;
 		port->tty = tty;
 		port->tty_index = tty->index;
-		port->rx_data = 0;
-		port->tx_data = 0;
 		DBG1("open: %d", port->token_dl);
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		dc->last_ier =
@@ -2239,8 +2223,6 @@ static int ntty_tty_init(struct nozomi *dc)
 	td->init_termios.c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
 	td->init_termios.c_ispeed = 115200;
 	td->init_termios.c_ospeed = 115200;
-	td->termios = dc->tty_termios;
-	td->termios_locked = dc->tty_termios_locked;
 	tty_set_operations(dc->tty_driver, &tty_ops);
 
 	rval = tty_register_driver(td);
