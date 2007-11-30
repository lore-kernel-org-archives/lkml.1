Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbXLFMv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbXLFMv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbXLFMnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:55 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53758 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbXLFMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:53 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <79e31cc009093f85216600133ba6d140883f0d75.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:26:23 +0100
Subject: [PATCH 37/47] Update CRISv32 debugport.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include paths to machine dependent headers.
- Add support for fifth serial port.
- Remove CONFIG_ETRAXFS_SIM and CONFIG_ETRAX_DEBUG_PORT_NULL, no longer used.
- Remove raw_printk and stupid_debug hack, no longer needed.
- Remove dummy console stuff, no longer needed.
- Correct some register type names.
- Correct some whitespace errors and formatting.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/debugport.c |  342 ++++----------------------------
 1 files changed, 43 insertions(+), 299 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index d1272ad..15af4c2 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -4,17 +4,12 @@
 
 #include <linux/console.h>
 #include <linux/init.h>
-#include <linux/major.h>
-#include <linux/delay.h>
-#include <linux/tty.h>
 #include <asm/system.h>
-#include <asm/io.h>
-#include <asm/arch/hwregs/ser_defs.h>
-#include <asm/arch/hwregs/dma_defs.h>
-#include <asm/arch/pinmux.h>
-
-#include <asm/irq.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/ser_defs.h>
+#include <hwregs/dma_defs.h>
+#include <asm/arch/mach/pinmux.h>
 
 struct dbg_port
 {
@@ -59,45 +54,50 @@ struct dbg_port ports[] =
     115200,
     'N',
     8
-  }
+  },
+#if CONFIG_ETRAX_SERIAL_PORTS == 5
+  {
+    4,
+    regi_ser4,
+    0,
+    115200,
+    'N',
+    8
+  },
+#endif
 };
 static struct dbg_port *port =
 #if defined(CONFIG_ETRAX_DEBUG_PORT0)
-&ports[0];
+	&ports[0];
 #elif defined(CONFIG_ETRAX_DEBUG_PORT1)
-&ports[1];
+	&ports[1];
 #elif defined(CONFIG_ETRAX_DEBUG_PORT2)
-&ports[2];
+	&ports[2];
 #elif defined(CONFIG_ETRAX_DEBUG_PORT3)
-&ports[3];
+	&ports[3];
+#elif defined(CONFIG_ETRAX_DEBUG_PORT4)
+	&ports[4];
 #else
-NULL;
+	NULL;
 #endif
 
 #ifdef CONFIG_ETRAX_KGDB
 static struct dbg_port *kgdb_port =
 #if defined(CONFIG_ETRAX_KGDB_PORT0)
-&ports[0];
+	&ports[0];
 #elif defined(CONFIG_ETRAX_KGDB_PORT1)
-&ports[1];
+	&ports[1];
 #elif defined(CONFIG_ETRAX_KGDB_PORT2)
-&ports[2];
+	&ports[2];
 #elif defined(CONFIG_ETRAX_KGDB_PORT3)
-&ports[3];
+	&ports[3];
+#elif defined(CONFIG_ETRAX_KGDB_PORT4)
+	&ports[4];
 #else
-NULL;
+	NULL;
 #endif
 #endif
 
-#ifdef CONFIG_ETRAXFS_SIM
-extern void print_str( const char *str );
-static char buffer[1024];
-static char msg[] = "Debug: ";
-static int buffer_pos = sizeof(msg) - 1;
-#endif
-
-extern struct tty_driver *serial_driver;
-
 static void
 start_port(struct dbg_port* p)
 {
@@ -114,6 +114,10 @@ start_port(struct dbg_port* p)
 		crisv32_pinmux_alloc_fixed(pinmux_ser2);
 	else if (p->nbr == 3)
 		crisv32_pinmux_alloc_fixed(pinmux_ser3);
+#if CONFIG_ETRAX_SERIAL_PORTS == 5
+	else if (p->nbr == 4)
+		crisv32_pinmux_alloc_fixed(pinmux_ser4);
+#endif
 
 	/* Set up serial port registers */
 	reg_ser_rw_tr_ctrl tr_ctrl = {0};
@@ -156,124 +160,21 @@ start_port(struct dbg_port* p)
 	REG_WR (ser, p->instance, rw_rec_ctrl, rec_ctrl);
 }
 
