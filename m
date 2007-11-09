Return-Path: <linux-kernel-owner+w=401wt.eu-S1764442AbXKIXro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764442AbXKIXro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762791AbXKIXre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:47:34 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57233 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXKIXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:47:33 -0500
Message-id: <2694611355132233895.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 7/13] Char: nozomi, remove struct irq
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:47:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, remove struct irq

struct irq (named as my_irq) is used only in ISR and its called functions.
We might silently use u16 variable on stack and remove all references to
this structure. This is the first step of struct nozomi_devices removal.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 9f9d7197e901ea00771812b7e903b14b95f54e40
tree fd36411ffccd536721bc42464489ffe2d3517dc2
parent 662a9d19654d8d79fbaeab13d7afe7fe021e6b42
author Jiri Slaby <jirislaby@gmail.com> Fri, 02 Nov 2007 10:57:49 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:22:01 +0100

 drivers/char/nozomi.c |   85 ++++++++++++++++++++++---------------------------
 1 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index eaa65fc..49e16c7 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -454,16 +454,10 @@ static struct pci_device_id nozomi_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, nozomi_pci_tbl);
 
-/* Used to store interrupt variables */
-struct irq {
-	u16 read_iir;		/* Holds current interrupt tokens */
-};
-
 /* Representing the pci device of interest */
 struct nozomi_devices {
 	struct list_head list;
 	struct nozomi *my_dev;
-	struct irq my_irq;
 	int index_start;
 };
 static atomic_t cards_found = ATOMIC_INIT(0);
@@ -1125,7 +1119,7 @@ static char *interrupt2str(u16 interrupt)
  * Receive flow control
  * Return 1 - If ok, else 0
  */
