Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0CBAtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:49:20 -0500
Received: from mga06.intel.com ([134.134.136.21]:31161 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809Ab0CBAtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208,223";a="600349965"
Date: Mon, 1 Mar 2010 16:48:53 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
Message-ID: <20100302004853.GA12244@xanatos>
References: <20100225190452.GA4184@xanatos>
 <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org>
 <20100225195249.GA5245@xanatos>
 <4B86FBB0.1080104@maroy.hu>
 <20100226001621.GA6060@xanatos>
 <4B88D183.9000006@maroy.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B88D183.9000006@maroy.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Feb 27, 2010 at 09:02:11AM +0100, Ákos Maróy wrote:
> Sarah,
> 
> > Actually, I wonder if 2.6.32 stable needs commit bcef3fd from 2.6.33.
> > If the xHCI driver wasn't cleaning up the endpoint rings properly after
> > a transfer error, I suppose the hardware could get wedged.
> 
> I see. where would I get this commit from? I have to stick with 2.6.32,
> as I'm using the binary ATI video driver, which doesn't work with 2.6.33...
> 
> > If the hardware wasn't responding properly to commands, then URBs
> > wouldn't have been able to be killed, the USB core would have sat around
> > waiting on those URBs, and rmmod could never exit.  I need a more
> > detailed log to figure out exactly why the hardware is wedged though.
> > Let me make the less-verbose debugging patch so you don't get log
> > corruption, and then we'll see what's going on.
> 
> let me know how I can use this..

Akos,

I've attached two patches that apply against 2.6.32.9.  The first limits
the amount of debugging from the xHCI driver to prevent log file
corruption.  The second is a backport of the commit bcef3fd from Linus'
2.6.33 tree.  I think this is the fix you need, but I can't be sure
until I see the complete log from the first patch.

Please apply the first patch, recompile with
CONFIG_USB_XHCI_HCD_DEBUGGING=y, and send me the results of `tail -f
/var/log/kern.log | tee /tmp/xhci-hp-envy-15.log`.  You'll need to load
the xHCI driver with the log_level module parameter set to 1095, like
so:

sudo insmod drivers/usb/host/xhci.ko log_level=1095

That will limit the debugging to output that relates to errors on
transfer events, hardware quirks, commands sent to the hardware, and
port status reporting.

When the driver is running, try an unplug of your USB DVD device and an
xHCI driver module remove.

Then apply the second patch, recompile, and do the same experiment.

Thanks,
Sarah Sharp

--tKW2IUtsqtDRztdT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-xhci-Add-logging-levels-and-reduce-excessive-verbosi.patch"

>From fa51d5ea582c988f0f8f202749fbc42382b224ba Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Mon, 1 Mar 2010 16:23:53 -0800
Subject: [PATCH 1/2] xhci: Add logging levels and reduce excessive verbosity.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-dbg.c  |  280 ++++++++++++++++++++++++++++--------------
 drivers/usb/host/xhci-hcd.c  |  263 ++++++++++++++++++++-------------------
 drivers/usb/host/xhci-hub.c  |   21 +++-
 drivers/usb/host/xhci-mem.c  |   87 ++++---------
 drivers/usb/host/xhci-pci.c  |   15 +--
 drivers/usb/host/xhci-ring.c |  213 ++++++++++++++++----------------
 drivers/usb/host/xhci.h      |   31 ++++-
 7 files changed, 500 insertions(+), 410 deletions(-)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 33128d5..ae71c56 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -30,80 +30,106 @@ void xhci_dbg_regs(struct xhci_hcd *xhci)
 {
 	u32 temp;
 
-	xhci_dbg(xhci, "// xHCI capability registers at %p:\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"xHCI capability registers at %p:\n",
 			xhci->cap_regs);
 	temp = xhci_readl(xhci, &xhci->cap_regs->hc_capbase);
-	xhci_dbg(xhci, "// @%p = 0x%x (CAPLENGTH AND HCIVERSION)\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"@%p = 0x%x (CAPLENGTH AND HCIVERSION)\n",
 			&xhci->cap_regs->hc_capbase, temp);
-	xhci_dbg(xhci, "//   CAPLENGTH: 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"   CAPLENGTH: 0x%x\n",
 			(unsigned int) HC_LENGTH(temp));
 #if 0
 	xhci_dbg(xhci, "//   HCIVERSION: 0x%x\n",
 			(unsigned int) HC_VERSION(temp));
 #endif
 
-	xhci_dbg(xhci, "// xHCI operational registers at %p:\n", xhci->op_regs);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+		       "xHCI operational registers at %p:\n", xhci->op_regs);
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->run_regs_off);
-	xhci_dbg(xhci, "// @%p = 0x%x RTSOFF\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+		       "@%p = 0x%x RTSOFF\n",
 			&xhci->cap_regs->run_regs_off,
 			(unsigned int) temp & RTSOFF_MASK);
-	xhci_dbg(xhci, "// xHCI runtime registers at %p:\n", xhci->run_regs);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"xHCI runtime registers at %p:\n", xhci->run_regs);
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->db_off);
-	xhci_dbg(xhci, "// @%p = 0x%x DBOFF\n", &xhci->cap_regs->db_off, temp);
-	xhci_dbg(xhci, "// Doorbell array at %p:\n", xhci->dba);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"@%p = 0x%x DBOFF\n", &xhci->cap_regs->db_off, temp);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"Doorbell array at %p:\n", xhci->dba);
 }
 
 static void xhci_print_cap_regs(struct xhci_hcd *xhci)
 {
 	u32 temp;
 
-	xhci_dbg(xhci, "xHCI capability registers at %p:\n", xhci->cap_regs);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"xHCI capability registers at %p:\n", xhci->cap_regs);
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->hc_capbase);
-	xhci_dbg(xhci, "CAPLENGTH AND HCIVERSION 0x%x:\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"CAPLENGTH AND HCIVERSION 0x%x:\n",
 			(unsigned int) temp);
-	xhci_dbg(xhci, "CAPLENGTH: 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"CAPLENGTH: 0x%x\n",
 			(unsigned int) HC_LENGTH(temp));
-	xhci_dbg(xhci, "HCIVERSION: 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"HCIVERSION: 0x%x\n",
 			(unsigned int) HC_VERSION(temp));
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params1);
-	xhci_dbg(xhci, "HCSPARAMS 1: 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"HCSPARAMS 1: 0x%x\n",
 			(unsigned int) temp);
-	xhci_dbg(xhci, "  Max device slots: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Max device slots: %u\n",
 			(unsigned int) HCS_MAX_SLOTS(temp));
-	xhci_dbg(xhci, "  Max interrupters: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Max interrupters: %u\n",
 			(unsigned int) HCS_MAX_INTRS(temp));
-	xhci_dbg(xhci, "  Max ports: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Max ports: %u\n",
 			(unsigned int) HCS_MAX_PORTS(temp));
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params2);
-	xhci_dbg(xhci, "HCSPARAMS 2: 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"HCSPARAMS 2: 0x%x\n",
 			(unsigned int) temp);
-	xhci_dbg(xhci, "  Isoc scheduling threshold: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Isoc scheduling threshold: %u\n",
 			(unsigned int) HCS_IST(temp));
-	xhci_dbg(xhci, "  Maximum allowed segments in event ring: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Maximum allowed segments in event ring: %u\n",
 			(unsigned int) HCS_ERST_MAX(temp));
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->hcs_params3);
-	xhci_dbg(xhci, "HCSPARAMS 3 0x%x:\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"HCSPARAMS 3 0x%x:\n",
 			(unsigned int) temp);
-	xhci_dbg(xhci, "  Worst case U1 device exit latency: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Worst case U1 device exit latency: %u\n",
 			(unsigned int) HCS_U1_LATENCY(temp));
-	xhci_dbg(xhci, "  Worst case U2 device exit latency: %u\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Worst case U2 device exit latency: %u\n",
 			(unsigned int) HCS_U2_LATENCY(temp));
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->hcc_params);
-	xhci_dbg(xhci, "HCC PARAMS 0x%x:\n", (unsigned int) temp);
-	xhci_dbg(xhci, "  HC generates %s bit addresses\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"HCC PARAMS 0x%x:\n", (unsigned int) temp);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  HC generates %s bit addresses\n",
 			HCC_64BIT_ADDR(temp) ? "64" : "32");
 	/* FIXME */
-	xhci_dbg(xhci, "  FIXME: more HCCPARAMS debugging\n");
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  FIXME: more HCCPARAMS debugging\n");
 
 	temp = xhci_readl(xhci, &xhci->cap_regs->run_regs_off);
-	xhci_dbg(xhci, "RTSOFF 0x%x:\n", temp & RTSOFF_MASK);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"RTSOFF 0x%x:\n", temp & RTSOFF_MASK);
 }
 
 static void xhci_print_command_reg(struct xhci_hcd *xhci)
@@ -111,16 +137,22 @@ static void xhci_print_command_reg(struct xhci_hcd *xhci)
 	u32 temp;
 
 	temp = xhci_readl(xhci, &xhci->op_regs->command);
-	xhci_dbg(xhci, "USBCMD 0x%x:\n", temp);
-	xhci_dbg(xhci, "  HC is %s\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"USBCMD 0x%x:\n", temp);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  HC is %s\n",
 			(temp & CMD_RUN) ? "running" : "being stopped");
-	xhci_dbg(xhci, "  HC has %sfinished hard reset\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  HC has %sfinished hard reset\n",
 			(temp & CMD_RESET) ? "not " : "");
-	xhci_dbg(xhci, "  Event Interrupts %s\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Event Interrupts %s\n",
 			(temp & CMD_EIE) ? "enabled " : "disabled");
-	xhci_dbg(xhci, "  Host System Error Interrupts %s\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Host System Error Interrupts %s\n",
 			(temp & CMD_EIE) ? "enabled " : "disabled");
-	xhci_dbg(xhci, "  HC has %sfinished light reset\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  HC has %sfinished light reset\n",
 			(temp & CMD_LRESET) ? "not " : "");
 }
 
@@ -129,18 +161,23 @@ static void xhci_print_status(struct xhci_hcd *xhci)
 	u32 temp;
 
 	temp = xhci_readl(xhci, &xhci->op_regs->status);
-	xhci_dbg(xhci, "USBSTS 0x%x:\n", temp);
-	xhci_dbg(xhci, "  Event ring is %sempty\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"USBSTS 0x%x:\n", temp);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  Event ring is %sempty\n",
 			(temp & STS_EINT) ? "not " : "");
-	xhci_dbg(xhci, "  %sHost System Error\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %sHost System Error\n",
 			(temp & STS_FATAL) ? "WARNING: " : "No ");
-	xhci_dbg(xhci, "  HC is %s\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  HC is %s\n",
 			(temp & STS_HALT) ? "halted" : "running");
 }
 
 static void xhci_print_op_regs(struct xhci_hcd *xhci)
 {
-	xhci_dbg(xhci, "xHCI operational registers at %p:\n", xhci->op_regs);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"xHCI operational registers at %p:\n", xhci->op_regs);
 	xhci_print_command_reg(xhci);
 	xhci_print_status(xhci);
 }
