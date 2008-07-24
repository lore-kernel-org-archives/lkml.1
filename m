Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYGXAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYGXAk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYGXAkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:40:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:4059 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYGXAkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fYltaQUQxW5AwtUokqmZcsY7MeKD3IQ6HvrnqIKSDv1A+so03Ufc9L+rqkRIfE60dx
         yDcW2i0zyd14WfiCnKFKHH1nCEKQcsShV9flfWUE4iLdAFvQy+9O3T3TfC6dUH1hBtsf
         Yq1AenSKYODeyt7rgtUbtRMV7V3FpqxBaXVTU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <greg@kroah.com>
Subject: [PATCH] x86: usb debug port early console v3
Date: Wed, 23 Jul 2008 17:39:39 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com>
In-Reply-To: <200807231400.53957.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807231739.39620.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


based on work from Eric, and add some timeout so don't dead loop when debug
device is not installed

v2: fix checkpatch warning
v3: move ehci struct def to linux/usrb/ehci_def.h from host/ehci.h
    also add CONFIG_EARLY_PRINTK_DBGP to disable it by default

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt |    3 
 arch/x86/Kconfig.debug              |   13 
 arch/x86/kernel/early_printk.c      |  643 +++++++++++++++++++++++++++++++++++-
 drivers/usb/host/ehci.h             |  139 -------
 include/linux/usb/ehci_def.h        |  160 ++++++++
 5 files changed, 817 insertions(+), 141 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -654,11 +654,12 @@ and is between 256 and 4096 characters.
 	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=dbgp
 
 			Append ",keep" to not disable it when the real console
 			takes over.
 
-			Only vga or serial at a time, not both.
+			Only vga or serial or usb debug port at a time.
 
 			Currently only ttyS0 and ttyS1 are supported.
 
Index: linux-2.6/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6/arch/x86/kernel/early_printk.c
@@ -3,11 +3,19 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/screen_info.h>
+#include <linux/usb/ch9.h>
+#include <linux/pci_regs.h>
+#include <linux/pci_ids.h>
+#include <linux/errno.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
 #include <asm/setup.h>
 #include <xen/hvc-console.h>
