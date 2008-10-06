Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYJFXhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYJFXhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJFXgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:36:50 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:55374 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYJFXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:36:49 -0400
X-Greylist: delayed 844 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 19:36:48 EDT
Message-ID: <48EAA109.10509@caviumnetworks.com>
Date: Mon, 06 Oct 2008 16:36:41 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: Re: [PATCH 2/2] serial: Move UPIO_TSI register access to processor
 specific file.
References: <48EA9DB8.1000309@caviumnetworks.com>
In-Reply-To: <48EA9DB8.1000309@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2008 23:36:42.0123 (UTC) FILETIME=[62EDA5B0:01C9280C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a completely untested example of how the processor specific
code could be removed from the 8250 UART driver if the first part of
the patch were accepted.

The register access code is moved from drivers/serial/8250.c to
arch/powerpc/kernel/legacy_serial.c

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/powerpc/kernel/legacy_serial.c |   35 +++++++++++++++++++++++++++--------
 drivers/serial/8250.c               |   25 -------------------------
 drivers/serial/serial_core.c        |    2 --
 include/linux/serial_core.h         |    5 ++---
 4 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 9ddfaef..3a56fc1 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -46,10 +46,27 @@ static struct __initdata of_device_id legacy_serial_parents[] = {
 static unsigned int legacy_serial_count;
 static int legacy_serial_console = -1;
 
+static unsigned int tsi_serial_in(struct uart_port *up, int offset)
+{
+	unsigned int tmp;
+	if (offset == UART_IIR) {
+		tmp = readl(p->membase + (UART_IIR & ~3));
+		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
+	} else
+		return readb(p->membase + offset);
+}
+
+static void tsi_serial_out(struct uart_port *up, int offset, int value)
+{
+	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
+		writeb(value, p->membase + offset);
+}
+
 static int __init add_legacy_port(struct device_node *np, int want_index,
 				  int iotype, phys_addr_t base,
 				  phys_addr_t taddr, unsigned long irq,
-				  upf_t flags, int irq_check_parent)
+				  upf_t flags, int irq_check_parent,
+				  int tsi_war)
 {
 	const u32 *clk, *spd;
 	u32 clock = BASE_BAUD * 16;
@@ -105,6 +122,10 @@ static int __init add_legacy_port(struct device_node *np, int want_index,
 	legacy_serial_ports[index].uartclk = clock;
 	legacy_serial_ports[index].irq = irq;
 	legacy_serial_ports[index].flags = flags;
+	if (tsi_war) {
+		legacy_serial_ports[index].serial_in_fn = tsi_serial_in;
+		legacy_serial_ports[index].serial_out_fn = tsi_serial_out;
+	}
 	legacy_serial_infos[index].taddr = taddr;
 	legacy_serial_infos[index].np = of_node_get(np);
 	legacy_serial_infos[index].clock = clock;
@@ -158,10 +179,8 @@ static int __init add_legacy_soc_port(struct device_node *np,
 	/* Add port, irq will be dealt with later. We passed a translated
 	 * IO port value. It will be fixed up later along with the irq
 	 */
-	if (tsi && !strcmp(tsi->type, "tsi-bridge"))
-		return add_legacy_port(np, -1, UPIO_TSI, addr, addr, NO_IRQ, flags, 0);
-	else
-		return add_legacy_port(np, -1, UPIO_MEM, addr, addr, NO_IRQ, flags, 0);
+	return add_legacy_port(np, -1, UPIO_MEM, addr, addr, NO_IRQ, flags, 0,
+			       tsi && !strcmp(tsi->type, "tsi-bridge"));
 }
 
 static int __init add_legacy_isa_port(struct device_node *np,
@@ -202,7 +221,7 @@ static int __init add_legacy_isa_port(struct device_node *np,
 
 	/* Add port, irq will be dealt with later */
 	return add_legacy_port(np, index, UPIO_PORT, reg[1], taddr,
-			       NO_IRQ, UPF_BOOT_AUTOCONF, 0);
+			NO_IRQ, UPF_BOOT_AUTOCONF, 0, 0);
 
 }
 
@@ -275,7 +294,7 @@ static int __init add_legacy_pci_port(struct device_node *np,
 	 * IO port value. It will be fixed up later along with the irq
 	 */
 	return add_legacy_port(np, index, iotype, base, addr, NO_IRQ,
-			       UPF_BOOT_AUTOCONF, np != pci_dev);
+			UPF_BOOT_AUTOCONF, np != pci_dev, 0);
 }
 #endif
 
@@ -482,7 +501,7 @@ static int __init serial_dev_init(void)
 			fixup_port_irq(i, np, port);
 		if (port->iotype == UPIO_PORT)
 			fixup_port_pio(i, np, port);
-		if ((port->iotype == UPIO_MEM) || (port->iotype == UPIO_TSI))
+		if (port->iotype == UPIO_MEM)
 			fixup_port_mmio(i, np, port);
 	}
 
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 2ef79e9..24cff9a 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -407,24 +407,6 @@ static void au_serial_out_fn(struct uart_port *p, int offset, int value)
 }
 #endif
 
-static unsigned int tsi_serial_in_fn(struct uart_port *p, int offset)
-{
-	unsigned int tmp;
-	offset = map_8250_in_reg(p, offset) << p->regshift;
-	if (offset == UART_IIR) {
-		tmp = readl(p->membase + (UART_IIR & ~3));
-		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
-	} else
-		return readb(p->membase + offset);
-}
-
-static void tsi_serial_out_fn(struct uart_port *p, int offset, int value)
-{
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
-		writeb(value, p->membase + offset);
-}
-
 static void dwapb_serial_out_fn(struct uart_port *p, int offset, int value)
 {
 	int save_offset = offset;
@@ -479,11 +461,6 @@ static void set_io_fns_from_upio(struct uart_port *p)
 		p->serial_out_fn = au_serial_out_fn;
 		break;
 #endif
-	case UPIO_TSI:
-		p->serial_in_fn = tsi_serial_in_fn;
-		p->serial_out_fn = tsi_serial_out_fn;
-		break;
-
 	case UPIO_DWAPB:
 		p->serial_in_fn = mem_serial_in_fn;
 		p->serial_out_fn = dwapb_serial_out_fn;
@@ -2364,7 +2341,6 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_AU:
 		size = 0x100000;
 		/* fall thru */
-	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM:
 	case UPIO_DWAPB:
@@ -2403,7 +2379,6 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 	case UPIO_AU:
 		size = 0x100000;
 		/* fall thru */
-	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM:
 	case UPIO_DWAPB:
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index f977c98..14e051d 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2164,7 +2164,6 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
-	case UPIO_TSI:
 	case UPIO_DWAPB:
 		snprintf(address, sizeof(address),
 			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
@@ -2578,7 +2577,6 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 	case UPIO_MEM:
 	case UPIO_MEM32:
 	case UPIO_AU:
-	case UPIO_TSI:
 	case UPIO_DWAPB:
 		return (port1->mapbase == port2->mapbase);
 	}
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 6f49385..60c8bf8 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -259,9 +259,8 @@ struct uart_port {
 #define UPIO_MEM		(2)
 #define UPIO_MEM32		(3)
 #define UPIO_AU			(4)			/* Au1x00 type IO */
-#define UPIO_TSI		(5)			/* Tsi108/109 type IO */
-#define UPIO_DWAPB		(6)			/* DesignWare APB UART */
-#define UPIO_RM9000		(7)			/* RM9000 type IO */
+#define UPIO_DWAPB		(5)			/* DesignWare APB UART */
+#define UPIO_RM9000		(6)			/* RM9000 type IO */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
