Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYKZRRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYKZRRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYKZRQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:16:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37296 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbYKZRQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:16:54 -0500
Date: Wed, 26 Nov 2008 15:16:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andrew Morton <akpm@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] 8250: fix boot hang with serial console when using with
 Serial Over Lan port
Message-ID: <20081126151607.022ad7c7@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel 8257x Ethernet boards have a feature called Serial Over Lan.

This feature works by emulating a serial port, and it is detected by
kernel as a normal 8250 port. However, this emulation is not perfect, as also
noticed on changeset 7500b1f602aad75901774a67a687ee985d85893f.

Before this patch, the kernel were trying to check if the serial TX is
capable of work using IRQ's. 

This were done with a code similar this:

        serial_outp(up, UART_IER, UART_IER_THRI);
        lsr = serial_in(up, UART_LSR);
        iir = serial_in(up, UART_IIR);
        serial_outp(up, UART_IER, 0);

        if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
		up->bugs |= UART_BUG_TXEN;

This works fine for other 8250 ports, but, on 8250-emulated SoL port, the chip
is a little lazy to down UART_IIR_NO_INT at UART_IIR register.

Due to that, UART_BUG_TXEN is sometimes enabled. However, as TX IRQ keeps
working, and the TX polling is now enabled, the driver miss-interprets the IRQ
received later, hanging up the machine until a key is pressed at the serial
console.
 
This is the 6 version of this patch. Previous versions were trying to introduce
a large enough delay between serial_outp and serial_in(up, UART_IIR), but not
taking forever. However, the needed delay couldn't be safely determined.

At the experimental tests, a delay of 1us solves most of the cases, but still
hangs sometimes. Increasing the delay to 5us was better, but still doesn't solve.
A very high delay of 50 ms seemed to work every time.

However, poking around with delays and pray for it to be enough doesn't seem to
be a good approach, even for a quirk.

So, instead of playing with random large arbitrary delays, let's just disable
UART_BUG_TXEN for all SoL ports.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..a181ccf 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2014,6 +2014,20 @@ static int serial8250_startup(struct uart_port *port)
 
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 
+	/* Serial over Lan (SoL) hack:
+	   Intel 8257x Gigabit ethernet chips have a
+	   16550 emulation, to be used for Serial Over Lan.
+	   Those chips take a longer time than a normal
+	   serial device to signalize that a transmission
+	   data was queued. Due to that, the above test generally
+	   fails. One solution would be to delay the reading of
+	   iir. However, this is not reliable, since the timeout
+	   is variable. So, let's just don't test if we receive
+	   TX irq. This way, we'll never enable UART_BUG_TXEN.
+	 */
+	if (up->port.flags & UPF_NO_TXEN_TEST)
+		goto dont_test_tx_en;
+
 	/*
 	 * Do a quick test to see if we receive an
 	 * interrupt when we enable the TX irq.
@@ -2033,6 +2047,7 @@ static int serial8250_startup(struct uart_port *port)
 		up->bugs &= ~UART_BUG_TXEN;
 	}
 
+dont_test_tx_en:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
 	/*
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 5450a0e..c53e8a4 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -758,6 +758,21 @@ pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
+static int
+skip_tx_en_setup(struct serial_private *priv, struct pciserial_board *board,
+		  struct uart_port *port, int idx)
+{
+	port->flags |= UPF_NO_TXEN_TEST;
+	printk(KERN_DEBUG "serial8250: skipping TxEn test for device "
+			  "[%04x:%04x] subsystem [%04x:%04x]\n",
+			  priv->dev->vendor,
+			  priv->dev->device,
+			  priv->dev->subsystem_vendor,
+			  priv->dev->subsystem_device);
+
+	return pci_default_setup(priv, board, port, idx);
+}
+
 /* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
@@ -822,6 +837,27 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.init		= pci_inteli960ni_init,
 		.setup		= pci_default_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_8257X_SOL,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= skip_tx_en_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_82573L_SOL,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= skip_tx_en_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_82573E_SOL,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= skip_tx_en_setup,
+	},
 	/*
 	 * ITE
 	 */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1800f1d..93b6a71 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2309,6 +2309,9 @@
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
+#define PCI_DEVICE_ID_INTEL_8257X_SOL	0x1062
+#define PCI_DEVICE_ID_INTEL_82573E_SOL	0x1085
+#define PCI_DEVICE_ID_INTEL_82573L_SOL	0x108F
 #define PCI_DEVICE_ID_INTEL_82815_MC	0x1130
 #define PCI_DEVICE_ID_INTEL_82815_CGC	0x1132
 #define PCI_DEVICE_ID_INTEL_82092AA_0	0x1221
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 4e4f127..a551e97 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -288,6 +288,7 @@ struct uart_port {
 #define UPF_HARDPPS_CD		((__force upf_t) (1 << 11))
 #define UPF_LOW_LATENCY		((__force upf_t) (1 << 13))
 #define UPF_BUGGY_UART		((__force upf_t) (1 << 14))
+#define UPF_NO_TXEN_TEST	((__force upf_t) (1 << 15))
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