+#include <asm/pci-direct.h>
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+#include <linux/usb/ehci_def.h>
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
@@ -78,6 +86,7 @@ static int early_serial_base = 0x3f8;  /
 static int early_serial_putc(unsigned char ch)
 {
 	unsigned timeout = 0xffff;
+
 	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
 		cpu_relax();
 	outb(ch, early_serial_base + TXR);
@@ -151,6 +160,602 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+
+static struct ehci_caps __iomem *ehci_caps;
+static struct ehci_regs __iomem *ehci_regs;
+static struct ehci_dbg_port __iomem *ehci_debug;
+static unsigned dbgp_endpoint_out;
+
+#define USB_DEBUG_DEVNUM 127
+
+#define DBGP_DATA_TOGGLE	0x8800
+
+static inline u32 dbgp_pid_update(u32 x, u32 tok)
+{
+	return ((x ^ DBGP_DATA_TOGGLE) & 0xffff00) | (tok & 0xff);
+}
+
+static inline u32 dbgp_len_update(u32 x, u32 len)
+{
+	return (x & ~0x0f) | (len & 0x0f);
+}
+
+/*
+ * USB Packet IDs (PIDs)
+ */
+
+/* token */
+#define USB_PID_OUT		0xe1
+#define USB_PID_IN		0x69
+#define USB_PID_SOF		0xa5
+#define USB_PID_SETUP		0x2d
+/* handshake */
+#define USB_PID_ACK		0xd2
+#define USB_PID_NAK		0x5a
+#define USB_PID_STALL		0x1e
+#define USB_PID_NYET		0x96
+/* data */
+#define USB_PID_DATA0		0xc3
+#define USB_PID_DATA1		0x4b
+#define USB_PID_DATA2		0x87
+#define USB_PID_MDATA		0x0f
+/* Special */
+#define USB_PID_PREAMBLE	0x3c
+#define USB_PID_ERR		0x3c
+#define USB_PID_SPLIT		0x78
+#define USB_PID_PING		0xb4
+#define USB_PID_UNDEF_0		0xf0
+
+#define USB_PID_DATA_TOGGLE	0x88
+#define DBGP_CLAIM (DBGP_OWNER | DBGP_ENABLED | DBGP_INUSE)
+
+#define PCI_CAP_ID_EHCI_DEBUG	0xa
+
+#define HUB_ROOT_RESET_TIME	50	/* times are in msec */
+#define HUB_SHORT_RESET_TIME	10
+#define HUB_LONG_RESET_TIME	200
+#define HUB_RESET_TIMEOUT	500
+
+#define DBGP_MAX_PACKET		8
+
+static int dbgp_wait_until_complete(void)
+{
+	unsigned ctrl;
+	int loop = 0x100000;
+
+	do {
+		ctrl = readl(&ehci_debug->control);
+		/* Stop when the transaction is finished */
+		if (ctrl & DBGP_DONE)
+			break;
+	} while (--loop > 0);
+
+	if (!loop)
+		return -1;
+
+	/* Now that we have observed the completed transaction,
+	 * clear the done bit.
+	 */
+	writel(ctrl | DBGP_DONE, &ehci_debug->control);
+	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
+}
+
+static void dbgp_mdelay(int ms)
+{
+	int i;
+
+	while (ms--) {
+		for (i = 0; i < 1000; i++)
+			outb(0x1, 0x80);
+	}
+}
+
+static void dbgp_breath(void)
+{
+	/* Sleep to give the debug port a chance to breathe */
+}
+
+static int dbgp_wait_until_done(unsigned ctrl)
+{
+	unsigned pids, lpid;
+	int ret;
+	int loop = 3;
+
+retry:
+	writel(ctrl | DBGP_GO, &ehci_debug->control);
+	ret = dbgp_wait_until_complete();
+	pids = readl(&ehci_debug->pids);
+	lpid = DBGP_PID_GET(pids);
+
+	if (ret < 0)
+		return ret;
+
+	/* If the port is getting full or it has dropped data
+	 * start pacing ourselves, not necessary but it's friendly.
+	 */
+	if ((lpid == USB_PID_NAK) || (lpid == USB_PID_NYET))
+		dbgp_breath();
+
+	/* If I get a NACK reissue the transmission */
+	if (lpid == USB_PID_NAK) {
+		if (--loop > 0)
+			goto retry;
+	}
+
+	return ret;
+}
+
+static void dbgp_set_data(const void *buf, int size)
+{
+	const unsigned char *bytes = buf;
+	unsigned lo, hi;
+	int i;
+
+	lo = hi = 0;
+	for (i = 0; i < 4 && i < size; i++)
+		lo |= bytes[i] << (8*i);
+	for (; i < 8 && i < size; i++)
+		hi |= bytes[i] << (8*(i - 4));
+	writel(lo, &ehci_debug->data03);
+	writel(hi, &ehci_debug->data47);
+}
+
+static void dbgp_get_data(void *buf, int size)
+{
+	unsigned char *bytes = buf;
+	unsigned lo, hi;
+	int i;
+
+	lo = readl(&ehci_debug->data03);
+	hi = readl(&ehci_debug->data47);
+	for (i = 0; i < 4 && i < size; i++)
+		bytes[i] = (lo >> (8*i)) & 0xff;
+	for (; i < 8 && i < size; i++)
+		bytes[i] = (hi >> (8*(i - 4))) & 0xff;
+}
+
+static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
+			 const char *bytes, int size)
+{
+	unsigned pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_OUT);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	dbgp_set_data(bytes, size);
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
+				 int size)
+{
+	unsigned pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_IN);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl &= ~DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+	if (size > ret)
+		size = ret;
+	dbgp_get_data(data, size);
+	return ret;
+}
+
+static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
+	int value, int index, void *data, int size)
+{
+	unsigned pids, addr, ctrl;
+	struct usb_ctrlrequest req;
+	int read;
+	int ret;
+
+	read = (requesttype & USB_DIR_IN) != 0;
+	if (size > (read ? DBGP_MAX_PACKET:0))
+		return -1;
+
+	/* Compute the control message */
+	req.bRequestType = requesttype;
+	req.bRequest = request;
+	req.wValue = value;
+	req.wIndex = index;
+	req.wLength = size;
+
+	pids = DBGP_PID_SET(USB_PID_DATA0, USB_PID_SETUP);
+	addr = DBGP_EPADDR(devnum, 0);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, sizeof(req));
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	/* Send the setup message */
+	dbgp_set_data(&req, sizeof(req));
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	/* Read the result */
+	ret = dbgp_bulk_read(devnum, 0, data, size);
+	return ret;
+}
+
+
+/* Find a PCI capability */
+static __u32 __init find_cap(int num, int slot, int func, int cap)
+{
+	u8 pos;
+	int bytes;
+
+	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
+		PCI_STATUS_CAP_LIST))
+		return 0;
+	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);
+	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
+		u8 id;
+		pos &= ~3;
+		id = read_pci_config_byte(num, slot, func, pos+PCI_CAP_LIST_ID);
+		if (id == 0xff)
+			break;
+		if (id == cap)
+			return pos;
+		pos = read_pci_config_byte(num, slot, func,
+						 pos+PCI_CAP_LIST_NEXT);
+	}
+	return 0;
+}
+
+static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned *rslot,
+				unsigned *rfunc)
+{
+	unsigned bus, slot, func;
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				u32 class;
+				unsigned cap;
+
+				class = read_pci_config(bus, slot, func,
+							 PCI_CLASS_REVISION);
+				if ((class >> 8) != PCI_CLASS_SERIAL_USB_EHCI)
+					continue;
+				cap = find_cap(bus, slot, func,
+						 PCI_CAP_ID_EHCI_DEBUG);
+				if (!cap)
+					continue;
+				if (ehci_num-- != 0)
+					continue;
+				*rbus = bus;
+				*rslot = slot;
+				*rfunc = func;
+				return cap;
+			}
+		}
+	}
+	return 0;
+}
+
+static int ehci_reset_port(int port)
+{
+	unsigned portsc;
+	unsigned delay_time, delay;
+	int loop;
+
+	/* Reset the usb debug port */
+	portsc = readl(&ehci_regs->port_status[port - 1]);
+	portsc &= ~PORT_PE;
+	portsc |= PORT_RESET;
+	writel(portsc, &ehci_regs->port_status[port - 1]);
+
+	delay = HUB_ROOT_RESET_TIME;
+	for (delay_time = 0; delay_time < HUB_RESET_TIMEOUT;
+	     delay_time += delay) {
+		dbgp_mdelay(delay);
+
+		portsc = readl(&ehci_regs->port_status[port - 1]);
+		if (portsc & PORT_RESET) {
+			/* force reset to complete */
+			loop = 2;
+			writel(portsc & ~(PORT_RWC_BITS | PORT_RESET),
+				&ehci_regs->port_status[port - 1]);
+			do {
+				portsc = readl(&ehci_regs->port_status[port-1]);
+			} while ((portsc & PORT_RESET) && (--loop > 0));
+		}
+
+		/* Device went away? */
+		if (!(portsc & PORT_CONNECT))
+			return -ENOTCONN;
+
+		/* bomb out completely if something weird happend */
+		if ((portsc & PORT_CSC))
+			return -EINVAL;
+
+		/* If we've finished resetting, then break out of the loop */
+		if (!(portsc & PORT_RESET) && (portsc & PORT_PE))
+			return 0;
+	}
+	return -EBUSY;
+}
+
+static int ehci_wait_for_port(int port)
+{
+	unsigned status;
+	int ret, reps;
+
+	for (reps = 0; reps < 3; reps++) {
+		dbgp_mdelay(100);
+		status = readl(&ehci_regs->status);
+		if (status & STS_PCD) {
+			ret = ehci_reset_port(port);
+			if (ret == 0)
+				return 0;
+		}
+	}
+	return -ENOTCONN;
+}
+
+#ifdef DBGP_DEBUG
+# define dbgp_printk early_printk
+#else
+static inline void dbgp_printk(const char *fmt, ...) { }
+#endif
+
+static int ehci_setup(void)
+{
+	unsigned cmd, ctrl, status, portsc, hcs_params, debug_port, n_ports;
+	int ret;
+	int loop;
+
+	hcs_params = readl(&ehci_caps->hcs_params);
+	debug_port = HCS_DEBUG_PORT(hcs_params);
+	n_ports    = HCS_N_PORTS(hcs_params);
+
+	dbgp_printk("debug_port: %d\n", debug_port);
+	dbgp_printk("n_ports:    %d\n", n_ports);
+
+	loop = 10;
+	/* Reset the EHCI controller */
+	cmd = readl(&ehci_regs->command);
+	cmd |= CMD_RESET;
+	writel(cmd, &ehci_regs->command);
+	do {
+		cmd = readl(&ehci_regs->command);
+	} while ((cmd & CMD_RESET) && (--loop > 0));
+
+	/* Claim ownership, but do not enable yet */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_OWNER;
+	ctrl &= ~(DBGP_ENABLED | DBGP_INUSE);
+	writel(ctrl, &ehci_debug->control);
+
+	/* Start the ehci running */
+	cmd = readl(&ehci_regs->command);
+	cmd &= ~(CMD_LRESET | CMD_IAAD | CMD_PSE | CMD_ASE | CMD_RESET);
+	cmd |= CMD_RUN;
+	writel(cmd, &ehci_regs->command);
+
+	/* Ensure everything is routed to the EHCI */
+	writel(FLAG_CF, &ehci_regs->configured_flag);
+
+	/* Wait until the controller is no longer halted */
+	loop = 10;
+	do {
+		status = readl(&ehci_regs->status);
+	} while ((status & STS_HALT) && (--loop > 0));
+
+	/* Wait for a device to show up in the debug port */
+	ret = ehci_wait_for_port(debug_port);
+	if (ret < 0) {
+		dbgp_printk("No device found in debug port\n");
+		return -1;
+	}
+
+	/* Enable the debug port */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_CLAIM;
+	writel(ctrl, &ehci_debug->control);
+	ctrl = readl(&ehci_debug->control);
+	if ((ctrl & DBGP_CLAIM) != DBGP_CLAIM) {
+		dbgp_printk("No device in debug port\n");
+		writel(ctrl & ~DBGP_CLAIM, &ehci_debug->control);
+		return -1;
+
+	}
+
+	/* Completely transfer the debug device to the debug controller */
+	portsc = readl(&ehci_regs->port_status[debug_port - 1]);
+	portsc &= ~PORT_PE;
+	writel(portsc, &ehci_regs->port_status[debug_port - 1]);
+
+	return 0;
+}
+
+static int __init early_dbgp_init(char *s)
+{
+	struct usb_debug_descriptor dbgp_desc;
+	void __iomem *ehci_bar;
+	unsigned ctrl, devnum;
+	unsigned bus, slot, func, cap;
+	unsigned debug_port, bar, offset;
+	unsigned bar_val;
+	char *e;
+	int ret;
+	unsigned dbgp_num;
+
+	if (!early_pci_allowed())
+		return -1;
+
+	dbgp_num = 0;
+	if (*s)
+		dbgp_num = simple_strtoul(s, &e, 10);
+	dbgp_printk("dbgp_num: %d\n", dbgp_num);
+	cap = find_dbgp(dbgp_num, &bus, &slot, &func);
+	if (!cap)
+		return -1;
+
+	dbgp_printk("Found EHCI debug port\n");
+
+	debug_port = read_pci_config(bus, slot, func, cap);
+	bar = (debug_port >> 29) & 0x7;
+	bar = (bar * 4) + 0xc;
+	offset = (debug_port >> 16) & 0xfff;
+	dbgp_printk("bar: %02x offset: %03x\n", bar, offset);
+	if (bar != PCI_BASE_ADDRESS_0) {
+		dbgp_printk("only debug ports on bar 1 handled.\n");
+		return -1;
+	}
+
+	bar_val = read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_0);
+	dbgp_printk("bar_val: %02x offset: %03x\n", bar_val, offset);
+	if (bar_val & ~PCI_BASE_ADDRESS_MEM_MASK) {
+		dbgp_printk("only simple 32bit mmio bars supported\n");
+		return -1;
+	}
+
+
+	/* FIXME I don't have the bar size so just guess PAGE_SIZE is more
+	 * than enough.  1K is the biggest I have seen.
+	 */
+	set_fixmap_nocache(FIX_DBGP_BASE, bar_val & PAGE_MASK);
+	ehci_bar = (void __iomem *)__fix_to_virt(FIX_DBGP_BASE);
+	ehci_bar += bar_val & ~PAGE_MASK;
+	dbgp_printk("ehci_bar: %p\n", ehci_bar);
+
+	ehci_caps  = ehci_bar;
+	ehci_regs  = ehci_bar + HC_LENGTH(readl(&ehci_caps->hc_capbase));
+	ehci_debug = ehci_bar + offset;
+
+	ret = ehci_setup();
+	if (ret < 0) {
+		dbgp_printk("ehci_setup failed\n");
+		ehci_debug = 0;
+		return -1;
+	}
+	dbgp_mdelay(100);
+
+	/* Find the debug device and make it device number 127 */
+	for (devnum = 0; devnum <= 127; devnum++) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_GET_DESCRIPTOR, (USB_DT_DEBUG << 8), 0,
+			&dbgp_desc, sizeof(dbgp_desc));
+		if (ret > 0)
+			break;
+	}
+	if (devnum > 127) {
+		dbgp_printk("Could not find attached debug device\n");
+		goto err;
+	}
+	if (ret < 0) {
+		dbgp_printk("Attached device is not a debug device\n");
+		goto err;
+	}
+	dbgp_endpoint_out = dbgp_desc.bDebugOutEndpoint;
+
+	/* Move the device to 127 if it isn't already there */
+	if (devnum != USB_DEBUG_DEVNUM) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_SET_ADDRESS, USB_DEBUG_DEVNUM, 0, NULL, 0);
+		if (ret < 0) {
+			dbgp_printk("Could not move attached device to %d\n",
+				USB_DEBUG_DEVNUM);
+			goto err;
+		}
+		devnum = USB_DEBUG_DEVNUM;
+	}
+
+	/* Enable the debug interface */
+	ret = dbgp_control_msg(USB_DEBUG_DEVNUM,
+		USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+		USB_REQ_SET_FEATURE, USB_DEVICE_DEBUG_MODE, 0, NULL, 0);
+	if (ret < 0) {
+		dbgp_printk(" Could not enable the debug device\n");
+		goto err;
+	}
+
+	/* Perform a small write to get the even/odd data state in sync
+	 */
+	ret = dbgp_bulk_write(USB_DEBUG_DEVNUM, dbgp_endpoint_out, " ", 1);
+	if (ret < 0) {
+		dbgp_printk("dbgp_bulk_write failed: %d\n", ret);
+		goto err;
+	}
+
+
+	return 0;
+err:
+	/* Things didn't work so remove my claim */
+	ctrl = readl(&ehci_debug->control);
+	ctrl &= ~(DBGP_CLAIM | DBGP_OUT);
+	writel(ctrl, &ehci_debug->control);
+	ehci_debug = 0;
+
+	return -1;
+}
+
+static void early_dbgp_write(struct console *con, const char *str, unsigned n)
+{
+	int chunk, ret;
+
+	if (!ehci_debug)
+		return;
+	while (n > 0) {
+		chunk = n;
+		if (chunk > DBGP_MAX_PACKET)
+			chunk = DBGP_MAX_PACKET;
+		ret = dbgp_bulk_write(USB_DEBUG_DEVNUM,
+			dbgp_endpoint_out, str, chunk);
+		str += chunk;
+		n -= chunk;
+	}
+}
+
+static struct console early_dbgp_console = {
+	.name =		"earlydbg",
+	.write =	early_dbgp_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+#endif
+
 /* Console interface to a host file on AMD's SimNow! */
 
 static int simnow_fd;
@@ -165,6 +770,7 @@ enum {
 static noinline long simnow(long cmd, long a, long b, long c)
 {
 	long ret;
+
 	asm volatile("cpuid" :
 		     "=a" (ret) :
 		     "b" (a), "c" (b), "d" (c), "0" (MAGIC1), "D" (cmd + MAGIC2));
@@ -174,6 +780,7 @@ static noinline long simnow(long cmd, lo
 static void __init simnow_init(char *str)
 {
 	char *fn = "klog";
+
 	if (*str == '=')
 		fn = ++str;
 	/* error ignored */
@@ -208,10 +815,11 @@ asmlinkage void early_printk(const char
 	va_end(ap);
 }
 
-static int __initdata keep_early;
 
 static int __init setup_early_printk(char *buf)
 {
+	int keep_early;
+
 	if (!buf)
 		return 0;
 
@@ -219,8 +827,7 @@ static int __init setup_early_printk(cha
 		return 0;
 	early_console_initialized = 1;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
+	keep_early = (strstr(buf, "keep") != NULL);
 
 	if (!strncmp(buf, "serial", 6)) {
 		early_serial_init(buf + 6);
@@ -238,6 +845,17 @@ static int __init setup_early_printk(cha
 		simnow_init(buf + 6);
 		early_console = &simnow_console;
 		keep_early = 1;
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+	} else if (!strncmp(buf, "dbgp", 4)) {
+		if (early_dbgp_init(buf+4) < 0)
+			return 0;
+		early_console = &early_dbgp_console;
+		/*
+		 * usb subsys will reset ehci controller, so don't keep
+		 * that early console
+		 */
+		keep_early = 0;
+#endif
 #ifdef CONFIG_HVC_XEN
 	} else if (!strncmp(buf, "xen", 3)) {
 		early_console = &xenboot_console;
@@ -251,4 +869,23 @@ static int __init setup_early_printk(cha
 	register_console(early_console);
 	return 0;
 }
+
+void __init enable_debug_console(char *buf)
+{
+#ifdef DBGP_DEBUG
+	struct console *old_early_console = NULL;
+
+	if (early_console_initialized && early_console) {
+		old_early_console = early_console;
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	}
+
+	setup_early_printk(buf);
+
+	if (early_console == old_early_console && old_early_console)
+		register_console(old_early_console);
+#endif
+}
+
 early_param("earlyprintk", setup_early_printk);
Index: linux-2.6/drivers/usb/host/ehci.h
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci.h
+++ linux-2.6/drivers/usb/host/ehci.h
@@ -210,146 +210,11 @@ timer_action (struct ehci_hcd *ehci, enu
 
 /*-------------------------------------------------------------------------*/
 
-/* EHCI register interface, corresponds to EHCI Revision 0.95 specification */
-
-/* Section 2.2 Host Controller Capability Registers */
-struct ehci_caps {
-	/* these fields are specified as 8 and 16 bit registers,
-	 * but some hosts can't perform 8 or 16 bit PCI accesses.
-	 */
-	u32		hc_capbase;
-#define HC_LENGTH(p)		(((p)>>00)&0x00ff)	/* bits 7:0 */
-#define HC_VERSION(p)		(((p)>>16)&0xffff)	/* bits 31:16 */
-	u32		hcs_params;     /* HCSPARAMS - offset 0x4 */
-#define HCS_DEBUG_PORT(p)	(((p)>>20)&0xf)	/* bits 23:20, debug port? */
-#define HCS_INDICATOR(p)	((p)&(1 << 16))	/* true: has port indicators */
-#define HCS_N_CC(p)		(((p)>>12)&0xf)	/* bits 15:12, #companion HCs */
-#define HCS_N_PCC(p)		(((p)>>8)&0xf)	/* bits 11:8, ports per CC */
-#define HCS_PORTROUTED(p)	((p)&(1 << 7))	/* true: port routing */
-#define HCS_PPC(p)		((p)&(1 << 4))	/* true: port power control */
-#define HCS_N_PORTS(p)		(((p)>>0)&0xf)	/* bits 3:0, ports on HC */
-
-	u32		hcc_params;      /* HCCPARAMS - offset 0x8 */
-#define HCC_EXT_CAPS(p)		(((p)>>8)&0xff)	/* for pci extended caps */
-#define HCC_ISOC_CACHE(p)       ((p)&(1 << 7))  /* true: can cache isoc frame */
-#define HCC_ISOC_THRES(p)       (((p)>>4)&0x7)  /* bits 6:4, uframes cached */
-#define HCC_CANPARK(p)		((p)&(1 << 2))  /* true: can park on async qh */
-#define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
-#define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
-	u8		portroute [8];	 /* nibbles for routing - offset 0xC */
-} __attribute__ ((packed));
-
-
-/* Section 2.3 Host Controller Operational Registers */
-struct ehci_regs {
-
-	/* USBCMD: offset 0x00 */
-	u32		command;
-/* 23:16 is r/w intr rate, in microframes; default "8" == 1/msec */
-#define CMD_PARK	(1<<11)		/* enable "park" on async qh */
-#define CMD_PARK_CNT(c)	(((c)>>8)&3)	/* how many transfers to park for */
-#define CMD_LRESET	(1<<7)		/* partial reset (no ports, etc) */
-#define CMD_IAAD	(1<<6)		/* "doorbell" interrupt async advance */
-#define CMD_ASE		(1<<5)		/* async schedule enable */
-#define CMD_PSE		(1<<4)		/* periodic schedule enable */
-/* 3:2 is periodic frame list size */
-#define CMD_RESET	(1<<1)		/* reset HC not bus */
-#define CMD_RUN		(1<<0)		/* start/stop HC */
-
-	/* USBSTS: offset 0x04 */
-	u32		status;
-#define STS_ASS		(1<<15)		/* Async Schedule Status */
-#define STS_PSS		(1<<14)		/* Periodic Schedule Status */
-#define STS_RECL	(1<<13)		/* Reclamation */
-#define STS_HALT	(1<<12)		/* Not running (any reason) */
-/* some bits reserved */
-	/* these STS_* flags are also intr_enable bits (USBINTR) */
-#define STS_IAA		(1<<5)		/* Interrupted on async advance */
-#define STS_FATAL	(1<<4)		/* such as some PCI access errors */
-#define STS_FLR		(1<<3)		/* frame list rolled over */
-#define STS_PCD		(1<<2)		/* port change detect */
-#define STS_ERR		(1<<1)		/* "error" completion (overflow, ...) */
-#define STS_INT		(1<<0)		/* "normal" completion (short, ...) */
-
-	/* USBINTR: offset 0x08 */
-	u32		intr_enable;
-
-	/* FRINDEX: offset 0x0C */
-	u32		frame_index;	/* current microframe number */
-	/* CTRLDSSEGMENT: offset 0x10 */
-	u32		segment;	/* address bits 63:32 if needed */
-	/* PERIODICLISTBASE: offset 0x14 */
-	u32		frame_list;	/* points to periodic list */
-	/* ASYNCLISTADDR: offset 0x18 */
-	u32		async_next;	/* address of next async queue head */
-
-	u32		reserved [9];
-
-	/* CONFIGFLAG: offset 0x40 */
-	u32		configured_flag;
-#define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
-
-	/* PORTSC: offset 0x44 */
-	u32		port_status [0];	/* up to N_PORTS */
-/* 31:23 reserved */
-#define PORT_WKOC_E	(1<<22)		/* wake on overcurrent (enable) */
-#define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
-#define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
-/* 19:16 for port testing */
-#define PORT_LED_OFF	(0<<14)
-#define PORT_LED_AMBER	(1<<14)
-#define PORT_LED_GREEN	(2<<14)
-#define PORT_LED_MASK	(3<<14)
-#define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
-#define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
-#define PORT_USB11(x) (((x)&(3<<10))==(1<<10))	/* USB 1.1 device */
-/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
-/* 9 reserved */
-#define PORT_RESET	(1<<8)		/* reset port */
-#define PORT_SUSPEND	(1<<7)		/* suspend port */
-#define PORT_RESUME	(1<<6)		/* resume it */
-#define PORT_OCC	(1<<5)		/* over current change */
-#define PORT_OC		(1<<4)		/* over current active */
-#define PORT_PEC	(1<<3)		/* port enable change */
-#define PORT_PE		(1<<2)		/* port enable */
-#define PORT_CSC	(1<<1)		/* connect status change */
-#define PORT_CONNECT	(1<<0)		/* device connected */
-#define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
-} __attribute__ ((packed));
-
-#define USBMODE		0x68		/* USB Device mode */
-#define USBMODE_SDIS	(1<<3)		/* Stream disable */
-#define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
-#define USBMODE_CM_HC	(3<<0)		/* host controller mode */
-#define USBMODE_CM_IDLE	(0<<0)		/* idle state */
-
-/* Appendix C, Debug port ... intended for use with special "debug devices"
- * that can help if there's no serial console.  (nonstandard enumeration.)
- */
-struct ehci_dbg_port {
-	u32	control;
-#define DBGP_OWNER	(1<<30)
-#define DBGP_ENABLED	(1<<28)
-#define DBGP_DONE	(1<<16)
-#define DBGP_INUSE	(1<<10)
-#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
-#	define DBGP_ERR_BAD	1
-#	define DBGP_ERR_SIGNAL	2
-#define DBGP_ERROR	(1<<6)
-#define DBGP_GO		(1<<5)
-#define DBGP_OUT	(1<<4)
-#define DBGP_LEN(x)	(((x)>>0)&0x0f)
-	u32	pids;
-#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
-#define DBGP_PID_SET(data,tok)	(((data)<<8)|(tok))
-	u32	data03;
-	u32	data47;
-	u32	address;
-#define DBGP_EPADDR(dev,ep)	(((dev)<<8)|(ep))
-} __attribute__ ((packed));
+#include <linux/usb/ehci_def.h>
 
 /*-------------------------------------------------------------------------*/
 
+
 #define	QTD_NEXT(ehci, dma)	cpu_to_hc32(ehci, (u32)dma)
 
 /*
Index: linux-2.6/include/linux/usb/ehci_def.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/usb/ehci_def.h
@@ -0,0 +1,160 @@
+/*
+ * Copyright (c) 2001-2002 by David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __LINUX_USB_EHCI_DEF_H
+#define __LINUX_USB_EHCI_DEF_H
+
+/* EHCI register interface, corresponds to EHCI Revision 0.95 specification */
+
+/* Section 2.2 Host Controller Capability Registers */
+struct ehci_caps {
+	/* these fields are specified as 8 and 16 bit registers,
+	 * but some hosts can't perform 8 or 16 bit PCI accesses.
+	 */
+	u32		hc_capbase;
+#define HC_LENGTH(p)		(((p)>>00)&0x00ff)	/* bits 7:0 */
+#define HC_VERSION(p)		(((p)>>16)&0xffff)	/* bits 31:16 */
+	u32		hcs_params;     /* HCSPARAMS - offset 0x4 */
+#define HCS_DEBUG_PORT(p)	(((p)>>20)&0xf)	/* bits 23:20, debug port? */
+#define HCS_INDICATOR(p)	((p)&(1 << 16))	/* true: has port indicators */
+#define HCS_N_CC(p)		(((p)>>12)&0xf)	/* bits 15:12, #companion HCs */
+#define HCS_N_PCC(p)		(((p)>>8)&0xf)	/* bits 11:8, ports per CC */
+#define HCS_PORTROUTED(p)	((p)&(1 << 7))	/* true: port routing */
+#define HCS_PPC(p)		((p)&(1 << 4))	/* true: port power control */
+#define HCS_N_PORTS(p)		(((p)>>0)&0xf)	/* bits 3:0, ports on HC */
+
+	u32		hcc_params;      /* HCCPARAMS - offset 0x8 */
+#define HCC_EXT_CAPS(p)		(((p)>>8)&0xff)	/* for pci extended caps */
+#define HCC_ISOC_CACHE(p)       ((p)&(1 << 7))  /* true: can cache isoc frame */
+#define HCC_ISOC_THRES(p)       (((p)>>4)&0x7)  /* bits 6:4, uframes cached */
+#define HCC_CANPARK(p)		((p)&(1 << 2))  /* true: can park on async qh */
+#define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
+#define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
+	u8		portroute [8];	 /* nibbles for routing - offset 0xC */
+} __attribute__ ((packed));
+
+
+/* Section 2.3 Host Controller Operational Registers */
+struct ehci_regs {
+
+	/* USBCMD: offset 0x00 */
+	u32		command;
+/* 23:16 is r/w intr rate, in microframes; default "8" == 1/msec */
+#define CMD_PARK	(1<<11)		/* enable "park" on async qh */
+#define CMD_PARK_CNT(c)	(((c)>>8)&3)	/* how many transfers to park for */
+#define CMD_LRESET	(1<<7)		/* partial reset (no ports, etc) */
+#define CMD_IAAD	(1<<6)		/* "doorbell" interrupt async advance */
+#define CMD_ASE		(1<<5)		/* async schedule enable */
+#define CMD_PSE		(1<<4)		/* periodic schedule enable */
+/* 3:2 is periodic frame list size */
+#define CMD_RESET	(1<<1)		/* reset HC not bus */
+#define CMD_RUN		(1<<0)		/* start/stop HC */
+
+	/* USBSTS: offset 0x04 */
+	u32		status;
+#define STS_ASS		(1<<15)		/* Async Schedule Status */
+#define STS_PSS		(1<<14)		/* Periodic Schedule Status */
+#define STS_RECL	(1<<13)		/* Reclamation */
+#define STS_HALT	(1<<12)		/* Not running (any reason) */
+/* some bits reserved */
+	/* these STS_* flags are also intr_enable bits (USBINTR) */
+#define STS_IAA		(1<<5)		/* Interrupted on async advance */
+#define STS_FATAL	(1<<4)		/* such as some PCI access errors */
+#define STS_FLR		(1<<3)		/* frame list rolled over */
+#define STS_PCD		(1<<2)		/* port change detect */
+#define STS_ERR		(1<<1)		/* "error" completion (overflow, ...) */
+#define STS_INT		(1<<0)		/* "normal" completion (short, ...) */
+
+	/* USBINTR: offset 0x08 */
+	u32		intr_enable;
+
+	/* FRINDEX: offset 0x0C */
+	u32		frame_index;	/* current microframe number */
+	/* CTRLDSSEGMENT: offset 0x10 */
+	u32		segment;	/* address bits 63:32 if needed */
+	/* PERIODICLISTBASE: offset 0x14 */
+	u32		frame_list;	/* points to periodic list */
+	/* ASYNCLISTADDR: offset 0x18 */
+	u32		async_next;	/* address of next async queue head */
+
+	u32		reserved [9];
+
+	/* CONFIGFLAG: offset 0x40 */
+	u32		configured_flag;
+#define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
+
+	/* PORTSC: offset 0x44 */
+	u32		port_status [0];	/* up to N_PORTS */
+/* 31:23 reserved */
+#define PORT_WKOC_E	(1<<22)		/* wake on overcurrent (enable) */
+#define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
+#define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
+/* 19:16 for port testing */
+#define PORT_LED_OFF	(0<<14)
+#define PORT_LED_AMBER	(1<<14)
+#define PORT_LED_GREEN	(2<<14)
+#define PORT_LED_MASK	(3<<14)
+#define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
+#define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
+#define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
+/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
+/* 9 reserved */
+#define PORT_RESET	(1<<8)		/* reset port */
+#define PORT_SUSPEND	(1<<7)		/* suspend port */
+#define PORT_RESUME	(1<<6)		/* resume it */
+#define PORT_OCC	(1<<5)		/* over current change */
+#define PORT_OC		(1<<4)		/* over current active */
+#define PORT_PEC	(1<<3)		/* port enable change */
+#define PORT_PE		(1<<2)		/* port enable */
+#define PORT_CSC	(1<<1)		/* connect status change */
+#define PORT_CONNECT	(1<<0)		/* device connected */
+#define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
+} __attribute__ ((packed));
+
+#define USBMODE		0x68		/* USB Device mode */
+#define USBMODE_SDIS	(1<<3)		/* Stream disable */
+#define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
+#define USBMODE_CM_HC	(3<<0)		/* host controller mode */
+#define USBMODE_CM_IDLE	(0<<0)		/* idle state */
+
+/* Appendix C, Debug port ... intended for use with special "debug devices"
+ * that can help if there's no serial console.  (nonstandard enumeration.)
+ */
+struct ehci_dbg_port {
+	u32	control;
+#define DBGP_OWNER	(1<<30)
+#define DBGP_ENABLED	(1<<28)
+#define DBGP_DONE	(1<<16)
+#define DBGP_INUSE	(1<<10)
+#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
+#	define DBGP_ERR_BAD	1
+#	define DBGP_ERR_SIGNAL	2
+#define DBGP_ERROR	(1<<6)
+#define DBGP_GO		(1<<5)
+#define DBGP_OUT	(1<<4)
+#define DBGP_LEN(x)	(((x)>>0)&0x0f)
+	u32	pids;
+#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
+#define DBGP_PID_SET(data, tok)	(((data)<<8)|(tok))
+	u32	data03;
+	u32	data47;
+	u32	address;
+#define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
+} __attribute__ ((packed));
+
+#endif /* __LINUX_USB_EHCI_DEF_H */
Index: linux-2.6/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.debug
+++ linux-2.6/arch/x86/Kconfig.debug
@@ -43,6 +43,19 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
+config EARLY_PRINTK_DBGP
+	bool "Early printk via EHCI debug port"
+	default n
+	depends on EARLY_PRINTK
+	help
+	  Write kernel log output directly into the EHCI debug port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash. You need usb debug device.
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
