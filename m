Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbZEHVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbZEHVYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZEHVXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:44751 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbZEHVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 03/13] RFC ONLY - kgdb,8250,pl011: Return immediately from console poll
Date: Fri,  8 May 2009 16:23:10 -0500
Message-Id: <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:26.0513 (UTC) FILETIME=[3992E210:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

The design of kdb required that every device that can provide input to
kdb have a polling routine that exits immediately if there is no
character available.

This is required in order to get the page scrolling mechanism working,
it is also a reasonable requirement for future kgdb I/O drivers
because that allows for the possibility of multiple input channels.

NO_POLL_CHAR will be the return code to the polling routine when ever
there is no character available.  There are several other console
polling drivers which can be modified, but for the prototype only the
8250 and pl011 driver have been changed to make use of this.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/8250.c       |    4 +-
 drivers/serial/amba-pl011.c |    6 ++--
 include/linux/kgdb.h        |    3 ++
 include/linux/serial_core.h |    1 +
 kernel/kgdb.c               |   47 +++++++++++++++++++++++++++++++++++++-----
 5 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b4b3981..03f815b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1884,8 +1884,8 @@ static int serial8250_get_poll_char(struct uart_port *port)
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char lsr = serial_inp(up, UART_LSR);
 
-	while (!(lsr & UART_LSR_DR))
-		lsr = serial_inp(up, UART_LSR);
+	if (!(lsr & UART_LSR_DR))
+		return NO_POLL_CHAR;
 
 	return serial_inp(up, UART_RX);
 }
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 8b2b970..fb2ed6a 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -318,9 +318,9 @@ static int pl010_get_poll_char(struct uart_port *port)
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 	unsigned int status;
 
-	do {
-		status = readw(uap->port.membase + UART01x_FR);
-	} while (status & UART01x_FR_RXFE);
+	status = readw(uap->port.membase + UART01x_FR);
+	if (status & UART01x_FR_RXFE)
+		return NO_POLL_CHAR;
 
 	return readw(uap->port.membase + UART01x_DR);
 }
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 3e838d6..967803d 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -283,4 +283,7 @@ extern int kgdb_nmicallback(int cpu, void *regs);
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 
+#ifdef CONFIG_KGDB_SERIAL_CONSOLE
+extern void __init early_kgdboc_init(void);
+#endif /* CONFIG_KGDB_SERIAL_CONSOLE */
 #endif /* _KGDB_H_ */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 57a97e5..6fda5b8 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -232,6 +232,7 @@ struct uart_ops {
 #endif
 };
 
+#define NO_POLL_CHAR		0x00ff0000
 #define UART_CONFIG_TYPE	(1 << 0)
 #define UART_CONFIG_IRQ		(1 << 1)
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 067f2cf..2f093bc 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -50,6 +50,7 @@
 #include <linux/kdebug.h>
 #include <linux/kdb.h>
 #include <linux/kdbprivate.h>
+#include <linux/serial_core.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -254,6 +255,8 @@ void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
  * KDB interface to KGDB internals
  */
 #ifdef CONFIG_KGDB_KDB
+int kdb_poll_idx = 1;
+EXPORT_SYMBOL_GPL(kdb_poll_idx);
 static void gdb_cmd_status(struct kgdb_state *ks);
 static void put_packet(char *buffer);
 static int kgdb_activate_sw_breakpoints(void);
@@ -261,6 +264,8 @@ static int kgdb_activate_sw_breakpoints(void);
 static int kgdbio_get_char(void)
 {
 	int ret = kgdb_io_ops->read_char();
+	if (ret == NO_POLL_CHAR)
+		return -1;
 	if (!kgdb_use_passthrough)
 		return ret;
 	if (ret == 127)
@@ -271,7 +276,27 @@ static int kgdbio_get_char(void)
 get_char_func kdb_poll_funcs[] = {
 	kgdbio_get_char,
 	NULL,
+	NULL,
+	NULL,
+	NULL,
+	NULL,
 };
+EXPORT_SYMBOL_GPL(kdb_poll_funcs);
+
+static int kgdb_read_wait(void)
+{
+	int ret = -1;
+	int i;
+
+	/* poll any additional I/O interfaces that are defined */
+	while (ret < 0)
+		for (i = 0; kdb_poll_funcs[i] != NULL; i++) {
+			ret = kdb_poll_funcs[i]();
+			if (ret > 0)
+				break;
+		}
+	return ret;
+}
 
 static int comm_passthrough(struct kgdb_state *ks)
 {
@@ -333,6 +358,7 @@ static int comm_passthrough(struct kgdb_state *ks)
 	kdb_bp_remove_global();
 	KDB_STATE_CLEAR(DOING_SS);
 	KDB_STATE_CLEAR(DOING_SSB);
+	KDB_STATE_SET(PAGER);
 	for_each_online_cpu(i) {
 		kdb_save_running_cpu(kgdb_info[i].debuggerinfo,
 				     kgdb_info[i].task, i);
@@ -356,6 +382,7 @@ static int comm_passthrough(struct kgdb_state *ks)
 	kdb_initial_cpu = -1;
 	kdb_current_task = NULL;
 	kdb_current_regs = NULL;
+	KDB_STATE_CLEAR(PAGER);
 	kdbnearsym_cleanup();
 	if (error == KDB_CMD_KGDB) {
 		if (KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)) {
@@ -397,6 +424,14 @@ static int comm_passthrough(struct kgdb_state *ks)
 {
 	return KGDB_PASS_EVENT;
 }
+
+static int kgdb_read_wait(void)
+{
+	int ret = kgdb_io_ops->read_char();
+	while (ret == NO_POLL_CHAR)
+		ret = kgdb_io_ops->read_char();
+	return ret;
+}
 #endif /* CONFIG_KGDB_KDB */
 
 /*
@@ -427,7 +462,7 @@ static void get_packet(char *buffer)
 		 * Spin and wait around for the start character, ignore all
 		 * other characters:
 		 */
-		while ((ch = (kgdb_io_ops->read_char())) != '$')
+		while ((ch = (kgdb_read_wait())) != '$')
 			/* nothing */;
 
 		kgdb_connected = 1;
@@ -440,7 +475,7 @@ static void get_packet(char *buffer)
 		 * now, read until a # or end of buffer is found:
 		 */
 		while (count < (BUFMAX - 1)) {
-			ch = kgdb_io_ops->read_char();
+			ch = kgdb_read_wait();
 			if (ch == '#')
 				break;
 			checksum = checksum + ch;
@@ -450,8 +485,8 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(kgdb_io_ops->read_char()) << 4;
-			xmitcsum += hex(kgdb_io_ops->read_char());
+			xmitcsum = hex(kgdb_read_wait()) << 4;
+			xmitcsum += hex(kgdb_read_wait());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
@@ -496,10 +531,10 @@ static void put_packet(char *buffer)
 			kgdb_io_ops->flush();
 
 		/* Now see what we get in reply. */
-		ch = kgdb_io_ops->read_char();
+		ch = kgdb_read_wait();
 
 		if (ch == 3)
-			ch = kgdb_io_ops->read_char();
+			ch = kgdb_read_wait();
 
 		/* If we get an ACK, we are done. */
 		if (ch == '+')
-- 
1.6.3.rc0.1.gf800

