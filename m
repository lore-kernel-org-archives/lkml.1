Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbZCNAeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbZCNAeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZCNATT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:19 -0400
Received: from kroah.org ([198.145.64.141]:46878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753038AbZCNASr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:43 2009
Message-Id: <20090314000742.991282118@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 27/96] 8250: fix boot hang with serial console when using with Serial Over Lan port
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit b6adea334c6c89d5e6c94f9196bbf3a279cb53bd upstream.

Intel 8257x Ethernet boards have a feature called Serial Over Lan.

This feature works by emulating a serial port, and it is detected by
kernel as a normal 8250 port.  However, this emulation is not perfect, as
also noticed on changeset 7500b1f602aad75901774a67a687ee985d85893f.

Before this patch, the kernel were trying to check if the serial TX is
capable of work using IRQ's.

This were done with a code similar this:

        serial_outp(up, UART_IER, UART_IER_THRI);
        lsr = serial_in(up, UART_LSR);
        iir = serial_in(up, UART_IIR);
        serial_outp(up, UART_IER, 0);

        if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT)
		up->bugs |= UART_BUG_TXEN;

This works fine for other 8250 ports, but, on 8250-emulated SoL port, the
chip is a little lazy to down UART_IIR_NO_INT at UART_IIR register.

Due to that, UART_BUG_TXEN is sometimes enabled.  However, as TX IRQ keeps
working, and the TX polling is now enabled, the driver miss-interprets the
IRQ received later, hanging up the machine until a key is pressed at the
serial console.

This is the 6 version of this patch.  Previous versions were trying to
introduce a large enough delay between serial_outp and serial_in(up,
UART_IIR), but not taking forever.  However, the needed delay couldn't be
safely determined.

At the experimental tests, a delay of 1us solves most of the cases, but
still hangs sometimes.  Increasing the delay to 5us was better, but still
doesn't solve.  A very high delay of 50 ms seemed to work every time.

However, poking around with delays and pray for it to be enough doesn't
seem to be a good approach, even for a quirk.

So, instead of playing with random large arbitrary delays, let's just
disable UART_BUG_TXEN for all SoL ports.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c       |   15 +++++++++++++++
 drivers/serial/8250_pci.c   |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h     |    3 +++
 include/linux/serial_core.h |    1 +
 4 files changed, 55 insertions(+)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1956,6 +1956,20 @@ static int serial8250_startup(struct uar
 
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
@@ -1975,6 +1989,7 @@ static int serial8250_startup(struct uar
 		up->bugs &= ~UART_BUG_TXEN;
 	}
 
+dont_test_tx_en:
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
 	/*
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -762,6 +762,21 @@ pci_default_setup(struct serial_private 
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
+static int skip_tx_en_setup(struct serial_private *priv,
+			const struct pciserial_board *board,
+			struct uart_port *port, int idx)
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
@@ -828,6 +843,27 @@ static struct pci_serial_quirk pci_seria
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
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2283,6 +2283,9 @@
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
+#define PCI_DEVICE_ID_INTEL_8257X_SOL	0x1062
+#define PCI_DEVICE_ID_INTEL_82573E_SOL	0x1085
+#define PCI_DEVICE_ID_INTEL_82573L_SOL	0x108F
 #define PCI_DEVICE_ID_INTEL_82815_MC	0x1130
 #define PCI_DEVICE_ID_INTEL_82815_CGC	0x1132
 #define PCI_DEVICE_ID_INTEL_82092AA_0	0x1221
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -285,6 +285,7 @@ struct uart_port {
 #define UPF_HARDPPS_CD		((__force upf_t) (1 << 11))
 #define UPF_LOW_LATENCY		((__force upf_t) (1 << 13))
 #define UPF_BUGGY_UART		((__force upf_t) (1 << 14))
+#define UPF_NO_TXEN_TEST	((__force upf_t) (1 << 15))
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))


