Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZISVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZISVmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZISVmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:42:16 -0400
Received: from kroah.org ([198.145.64.141]:40489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbZISVmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:42:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 45/79] isicom: split the open method for the isicom device
Date: Sat, 19 Sep 2009 14:36:50 -0700
Message-Id: <1253396244-7885-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Again moving towards being able to add a common open method

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/isicom.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 08f5743..426bfdd 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -846,37 +846,53 @@ static int isicom_carrier_raised(struct tty_port *port)
 	return (ip->status & ISI_DCD)?1 : 0;
 }
 
-static int isicom_open(struct tty_struct *tty, struct file *filp)
+static struct tty_port *isicom_find_port(struct tty_struct *tty)
 {
 	struct isi_port *port;
 	struct isi_board *card;
 	unsigned int board;
-	int error, line;
+	int line = tty->index;
 
-	line = tty->index;
 	if (line < 0 || line > PORT_COUNT-1)
-		return -ENODEV;
+		return NULL;
 	board = BOARD(line);
 	card = &isi_card[board];
 
 	if (!(card->status & FIRMWARE_LOADED))
-		return -ENODEV;
+		return NULL;
 
 	/*  open on a port greater than the port count for the card !!! */
 	if (line > ((board * 16) + card->port_count - 1))
-		return -ENODEV;
+		return NULL;
 
 	port = &isi_ports[line];
 	if (isicom_paranoia_check(port, tty->name, "isicom_open"))
-		return -ENODEV;
+		return NULL;
+
+	return &port->port;
+}
+	
+static int isicom_open(struct tty_struct *tty, struct file *filp)
+{
+	struct isi_port *port;
+	struct isi_board *card;
+	struct tty_port *tport;
+	int error = 0;
 
+	tport = isicom_find_port(tty);
+	if (tport == NULL)
+		return -ENODEV;
+	port = container_of(tport, struct isi_port, port);
+	card = &isi_card[BOARD(tty->index)];
 	isicom_setup_board(card);
 
 	/* FIXME: locking on port.count etc */
 	port->port.count++;
 	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
-	error = isicom_setup_port(tty);
+	/* FIXME: Locking on Initialized flag */
+	if (!test_bit(ASYNCB_INITIALIZED, &tport->flags))
+		error = isicom_setup_port(tty);
 	if (error == 0)
 		error = tty_port_block_til_ready(&port->port, tty, filp);
 	return error;
-- 
1.6.4.2

