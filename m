Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYA1SJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYA1SJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYA1SJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:09:04 -0500
Received: from xenotime.net ([66.160.160.81]:54099 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751697AbYA1SJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:09:01 -0500
Date: Mon, 28 Jan 2008 10:08:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: dsterba@suse.cz
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-Id: <20080128100854.fe7acad8.rdunlap@xenotime.net>
In-Reply-To: <20080128171929.GA3906@ds.suse.cz>
References: <20080128171929.GA3906@ds.suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 18:19:29 +0100 David Sterba wrote:

[resending due to send problems, sorry about any dups]

> Hi Linus,
> 
> I'm submitting driver for IPWireless PC Card modem for inclusion to 2.6.25.
> 
> The driver has been in -mm series as ipwireless_cs.git tree for
> some time and has passed through lkml (http://lkml.org/lkml/2007/12/12/165).
> The PCMCIA subsystem is unmaintained, so I'm sending it directly as Andrew
> suggested.
> 
> David Sterba
> ---
> From: David Sterba <dsterba@suse.cz>
> 
> ipwireless: driver for PC Card, 3G internet connection
> 
> The driver is manufactured by IPWireless.
> 
> Rewieved-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Ben Martel <benm@symmetric.co.nz>
> Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  MAINTAINERS                                     |    8 
>  drivers/char/pcmcia/Kconfig                     |    9 
>  drivers/char/pcmcia/Makefile                    |    2 
>  drivers/char/pcmcia/ipwireless/Makefile         |   10 
>  drivers/char/pcmcia/ipwireless/hardware.c       | 1784 ++++++++++++++++++++++++
>  drivers/char/pcmcia/ipwireless/hardware.h       |   63 
>  drivers/char/pcmcia/ipwireless/main.c           |  496 ++++++
>  drivers/char/pcmcia/ipwireless/main.h           |   70 
>  drivers/char/pcmcia/ipwireless/network.c        |  513 ++++++
>  drivers/char/pcmcia/ipwireless/network.h        |   54 
>  drivers/char/pcmcia/ipwireless/setup_protocol.h |  108 +
>  drivers/char/pcmcia/ipwireless/tty.c            |  687 +++++++++
>  drivers/char/pcmcia/ipwireless/tty.h            |   48 
>  13 files changed, 3852 insertions(+)
> ---
> diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
> new file mode 100644
> index 0000000..de31f48
> --- /dev/null
> +++ b/drivers/char/pcmcia/ipwireless/hardware.c
> @@ -0,0 +1,1784 @@
> +/*
> + * IPWireless 3G PCMCIA Network Driver
> + *
> + * Original code
> + *   by Stephen Blackheath <stephen@blacksapphire.com>,
> + *      Ben Martel <benm@symmetric.co.nz>
> + *
> + * Copyrighted as follows:
> + *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
> + *
> + * Various driver changes and rewrites, port to new kernels
> + *   Copyright (C) 2006-2007 Jiri Kosina
> + *
> + * Misc code cleanups and updates
> + *   Copyright (C) 2007 David Sterba
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +
> +#include "hardware.h"
> +#include "setup_protocol.h"
> +#include "network.h"
> +#include "main.h"
> +
> +/* Function prototypes */
> +static void ipw_send_setup_packet(struct ipw_hardware *hw);
> +static void handle_received_SETUP_packet(struct ipw_hardware *ipw,
> +					 unsigned int address,
> +					 unsigned char *data, int len,
> +					 int is_last);
> +static void ipwireless_setup_timer(unsigned long data);
> +static void handle_received_CTRL_packet(struct ipw_hardware *hw,
> +		unsigned int channel_idx, unsigned char *data, int len);
> +
> +/*#define TIMING_DIAGNOSTICS*/
> +
> +#ifdef TIMING_DIAGNOSTICS
> +
> +static struct timing_stats {
> +	unsigned long last_report_time;
> +	unsigned long read_time;
> +	unsigned long write_time;
> +	unsigned long read_bytes;
> +	unsigned long write_bytes;
> +	unsigned long start_time;
> +};
> +
...
> +/* Protocol ids */
> +enum {
> +	/* Identifier for the Com Data protocol */
> +	TL_PROTOCOLID_COM_DATA = 0,
> +
> +	/* Identifier for the Com Control protocol */
> +	TL_PROTOCOLID_COM_CTRL = 1,
> +
> +	/* Identifier for the Setup protocol */
> +	TL_PROTOCOLID_SETUP = 2
> +};
> +
> +/* Number of bytes in NL packet header (can not do

cannot

> + * sizeof(nl_packet_header) since it's a bitfield) */
> +#define NL_FIRST_PACKET_HEADER_SIZE        3
> +
> +/* Number of bytes in NL packet header (can not do

cannot

> + * sizeof(nl_packet_header) since it's a bitfield) */
> +#define NL_FOLLOWING_PACKET_HEADER_SIZE    1
> +
> +struct nl_first_paket_header {

                   packet ?

> +#if defined(__BIG_ENDIAN)
> +	unsigned char packet_rank:2;
> +	unsigned char address:3;
> +	unsigned char protocol:3;
> +#else
> +	unsigned char protocol:3;
> +	unsigned char address:3;
> +	unsigned char packet_rank:2;
> +#endif

>From C99 spec:
"The order of allocation of bit-fields within a unit (high-order to
low-order or low-order to high-order) is implementation-defined."

so if the order/location of these bitfields is important (from one
system to another), you should use bit masks instead of bitfields
for them.

> +	unsigned char length_lsb;
> +	unsigned char length_msb;
> +};
> +
> +struct nl_packet_header {
> +#if defined(__BIG_ENDIAN)
> +	unsigned char packet_rank:2;
> +	unsigned char address:3;
> +	unsigned char protocol:3;
> +#else
> +	unsigned char protocol:3;
> +	unsigned char address:3;
> +	unsigned char packet_rank:2;
> +#endif
> +};
> +
> +/* Value of 'packet_rank' above */
> +#define NL_INTERMEDIATE_PACKET    0x0
> +#define NL_LAST_PACKET            0x1
> +#define NL_FIRST_PACKET           0x2
> +
> +union nl_packet {
> +	/* Network packet header of the first packet (a special case) */
> +	struct nl_first_paket_header hdr_first;
> +	/* Network packet header of the following packets (if any) */
> +	struct nl_packet_header hdr;
> +	/* Complete network packet (header + data) */
> +	unsigned char rawpkt[LL_MTU_MAX];
> +} __attribute__ ((__packed__));
> +
> +#define HW_VERSION_UNKNOWN -1
> +#define HW_VERSION_1 1
> +#define HW_VERSION_2 2
> +
...
> +
> +/*
> + * Packet info structure for tx packets.
> + * Note: not all the fields defined here are required for all protocols
> + */
> +struct ipw_tx_packet {
> +	struct list_head queue;
> +	/* channel idx + 1 */
> +	unsigned char dest_addr;
> +	/* SETUP, CTRL or DATA */
> +	unsigned char protocol;
> +	/* Length of data block, which starts at the end of this structure */
> +	unsigned short length;
> +	/* Sending state */
> +	/* Offset of where we've sent up to so far */
> +	unsigned long offset;
> +	/* Count of packet fragments, starting at 0 */
> +	int fragment_count;
> +
> +	/* Called after packet is sent and before is freed */
> +	void (*packet_callback) (void *cb_data, unsigned int packet_length);
> +	void *callback_data;
> +};
> +
> +/* Signals from DTE */
> +enum ComCtrl_DTESignal {
> +	ComCtrl_RTS = 0,
> +	ComCtrl_DTR = 1
> +};
> +
> +/* Signals from DCE */
> +enum ComCtrl_DCESignal {
> +	ComCtrl_CTS = 2,
> +	ComCtrl_DCD = 3,
> +	ComCtrl_DSR = 4,
> +	ComCtrl_RI = 5
> +};
> +
> +struct ipw_control_packet_body {
> +	/* ComCtrl_DTESignal or ComCtrl_DCESignal */
> +	unsigned char sig_no;
> +	/* ComCtrl_SET(0) or ComCtrl_CLEAR(1) */
> +	unsigned char value;
> +} __attribute__ ((__packed__));
> +
> +struct ipw_control_packet {
> +	struct ipw_tx_packet header;
> +	struct ipw_control_packet_body body;
> +};
> +
> +struct ipw_rx_packet {
> +	struct list_head queue;
> +	unsigned int capacity;
> +	unsigned int length;
> +	unsigned int protocol;
> +	unsigned int channel_idx;
> +};
> +
> +#ifdef IPWIRELESS_STATE_DEBUG
> +int ipwireless_dump_hardware_state(char *p, struct ipw_hardware *hw)
> +{
> +	int idx = 0;
> +
> +	idx += sprintf(p + idx, "debug: initializing=%d\n", hw->initializing);
> +	idx += sprintf(p + idx, "debug: tx_ready=%d\n", hw->tx_ready);
> +	idx += sprintf(p + idx, "debug: tx_queued=%d\n", hw->tx_queued);
> +	idx += sprintf(p + idx, "debug: rx_ready=%d\n", hw->rx_ready);
> +	idx += sprintf(p + idx, "debug: rx_bytes_queued=%d\n",
> +			hw->rx_bytes_queued);
> +	idx += sprintf(p + idx, "debug: blocking_rx=%d\n", hw->blocking_rx);
> +	idx += sprintf(p + idx, "debug: removed=%d\n", hw->removed);
> +	idx += sprintf(p + idx, "debug: hardware.shutting_down=%d\n",
> +			hw->shutting_down);
> +	idx += sprintf(p + idx, "debug: to_setup=%d\n",
> +			hw->to_setup);
> +	return idx;

check for/prevent overflow of <p> ?

> +}
> +#endif
> +
> +static char *data_type(const unsigned char *buf, unsigned length)
> +{
> +	struct nl_packet_header *hdr = (struct nl_packet_header *) buf;
> +
> +	if (length == 0)
> +		return "     ";
> +
> +	if (hdr->packet_rank & NL_FIRST_PACKET) {
> +		switch (hdr->protocol) {
> +		case TL_PROTOCOLID_COM_DATA:	return "DATA ";
> +		case TL_PROTOCOLID_COM_CTRL:	return "CTRL ";
> +		case TL_PROTOCOLID_SETUP:	return "SETUP";
> +		default: return "???? ";
> +		}
> +	} else
> +		return "     ";
> +}
> +
> +#define DUMP_MAX_BYTES 64
> +
> +static void dump_data_bytes(const char *type, const unsigned char *data,
> +			    unsigned length)
> +{
> +	char prefix[56];
> +
> +	sprintf(prefix, IPWIRELESS_PCCARD_NAME ": %s %s ",
> +			type, data_type(data, length));
> +	print_hex_dump_bytes(prefix, 0, (void *)data,
> +			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
> +}
> +
...

> +
> +/*
> + * Retrieve a packet from the IPW hardware.
> + */
> +static void do_receive_packet(struct ipw_hardware *hw)
> +{
> +	unsigned short len;
> +	unsigned int i;
> +	unsigned char pkt[LL_MTU_MAX];
> +
> +	start_timing();
> +
> +	if (hw->hw_version == HW_VERSION_1) {
> +		len = inw(hw->base_port + IODRR);
> +		if (len > hw->ll_mtu) {
> +			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
> +			       ": received a packet of %d bytes - "
> +			       "longer than the MTU!\n", (unsigned int)len);
> +			outw(DCR_RXDONE | DCR_RXRESET, hw->base_port + IODCR);
> +			return;
> +		}
> +
> +		for (i = 0; i < len; i += 2) {
> +			__le16 raw_data = inw(hw->base_port + IODRR);
> +			unsigned short data = le16_to_cpu(raw_data);
> +
> +			pkt[i] = (unsigned char) data;
> +			pkt[i + 1] = (unsigned char) (data >> 8);
> +		}
> +	} else {
> +		len = inw(hw->base_port + IODMADPR);
> +		if (len > hw->ll_mtu) {
> +			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
> +			       ": received a packet of %d bytes - "
> +			       "longer than the MTU!\n", (unsigned int)len);
> +			writew(MEMRX_PCINTACKK,
> +				&hw->memory_info_regs->memreg_pc_interrupt_ack);
> +			return;
> +		}
> +
> +		for (i = 0; i < len; i += 2) {
> +			__le16 raw_data = inw(hw->base_port + IODMADPR);
> +			unsigned short data = le16_to_cpu(raw_data);
> +
> +			pkt[i] = (unsigned char) data;
> +			pkt[i + 1] = (unsigned char) (data >> 8);
> +		}
> +
> +		while ((i & 3) != 2) {
> +			inw(hw->base_port + IODMADPR);
> +			i += 2;
> +		}
> +	}
> +
> +	acknowledge_data_read(hw);
> +
> +	if (ipwireless_debug)
> +		dump_data_bytes("recv", pkt, len);
> +
> +	handle_received_packet(hw, (union nl_packet *) pkt, len);
> +
> +	end_read_timing(len);
> +}
> +
> +static int get_current_packet_priority(struct ipw_hardware *hw)
> +{
> +	/*
> +	 * If we're initializing, don't send anything of higher priority than
> +	 * PRIO_SETUP.  The network layer therefore need not care about
> +	 * hardware initialization - any of its stuff will simply be queued
> +	 * until setup is complete.
> +	 */
> +	return (hw->to_setup || hw->initializing
> +			? PRIO_SETUP + 1 :
> +			NL_NUM_OF_PRIORITIES);
> +}
> +
> +/*
> + * @return 1 if something has been received from hw

What's with the '@'?

> + */
> +static int get_packets_from_hw(struct ipw_hardware *hw)
> +{
> +	int received = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&hw->spinlock, flags);
> +	while (hw->rx_ready && !hw->blocking_rx) {
> +		received = 1;
> +		hw->rx_ready--;
> +		spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +		do_receive_packet(hw);
> +
> +		spin_lock_irqsave(&hw->spinlock, flags);
> +	}
> +	spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +	return received;
> +}
> +
> +/*
> + * Send pending packet up to given priority, prioritize SETUP data until
> + * hardware is fully setup.
> + *
> + * @return 1 if more packets can be sent

ditto.

> + */
> +static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
> +{
> +	int more_to_send = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&hw->spinlock, flags);
> +	if (hw->tx_queued && hw->tx_ready != 0) {
> +		int priority;
> +		struct ipw_tx_packet *packet = NULL;
> +
> +		hw->tx_ready--;
> +
> +		/* Pick a packet */
> +		for (priority = 0; priority < priority_limit; priority++) {
> +			if (!list_empty(&hw->tx_queue[priority])) {
> +				packet = list_first_entry(
> +						&hw->tx_queue[priority],
> +						struct ipw_tx_packet,
> +						queue);
> +
> +				list_del(&packet->queue);
> +
> +				break;
> +			}
> +		}
> +		if (!packet) {
> +			hw->tx_queued = 0;
> +			spin_unlock_irqrestore(&hw->spinlock, flags);
> +			return 0;
> +		}
> +		spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +		/* Send */
> +		do_send_packet(hw, packet);
> +
> +		/* Check if more to send */
> +		spin_lock_irqsave(&hw->spinlock, flags);
> +		for (priority = 0; priority < priority_limit; priority++)
> +			if (!list_empty(&hw->tx_queue[priority])) {
> +				more_to_send = 1;
> +				break;
> +			}
> +
> +		if (!more_to_send)
> +			hw->tx_queued = 0;
> +	}
> +	spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +	return more_to_send;
> +}
> +
> +/*
> + * Send and receive all queued packets.
> + */
> +static void ipwireless_do_tasklet(unsigned long hw_)
> +{
> +	struct ipw_hardware *hw = (struct ipw_hardware *) hw_;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&hw->spinlock, flags);
> +	if (hw->shutting_down) {
> +		spin_unlock_irqrestore(&hw->spinlock, flags);
> +		return;
> +	}
> +
> +	if (hw->to_setup == 1) {
> +		/*
> +		 * Initial setup data sent to hardware
> +		 */
> +		hw->to_setup = 2;
> +		spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +		ipw_setup_hardware(hw);
> +		ipw_send_setup_packet(hw);
> +
> +		send_pending_packet(hw, PRIO_SETUP + 1);
> +		get_packets_from_hw(hw);
> +	} else {
> +		int priority_limit = get_current_packet_priority(hw);
> +		int again;
> +
> +		spin_unlock_irqrestore(&hw->spinlock, flags);
> +
> +		do {
> +			again = send_pending_packet(hw, priority_limit);
> +			again |= get_packets_from_hw(hw);
> +		} while (again);
> +	}
> +}
> +
> +/*!

and the '!' ?

> + * @return true if the card is physically present.
> + */
> +static int is_card_present(struct ipw_hardware *hw)
> +{
> +	if (hw->hw_version == HW_VERSION_1)
> +		return inw(hw->base_port + IOIR) != (unsigned short) 0xFFFF;
> +	else
> +		return readl(&hw->memory_info_regs->memreg_card_present) ==
> +		    CARD_PRESENT_VALUE;
> +}
> +
...
> +/* This handles the actual initialization of the card */
> +static void __handle_setup_get_version_rsp(struct ipw_hardware *hw)
> +{
> +	struct ipw_setup_config_packet *config_packet;
> +	struct ipw_setup_config_done_packet *config_done_packet;
> +	struct ipw_setup_open_packet *open_packet;
> +	struct ipw_setup_info_packet *info_packet;
> +	int port;
> +	unsigned int channel_idx;
> +
> +	/* generate config packet */
> +	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
> +		config_packet = alloc_ctrl_packet(
> +				sizeof(struct ipw_setup_config_packet),
> +				ADDR_SETUP_PROT,
> +				TL_PROTOCOLID_SETUP,
> +				TL_SETUP_SIGNO_CONFIG_MSG);
> +		if (!config_packet)
> +			goto exit_nomem;
> +		config_packet->header.length = sizeof(struct TlSetupConfigMsg);
> +		config_packet->body.port_no = port;
> +		config_packet->body.prio_data = PRIO_DATA;
> +		config_packet->body.prio_ctrl = PRIO_CTRL;
> +		send_packet(hw, PRIO_SETUP, &config_packet->header);
> +	}
> +	config_done_packet = alloc_ctrl_packet(
> +			sizeof(struct ipw_setup_config_done_packet),
> +			ADDR_SETUP_PROT,
> +			TL_PROTOCOLID_SETUP,
> +			TL_SETUP_SIGNO_CONFIG_DONE_MSG);
> +	if (!config_done_packet)
> +		goto exit_nomem;
> +	config_done_packet->header.length = sizeof(struct TlSetupConfigDoneMsg);
> +	send_packet(hw, PRIO_SETUP, &config_done_packet->header);
> +
> +	/* generate open packet */
> +	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
> +		open_packet = alloc_ctrl_packet(
> +				sizeof(struct ipw_setup_open_packet),
> +				ADDR_SETUP_PROT,
> +				TL_PROTOCOLID_SETUP,
> +				TL_SETUP_SIGNO_OPEN_MSG);
> +		if (!open_packet)
> +			goto exit_nomem;
> +		open_packet->header.length = sizeof(struct TlSetupOpenMsg);
> +		open_packet->body.port_no = port;
> +		send_packet(hw, PRIO_SETUP, &open_packet->header);
> +	}
> +	for (channel_idx = 0;
> +			channel_idx < NL_NUM_OF_ADDRESSES; channel_idx++) {
> +		int ret;
> +
> +		ret = set_DTR(hw, PRIO_SETUP, channel_idx,
> +			(hw->control_lines[channel_idx] &
> +			 IPW_CONTROL_LINE_DTR) != 0);
> +		if (ret) {
> +			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
> +					"error setting DTR (%d)\n", ret);
> +			return;
> +		}
> +
> +		set_RTS(hw, PRIO_SETUP, channel_idx,
> +			(hw->control_lines [channel_idx] &
> +			 IPW_CONTROL_LINE_RTS) != 0);
> +		if (ret) {
> +			printk(KERN_ERR IPWIRELESS_PCCARD_NAME
> +					"error setting RTS (%d)\n", ret);
> +			return;
> +		}
> +	}
> +	/*
> +	 * For NDIS we assume that we are using sync PPP frames, for COM async.
> +	 * This driver uses NDIS mode too. We don't bother with translation
> +	 * from async -> sync PPP.
> +	 */
> +	info_packet = alloc_ctrl_packet(sizeof(struct ipw_setup_info_packet),
> +			ADDR_SETUP_PROT,
> +			TL_PROTOCOLID_SETUP,
> +			TL_SETUP_SIGNO_INFO_MSG);
> +	if (!info_packet)
> +		goto exit_nomem;
> +	info_packet->header.length = sizeof(struct TlSetupInfoMsg);
> +	info_packet->body.driver_type = NDISWAN_DRIVER;
> +	info_packet->body.major_version = NDISWAN_DRIVER_MAJOR_VERSION;
> +	info_packet->body.minor_version = NDISWAN_DRIVER_MINOR_VERSION;
> +	send_packet(hw, PRIO_SETUP, &info_packet->header);
> +
> +	/* Initialization is now complete, so we clear the 'to_setup' flag */
> +	hw->to_setup = 0;
> +
> +	return;
> +
> +exit_nomem:
> +	printk(KERN_ERR IPWIRELESS_PCCARD_NAME
> +			"not enough memory to alloc control packet\n");