@@ -161,7 +198,8 @@ static void xhci_print_ports(struct xhci_hcd *xhci)
 	addr = &xhci->op_regs->port_status_base;
 	for (i = 0; i < ports; i++) {
 		for (j = 0; j < NUM_PORT_REGS; ++j) {
-			xhci_dbg(xhci, "%p port %s reg = 0x%x\n",
+			xhci_dbg(xhci, (XHCI_LOG_PORTS | XHCI_LOG_REGS),
+					"%p port %s reg = 0x%x\n",
 					addr, names[j],
 					(unsigned int) xhci_readl(xhci, addr));
 			addr++;
@@ -180,35 +218,42 @@ void xhci_print_ir_set(struct xhci_hcd *xhci, struct xhci_intr_reg *ir_set, int
 	if (temp == XHCI_INIT_VALUE)
 		return;
 
-	xhci_dbg(xhci, "  %p: ir_set[%i]\n", ir_set, set_num);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set[%i]\n", ir_set, set_num);
 
-	xhci_dbg(xhci, "  %p: ir_set.pending = 0x%x\n", addr,
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set.pending = 0x%x\n", addr,
 			(unsigned int)temp);
 
 	addr = &ir_set->irq_control;
 	temp = xhci_readl(xhci, addr);
-	xhci_dbg(xhci, "  %p: ir_set.control = 0x%x\n", addr,
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set.control = 0x%x\n", addr,
 			(unsigned int)temp);
 
 	addr = &ir_set->erst_size;
 	temp = xhci_readl(xhci, addr);
-	xhci_dbg(xhci, "  %p: ir_set.erst_size = 0x%x\n", addr,
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set.erst_size = 0x%x\n", addr,
 			(unsigned int)temp);
 
 	addr = &ir_set->rsvd;
 	temp = xhci_readl(xhci, addr);
 	if (temp != XHCI_INIT_VALUE)
-		xhci_dbg(xhci, "  WARN: %p: ir_set.rsvd = 0x%x\n",
+		xhci_dbg(xhci, XHCI_LOG_REGS,
+				"  WARN: %p: ir_set.rsvd = 0x%x\n",
 				addr, (unsigned int)temp);
 
 	addr = &ir_set->erst_base;
 	temp_64 = xhci_read_64(xhci, addr);
-	xhci_dbg(xhci, "  %p: ir_set.erst_base = @%08llx\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set.erst_base = @%08llx\n",
 			addr, temp_64);
 
 	addr = &ir_set->erst_dequeue;
 	temp_64 = xhci_read_64(xhci, addr);
-	xhci_dbg(xhci, "  %p: ir_set.erst_dequeue = @%08llx\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: ir_set.erst_dequeue = @%08llx\n",
 			addr, temp_64);
 }
 
@@ -217,15 +262,18 @@ void xhci_print_run_regs(struct xhci_hcd *xhci)
 	u32 temp;
 	int i;
 
-	xhci_dbg(xhci, "xHCI runtime registers at %p:\n", xhci->run_regs);
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"xHCI runtime registers at %p:\n", xhci->run_regs);
 	temp = xhci_readl(xhci, &xhci->run_regs->microframe_index);
-	xhci_dbg(xhci, "  %p: Microframe index = 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_REGS,
+			"  %p: Microframe index = 0x%x\n",
 			&xhci->run_regs->microframe_index,
 			(unsigned int) temp);
 	for (i = 0; i < 7; ++i) {
 		temp = xhci_readl(xhci, &xhci->run_regs->rsvd[i]);
 		if (temp != XHCI_INIT_VALUE)
-			xhci_dbg(xhci, "  WARN: %p: Rsvd[%i] = 0x%x\n",
+			xhci_dbg(xhci, XHCI_LOG_REGS,
+					"  WARN: %p: Rsvd[%i] = 0x%x\n",
 					&xhci->run_regs->rsvd[i],
 					i, (unsigned int) temp);
 	}
@@ -242,7 +290,8 @@ void xhci_print_trb_offsets(struct xhci_hcd *xhci, union xhci_trb *trb)
 {
 	int i;
 	for (i = 0; i < 4; ++i)
-		xhci_dbg(xhci, "Offset 0x%x = 0x%x\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Offset 0x%x = 0x%x\n",
 				i*4, trb->generic.field[i]);
 }
 
@@ -253,22 +302,30 @@ void xhci_debug_trb(struct xhci_hcd *xhci, union xhci_trb *trb)
 {
 	u64	address;
 	u32	type = xhci_readl(xhci, &trb->link.control) & TRB_TYPE_BITMASK;
+	unsigned int temp;
 
 	switch (type) {
 	case TRB_TYPE(TRB_LINK):
-		xhci_dbg(xhci, "Link TRB:\n");
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Link TRB:\n");
 		xhci_print_trb_offsets(xhci, trb);
 
 		address = trb->link.segment_ptr;
-		xhci_dbg(xhci, "Next ring segment DMA address = 0x%llx\n", address);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Next ring segment DMA address = 0x%llx\n",
+				address);
 
-		xhci_dbg(xhci, "Interrupter target = 0x%x\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Interrupter target = 0x%x\n",
 				GET_INTR_TARGET(trb->link.intr_target));
-		xhci_dbg(xhci, "Cycle bit = %u\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Cycle bit = %u\n",
 				(unsigned int) (trb->link.control & TRB_CYCLE));
-		xhci_dbg(xhci, "Toggle cycle bit = %u\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Toggle cycle bit = %u\n",
 				(unsigned int) (trb->link.control & LINK_TOGGLE));
-		xhci_dbg(xhci, "No Snoop bit = %u\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"No Snoop bit = %u\n",
 				(unsigned int) (trb->link.control & TRB_NO_SNOOP));
 		break;
 	case TRB_TYPE(TRB_TRANSFER):
@@ -277,17 +334,24 @@ void xhci_debug_trb(struct xhci_hcd *xhci, union xhci_trb *trb)
 		 * FIXME: look at flags to figure out if it's an address or if
 		 * the data is directly in the buffer field.
 		 */
-		xhci_dbg(xhci, "DMA address or buffer contents= %llu\n", address);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"DMA address or buffer contents= %llu\n",
+				address);
 		break;
 	case TRB_TYPE(TRB_COMPLETION):
 		address = trb->event_cmd.cmd_trb;
-		xhci_dbg(xhci, "Command TRB pointer = %llu\n", address);
-		xhci_dbg(xhci, "Completion status = %u\n",
-				(unsigned int) GET_COMP_CODE(trb->event_cmd.status));
-		xhci_dbg(xhci, "Flags = 0x%x\n", (unsigned int) trb->event_cmd.flags);
+		temp = GET_COMP_CODE(trb->event_cmd.status);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Command TRB pointer = %llu\n", address);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Completion status = %u\n", temp);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Flags = 0x%x\n",
+				(unsigned int) trb->event_cmd.flags);
 		break;
 	default:
-		xhci_dbg(xhci, "Unknown TRB with TRB type ID %u\n",
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_TX_VERBOSE),
+				"Unknown TRB with TRB type ID %u\n",
 				(unsigned int) type>>10);
 		xhci_print_trb_offsets(xhci, trb);
 		break;
@@ -315,7 +379,8 @@ void xhci_debug_segment(struct xhci_hcd *xhci, struct xhci_segment *seg)
 
 	for (i = 0; i < TRBS_PER_SEGMENT; ++i) {
 		trb = &seg->trbs[i];
-		xhci_dbg(xhci, "@%08x %08x %08x %08x %08x\n", addr,
+		xhci_dbg(xhci, XHCI_LOG_RINGS, "@%08x %08x %08x %08x %08x\n",
+				addr,
 				lower_32_bits(trb->link.segment_ptr),
 				upper_32_bits(trb->link.segment_ptr),
 				(unsigned int) trb->link.intr_target,
@@ -326,17 +391,17 @@ void xhci_debug_segment(struct xhci_hcd *xhci, struct xhci_segment *seg)
 
 void xhci_dbg_ring_ptrs(struct xhci_hcd *xhci, struct xhci_ring *ring)
 {
-	xhci_dbg(xhci, "Ring deq = %p (virt), 0x%llx (dma)\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Ring deq = %p (virt), 0x%llx (dma)\n",
 			ring->dequeue,
 			(unsigned long long)xhci_trb_virt_to_dma(ring->deq_seg,
 							    ring->dequeue));
-	xhci_dbg(xhci, "Ring deq updated %u times\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Ring deq updated %u times\n",
 			ring->deq_updates);
-	xhci_dbg(xhci, "Ring enq = %p (virt), 0x%llx (dma)\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Ring enq = %p (virt), 0x%llx (dma)\n",
 			ring->enqueue,
 			(unsigned long long)xhci_trb_virt_to_dma(ring->enq_seg,
 							    ring->enqueue));
-	xhci_dbg(xhci, "Ring enq updated %u times\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Ring enq updated %u times\n",
 			ring->enq_updates);
 }
 
@@ -357,7 +422,8 @@ void xhci_debug_ring(struct xhci_hcd *xhci, struct xhci_ring *ring)
 	xhci_debug_segment(xhci, first_seg);
 
 	if (!ring->enq_updates && !ring->deq_updates) {
-		xhci_dbg(xhci, "  Ring has not been updated\n");
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"  Ring has not been updated\n");
 		return;
 	}
 	for (seg = first_seg->next; seg != first_seg; seg = seg->next)
@@ -372,7 +438,8 @@ void xhci_dbg_erst(struct xhci_hcd *xhci, struct xhci_erst *erst)
 
 	for (i = 0; i < erst->num_entries; ++i) {
 		entry = &erst->entries[i];
-		xhci_dbg(xhci, "@%08x %08x %08x %08x %08x\n",
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"@%08x %08x %08x %08x %08x\n",
 				(unsigned int) addr,
 				lower_32_bits(entry->seg_addr),
 				upper_32_bits(entry->seg_addr),
@@ -387,21 +454,25 @@ void xhci_dbg_cmd_ptrs(struct xhci_hcd *xhci)
 	u64 val;
 
 	val = xhci_read_64(xhci, &xhci->op_regs->cmd_ring);
-	xhci_dbg(xhci, "// xHC command ring deq ptr low bits + flags = @%08x\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS,
+			"xHC command ring deq ptr low bits + flags = @%08x\n",
 			lower_32_bits(val));
-	xhci_dbg(xhci, "// xHC command ring deq ptr high bits = @%08x\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS,
+			"xHC command ring deq ptr high bits = @%08x\n",
 			upper_32_bits(val));
 }
 
 /* Print the last 32 bytes for 64-byte contexts */
-static void dbg_rsvd64(struct xhci_hcd *xhci, u64 *ctx, dma_addr_t dma)
+static void dbg_rsvd64(struct xhci_hcd *xhci, u64 *ctx, dma_addr_t dma,
+		int log_level)
 {
 	int i;
 	for (i = 0; i < 4; ++i) {
-		xhci_dbg(xhci, "@%p (virt) @%08llx "
-			 "(dma) %#08llx - rsvd64[%d]\n",
-			 &ctx[4 + i], (unsigned long long)dma,
-			 ctx[4 + i], i);
+		xhci_dbg(xhci, log_level,
+				"@%p (virt) @%08llx "
+				"(dma) %#08llx - rsvd64[%d]\n",
+				&ctx[4 + i], (unsigned long long)dma,
+				ctx[4 + i], i);
 		dma += 8;
 	}
 }
@@ -417,32 +488,37 @@ void xhci_dbg_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx)
 		((unsigned long)slot_ctx - (unsigned long)ctx->bytes);
 	int csz = HCC_64BYTE_CONTEXT(xhci->hcc_params);
 
-	xhci_dbg(xhci, "Slot Context:\n");
-	xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - dev_info\n",
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE, "Slot Context:\n");
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+			"@%p (virt) @%08llx (dma) %#08x - dev_info\n",
 			&slot_ctx->dev_info,
 			(unsigned long long)dma, slot_ctx->dev_info);
 	dma += field_size;
-	xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - dev_info2\n",
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+			"@%p (virt) @%08llx (dma) %#08x - dev_info2\n",
 			&slot_ctx->dev_info2,
 			(unsigned long long)dma, slot_ctx->dev_info2);
 	dma += field_size;
-	xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - tt_info\n",
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+			"@%p (virt) @%08llx (dma) %#08x - tt_info\n",
 			&slot_ctx->tt_info,
 			(unsigned long long)dma, slot_ctx->tt_info);
 	dma += field_size;
-	xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - dev_state\n",
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+			"@%p (virt) @%08llx (dma) %#08x - dev_state\n",
 			&slot_ctx->dev_state,
 			(unsigned long long)dma, slot_ctx->dev_state);
 	dma += field_size;
 	for (i = 0; i < 4; ++i) {
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - rsvd[%d]\n",
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"@%p (virt) @%08llx (dma) %#08x - rsvd[%d]\n",
 				&slot_ctx->reserved[i], (unsigned long long)dma,
 				slot_ctx->reserved[i], i);
 		dma += field_size;
 	}
 
 	if (csz)
-		dbg_rsvd64(xhci, (u64 *)slot_ctx, dma);
+		dbg_rsvd64(xhci, (u64 *)slot_ctx, dma, XHCI_LOG_DEVICE_STATE);
 }
 
 void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
@@ -462,25 +538,32 @@ void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
 		dma_addr_t dma = ctx->dma +
 			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
 
-		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - ep_info\n",
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"Endpoint %02d Context:\n", i);
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"@%p (virt) @%08llx (dma) %#08x - ep_info\n",
 				&ep_ctx->ep_info,
 				(unsigned long long)dma, ep_ctx->ep_info);
 		dma += field_size;
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - ep_info2\n",
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"@%p (virt) @%08llx (dma) %#08x - ep_info2\n",
 				&ep_ctx->ep_info2,
 				(unsigned long long)dma, ep_ctx->ep_info2);
 		dma += field_size;
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08llx - deq\n",
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"@%p (virt) @%08llx (dma) %#08llx - deq\n",
 				&ep_ctx->deq,
 				(unsigned long long)dma, ep_ctx->deq);
 		dma += 2*field_size;
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - tx_info\n",
+		xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+				"@%p (virt) @%08llx (dma) %#08x - tx_info\n",
 				&ep_ctx->tx_info,
 				(unsigned long long)dma, ep_ctx->tx_info);
 		dma += field_size;
 		for (j = 0; j < 3; ++j) {
-			xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - rsvd[%d]\n",
+			xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+					"@%p (virt) @%08llx (dma) %#08x "
+					"- rsvd[%d]\n",
 					&ep_ctx->reserved[j],
 					(unsigned long long)dma,
 					ep_ctx->reserved[j], j);
@@ -488,7 +571,8 @@ void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
 		}
 
 		if (csz)
-			dbg_rsvd64(xhci, (u64 *)ep_ctx, dma);
+			dbg_rsvd64(xhci, (u64 *)ep_ctx, dma,
+					XHCI_LOG_DEVICE_STATE);
 	}
 }
 
@@ -506,23 +590,29 @@ void xhci_dbg_ctx(struct xhci_hcd *xhci,
 	if (ctx->type == XHCI_CTX_TYPE_INPUT) {
 		struct xhci_input_control_ctx *ctrl_ctx =
 			xhci_get_input_control_ctx(xhci, ctx);
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - drop flags\n",
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"@%p (virt) @%08llx (dma) %#08x - drop flags\n",
 			 &ctrl_ctx->drop_flags, (unsigned long long)dma,
 			 ctrl_ctx->drop_flags);
 		dma += field_size;
-		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - add flags\n",
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"@%p (virt) @%08llx (dma) %#08x - add flags\n",
 			 &ctrl_ctx->add_flags, (unsigned long long)dma,
 			 ctrl_ctx->add_flags);
 		dma += field_size;
 		for (i = 0; i < 6; ++i) {
-			xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - rsvd2[%d]\n",
-				 &ctrl_ctx->rsvd2[i], (unsigned long long)dma,
-				 ctrl_ctx->rsvd2[i], i);
+			xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+					"@%p (virt) @%08llx (dma) %#08x"
+					" - rsvd2[%d]\n",
+					&ctrl_ctx->rsvd2[i],
+					(unsigned long long)dma,
+					ctrl_ctx->rsvd2[i], i);
 			dma += field_size;
 		}
 
 		if (csz)
-			dbg_rsvd64(xhci, (u64 *)ctrl_ctx, dma);
+			dbg_rsvd64(xhci, (u64 *)ctrl_ctx, dma,
+					XHCI_LOG_COMMANDS_VERBOSE);
 	}
 
 	slot_ctx = xhci_get_slot_ctx(xhci, ctx);
