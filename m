Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZFDTKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZFDTKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZFDTJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:09:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50553 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFDTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:09:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 4 Jun 2009 21:09:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: clean up includes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.a308ae965adc8ea8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include required headers which were only indirectly included.
Remove unused includes and an unused constant.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |   15 ++++++++++++---
 drivers/firewire/fw-device.c      |    3 +++
 drivers/firewire/fw-iso.c         |    2 ++
 drivers/firewire/fw-ohci.c        |    7 ++++++-
 drivers/firewire/fw-sbp2.c        |   12 ++++++++++--
 drivers/firewire/fw-topology.c    |   16 ++++++++++++----
 drivers/firewire/fw-transaction.c |   28 ++++++++++++++++------------
 7 files changed, 61 insertions(+), 22 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -16,18 +16,27 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/completion.h>
 #include <linux/crc-itu-t.h>
-#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+
+#include <asm/atomic.h>
+#include <asm/byteorder.h>
 
-#include "fw-transaction.h"
-#include "fw-topology.h"
 #include "fw-device.h"
+#include "fw-topology.h"
+#include "fw-transaction.h"
 
 int fw_compute_block_crc(u32 *block)
 {
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -27,6 +27,7 @@
 #include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/mod_devicetable.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/semaphore.h>
@@ -34,6 +35,8 @@
 #include <linux/string.h>
 #include <linux/workqueue.h>
 
+#include <asm/atomic.h>
+#include <asm/byteorder.h>
 #include <asm/system.h>
 
 #include "fw-device.h"
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -28,6 +28,8 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 
+#include <asm/byteorder.h>
+
 #include "fw-topology.h"
 #include "fw-transaction.h"
 
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -20,18 +20,24 @@
 
 #include <linux/compiler.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/firewire-constants.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 
 #include <asm/atomic.h>
+#include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/system.h>
 
@@ -232,7 +238,6 @@ static inline struct fw_ohci *fw_ohci(st
 #define OHCI1394_MAX_AT_RESP_RETRIES	0x2
 #define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
 
-#define FW_OHCI_MAJOR			240
 #define OHCI1394_REGISTER_SIZE		0x800
 #define OHCI_LOOP_COUNT			500
 #define OHCI1394_PCI_HCI_Control	0x40
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -30,18 +30,27 @@
 
 #include <linux/blkdev.h>
 #include <linux/bug.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/firewire-constants.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/stringify.h>
-#include <linux/timer.h>
 #include <linux/workqueue.h>
+
+#include <asm/byteorder.h>
 #include <asm/system.h>
 
 #include <scsi/scsi.h>
@@ -50,7 +59,6 @@
 #include <scsi/scsi_host.h>
 
 #include "fw-device.h"
-#include "fw-topology.h"
 #include "fw-transaction.h"
 
 /*
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -18,13 +18,21 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/module.h>
-#include <linux/wait.h>
+#include <linux/bug.h>
 #include <linux/errno.h>
-#include <asm/bug.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+#include <asm/atomic.h>
 #include <asm/system.h>
-#include "fw-transaction.h"
+
 #include "fw-topology.h"
+#include "fw-transaction.h"
 
 #define SELF_ID_PHY_ID(q)		(((q) >> 24) & 0x3f)
 #define SELF_ID_EXTENDED(q)		(((q) >> 23) & 0x01)
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -18,24 +18,28 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/firewire-constants.h>
+#include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/idr.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
-#include <linux/kref.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/poll.h>
 #include <linux/list.h>
-#include <linux/kthread.h>
-#include <asm/uaccess.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+
+#include <asm/byteorder.h>
 
+#include "fw-device.h"	/* for fw_device_ops */
 #include "fw-transaction.h"
-#include "fw-topology.h"
-#include "fw-device.h"
 
 #define HEADER_PRI(pri)			((pri) << 0)
 #define HEADER_TCODE(tcode)		((tcode) << 4)

-- 
Stefan Richter
-=====-==--= -==- --=--
http://arcgraph.de/sr/