Need ":" and/or space between CARD_NAME and following string.
(in several places)

> +	hw->to_setup = -1;
> +}
> +
> +static void handle_setup_get_version_rsp(struct ipw_hardware *hw,
> +		unsigned char vers_no)
> +{
> +	del_timer(&hw->setup_timer);
> +	hw->initializing = 0;
> +	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": card is ready.\n");
> +
> +	if (vers_no == TL_SETUP_VERSION)
> +		__handle_setup_get_version_rsp(hw);
> +	else
> +		printk(KERN_ERR
> +				IPWIRELESS_PCCARD_NAME
> +				": invalid hardware version no %u\n",
> +				(unsigned int) vers_no);
> +}
> +
...

> diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
> new file mode 100644
> index 0000000..cab5722
> --- /dev/null
> +++ b/drivers/char/pcmcia/ipwireless/main.c
> @@ -0,0 +1,496 @@
> +/*
> + * IPWireless 3G PCMCIA Network Driver
> + *
> + * Original code
> + *   by Stephen Blackheath <stephen@blacksapphire.com>,
> + *      Ben Martel <benm@symmetric.co.nz>
> + *
> + * Copyrighted as follows:
> + *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
> + *
> + * Various driver changes and rewrites, port to new kernels
> + *   Copyright (C) 2006-2007 Jiri Kosina
> + *
> + * Misc code cleanups and updates
> + *   Copyright (C) 2007 David Sterba
> + */
> +
> +#include "hardware.h"
> +#include "network.h"
> +#include "main.h"
> +#include "tty.h"
> +
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <pcmcia/version.h>
> +#include <pcmcia/cisreg.h>
> +#include <pcmcia/device_id.h>
> +#include <pcmcia/ss.h>
> +#include <pcmcia/ds.h>
> +#include <pcmcia/cs.h>
> +
> +static struct pcmcia_device_id ipw_ids[] = {
> +	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0100),
> +	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0200),
> +	PCMCIA_DEVICE_NULL
> +};
> +MODULE_DEVICE_TABLE(pcmcia, ipw_ids);
> +
> +static void ipwireless_detach(struct pcmcia_device *link);
> +
> +/* Module params */
> +int ipwireless_debug;
> +int ipwireless_loopback;
> +int ipwireless_out_queue = 1;
> +static int major;
> +
> +module_param(major, int, 0);
> +module_param(ipwireless_debug, int, 0);
> +module_param(ipwireless_loopback, int, 0);
> +module_param(ipwireless_out_queue, int, 0);
> +MODULE_PARM_DESC(major, "ttyIPWp major number [0]");
> +MODULE_PARM_DESC(ipwireless_debug, "switch on debug messages [0]");
> +MODULE_PARM_DESC(ipwireless_debug, "switch on loopback mode [0]");
> +MODULE_PARM_DESC(ipwireless_debug, "set size of outgoing queue [1]");