diff --git a/drivers/usb/host/xhci-hcd.c b/drivers/usb/host/xhci-hcd.c
index 932f999..d8abbba 100644
--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -34,6 +34,11 @@ static int link_quirk;
 module_param(link_quirk, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(link_quirk, "Don't clear the chain bit on a link TRB");
 
+/* Logging level bitmask, see xhci.h */
+static int log_level;
+module_param(log_level, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(log_level, "Log level bitmask");
+
 /* TODO: copied from ehci-hcd.c - can this be refactored? */
 /*
  * handshake - spin reading hc until handshake completes or fails
@@ -81,7 +86,7 @@ int xhci_halt(struct xhci_hcd *xhci)
 	u32 cmd;
 	u32 mask;
 
-	xhci_dbg(xhci, "// Halt the HC\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS, "Halt the HC\n");
 	/* Disable all interrupts from the host controller */
 	mask = ~(XHCI_IRQS);
 	halted = xhci_readl(xhci, &xhci->op_regs->status) & STS_HALT;
@@ -114,7 +119,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 		return 0;
 	}
 
-	xhci_dbg(xhci, "// Reset the HC\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS, "Reset the HC\n");
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command |= CMD_RESET;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
@@ -144,7 +149,6 @@ static void xhci_quiesce(struct xhci_hcd *xhci)
 	 * TODO: Implement after command ring code is done.
 	 */
 	BUG_ON(!HC_IS_RUNNING(xhci_to_hcd(xhci)->state));
-	xhci_dbg(xhci, "Finished quiescing -- code not written yet\n");
 }
 
 #if 0
@@ -179,7 +183,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 		xhci_err(xhci, "Failed to allocate MSI-X interrupt\n");
 		goto disable_msix;
 	}
-	xhci_dbg(xhci, "Finished setting up MSI-X\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Finished setting up MSI-X\n");
 	return 0;
 
 disable_msix:
@@ -202,7 +206,7 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 	pci_disable_msix(pdev);
 	kfree(xhci->msix_entries);
 	xhci->msix_entries = NULL;
-	xhci_dbg(xhci, "Finished cleaning up MSI-X\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Finished cleaning up MSI-X\n");
 }
 #endif
 
@@ -218,16 +222,19 @@ int xhci_init(struct usb_hcd *hcd)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	int retval = 0;
 
-	xhci_dbg(xhci, "xhci_init\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "xhci_init\n");
 	spin_lock_init(&xhci->lock);
 	if (link_quirk) {
-		xhci_dbg(xhci, "QUIRK: Not clearing Link TRB chain bits.\n");
+		xhci_dbg(xhci, XHCI_LOG_QUIRKS,
+				"QUIRK: Not clearing Link TRB chain bits.\n");
 		xhci->quirks |= XHCI_LINK_TRB_QUIRK;
 	} else {
-		xhci_dbg(xhci, "xHCI doesn't need link TRB QUIRK\n");
+		xhci_dbg(xhci, XHCI_LOG_QUIRKS,
+				"xHCI doesn't need link TRB QUIRK\n");
 	}
+	xhci->log_level = log_level;
 	retval = xhci_mem_init(xhci, GFP_KERNEL);
-	xhci_dbg(xhci, "Finished xhci_init\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Finished xhci_init\n");
 
 	return retval;
 }
@@ -296,10 +303,9 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 		spin_unlock(&xhci->lock);
 		return IRQ_NONE;
 	}
-	xhci_dbg(xhci, "op reg status = %08x\n", temp);
-	xhci_dbg(xhci, "ir set irq_pending = %08x\n", temp2);
-	xhci_dbg(xhci, "Event ring dequeue ptr:\n");
-	xhci_dbg(xhci, "@%llx %08x %08x %08x %08x\n",
+	xhci_dbg(xhci, XHCI_LOG_EVENTS,
+			"xHCI IRQ -- event ring dequeue ptr:\n");
+	xhci_dbg(xhci, XHCI_LOG_EVENTS, "@%llx %08x %08x %08x %08x\n",
 			(unsigned long long)xhci_trb_virt_to_dma(xhci->event_ring->deq_seg, trb),
 			lower_32_bits(trb->link.segment_ptr),
 			upper_32_bits(trb->link.segment_ptr),
@@ -330,29 +336,33 @@ void xhci_event_ring_work(unsigned long arg)
 	struct xhci_hcd *xhci = (struct xhci_hcd *) arg;
 	int i, j;
 
-	xhci_dbg(xhci, "Poll event ring: %lu\n", jiffies);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Poll event ring: %lu\n", jiffies);
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	temp = xhci_readl(xhci, &xhci->op_regs->status);
-	xhci_dbg(xhci, "op reg status = 0x%x\n", temp);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "op reg status = 0x%x\n", temp);
 	if (temp == 0xffffffff) {
-		xhci_dbg(xhci, "HW died, polling stopped.\n");
+		xhci_warn(xhci, "HW died, polling stopped.\n");
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return;
 	}
 
 	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-	xhci_dbg(xhci, "ir_set 0 pending = 0x%x\n", temp);
-	xhci_dbg(xhci, "No-op commands handled = %d\n", xhci->noops_handled);
-	xhci_dbg(xhci, "HC error bitmask = 0x%x\n", xhci->error_bitmask);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "ir_set 0 pending = 0x%x\n", temp);
+	xhci_dbg(xhci, XHCI_LOG_NOOPS, "No-op commands handled = %d\n",
+			xhci->noops_handled);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "HC error bitmask = 0x%x\n",
+			xhci->error_bitmask);
+
 	xhci->error_bitmask = 0;
-	xhci_dbg(xhci, "Event ring:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Event ring:\n");
 	xhci_debug_segment(xhci, xhci->event_ring->deq_seg);
 	xhci_dbg_ring_ptrs(xhci, xhci->event_ring);
 	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
 	temp_64 &= ~ERST_PTR_MASK;
-	xhci_dbg(xhci, "ERST deq = 64'h%0lx\n", (long unsigned int) temp_64);
-	xhci_dbg(xhci, "Command ring:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "ERST deq = 64'h%0lx\n",
+			(long unsigned int) temp_64);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Command ring:\n");
 	xhci_debug_segment(xhci, xhci->cmd_ring->deq_seg);
 	xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
 	xhci_dbg_cmd_ptrs(xhci);
@@ -363,7 +373,14 @@ void xhci_event_ring_work(unsigned long arg)
 			struct xhci_ring *ring = xhci->devs[i]->eps[j].ring;
 			if (!ring)
 				continue;
-			xhci_dbg(xhci, "Dev %d endpoint ring %d:\n", i, j);
+			if (!ring->enq_updates && !ring->deq_updates) {
+				xhci_dbg(xhci, XHCI_LOG_RINGS,
+						"Dev %d endpoint ring %d "
+						"is unused:\n", i, j);
+				continue;
+			}
+			xhci_dbg(xhci, XHCI_LOG_RINGS,
+					"Dev %d endpoint ring %d:\n", i, j);
 			xhci_debug_segment(xhci, ring->deq_seg);
 		}
 	}
@@ -375,8 +392,6 @@ void xhci_event_ring_work(unsigned long arg)
 
 	if (!xhci->zombie)
 		mod_timer(&xhci->event_ring_timer, jiffies + POLL_TIMEOUT * HZ);
-	else
-		xhci_dbg(xhci, "Quit polling the event ring.\n");
 }
 #endif
 
@@ -402,7 +417,6 @@ int xhci_run(struct usb_hcd *hcd)
 	hcd->uses_new_polling = 1;
 	hcd->poll_rh = 0;
 
-	xhci_dbg(xhci, "xhci_run\n");
 #if 0	/* FIXME: MSI not setup yet */
 	/* Do this at the very last minute */
 	ret = xhci_setup_msix(xhci);
@@ -418,25 +432,25 @@ int xhci_run(struct usb_hcd *hcd)
 	/* Poll the event ring */
 	xhci->event_ring_timer.expires = jiffies + POLL_TIMEOUT * HZ;
 	xhci->zombie = 0;
-	xhci_dbg(xhci, "Setting event ring polling timer\n");
 	add_timer(&xhci->event_ring_timer);
 #endif
 
-	xhci_dbg(xhci, "Command ring memory map follows:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Command ring memory map follows:\n");
 	xhci_debug_ring(xhci, xhci->cmd_ring);
 	xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
 	xhci_dbg_cmd_ptrs(xhci);
 
-	xhci_dbg(xhci, "ERST memory map follows:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "ERST memory map follows:\n");
 	xhci_dbg_erst(xhci, &xhci->erst);
-	xhci_dbg(xhci, "Event ring:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Event ring:\n");
 	xhci_debug_ring(xhci, xhci->event_ring);
 	xhci_dbg_ring_ptrs(xhci, xhci->event_ring);
 	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
 	temp_64 &= ~ERST_PTR_MASK;
-	xhci_dbg(xhci, "ERST deq = 64'h%0lx\n", (long unsigned int) temp_64);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "ERST deq = 64'h%0lx\n",
+			(long unsigned int) temp_64);
 
-	xhci_dbg(xhci, "// Set the interrupt modulation register\n");
+	/* Set the interrupt modulation register */
 	temp = xhci_readl(xhci, &xhci->ir_set->irq_control);
 	temp &= ~ER_IRQ_INTERVAL_MASK;
 	temp |= (u32) 160;
@@ -446,13 +460,9 @@ int xhci_run(struct usb_hcd *hcd)
 	hcd->state = HC_STATE_RUNNING;
 	temp = xhci_readl(xhci, &xhci->op_regs->command);
 	temp |= (CMD_EIE);
-	xhci_dbg(xhci, "// Enable interrupts, cmd = 0x%x.\n",
-			temp);
 	xhci_writel(xhci, temp, &xhci->op_regs->command);
 
 	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-	xhci_dbg(xhci, "// Enabling event ring interrupter %p by writing 0x%x to irq_pending\n",
-			xhci->ir_set, (unsigned int) ER_IRQ_ENABLE(temp));
 	xhci_writel(xhci, ER_IRQ_ENABLE(temp),
 			&xhci->ir_set->irq_pending);
 	xhci_print_ir_set(xhci, xhci->ir_set, 0);
@@ -462,16 +472,14 @@ int xhci_run(struct usb_hcd *hcd)
 
 	temp = xhci_readl(xhci, &xhci->op_regs->command);
 	temp |= (CMD_RUN);
-	xhci_dbg(xhci, "// Turn on HC, cmd = 0x%x.\n",
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Turn on HC, cmd = 0x%x.\n",
 			temp);
 	xhci_writel(xhci, temp, &xhci->op_regs->command);
 	/* Flush PCI posted writes */
 	temp = xhci_readl(xhci, &xhci->op_regs->command);
-	xhci_dbg(xhci, "// @%p = 0x%x\n", &xhci->op_regs->command, temp);
 	if (doorbell)
 		(*doorbell)(xhci);
 
-	xhci_dbg(xhci, "Finished xhci_run\n");
 	return 0;
 }
 
@@ -505,7 +513,6 @@ void xhci_stop(struct usb_hcd *hcd)
 	del_timer_sync(&xhci->event_ring_timer);
 #endif
 
-	xhci_dbg(xhci, "// Disabling event ring interrupts\n");
 	temp = xhci_readl(xhci, &xhci->op_regs->status);
 	xhci_writel(xhci, temp & ~STS_EINT, &xhci->op_regs->status);
 	temp = xhci_readl(xhci, &xhci->ir_set->irq_pending);
@@ -513,9 +520,8 @@ void xhci_stop(struct usb_hcd *hcd)
 			&xhci->ir_set->irq_pending);
 	xhci_print_ir_set(xhci, xhci->ir_set, 0);
 
-	xhci_dbg(xhci, "cleaning up memory\n");
 	xhci_mem_cleanup(xhci);
-	xhci_dbg(xhci, "xhci_stop completed - status = %x\n",
+	xhci_dbg(xhci, XHCI_LOG_INIT, "xhci_stop completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
 }
 
@@ -538,7 +544,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_cleanup_msix(xhci);
 #endif
 
-	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
+	xhci_dbg(xhci, XHCI_LOG_INIT, "xhci_shutdown completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
 }
 
@@ -599,21 +605,12 @@ unsigned int xhci_last_valid_endpoint(u32 added_ctxs)
  */
 int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 		struct usb_host_endpoint *ep, int check_ep, const char *func) {
-	if (!hcd || (check_ep && !ep) || !udev) {
-		printk(KERN_DEBUG "xHCI %s called with invalid args\n",
-				func);
+	if (!hcd || (check_ep && !ep) || !udev)
 		return -EINVAL;
-	}
-	if (!udev->parent) {
-		printk(KERN_DEBUG "xHCI %s called for root hub\n",
-				func);
+	if (!udev->parent)
 		return 0;
-	}
-	if (!udev->slot_id) {
-		printk(KERN_DEBUG "xHCI %s called with unaddressed device\n",
-				func);
+	if (!udev->slot_id)
 		return -EINVAL;
-	}
 	return 1;
 }
 
@@ -643,12 +640,16 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 	hw_max_packet_size = MAX_PACKET_DECODED(ep_ctx->ep_info2);
 	max_packet_size = urb->dev->ep0.desc.wMaxPacketSize;
 	if (hw_max_packet_size != max_packet_size) {
-		xhci_dbg(xhci, "Max Packet Size for ep 0 changed.\n");
-		xhci_dbg(xhci, "Max packet size in usb_device = %d\n",
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Max Packet Size for ep 0 changed.\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Max packet size in usb_device = %d\n",
 				max_packet_size);
-		xhci_dbg(xhci, "Max packet size in xHCI HW = %d\n",
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Max packet size in xHCI HW = %d\n",
 				hw_max_packet_size);
-		xhci_dbg(xhci, "Issuing evaluate context command.\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Issuing evaluate context command.\n");
 
 		/* Set up the modified control endpoint 0 */
 		xhci_endpoint_copy(xhci, xhci->devs[slot_id]->in_ctx,
@@ -666,9 +667,11 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		ctrl_ctx->add_flags = EP0_FLAG;
 		ctrl_ctx->drop_flags = 0;
 
-		xhci_dbg(xhci, "Slot %d input context\n", slot_id);
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"Slot %d input context\n", slot_id);
 		xhci_dbg_ctx(xhci, in_ctx, ep_index);
-		xhci_dbg(xhci, "Slot %d output context\n", slot_id);
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"Slot %d output context\n", slot_id);
 		xhci_dbg_ctx(xhci, out_ctx, ep_index);
 
 		ret = xhci_configure_endpoint(xhci, urb->dev, NULL,
@@ -701,14 +704,14 @@ int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flags)
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
 
 	if (!xhci->devs || !xhci->devs[slot_id]) {
-		if (!in_interrupt())
-			dev_warn(&urb->dev->dev, "WARN: urb submitted for dev with no Slot ID\n");
+		xhci_warn(xhci, "WARN: urb submitted for dev "
+				"with no Slot ID\n");
 		ret = -EINVAL;
 		goto exit;
 	}
 	if (!test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags)) {
-		if (!in_interrupt())
-			xhci_dbg(xhci, "urb submitted during PCI suspend\n");
+		xhci_dbg(xhci, XHCI_LOG_TX,
+				"urb submitted during PCI suspend\n");
 		ret = -ESHUTDOWN;
 		goto exit;
 	}
