Return-Path: <linux-kernel-owner+w=401wt.eu-S934301AbYBHJRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbYBHJRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934113AbYBHJQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:16:55 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:41789 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbYBHJQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:16:51 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/1] mxser: convert large macros to functions
Date: Fri,  8 Feb 2008 10:16:48 +0100
Message-Id: <1202462208-6171-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |  229 ++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/char/mxser.h |  137 ------------------------------
 2 files changed, 214 insertions(+), 152 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 68c2e92..9698552 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -307,6 +307,200 @@ static unsigned char mxser_msr[MXSER_PORTS + 1];
 static struct mxser_mon_ext mon_data_ext;
 static int mxser_set_baud_method[MXSER_PORTS + 1];
 
+static void mxser_enable_must_enchance_mode(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr |= MOXA_MUST_EFR_EFRB_ENABLE;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_enchance_mode(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_EFRB_ENABLE;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_xon1_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK0;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_XON1_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_xoff1_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK0;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_XOFF1_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_set_must_fifo_value(struct mxser_port *info)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(info->ioaddr + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, info->ioaddr + UART_LCR);
+
+	efr = inb(info->ioaddr + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK1;
+
+	outb(efr, info->ioaddr + MOXA_MUST_EFR_REGISTER);
+	outb((u8)info->rx_high_water, info->ioaddr + MOXA_MUST_RBRTH_REGISTER);
+	outb((u8)info->rx_trigger, info->ioaddr + MOXA_MUST_RBRTI_REGISTER);
+	outb((u8)info->rx_low_water, info->ioaddr + MOXA_MUST_RBRTL_REGISTER);
+	outb(oldlcr, info->ioaddr + UART_LCR);
+}
+
+static void mxser_set_must_enum_value(unsigned long baseio, u8 value)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK2;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(value, baseio + MOXA_MUST_ENUM_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_get_must_hardware_id(unsigned long baseio, u8 *pId)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_BANK_MASK;
+	efr |= MOXA_MUST_EFR_BANK2;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	*pId = inb(baseio + MOXA_MUST_HWID_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_enable_must_tx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_TX_MASK;
+	efr |= MOXA_MUST_EFR_SF_TX1;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_tx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_TX_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_enable_must_rx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_RX_MASK;
+	efr |= MOXA_MUST_EFR_SF_RX1;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
+static void mxser_disable_must_rx_software_flow_control(unsigned long baseio)
+{
+	u8 oldlcr;
+	u8 efr;
+
+	oldlcr = inb(baseio + UART_LCR);
+	outb(MOXA_MUST_ENTER_ENCHANCE, baseio + UART_LCR);
+
+	efr = inb(baseio + MOXA_MUST_EFR_REGISTER);
+	efr &= ~MOXA_MUST_EFR_SF_RX_MASK;
+
+	outb(efr, baseio + MOXA_MUST_EFR_REGISTER);
+	outb(oldlcr, baseio + UART_LCR);
+}
+
 #ifdef CONFIG_PCI
 static int __devinit CheckIsMoxaMust(unsigned long io)
 {
@@ -314,16 +508,16 @@ static int __devinit CheckIsMoxaMust(unsigned long io)
 	int i;
 
 	outb(0, io + UART_LCR);
-	DISABLE_MOXA_MUST_ENCHANCE_MODE(io);
+	mxser_disable_must_enchance_mode(io);
 	oldmcr = inb(io + UART_MCR);
 	outb(0, io + UART_MCR);
-	SET_MOXA_MUST_XON1_VALUE(io, 0x11);
+	mxser_set_must_xon1_value(io, 0x11);
 	if ((hwid = inb(io + UART_MCR)) != 0) {
 		outb(oldmcr, io + UART_MCR);
 		return MOXA_OTHER_UART;
 	}
 
-	GET_MOXA_MUST_HARDWARE_ID(io, &hwid);
+	mxser_get_must_hardware_id(io, &hwid);
 	for (i = 1; i < UART_INFO_NUM; i++) { /* 0 = OTHER_UART */
 		if (hwid == Gpci_uart_info[i].type)
 			return (int)hwid;
@@ -494,10 +688,10 @@ static int mxser_set_baud(struct mxser_port *info, long newspd)
 		} else
 			quot /= newspd;
 
-		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, quot);
+		mxser_set_must_enum_value(info->ioaddr, quot);
 	} else
 #endif
-		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
+		mxser_set_must_enum_value(info->ioaddr, 0);
 
 	return 0;
 }
@@ -553,14 +747,14 @@ static int mxser_change_speed(struct mxser_port *info,
 		if (info->board->chip_flag) {
 			fcr = UART_FCR_ENABLE_FIFO;
 			fcr |= MOXA_MUST_FCR_GDA_MODE_ENABLE;
-			SET_MOXA_MUST_FIFO_VALUE(info);
+			mxser_set_must_fifo_value(info);
 		} else
 			fcr = 0;
 	} else {
 		fcr = UART_FCR_ENABLE_FIFO;
 		if (info->board->chip_flag) {
 			fcr |= MOXA_MUST_FCR_GDA_MODE_ENABLE;
-			SET_MOXA_MUST_FIFO_VALUE(info);
+			mxser_set_must_fifo_value(info);
 		} else {
 			switch (info->rx_trigger) {
 			case 1:
@@ -657,17 +851,21 @@ static int mxser_change_speed(struct mxser_port *info,
 		}
 	}
 	if (info->board->chip_flag) {
-		SET_MOXA_MUST_XON1_VALUE(info->ioaddr, START_CHAR(info->tty));
-		SET_MOXA_MUST_XOFF1_VALUE(info->ioaddr, STOP_CHAR(info->tty));
+		mxser_set_must_xon1_value(info->ioaddr, START_CHAR(info->tty));
+		mxser_set_must_xoff1_value(info->ioaddr, STOP_CHAR(info->tty));
 		if (I_IXON(info->tty)) {
-			ENABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_enable_must_rx_software_flow_control(
+					info->ioaddr);
 		} else {
-			DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_rx_software_flow_control(
+					info->ioaddr);
 		}
 		if (I_IXOFF(info->tty)) {
-			ENABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_enable_must_tx_software_flow_control(
+					info->ioaddr);
 		} else {
-			DISABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_tx_software_flow_control(
+					info->ioaddr);
 		}
 	}
 
@@ -1925,7 +2123,8 @@ static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termi
 
 		if (info->board->chip_flag) {
 			spin_lock_irqsave(&info->slock, flags);
-			DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
+			mxser_disable_must_rx_software_flow_control(
+					info->ioaddr);
 			spin_unlock_irqrestore(&info->slock, flags);
 		}
 
@@ -2342,7 +2541,7 @@ static int __devinit mxser_initbrd(struct mxser_board *brd,
 
 		/* Enhance mode enabled here */
 		if (brd->chip_flag != MOXA_OTHER_UART)
-			ENABLE_MOXA_MUST_ENCHANCE_MODE(info->ioaddr);
+			mxser_enable_must_enchance_mode(info->ioaddr);
 
 		info->flags = ASYNC_SHARE_IRQ;
 		info->type = brd->uart_type;
diff --git a/drivers/char/mxser.h b/drivers/char/mxser.h
index 8441711..41878a6 100644
--- a/drivers/char/mxser.h
+++ b/drivers/char/mxser.h
@@ -147,141 +147,4 @@
 /* Rx software flow control mask */
 #define MOXA_MUST_EFR_SF_RX_MASK	0x03
 
-#define ENABLE_MOXA_MUST_ENCHANCE_MODE(baseio) do { 		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr |= MOXA_MUST_EFR_EFRB_ENABLE;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_ENCHANCE_MODE(baseio) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_EFRB_ENABLE;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_XON1_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK0;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_XON1_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_XOFF1_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK0;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_XOFF1_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_FIFO_VALUE(info) do {			\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((info)->ioaddr+UART_LCR);		\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (info)->ioaddr+UART_LCR);\
-	__efr = inb((info)->ioaddr+MOXA_MUST_EFR_REGISTER);	\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK1;				\
-	outb(__efr, (info)->ioaddr+MOXA_MUST_EFR_REGISTER);	\
-	outb((u8)((info)->rx_high_water), (info)->ioaddr+	\
-			MOXA_MUST_RBRTH_REGISTER);		\
-	outb((u8)((info)->rx_trigger), (info)->ioaddr+		\
-			MOXA_MUST_RBRTI_REGISTER);		\
-	outb((u8)((info)->rx_low_water), (info)->ioaddr+	\
-			MOXA_MUST_RBRTL_REGISTER);		\
-	outb(__oldlcr, (info)->ioaddr+UART_LCR);		\
-} while (0)
-
-#define SET_MOXA_MUST_ENUM_VALUE(baseio, Value) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK2;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb((u8)(Value), (baseio)+MOXA_MUST_ENUM_REGISTER);	\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define GET_MOXA_MUST_HARDWARE_ID(baseio, pId) do {		\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
-	__efr |= MOXA_MUST_EFR_BANK2;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	*pId = inb((baseio)+MOXA_MUST_HWID_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define ENABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_TX_MASK;			\
-	__efr |= MOXA_MUST_EFR_SF_TX1;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_TX_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define ENABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_RX_MASK;			\
-	__efr |= MOXA_MUST_EFR_SF_RX1;				\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
-#define DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(baseio) do {	\
-	u8	__oldlcr, __efr;				\
-	__oldlcr = inb((baseio)+UART_LCR);			\
-	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
-	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
-	__efr &= ~MOXA_MUST_EFR_SF_RX_MASK;			\
-	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
-	outb(__oldlcr, (baseio)+UART_LCR);			\
-} while (0)
-
 #endif
-- 
1.5.3.8