-/* No debug */
-#ifdef CONFIG_ETRAX_DEBUG_PORT_NULL
-
-static void
-console_write(struct console *co, const char *buf, unsigned int len)
-{
-	return;
-}
-
-/* Target debug */
-#elif !defined(CONFIG_ETRAXFS_SIM)
-
-static void
-console_write_direct(struct console *co, const char *buf, unsigned int len)
-{
-	int i;
-	reg_ser_r_stat_din stat;
-	reg_ser_rw_tr_dma_en tr_dma_en, old;
-
-	/* Switch to manual mode */
-	tr_dma_en = old = REG_RD (ser, port->instance, rw_tr_dma_en);
-	if (tr_dma_en.en == regk_ser_yes) {
-		tr_dma_en.en = regk_ser_no;
-		REG_WR(ser, port->instance, rw_tr_dma_en, tr_dma_en);
-	}
-
-	/* Send data */
-	for (i = 0; i < len; i++) {
-		/* LF -> CRLF */
-		if (buf[i] == '\n') {
-			do {
-				stat = REG_RD (ser, port->instance, r_stat_din);
-			} while (!stat.tr_rdy);
-			REG_WR_INT (ser, port->instance, rw_dout, '\r');
-		}
-		/* Wait until transmitter is ready and send.*/
-		do {
-			stat = REG_RD (ser, port->instance, r_stat_din);
-		} while (!stat.tr_rdy);
-		REG_WR_INT (ser, port->instance, rw_dout, buf[i]);
-	}
-
-	/* Restore mode */
-	if (tr_dma_en.en != old.en)
-		REG_WR(ser, port->instance, rw_tr_dma_en, old);
-}
-
-static void
-console_write(struct console *co, const char *buf, unsigned int len)
-{
-	if (!port)
-		return;
-        console_write_direct(co, buf, len);
-}
-
-
-
-#else
-
-/* VCS debug */
-
-static void
-console_write(struct console *co, const char *buf, unsigned int len)
-{
-	char* pos;
-	pos = memchr(buf, '\n', len);
-	if (pos) {
-		int l = ++pos - buf;
-		memcpy(buffer + buffer_pos, buf, l);
-		memcpy(buffer, msg, sizeof(msg) - 1);
-		buffer[buffer_pos + l] = '\0';
-		print_str(buffer);
-		buffer_pos = sizeof(msg) - 1;
-		if (pos - buf != len) {
-			memcpy(buffer + buffer_pos, pos, len - l);
-			buffer_pos += len - l;
-		}
-	} else {
-		memcpy(buffer + buffer_pos, buf, len);
-		buffer_pos += len;
-	}
-}
-
-#endif
-
-int raw_printk(const char *fmt, ...)
-{
-	static char buf[1024];
-	int printed_len;
-	va_list args;
-	va_start(args, fmt);
-	printed_len = vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
-	console_write(NULL, buf, strlen(buf));
-	return printed_len;
-}
-
-void
-stupid_debug(char* buf)
-{
-  console_write(NULL, buf, strlen(buf));
-}
-
 #ifdef CONFIG_ETRAX_KGDB
 /* Use polling to get a single character from the kernel debug port */
 int
 getDebugChar(void)
 {
-	reg_ser_rs_status_data stat;
+	reg_ser_rs_stat_din stat;
 	reg_ser_rw_ack_intr ack_intr = { 0 };
 
 	do {
-		stat = REG_RD(ser, kgdb_instance, rs_status_data);
-	} while (!stat.data_avail);
+		stat = REG_RD(ser, kgdb_port->instance, rs_stat_din);
+	} while (!stat.dav);
 
 	/* Ack the data_avail interrupt. */
-	ack_intr.data_avail = 1;
-	REG_WR(ser, kgdb_instance, rw_ack_intr, ack_intr);
+	ack_intr.dav = 1;
+	REG_WR(ser, kgdb_port->instance, rw_ack_intr, ack_intr);
 
 	return stat.data;
 }
@@ -282,173 +183,18 @@ getDebugChar(void)
 void
 putDebugChar(int val)
 {
-	reg_ser_r_status_data stat;
+	reg_ser_r_stat_din stat;
 	do {
-		stat = REG_RD (ser, kgdb_instance, r_status_data);
-	} while (!stat.tr_ready);
-	REG_WR (ser, kgdb_instance, rw_data_out, REG_TYPE_CONV(reg_ser_rw_data_out, int, val));
+		stat = REG_RD(ser, kgdb_port->instance, r_stat_din);
+	} while (!stat.tr_rdy);
+	REG_WR_INT(ser, kgdb_port->instance, rw_dout, val);
 }
 #endif /* CONFIG_ETRAX_KGDB */
 