@@ -797,7 +800,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		goto done;
 	temp = xhci_readl(xhci, &xhci->op_regs->status);
 	if (temp == 0xffffffff) {
-		xhci_dbg(xhci, "HW died, freeing TD.\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "HW died, freeing TD.\n");
 		td = (struct xhci_td *) urb->hcpriv;
 
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
@@ -807,13 +810,13 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		return ret;
 	}
 
-	xhci_dbg(xhci, "Cancel URB %p\n", urb);
-	xhci_dbg(xhci, "Event ring:\n");
+	xhci_dbg(xhci, XHCI_LOG_TX, "Cancel URB %p\n", urb);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Event ring:\n");
 	xhci_debug_ring(xhci, xhci->event_ring);
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
 	ep = &xhci->devs[urb->dev->slot_id]->eps[ep_index];
 	ep_ring = ep->ring;
-	xhci_dbg(xhci, "Endpoint ring:\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Endpoint ring:\n");
 	xhci_debug_ring(xhci, ep_ring);
 	td = (struct xhci_td *) urb->hcpriv;
 
@@ -862,12 +865,11 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	if (ret <= 0)
 		return ret;
 	xhci = hcd_to_xhci(hcd);
-	xhci_dbg(xhci, "%s called for udev %p\n", __func__, udev);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"%s called for udev %p\n", __func__, udev);
 
 	drop_flag = xhci_get_endpoint_flag(&ep->desc);
 	if (drop_flag == SLOT_FLAG || drop_flag == EP0_FLAG) {
-		xhci_dbg(xhci, "xHCI %s - can't drop slot or ep 0 %#x\n",
-				__func__, drop_flag);
 		return 0;
 	}
 
@@ -909,7 +911,9 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 
 	xhci_endpoint_zero(xhci, xhci->devs[udev->slot_id], ep);
 
-	xhci_dbg(xhci, "drop ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"drop ep 0x%x, slot id %d, new drop flags = %#x, "
+			"new add flags = %#x, new slot info = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
 			(unsigned int) new_drop_flags,
@@ -956,12 +960,6 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	added_ctxs = xhci_get_endpoint_flag(&ep->desc);
 	last_ctx = xhci_last_valid_endpoint(added_ctxs);
 	if (added_ctxs == SLOT_FLAG || added_ctxs == EP0_FLAG) {
-		/* FIXME when we have to issue an evaluate endpoint command to
-		 * deal with ep0 max packet size changing once we get the
-		 * descriptors
-		 */
-		xhci_dbg(xhci, "xHCI %s - can't add slot or ep 0 %#x\n",
-				__func__, added_ctxs);
 		return 0;
 	}
 
@@ -992,7 +990,7 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	 */
 	if (xhci_endpoint_init(xhci, xhci->devs[udev->slot_id],
 				udev, ep, GFP_KERNEL) < 0) {
-		dev_dbg(&udev->dev, "%s - could not initialize ep %#x\n",
+		xhci_warn(xhci, "%s - could not initialize ep %#x\n",
 				__func__, ep->desc.bEndpointAddress);
 		return -ENOMEM;
 	}
@@ -1019,7 +1017,9 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	/* Store the usb_device pointer for later use */
 	ep->hcpriv = udev;
 
-	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"add ep 0x%x, slot id %d, new drop flags = %#x, "
+			"new add flags = %#x, new slot info = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
 			(unsigned int) new_drop_flags,
@@ -1063,26 +1063,27 @@ static int xhci_configure_endpoint_result(struct xhci_hcd *xhci,
 
 	switch (*cmd_status) {
 	case COMP_ENOMEM:
-		dev_warn(&udev->dev, "Not enough host controller resources "
+		xhci_warn(xhci, "Not enough host controller resources "
 				"for new device state.\n");
 		ret = -ENOMEM;
 		/* FIXME: can we allocate more resources for the HC? */
 		break;
 	case COMP_BW_ERR:
-		dev_warn(&udev->dev, "Not enough bandwidth "
+		xhci_warn(xhci, "Not enough bandwidth "
 				"for new device state.\n");
 		ret = -ENOSPC;
 		/* FIXME: can we go back to the old state? */
 		break;
 	case COMP_TRB_ERR:
 		/* the HCD set up something wrong */
-		dev_warn(&udev->dev, "ERROR: Endpoint drop flag = 0, "
+		xhci_warn(xhci, "ERROR: Endpoint drop flag = 0, "
 				"add flag = 1, "
 				"and endpoint is not disabled.\n");
 		ret = -EINVAL;
 		break;
 	case COMP_SUCCESS:
-		dev_dbg(&udev->dev, "Successful Endpoint Configure command\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Successful Endpoint Configure command\n");
 		ret = 0;
 		break;
 	default:
@@ -1102,21 +1103,22 @@ static int xhci_evaluate_context_result(struct xhci_hcd *xhci,
 
 	switch (*cmd_status) {
 	case COMP_EINVAL:
-		dev_warn(&udev->dev, "WARN: xHCI driver setup invalid evaluate "
+		xhci_warn(xhci, "WARN: xHCI driver setup invalid evaluate "
 				"context command.\n");
 		ret = -EINVAL;
 		break;
 	case COMP_EBADSLT:
-		dev_warn(&udev->dev, "WARN: slot not enabled for"
+		xhci_warn(xhci, "WARN: slot not enabled for"
 				"evaluate context command.\n");
 	case COMP_CTX_STATE:
-		dev_warn(&udev->dev, "WARN: invalid context state for "
+		xhci_warn(xhci, "WARN: invalid context state for "
 				"evaluate context command.\n");
 		xhci_dbg_ctx(xhci, virt_dev->out_ctx, 1);
 		ret = -EINVAL;
 		break;
 	case COMP_SUCCESS:
-		dev_dbg(&udev->dev, "Successful evaluate context command\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Successful evaluate context command\n");
 		ret = 0;
 		break;
 	default:
@@ -1166,7 +1168,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 				udev->slot_id);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		xhci_dbg(xhci, "FIXME allocate a new ring segment\n");
+		xhci_warn(xhci, "FIXME allocate a new ring segment\n");
 		return -ENOMEM;
 	}
 	xhci_ring_cmd_db(xhci);
@@ -1220,7 +1222,8 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 				__func__);
 		return -EINVAL;
 	}
-	xhci_dbg(xhci, "%s called for udev %p\n", __func__, udev);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"%s called for udev %p\n", __func__, udev);
 	virt_dev = xhci->devs[udev->slot_id];
 
 	/* See section 4.6.6 - A0 = 1; A1 = D0 = D1 = 0 */
@@ -1229,7 +1232,8 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 	ctrl_ctx->add_flags &= ~EP0_FLAG;
 	ctrl_ctx->drop_flags &= ~SLOT_FLAG;
 	ctrl_ctx->drop_flags &= ~EP0_FLAG;
-	xhci_dbg(xhci, "New Input Control Context:\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"New Input Control Context:\n");
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx,
 			LAST_CTX_TO_EP_NUM(slot_ctx->dev_info));
@@ -1241,7 +1245,8 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		return ret;
 	}
 
-	xhci_dbg(xhci, "Output context after successful config ep cmd:\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Output context after successful config ep cmd:\n");
 	xhci_dbg_ctx(xhci, virt_dev->out_ctx,
 			LAST_CTX_TO_EP_NUM(slot_ctx->dev_info));
 
@@ -1274,7 +1279,8 @@ void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 				__func__);
 		return;
 	}
-	xhci_dbg(xhci, "%s called for udev %p\n", __func__, udev);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"%s called for udev %p\n", __func__, udev);
 	virt_dev = xhci->devs[udev->slot_id];
 	/* Free any rings allocated for added endpoints */
 	for (i = 0; i < 31; ++i) {
@@ -1298,7 +1304,7 @@ static void xhci_setup_input_ctx_for_config_ep(struct xhci_hcd *xhci,
 	xhci_slot_copy(xhci, in_ctx, out_ctx);
 	ctrl_ctx->add_flags |= SLOT_FLAG;
 
-	xhci_dbg(xhci, "Input Context:\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE, "Input Context:\n");
 	xhci_dbg_ctx(xhci, in_ctx, xhci_last_valid_endpoint(add_flags));
 }
 
@@ -1338,7 +1344,8 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 	struct xhci_dequeue_state deq_state;
 	struct xhci_virt_ep *ep;
 
-	xhci_dbg(xhci, "Cleaning up stalled endpoint ring\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"Cleaning up stalled endpoint ring\n");
 	ep = &xhci->devs[udev->slot_id]->eps[ep_index];
 	/* We need to move the HW's dequeue pointer past this TD,
 	 * or it will attempt to resend it on the next doorbell ring.
@@ -1351,14 +1358,16 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 	 * issue a configure endpoint command later.
 	 */
 	if (!(xhci->quirks & XHCI_RESET_EP_QUIRK)) {
-		xhci_dbg(xhci, "Queueing new dequeue state\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Queueing new dequeue state\n");
 		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
 				ep_index, &deq_state);
 	} else {
 		/* Better hope no one uses the input context between now and the
 		 * reset endpoint completion!
 		 */
-		xhci_dbg(xhci, "Setting up input context for "
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Setting up input context for "
 				"configure endpoint command\n");
 		xhci_setup_input_ctx_for_quirk(xhci, udev->slot_id,
 				ep_index, &deq_state);
@@ -1391,16 +1400,13 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 	virt_ep = &xhci->devs[udev->slot_id]->eps[ep_index];
 	if (!virt_ep->stopped_td) {
-		xhci_dbg(xhci, "Endpoint 0x%x not halted, refusing to reset.\n",
-				ep->desc.bEndpointAddress);
 		return;
 	}
 	if (usb_endpoint_xfer_control(&ep->desc)) {
-		xhci_dbg(xhci, "Control endpoint stall already handled.\n");
 		return;
 	}
 
-	xhci_dbg(xhci, "Queueing reset endpoint command\n");
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS, "Queueing reset endpoint command\n");
 	spin_lock_irqsave(&xhci->lock, flags);
 	ret = xhci_queue_reset_ep(xhci, udev->slot_id, ep_index);
 	/*
@@ -1444,7 +1450,7 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 
 	if (xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
+		xhci_warn(xhci, "FIXME: allocate a command ring segment\n");
 		return;
 	}
 	xhci_ring_cmd_db(xhci);
@@ -1470,7 +1476,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
+		xhci_warn(xhci, "FIXME: allocate a command ring segment\n");
 		return 0;
 	}
 	xhci_ring_cmd_db(xhci);
@@ -1527,7 +1533,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	u64 temp_64;
 
 	if (!udev->slot_id) {
-		xhci_dbg(xhci, "Bad Slot ID %d\n", udev->slot_id);
+		xhci_warn(xhci, "Bad Slot ID %d\n", udev->slot_id);
 		return -EINVAL;
 	}
 
@@ -1537,7 +1543,8 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	if (!udev->config)
 		xhci_setup_addressable_virt_dev(xhci, udev);
 	/* Otherwise, assume the core has the device configured how it wants */
-	xhci_dbg(xhci, "Slot ID %d Input Context:\n", udev->slot_id);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Slot ID %d Input Context:\n", udev->slot_id);
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx, 2);
 
 	spin_lock_irqsave(&xhci->lock, flags);
@@ -1545,7 +1552,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 					udev->slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
-		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
+		xhci_warn(xhci, "FIXME: allocate a command ring segment\n");
 		return ret;
 	}
 	xhci_ring_cmd_db(xhci);
@@ -1573,16 +1580,18 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		ret = -EINVAL;
 		break;
 	case COMP_TX_ERR:
-		dev_warn(&udev->dev, "Device not responding to set address.\n");
+		xhci_warn(xhci, "Device not responding to set address.\n");
 		ret = -EPROTO;
 		break;
 	case COMP_SUCCESS:
-		xhci_dbg(xhci, "Successful Address Device command\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Successful Address Device command\n");
 		break;
 	default:
 		xhci_err(xhci, "ERROR: unexpected command completion "
 				"code 0x%x.\n", virt_dev->cmd_status);
-		xhci_dbg(xhci, "Slot ID %d Output Context:\n", udev->slot_id);
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"Slot ID %d Output Context:\n", udev->slot_id);
 		xhci_dbg_ctx(xhci, virt_dev->out_ctx, 2);
 		ret = -EINVAL;
 		break;
@@ -1591,17 +1600,11 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		return ret;
 	}
 	temp_64 = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
-	xhci_dbg(xhci, "Op regs DCBAA ptr = %#016llx\n", temp_64);
-	xhci_dbg(xhci, "Slot ID %d dcbaa entry @%p = %#016llx\n",
-			udev->slot_id,
-			&xhci->dcbaa->dev_context_ptrs[udev->slot_id],
-			(unsigned long long)
-				xhci->dcbaa->dev_context_ptrs[udev->slot_id]);
-	xhci_dbg(xhci, "Output Context DMA address = %#08llx\n",
-			(unsigned long long)virt_dev->out_ctx->dma);
-	xhci_dbg(xhci, "Slot ID %d Input Context:\n", udev->slot_id);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Slot ID %d Input Context:\n", udev->slot_id);
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx, 2);
-	xhci_dbg(xhci, "Slot ID %d Output Context:\n", udev->slot_id);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Slot ID %d Output Context:\n", udev->slot_id);
 	xhci_dbg_ctx(xhci, virt_dev->out_ctx, 2);
 	/*
 	 * USB core uses address 1 for the roothubs, so we add one to the
@@ -1614,7 +1617,8 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	ctrl_ctx->add_flags = 0;
 	ctrl_ctx->drop_flags = 0;
 
-	xhci_dbg(xhci, "Device address = %d\n", udev->devnum);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Device address = %d\n", udev->devnum);
 	/* XXX Meh, not sure if anyone else but choose_address uses this. */
 	set_bit(udev->devnum, udev->bus->devmap.devicemap);
 