-static int receive_flow_control(struct nozomi *dc, struct irq *m)
+static int receive_flow_control(struct nozomi *dc)
 {
 	enum port_type port = PORT_MDM;
 	struct ctrl_dl ctrl_dl;
@@ -1262,28 +1256,28 @@ static int send_flow_control(struct nozomi *dc)
  * Return 1 - ok
  * Return 0 - toggle fields are out of sync
  */
-static int handle_data_dl(struct nozomi *dc, struct irq *m, enum port_type port,
-			  u8 *toggle, u16 mask1, u16 mask2)
+static int handle_data_dl(struct nozomi *dc, enum port_type port, u8 *toggle,
+		u16 read_iir, u16 mask1, u16 mask2)
 {
-	if (*toggle == 0 && m->read_iir & mask1) {
+	if (*toggle == 0 && read_iir & mask1) {
 		if (receive_data(port, dc)) {
 			writew(mask1, dc->reg_fcr);
 			*toggle = !(*toggle);
 		}
 
-		if (m->read_iir & mask2) {
+		if (read_iir & mask2) {
 			if (receive_data(port, dc)) {
 				writew(mask2, dc->reg_fcr);
 				*toggle = !(*toggle);
 			}
 		}
-	} else if (*toggle == 1 && m->read_iir & mask2) {
+	} else if (*toggle == 1 && read_iir & mask2) {
 		if (receive_data(port, dc)) {
 			writew(mask2, dc->reg_fcr);
 			*toggle = !(*toggle);
 		}
 
-		if (m->read_iir & mask1) {
+		if (read_iir & mask1) {
 			if (receive_data(port, dc)) {
 				writew(mask1, dc->reg_fcr);
 				*toggle = !(*toggle);
@@ -1302,11 +1296,11 @@ static int handle_data_dl(struct nozomi *dc, struct irq *m, enum port_type port,
  * Return 1 - ok
  * Return 0 - toggle field are out of sync
  */
-static int handle_data_ul(struct nozomi *dc, struct irq *m, enum port_type port)
+static int handle_data_ul(struct nozomi *dc, enum port_type port, u16 read_iir)
 {
 	u8 *toggle = &(dc->port[port].toggle_ul);
 
-	if (*toggle == 0 && m->read_iir & MDM_UL1) {
+	if (*toggle == 0 && read_iir & MDM_UL1) {
 		dc->last_ier &= ~MDM_UL;
 		writew(dc->last_ier, dc->reg_ier);
 		if (send_data(port, dc)) {
@@ -1316,7 +1310,7 @@ static int handle_data_ul(struct nozomi *dc, struct irq *m, enum port_type port)
 			*toggle = !*toggle;
 		}
 
-		if (m->read_iir & MDM_UL2) {
+		if (read_iir & MDM_UL2) {
 			dc->last_ier &= ~MDM_UL;
 			writew(dc->last_ier, dc->reg_ier);
 			if (send_data(port, dc)) {
@@ -1328,7 +1322,7 @@ static int handle_data_ul(struct nozomi *dc, struct irq *m, enum port_type port)
 			}
 		}
 
-	} else if (*toggle == 1 && m->read_iir & MDM_UL2) {
+	} else if (*toggle == 1 && read_iir & MDM_UL2) {
 		dc->last_ier &= ~MDM_UL;
 		writew(dc->last_ier, dc->reg_ier);
 		if (send_data(port, dc)) {
@@ -1338,7 +1332,7 @@ static int handle_data_ul(struct nozomi *dc, struct irq *m, enum port_type port)
 			*toggle = !*toggle;
 		}
 
-		if (m->read_iir & MDM_UL1) {
+		if (read_iir & MDM_UL1) {
 			dc->last_ier &= ~MDM_UL;
 			writew(dc->last_ier, dc->reg_ier);
 			if (send_data(port, dc)) {
@@ -1350,7 +1344,7 @@ static int handle_data_ul(struct nozomi *dc, struct irq *m, enum port_type port)
 			}
 		}
 	} else {
-		writew(m->read_iir & MDM_UL, dc->reg_fcr);
+		writew(read_iir & MDM_UL, dc->reg_fcr);
 		dev_err(&dc->pdev->dev, "port out of sync!\n");
 		return 0;
 	}
@@ -1361,34 +1355,33 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 {
 	struct nozomi_devices *ndev = dev_id;
 	struct nozomi *dc;
-	struct irq *m;
+	u16 read_iir;
 
 	if (!ndev)
 		return IRQ_NONE;
 
 	dc = ndev->my_dev;
-	m = &ndev->my_irq;
 
 	spin_lock(&dc->spin_mutex);
-	m->read_iir = readw(dc->reg_iir);
+	read_iir = readw(dc->reg_iir);
 
 	/* Card removed */
-	if (m->read_iir == (u16)-1)
+	if (read_iir == (u16)-1)
 		goto none;
 	/*
 	 * Just handle interrupt enabled in IER
 	 * (by masking with dc->last_ier)
 	 */
-	m->read_iir &= dc->last_ier;
+	read_iir &= dc->last_ier;
 
-	if (m->read_iir == 0)
+	if (read_iir == 0)
 		goto none;
 
 
-	DBG4("%s irq:0x%04X, prev:0x%04X", interrupt2str(m->read_iir),
-	   m->read_iir, dc->last_ier);
+	DBG4("%s irq:0x%04X, prev:0x%04X", interrupt2str(read_iir), read_iir,
+			dc->last_ier);
 
-	if (m->read_iir & RESET) {
+	if (read_iir & RESET) {
 		if (unlikely(!nozomi_read_config_table(dc))) {
 			dc->last_ier = 0x0;
 			writew(dc->last_ier, dc->reg_ier);
@@ -1400,7 +1393,7 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 		/* No more useful info if this was the reset interrupt. */
 		goto exit_handler;
 	}
-	if (m->read_iir & CTRL_UL) {
+	if (read_iir & CTRL_UL) {
 		DBG1("CTRL_UL");
 		dc->last_ier &= ~CTRL_UL;
 		writew(dc->last_ier, dc->reg_ier);
@@ -1410,33 +1403,33 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 			writew(dc->last_ier, dc->reg_ier);
 		}
 	}
-	if (m->read_iir & CTRL_DL) {
-		receive_flow_control(dc, m);
+	if (read_iir & CTRL_DL) {
+		receive_flow_control(dc);
 		writew(CTRL_DL, dc->reg_fcr);
 	}
-	if (m->read_iir & MDM_DL) {
-		if (!handle_data_dl(dc, m, PORT_MDM,
-				&(dc->port[PORT_MDM].toggle_dl), MDM_DL1,
-				MDM_DL2)) {
+	if (read_iir & MDM_DL) {
+		if (!handle_data_dl(dc, PORT_MDM,
+				&(dc->port[PORT_MDM].toggle_dl), read_iir,
+				MDM_DL1, MDM_DL2)) {
 			dev_err(&dc->pdev->dev, "MDM_DL out of sync!\n");
 			goto exit_handler;
 		}
 	}
-	if (m->read_iir & MDM_UL) {
-		if (!handle_data_ul(dc, m, PORT_MDM)) {
+	if (read_iir & MDM_UL) {
+		if (!handle_data_ul(dc, PORT_MDM, read_iir)) {
 			dev_err(&dc->pdev->dev, "MDM_UL out of sync!\n");
 			goto exit_handler;
 		}
 	}
-	if (m->read_iir & DIAG_DL) {
-		if (!handle_data_dl(dc, m, PORT_DIAG,
-				&(dc->port[PORT_DIAG].toggle_dl), DIAG_DL1,
-				DIAG_DL2)) {
+	if (read_iir & DIAG_DL) {
+		if (!handle_data_dl(dc, PORT_DIAG,
+				&(dc->port[PORT_DIAG].toggle_dl), read_iir,
+				DIAG_DL1, DIAG_DL2)) {
 			dev_err(&dc->pdev->dev, "DIAG_DL out of sync!\n");
 			goto exit_handler;
 		}
 	}
-	if (m->read_iir & DIAG_UL) {
+	if (read_iir & DIAG_UL) {
 		dc->last_ier &= ~DIAG_UL;
 		writew(dc->last_ier, dc->reg_ier);
 		if (send_data(PORT_DIAG, dc)) {
@@ -1445,11 +1438,11 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 			writew(dc->last_ier, dc->reg_ier);
 		}
 	}
-	if (m->read_iir & APP1_DL) {
+	if (read_iir & APP1_DL) {
 		if (receive_data(PORT_APP1, dc))
 			writew(APP1_DL, dc->reg_fcr);
 	}
-	if (m->read_iir & APP1_UL) {
+	if (read_iir & APP1_UL) {
 		dc->last_ier &= ~APP1_UL;
 		writew(dc->last_ier, dc->reg_ier);
 		if (send_data(PORT_APP1, dc)) {
@@ -1458,11 +1451,11 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 			writew(dc->last_ier, dc->reg_ier);
 		}
 	}
-	if (m->read_iir & APP2_DL) {
+	if (read_iir & APP2_DL) {
 		if (receive_data(PORT_APP2, dc))
 			writew(APP2_DL, dc->reg_fcr);
 	}
-	if (m->read_iir & APP2_UL) {
+	if (read_iir & APP2_UL) {
 		dc->last_ier &= ~APP2_UL;
 		writew(dc->last_ier, dc->reg_ier);
 		if (send_data(PORT_APP2, dc)) {
