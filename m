Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbYA2NvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbYA2NvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762515AbYA2Ntr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:49:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:55902 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764040AbYA2Ntk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:49:40 -0500
Date: Tue, 29 Jan 2008 14:49:24 +0100
From: David Sterba <dsterba@suse.cz>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: [PATCH v3] ipwireless: driver for 3G PC Card
Message-ID: <20080129134924.GB32589@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm resending the patch with fixes after feedback from lkml.

Changelog v2->v3:
- use __BIG_ENDIAN_BITFIELDS
- fixed typos and @ ! artifacts in comments
- cleaned and a bit documented module params
- added ':' after module names in printk
- use safe snprintf for some debug output

David Sterba
---
From: David Sterba <dsterba@suse.cz>

ipwireless_cs: driver for PC Card, 3G internet connection

The driver is manufactured by IPWireless.

Rewieved-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Ben Martel <benm@symmetric.co.nz>
Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 MAINTAINERS                                     |    8 
 drivers/char/pcmcia/Kconfig                     |    9 
 drivers/char/pcmcia/Makefile                    |    2 
 drivers/char/pcmcia/ipwireless/Makefile         |   10 
 drivers/char/pcmcia/ipwireless/hardware.c       | 1788 ++++++++++++++++++++++++
 drivers/char/pcmcia/ipwireless/hardware.h       |   64 
 drivers/char/pcmcia/ipwireless/main.c           |  500 ++++++
 drivers/char/pcmcia/ipwireless/main.h           |   70 
 drivers/char/pcmcia/ipwireless/network.c        |  512 ++++++
 drivers/char/pcmcia/ipwireless/network.h        |   55 
 drivers/char/pcmcia/ipwireless/setup_protocol.h |  108 +
 drivers/char/pcmcia/ipwireless/tty.c            |  688 +++++++++
 drivers/char/pcmcia/ipwireless/tty.h            |   48 
 13 files changed, 3862 insertions(+)
---
diff --git a/MAINTAINERS b/MAINTAINERS
index df40a4e..fc01a22 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2007,6 +2007,14 @@ M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+IPWIRELES DRIVER
+P:	Jiri Kosina
+M:	jkosina@suse.cz
+P:	David Sterba
+M:	dsterba@suse.cz
+S:	Maintained
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
 M:	samuel@sortiz.org
diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index f25facd..00b8a84 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -43,5 +43,14 @@ config CARDMAN_4040
 	  (http://www.omnikey.com/), or a current development version of OpenCT
 	  (http://www.opensc.org/).
 
+config IPWIRELESS
+	tristate "IPWireless 3G UMTS PCMCIA card support"
+	depends on PCMCIA
+	select PPP
+	help
+	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
+	  some countries (for example Czech Republic, T-Mobile ISP) this card
+	  is shipped for service called UMTS 4G.
+
 endmenu
 
diff --git a/drivers/char/pcmcia/Makefile b/drivers/char/pcmcia/Makefile
index 0aae209..be8f287 100644
--- a/drivers/char/pcmcia/Makefile
+++ b/drivers/char/pcmcia/Makefile
@@ -4,6 +4,8 @@
 # Makefile for the Linux PCMCIA char device drivers.
 #
 
+obj-y += ipwireless/
+
 obj-$(CONFIG_SYNCLINK_CS) += synclink_cs.o
 obj-$(CONFIG_CARDMAN_4000) += cm4000_cs.o
 obj-$(CONFIG_CARDMAN_4040) += cm4040_cs.o
diff --git a/drivers/char/pcmcia/ipwireless/Makefile b/drivers/char/pcmcia/ipwireless/Makefile
new file mode 100644
index 0000000..b71eb59
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/Makefile
@@ -0,0 +1,10 @@
+#
+# drivers/char/pcmcia/ipwireless/Makefile
+#
+# Makefile for the IPWireless driver
+#
+
+obj-$(CONFIG_IPWIRELESS) += ipwireless.o
+
+ipwireless-objs := hardware.o main.o network.o tty.o
+
diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
new file mode 100644
index 0000000..8e418df
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -0,0 +1,1788 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+
+#include "hardware.h"
+#include "setup_protocol.h"
+#include "network.h"
+#include "main.h"
+
+static void ipw_send_setup_packet(struct ipw_hardware *hw);
+static void handle_received_SETUP_packet(struct ipw_hardware *ipw,
+					 unsigned int address,
+					 unsigned char *data, int len,
+					 int is_last);
+static void ipwireless_setup_timer(unsigned long data);
+static void handle_received_CTRL_packet(struct ipw_hardware *hw,
+		unsigned int channel_idx, unsigned char *data, int len);
+
+/*#define TIMING_DIAGNOSTICS*/
+
+#ifdef TIMING_DIAGNOSTICS
+
+static struct timing_stats {
+	unsigned long last_report_time;
+	unsigned long read_time;
+	unsigned long write_time;
+	unsigned long read_bytes;
+	unsigned long write_bytes;
+	unsigned long start_time;
+};
+
+static void start_timing(void)
+{
+	timing_stats.start_time = jiffies;
+}
+
+static void end_read_timing(unsigned length)
+{
+	timing_stats.read_time += (jiffies - start_time);
+	timing_stats.read_bytes += length + 2;
+	report_timing();
+}
+
+static void end_write_timing(unsigned length)
+{
+	timing_stats.write_time += (jiffies - start_time);
+	timing_stats.write_bytes += length + 2;
+	report_timing();
+}
+
+static void report_timing(void)
+{
+	unsigned long since = jiffies - timing_stats.last_report_time;
+
+	/* If it's been more than one second... */
+	if (since >= HZ) {
+		int first = (timing_stats.last_report_time == 0);
+
+		timing_stats.last_report_time = jiffies;
+		if (!first)
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": %u us elapsed - read %lu bytes in %u us, "
+			       "wrote %lu bytes in %u us\n",
+			       jiffies_to_usecs(since),
+			       timing_stats.read_bytes,
+			       jiffies_to_usecs(timing_stats.read_time),
+			       timing_stats.write_bytes,
+			       jiffies_to_usecs(timing_stats.write_time));
+
+		timing_stats.read_time = 0;
+		timing_stats.write_time = 0;
+		timing_stats.read_bytes = 0;
+		timing_stats.write_bytes = 0;
+	}
+}
+#else
+static void start_timing(void) { }
+static void end_read_timing(unsigned length) { }
+static void end_write_timing(unsigned length) { }
+#endif
+
+/* Imported IPW definitions */
+
+#define LL_MTU_V1 318
+#define LL_MTU_V2 250
+#define LL_MTU_MAX (LL_MTU_V1 > LL_MTU_V2 ? LL_MTU_V1 : LL_MTU_V2)
+
+#define PRIO_DATA  2
+#define PRIO_CTRL  1
+#define PRIO_SETUP 0
+
+/* Addresses */
+#define ADDR_SETUP_PROT 0
+
+/* Protocol ids */
+enum {
+	/* Identifier for the Com Data protocol */
+	TL_PROTOCOLID_COM_DATA = 0,
+
+	/* Identifier for the Com Control protocol */
+	TL_PROTOCOLID_COM_CTRL = 1,
+
+	/* Identifier for the Setup protocol */
+	TL_PROTOCOLID_SETUP = 2
+};
+
+/* Number of bytes in NL packet header (cannot do
+ * sizeof(nl_packet_header) since it's a bitfield) */
+#define NL_FIRST_PACKET_HEADER_SIZE        3
+
+/* Number of bytes in NL packet header (cannot do
+ * sizeof(nl_packet_header) since it's a bitfield) */
+#define NL_FOLLOWING_PACKET_HEADER_SIZE    1
+
+struct nl_first_packet_header {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	unsigned char packet_rank:2;
+	unsigned char address:3;
+	unsigned char protocol:3;
+#else
+	unsigned char protocol:3;
+	unsigned char address:3;
+	unsigned char packet_rank:2;
+#endif
+	unsigned char length_lsb;
+	unsigned char length_msb;
+};
+
+struct nl_packet_header {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	unsigned char packet_rank:2;
+	unsigned char address:3;
+	unsigned char protocol:3;
+#else
+	unsigned char protocol:3;
+	unsigned char address:3;
+	unsigned char packet_rank:2;
+#endif
+};
+
+/* Value of 'packet_rank' above */
+#define NL_INTERMEDIATE_PACKET    0x0
+#define NL_LAST_PACKET            0x1
+#define NL_FIRST_PACKET           0x2
+
+union nl_packet {
+	/* Network packet header of the first packet (a special case) */
+	struct nl_first_packet_header hdr_first;
+	/* Network packet header of the following packets (if any) */
+	struct nl_packet_header hdr;
+	/* Complete network packet (header + data) */
+	unsigned char rawpkt[LL_MTU_MAX];
+} __attribute__ ((__packed__));
+
+#define HW_VERSION_UNKNOWN -1
+#define HW_VERSION_1 1
+#define HW_VERSION_2 2
+
+/* IPW I/O ports */
+#define IOIER 0x00		/* Interrupt Enable Register */
+#define IOIR  0x02		/* Interrupt Source/ACK register */
+#define IODCR 0x04		/* Data Control Register */
+#define IODRR 0x06		/* Data Read Register */
+#define IODWR 0x08		/* Data Write Register */
+#define IOESR 0x0A		/* Embedded Driver Status Register */
+#define IORXR 0x0C		/* Rx Fifo Register (Host to Embedded) */
+#define IOTXR 0x0E		/* Tx Fifo Register (Embedded to Host) */
+
+/* I/O ports and bit definitions for version 1 of the hardware */
+
+/* IER bits*/
+#define IER_RXENABLED   ((unsigned short) 0x1)
+#define IER_TXENABLED   ((unsigned short) 0x2)
+
+/* ISR bits */
+#define IR_RXINTR       ((unsigned short) 0x1)
+#define IR_TXINTR       ((unsigned short) 0x2)
+
+/* DCR bits */
+#define DCR_RXDONE      ((unsigned short) 0x1)
+#define DCR_TXDONE      ((unsigned short) 0x2)
+#define DCR_RXRESET     ((unsigned short) 0x4)
+#define DCR_TXRESET     ((unsigned short) 0x8)
+
+/* I/O ports and bit definitions for version 2 of the hardware */
+
+struct MEMCCR {
+	unsigned short PCCOR;		/* Configuration Option Register */
+	unsigned short PCCSR;		/* Configuration and Status Register */
+	unsigned short PCPRR;		/* Pin Replacemant Register */
+	unsigned short PCSCR;		/* Socket and Copy Register */
+	unsigned short PCESR;		/* Extendend Status Register */
+	unsigned short PCIOB;		/* I/O Base Register */
+};
+
+struct MEMINFREG {
+	unsigned short memreg_tx_old;	/* TX Register (R/W) */
+	unsigned short pad1;
+	unsigned short memreg_rx_done;	/* RXDone Register (R/W) */
+	unsigned short pad2;
+	unsigned short memreg_rx;	/* RX Register (R/W) */
+	unsigned short pad3;
+	unsigned short memreg_pc_interrupt_ack;	/* PC intr Ack Register (W) */
+	unsigned short pad4;
+	unsigned long memreg_card_present;/* Mask for Host to check (R) for
+					   * CARD_PRESENT_VALUE */
+	unsigned short memreg_tx_new;	/* TX2 (new) Register (R/W) */
+};
+
+#define IODMADPR 0x00		/* DMA Data Port Register (R/W) */
+
+#define CARD_PRESENT_VALUE ((unsigned long)0xBEEFCAFEUL)
+
+#define MEMTX_TX                       0x0001
+#define MEMRX_RX                       0x0001
+#define MEMRX_RX_DONE                  0x0001
+#define MEMRX_PCINTACKK                0x0001
+#define MEMRX_MEMSPURIOUSINT           0x0001
+
+#define NL_NUM_OF_PRIORITIES       3
+#define NL_NUM_OF_PROTOCOLS        3
+#define NL_NUM_OF_ADDRESSES        NO_OF_IPW_CHANNELS
+
+struct ipw_hardware {
+	unsigned int base_port;
+	short hw_version;
+	unsigned short ll_mtu;
+	spinlock_t spinlock;
+
+	int initializing;
+	int init_loops;
+	struct timer_list setup_timer;
+
+	int tx_ready;
+	struct list_head tx_queue[NL_NUM_OF_PRIORITIES];
+	/* True if any packets are queued for transmission */
+	int tx_queued;
+
+	int rx_bytes_queued;
+	struct list_head rx_queue;
+	/* Pool of rx_packet structures that are not currently used. */
+	struct list_head rx_pool;
+	int rx_pool_size;
+	/* True if reception of data is blocked while userspace processes it. */
+	int blocking_rx;
+	/* True if there is RX data ready on the hardware. */
+	int rx_ready;
+	unsigned short last_memtx_serial;
+	/*
+	 * Newer versions of the V2 card firmware send serial numbers in the
+	 * MemTX register. 'serial_number_detected' is set true when we detect
+	 * a non-zero serial number (indicating the new firmware).  Thereafter,
+	 * the driver can safely ignore the Timer Recovery re-sends to avoid
+	 * out-of-sync problems.
+	 */
+	int serial_number_detected;
+	struct work_struct work_rx;
+
+	/* True if we are to send the set-up data to the hardware. */
+	int to_setup;
+
+	/* Card has been removed */
+	int removed;
+	/* Saved irq value when we disable the interrupt. */
+	int irq;
+	/* True if this driver is shutting down. */
+	int shutting_down;
+	/* Modem control lines */
+	unsigned int control_lines[NL_NUM_OF_ADDRESSES];
+	struct ipw_rx_packet *packet_assembler[NL_NUM_OF_ADDRESSES];
+
+	struct tasklet_struct tasklet;
+
+	/* The handle for the network layer, for the sending of events to it. */
+	struct ipw_network *network;
+	struct MEMINFREG __iomem *memory_info_regs;
+	struct MEMCCR __iomem *memregs_CCR;
+	int bad_interrupt_count;
+	void (*reboot_callback) (void *data);
+	void *reboot_callback_data;
+
+	unsigned short __iomem *memreg_tx;
+};
+
+/*
+ * Packet info structure for tx packets.
+ * Note: not all the fields defined here are required for all protocols
+ */
+struct ipw_tx_packet {
+	struct list_head queue;
+	/* channel idx + 1 */
+	unsigned char dest_addr;
+	/* SETUP, CTRL or DATA */
+	unsigned char protocol;
+	/* Length of data block, which starts at the end of this structure */
+	unsigned short length;
+	/* Sending state */
+	/* Offset of where we've sent up to so far */
+	unsigned long offset;
+	/* Count of packet fragments, starting at 0 */
+	int fragment_count;
+
+	/* Called after packet is sent and before is freed */
+	void (*packet_callback) (void *cb_data, unsigned int packet_length);
+	void *callback_data;
+};
+
+/* Signals from DTE */
+enum ComCtrl_DTESignal {
+	ComCtrl_RTS = 0,
+	ComCtrl_DTR = 1
+};
+
+/* Signals from DCE */
+enum ComCtrl_DCESignal {
+	ComCtrl_CTS = 2,
+	ComCtrl_DCD = 3,
+	ComCtrl_DSR = 4,
+	ComCtrl_RI = 5
+};
+
+struct ipw_control_packet_body {
+	/* ComCtrl_DTESignal or ComCtrl_DCESignal */
+	unsigned char sig_no;
+	/* ComCtrl_SET(0) or ComCtrl_CLEAR(1) */
+	unsigned char value;
+} __attribute__ ((__packed__));
+
+struct ipw_control_packet {
+	struct ipw_tx_packet header;
+	struct ipw_control_packet_body body;
+};
+
+struct ipw_rx_packet {
+	struct list_head queue;
+	unsigned int capacity;
+	unsigned int length;
+	unsigned int protocol;
+	unsigned int channel_idx;
+};
+
+#ifdef IPWIRELESS_STATE_DEBUG
+int ipwireless_dump_hardware_state(char *p, size_t limit,
+				   struct ipw_hardware *hw)
+{
+	return snprintf(p, limit,
+			"debug: initializing=%d\n"
+			"debug: tx_ready=%d\n"
+			"debug: tx_queued=%d\n"
+			"debug: rx_ready=%d\n"
+			"debug: rx_bytes_queued=%d\n"
+			"debug: blocking_rx=%d\n"
+			"debug: removed=%d\n"
+			"debug: hardware.shutting_down=%d\n"
+			"debug: to_setup=%d\n",
+			hw->initializing,
+			hw->tx_ready,
+			hw->tx_queued,
+			hw->rx_ready,
+			hw->rx_bytes_queued,
+			hw->blocking_rx,
+			hw->removed,
+			hw->shutting_down,
+			hw->to_setup);
+}
+#endif
+
+static char *data_type(const unsigned char *buf, unsigned length)
+{
+	struct nl_packet_header *hdr = (struct nl_packet_header *) buf;
+
+	if (length == 0)
+		return "     ";
+
+	if (hdr->packet_rank & NL_FIRST_PACKET) {
+		switch (hdr->protocol) {
+		case TL_PROTOCOLID_COM_DATA:	return "DATA ";
+		case TL_PROTOCOLID_COM_CTRL:	return "CTRL ";
+		case TL_PROTOCOLID_SETUP:	return "SETUP";
+		default: return "???? ";
+		}
+	} else
+		return "     ";
+}
+
+#define DUMP_MAX_BYTES 64
+
+static void dump_data_bytes(const char *type, const unsigned char *data,
+			    unsigned length)
+{
+	char prefix[56];
+
+	sprintf(prefix, IPWIRELESS_PCCARD_NAME ": %s %s ",
+			type, data_type(data, length));
+	print_hex_dump_bytes(prefix, 0, (void *)data,
+			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
+}
+
+static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
+			    unsigned length)
+{
+	int i;
+	unsigned long flags;
+
+	start_timing();
+
+	if (length == 0)
+		return 0;
+
+	if (length > hw->ll_mtu)
+		return -1;
+
+	if (ipwireless_debug)
+		dump_data_bytes("send", data, length);
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+
+	if (hw->hw_version == HW_VERSION_1) {
+		outw((unsigned short) length, hw->base_port + IODWR);
+
+		for (i = 0; i < length; i += 2) {
+			unsigned short d = data[i];
+			__le16 raw_data;
+
+			if (likely(i + 1 < length))
+				d |= data[i + 1] << 8;
+			raw_data = cpu_to_le16(d);
+			outw(raw_data, hw->base_port + IODWR);
+		}
+
+		outw(DCR_TXDONE, hw->base_port + IODCR);
+	} else if (hw->hw_version == HW_VERSION_2) {
+		outw((unsigned short) length, hw->base_port + IODMADPR);
+
+		for (i = 0; i < length; i += 2) {
+			unsigned short d = data[i];
+			__le16 raw_data;
+
+			if ((i + 1 < length))
+				d |= data[i + 1] << 8;
+			raw_data = cpu_to_le16(d);
+			outw(raw_data, hw->base_port + IODMADPR);
+		}
+		while ((i & 3) != 2) {
+			outw((unsigned short) 0xDEAD, hw->base_port + IODMADPR);
+			i += 2;
+		}
+		writew(MEMRX_RX, &hw->memory_info_regs->memreg_rx);
+	}
+
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	end_write_timing(length);
+
+	return 0;
+}
+
+static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
+{
+	unsigned short fragment_data_len;
+	unsigned short data_left = packet->length - packet->offset;
+	unsigned short header_size;
+	union nl_packet pkt;
+
+	header_size =
+	    (packet->fragment_count == 0)
+	    ? NL_FIRST_PACKET_HEADER_SIZE
+	    : NL_FOLLOWING_PACKET_HEADER_SIZE;
+	fragment_data_len = (unsigned short) hw->ll_mtu - header_size;
+	if (data_left < fragment_data_len)
+		fragment_data_len = data_left;
+
+	pkt.hdr_first.protocol = packet->protocol;
+	pkt.hdr_first.address = packet->dest_addr;
+	pkt.hdr_first.packet_rank = 0;
+
+	/* First packet? */
+	if (packet->fragment_count == 0) {
+		pkt.hdr_first.packet_rank |= NL_FIRST_PACKET;
+		pkt.hdr_first.length_lsb = (unsigned char) packet->length;
+		pkt.hdr_first.length_msb =
+			(unsigned char) (packet->length >> 8);
+	}
+
+	memcpy(pkt.rawpkt + header_size,
+	       ((unsigned char *) packet) + sizeof(struct ipw_tx_packet) +
+	       packet->offset, fragment_data_len);
+	packet->offset += fragment_data_len;
+	packet->fragment_count++;
+
+	/* Last packet? (May also be first packet.) */
+	if (packet->offset == packet->length)
+		pkt.hdr_first.packet_rank |= NL_LAST_PACKET;
+	do_send_fragment(hw, pkt.rawpkt, header_size + fragment_data_len);
+
+	/* If this packet has unsent data, then re-queue it. */
+	if (packet->offset < packet->length) {
+		/*
+		 * Re-queue it at the head of the highest priority queue so
+		 * it goes before all other packets
+		 */
+		unsigned long flags;
+
+		spin_lock_irqsave(&hw->spinlock, flags);
+		list_add(&packet->queue, &hw->tx_queue[0]);
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+	} else {
+		if (packet->packet_callback)
+			packet->packet_callback(packet->callback_data,
+					packet->length);
+		kfree(packet);
+	}
+
+	return 0;
+}
+
+static void ipw_setup_hardware(struct ipw_hardware *hw)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->hw_version == HW_VERSION_1) {
+		/* Reset RX FIFO */
+		outw(DCR_RXRESET, hw->base_port + IODCR);
+		/* SB: Reset TX FIFO */
+		outw(DCR_TXRESET, hw->base_port + IODCR);
+
+		/* Enable TX and RX interrupts. */
+		outw(IER_TXENABLED | IER_RXENABLED, hw->base_port + IOIER);
+	} else {
+		/*
+		 * Set INTRACK bit (bit 0), which means we must explicitly
+		 * acknowledge interrupts by clearing bit 2 of PCCSR.
+		 */
+		unsigned short csr = readw(&hw->memregs_CCR->PCCSR);
+
+		csr |= 1;
+		writew(csr, &hw->memregs_CCR->PCCSR);
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+}
+
+/*
+ * If 'packet' is NULL, then this function allocates a new packet, setting its
+ * length to 0 and ensuring it has the specified minimum amount of free space.
+ *
+ * If 'packet' is not NULL, then this function enlarges it if it doesn't
+ * have the specified minimum amount of free space.
+ *
+ */
+static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
+					   struct ipw_rx_packet *packet,
+					   int minimum_free_space)
+{
+
+	if (!packet) {
+		unsigned long flags;
+
+		/*
+		 * If this is the first fragment, then we will need to fetch a
+		 * packet to put it in.
+		 */
+		spin_lock_irqsave(&hw->spinlock, flags);
+		/* If we have one in our pool, then pull it out. */
+		if (!list_empty(&hw->rx_pool)) {
+			packet = list_first_entry(&hw->rx_pool,
+					struct ipw_rx_packet, queue);
+			list_del(&packet->queue);
+			hw->rx_pool_size--;
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+		} else {
+			/* Otherwise allocate a new one. */
+			static int min_capacity = 256;
+			int new_capacity;
+
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+			new_capacity =
+			    minimum_free_space > min_capacity
+			    ? minimum_free_space
+			    : min_capacity;
+			packet = kmalloc(sizeof(struct ipw_rx_packet)
+					+ new_capacity, GFP_ATOMIC);
+			if (!packet)
+				return NULL;
+			packet->capacity = new_capacity;
+		}
+		packet->length = 0;
+	}
+
+	/*
+	 * If this packet does not have sufficient capacity for the data we
+	 * want to add, then make it bigger.
+	 */
+	if (packet->length + minimum_free_space > packet->capacity) {
+		struct ipw_rx_packet *old_packet = packet;
+
+		packet = kmalloc(sizeof(struct ipw_rx_packet) +
+				old_packet->length + minimum_free_space,
+				GFP_ATOMIC);
+		if (!packet)
+			return NULL;
+		memcpy(packet, old_packet,
+				sizeof(struct ipw_rx_packet)
+					+ old_packet->length);
+		packet->capacity = old_packet->length + minimum_free_space;
+		kfree(old_packet);
+	}
+
+	return packet;
+}
+
+static void pool_free(struct ipw_hardware *hw, struct ipw_rx_packet *packet)
+{
+	if (hw->rx_pool_size > 6)
+		kfree(packet);
+	else {
+		hw->rx_pool_size++;
+		list_add_tail(&packet->queue, &hw->rx_pool);
+	}
+}
+
+static void queue_received_packet(struct ipw_hardware *hw,
+				  unsigned int protocol, unsigned int address,
+				  unsigned char *data, int length, int is_last)
+{
+	unsigned int channel_idx = address - 1;
+	struct ipw_rx_packet *packet = NULL;
+	unsigned long flags;
+
+	/* Discard packet if channel index is out of range. */
+	if (channel_idx >= NL_NUM_OF_ADDRESSES) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": data packet has bad address %u\n", address);
+		return;
+	}
+
+	/*
+	 * ->packet_assembler is safe to touch unlocked, this is the only place
+	 */
+	if (protocol == TL_PROTOCOLID_COM_DATA) {
+		struct ipw_rx_packet **assem =
+			&hw->packet_assembler[channel_idx];
+
+		/*
+		 * Create a new packet, or assembler already contains one
+		 * enlarge it by 'length' bytes.
+		 */
+		(*assem) = pool_allocate(hw, *assem, length);
+		if (!(*assem)) {
+			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+				": no memory for incomming data packet, dropped!\n");
+			return;
+		}
+		(*assem)->protocol = protocol;
+		(*assem)->channel_idx = channel_idx;
+
+		/* Append this packet data onto existing data. */
+		memcpy((unsigned char *)(*assem) +
+			       sizeof(struct ipw_rx_packet)
+				+ (*assem)->length, data, length);
+		(*assem)->length += length;
+		if (is_last) {
+			packet = *assem;
+			*assem = NULL;
+			/* Count queued DATA bytes only */
+			spin_lock_irqsave(&hw->spinlock, flags);
+			hw->rx_bytes_queued += packet->length;
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+		}
+	} else {
+		/* If it's a CTRL packet, don't assemble, just queue it. */
+		packet = pool_allocate(hw, NULL, length);
+		if (!packet) {
+			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+				": no memory for incomming ctrl packet, dropped!\n");
+			return;
+		}
+		packet->protocol = protocol;
+		packet->channel_idx = channel_idx;
+		memcpy((unsigned char *)packet + sizeof(struct ipw_rx_packet),
+				data, length);
+		packet->length = length;
+	}
+
+	/*
+	 * If this is the last packet, then send the assembled packet on to the
+	 * network layer.
+	 */
+	if (packet) {
+		spin_lock_irqsave(&hw->spinlock, flags);
+		list_add_tail(&packet->queue, &hw->rx_queue);
+		/* Block reception of incoming packets if queue is full. */
+		hw->blocking_rx =
+			hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE;
+
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+		schedule_work(&hw->work_rx);
+	}
+}
+
+/*
+ * Workqueue callback
+ */
+static void ipw_receive_data_work(struct work_struct *work_rx)
+{
+	struct ipw_hardware *hw =
+	    container_of(work_rx, struct ipw_hardware, work_rx);
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	while (!list_empty(&hw->rx_queue)) {
+		struct ipw_rx_packet *packet =
+			list_first_entry(&hw->rx_queue,
+					struct ipw_rx_packet, queue);
+
+		if (hw->shutting_down)
+			break;
+		list_del(&packet->queue);
+
+		/*
+		 * Note: ipwireless_network_packet_received must be called in a
+		 * process context (i.e. via schedule_work) because the tty
+		 * output code can sleep in the tty_flip_buffer_push call.
+		 */
+		if (packet->protocol == TL_PROTOCOLID_COM_DATA) {
+			if (hw->network != NULL) {
+				/* If the network hasn't been disconnected. */
+				spin_unlock_irqrestore(&hw->spinlock, flags);
+				/*
+				 * This must run unlocked due to tty processing
+				 * and mutex locking
+				 */
+				ipwireless_network_packet_received(
+						hw->network,
+						packet->channel_idx,
+						(unsigned char *)packet
+						+ sizeof(struct ipw_rx_packet),
+						packet->length);
+				spin_lock_irqsave(&hw->spinlock, flags);
+			}
+			/* Count queued DATA bytes only */
+			hw->rx_bytes_queued -= packet->length;
+		} else {
+			/*
+			 * This is safe to be called locked, callchain does
+			 * not block
+			 */
+			handle_received_CTRL_packet(hw, packet->channel_idx,
+					(unsigned char *)packet
+					+ sizeof(struct ipw_rx_packet),
+					packet->length);
+		}
+		pool_free(hw, packet);
+		/*
+		 * Unblock reception of incoming packets if queue is no longer
+		 * full.
+		 */
+		hw->blocking_rx =
+			hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE;
+		if (hw->shutting_down)
+			break;
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+}
+
+static void handle_received_CTRL_packet(struct ipw_hardware *hw,
+					unsigned int channel_idx,
+					unsigned char *data, int len)
+{
+	struct ipw_control_packet_body *body =
+		(struct ipw_control_packet_body *) data;
+	unsigned int changed_mask;
+
+	if (len != sizeof(struct ipw_control_packet_body)) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": control packet was %d bytes - wrong size!\n",
+		       len);
+		return;
+	}
+
+	switch (body->sig_no) {
+	case ComCtrl_CTS:
+		changed_mask = IPW_CONTROL_LINE_CTS;
+		break;
+	case ComCtrl_DCD:
+		changed_mask = IPW_CONTROL_LINE_DCD;
+		break;
+	case ComCtrl_DSR:
+		changed_mask = IPW_CONTROL_LINE_DSR;
+		break;
+	case ComCtrl_RI:
+		changed_mask = IPW_CONTROL_LINE_RI;
+		break;
+	default:
+		changed_mask = 0;
+	}
+
+	if (changed_mask != 0) {
+		if (body->value)
+			hw->control_lines[channel_idx] |= changed_mask;
+		else
+			hw->control_lines[channel_idx] &= ~changed_mask;
+		if (hw->network)
+			ipwireless_network_notify_control_line_change(
+					hw->network,
+					channel_idx,
+					hw->control_lines[channel_idx],
+					changed_mask);
+	}
+}
+
+static void handle_received_packet(struct ipw_hardware *hw,
+				   union nl_packet *packet,
+				   unsigned short len)
+{
+	unsigned int protocol = packet->hdr.protocol;
+	unsigned int address = packet->hdr.address;
+	unsigned int header_length;
+	unsigned char *data;
+	unsigned int data_len;
+	int is_last = packet->hdr.packet_rank & NL_LAST_PACKET;
+
+	if (packet->hdr.packet_rank & NL_FIRST_PACKET)
+		header_length = NL_FIRST_PACKET_HEADER_SIZE;
+	else
+		header_length = NL_FOLLOWING_PACKET_HEADER_SIZE;
+
+	data = packet->rawpkt + header_length;
+	data_len = len - header_length;
+	switch (protocol) {
+	case TL_PROTOCOLID_COM_DATA:
+	case TL_PROTOCOLID_COM_CTRL:
+		queue_received_packet(hw, protocol, address, data, data_len,
+				is_last);
+		break;
+	case TL_PROTOCOLID_SETUP:
+		handle_received_SETUP_packet(hw, address, data, data_len,
+				is_last);
+		break;
+	}
+}
+
+static void acknowledge_data_read(struct ipw_hardware *hw)
+{
+	if (hw->hw_version == HW_VERSION_1)
+		outw(DCR_RXDONE, hw->base_port + IODCR);
+	else
+		writew(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+}
+
+/*
+ * Retrieve a packet from the IPW hardware.
+ */
+static void do_receive_packet(struct ipw_hardware *hw)
+{
+	unsigned short len;
+	unsigned int i;
+	unsigned char pkt[LL_MTU_MAX];
+
+	start_timing();
+
+	if (hw->hw_version == HW_VERSION_1) {
+		len = inw(hw->base_port + IODRR);
+		if (len > hw->ll_mtu) {
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": received a packet of %d bytes - "
+			       "longer than the MTU!\n", (unsigned int)len);
+			outw(DCR_RXDONE | DCR_RXRESET, hw->base_port + IODCR);
+			return;
+		}
+
+		for (i = 0; i < len; i += 2) {
+			__le16 raw_data = inw(hw->base_port + IODRR);
+			unsigned short data = le16_to_cpu(raw_data);
+
+			pkt[i] = (unsigned char) data;
+			pkt[i + 1] = (unsigned char) (data >> 8);
+		}
+	} else {
+		len = inw(hw->base_port + IODMADPR);
+		if (len > hw->ll_mtu) {
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": received a packet of %d bytes - "
+			       "longer than the MTU!\n", (unsigned int)len);
+			writew(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+			return;
+		}
+
+		for (i = 0; i < len; i += 2) {
+			__le16 raw_data = inw(hw->base_port + IODMADPR);
+			unsigned short data = le16_to_cpu(raw_data);
+
+			pkt[i] = (unsigned char) data;
+			pkt[i + 1] = (unsigned char) (data >> 8);
+		}
+
+		while ((i & 3) != 2) {
+			inw(hw->base_port + IODMADPR);
+			i += 2;
+		}
+	}
+
+	acknowledge_data_read(hw);
+
+	if (ipwireless_debug)
+		dump_data_bytes("recv", pkt, len);
+
+	handle_received_packet(hw, (union nl_packet *) pkt, len);
+
+	end_read_timing(len);
+}
+
+static int get_current_packet_priority(struct ipw_hardware *hw)
+{
+	/*
+	 * If we're initializing, don't send anything of higher priority than
+	 * PRIO_SETUP.  The network layer therefore need not care about
+	 * hardware initialization - any of its stuff will simply be queued
+	 * until setup is complete.
+	 */
+	return (hw->to_setup || hw->initializing
+			? PRIO_SETUP + 1 :
+			NL_NUM_OF_PRIORITIES);
+}
+
+/*
+ * return 1 if something has been received from hw
+ */
+static int get_packets_from_hw(struct ipw_hardware *hw)
+{
+	int received = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	while (hw->rx_ready && !hw->blocking_rx) {
+		received = 1;
+		hw->rx_ready--;
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		do_receive_packet(hw);
+
+		spin_lock_irqsave(&hw->spinlock, flags);
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	return received;
+}
+
+/*
+ * Send pending packet up to given priority, prioritize SETUP data until
+ * hardware is fully setup.
+ *
+ * return 1 if more packets can be sent
+ */
+static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
+{
+	int more_to_send = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->tx_queued && hw->tx_ready != 0) {
+		int priority;
+		struct ipw_tx_packet *packet = NULL;
+
+		hw->tx_ready--;
+
+		/* Pick a packet */
+		for (priority = 0; priority < priority_limit; priority++) {
+			if (!list_empty(&hw->tx_queue[priority])) {
+				packet = list_first_entry(
+						&hw->tx_queue[priority],
+						struct ipw_tx_packet,
+						queue);
+
+				list_del(&packet->queue);
+
+				break;
+			}
+		}
+		if (!packet) {
+			hw->tx_queued = 0;
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+			return 0;
+		}
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		/* Send */
+		do_send_packet(hw, packet);
+
+		/* Check if more to send */
+		spin_lock_irqsave(&hw->spinlock, flags);
+		for (priority = 0; priority < priority_limit; priority++)
+			if (!list_empty(&hw->tx_queue[priority])) {
+				more_to_send = 1;
+				break;
+			}
+
+		if (!more_to_send)
+			hw->tx_queued = 0;
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	return more_to_send;
+}
+
+/*
+ * Send and receive all queued packets.
+ */
+static void ipwireless_do_tasklet(unsigned long hw_)
+{
+	struct ipw_hardware *hw = (struct ipw_hardware *) hw_;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->shutting_down) {
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+		return;
+	}
+
+	if (hw->to_setup == 1) {
+		/*
+		 * Initial setup data sent to hardware
+		 */
+		hw->to_setup = 2;
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		ipw_setup_hardware(hw);
+		ipw_send_setup_packet(hw);
+
+		send_pending_packet(hw, PRIO_SETUP + 1);
+		get_packets_from_hw(hw);
+	} else {
+		int priority_limit = get_current_packet_priority(hw);
+		int again;
+
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		do {
+			again = send_pending_packet(hw, priority_limit);
+			again |= get_packets_from_hw(hw);
+		} while (again);
+	}
+}
+
+/*
+ * return true if the card is physically present.
+ */
+static int is_card_present(struct ipw_hardware *hw)
+{
+	if (hw->hw_version == HW_VERSION_1)
+		return inw(hw->base_port + IOIR) != (unsigned short) 0xFFFF;
+	else
+		return readl(&hw->memory_info_regs->memreg_card_present) ==
+		    CARD_PRESENT_VALUE;
+}
+
+static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
+						  struct ipw_hardware *hw)
+{
+	unsigned short irqn;
+	unsigned short ack;
+
+	irqn = inw(hw->base_port + IOIR);
+
+	/* Check if card is present */
+	if (irqn == (unsigned short) 0xFFFF) {
+		if (++hw->bad_interrupt_count >= 100) {
+			/*
+			 * It is necessary to disable the interrupt at this
+			 * point, or the kernel hangs, interrupting repeatedly
+			 * forever.
+			 */
+			hw->irq = irq;
+			hw->removed = 1;
+			disable_irq_nosync(irq);
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+					": Mr. Fluffy is not happy!\n");
+		}
+		return IRQ_HANDLED;
+	} else if (irqn != 0) {
+		ack = 0;
+		/* Transmit complete. */
+		if (irqn & IR_TXINTR) {
+			ack |= IR_TXINTR;
+			hw->tx_ready++;
+		}
+		/* Received data */
+		if (irqn & IR_RXINTR) {
+			ack |= IR_RXINTR;
+			hw->rx_ready++;
+		}
+		if (ack != 0) {
+			outw(ack, hw->base_port + IOIR);
+			tasklet_schedule(&hw->tasklet);
+		}
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+static void acknowledge_pcmcia_interrupt(struct ipw_hardware *hw)
+{
+	unsigned short csr = readw(&hw->memregs_CCR->PCCSR);
+
+	csr &= 0xfffd;
+	writew(csr, &hw->memregs_CCR->PCCSR);
+}
+
+static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
+						     struct ipw_hardware *hw)
+{
+	int tx = 0;
+	int rx = 0;
+	int rx_repeat = 0;
+	int try_mem_tx_old;
+
+	do {
+
+	unsigned short memtx = readw(hw->memreg_tx);
+	unsigned short memtx_serial;
+	unsigned short memrxdone =
+		readw(&hw->memory_info_regs->memreg_rx_done);
+
+	try_mem_tx_old = 0;
+
+	/* check whether the interrupt was generated by ipwireless card */
+	if (!(memtx & MEMTX_TX) && !(memrxdone & MEMRX_RX_DONE)) {
+
+		/* check if the card uses memreg_tx_old register */
+		if (hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+			memtx = readw(&hw->memory_info_regs->memreg_tx_old);
+			if (memtx & MEMTX_TX) {
+				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+					": Using memreg_tx_old\n");
+				hw->memreg_tx =
+					&hw->memory_info_regs->memreg_tx_old;
+			} else {
+				return IRQ_NONE;
+			}
+		} else {
+			return IRQ_NONE;
+		}
+	}
+
+	/*
+	 * See if the card is physically present. Note that while it is
+	 * powering up, it appears not to be present.
+	 */
+	if (!is_card_present(hw)) {
+		acknowledge_pcmcia_interrupt(hw);
+		return IRQ_HANDLED;
+	}
+
+	memtx_serial = memtx & (unsigned short) 0xff00;
+	if (memtx & MEMTX_TX) {
+		writew(memtx_serial, hw->memreg_tx);
+
+		if (hw->serial_number_detected) {
+			if (memtx_serial != hw->last_memtx_serial) {
+				hw->last_memtx_serial = memtx_serial;
+				hw->rx_ready++;
+				rx = 1;
+			} else
+				/* Ignore 'Timer Recovery' duplicates. */
+				rx_repeat = 1;
+		} else {
+			/*
+			 * If a non-zero serial number is seen, then enable
+			 * serial number checking.
+			 */
+			if (memtx_serial != 0)
+				hw->serial_number_detected = 1;
+				printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+					": memreg_tx serial num detected\n");
+
+			hw->rx_ready++;
+			rx = 1;
+		}
+	}
+	if (memrxdone & MEMRX_RX_DONE) {
+		writew(0, &hw->memory_info_regs->memreg_rx_done);
+		hw->tx_ready++;
+		tx = 1;
+	}
+	if (tx)
+		writew(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+
+	acknowledge_pcmcia_interrupt(hw);
+
+	if (tx || rx)
+		tasklet_schedule(&hw->tasklet);
+	else if (!rx_repeat) {
+		if (hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+			if (hw->serial_number_detected)
+				printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": spurious interrupt - new_tx mode\n");
+			else {
+				printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": no valid memreg_tx value - "
+					"switching to the old memreg_tx\n");
+				hw->memreg_tx =
+					&hw->memory_info_regs->memreg_tx_old;
+				try_mem_tx_old = 1;
+			}
+		} else
+			printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": spurious interrupt - old_tx mode\n");
+	}
+
+	} while (try_mem_tx_old == 1);
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+{
+	struct ipw_hardware *hw = dev_id;
+
+	if (hw->hw_version == HW_VERSION_1)
+		return ipwireless_handle_v1_interrupt(irq, hw);
+	else
+		return ipwireless_handle_v2_v3_interrupt(irq, hw);
+}
+
+static void flush_packets_to_hw(struct ipw_hardware *hw)
+{
+	int priority_limit;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	priority_limit = get_current_packet_priority(hw);
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	while (send_pending_packet(hw, priority_limit));
+}
+
+static void send_packet(struct ipw_hardware *hw, int priority,
+			struct ipw_tx_packet *packet)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	list_add_tail(&packet->queue, &hw->tx_queue[priority]);
+	hw->tx_queued = 1;
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	flush_packets_to_hw(hw);
+}
+
+/* Create data packet, non-atomic allocation */
+static void *alloc_data_packet(int data_size,
+				unsigned char dest_addr,
+				unsigned char protocol)
+{
+	struct ipw_tx_packet *packet = kzalloc(
+			sizeof(struct ipw_tx_packet) + data_size,
+			GFP_ATOMIC);
+
+	if (!packet)
+		return NULL;
+
+	INIT_LIST_HEAD(&packet->queue);
+	packet->dest_addr = dest_addr;
+	packet->protocol = protocol;
+	packet->length = data_size;
+
+	return packet;
+}
+
+static void *alloc_ctrl_packet(int header_size,
+			       unsigned char dest_addr,
+			       unsigned char protocol,
+			       unsigned char sig_no)
+{
+	/*
+	 * sig_no is located right after ipw_tx_packet struct in every
+	 * CTRL or SETUP packets, we can use ipw_control_packet as a
+	 * common struct
+	 */
+	struct ipw_control_packet *packet = kzalloc(header_size, GFP_ATOMIC);
+
+	if (!packet)
+		return NULL;
+
+	INIT_LIST_HEAD(&packet->header.queue);
+	packet->header.dest_addr = dest_addr;
+	packet->header.protocol = protocol;
+	packet->header.length = header_size - sizeof(struct ipw_tx_packet);
+	packet->body.sig_no = sig_no;
+
+	return packet;
+}
+
+int ipwireless_send_packet(struct ipw_hardware *hw, unsigned int channel_idx,
+			    unsigned char *data, unsigned int length,
+			    void (*callback) (void *cb, unsigned int length),
+			    void *callback_data)
+{
+	struct ipw_tx_packet *packet;
+
+	packet = alloc_data_packet(length,
+			       (unsigned char) (channel_idx + 1),
+			       TL_PROTOCOLID_COM_DATA);
+	if (!packet)
+		return -1;
+	packet->packet_callback = callback;
+	packet->callback_data = callback_data;
+	memcpy((unsigned char *) packet +
+			sizeof(struct ipw_tx_packet), data, length);
+
+	send_packet(hw, PRIO_DATA, packet);
+	return 0;
+}
+
+static int set_control_line(struct ipw_hardware *hw, int prio,
+			   unsigned int channel_idx, int line, int state)
+{
+	struct ipw_control_packet *packet;
+	int protocolid = TL_PROTOCOLID_COM_CTRL;
+
+	if (prio == PRIO_SETUP)
+		protocolid = TL_PROTOCOLID_SETUP;
+
+	packet = alloc_ctrl_packet(sizeof(struct ipw_control_packet),
+			(unsigned char) (channel_idx + 1),
+			protocolid, line);
+	if (!packet)
+		return -1;
+	packet->header.length = sizeof(struct ipw_control_packet_body);
+	packet->body.value = (unsigned char) (state == 0 ? 0 : 1);
+	send_packet(hw, prio, &packet->header);
+	return 0;
+}
+
+
+static int set_DTR(struct ipw_hardware *hw, int priority,
+		   unsigned int channel_idx, int state)
+{
+	if (state != 0)
+		hw->control_lines[channel_idx] |= IPW_CONTROL_LINE_DTR;
+	else
+		hw->control_lines[channel_idx] &= ~IPW_CONTROL_LINE_DTR;
+
+	return set_control_line(hw, priority, channel_idx, ComCtrl_DTR, state);
+}
+
+static int set_RTS(struct ipw_hardware *hw, int priority,
+		   unsigned int channel_idx, int state)
+{
+	if (state != 0)
+		hw->control_lines[channel_idx] |= IPW_CONTROL_LINE_RTS;
+	else
+		hw->control_lines[channel_idx] &= ~IPW_CONTROL_LINE_RTS;
+
+	return set_control_line(hw, priority, channel_idx, ComCtrl_RTS, state);
+}
+
+int ipwireless_set_DTR(struct ipw_hardware *hw, unsigned int channel_idx,
+		       int state)
+{
+	return set_DTR(hw, PRIO_CTRL, channel_idx, state);
+}
+
+int ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,
+		       int state)
+{
+	return set_RTS(hw, PRIO_CTRL, channel_idx, state);
+}
+
+struct ipw_setup_get_version_query_packet {
+	struct ipw_tx_packet header;
+	struct TlSetupGetVersionQry body;
+};
+
+struct ipw_setup_config_packet {
+	struct ipw_tx_packet header;
+	struct TlSetupConfigMsg body;
+};
+
+struct ipw_setup_config_done_packet {
+	struct ipw_tx_packet header;
+	struct TlSetupConfigDoneMsg body;
+};
+
+struct ipw_setup_open_packet {
+	struct ipw_tx_packet header;
+	struct TlSetupOpenMsg body;
+};
+
+struct ipw_setup_info_packet {
+	struct ipw_tx_packet header;
+	struct TlSetupInfoMsg body;
+};
+
+struct ipw_setup_reboot_msg_ack {
+	struct ipw_tx_packet header;
+	struct TlSetupRebootMsgAck body;
+};
+
+/* This handles the actual initialization of the card */
+static void __handle_setup_get_version_rsp(struct ipw_hardware *hw)
+{
+	struct ipw_setup_config_packet *config_packet;
+	struct ipw_setup_config_done_packet *config_done_packet;
+	struct ipw_setup_open_packet *open_packet;
+	struct ipw_setup_info_packet *info_packet;
+	int port;
+	unsigned int channel_idx;
+
+	/* generate config packet */
+	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
+		config_packet = alloc_ctrl_packet(
+				sizeof(struct ipw_setup_config_packet),
+				ADDR_SETUP_PROT,
+				TL_PROTOCOLID_SETUP,
+				TL_SETUP_SIGNO_CONFIG_MSG);
+		if (!config_packet)
+			goto exit_nomem;
+		config_packet->header.length = sizeof(struct TlSetupConfigMsg);
+		config_packet->body.port_no = port;
+		config_packet->body.prio_data = PRIO_DATA;
+		config_packet->body.prio_ctrl = PRIO_CTRL;
+		send_packet(hw, PRIO_SETUP, &config_packet->header);
+	}
+	config_done_packet = alloc_ctrl_packet(
+			sizeof(struct ipw_setup_config_done_packet),
+			ADDR_SETUP_PROT,
+			TL_PROTOCOLID_SETUP,
+			TL_SETUP_SIGNO_CONFIG_DONE_MSG);
+	if (!config_done_packet)
+		goto exit_nomem;
+	config_done_packet->header.length = sizeof(struct TlSetupConfigDoneMsg);
+	send_packet(hw, PRIO_SETUP, &config_done_packet->header);
+
+	/* generate open packet */
+	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
+		open_packet = alloc_ctrl_packet(
+				sizeof(struct ipw_setup_open_packet),
+				ADDR_SETUP_PROT,
+				TL_PROTOCOLID_SETUP,
+				TL_SETUP_SIGNO_OPEN_MSG);
+		if (!open_packet)
+			goto exit_nomem;
+		open_packet->header.length = sizeof(struct TlSetupOpenMsg);
+		open_packet->body.port_no = port;
+		send_packet(hw, PRIO_SETUP, &open_packet->header);
+	}
+	for (channel_idx = 0;
+			channel_idx < NL_NUM_OF_ADDRESSES; channel_idx++) {
+		int ret;
+
+		ret = set_DTR(hw, PRIO_SETUP, channel_idx,
+			(hw->control_lines[channel_idx] &
+			 IPW_CONTROL_LINE_DTR) != 0);
+		if (ret) {
+			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+					": error setting DTR (%d)\n", ret);
+			return;
+		}
+
+		set_RTS(hw, PRIO_SETUP, channel_idx,
+			(hw->control_lines [channel_idx] &
+			 IPW_CONTROL_LINE_RTS) != 0);
+		if (ret) {
+			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+					": error setting RTS (%d)\n", ret);
+			return;
+		}
+	}
+	/*
+	 * For NDIS we assume that we are using sync PPP frames, for COM async.
+	 * This driver uses NDIS mode too. We don't bother with translation
+	 * from async -> sync PPP.
+	 */
+	info_packet = alloc_ctrl_packet(sizeof(struct ipw_setup_info_packet),
+			ADDR_SETUP_PROT,
+			TL_PROTOCOLID_SETUP,
+			TL_SETUP_SIGNO_INFO_MSG);
+	if (!info_packet)
+		goto exit_nomem;
+	info_packet->header.length = sizeof(struct TlSetupInfoMsg);
+	info_packet->body.driver_type = NDISWAN_DRIVER;
+	info_packet->body.major_version = NDISWAN_DRIVER_MAJOR_VERSION;
+	info_packet->body.minor_version = NDISWAN_DRIVER_MINOR_VERSION;
+	send_packet(hw, PRIO_SETUP, &info_packet->header);
+
+	/* Initialization is now complete, so we clear the 'to_setup' flag */
+	hw->to_setup = 0;
+
+	return;
+
+exit_nomem:
+	printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+			": not enough memory to alloc control packet\n");
+	hw->to_setup = -1;
+}
+
+static void handle_setup_get_version_rsp(struct ipw_hardware *hw,
+		unsigned char vers_no)
+{
+	del_timer(&hw->setup_timer);
+	hw->initializing = 0;
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": card is ready.\n");
+
+	if (vers_no == TL_SETUP_VERSION)
+		__handle_setup_get_version_rsp(hw);
+	else
+		printk(KERN_ERR
+				IPWIRELESS_PCCARD_NAME
+				": invalid hardware version no %u\n",
+				(unsigned int) vers_no);
+}
+
+static void ipw_send_setup_packet(struct ipw_hardware *hw)
+{
+	struct ipw_setup_get_version_query_packet *ver_packet;
+
+	ver_packet = alloc_ctrl_packet(
+			sizeof(struct ipw_setup_get_version_query_packet),
+			ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP,
+			TL_SETUP_SIGNO_GET_VERSION_QRY);
+	ver_packet->header.length = sizeof(struct TlSetupGetVersionQry);
+
+	/*
+	 * Response is handled in handle_received_SETUP_packet
+	 */
+	send_packet(hw, PRIO_SETUP, &ver_packet->header);
+}
+
+static void handle_received_SETUP_packet(struct ipw_hardware *hw,
+					 unsigned int address,
+					 unsigned char *data, int len,
+					 int is_last)
+{
+	union ipw_setup_rx_msg *rx_msg = (union ipw_setup_rx_msg *) data;
+
+	if (address != ADDR_SETUP_PROT) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": setup packet has bad address %d\n", address);
+		return;
+	}
+
+	switch (rx_msg->sig_no) {
+	case TL_SETUP_SIGNO_GET_VERSION_RSP:
+		if (hw->to_setup)
+			handle_setup_get_version_rsp(hw,
+					rx_msg->VersRspMsg.version);
+		break;
+
+	case TL_SETUP_SIGNO_OPEN_MSG:
+		if (ipwireless_debug) {
+			unsigned int channel_idx = rx_msg->OpenMsg.port_no - 1;
+
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": OPEN_MSG [channel %u] reply received\n",
+			       channel_idx);
+		}
+		break;
+
+	case TL_SETUP_SIGNO_INFO_MSG_ACK:
+		if (ipwireless_debug)
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": card successfully configured as NDISWAN\n");
+		break;
+
+	case TL_SETUP_SIGNO_REBOOT_MSG:
+		if (hw->to_setup)
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": Setup not completed - ignoring reboot msg\n");
+		else {
+			struct ipw_setup_reboot_msg_ack *packet;
+
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": Acknowledging REBOOT message\n");
+			packet = alloc_ctrl_packet(
+					sizeof(struct ipw_setup_reboot_msg_ack),
+					ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP,
+					TL_SETUP_SIGNO_REBOOT_MSG_ACK);
+			packet->header.length =
+				sizeof(struct TlSetupRebootMsgAck);
+			send_packet(hw, PRIO_SETUP, &packet->header);
+			if (hw->reboot_callback)
+				hw->reboot_callback(hw->reboot_callback_data);
+		}
+		break;
+
+	default:
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": unknown setup message %u received\n",
+		       (unsigned int) rx_msg->sig_no);
+	}
+}
+
+static void do_close_hardware(struct ipw_hardware *hw)
+{
+	unsigned int irqn;
+
+	if (hw->hw_version == HW_VERSION_1) {
+		/* Disable TX and RX interrupts. */
+		outw(0, hw->base_port + IOIER);
+
+		/* Acknowledge any outstanding interrupt requests */
+		irqn = inw(hw->base_port + IOIR);
+		if (irqn & IR_TXINTR)
+			outw(IR_TXINTR, hw->base_port + IOIR);
+		if (irqn & IR_RXINTR)
+			outw(IR_RXINTR, hw->base_port + IOIR);
+
+		synchronize_irq(hw->irq);
+	}
+}
+
+struct ipw_hardware *ipwireless_hardware_create(void)
+{
+	int i;
+	struct ipw_hardware *hw =
+		kzalloc(sizeof(struct ipw_hardware), GFP_KERNEL);
+
+	if (!hw)
+		return NULL;
+
+	hw->irq = -1;
+	hw->initializing = 1;
+	hw->tx_ready = 1;
+	hw->rx_bytes_queued = 0;
+	hw->rx_pool_size = 0;
+	hw->last_memtx_serial = (unsigned short) 0xffff;
+	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
+		INIT_LIST_HEAD(&hw->tx_queue[i]);
+
+	INIT_LIST_HEAD(&hw->rx_queue);
+	INIT_LIST_HEAD(&hw->rx_pool);
+	spin_lock_init(&hw->spinlock);
+	tasklet_init(&hw->tasklet, ipwireless_do_tasklet, (unsigned long) hw);
+	INIT_WORK(&hw->work_rx, ipw_receive_data_work);
+	setup_timer(&hw->setup_timer, ipwireless_setup_timer,
+			(unsigned long) hw);
+
+	return hw;
+}
+
+void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
+		unsigned int base_port,
+		void __iomem *attr_memory,
+		void __iomem *common_memory,
+		int is_v2_card,
+		void (*reboot_callback) (void *data),
+		void *reboot_callback_data)
+{
+	hw->bad_interrupt_count = 0;
+	if (hw->removed) {
+		hw->removed = 0;
+		enable_irq(hw->irq);
+	}
+	hw->base_port = base_port;
+	hw->hw_version = is_v2_card ? HW_VERSION_2 : HW_VERSION_1;
+	hw->ll_mtu = hw->hw_version == HW_VERSION_1 ? LL_MTU_V1 : LL_MTU_V2;
+	hw->memregs_CCR = (struct MEMCCR __iomem *)
+			((unsigned short __iomem *) attr_memory + 0x200);
+	hw->memory_info_regs = (struct MEMINFREG __iomem *) common_memory;
+	hw->memreg_tx = &hw->memory_info_regs->memreg_tx_new;
+	hw->reboot_callback = reboot_callback;
+	hw->reboot_callback_data = reboot_callback_data;
+}
+
+void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw)
+{
+	hw->initializing = 1;
+	hw->init_loops = 0;
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": waiting for card to start up...\n");
+	ipwireless_setup_timer((unsigned long) hw);
+}
+
+static void ipwireless_setup_timer(unsigned long data)
+{
+	struct ipw_hardware *hw = (struct ipw_hardware *) data;
+
+	hw->init_loops++;
+
+	if (hw->init_loops == TL_SETUP_MAX_VERSION_QRY &&
+			hw->hw_version == HW_VERSION_2 &&
+			hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				": failed to startup using TX2, trying TX\n");
+
+		hw->memreg_tx = &hw->memory_info_regs->memreg_tx_old;
+		hw->init_loops = 0;
+	}
+	/* Give up after a certain number of retries */
+	if (hw->init_loops == TL_SETUP_MAX_VERSION_QRY) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": card failed to start up!\n");
+		hw->initializing = 0;
+	} else {
+		/* Do not attempt to write to the board if it is not present. */
+		if (is_card_present(hw)) {
+			hw->to_setup = 1;
+			hw->tx_ready = 1;
+			tasklet_schedule(&hw->tasklet);
+		}
+
+		mod_timer(&hw->setup_timer,
+			jiffies + msecs_to_jiffies(TL_SETUP_VERSION_QRY_TMO));
+	}
+}
+
+/*
+ * Stop any interrupts from executing so that, once this function returns,
+ * other layers of the driver can be sure they won't get any more callbacks.
+ * Thus must be called on a proper process context.
+ */
+void ipwireless_stop_interrupts(struct ipw_hardware *hw)
+{
+	if (!hw->shutting_down) {
+		/* Tell everyone we are going down. */
+		hw->shutting_down = 1;
+		del_timer(&hw->setup_timer);
+
+		/* Prevent the hardware from sending any more interrupts */
+		do_close_hardware(hw);
+	}
+}
+
+void ipwireless_hardware_free(struct ipw_hardware *hw)
+{
+	int i;
+	struct ipw_rx_packet *rp, *rq;
+	struct ipw_tx_packet *tp, *tq;
+
+	ipwireless_stop_interrupts(hw);
+
+	flush_scheduled_work();
+
+	for (i = 0; i < NL_NUM_OF_ADDRESSES; i++)
+		if (hw->packet_assembler[i] != NULL)
+			kfree(hw->packet_assembler[i]);
+
+	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
+		list_for_each_entry_safe(tp, tq, &hw->tx_queue[i], queue) {
+			list_del(&tp->queue);
+			kfree(tp);
+		}
+
+	list_for_each_entry_safe(rp, rq, &hw->rx_queue, queue) {
+		list_del(&rp->queue);
+		kfree(rp);
+	}
+
+	list_for_each_entry_safe(rp, rq, &hw->rx_pool, queue) {
+		list_del(&rp->queue);
+		kfree(rp);
+	}
+	kfree(hw);
+}
+
+/*
+ * Associate the specified network with this hardware, so it will receive events
+ * from it.
+ */
+void ipwireless_associate_network(struct ipw_hardware *hw,
+				  struct ipw_network *network)
+{
+	hw->network = network;
+}
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/char/pcmcia/ipwireless/hardware.h
new file mode 100644
index 0000000..c83190f
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/hardware.h
@@ -0,0 +1,64 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_HARDWARE_H_
+#define _IPWIRELESS_CS_HARDWARE_H_
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+
+#define IPW_CONTROL_LINE_CTS 0x0001
+#define IPW_CONTROL_LINE_DCD 0x0002
+#define IPW_CONTROL_LINE_DSR 0x0004
+#define IPW_CONTROL_LINE_RI  0x0008
+#define IPW_CONTROL_LINE_DTR 0x0010
+#define IPW_CONTROL_LINE_RTS 0x0020
+
+struct ipw_hardware;
+struct ipw_network;
+
+struct ipw_hardware *ipwireless_hardware_create(void);
+void ipwireless_hardware_free(struct ipw_hardware *hw);
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs);
+int ipwireless_set_DTR(struct ipw_hardware *hw, unsigned int channel_idx,
+		int state);
+int ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,
+		int state);
+int ipwireless_send_packet(struct ipw_hardware *hw,
+			    unsigned int channel_idx,
+			    unsigned char *data,
+			    unsigned int length,
+			    void (*packet_sent_callback) (void *cb,
+							  unsigned int length),
+			    void *sent_cb_data);
+void ipwireless_associate_network(struct ipw_hardware *hw,
+		struct ipw_network *net);
+void ipwireless_stop_interrupts(struct ipw_hardware *hw);
+void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
+				 unsigned int base_port,
+				 void __iomem *attr_memory,
+				 void __iomem *common_memory,
+				 int is_v2_card,
+				 void (*reboot_cb) (void *data),
+				 void *reboot_cb_data);
+void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw);
+void ipwireless_sleep(unsigned int tenths);
+int ipwireless_dump_hardware_state(char *p, size_t limit,
+				   struct ipw_hardware *hw);
+
+#endif
diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
new file mode 100644
index 0000000..1bb3f2b
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/main.c
@@ -0,0 +1,500 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include "hardware.h"
+#include "network.h"
+#include "main.h"
+#include "tty.h"
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <pcmcia/version.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/device_id.h>
+#include <pcmcia/ss.h>
+#include <pcmcia/ds.h>
+#include <pcmcia/cs.h>
+
+static struct pcmcia_device_id ipw_ids[] = {
+	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0100),
+	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0200),
+	PCMCIA_DEVICE_NULL
+};
+MODULE_DEVICE_TABLE(pcmcia, ipw_ids);
+
+static void ipwireless_detach(struct pcmcia_device *link);
+
+/*
+ * Module params
+ */
+/* Debug mode: more verbose, print sent/recv bytes */
+int ipwireless_debug;
+int ipwireless_loopback;
+int ipwireless_out_queue = 1;
+static int tty_major;
+
+module_param(tty_major, int, 0);
+module_param_named(debug, ipwireless_debug, int, 0);
+module_param_named(loopback, ipwireless_loopback, int, 0);
+module_param_named(out_queue, ipwireless_out_queue, int, 0);
+MODULE_PARM_DESC(tty_major, "ttyIPWp major number [0]");
+MODULE_PARM_DESC(debug, "switch on debug messages [0]");
+MODULE_PARM_DESC(loopback,
+		"debug: enable ras_raw channel [0]");
+MODULE_PARM_DESC(out_queue, "debug: set size of outgoing queue [1]");
+
+static const char drv_name[] = IPWIRELESS_PCCARD_NAME;
+
+/* Executes in process context. */
+static void signalled_reboot_work(struct work_struct *work_reboot)
+{
+	struct ipw_dev *ipw = container_of(work_reboot, struct ipw_dev,
+			work_reboot);
+	struct pcmcia_device *link = ipw->link;
+	int ret = pccard_reset_card(link->socket);
+
+	if (ret != CS_SUCCESS)
+		cs_error(link, ResetCard, ret);
+}
+
+static void signalled_reboot_callback(void *callback_data)
+{
+	struct ipw_dev *ipw = (struct ipw_dev *) callback_data;
+
+	/* Delegate to process context. */
+	schedule_work(&ipw->work_reboot);
+}
+
+static int config_ipwireless(struct ipw_dev *ipw)
+{
+	struct pcmcia_device *link = ipw->link;
+	int ret;
+	config_info_t conf;
+	tuple_t tuple;
+	unsigned short buf[64];
+	cisparse_t parse;
+	unsigned short cor_value;
+	win_req_t reqAM;
+	win_req_t reqCM;
+	memreq_t memAM;
+	memreq_t memCM;
+
+	ipw->isV2Card = 0;
+
+	tuple.Attributes = 0;
+	tuple.TupleData = (cisdata_t *) buf;
+	tuple.TupleDataMax = sizeof(buf);
+	tuple.TupleOffset = 0;
+
+	tuple.DesiredTuple = RETURN_FIRST_TUPLE;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	while (ret == 0) {
+		ret = pcmcia_get_tuple_data(link, &tuple);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, GetTupleData, ret);
+			goto exit0;
+		}
+		ret = pcmcia_get_next_tuple(link, &tuple);
+	}
+
+	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, ParseTuple, ret);
+		goto exit0;
+	}
+
+	link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
+	link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
+	link->io.NumPorts1 = parse.cftable_entry.io.win[0].len;
+	link->io.IOAddrLines = 16;
+
+	link->irq.IRQInfo1 = parse.cftable_entry.irq.IRQInfo1;
+
+	/* 0x40 causes it to generate level mode interrupts. */
+	/* 0x04 enables IREQ pin. */
+	cor_value = parse.cftable_entry.index | 0x44;
+	link->conf.ConfigIndex = cor_value;
+
+	/* IRQ and I/O settings */
+	tuple.DesiredTuple = CISTPL_CONFIG;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+	link->conf.Attributes = CONF_ENABLE_IRQ;
+	link->conf.ConfigBase = parse.config.base;
+	link->conf.Present = parse.config.rmask[0];
+	link->conf.IntType = INT_MEMORY_AND_IO;
+
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
+	link->irq.Handler = ipwireless_interrupt;
+	link->irq.Instance = ipw->hardware;
+
+	ret = pcmcia_request_io(link, &link->io);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestIO, ret);
+		goto exit0;
+	}
+
+	/* memory settings */
+
+	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit1;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit1;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, ParseTuple, ret);
+		goto exit1;
+	}
+
+	if (parse.cftable_entry.mem.nwin > 0) {
+		reqCM.Attributes =
+			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_CM | WIN_ENABLE;
+		reqCM.Base = parse.cftable_entry.mem.win[0].host_addr;
+		reqCM.Size = parse.cftable_entry.mem.win[0].len;
+		if (reqCM.Size < 0x1000)
+			reqCM.Size = 0x1000;
+		reqCM.AccessSpeed = 0;
+
+		ret = pcmcia_request_window(&link, &reqCM, &ipw->handleCM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, RequestWindow, ret);
+			goto exit1;
+		}
+
+		memCM.CardOffset = parse.cftable_entry.mem.win[0].card_addr;
+		memCM.Page = 0;
+
+		ret = pcmcia_map_mem_page(ipw->handleCM, &memCM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, MapMemPage, ret);
+			goto exit1;
+		}
+
+		ipw->isV2Card =
+			parse.cftable_entry.mem.win[0].len == 0x100;
+
+		ipw->commonMemory = ioremap(reqCM.Base, reqCM.Size);
+
+		reqAM.Attributes =
+			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_AM | WIN_ENABLE;
+		reqAM.Base = 0;
+		reqAM.Size = 0;	/* this used to be 0x1000 */
+		reqAM.AccessSpeed = 0;
+
+		ret = pcmcia_request_window(&link, &reqAM, &ipw->handleAM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, RequestWindow, ret);
+			goto exit2;
+		}
+
+		memAM.CardOffset = 0;
+		memAM.Page = 0;
+
+		ret = pcmcia_map_mem_page(ipw->handleAM, &memAM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, MapMemPage, ret);
+			goto exit2;
+		}
+
+		ipw->attrMemory = ioremap(reqAM.Base, reqAM.Size);
+	}
+
+	INIT_WORK(&ipw->work_reboot, signalled_reboot_work);
+
+	ipwireless_init_hardware_v1(ipw->hardware, link->io.BasePort1,
+				    ipw->attrMemory, ipw->commonMemory,
+				    ipw->isV2Card, signalled_reboot_callback,
+				    ipw);
+
+	ret = pcmcia_request_irq(link, &link->irq);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestIRQ, ret);
+		goto exit3;
+	}
+
+	/* Look up current Vcc */
+
+	ret = pcmcia_get_configuration_info(link, &conf);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetConfigurationInfo, ret);
+		goto exit4;
+	}
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": Card type %s\n",
+			ipw->isV2Card ? "V2/V3" : "V1");
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			": I/O ports 0x%04x-0x%04x, irq %d\n",
+			(unsigned int) link->io.BasePort1,
+			(unsigned int) (link->io.BasePort1 +
+				link->io.NumPorts1 - 1),
+			(unsigned int) link->irq.AssignedIRQ);
+	if (ipw->attrMemory && ipw->commonMemory)
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				": attr memory 0x%08lx-0x%08lx, "
+				"common memory 0x%08lx-0x%08lx\n",
+				(unsigned long)reqAM.Base,
+				(unsigned long)reqAM.Base +
+					(unsigned long)reqAM.Size -
+					(unsigned long) 1,
+				(unsigned long)reqCM.Base,
+				(unsigned long)reqCM.Base +
+					(unsigned long)reqCM.Size -
+					(unsigned long) 1);
+
+	ipw->network = ipwireless_network_create(ipw->hardware);
+	if (!ipw->network)
+		goto exit3;
+
+	ipw->tty = ipwireless_tty_create(ipw->hardware, ipw->network,
+			ipw->nodes);
+	if (!ipw->tty)
+		goto exit3;
+
+	ipwireless_init_hardware_v2_v3(ipw->hardware);
+
+	/*
+	 * Do the RequestConfiguration last, because it enables interrupts.
+	 * Then we don't get any interrupts before we're ready for them.
+	 */
+	ret = pcmcia_request_configuration(link, &link->conf);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestConfiguration, ret);
+		goto exit4;
+	}
+
+	link->dev_node = &ipw->nodes[0];
+
+	return 0;
+
+exit4:
+	pcmcia_disable_device(link);
+exit3:
+	if (ipw->attrMemory) {
+		iounmap(ipw->attrMemory);
+		pcmcia_release_window(ipw->handleAM);
+		pcmcia_disable_device(link);
+	}
+exit2:
+	if (ipw->commonMemory) {
+		iounmap(ipw->commonMemory);
+		pcmcia_release_window(ipw->handleCM);
+	}
+exit1:
+	pcmcia_disable_device(link);
+exit0:
+	return -1;
+}
+
+static void release_ipwireless(struct ipw_dev *ipw)
+{
+	struct pcmcia_device *link = ipw->link;
+
+	pcmcia_disable_device(link);
+
+	if (ipw->commonMemory)
+		iounmap(ipw->commonMemory);
+	if (ipw->attrMemory)
+		iounmap(ipw->attrMemory);
+	if (ipw->commonMemory)
+		pcmcia_release_window(ipw->handleCM);
+	if (ipw->attrMemory)
+		pcmcia_release_window(ipw->handleAM);
+	pcmcia_disable_device(link);
+}
+
+/*
+ * ipwireless_attach() creates an "instance" of the driver, allocating
+ * local data structures for one device (one interface).  The device
+ * is registered with Card Services.
+ *
+ * The pcmcia_device structure is initialized, but we don't actually
+ * configure the card at this point -- we wait until we receive a
+ * card insertion event.
+ */
+static int ipwireless_attach(struct pcmcia_device *link)
+{
+	struct ipw_dev *ipw;
+	int ret;
+
+	ipw = kzalloc(sizeof(struct ipw_dev), GFP_KERNEL);
+	if (!ipw)
+		return -ENOMEM;
+
+	ipw->link = link;
+	link->priv = ipw;
+	link->irq.Instance = ipw;
+
+	/* Link this device into our device list. */
+	link->dev_node = &ipw->nodes[0];
+
+	ipw->hardware = ipwireless_hardware_create();
+	if (!ipw->hardware) {
+		kfree(ipw);
+		return -ENOMEM;
+	}
+	/* RegisterClient will call config_ipwireless */
+
+	ret = config_ipwireless(ipw);
+
+	if (ret != 0) {
+		cs_error(link, RegisterClient, ret);
+		ipwireless_detach(link);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * This deletes a driver "instance".  The device is de-registered with
+ * Card Services.  If it has been released, all local data structures
+ * are freed.  Otherwise, the structures will be freed when the device
+ * is released.
+ */
+static void ipwireless_detach(struct pcmcia_device *link)
+{
+	struct ipw_dev *ipw = link->priv;
+
+	release_ipwireless(ipw);
+
+	/* Break the link with Card Services */
+	if (link)
+		pcmcia_disable_device(link);
+
+	if (ipw->tty != NULL)
+		ipwireless_tty_free(ipw->tty);
+	if (ipw->network != NULL)
+		ipwireless_network_free(ipw->network);
+	if (ipw->hardware != NULL)
+		ipwireless_hardware_free(ipw->hardware);
+	kfree(ipw);
+}
+
+static struct pcmcia_driver me = {
+	.owner		= THIS_MODULE,
+	.probe          = ipwireless_attach,
+	.remove         = ipwireless_detach,
+	.drv = { .name  = drv_name },
+	.id_table       = ipw_ids
+};
+
+/*
+ * Module insertion : initialisation of the module.
+ * Register the card with cardmgr...
+ */
+static int __init init_ipwireless(void)
+{
+	int ret;
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME " "
+	       IPWIRELESS_PCMCIA_VERSION " by " IPWIRELESS_PCMCIA_AUTHOR "\n");
+
+	ret = ipwireless_tty_init(tty_major);
+	if (ret != 0)
+		return ret;
+
+	ret = pcmcia_register_driver(&me);
+	if (ret != 0)
+		ipwireless_tty_release();
+
+	return ret;
+}
+
+/*
+ * Module removal
+ */
+static void __exit exit_ipwireless(void)
+{
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME " "
+			IPWIRELESS_PCMCIA_VERSION " removed\n");
+
+	pcmcia_unregister_driver(&me);
+	ipwireless_tty_release();
+}
+
+module_init(init_ipwireless);
+module_exit(exit_ipwireless);
+
+MODULE_AUTHOR(IPWIRELESS_PCMCIA_AUTHOR);
+MODULE_DESCRIPTION(IPWIRELESS_PCCARD_NAME " " IPWIRELESS_PCMCIA_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/pcmcia/ipwireless/main.h b/drivers/char/pcmcia/ipwireless/main.h
new file mode 100644
index 0000000..17de305
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/main.h
@@ -0,0 +1,70 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_H_
+#define _IPWIRELESS_CS_H_
+
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+
+#include "hardware.h"
+
+#define IPWIRELESS_PCCARD_NAME		"ipwireless"
+#define IPWIRELESS_PCMCIA_VERSION	"1.1"
+#define IPWIRELESS_PCMCIA_AUTHOR        \
+	"Stephen Blackheath, Ben Martel, Jiri Kosina and David Sterba"
+
+#define IPWIRELESS_TX_QUEUE_SIZE  262144
+#define IPWIRELESS_RX_QUEUE_SIZE  262144
+
+#define IPWIRELESS_STATE_DEBUG
+
+struct ipw_hardware;
+struct ipw_network;
+struct ipw_tty;
+
+struct ipw_dev {
+	struct pcmcia_device *link;
+	int isV2Card;
+	window_handle_t handleAM;
+	void __iomem *attrMemory;
+	window_handle_t handleCM;
+	void __iomem *commonMemory;
+	dev_node_t nodes[2];
+	/* Reference to attribute memory, containing CIS data */
+	void *attribute_memory;
+
+	/* Hardware context */
+	struct ipw_hardware *hardware;
+	/* Network layer context */
+	struct ipw_network *network;
+	/* TTY device context */
+	struct ipw_tty *tty;
+	struct work_struct work_reboot;
+};
+
+/* Module parametres */
+extern int ipwireless_debug;
+extern int ipwireless_loopback;
+extern int ipwireless_out_queue;
+
+#endif
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
new file mode 100644
index 0000000..ff35230
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -0,0 +1,512 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/ppp_channel.h>
+#include <linux/ppp_defs.h>
+#include <linux/if_ppp.h>
+#include <linux/skbuff.h>
+
+#include "network.h"
+#include "hardware.h"
+#include "main.h"
+#include "tty.h"
+
+#define MAX_OUTGOING_PACKETS_QUEUED   ipwireless_out_queue
+#define MAX_ASSOCIATED_TTYS 2
+
+#define SC_RCV_BITS     (SC_RCV_B7_1|SC_RCV_B7_0|SC_RCV_ODDP|SC_RCV_EVNP)
+
+struct ipw_network {
+	/* Hardware context, used for calls to hardware layer. */
+	struct ipw_hardware *hardware;
+	/* Context for kernel 'generic_ppp' functionality */
+	struct ppp_channel *ppp_channel;
+	/* tty context connected with IPW console */
+	struct ipw_tty *associated_ttys[NO_OF_IPW_CHANNELS][MAX_ASSOCIATED_TTYS];
+	/* True if ppp needs waking up once we're ready to xmit */
+	int ppp_blocked;
+	/* Number of packets queued up in hardware module. */
+	int outgoing_packets_queued;
+	/* Spinlock to avoid interrupts during shutdown */
+	spinlock_t spinlock;
+	struct mutex close_lock;
+
+	/* PPP ioctl data, not actually used anywere */
+	unsigned int flags;
+	unsigned int rbits;
+	u32 xaccm[8];
+	u32 raccm;
+	int mru;
+
+	int shutting_down;
+	unsigned int ras_control_lines;
+
+	struct work_struct work_go_online;
+	struct work_struct work_go_offline;
+};
+
+
+#ifdef IPWIRELESS_STATE_DEBUG
+int ipwireless_dump_network_state(char *p, size_t limit,
+				  struct ipw_network *network)
+{
+	return snprintf(p, limit,
+			"debug: ppp_blocked=%d\n"
+			"debug: outgoing_packets_queued=%d\n"
+			"debug: network.shutting_down=%d\n",
+			network->ppp_blocked,
+			network->outgoing_packets_queued,
+			network->shutting_down);
+}
+#endif
+
+static void notify_packet_sent(void *callback_data, unsigned int packet_length)
+{
+	struct ipw_network *network = callback_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	network->outgoing_packets_queued--;
+	if (network->ppp_channel != NULL) {
+		if (network->ppp_blocked) {
+			network->ppp_blocked = 0;
+			spin_unlock_irqrestore(&network->spinlock, flags);
+			ppp_output_wakeup(network->ppp_channel);
+			if (ipwireless_debug)
+				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				       ": ppp unblocked\n");
+		} else
+			spin_unlock_irqrestore(&network->spinlock, flags);
+	} else
+		spin_unlock_irqrestore(&network->spinlock, flags);
+}
+
+/*
+ * Called by the ppp system when it has a packet to send to the hardware.
+ */
+static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
+				     struct sk_buff *skb)
+{
+	struct ipw_network *network = ppp_channel->private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->outgoing_packets_queued < MAX_OUTGOING_PACKETS_QUEUED) {
+		unsigned char *buf;
+		static unsigned char header[] = {
+			PPP_ALLSTATIONS, /* 0xff */
+			PPP_UI,		 /* 0x03 */
+		};
+		int ret;
+
+		network->outgoing_packets_queued++;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+
+		/*
+		 * If we have the requested amount of headroom in the skb we
+		 * were handed, then we can add the header efficiently.
+		 */
+		if (skb_headroom(skb) >= 2) {
+			memcpy(skb_push(skb, 2), header, 2);
+			ret = ipwireless_send_packet(network->hardware,
+					       IPW_CHANNEL_RAS, skb->data,
+					       skb->len,
+					       notify_packet_sent,
+					       network);
+			if (ret == -1) {
+				skb_pull(skb, 2);
+				return 0;
+			}
+		} else {
+			/* Otherwise (rarely) we do it inefficiently. */
+			buf = kmalloc(skb->len + 2, GFP_ATOMIC);
+			if (!buf)
+				return 0;
+			memcpy(buf + 2, skb->data, skb->len);
+			memcpy(buf, header, 2);
+			ret = ipwireless_send_packet(network->hardware,
+					       IPW_CHANNEL_RAS, buf,
+					       skb->len + 2,
+					       notify_packet_sent,
+					       network);
+			kfree(buf);
+			if (ret == -1)
+				return 0;
+		}
+		kfree_skb(skb);
+		return 1;
+	} else {
+		/*
+		 * Otherwise reject the packet, and flag that the ppp system
+		 * needs to be unblocked once we are ready to send.
+		 */
+		network->ppp_blocked = 1;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		return 0;
+	}
+}
+
+/* Handle an ioctl call that has come in via ppp. (copy of ppp_async_ioctl() */
+static int ipwireless_ppp_ioctl(struct ppp_channel *ppp_channel,
+				unsigned int cmd, unsigned long arg)
+{
+	struct ipw_network *network = ppp_channel->private;
+	int err, val;
+	u32 accm[8];
+	int __user *user_arg = (int __user *) arg;
+
+	err = -EFAULT;
+	switch (cmd) {
+	case PPPIOCGFLAGS:
+		val = network->flags | network->rbits;
+		if (put_user(val, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSFLAGS:
+		if (get_user(val, user_arg))
+			break;
+		network->flags = val & ~SC_RCV_BITS;
+		network->rbits = val & SC_RCV_BITS;
+		err = 0;
+		break;
+
+	case PPPIOCGASYNCMAP:
+		if (put_user(network->xaccm[0], user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSASYNCMAP:
+		if (get_user(network->xaccm[0], user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCGRASYNCMAP:
+		if (put_user(network->raccm, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSRASYNCMAP:
+		if (get_user(network->raccm, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCGXASYNCMAP:
+		if (copy_to_user((void __user *) arg, network->xaccm,
+					sizeof(network->xaccm)))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSXASYNCMAP:
+		if (copy_from_user(accm, (void __user *) arg, sizeof(accm)))
+			break;
+		accm[2] &= ~0x40000000U;	/* can't escape 0x5e */
+		accm[3] |= 0x60000000U;	/* must escape 0x7d, 0x7e */
+		memcpy(network->xaccm, accm, sizeof(network->xaccm));
+		err = 0;
+		break;
+
+	case PPPIOCGMRU:
+		if (put_user(network->mru, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSMRU:
+		if (get_user(val, user_arg))
+			break;
+		if (val < PPP_MRU)
+			val = PPP_MRU;
+		network->mru = val;
+		err = 0;
+		break;
+
+	default:
+		err = -ENOTTY;
+	}
+
+	return err;
+}
+
+static struct ppp_channel_ops ipwireless_ppp_channel_ops = {
+	.start_xmit = ipwireless_ppp_start_xmit,
+	.ioctl      = ipwireless_ppp_ioctl
+};
+
+static void do_go_online(struct work_struct *work_go_online)
+{
+	struct ipw_network *network =
+		container_of(work_go_online, struct ipw_network,
+				work_go_online);
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (!network->ppp_channel) {
+		struct ppp_channel *channel;
+
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		channel = kzalloc(sizeof(struct ppp_channel), GFP_KERNEL);
+		if (!channel) {
+			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+					": unable to allocate PPP channel\n");
+			return;
+		}
+		channel->private = network;
+		channel->mtu = 16384;	/* Wild guess */
+		channel->hdrlen = 2;
+		channel->ops = &ipwireless_ppp_channel_ops;
+
+		network->flags = 0;
+		network->rbits = 0;
+		network->mru = PPP_MRU;
+		memset(network->xaccm, 0, sizeof(network->xaccm));
+		network->xaccm[0] = ~0U;
+		network->xaccm[3] = 0x60000000U;
+		network->raccm = ~0U;
+		ppp_register_channel(channel);
+		spin_lock_irqsave(&network->spinlock, flags);
+		network->ppp_channel = channel;
+	}
+	spin_unlock_irqrestore(&network->spinlock, flags);
+}
+
+static void do_go_offline(struct work_struct *work_go_offline)
+{
+	struct ipw_network *network =
+		container_of(work_go_offline, struct ipw_network,
+				work_go_offline);
+	unsigned long flags;
+
+	mutex_lock(&network->close_lock);
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL) {
+		struct ppp_channel *channel = network->ppp_channel;
+
+		network->ppp_channel = NULL;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		mutex_unlock(&network->close_lock);
+		ppp_unregister_channel(channel);
+	} else {
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		mutex_unlock(&network->close_lock);
+	}
+}
+
+void ipwireless_network_notify_control_line_change(struct ipw_network *network,
+						   unsigned int channel_idx,
+						   unsigned int control_lines,
+						   unsigned int changed_mask)
+{
+	int i;
+
+	if (channel_idx == IPW_CHANNEL_RAS)
+		network->ras_control_lines = control_lines;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++) {
+		struct ipw_tty *tty =
+			network->associated_ttys[channel_idx][i];
+
+		/*
+		 * If it's associated with a tty (other than the RAS channel
+		 * when we're online), then send the data to that tty.  The RAS
+		 * channel's data is handled above - it always goes through
+		 * ppp_generic.
+		 */
+		if (tty)
+			ipwireless_tty_notify_control_line_change(tty,
+								  channel_idx,
+								  control_lines,
+								  changed_mask);
+	}
+}
+
+/*
+ * Some versions of firmware stuff packets with 0xff 0x03 (PPP: ALLSTATIONS, UI)
+ * bytes, which are required on sent packet, but not always present on received
+ * packets
+ */
+static struct sk_buff *ipw_packet_received_skb(unsigned char *data,
+					       unsigned int length)
+{
+	struct sk_buff *skb;
+
+	if (length > 2 && data[0] == PPP_ALLSTATIONS && data[1] == PPP_UI) {
+		length -= 2;
+		data += 2;
+	}
+
+	skb = dev_alloc_skb(length + 4);
+	skb_reserve(skb, 2);
+	memcpy(skb_put(skb, length), data, length);
+
+	return skb;
+}
+
+void ipwireless_network_packet_received(struct ipw_network *network,
+					unsigned int channel_idx,
+					unsigned char *data,
+					unsigned int length)
+{
+	int i;
+	unsigned long flags;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++) {
+		struct ipw_tty *tty = network->associated_ttys[channel_idx][i];
+
+		/*
+		 * If it's associated with a tty (other than the RAS channel
+		 * when we're online), then send the data to that tty.  The RAS
+		 * channel's data is handled above - it always goes through
+		 * ppp_generic.
+		 */
+		if (tty && channel_idx == IPW_CHANNEL_RAS
+				&& (network->ras_control_lines &
+					IPW_CONTROL_LINE_DCD) != 0
+				&& ipwireless_tty_is_modem(tty)) {
+			/*
+			 * If data came in on the RAS channel and this tty is
+			 * the modem tty, and we are online, then we send it to
+			 * the PPP layer.
+			 */
+			mutex_lock(&network->close_lock);
+			spin_lock_irqsave(&network->spinlock, flags);
+			if (network->ppp_channel != NULL) {
+				struct sk_buff *skb;
+
+				spin_unlock_irqrestore(&network->spinlock,
+						flags);
+
+				/* Send the data to the ppp_generic module. */
+				skb = ipw_packet_received_skb(data, length);
+				ppp_input(network->ppp_channel, skb);
+			} else
+				spin_unlock_irqrestore(&network->spinlock,
+						flags);
+			mutex_unlock(&network->close_lock);
+		}
+		/* Otherwise we send it out the tty. */
+		else
+			ipwireless_tty_received(tty, data, length);
+	}
+}
+
+struct ipw_network *ipwireless_network_create(struct ipw_hardware *hw)
+{
+	struct ipw_network *network =
+		kzalloc(sizeof(struct ipw_network), GFP_ATOMIC);
+
+	if (!network)
+		return NULL;
+
+	spin_lock_init(&network->spinlock);
+	mutex_init(&network->close_lock);
+
+	network->hardware = hw;
+
+	INIT_WORK(&network->work_go_online, do_go_online);
+	INIT_WORK(&network->work_go_offline, do_go_offline);
+
+	ipwireless_associate_network(hw, network);
+
+	return network;
+}
+
+void ipwireless_network_free(struct ipw_network *network)
+{
+	network->shutting_down = 1;
+
+	ipwireless_ppp_close(network);
+	flush_scheduled_work();
+
+	ipwireless_stop_interrupts(network->hardware);
+	ipwireless_associate_network(network->hardware, NULL);
+
+	kfree(network);
+}
+
+void ipwireless_associate_network_tty(struct ipw_network *network,
+				      unsigned int channel_idx,
+				      struct ipw_tty *tty)
+{
+	int i;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++)
+		if (network->associated_ttys[channel_idx][i] == NULL) {
+			network->associated_ttys[channel_idx][i] = tty;
+			break;
+		}
+}
+
+void ipwireless_disassociate_network_ttys(struct ipw_network *network,
+					  unsigned int channel_idx)
+{
+	int i;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++)
+		network->associated_ttys[channel_idx][i] = NULL;
+}
+
+void ipwireless_ppp_open(struct ipw_network *network)
+{
+	if (ipwireless_debug)
+		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME ": online\n");
+	schedule_work(&network->work_go_online);
+}
+
+void ipwireless_ppp_close(struct ipw_network *network)
+{
+	/* Disconnect from the wireless network. */
+	if (ipwireless_debug)
+		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME ": offline\n");
+	schedule_work(&network->work_go_offline);
+}
+
+int ipwireless_ppp_channel_index(struct ipw_network *network)
+{
+	int ret = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL)
+		ret = ppp_channel_index(network->ppp_channel);
+	spin_unlock_irqrestore(&network->spinlock, flags);
+
+	return ret;
+}
+
+int ipwireless_ppp_unit_number(struct ipw_network *network)
+{
+	int ret = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL)
+		ret = ppp_unit_number(network->ppp_channel);
+	spin_unlock_irqrestore(&network->spinlock, flags);
+
+	return ret;
+}
diff --git a/drivers/char/pcmcia/ipwireless/network.h b/drivers/char/pcmcia/ipwireless/network.h
new file mode 100644
index 0000000..b0e1e95
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/network.h
@@ -0,0 +1,55 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_NETWORK_H_
+#define _IPWIRELESS_CS_NETWORK_H_
+
+#include <linux/types.h>
+
+struct ipw_network;
+struct ipw_tty;
+struct ipw_hardware;
+
+/* Definitions of the different channels on the PCMCIA UE */
+#define IPW_CHANNEL_RAS      0
+#define IPW_CHANNEL_DIALLER  1
+#define IPW_CHANNEL_CONSOLE  2
+#define NO_OF_IPW_CHANNELS   5
+
+void ipwireless_network_notify_control_line_change(struct ipw_network *net,
+		unsigned int channel_idx, unsigned int control_lines,
+		unsigned int control_mask);
+void ipwireless_network_packet_received(struct ipw_network *net,
+		unsigned int channel_idx, unsigned char *data,
+		unsigned int length);
+struct ipw_network *ipwireless_network_create(struct ipw_hardware *hw);
+void ipwireless_network_free(struct ipw_network *net);
+void ipwireless_associate_network_tty(struct ipw_network *net,
+		unsigned int channel_idx, struct ipw_tty *tty);
+void ipwireless_disassociate_network_ttys(struct ipw_network *net,
+		unsigned int channel_idx);
+
+void ipwireless_ppp_open(struct ipw_network *net);
+
+void ipwireless_ppp_close(struct ipw_network *net);
+int ipwireless_ppp_channel_index(struct ipw_network *net);
+int ipwireless_ppp_unit_number(struct ipw_network *net);
+
+int ipwireless_dump_network_state(char *p, size_t limit,
+				  struct ipw_network *net);
+
+#endif
diff --git a/drivers/char/pcmcia/ipwireless/setup_protocol.h b/drivers/char/pcmcia/ipwireless/setup_protocol.h
new file mode 100644
index 0000000..1289219
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/setup_protocol.h
@@ -0,0 +1,108 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_SETUP_PROTOCOL_H_
+#define _IPWIRELESS_CS_SETUP_PROTOCOL_H_
+
+/* Version of the setup protocol and transport protocols */
+#define TL_SETUP_VERSION		1
+
+#define TL_SETUP_VERSION_QRY_TMO	1000
+#define TL_SETUP_MAX_VERSION_QRY	30
+
+/* Message numbers 0-9 are obsoleted and must not be reused! */
+#define TL_SETUP_SIGNO_GET_VERSION_QRY	10
+#define TL_SETUP_SIGNO_GET_VERSION_RSP	11
+#define TL_SETUP_SIGNO_CONFIG_MSG	12
+#define TL_SETUP_SIGNO_CONFIG_DONE_MSG	13
+#define TL_SETUP_SIGNO_OPEN_MSG		14
+#define TL_SETUP_SIGNO_CLOSE_MSG	15
+
+#define TL_SETUP_SIGNO_INFO_MSG     20
+#define TL_SETUP_SIGNO_INFO_MSG_ACK 21
+
+#define TL_SETUP_SIGNO_REBOOT_MSG      22
+#define TL_SETUP_SIGNO_REBOOT_MSG_ACK  23
+
+/* Synchronous start-messages */
+struct TlSetupGetVersionQry {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_GET_VERSION_QRY */
+} __attribute__ ((__packed__));
+
+struct TlSetupGetVersionRsp {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_GET_VERSION_RSP */
+	unsigned char version;		/* TL_SETUP_VERSION */
+} __attribute__ ((__packed__));
+
+struct TlSetupConfigMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CONFIG_MSG */
+	unsigned char port_no;
+	unsigned char prio_data;
+	unsigned char prio_ctrl;
+} __attribute__ ((__packed__));
+
+struct TlSetupConfigDoneMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CONFIG_DONE_MSG */
+} __attribute__ ((__packed__));
+
+/* Asyncronous messages */
+struct TlSetupOpenMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_OPEN_MSG */
+	unsigned char port_no;
+} __attribute__ ((__packed__));
+
+struct TlSetupCloseMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CLOSE_MSG */
+	unsigned char port_no;
+} __attribute__ ((__packed__));
+
+/* Driver type  - for use in TlSetupInfoMsg.driver_type */
+#define COMM_DRIVER     0
+#define NDISWAN_DRIVER  1
+#define NDISWAN_DRIVER_MAJOR_VERSION  2
+#define NDISWAN_DRIVER_MINOR_VERSION  0
+
+/*
+ * It should not matter when this message comes over as we just store the
+ * results and send the ACK.
+ */
+struct TlSetupInfoMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_INFO_MSG */
+	unsigned char driver_type;
+	unsigned char major_version;
+	unsigned char minor_version;
+} __attribute__ ((__packed__));
+
+struct TlSetupInfoMsgAck {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_INFO_MSG_ACK */
+} __attribute__ ((__packed__));
+
+struct TlSetupRebootMsgAck {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_REBOOT_MSG_ACK */
+} __attribute__ ((__packed__));
+
+/* Define a union of all the msgs that the driver can receive from the card.*/
+union ipw_setup_rx_msg {
+	unsigned char sig_no;
+	struct TlSetupGetVersionRsp VersRspMsg;
+	struct TlSetupOpenMsg OpenMsg;
+	struct TlSetupCloseMsg CloseMsg;
+	struct TlSetupInfoMsg InfoMsg;
+	struct TlSetupInfoMsgAck InfoMsgAck;
+} __attribute__ ((__packed__));
+
+#endif				/* _IPWIRELESS_CS_SETUP_PROTOCOL_H_ */
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
new file mode 100644
index 0000000..9f67d1f
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -0,0 +1,688 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/ppp_defs.h>
+#include <linux/if.h>
+#include <linux/if_ppp.h>
+#include <linux/sched.h>
+#include <linux/serial.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/uaccess.h>
+#include <linux/version.h>
+
+#include "tty.h"
+#include "network.h"
+#include "hardware.h"
+#include "main.h"
+
+#define IPWIRELESS_PCMCIA_START 	(0)
+#define IPWIRELESS_PCMCIA_MINORS	(24)
+#define IPWIRELESS_PCMCIA_MINOR_RANGE	(8)
+
+#define TTYTYPE_MODEM    (0)
+#define TTYTYPE_MONITOR  (1)
+#define TTYTYPE_RAS_RAW  (2)
+
+struct ipw_tty {
+	int index;
+	struct ipw_hardware *hardware;
+	unsigned int channel_idx;
+	unsigned int secondary_channel_idx;
+	int tty_type;
+	struct ipw_network *network;
+	struct tty_struct *linux_tty;
+	int open_count;
+	unsigned int control_lines;
+	struct mutex ipw_tty_mutex;
+	int tx_bytes_queued;
+	int closing;
+};
+
+static struct ipw_tty *ttys[IPWIRELESS_PCMCIA_MINORS];
+
+static struct tty_driver *ipw_tty_driver;
+
+static char *tty_type_name(int tty_type)
+{
+	static char *channel_names[] = {
+		"modem",
+		"monitor",
+		"RAS-raw"
+	};
+
+	return channel_names[tty_type];
+}
+
+static void report_registering(struct ipw_tty *tty)
+{
+	char *iftype = tty_type_name(tty->tty_type);
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": registering %s device ttyIPWp%d\n", iftype, tty->index);
+}
+
+static void report_deregistering(struct ipw_tty *tty)
+{
+	char *iftype = tty_type_name(tty->tty_type);
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": deregistering %s device ttyIPWp%d\n", iftype,
+	       tty->index);
+}
+
+static struct ipw_tty *get_tty(int minor)
+{
+	if (minor < ipw_tty_driver->minor_start
+			|| minor >= ipw_tty_driver->minor_start +
+			IPWIRELESS_PCMCIA_MINORS)
+		return NULL;
+	else {
+		int minor_offset = minor - ipw_tty_driver->minor_start;
+
+		/*
+		 * The 'ras_raw' channel is only available when 'loopback' mode
+		 * is enabled.
+		 * Number of minor starts with 16 (_RANGE * _RAS_RAW).
+		 */
+		if (!ipwireless_loopback &&
+				minor_offset >=
+				 IPWIRELESS_PCMCIA_MINOR_RANGE * TTYTYPE_RAS_RAW)
+			return NULL;
+
+		return ttys[minor_offset];
+	}
+}
+
+static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
+{
+	int minor = linux_tty->index;
+	struct ipw_tty *tty = get_tty(minor);
+
+	if (!tty)
+		return -ENODEV;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+
+	if (tty->closing) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return -ENODEV;
+	}
+	if (tty->open_count == 0)
+		tty->tx_bytes_queued = 0;
+
+	tty->open_count++;
+
+	tty->linux_tty = linux_tty;
+	linux_tty->driver_data = tty;
+	linux_tty->low_latency = 1;
+
+	if (tty->tty_type == TTYTYPE_MODEM)
+		ipwireless_ppp_open(tty->network);
+
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	return 0;
+}
+
+static void do_ipw_close(struct ipw_tty *tty)
+{
+	tty->open_count--;
+
+	if (tty->open_count == 0) {
+		struct tty_struct *linux_tty = tty->linux_tty;
+
+		if (linux_tty != NULL) {
+			tty->linux_tty = NULL;
+			linux_tty->driver_data = NULL;
+
+			if (tty->tty_type == TTYTYPE_MODEM)
+				ipwireless_ppp_close(tty->network);
+		}
+	}
+}
+
+static void ipw_hangup(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	if (tty->open_count == 0) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+
+	do_ipw_close(tty);
+
+	mutex_unlock(&tty->ipw_tty_mutex);
+}
+
+static void ipw_close(struct tty_struct *linux_tty, struct file *filp)
+{
+	ipw_hangup(linux_tty);
+}
+
+/* Take data received from hardware, and send it out the tty */
+void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
+			unsigned int length)
+{
+	struct tty_struct *linux_tty;
+	int work = 0;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	linux_tty = tty->linux_tty;
+	if (linux_tty == NULL) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+
+	if (!tty->open_count) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	work = tty_insert_flip_string(linux_tty, data, length);
+
+	if (work != length)
+		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+				": %d chars not inserted to flip buffer!\n",
+				length - work);
+
+	/*
+	 * This may sleep if ->low_latency is set
+	 */
+	if (work)
+		tty_flip_buffer_push(linux_tty);
+}
+
+static void ipw_write_packet_sent_callback(void *callback_data,
+					   unsigned int packet_length)
+{
+	struct ipw_tty *tty = callback_data;
+
+	/*
+	 * Packet has been sent, so we subtract the number of bytes from our
+	 * tally of outstanding TX bytes.
+	 */
+	tty->tx_bytes_queued -= packet_length;
+}
+
+static int ipw_write(struct tty_struct *linux_tty,
+		     const unsigned char *buf, int count)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+	int room, ret;
+
+	if (!tty)
+		return -ENODEV;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	if (!tty->open_count) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return -EINVAL;
+	}
+
+	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
+	if (room < 0)
+		room = 0;
+	/* Don't allow caller to write any more than we have room for */
+	if (count > room)
+		count = room;
+
+	if (count == 0) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return 0;
+	}
+
+	ret = ipwireless_send_packet(tty->hardware, IPW_CHANNEL_RAS,
+			       (unsigned char *) buf, count,
+			       ipw_write_packet_sent_callback, tty);
+	if (ret == -1) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return 0;
+	}
+
+	tty->tx_bytes_queued += count;
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	return count;
+}
+
+static int ipw_write_room(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+	int room;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
+	if (room < 0)
+		room = 0;
+
+	return room;
+}
+
+static int ipwireless_get_serial_info(struct ipw_tty *tty,
+				      struct serial_struct __user *retinfo)
+{
+	struct serial_struct tmp;
+
+	if (!retinfo)
+		return (-EFAULT);
+
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.type = PORT_UNKNOWN;
+	tmp.line = tty->index;
+	tmp.port = 0;
+	tmp.irq = 0;
+	tmp.flags = 0;
+	tmp.baud_base = 115200;
+	tmp.close_delay = 0;
+	tmp.closing_wait = 0;
+	tmp.custom_divisor = 0;
+	tmp.hub6 = 0;
+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ipw_chars_in_buffer(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return tty->tx_bytes_queued;
+}
+
+static int get_control_lines(struct ipw_tty *tty)
+{
+	unsigned int my = tty->control_lines;
+	unsigned int out = 0;
+
+	if (my & IPW_CONTROL_LINE_RTS)
+		out |= TIOCM_RTS;
+	if (my & IPW_CONTROL_LINE_DTR)
+		out |= TIOCM_DTR;
+	if (my & IPW_CONTROL_LINE_CTS)
+		out |= TIOCM_CTS;
+	if (my & IPW_CONTROL_LINE_DSR)
+		out |= TIOCM_DSR;
+	if (my & IPW_CONTROL_LINE_DCD)
+		out |= TIOCM_CD;
+
+	return out;
+}
+
+static int set_control_lines(struct ipw_tty *tty, unsigned int set,
+			     unsigned int clear)
+{
+	int ret;
+
+	if (set & TIOCM_RTS) {
+		ret = ipwireless_set_RTS(tty->hardware, tty->channel_idx, 1);
+		if (ret)
+			return ret;
+		if (tty->secondary_channel_idx != -1) {
+			ret = ipwireless_set_RTS(tty->hardware,
+					  tty->secondary_channel_idx, 1);
+			if (ret)
+				return ret;
+		}
+	}
+	if (set & TIOCM_DTR) {
+		ret = ipwireless_set_DTR(tty->hardware, tty->channel_idx, 1);
+		if (ret)
+			return ret;
+		if (tty->secondary_channel_idx != -1) {
+			ret = ipwireless_set_DTR(tty->hardware,
+					  tty->secondary_channel_idx, 1);
+			if (ret)
+				return ret;
+		}
+	}
+	if (clear & TIOCM_RTS) {
+		ret = ipwireless_set_RTS(tty->hardware, tty->channel_idx, 0);
+		if (tty->secondary_channel_idx != -1) {
+			ret = ipwireless_set_RTS(tty->hardware,
+					  tty->secondary_channel_idx, 0);
+			if (ret)
+				return ret;
+		}
+	}
+	if (clear & TIOCM_DTR) {
+		ret = ipwireless_set_DTR(tty->hardware, tty->channel_idx, 0);
+		if (tty->secondary_channel_idx != -1) {
+			ret = ipwireless_set_DTR(tty->hardware,
+					  tty->secondary_channel_idx, 0);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+static int ipw_tiocmget(struct tty_struct *linux_tty, struct file *file)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return get_control_lines(tty);
+}
+
+static int
+ipw_tiocmset(struct tty_struct *linux_tty, struct file *file,
+	     unsigned int set, unsigned int clear)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return set_control_lines(tty, set, clear);
+}
+
+static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
+		     unsigned int cmd, unsigned long arg)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	switch (cmd) {
+	case TIOCGSERIAL:
+		return ipwireless_get_serial_info(tty, (void __user *) arg);
+
+	case TIOCSSERIAL:
+		return 0;	/* Keeps the PCMCIA scripts happy. */
+	}
+
+	if (tty->tty_type == TTYTYPE_MODEM) {
+		switch (cmd) {
+		case PPPIOCGCHAN:
+			{
+				int chan = ipwireless_ppp_channel_index(
+							tty->network);
+
+				if (chan < 0)
+					return -ENODEV;
+				if (put_user(chan, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+
+		case PPPIOCGUNIT:
+			{
+				int unit = ipwireless_ppp_unit_number(
+						tty->network);
+
+				if (unit < 0)
+					return -ENODEV;
+				if (put_user(unit, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+
+		case TCGETS:
+		case TCGETA:
+			return n_tty_ioctl(linux_tty, file, cmd, arg);
+
+		case TCFLSH:
+			return n_tty_ioctl(linux_tty, file, cmd, arg);
+
+		case FIONREAD:
+			{
+				int val = 0;
+
+				if (put_user(val, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+		}
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static int add_tty(dev_node_t *nodesp, int j,
+		    struct ipw_hardware *hardware,
+		    struct ipw_network *network, int channel_idx,
+		    int secondary_channel_idx, int tty_type)
+{
+	ttys[j] = kzalloc(sizeof(struct ipw_tty), GFP_KERNEL);
+	if (!ttys[j])
+		return -1;
+	ttys[j]->index = j;
+	ttys[j]->hardware = hardware;
+	ttys[j]->channel_idx = channel_idx;
+	ttys[j]->secondary_channel_idx = secondary_channel_idx;
+	ttys[j]->network = network;
+	ttys[j]->tty_type = tty_type;
+	mutex_init(&ttys[j]->ipw_tty_mutex);
+
+	tty_register_device(ipw_tty_driver, j, NULL);
+	ipwireless_associate_network_tty(network, channel_idx, ttys[j]);
+
+	if (secondary_channel_idx != -1)
+		ipwireless_associate_network_tty(network,
+						 secondary_channel_idx,
+						 ttys[j]);
+	if (nodesp != NULL) {
+		sprintf(nodesp->dev_name, "ttyIPWp%d", j);
+		nodesp->major = ipw_tty_driver->major;
+		nodesp->minor = j + ipw_tty_driver->minor_start;
+	}
+	if (get_tty(j + ipw_tty_driver->minor_start) == ttys[j])
+		report_registering(ttys[j]);
+	return 0;
+}
+
+struct ipw_tty *ipwireless_tty_create(struct ipw_hardware *hardware,
+				      struct ipw_network *network,
+				      dev_node_t *nodes)
+{
+	int i, j;
+
+	for (i = 0; i < IPWIRELESS_PCMCIA_MINOR_RANGE; i++) {
+		int allfree = 1;
+
+		for (j = i; j < IPWIRELESS_PCMCIA_MINORS;
+				j += IPWIRELESS_PCMCIA_MINOR_RANGE)
+			if (ttys[j] != NULL) {
+				allfree = 0;
+				break;
+			}
+
+		if (allfree) {
+			j = i;
+
+			if (add_tty(&nodes[0], j, hardware, network,
+					IPW_CHANNEL_DIALLER, IPW_CHANNEL_RAS,
+					TTYTYPE_MODEM))
+				return NULL;
+
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE;
+			if (add_tty(&nodes[1], j, hardware, network,
+					IPW_CHANNEL_DIALLER, -1,
+					TTYTYPE_MONITOR))
+				return NULL;
+
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE;
+			if (add_tty(NULL, j, hardware, network,
+					IPW_CHANNEL_RAS, -1,
+					TTYTYPE_RAS_RAW))
+				return NULL;
+
+			nodes[0].next = &nodes[1];
+			nodes[1].next = NULL;
+
+			return ttys[i];
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Must be called before ipwireless_network_free().
+ */
+void ipwireless_tty_free(struct ipw_tty *tty)
+{
+	int j;
+	struct ipw_network *network = ttys[tty->index]->network;
+
+	for (j = tty->index; j < IPWIRELESS_PCMCIA_MINORS;
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE) {
+		struct ipw_tty *ttyj = ttys[j];
+
+		if (ttyj) {
+			mutex_lock(&ttyj->ipw_tty_mutex);
+			if (get_tty(j + ipw_tty_driver->minor_start) == ttyj)
+				report_deregistering(ttyj);
+			ttyj->closing = 1;
+			if (ttyj->linux_tty != NULL) {
+				mutex_unlock(&ttyj->ipw_tty_mutex);
+				tty_hangup(ttyj->linux_tty);
+				/* Wait till the tty_hangup has completed */
+				flush_scheduled_work();
+				mutex_lock(&ttyj->ipw_tty_mutex);
+			}
+			while (ttyj->open_count)
+				do_ipw_close(ttyj);
+			ipwireless_disassociate_network_ttys(network,
+							     ttyj->channel_idx);
+			tty_unregister_device(ipw_tty_driver, j);
+			ttys[j] = NULL;
+			mutex_unlock(&ttyj->ipw_tty_mutex);
+			kfree(ttyj);
+		}
+	}
+}
+
+static struct tty_operations tty_ops = {
+	.open = ipw_open,
+	.close = ipw_close,
+	.hangup = ipw_hangup,
+	.write = ipw_write,
+	.write_room = ipw_write_room,
+	.ioctl = ipw_ioctl,
+	.chars_in_buffer = ipw_chars_in_buffer,
+	.tiocmget = ipw_tiocmget,
+	.tiocmset = ipw_tiocmset,
+};
+
+int ipwireless_tty_init(int major)
+{
+	int result;
+
+	ipw_tty_driver = alloc_tty_driver(IPWIRELESS_PCMCIA_MINORS);
+	if (!ipw_tty_driver)
+		return -ENOMEM;
+
+	ipw_tty_driver->owner = THIS_MODULE;
+	ipw_tty_driver->driver_name = IPWIRELESS_PCCARD_NAME;
+	ipw_tty_driver->name = "ttyIPWp";
+	ipw_tty_driver->major = major;
+	ipw_tty_driver->minor_start = IPWIRELESS_PCMCIA_START;
+	ipw_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	ipw_tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	ipw_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	ipw_tty_driver->init_termios = tty_std_termios;
+	ipw_tty_driver->init_termios.c_cflag =
+	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	ipw_tty_driver->init_termios.c_ispeed = 9600;
+	ipw_tty_driver->init_termios.c_ospeed = 9600;
+	tty_set_operations(ipw_tty_driver, &tty_ops);
+	result = tty_register_driver(ipw_tty_driver);
+	if (result) {
+		printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+		       ": failed to register tty driver\n");
+		put_tty_driver(ipw_tty_driver);
+		return result;
+	}
+
+	return 0;
+}
+
+void ipwireless_tty_release(void)
+{
+	int ret;
+
+	ret = tty_unregister_driver(ipw_tty_driver);
+	put_tty_driver(ipw_tty_driver);
+	if (ret != 0)
+		printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+			": tty_unregister_driver failed with code %d\n", ret);
+}
+
+int ipwireless_tty_is_modem(struct ipw_tty *tty)
+{
+	return tty->tty_type == TTYTYPE_MODEM;
+}
+
+void
+ipwireless_tty_notify_control_line_change(struct ipw_tty *tty,
+					  unsigned int channel_idx,
+					  unsigned int control_lines,
+					  unsigned int changed_mask)
+{
+	unsigned int old_control_lines = tty->control_lines;
+
+	tty->control_lines = (tty->control_lines & ~changed_mask)
+		| (control_lines & changed_mask);
+
+	/*
+	 * If DCD is de-asserted, we close the tty so pppd can tell that we
+	 * have gone offline.
+	 */
+	if ((old_control_lines & IPW_CONTROL_LINE_DCD)
+			&& !(tty->control_lines & IPW_CONTROL_LINE_DCD)
+			&& tty->linux_tty) {
+		tty_hangup(tty->linux_tty);
+	}
+}
+
diff --git a/drivers/char/pcmcia/ipwireless/tty.h b/drivers/char/pcmcia/ipwireless/tty.h
new file mode 100644
index 0000000..a678c5d
--- /dev/null
+++ b/drivers/char/pcmcia/ipwireless/tty.h
@@ -0,0 +1,48 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_TTY_H_
+#define _IPWIRELESS_CS_TTY_H_
+
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+
+struct ipw_tty;
+struct ipw_network;
+struct ipw_hardware;
+
+int ipwireless_tty_init(int);
+
+void ipwireless_tty_release(void);
+
+struct ipw_tty *ipwireless_tty_create(struct ipw_hardware *hw,
+				      struct ipw_network *net,
+				      dev_node_t *nodes);
+void ipwireless_tty_free(struct ipw_tty *tty);
+void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
+		unsigned int length);
+int ipwireless_tty_is_modem(struct ipw_tty *tty);
+void ipwireless_tty_notify_control_line_change(struct ipw_tty *tty,
+		unsigned int channel_idx, unsigned int control_lines,
+		unsigned int changed_mask);
+
+#endif