@@ -1647,7 +1651,7 @@ int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 	}
 	config_cmd = xhci_alloc_command(xhci, true, mem_flags);
 	if (!config_cmd) {
-		xhci_dbg(xhci, "Could not allocate xHCI command structure.\n");
+		xhci_warn(xhci, "Could not allocate xHCI command structure.\n");
 		return -ENOMEM;
 	}
 
@@ -1660,7 +1664,8 @@ int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 	if (tt->multi)
 		slot_ctx->dev_info |= DEV_MTT;
 	if (xhci->hci_version > 0x95) {
-		xhci_dbg(xhci, "xHCI version %x needs hub "
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"xHCI version %x needs hub "
 				"TT think time and number of ports\n",
 				(unsigned int) xhci->hci_version);
 		slot_ctx->dev_info2 |= XHCI_MAX_PORTS(hdev->maxchild);
@@ -1673,17 +1678,20 @@ int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 			think_time = (think_time / 666) - 1;
 		slot_ctx->tt_info |= TT_THINK_TIME(think_time);
 	} else {
-		xhci_dbg(xhci, "xHCI version %x doesn't need hub "
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+				"xHCI version %x doesn't need hub "
 				"TT think time or number of ports\n",
 				(unsigned int) xhci->hci_version);
 	}
 	slot_ctx->dev_state = 0;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
-	xhci_dbg(xhci, "Set up %s for hub device.\n",
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+			"Set up %s for hub device.\n",
 			(xhci->hci_version > 0x95) ?
 			"configure endpoint" : "evaluate context");
-	xhci_dbg(xhci, "Slot %u Input Context:\n", hdev->slot_id);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Slot %u Input Context:\n", hdev->slot_id);
 	xhci_dbg_ctx(xhci, config_cmd->in_ctx, 0);
 
 	/* Issue and wait for the configure endpoint or
@@ -1696,7 +1704,8 @@ int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 		ret = xhci_configure_endpoint(xhci, hdev, config_cmd,
 				true, false);
 
-	xhci_dbg(xhci, "Slot %u Output Context:\n", hdev->slot_id);
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Slot %u Output Context:\n", hdev->slot_id);
 	xhci_dbg_ctx(xhci, vdev->out_ctx, 0);
 
 	xhci_free_command(xhci, config_cmd);
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index eac5b53..de9ed07 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -158,7 +158,6 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		status = 0;
 		addr = &xhci->op_regs->port_status_base + NUM_PORT_REGS*(wIndex & 0xff);
 		temp = xhci_readl(xhci, addr);
-		xhci_dbg(xhci, "get port status, actual port %d status  = 0x%x\n", wIndex, temp);
 
 		/* wPortChange bits */
 		if (temp & PORT_CSC)
@@ -183,7 +182,10 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			status |= 1 << USB_PORT_FEAT_RESET;
 		if (temp & PORT_POWER)
 			status |= 1 << USB_PORT_FEAT_POWER;
-		xhci_dbg(xhci, "Get port status returned 0x%x\n", status);
+		xhci_dbg(xhci, XHCI_LOG_PORTS,
+				"Get port %d status, actual status  = 0x%x, "
+				"returned status = 0x%x\n",
+				wIndex, temp, status);
 		put_unaligned(cpu_to_le32(status), (__le32 *) buf);
 		break;
 	case SetPortFeature:
@@ -205,14 +207,19 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			xhci_writel(xhci, temp | PORT_POWER, addr);
 
 			temp = xhci_readl(xhci, addr);
-			xhci_dbg(xhci, "set port power, actual port %d status  = 0x%x\n", wIndex, temp);
+			xhci_dbg(xhci, XHCI_LOG_PORTS,
+					"Set port %d power, "
+					"actual status  = 0x%x\n",
+					wIndex, temp);
 			break;
 		case USB_PORT_FEAT_RESET:
 			temp = (temp | PORT_RESET);
 			xhci_writel(xhci, temp, addr);
 
 			temp = xhci_readl(xhci, addr);
-			xhci_dbg(xhci, "set port reset, actual port %d status  = 0x%x\n", wIndex, temp);
+			xhci_dbg(xhci, XHCI_LOG_PORTS, "Set port %d reset, "
+					"actual status  = 0x%x\n",
+					wIndex, temp);
 			break;
 		default:
 			goto error;
@@ -246,8 +253,10 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* Change bits are all write 1 to clear */
 		xhci_writel(xhci, temp | status, addr);
 		temp = xhci_readl(xhci, addr);
-		xhci_dbg(xhci, "clear port %s change, actual port %d status  = 0x%x\n",
-				port_change_bit, wIndex, temp);
+		xhci_dbg(xhci, XHCI_LOG_PORTS,
+				"Clear port %d %s change,"
+				" actual status  = 0x%x\n",
+				wIndex, port_change_bit, temp);
 		temp = xhci_readl(xhci, addr); /* unblock any posted writes */
 		break;
 	default:
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index b8fd270..cf7fbee 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -41,15 +41,15 @@ static struct xhci_segment *xhci_segment_alloc(struct xhci_hcd *xhci, gfp_t flag
 	seg = kzalloc(sizeof *seg, flags);
 	if (!seg)
 		return 0;
-	xhci_dbg(xhci, "Allocating priv segment structure at %p\n", seg);
 
 	seg->trbs = dma_pool_alloc(xhci->segment_pool, flags, &dma);
 	if (!seg->trbs) {
 		kfree(seg);
 		return 0;
 	}
-	xhci_dbg(xhci, "// Allocating segment at %p (virtual) 0x%llx (DMA)\n",
-			seg->trbs, (unsigned long long)dma);
+	xhci_dbg(xhci, XHCI_LOG_RINGS,
+			"Allocating DMA segment at 0x%llx (DMA)\n",
+			(unsigned long long)dma);
 
 	memset(seg->trbs, 0, SEGMENT_SIZE);
 	seg->dma = dma;
@@ -63,12 +63,12 @@ static void xhci_segment_free(struct xhci_hcd *xhci, struct xhci_segment *seg)
 	if (!seg)
 		return;
 	if (seg->trbs) {
-		xhci_dbg(xhci, "Freeing DMA segment at %p (virtual) 0x%llx (DMA)\n",
-				seg->trbs, (unsigned long long)seg->dma);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Freeing DMA segment at 0x%llx (DMA)\n",
+				(unsigned long long)seg->dma);
 		dma_pool_free(xhci->segment_pool, seg->trbs, seg->dma);
 		seg->trbs = NULL;
 	}
-	xhci_dbg(xhci, "Freeing priv segment structure at %p\n", seg);
 	kfree(seg);
 }
 
@@ -99,9 +99,6 @@ static void xhci_link_segments(struct xhci_hcd *xhci, struct xhci_segment *prev,
 			val |= TRB_CHAIN;
 		prev->trbs[TRBS_PER_SEGMENT-1].link.control = val;
 	}
-	xhci_dbg(xhci, "Linking segment 0x%llx to segment 0x%llx (DMA)\n",
-			(unsigned long long)prev->dma,
-			(unsigned long long)next->dma);
 }
 
 /* XXX: Do we need the hcd structure in all these functions? */
@@ -114,7 +111,7 @@ void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
 		return;
 	first_seg = ring->first_seg;
 	seg = first_seg->next;
-	xhci_dbg(xhci, "Freeing ring at %p\n", ring);
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Freeing ring at %p\n", ring);
 	while (seg != first_seg) {
 		struct xhci_segment *next = seg->next;
 		xhci_segment_free(xhci, seg);
@@ -139,7 +136,6 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
 	struct xhci_segment	*prev;
 
 	ring = kzalloc(sizeof *(ring), flags);
-	xhci_dbg(xhci, "Allocating ring at %p\n", ring);
 	if (!ring)
 		return 0;
 
@@ -169,9 +165,6 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
 	if (link_trbs) {
 		/* See section 4.9.2.1 and 6.4.4.1 */
 		prev->trbs[TRBS_PER_SEGMENT-1].link.control |= (LINK_TOGGLE);
-		xhci_dbg(xhci, "Wrote link toggle flag to"
-				" segment %p (virtual), 0x%llx (DMA)\n",
-				prev, (unsigned long long)prev->dma);
 	}
 	/* The ring is empty, so the enqueue pointer == dequeue pointer */
 	ring->enqueue = ring->first_seg->trbs;
@@ -287,6 +280,8 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 		xhci_warn(xhci, "Bad Slot ID %d\n", slot_id);
 		return 0;
 	}
+	xhci_dbg(xhci, XHCI_LOG_DEVICE_STATE,
+			"Allocate device structure for slot ID %i\n", slot_id);
 
 	xhci->devs[slot_id] = kzalloc(sizeof(*xhci->devs[slot_id]), flags);
 	if (!xhci->devs[slot_id])
@@ -298,17 +293,11 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 	if (!dev->out_ctx)
 		goto fail;
 
-	xhci_dbg(xhci, "Slot %d output ctx = 0x%llx (dma)\n", slot_id,
-			(unsigned long long)dev->out_ctx->dma);
-
 	/* Allocate the (input) device context for address device command */
 	dev->in_ctx = xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_INPUT, flags);
 	if (!dev->in_ctx)
 		goto fail;
 
-	xhci_dbg(xhci, "Slot %d input ctx = 0x%llx (dma)\n", slot_id,
-			(unsigned long long)dev->in_ctx->dma);
-
 	/* Initialize the cancellation list for each endpoint */
 	for (i = 0; i < 31; i++)
 		INIT_LIST_HEAD(&dev->eps[i].cancelled_td_list);
@@ -323,10 +312,6 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 
 	/* Point to output device context in dcbaa. */
 	xhci->dcbaa->dev_context_ptrs[slot_id] = dev->out_ctx->dma;
-	xhci_dbg(xhci, "Set slot id %d dcbaa entry %p to 0x%llx\n",
-			slot_id,
-			&xhci->dcbaa->dev_context_ptrs[slot_id],
-			(unsigned long long) xhci->dcbaa->dev_context_ptrs[slot_id]);
 
 	return 1;
 fail:
@@ -375,7 +360,7 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 		slot_ctx->dev_info |= (u32) SLOT_SPEED_LS;
 		break;
 	case USB_SPEED_VARIABLE:
-		xhci_dbg(xhci, "FIXME xHCI doesn't support wireless speeds\n");
+		xhci_warn(xhci, "FIXME xHCI doesn't support wireless speeds\n");
 		return -EINVAL;
 		break;
 	default:
@@ -387,7 +372,6 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 			top_dev = top_dev->parent)
 		/* Found device below root hub */;
 	slot_ctx->dev_info2 |= (u32) ROOT_HUB_PORT(top_dev->portnum);
-	xhci_dbg(xhci, "Set root hub portnum to %d\n", top_dev->portnum);
 
 	/* Is this a LS/FS device under a HS hub? */
 	if ((udev->speed == USB_SPEED_LOW || udev->speed == USB_SPEED_FULL) &&
@@ -397,8 +381,6 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 		if (udev->tt->multi)
 			slot_ctx->dev_info |= DEV_MTT;
 	}
-	xhci_dbg(xhci, "udev->tt = %p\n", udev->tt);
-	xhci_dbg(xhci, "udev->ttport = 0x%x\n", udev->ttport);
 
 	/* Step 4 - ring already allocated */
 	/* Step 5 */
@@ -419,7 +401,7 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 		ep0_ctx->ep_info2 |= MAX_PACKET(8);
 		break;
 	case USB_SPEED_VARIABLE:
-		xhci_dbg(xhci, "FIXME xHCI doesn't support wireless speeds\n");
+		xhci_warn(xhci, "FIXME xHCI doesn't support wireless speeds\n");
 		return -EINVAL;
 		break;
 	default:
@@ -569,7 +551,7 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 		max_packet = ep->desc.wMaxPacketSize;
 		ep_ctx->ep_info2 |= MAX_PACKET(max_packet);
 		/* dig out max burst from ep companion desc */
