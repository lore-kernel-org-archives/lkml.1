Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZISGAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZISGAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZISGA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:00:29 -0400
Received: from smtp.wp.pl ([212.77.101.1]:55653 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbZISGA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:00:28 -0400
Date: Sat, 19 Sep 2009 08:15:49 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hid-core: fix lockdep in hid_input_report()
Message-Id: <20090919081549.669b6773.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [sdM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

There is a lockdep warning in the hid_input_report() due to dynamic allocation
of a temporary buffer.
Change the buffer to a local variable. The buffer size is 512 chars.

The lockdep trace is:

WARNING: at kernel/lockdep.c:2457 lockdep_trace_alloc+0xca/0xd0()
Hardware name: Product Name
Modules linked in: usbhid(+) hid uhci_hcd ne2k_pci via_agp 8390 i2c_via
Pid: 0, comm: swapper Not tainted 2.6.31 #74
Call Trace:
 [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
 [<c0221d1c>] warn_slowpath_common+0x7c/0xa0
 [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
 [<c0221d55>] warn_slowpath_null+0x15/0x20
 [<c0243b8a>] lockdep_trace_alloc+0xca/0xd0
 [<c027d2c8>] kmem_cache_alloc+0x28/0x100
 [<cc9359ef>] ? hid_input_report+0x6f/0x220 [hid]
 [<cc9359ef>] hid_input_report+0x6f/0x220 [hid]
 [<cc94cabf>] hid_ctrl+0x7f/0x180 [usbhid]
 [<c03b28b1>] usb_hcd_giveback_urb+0x41/0xa0
 [<cc91a3fc>] uhci_giveback_urb+0x8c/0x280 [uhci_hcd]
 [<c0279853>] ? dma_pool_free+0xd3/0x120
 [<cc919848>] ? uhci_free_td+0x58/0xa0 [uhci_hcd]
 [<cc91ac01>] uhci_scan_schedule+0x301/0x910 [uhci_hcd]
 [<cc91cac4>] uhci_irq+0x94/0x940 [uhci_hcd]
 [<c0245c43>] ? __lock_acquire+0x433/0xab0
 [<c0206246>] ? mask_and_ack_8259A+0x66/0x100
 [<c03b494b>] usb_hcd_irq+0x6b/0x90
 [<c0255e7d>] handle_IRQ_event+0x2d/0xc0
 [<c0257e85>] handle_level_irq+0x65/0xe0
 [<c0204c74>] handle_irq+0x34/0x60
 [<c0204bc9>] do_IRQ+0x39/0xb0
 [<c024365c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c020328e>] common_interrupt+0x2e/0x40
 [<c0208d48>] ? default_idle+0x38/0x50
 [<c02108df>] apm_cpu_idle+0x10f/0x290
 [<c0201b11>] cpu_idle+0x21/0x40
 [<c045892d>] rest_init+0x4d/0x60
 [<c0575815>] start_kernel+0x235/0x280
 [<c05751f0>] ? unknown_bootoption+0x0/0x210
 [<c057503f>] __init_begin+0x3f/0x50

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
This lockdep is in the current git tree.

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 342b7d3..eb7968d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1075,7 +1075,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
-	char *buf;
+	char buf[HID_DEBUG_BUFSIZE];
 	unsigned int i;
 	int ret;
 
@@ -1089,21 +1089,12 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 		return -1;
 	}
 
-	buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE,
-			interrupt ? GFP_ATOMIC : GFP_KERNEL);
-
-	if (!buf) {
-		report = hid_get_report(report_enum, data);
-		goto nomem;
-	}
-
 	snprintf(buf, HID_DEBUG_BUFSIZE - 1,
 			"\nreport (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
 	hid_debug_event(hid, buf);
 
 	report = hid_get_report(report_enum, data);
 	if (!report) {
-		kfree(buf);
 		return -1;
 	}
 
@@ -1118,9 +1109,6 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 	}
 	hid_debug_event(hid, "\n");
 
-	kfree(buf);
-
-nomem:
 	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
 		ret = hdrv->raw_event(hid, report, data, size);
 		if (ret != 0)