Will these parameters be documented anywhere?

HERE:
> diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
> new file mode 100644
> index 0000000..c16e928
> --- /dev/null
> +++ b/drivers/char/pcmcia/ipwireless/network.c
> @@ -0,0 +1,513 @@
> +/*
> + * IPWireless 3G PCMCIA Network Driver
> + *
> + * Original code
> + *   by Stephen Blackheath <stephen@blacksapphire.com>,
> + *      Ben Martel <benm@symmetric.co.nz>
> + *
> + * Copyrighted as follows:
> + *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
> + *
> + * Various driver changes and rewrites, port to new kernels
> + *   Copyright (C) 2006-2007 Jiri Kosina
> + *
> + * Misc code cleanups and updates
> + *   Copyright (C) 2007 David Sterba
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/mutex.h>
> +#include <linux/netdevice.h>
> +#include <linux/ppp_channel.h>
> +#include <linux/ppp_defs.h>
> +#include <linux/if_ppp.h>
> +#include <linux/skbuff.h>
> +
> +#include "network.h"
> +#include "hardware.h"
> +#include "main.h"
> +#include "tty.h"
> +
> +struct ipw_network {
> +	/* Hardware context, used for calls to hardware layer. */
> +	struct ipw_hardware *hardware;
> +	/* Context for kernel 'generic_ppp' functionality */
> +	struct ppp_channel *ppp_channel;
> +	/* tty context connected with IPW console */
> +	struct ipw_tty *associated_ttys[NO_OF_IPW_CHANNELS][MAX_ASSOCIATED_TTYS];
> +	/* True if ppp needs waking up once we're ready to xmit */
> +	int ppp_blocked;
> +	/* Number of packets queued up in hardware module. */
> +	int outgoing_packets_queued;
> +	/* Spinlock to avoid interrupts during shutdown */
> +	spinlock_t spinlock;
> +	struct mutex close_lock;
> +
> +	/* PPP ioctl data, not actually used anywere */
> +	unsigned int flags;
> +	unsigned int rbits;
> +	u32 xaccm[8];
> +	u32 raccm;
> +	int mru;
> +
> +	int shutting_down;
> +	unsigned int ras_control_lines;
> +
> +	struct work_struct work_go_online;
> +	struct work_struct work_go_offline;
> +};
> +
> +
> +#ifdef IPWIRELESS_STATE_DEBUG
> +int ipwireless_dump_network_state(char *p, struct ipw_network *network)
> +{
> +	int idx = 0;
> +
> +	idx += sprintf(p + idx, "debug: ppp_blocked=%d\n",
> +			network->ppp_blocked);
> +	idx += sprintf(p + idx, "debug: outgoing_packets_queued=%d\n",
> +			network->outgoing_packets_queued);
> +	idx += sprintf(p + idx, "debug: network.shutting_down=%d\n",
> +			network->shutting_down);

check for overflow of 'p'?

> +	return idx;
> +}
> +#endif
> +