-		if (!ep->ss_ep_comp) {
+		if (!ep->ss_ep_comp && udev->parent) {
 			xhci_warn(xhci, "WARN no SS endpoint companion descriptor.\n");
 			max_packet = 0;
 		} else {
@@ -667,7 +649,8 @@ static int scratchpad_alloc(struct xhci_hcd *xhci, gfp_t flags)
 	struct device *dev = xhci_to_hcd(xhci)->self.controller;
 	int num_sp = HCS_MAX_SCRATCHPAD(xhci->hcs_params2);
 
-	xhci_dbg(xhci, "Allocating %d scratchpad buffers\n", num_sp);
+	xhci_dbg(xhci, XHCI_LOG_INIT,
+			"Allocating %d scratchpad buffers\n", num_sp);
 
 	if (!num_sp)
 		return 0;
@@ -812,17 +795,14 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		pci_free_consistent(pdev, size,
 				xhci->erst.entries, xhci->erst.erst_dma_addr);
 	xhci->erst.entries = NULL;
-	xhci_dbg(xhci, "Freed ERST\n");
 	if (xhci->event_ring)
 		xhci_ring_free(xhci, xhci->event_ring);
 	xhci->event_ring = NULL;
-	xhci_dbg(xhci, "Freed event ring\n");
 
 	xhci_write_64(xhci, 0, &xhci->op_regs->cmd_ring);
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;
-	xhci_dbg(xhci, "Freed command ring\n");
 
 	for (i = 1; i < MAX_HC_SLOTS; ++i)
 		xhci_free_virt_device(xhci, i);
@@ -830,12 +810,10 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	if (xhci->segment_pool)
 		dma_pool_destroy(xhci->segment_pool);
 	xhci->segment_pool = NULL;
-	xhci_dbg(xhci, "Freed segment pool\n");
 
 	if (xhci->device_pool)
 		dma_pool_destroy(xhci->device_pool);
 	xhci->device_pool = NULL;
-	xhci_dbg(xhci, "Freed device context pool\n");
 
 	xhci_write_64(xhci, 0, &xhci->op_regs->dcbaa_ptr);
 	if (xhci->dcbaa)
@@ -859,32 +837,33 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	int i;
 
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
-	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
 		if ((0x1 & page_size) != 0)
 			break;
 		page_size = page_size >> 1;
 	}
 	if (i < 16)
-		xhci_dbg(xhci, "Supported page size of %iK\n", (1 << (i+12)) / 1024);
+		xhci_dbg(xhci, XHCI_LOG_INIT,
+				"Supported page size of %iK\n",
+				(1 << (i+12)) / 1024);
 	else
 		xhci_warn(xhci, "WARN: no supported page size\n");
 	/* Use 4K pages, since that's common and the minimum the HC supports */
 	xhci->page_shift = 12;
 	xhci->page_size = 1 << xhci->page_shift;
-	xhci_dbg(xhci, "HCD page size set to %iK\n", xhci->page_size / 1024);
+	xhci_dbg(xhci, XHCI_LOG_INIT,
+			"HCD page size set to %iK\n", xhci->page_size / 1024);
 
 	/*
 	 * Program the Number of Device Slots Enabled field in the CONFIG
 	 * register with the max value of slots the HC can handle.
 	 */
 	val = HCS_MAX_SLOTS(xhci_readl(xhci, &xhci->cap_regs->hcs_params1));
-	xhci_dbg(xhci, "// xHC can handle at most %d device slots.\n",
+	xhci_dbg(xhci, XHCI_LOG_INIT,
+			"xHC can handle at most %d device slots.\n",
 			(unsigned int) val);
 	val2 = xhci_readl(xhci, &xhci->op_regs->config_reg);
 	val |= (val2 & ~HCS_SLOTS_MASK);
-	xhci_dbg(xhci, "// Setting Max device slots reg = 0x%x.\n",
-			(unsigned int) val);
 	xhci_writel(xhci, val, &xhci->op_regs->config_reg);
 
 	/*
@@ -897,8 +876,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 		goto fail;
 	memset(xhci->dcbaa, 0, sizeof *(xhci->dcbaa));
 	xhci->dcbaa->dma = dma;
-	xhci_dbg(xhci, "// Device context base array address = 0x%llx (DMA), %p (virt)\n",
-			(unsigned long long)xhci->dcbaa->dma, xhci->dcbaa);
 	xhci_write_64(xhci, dma, &xhci->op_regs->dcbaa_ptr);
 
 	/*
@@ -917,25 +894,23 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 		goto fail;
 
 	/* Set up the command ring to have one segments for now. */
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Allocating command ring\n");
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, true, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
-	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
-			(unsigned long long)xhci->cmd_ring->first_seg->dma);
 
 	/* Set the address in the Command Ring Control register */
 	val_64 = xhci_read_64(xhci, &xhci->op_regs->cmd_ring);
 	val_64 = (val_64 & (u64) CMD_RING_RSVD_BITS) |
 		(xhci->cmd_ring->first_seg->dma & (u64) ~CMD_RING_RSVD_BITS) |
 		xhci->cmd_ring->cycle_state;
-	xhci_dbg(xhci, "// Setting command ring address to 0x%x\n", val);
 	xhci_write_64(xhci, val_64, &xhci->op_regs->cmd_ring);
 	xhci_dbg_cmd_ptrs(xhci);
 
 	val = xhci_readl(xhci, &xhci->cap_regs->db_off);
 	val &= DBOFF_MASK;
-	xhci_dbg(xhci, "// Doorbell array is located at offset 0x%x"
+	xhci_dbg(xhci, XHCI_LOG_INIT,
+			"Doorbell array is located at offset 0x%x"
 			" from cap regs base addr\n", val);
 	xhci->dba = (void *) xhci->cap_regs + val;
 	xhci_dbg_regs(xhci);
@@ -947,7 +922,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 * Event ring setup: Allocate a normal ring, but also setup
 	 * the event ring segment table (ERST).  Section 4.9.3.
 	 */
-	xhci_dbg(xhci, "// Allocating event ring\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Allocating event ring\n");
 	xhci->event_ring = xhci_ring_alloc(xhci, ERST_NUM_SEGS, false, flags);
 	if (!xhci->event_ring)
 		goto fail;
@@ -956,16 +931,10 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 			sizeof(struct xhci_erst_entry)*ERST_NUM_SEGS, &dma);
 	if (!xhci->erst.entries)
 		goto fail;
-	xhci_dbg(xhci, "// Allocated event ring segment table at 0x%llx\n",
-			(unsigned long long)dma);
 
 	memset(xhci->erst.entries, 0, sizeof(struct xhci_erst_entry)*ERST_NUM_SEGS);
 	xhci->erst.num_entries = ERST_NUM_SEGS;
 	xhci->erst.erst_dma_addr = dma;
-	xhci_dbg(xhci, "Set ERST to 0; private num segs = %i, virt addr = %p, dma addr = 0x%llx\n",
-			xhci->erst.num_entries,
-			xhci->erst.entries,
-			(unsigned long long)xhci->erst.erst_dma_addr);
 
 	/* set ring base address and size for each segment table entry */
 	for (val = 0, seg = xhci->event_ring->first_seg; val < ERST_NUM_SEGS; val++) {
@@ -980,14 +949,9 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	val = xhci_readl(xhci, &xhci->ir_set->erst_size);
 	val &= ERST_SIZE_MASK;
 	val |= ERST_NUM_SEGS;
-	xhci_dbg(xhci, "// Write ERST size = %i to ir_set 0 (some bits preserved)\n",
-			val);
 	xhci_writel(xhci, val, &xhci->ir_set->erst_size);
 
-	xhci_dbg(xhci, "// Set ERST entries to point to event ring.\n");
 	/* set the segment table base address */
-	xhci_dbg(xhci, "// Set ERST base address for ir_set 0 = 0x%llx\n",
-			(unsigned long long)xhci->erst.erst_dma_addr);
 	val_64 = xhci_read_64(xhci, &xhci->ir_set->erst_base);
 	val_64 &= ERST_PTR_MASK;
 	val_64 |= (xhci->erst.erst_dma_addr & (u64) ~ERST_PTR_MASK);
@@ -995,7 +959,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 	/* Set the event ring dequeue address */
 	xhci_set_hc_event_deq(xhci);
-	xhci_dbg(xhci, "Wrote ERST address to ir_set 0.\n");
 	xhci_print_ir_set(xhci, xhci->ir_set, 0);
 
 	/*
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 06595ec..0610bc7 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -41,9 +41,9 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
 
 	/* PCI Memory-Write-Invalidate cycle support is optional (uncommon) */
 	if (!pci_set_mwi(pdev))
-		xhci_dbg(xhci, "MWI active\n");
+		xhci_dbg(xhci, XHCI_LOG_INIT, "MWI active\n");
 
-	xhci_dbg(xhci, "Finished xhci_pci_reinit\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Finished xhci_pci_reinit\n");
 	return 0;
 }
 
@@ -73,7 +73,8 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
 			pdev->revision == 0x0) {
 			xhci->quirks |= XHCI_RESET_EP_QUIRK;
-			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
+			xhci_dbg(xhci, XHCI_LOG_QUIRKS,
+					"QUIRK: Fresco Logic xHC needs config"
 					" endpoint cmd after reset endpoint\n");
 	}
 
@@ -82,22 +83,20 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	xhci_dbg(xhci, "Resetting HCD\n");
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
 	retval = xhci_reset(xhci);
 	if (retval)
 		return retval;
-	xhci_dbg(xhci, "Reset complete\n");
 
-	xhci_dbg(xhci, "Calling HCD init\n");
 	/* Initialize HCD and host controller data structures. */
 	retval = xhci_init(hcd);
 	if (retval)
 		return retval;
-	xhci_dbg(xhci, "Called HCD init\n");
 
 	pci_read_config_byte(pdev, XHCI_SBRN_OFFSET, &xhci->sbrn);
-	xhci_dbg(xhci, "Got SBRN %u\n", (unsigned int) xhci->sbrn);
+	xhci_dbg(xhci, XHCI_LOG_INIT, "Got SBRN %u\n",
+			(unsigned int) xhci->sbrn);
 
 	/* Find any debug ports */
 	return xhci_pci_reinit(xhci, pdev);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 821b7b4..d71faf5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -144,10 +144,10 @@ static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer
 	while (last_trb(xhci, ring, ring->deq_seg, next)) {
 		if (consumer && last_trb_on_last_seg(xhci, ring, ring->deq_seg, next)) {
 			ring->cycle_state = (ring->cycle_state ? 0 : 1);
-			if (!in_interrupt())
-				xhci_dbg(xhci, "Toggle cycle state for ring %p = %i\n",
-						ring,
-						(unsigned int) ring->cycle_state);
+			xhci_dbg(xhci, (XHCI_LOG_QUIRKS | XHCI_LOG_RINGS),
+					"Toggle cycle state for ring %p = %i\n",
+					ring,
+					(unsigned int) ring->cycle_state);
 		}
 		ring->deq_seg = ring->deq_seg->next;
 		ring->dequeue = ring->deq_seg->trbs;
@@ -155,11 +155,14 @@ static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer
 	}
 	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->dequeue);
 	if (ring == xhci->event_ring)
-		xhci_dbg(xhci, "Event ring deq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Event ring deq = 0x%llx (DMA)\n", addr);
 	else if (ring == xhci->cmd_ring)
-		xhci_dbg(xhci, "Command ring deq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Command ring deq = 0x%llx (DMA)\n", addr);
 	else
-		xhci_dbg(xhci, "Ring deq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Ring deq = 0x%llx (DMA)\n", addr);
 }
 
 /*
@@ -181,6 +184,7 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer
 	u32 chain;
 	union xhci_trb *next;
 	unsigned long long addr;
+	unsigned int temp;
 
 	chain = ring->enqueue->generic.field[3] & TRB_CHAIN;
 	next = ++(ring->enqueue);
@@ -209,11 +213,11 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer
 			}
 			/* Toggle the cycle bit after the last ring segment. */
 			if (last_trb_on_last_seg(xhci, ring, ring->enq_seg, next)) {
+				temp = ring->cycle_state;
 				ring->cycle_state = (ring->cycle_state ? 0 : 1);
-				if (!in_interrupt())
-					xhci_dbg(xhci, "Toggle cycle state for ring %p = %i\n",
-							ring,
-							(unsigned int) ring->cycle_state);
+				xhci_dbg(xhci, XHCI_LOG_RINGS,
+						"Toggle cycle state for ring "
+						"%p = %i\n", ring, temp);
 			}
 		}
 		ring->enq_seg = ring->enq_seg->next;
@@ -222,11 +226,14 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer
 	}
 	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
 	if (ring == xhci->event_ring)
-		xhci_dbg(xhci, "Event ring enq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Event ring enq = 0x%llx (DMA)\n", addr);
 	else if (ring == xhci->cmd_ring)
-		xhci_dbg(xhci, "Command ring enq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Command ring enq = 0x%llx (DMA)\n", addr);
 	else
-		xhci_dbg(xhci, "Ring enq = 0x%llx (DMA)\n", addr);
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Ring enq = 0x%llx (DMA)\n", addr);
 }
 
 /*
@@ -275,7 +282,6 @@ void xhci_set_hc_event_deq(struct xhci_hcd *xhci)
 	 * there might be more events to service.
 	 */
 	temp &= ~ERST_EHB;
-	xhci_dbg(xhci, "// Write event ring dequeue pointer, preserving EHB bit\n");
 	xhci_write_64(xhci, ((u64) deq & (u64) ~ERST_PTR_MASK) | temp,
 			&xhci->ir_set->erst_dequeue);
 }
@@ -285,7 +291,7 @@ void xhci_ring_cmd_db(struct xhci_hcd *xhci)
 {
 	u32 temp;
 
-	xhci_dbg(xhci, "// Ding dong!\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Ding dong! (Command ring)\n");
 	temp = xhci_readl(xhci, &xhci->dba->doorbell[0]) & DB_MASK;
 	xhci_writel(xhci, temp | DB_TARGET_HOST, &xhci->dba->doorbell[0]);
 	/* Flush PCI posted writes */
@@ -369,19 +375,16 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	dma_addr_t addr;
 
 	state->new_cycle_state = 0;
-	xhci_dbg(xhci, "Finding segment containing stopped TRB.\n");
 	state->new_deq_seg = find_trb_seg(cur_td->start_seg,
 			dev->eps[ep_index].stopped_trb,
 			&state->new_cycle_state);
 	if (!state->new_deq_seg)
 		BUG();
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
-	xhci_dbg(xhci, "Finding endpoint context\n");
 	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
 	state->new_cycle_state = 0x1 & ep_ctx->deq;
 
 	state->new_deq_ptr = cur_td->last_trb;
-	xhci_dbg(xhci, "Finding segment containing last TRB in TD.\n");
 	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
 			state->new_deq_ptr,
 			&state->new_cycle_state);
@@ -395,12 +398,12 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
 
 	/* Don't update the ring cycle state for the producer (us). */
-	xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "Found new ring dequeue pointer.\n");
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "New dequeue segment = %p (virtual)\n",
 			state->new_deq_seg);
 	addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
-	xhci_dbg(xhci, "New dequeue pointer = 0x%llx (DMA)\n",
+	xhci_dbg(xhci, XHCI_LOG_RINGS, "New dequeue pointer = 0x%llx (DMA)\n",
 			(unsigned long long) addr);
-	xhci_dbg(xhci, "Setting dequeue pointer in internal ring state.\n");
 	ep_ring->dequeue = state->new_deq_ptr;
 	ep_ring->deq_seg = state->new_deq_seg;
 }
