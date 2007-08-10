Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXHJM3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXHJM3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbXHJM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:29:45 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:36096 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXHJM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:29:44 -0400
Message-ID: <46BC59E2.9060102@csr.com>
Date: Fri, 10 Aug 2007 13:28:18 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus-list@drzeus.cx>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR registers
References: <46BC58E8.50300@csr.com>
In-Reply-To: <46BC58E8.50300@csr.com>
Content-Type: multipart/mixed;
 boundary="------------090605020305080000020302"
X-OriginalArrivalTime: 10 Aug 2007 12:28:31.0056 (UTC) FILETIME=[F60E0D00:01C7DB49]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090605020305080000020302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------090605020305080000020302
Content-Type: text/x-patch;
 name="sdio-csr-regs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-csr-regs.patch"

sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR registers

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/include/linux/mmc/sdio_csr.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ mmc/include/linux/mmc/sdio_csr.h	2007-08-10 01:16:14.000000000 +0100
@@ -0,0 +1,116 @@
+/*
+ * SDIO CCCR vendor registers for CSR chips.
+ *
+ * Copyright (C) 2007 Cambridge Silicon Radio Ltd.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef LINUX_MMC_SDIO_CSR_H
+#define LINUX_MMC_SDIO_CSR_H
+
+/*
+ * Registers at 0xF0 - 0xFF in the CCCR are reserved for vendor
+ * specific registers.  The registers defined here are specific to
+ * following CSR chips:
+ *
+ *   - BlueCore (6 and later)
+ */
+
+/*
+ * Interrupt status/host wakeup register.
+ *
+ * This controls a function's deep sleep state.
+ *
+ * See enum sdio_sleep_state.
+ */
+#define SDIO_CSR_SLEEP_STATE 0xf0
+#  define SDIO_CSR_SLEEP_STATE_FUNC(f) ((f) << 4)
+#  define SDIO_CSR_SLEEP_STATE_RDY_INT_EN  0x02
+#  define SDIO_CSR_SLEEP_STATE_WAKE_REQ    0x01
+
+/*
+ * Host interrupt clear register.
+ *
+ * Writing a 1 to bit 0 clears an SDIO interrupt raised by a generic
+ * function.
+ */
+#define SDIO_CSR_HOST_INT 0xf1
+#  define SDIO_CSR_HOST_INT_CL 0x01
+
+/*
+ * From host scratch registers 0 and 1.
+ *
+ * Read/write registers that can be used for signalling between the
+ * host and the chip.
+ *
+ * The usage of this register depends on the version of the chip or
+ * firmware.
+ */
+#define SDIO_CSR_FROM_HOST_SCRATCH0 0xf2
+#define SDIO_CSR_FROM_HOST_SCRATCH1 0xf3
+
+/*
+ * To host scratch register 0 and 1.
+ *
+ * Read only registers that may be used for signalling between the
+ * chip and the host.
+ *
+ * The usage of this register depends on the version of the chip or
+ * firmware.
+ */
+#define SDIO_CSR_TO_HOST_SCRATCH0 0xf4
+#define SDIO_CSR_TO_HOST_SCRATCH1 0xf5
+
+/*
+ * Extended I/O enable.
+ *
+ * Similar to the standard CCCR I/O Enable register, this is used to
+ * detect if an internal reset of a function has occured and
+ * (optionally) reenable it.
+ *
+ * An internal reset is detected by CCCR I/O Enable bit being set and
+ * the corresponding EXT_IO_EN bit being clear.
+ */
+#define SDIO_CSR_EXT_IO_EN 0xf6
+
+/*
+ * Deep sleep states as set via the sleep state register.
+ *
+ * These states are used to control when the chip may go into a deep
+ * sleep (a low power mode).
+ *
+ * Since a chip in deep sleep may not respond to SDIO commands, the
+ * host should ensure that the chip is not in deep sleep before
+ * attempting SDIO commands to functions 1 to 7.
+ *
+ * The available states are:
+ *
+ * AWAKE - chip must not enter deep sleep and should exit deep sleep
+ * if it's currently sleeping.
+ *
+ * TORPID - chip may enter deep sleep.
+ *
+ * DROWSY - a transition state between TORPID and AWAKE.  This is
+ * AWAKE plus the chip asserts an interrupt when the chip is awake.
+ *
+ * See SDIO_CSR_SLEEP_STATE.
+ */
+enum sdio_csr_sleep_state {
+	SDIO_CSR_SLEEP_STATE_AWAKE  = SDIO_CSR_SLEEP_STATE_WAKE_REQ,
+	SDIO_CSR_SLEEP_STATE_DROWSY = SDIO_CSR_SLEEP_STATE_WAKE_REQ
+	                            | SDIO_CSR_SLEEP_STATE_RDY_INT_EN,
+	SDIO_CSR_SLEEP_STATE_TORPID = 0x00,
+};
+
+#endif /* LINUX_MMC_SDIO_CSR_H */

--------------090605020305080000020302--