> diff --git a/drivers/char/pcmcia/ipwireless/setup_protocol.h b/drivers/char/pcmcia/ipwireless/setup_protocol.h
> new file mode 100644
> index 0000000..46f2c57
> --- /dev/null
> +++ b/drivers/char/pcmcia/ipwireless/setup_protocol.h
> @@ -0,0 +1,108 @@
> +/*
> + * IPWireless 3G PCMCIA Network Driver
> + *
> + * Original code
> + *   by Stephen Blackheath <stephen@blacksapphire.com>,
> + *      Ben Martel <benm@symmetric.co.nz>
> + *
> + * Copyrighted as follows:
> + *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
> + *
> + * Various driver changes and rewrites, port to new kernels
> + *   Copyright (C) 2006-2007 Jiri Kosina
> + *
> + * Misc code cleanups and updates
> + *   Copyright (C) 2007 David Sterba
> + */
> +
> +#ifndef _IPWIRELESS_CS_SETUP_PROTOCOL_H_
> +#define _IPWIRELESS_CS_SETUP_PROTOCOL_H_
> +
> +/* Version of the setup protocol and transport protocols */
> +#define TL_SETUP_VERSION		1
> +
> +#define TL_SETUP_VERSION_QRY_TMO	1000
> +#define TL_SETUP_MAX_VERSION_QRY	30
> +
> +/* Message numbers 0-9 are obsoleted and must not be reused! */
> +#define TL_SETUP_SIGNO_GET_VERSION_QRY	10
> +#define TL_SETUP_SIGNO_GET_VERSION_RSP	11
> +#define TL_SETUP_SIGNO_CONFIG_MSG	12
> +#define TL_SETUP_SIGNO_CONFIG_DONE_MSG	13
> +#define TL_SETUP_SIGNO_OPEN_MSG		14
> +#define TL_SETUP_SIGNO_CLOSE_MSG	15
> +
> +#define TL_SETUP_SIGNO_INFO_MSG     20
> +#define TL_SETUP_SIGNO_INFO_MSG_ACK 21
> +
> +#define TL_SETUP_SIGNO_REBOOT_MSG      22
> +#define TL_SETUP_SIGNO_REBOOT_MSG_ACK  23
> +
> +/* Syncronous start-messages */

	Synchronous

> +struct TlSetupGetVersionQry {
> +	unsigned char sig_no;		/* TL_SETUP_SIGNO_GET_VERSION_QRY */
> +} __attribute__ ((__packed__));
> +

---
~Randy