@@ -420,13 +423,6 @@ static void td_to_noop(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 			 * leave the pointers intact.
 			 */
 			cur_trb->generic.field[3] &= ~TRB_CHAIN;
-			xhci_dbg(xhci, "Cancel (unchain) link TRB\n");
-			xhci_dbg(xhci, "Address = %p (0x%llx dma); "
-					"in seg %p (0x%llx dma)\n",
-					cur_trb,
-					(unsigned long long)xhci_trb_virt_to_dma(cur_seg, cur_trb),
-					cur_seg,
-					(unsigned long long)cur_seg->dma);
 		} else {
 			cur_trb->generic.field[0] = 0;
 			cur_trb->generic.field[1] = 0;
@@ -434,12 +430,6 @@ static void td_to_noop(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 			/* Preserve only the cycle bit of this TRB */
 			cur_trb->generic.field[3] &= TRB_CYCLE;
 			cur_trb->generic.field[3] |= TRB_TYPE(TRB_TR_NOOP);
-			xhci_dbg(xhci, "Cancel TRB %p (0x%llx dma) "
-					"in seg %p (0x%llx dma)\n",
-					cur_trb,
-					(unsigned long long)xhci_trb_virt_to_dma(cur_seg, cur_trb),
-					cur_seg,
-					(unsigned long long)cur_seg->dma);
 		}
 		if (cur_trb == cur_td->last_trb)
 			break;
@@ -456,7 +446,8 @@ void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
 {
 	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
 
-	xhci_dbg(xhci, "Set TR Deq Ptr cmd, new deq seg = %p (0x%llx dma), "
+	xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_COMMANDS),
+			"Set TR Deq Ptr cmd, new deq seg = %p (0x%llx dma), "
 			"new deq ptr = %p (0x%llx dma), new cycle = %u\n",
 			deq_state->new_deq_seg,
 			(unsigned long long)deq_state->new_deq_seg->dma,
@@ -517,9 +508,6 @@ static void handle_stopped_endpoint(struct xhci_hcd *xhci,
 	 */
 	list_for_each(entry, &ep->cancelled_td_list) {
 		cur_td = list_entry(entry, struct xhci_td, cancelled_td_list);
-		xhci_dbg(xhci, "Cancelling TD starting at %p, 0x%llx (dma).\n",
-				cur_td->first_trb,
-				(unsigned long long)xhci_trb_virt_to_dma(cur_td->start_seg, cur_td->first_trb));
 		/*
 		 * If we stopped on the TD we need to cancel, then we have to
 		 * move the xHC endpoint ring dequeue pointer past this TD.
@@ -568,7 +556,8 @@ static void handle_stopped_endpoint(struct xhci_hcd *xhci,
 		cur_td->urb->hcpriv = NULL;
 		usb_hcd_unlink_urb_from_ep(xhci_to_hcd(xhci), cur_td->urb);
 
-		xhci_dbg(xhci, "Giveback cancelled URB %p\n", cur_td->urb);
+		xhci_dbg(xhci, XHCI_LOG_TX,
+				"Giveback cancelled URB %p\n", cur_td->urb);
 		spin_unlock(&xhci->lock);
 		/* Doesn't matter what we pass for status, since the core will
 		 * just overwrite it (because the URB has been unlinked).
@@ -623,7 +612,7 @@ static void handle_set_deq_completion(struct xhci_hcd *xhci,
 			ep_state &= EP_STATE_MASK;
 			slot_state = slot_ctx->dev_state;
 			slot_state = GET_SLOT_STATE(slot_state);
-			xhci_dbg(xhci, "Slot state = %u, EP state = %u\n",
+			xhci_warn(xhci, "Slot state = %u, EP state = %u\n",
 					slot_state, ep_state);
 			break;
 		case COMP_EBADSLT:
@@ -643,8 +632,9 @@ static void handle_set_deq_completion(struct xhci_hcd *xhci,
 		 * cancelling URBs, which might not be an error...
 		 */
 	} else {
-		xhci_dbg(xhci, "Successful Set TR Deq Ptr cmd, deq = @%08llx\n",
-				ep_ctx->deq);
+		xhci_dbg(xhci, (XHCI_LOG_RINGS | XHCI_LOG_COMMANDS),
+				"Successful Set TR Deq Ptr cmd, "
+				"deq = @%08llx\n", ep_ctx->deq);
 	}
 
 	dev->eps[ep_index].ep_state &= ~SET_DEQ_PENDING;
@@ -665,7 +655,8 @@ static void handle_reset_ep_completion(struct xhci_hcd *xhci,
 	/* This command will only fail if the endpoint wasn't halted,
 	 * but we don't care.
 	 */
-	xhci_dbg(xhci, "Ignoring reset ep completion code of %u\n",
+	xhci_dbg(xhci, XHCI_LOG_COMMANDS_VERBOSE,
+			"Ignoring reset ep completion code of %u\n",
 			(unsigned int) GET_COMP_CODE(event->status));
 
 	/* HW with the reset endpoint quirk needs to have a configure endpoint
@@ -673,7 +664,8 @@ static void handle_reset_ep_completion(struct xhci_hcd *xhci,
 	 * because the HW can't handle two commands being queued in a row.
 	 */
 	if (xhci->quirks & XHCI_RESET_EP_QUIRK) {
-		xhci_dbg(xhci, "Queueing configure endpoint command\n");
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Queueing configure endpoint command\n");
 		xhci_queue_configure_endpoint(xhci,
 				xhci->devs[slot_id]->in_ctx->dma, slot_id,
 				false);
@@ -774,7 +766,8 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 			break;
 		}
 		ep_state = xhci->devs[slot_id]->eps[ep_index].ep_state;
-		xhci_dbg(xhci, "Completed config ep cmd - last ep index = %d, "
+		xhci_dbg(xhci, XHCI_LOG_COMMANDS,
+				"Completed config ep cmd - last ep index = %d, "
 				"state = %d\n", ep_index, ep_state);
 		if (xhci->quirks & XHCI_RESET_EP_QUIRK &&
 				ep_state & EP_HALTED) {
@@ -831,7 +824,8 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	}
 	/* FIXME: core doesn't care about all port link state changes yet */
 	port_id = GET_PORT_ID(event->generic.field[0]);
-	xhci_dbg(xhci, "Port Status Change Event for port %d\n", port_id);
+	xhci_dbg(xhci, XHCI_LOG_PORTS,
+			"Port Status Change Event for port %d\n", port_id);
 
 	/* Update event ring dequeue pointer before dropping the lock */
 	inc_deq(xhci, xhci->event_ring, true);
@@ -922,7 +916,6 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
 
-	xhci_dbg(xhci, "In %s\n", __func__);
 	slot_id = TRB_TO_SLOT_ID(event->flags);
 	xdev = xhci->devs[slot_id];
 	if (!xdev) {
@@ -932,7 +925,6 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 
 	/* Endpoint ID is 1 based, our index is zero based */
 	ep_index = TRB_TO_EP_ID(event->flags) - 1;
-	xhci_dbg(xhci, "%s - ep index = %d\n", __func__, ep_index);
 	ep = &xdev->eps[ep_index];
 	ep_ring = ep->ring;
 	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
@@ -943,39 +935,40 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 
 	event_dma = event->buffer;
 	/* This TRB should be in the TD at the head of this ring's TD list */
-	xhci_dbg(xhci, "%s - checking for list empty\n", __func__);
 	if (list_empty(&ep_ring->td_list)) {
 		xhci_warn(xhci, "WARN Event TRB for slot %d ep %d with no TDs queued?\n",
 				TRB_TO_SLOT_ID(event->flags), ep_index);
-		xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
+		xhci_warn(xhci, "Event TRB with TRB type ID %u\n",
 				(unsigned int) (event->flags & TRB_TYPE_BITMASK)>>10);
 		xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
 		urb = NULL;
 		goto cleanup;
 	}
-	xhci_dbg(xhci, "%s - getting list entry\n", __func__);
 	td = list_entry(ep_ring->td_list.next, struct xhci_td, td_list);
 
 	/* Is this a TRB in the currently executing TD? */
-	xhci_dbg(xhci, "%s - looking for TD\n", __func__);
 	event_seg = trb_in_td(ep_ring->deq_seg, ep_ring->dequeue,
 			td->last_trb, event_dma);
-	xhci_dbg(xhci, "%s - found event_seg = %p\n", __func__, event_seg);
 	if (!event_seg) {
 		/* HC is busted, give up! */
 		xhci_err(xhci, "ERROR Transfer event TRB DMA ptr not part of current TD\n");
 		return -ESHUTDOWN;
 	}
 	event_trb = &event_seg->trbs[(event_dma - event_seg->dma) / sizeof(*event_trb)];
-	xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Event TRB with TRB type ID %u\n",
 			(unsigned int) (event->flags & TRB_TYPE_BITMASK)>>10);
-	xhci_dbg(xhci, "Offset 0x00 (buffer lo) = 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Offset 0x00 (buffer lo) = 0x%x\n",
 			lower_32_bits(event->buffer));
-	xhci_dbg(xhci, "Offset 0x04 (buffer hi) = 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Offset 0x04 (buffer hi) = 0x%x\n",
 			upper_32_bits(event->buffer));
-	xhci_dbg(xhci, "Offset 0x08 (transfer length) = 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Offset 0x08 (transfer length) = 0x%x\n",
 			(unsigned int) event->transfer_len);
-	xhci_dbg(xhci, "Offset 0x0C (flags) = 0x%x\n",
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Offset 0x0C (flags) = 0x%x\n",
 			(unsigned int) event->flags);
 
 	/* Look for common error cases */
@@ -988,13 +981,13 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	case COMP_SHORT_TX:
 		break;
 	case COMP_STOP:
-		xhci_dbg(xhci, "Stopped on Transfer TRB\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "Stopped on Transfer TRB\n");
 		break;
 	case COMP_STOP_INVAL:
-		xhci_dbg(xhci, "Stopped on No-op or Link TRB\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "Stopped on No-op or Link TRB\n");
 		break;
 	case COMP_STALL:
-		xhci_warn(xhci, "WARN: Stalled endpoint\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "Stalled endpoint\n");
 		ep->ep_state |= EP_HALTED;
 		status = -EPIPE;
 		break;
@@ -1003,11 +996,11 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		status = -EILSEQ;
 		break;
 	case COMP_TX_ERR:
-		xhci_warn(xhci, "WARN: transfer error on endpoint\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "Transfer error on endpoint\n");
 		status = -EPROTO;
 		break;
 	case COMP_BABBLE:
-		xhci_warn(xhci, "WARN: babble error on endpoint\n");
+		xhci_dbg(xhci, XHCI_LOG_TX, "Babble error on endpoint\n");
 		status = -EOVERFLOW;
 		break;
 	case COMP_DB_ERR:
@@ -1032,12 +1025,15 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				xhci_warn(xhci, "WARN: Success on ctrl data TRB without IOC set??\n");
 				status = -ESHUTDOWN;
 			} else {
-				xhci_dbg(xhci, "Successful control transfer!\n");
+				xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+						"Successful "
+						"control transfer!\n");
 				status = 0;
 			}
 			break;
 		case COMP_SHORT_TX:
-			xhci_warn(xhci, "WARN: short transfer on control ep\n");
+			xhci_dbg(xhci, XHCI_LOG_TX,
+					"Short transfer on control ep\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 				status = -EREMOTEIO;
 			else
@@ -1099,7 +1095,9 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 					td->urb->actual_length =
 						td->urb->transfer_buffer_length -
 						TRB_LEN(event->transfer_len);
-					xhci_dbg(xhci, "Waiting for status stage event\n");
+					xhci_dbg(xhci, XHCI_LOG_TX,
+							"Waiting for "
+							"status stage event\n");
 					urb = NULL;
 					goto cleanup;
 				}
@@ -1118,10 +1116,12 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 					status = 0;
 			} else {
 				if (usb_endpoint_xfer_bulk(&td->urb->ep->desc))
-					xhci_dbg(xhci, "Successful bulk "
+					xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+							"Successful bulk "
 							"transfer!\n");
 				else
-					xhci_dbg(xhci, "Successful interrupt "
+					xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+							"Successful interrupt "
 							"transfer!\n");
 				status = 0;
 			}
@@ -1136,9 +1136,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			/* Others already handled above */
 			break;
 		}
-		dev_dbg(&td->urb->dev->dev,
-				"ep %#x - asked for %d bytes, "
+		xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+				"slot ID %u, ep %#x - asked for %d bytes, "
 				"%d bytes untransferred\n",
+				td->urb->dev->slot_id,
 				td->urb->ep->desc.bEndpointAddress,
 				td->urb->transfer_buffer_length,
 				TRB_LEN(event->transfer_len));
@@ -1272,7 +1273,8 @@ cleanup:
 	/* FIXME for multi-TD URBs (who have buffers bigger than 64MB) */
 	if (urb) {
 		usb_hcd_unlink_urb_from_ep(xhci_to_hcd(xhci), urb);
-		xhci_dbg(xhci, "Giveback URB %p, len = %d, status = %d\n",
+		xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+				"Giveback URB %p, len = %d, status = %d\n",
 				urb, urb->actual_length, status);
 		spin_unlock(&xhci->lock);
 		usb_hcd_giveback_urb(xhci_to_hcd(xhci), urb, status);
@@ -1291,7 +1293,6 @@ void xhci_handle_event(struct xhci_hcd *xhci)
 	int update_ptrs = 1;
 	int ret;
 
-	xhci_dbg(xhci, "In %s\n", __func__);
 	if (!xhci->event_ring || !xhci->event_ring->dequeue) {
 		xhci->error_bitmask |= 1 << 1;
 		return;
@@ -1304,25 +1305,18 @@ void xhci_handle_event(struct xhci_hcd *xhci)
 		xhci->error_bitmask |= 1 << 2;
 		return;
 	}
-	xhci_dbg(xhci, "%s - OS owns TRB\n", __func__);
 
 	/* FIXME: Handle more event types. */
 	switch ((event->event_cmd.flags & TRB_TYPE_BITMASK)) {
 	case TRB_TYPE(TRB_COMPLETION):
-		xhci_dbg(xhci, "%s - calling handle_cmd_completion\n", __func__);
 		handle_cmd_completion(xhci, &event->event_cmd);
-		xhci_dbg(xhci, "%s - returned from handle_cmd_completion\n", __func__);
 		break;
 	case TRB_TYPE(TRB_PORT_STATUS):
-		xhci_dbg(xhci, "%s - calling handle_port_status\n", __func__);
 		handle_port_status(xhci, event);
-		xhci_dbg(xhci, "%s - returned from handle_port_status\n", __func__);
 		update_ptrs = 0;
 		break;
 	case TRB_TYPE(TRB_TRANSFER):
-		xhci_dbg(xhci, "%s - calling handle_tx_event\n", __func__);
 		ret = handle_tx_event(xhci, &event->trans_event);
-		xhci_dbg(xhci, "%s - returned from handle_tx_event\n", __func__);
 		if (ret < 0)
 			xhci->error_bitmask |= 1 << 9;
 		else
@@ -1369,7 +1363,11 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 		u32 ep_state, unsigned int num_trbs, gfp_t mem_flags)
 {
 	/* Make sure the endpoint has been added to xHC schedule */
-	xhci_dbg(xhci, "Endpoint state = 0x%x\n", ep_state);
+	if (ep_state != EP_STATE_STOPPED &&
+			ep_state != EP_STATE_RUNNING)
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				"Endpoint state = 0x%x\n", ep_state);
+
 	switch (ep_state) {
 	case EP_STATE_DISABLED:
 		/*
@@ -1384,7 +1382,8 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 		/* XXX not sure if this should be -ENOENT or not */
 		return -EINVAL;
 	case EP_STATE_HALTED:
-		xhci_dbg(xhci, "WARN halted endpoint, queueing URB anyway.\n");
+		xhci_dbg(xhci, XHCI_LOG_TX,
+				"Halted endpoint, queueing URB anyway.\n");
 	case EP_STATE_STOPPED:
 	case EP_STATE_RUNNING:
 		break;
@@ -1450,10 +1449,8 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 	num_sgs = urb->num_sgs;
 	temp = urb->transfer_buffer_length;
 
-	xhci_dbg(xhci, "count sg list trbs: \n");
 	num_trbs = 0;
 	for_each_sg(urb->sg->sg, sg, num_sgs, i) {
-		unsigned int previous_total_trbs = num_trbs;
 		unsigned int len = sg_dma_len(sg);
 
 		/* Scatter gather list entries may cross 64KB boundaries */
@@ -1467,21 +1464,19 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 			num_trbs++;
 			running_total += TRB_MAX_BUFF_SIZE;
 		}
-		xhci_dbg(xhci, " sg #%d: dma = %#llx, len = %#x (%d), num_trbs = %d\n",
-				i, (unsigned long long)sg_dma_address(sg),
-				len, len, num_trbs - previous_total_trbs);
 
 		len = min_t(int, len, temp);
 		temp -= len;
 		if (temp == 0)
 			break;
 	}
-	xhci_dbg(xhci, "\n");
-	if (!in_interrupt())
-		dev_dbg(&urb->dev->dev, "ep %#x - urb len = %d, sglist used, num_trbs = %d\n",
-				urb->ep->desc.bEndpointAddress,
-				urb->transfer_buffer_length,
-				num_trbs);
+	xhci_dbg(xhci, XHCI_LOG_RINGS,
+			"slot ID %u ep %#x - urb len = %d, "
+			"sglist used, num_trbs = %d\n",
+			urb->dev->slot_id,
+			urb->ep->desc.bEndpointAddress,
+			urb->transfer_buffer_length,
+			num_trbs);
 	return num_trbs;
 }
 
@@ -1539,7 +1534,8 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 */
 	if (xhci_interval != ep_interval) {
 		if (!printk_ratelimit())
-			dev_dbg(&urb->dev->dev, "Driver uses different interval"
+			xhci_dbg(xhci, XHCI_LOG_TX,
+					"Driver uses different interval"
 					" (%d microframe%s) than xHCI "
 					"(%d microframe%s)\n",
 					ep_interval,
@@ -1604,8 +1600,6 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
-	xhci_dbg(xhci, "First length to xfer from 1st sglist entry = %u\n",
-			trb_buff_len);
 
 	first_trb = true;
 	/* Queue the first TRB, even if it's zero-length */
@@ -1629,7 +1623,8 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 			td->last_trb = ep_ring->enqueue;
 			field |= TRB_IOC;
 		}
-		xhci_dbg(xhci, " sg entry: dma = %#x, len = %#x (%d), "
+		xhci_dbg(xhci, XHCI_LOG_RINGS,
+				" sg entry: dma = %#x, len = %#x (%d), "
 				"64KB boundary at %#x, end dma = %#x\n",
 				(unsigned int) addr, trb_buff_len, trb_buff_len,
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -1637,7 +1632,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		if (TRB_MAX_BUFF_SIZE -
 				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
-			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
+			xhci_warn(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 					(unsigned int) addr + trb_buff_len);
 		}
@@ -1722,13 +1717,15 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	}
 	/* FIXME: this doesn't deal with URB_ZERO_PACKET - need one more */
 
-	if (!in_interrupt())
-		dev_dbg(&urb->dev->dev, "ep %#x - urb len = %#x (%d), addr = %#llx, num_trbs = %d\n",
-				urb->ep->desc.bEndpointAddress,
-				urb->transfer_buffer_length,
-				urb->transfer_buffer_length,
-				(unsigned long long)urb->transfer_dma,
-				num_trbs);
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Slot ID %u ep %#x - urb len = %#x (%d), "
+			"addr = %#llx, num_trbs = %d\n",
+			urb->dev->slot_id,
+			urb->ep->desc.bEndpointAddress,
+			urb->transfer_buffer_length,
+			urb->transfer_buffer_length,
+			(unsigned long long)urb->transfer_dma,
+			num_trbs);
 
 	ret = prepare_transfer(xhci, xhci->devs[slot_id], ep_index,
 			num_trbs, urb, &td, mem_flags);
@@ -1823,9 +1820,9 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	if (!urb->setup_packet)
 		return -EINVAL;
 
-	if (!in_interrupt())
-		xhci_dbg(xhci, "Queueing ctrl tx for slot id %d, ep %d\n",
-				slot_id, ep_index);
+	xhci_dbg(xhci, XHCI_LOG_TX_VERBOSE,
+			"Queueing ctrl tx for slot id %d, ep %d\n",
+			slot_id, ep_index);
 	/* 1 TRB for setup, 1 for status */
 	num_trbs = 2;
 	/*
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 4b254b6..473e485 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1090,6 +1090,19 @@ struct xhci_hcd {
 	unsigned int		quirks;
 #define	XHCI_LINK_TRB_QUIRK	(1 << 0)
 #define XHCI_RESET_EP_QUIRK	(1 << 1)
+	unsigned int		log_level;
+#define XHCI_LOG_QUIRKS			(1 << 0)
+#define XHCI_LOG_COMMANDS		(1 << 1)
+#define XHCI_LOG_COMMANDS_VERBOSE	(1 << 2)
+#define XHCI_LOG_INIT			(1 << 3)
+#define XHCI_LOG_EVENTS			(1 << 4)
+#define XHCI_LOG_DEVICE_STATE		(1 << 5)
+#define XHCI_LOG_TX			(1 << 6)
+#define XHCI_LOG_TX_VERBOSE		(1 << 7)
+#define XHCI_LOG_NOOPS			(1 << 8)
+#define XHCI_LOG_RINGS			(1 << 9)
+#define XHCI_LOG_PORTS			(1 << 10)
+#define XHCI_LOG_REGS			(1 << 11)
 };
 
 /* For testing purposes */
@@ -1112,8 +1125,18 @@ static inline struct usb_hcd *xhci_to_hcd(struct xhci_hcd *xhci)
 #define XHCI_DEBUG	0
 #endif
 
-#define xhci_dbg(xhci, fmt, args...) \
-	do { if (XHCI_DEBUG) dev_dbg(xhci_to_hcd(xhci)->self.controller , fmt , ## args); } while (0)
+#if XHCI_DEBUG
+#define xhci_dbg(xhci, lvl, fmt, args...)			\
+do {								\
+	if (lvl & xhci->log_level)			\
+		dev_dbg(xhci_to_hcd(xhci)->self.controller ,	\
+				fmt , ## args);			\
+} while (0)
+#else
+#define xhci_dbg(xhci, lvl, fmt, args...)			\
+do {} while (0)
+#endif
+
 #define xhci_info(xhci, fmt, args...) \
 	do { if (XHCI_DEBUG) dev_info(xhci_to_hcd(xhci)->self.controller , fmt , ## args); } while (0)
 #define xhci_err(xhci, fmt, args...) \
@@ -1131,7 +1154,7 @@ static inline unsigned int xhci_readl(const struct xhci_hcd *xhci,
 static inline void xhci_writel(struct xhci_hcd *xhci,
 		const unsigned int val, __u32 __iomem *regs)
 {
-	xhci_dbg(xhci,
+	xhci_dbg(xhci, XHCI_LOG_REGS,
 			"`MEM_WRITE_DWORD(3'b000, 32'h%p, 32'h%0x, 4'hf);\n",
 			regs, val);
 	writel(val, regs);
@@ -1161,7 +1184,7 @@ static inline void xhci_write_64(struct xhci_hcd *xhci,
 	u32 val_lo = lower_32_bits(val);
 	u32 val_hi = upper_32_bits(val);
 
-	xhci_dbg(xhci,
+	xhci_dbg(xhci, XHCI_LOG_REGS,
 			"`MEM_WRITE_DWORD(3'b000, 64'h%p, 64'h%0lx, 4'hf);\n",
 			regs, (long unsigned int) val);
 	writel(val_lo, ptr);
-- 
1.6.3.3


--tKW2IUtsqtDRztdT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-USB-xhci-Handle-errors-that-cause-endpoint-halts.patch"

>From 1bd817eafb9411f0da8ae97f8e2590864e90bcef Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Wed, 11 Nov 2009 10:28:44 -0800
Subject: [PATCH 2/2] USB: xhci: Handle errors that cause endpoint halts.

The xHCI 0.95 and 0.96 specification defines several transfer buffer
request completion codes that indicate a USB transaction error occurred.
When a stall, babble, transaction, or split transaction error completion code
is set, the xHCI has halted that endpoint ring.  Software must issue a
Reset Endpoint command and a Set Transfer Ring Dequeue Pointer command
to clean up the halted ring.

The USB device driver is supposed to call into usb_reset_endpoint() when
an endpoint stalls.  That calls into the xHCI driver to issue the proper
commands.  However, drivers don't call that function for the other
errors that cause the xHC to halt the endpoint ring.  If a babble,
transaction, or split transaction error occurs, check if the endpoint
context reports a halted condition, and clean up the endpoint ring if it
does.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/xhci-ring.c |   79 ++++++++++++++++++++++++++++++++----------
 1 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d71faf5..73954bc 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -894,6 +894,45 @@ static struct xhci_segment *trb_in_td(
 	return 0;
 }
 
+static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
+		unsigned int slot_id, unsigned int ep_index,
+		struct xhci_td *td, union xhci_trb *event_trb)
+{
+	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep->ep_state |= EP_HALTED;
+	ep->stopped_td = td;
+	ep->stopped_trb = event_trb;
+	xhci_queue_reset_ep(xhci, slot_id, ep_index);
+	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
+	xhci_ring_cmd_db(xhci);
+}
+
+/* Check if an error has halted the endpoint ring.  The class driver will
+ * cleanup the halt for a non-default control endpoint if we indicate a stall.
+ * However, a babble and other errors also halt the endpoint ring, and the class
+ * driver won't clear the halt in that case, so we need to issue a Set Transfer
+ * Ring Dequeue Pointer command manually.
+ */
+static int xhci_requires_manual_halt_cleanup(struct xhci_hcd *xhci,
+		struct xhci_ep_ctx *ep_ctx,
+		unsigned int trb_comp_code)
+{
+	/* TRB completion codes that may require a manual halt cleanup */
+	if (trb_comp_code == COMP_TX_ERR ||
+			trb_comp_code == COMP_BABBLE ||
+			trb_comp_code == COMP_SPLIT_ERR)
+		/* The 0.96 spec says a babbling control endpoint
+		 * is not halted. The 0.96 spec says it is.  Some HW
+		 * claims to be 0.95 compliant, but it halts the control
+		 * endpoint anyway.  Check if a babble halted the
+		 * endpoint.
+		 */
+		if ((ep_ctx->ep_info & EP_STATE_MASK) == EP_STATE_HALTED)
+			return 1;
+
+	return 0;
+}
+
 /*
  * If this function returns an error condition, it means it got a Transfer
  * event with a corrupted Slot ID, Endpoint ID, or TRB DMA address.
@@ -1039,15 +1078,14 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			else
 				status = 0;
 			break;
-		case COMP_BABBLE:
-			/* The 0.96 spec says a babbling control endpoint
-			 * is not halted. The 0.96 spec says it is.  Some HW
-			 * claims to be 0.95 compliant, but it halts the control
-			 * endpoint anyway.  Check if a babble halted the
-			 * endpoint.
-			 */
-			if (ep_ctx->ep_info != EP_STATE_HALTED)
+
+		default:
+			if (!xhci_requires_manual_halt_cleanup(xhci,
+						ep_ctx, trb_comp_code))
 				break;
+			xhci_dbg(xhci, "TRB error code %u, "
+					"halted endpoint index = %u\n",
+					trb_comp_code, ep_index);
 			/* else fall through */
 		case COMP_STALL:
 			/* Did we transfer part of the data (middle) phase? */
@@ -1059,15 +1097,9 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			else
 				td->urb->actual_length = 0;
 
-			ep->stopped_td = td;
-			ep->stopped_trb = event_trb;
-			xhci_queue_reset_ep(xhci, slot_id, ep_index);
-			xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
-			xhci_ring_cmd_db(xhci);
+			xhci_cleanup_halted_endpoint(xhci,
+					slot_id, ep_index, td, event_trb);
 			goto td_cleanup;
-		default:
-			/* Others already handled above */
-			break;
 		}
 		/*
 		 * Did we transfer any data, despite the errors that might have
@@ -1210,16 +1242,25 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		ep->stopped_td = td;
 		ep->stopped_trb = event_trb;
 	} else {
-		if (trb_comp_code == COMP_STALL ||
-				trb_comp_code == COMP_BABBLE) {
+		if (trb_comp_code == COMP_STALL) {
 			/* The transfer is completed from the driver's
 			 * perspective, but we need to issue a set dequeue
 			 * command for this stalled endpoint to move the dequeue
 			 * pointer past the TD.  We can't do that here because
-			 * the halt condition must be cleared first.
+			 * the halt condition must be cleared first.  Let the
+			 * USB class driver clear the stall later.
 			 */
 			ep->stopped_td = td;
 			ep->stopped_trb = event_trb;
+		} else if (xhci_requires_manual_halt_cleanup(xhci,
+					ep_ctx, trb_comp_code)) {
+			/* Other types of errors halt the endpoint, but the
+			 * class driver doesn't call usb_reset_endpoint() unless
+			 * the error is -EPIPE.  Clear the halted status in the
+			 * xHCI hardware manually.
+			 */
+			xhci_cleanup_halted_endpoint(xhci,
+					slot_id, ep_index, td, event_trb);
 		} else {
 			/* Update ring dequeue pointer */
 			while (ep_ring->dequeue != td->last_trb)
-- 
1.6.3.3


--tKW2IUtsqtDRztdT--