-static int __init
-console_setup(struct console *co, char *options)
-{
-	char* s;
-
-	if (options) {
-		port = &ports[co->index];
-		port->baudrate = 115200;
-		port->parity = 'N';
-		port->bits = 8;
-		port->baudrate = simple_strtoul(options, NULL, 10);
-		s = options;
-		while(*s >= '0' && *s <= '9')
-			s++;
-		if (*s) port->parity = *s++;
-		if (*s) port->bits   = *s++ - '0';
-		port->started = 0;
-		start_port(port);
-	}
-	return 0;
-}
-
-/* This is a dummy serial device that throws away anything written to it.
- * This is used when no debug output is wanted.
- */
-static struct tty_driver dummy_driver;
-
-static int dummy_open(struct tty_struct *tty, struct file * filp)
-{
-	return 0;
-}
-
-static void dummy_close(struct tty_struct *tty, struct file * filp)
-{
-}
-
-static int dummy_write(struct tty_struct * tty,
-                       const unsigned char *buf, int count)
-{
-	return count;
-}
-
-static int
-dummy_write_room(struct tty_struct *tty)
-{
-	return 8192;
-}
-
-void __init
-init_dummy_console(void)
-{
-	memset(&dummy_driver, 0, sizeof(struct tty_driver));
-	dummy_driver.driver_name = "serial";
-	dummy_driver.name = "ttyS";
-	dummy_driver.major = TTY_MAJOR;
-	dummy_driver.minor_start = 68;
-	dummy_driver.num = 1;       /* etrax100 has 4 serial ports */
-	dummy_driver.type = TTY_DRIVER_TYPE_SERIAL;
-	dummy_driver.subtype = SERIAL_TYPE_NORMAL;
-	dummy_driver.init_termios = tty_std_termios;
-	dummy_driver.init_termios.c_cflag =
-		B115200 | CS8 | CREAD | HUPCL | CLOCAL; /* is normally B9600 default... */
-	dummy_driver.flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-
-	dummy_driver.open = dummy_open;
-	dummy_driver.close = dummy_close;
-	dummy_driver.write = dummy_write;
-	dummy_driver.write_room = dummy_write_room;
-	if (tty_register_driver(&dummy_driver))
-		panic("Couldn't register dummy serial driver\n");
-}
-
-static struct tty_driver*
-crisv32_console_device(struct console* co, int *index)
-{
-	if (port)
-		*index = port->nbr;
-        return port ? serial_driver : &dummy_driver;
-}
-
-static struct console sercons = {
-	name : "ttyS",
-	write: console_write,
-	read : NULL,
-	device : crisv32_console_device,
-	unblank : NULL,
-	setup : console_setup,
-	flags : CON_PRINTBUFFER,
-	index : -1,
-	cflag : 0,
-	next : NULL
-};
-static struct console sercons0 = {
-	name : "ttyS",
-	write: console_write,
-	read : NULL,
-	device : crisv32_console_device,
-	unblank : NULL,
-	setup : console_setup,
-	flags : CON_PRINTBUFFER,
-	index : 0,
-	cflag : 0,
-	next : NULL
-};
-
-static struct console sercons1 = {
-	name : "ttyS",
-	write: console_write,
-	read : NULL,
-	device : crisv32_console_device,
-	unblank : NULL,
-	setup : console_setup,
-	flags : CON_PRINTBUFFER,
-	index : 1,
-	cflag : 0,
-	next : NULL
-};
-static struct console sercons2 = {
-	name : "ttyS",
-	write: console_write,
-	read : NULL,
-	device : crisv32_console_device,
-	unblank : NULL,
-	setup : console_setup,
-	flags : CON_PRINTBUFFER,
-	index : 2,
-	cflag : 0,
-	next : NULL
-};
-static struct console sercons3 = {
-	name : "ttyS",
-	write: console_write,
-	read : NULL,
-	device : crisv32_console_device,
-	unblank : NULL,
-	setup : console_setup,
-	flags : CON_PRINTBUFFER,
-	index : 3,
-	cflag : 0,
-	next : NULL
-};
-
 /* Register console for printk's, etc. */
 int __init
 init_etrax_debug(void)
 {
-  	static int first = 1;
-
-	if (!first) {
-		unregister_console(&sercons);
-		register_console(&sercons0);
-		register_console(&sercons1);
-		register_console(&sercons2);
-		register_console(&sercons3);
-		init_dummy_console();
-		return 0;
-	}
-	first = 0;
-        register_console(&sercons);
         start_port(port);
 
 #ifdef CONFIG_ETRAX_KGDB
@@ -456,5 +202,3 @@ init_etrax_debug(void)
 #endif /* CONFIG_ETRAX_KGDB */
 	return 0;
 }
-
-__initcall(init_etrax_debug);
-- 
1.5.3.6.970.gd25430

