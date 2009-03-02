Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZCBOZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZCBOZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZCBOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:25:09 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:51095 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCBOZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:25:08 -0500
Message-ID: <49ABEC38.6050806@linux.vnet.ibm.com>
Date: Mon, 02 Mar 2009 11:24:56 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: alan@lxorguk.ukuu.org.uk, scottk@digi.com
Subject: [PATCH 1/1] jsm: Cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some cleanups, mainly removing unused variables and silly
declarations.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>

---

 drivers/serial/jsm/jsm_neo.c |   14 ++++----------
 drivers/serial/jsm/jsm_tty.c |   19 ++++++++-----------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index e6390d0..9dadaa1 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -533,7 +533,6 @@ static void neo_copy_data_from_queue_to_uart(struct jsm_channel *ch)
 	if (!(ch->ch_flags & (CH_TX_FIFO_EMPTY | CH_TX_FIFO_LWM)))
 		return;
 
-	len_written = 0;
 	n = UART_17158_TX_FIFOSIZE - ch->ch_t_tlevel;
 
 	/* cache head and tail of queue */
@@ -619,14 +618,10 @@ static void neo_parse_modem(struct jsm_channel *ch, u8 signals)
 /* Make the UART raise any of the output signals we want up */
 static void neo_assert_modem_signals(struct jsm_channel *ch)
 {
-	u8 out;
-
 	if (!ch)
 		return;
 
-	out = ch->ch_mostat;
-
-	writeb(out, &ch->ch_neo_uart->mcr);
+	writeb(ch->ch_mostat, &ch->ch_neo_uart->mcr);
 
 	/* flush write operation */
 	neo_pci_posting_flush(ch->ch_bd);
@@ -936,10 +931,9 @@ static inline void neo_parse_lsr(struct jsm_board *brd, u32 port)
 static void neo_param(struct jsm_channel *ch)
 {
 	u8 lcr = 0;
-	u8 uart_lcr = 0;
-	u8 ier = 0;
-	u32 baud = 9600;
-	int quot = 0;
+	u8 uart_lcr, ier;
+	u32 baud;
+	int quot;
 	struct jsm_board *bd;
 
 	bd = ch->ch_bd;
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 324c74d..2285bf4 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -183,7 +183,6 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 static int jsm_tty_open(struct uart_port *port)
 {
 	struct jsm_board *brd;
-	int rc = 0;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 	struct ktermios *termios;
 
@@ -265,7 +264,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_open_count++;
 
 	jsm_printk(OPEN, INFO, &channel->ch_bd->pci_dev, "finish\n");
-	return rc;
+	return 0;
 }
 
 static void jsm_tty_close(struct uart_port *port)
@@ -748,7 +747,7 @@ static void jsm_carrier(struct jsm_channel *ch)
 void jsm_check_queue_flow_control(struct jsm_channel *ch)
 {
 	struct board_ops *bd_ops = ch->ch_bd->bd_ops;
-	int qleft = 0;
+	int qleft;
 
 	/* Store how much space we have left in the queue */
 	if ((qleft = ch->ch_r_tail - ch->ch_r_head - 1) < 0)
@@ -834,7 +833,7 @@ void jsm_check_queue_flow_control(struct jsm_channel *ch)
  */
 int jsm_tty_write(struct uart_port *port)
 {
-	int bufcount = 0, n = 0;
+	int bufcount;
 	int data_count = 0,data_count1 =0;
 	u16 head;
 	u16 tail;
@@ -850,14 +849,12 @@ int jsm_tty_write(struct uart_port *port)
 	if ((bufcount = tail - head - 1) < 0)
 		bufcount += WQUEUESIZE;
 
-	n = bufcount;
-
-	n = min(n, 56);
+	bufcount = min(bufcount, 56);
 	remain = WQUEUESIZE - head;
 
 	data_count = 0;
-	if (n >= remain) {
-		n -= remain;
+	if (bufcount >= remain) {
+		bufcount -= remain;
 		while ((port->info->xmit.head != temp_tail) &&
 		(data_count < remain)) {
 			channel->ch_wqueue[head++] =
@@ -871,8 +868,8 @@ int jsm_tty_write(struct uart_port *port)
 	}
 
 	data_count1 = 0;
-	if (n > 0) {
-		remain = n;
+	if (bufcount > 0) {
+		remain = bufcount;
 		while ((port->info->xmit.head != temp_tail) &&
 			(data_count1 < remain)) {
 			channel->ch_wqueue[head++] =
