Return-Path: <linux-kernel-owner+w=401wt.eu-S966044AbXJPWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966044AbXJPWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbXJPWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:40:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44275 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748AbXJPWkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:40:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Oct 2007 00:40:28 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] FireWire updates post 2.6.23
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.762cf4d84dd2db77@s5r6.in-berlin.de>
Message-ID: <tkrat.320dceac9e6c952b@s5r6.in-berlin.de>
References: <tkrat.762cf4d84dd2db77@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Oct, Stefan Richter wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following IEEE 1394/ FireWire subsystem updates.

commit 83431cba3d847fc2296d3f38ce7feb623a1cfc45
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Mon Oct 8 17:00:29 2007 -0400

    firewire: fw-cdev: reorder wakeup vs. spinlock
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    
    Prompted by https://bugzilla.redhat.com/show_bug.cgi?id=323411
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 290d9f0..60f1a89 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -143,11 +143,10 @@ static void queue_event(struct client *client, struct event *event,
 	event->v[1].size = size1;
 
 	spin_lock_irqsave(&client->lock, flags);
-
 	list_add_tail(&event->link, &client->event_list);
-	wake_up_interruptible(&client->wait);
-
 	spin_unlock_irqrestore(&client->lock, flags);
+
+	wake_up_interruptible(&client->wait);
 }
 
 static int

commit c1b91ce49158d607666dbef5b8d53cd77d397589
Author: Yann Dirson <ydirson@altern.org>
Date:   Sun Oct 7 02:21:29 2007 +0200

    firewire: in-code doc updates.
    
    Signed-off-by: Yann Dirson <ydirson@altern.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (update)

diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index 45e6f9b..0fc9b00 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -166,7 +166,7 @@ static inline struct fw_node *fw_node(struct list_head *l)
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
  * of the tree, the function checks that the self IDs are valid and
- * internally consistent.  On succcess this funtions returns the
+ * internally consistent.  On succcess this function returns the
  * fw_node corresponding to the local card otherwise NULL.
  */
 static struct fw_node *build_tree(struct fw_card *card,
@@ -215,6 +215,10 @@ static struct fw_node *build_tree(struct fw_card *card,
 		 */
 		for (i = 0, h = &stack; i < child_port_count; i++)
 			h = h->prev;
+		/*
+		 * When the stack is empty, this yields an invalid value,
+		 * but that pointer will never be dereferenced.
+		 */
 		child = fw_node(h);
 
 		node = fw_node_create(q, port_count, card->color);

commit e5f84f82bdc5f8a5ce3d33aa6a2cc727fc08bda6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 7 02:10:11 2007 +0200

    firewire: a header cleanup
    
    fw_node() is not used (and not useful) outside fw-topology.c.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index 39e5cd1..45e6f9b 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -152,6 +152,10 @@ static void update_hop_count(struct fw_node *node)
 	node->max_hops = max(max_child_hops, depths[0] + depths[1] + 2);
 }
 
+static inline struct fw_node *fw_node(struct list_head *l)
+{
+	return list_entry(l, struct fw_node, link);
+}
 
 /**
  * build_tree - Build the tree representation of the topology
diff --git a/drivers/firewire/fw-topology.h b/drivers/firewire/fw-topology.h
index 1b56b4a..cedc1ec 100644
--- a/drivers/firewire/fw-topology.h
+++ b/drivers/firewire/fw-topology.h
@@ -51,12 +51,6 @@ struct fw_node {
 };
 
 static inline struct fw_node *
-fw_node(struct list_head *l)
-{
-	return list_entry(l, struct fw_node, link);
-}
-
-static inline struct fw_node *
 fw_node_get(struct fw_node *node)
 {
 	atomic_inc(&node->ref_count);

commit a64408b96b5f67c2778958a230b5cfa3408a4a81
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Sep 29 10:41:58 2007 +0200

    firewire: adopt read cycle timer ABI from raw1394
    
    This duplicates the read cycle timer feature of raw1394 (added in Linux
    2.6.21) in firewire-core's userspace ABI.  The argument to the ioctl is
    reordered though to ensure 32/64 bit compatibility.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index b960fd9..290d9f0 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -25,11 +25,14 @@
 #include <linux/device.h>
 #include <linux/vmalloc.h>
 #include <linux/poll.h>
+#include <linux/preempt.h>
+#include <linux/time.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/idr.h>
 #include <linux/compat.h>
 #include <linux/firewire-cdev.h>
+#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -811,6 +814,28 @@ static int ioctl_stop_iso(struct client *client, void *buffer)
 	return fw_iso_context_stop(client->iso_context);
 }
 
+static int ioctl_get_cycle_timer(struct client *client, void *buffer)
+{
+	struct fw_cdev_get_cycle_timer *request = buffer;
+	struct fw_card *card = client->device->card;
+	unsigned long long bus_time;
+	struct timeval tv;
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	bus_time = card->driver->get_bus_time(card);
+	do_gettimeofday(&tv);
+
+	local_irq_restore(flags);
+	preempt_enable();
+
+	request->local_time = tv.tv_sec * 1000000ULL + tv.tv_usec;
+	request->cycle_timer = bus_time & 0xffffffff;
+	return 0;
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -824,6 +849,7 @@ static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_queue_iso,
 	ioctl_start_iso,
 	ioctl_stop_iso,
+	ioctl_get_cycle_timer,
 };
 
 static int
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 1a45d6f..0f0e271 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -178,6 +178,7 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
 #define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
 #define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
+#define FW_CDEV_IOC_GET_CYCLE_TIMER	_IOR('#', 0x0c, struct fw_cdev_get_cycle_timer)
 
 /* FW_CDEV_VERSION History
  *
@@ -459,4 +460,18 @@ struct fw_cdev_stop_iso {
 	__u32 handle;
 };
 
+/**
+ * struct fw_cdev_get_cycle_timer - read cycle timer register
+ * @local_time:   system time, in microseconds since the Epoch
+ * @cycle_timer:  isochronous cycle timer, as per OHCI 1.1 clause 5.13
+ *
+ * The %FW_CDEV_IOC_GET_CYCLE_TIMER ioctl reads the isochronous cycle timer
+ * and also the system clock.  This allows to express the receive time of an
+ * isochronous packet as a system time with microsecond accuracy.
+ */
+struct fw_cdev_get_cycle_timer {
+	__u64 local_time;
+	__u32 cycle_timer;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */

commit 02ff8f8ee151e880414b99a11f67cae0cecd4977
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Aug 30 00:11:40 2007 +0200

    firewire: fw-ohci: check for misconfigured bus (phyID == 63)
    
    Check NodeID.nodeNumber as per OHCI 1.1 clause 7.2.3.2.  See also IEEE
    1394a table 5B-1.
    
    Also, demote the "node ID not valid" message from error to notification
    as it is not an error condition.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index ec70c9f..2f307c4 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -917,10 +917,15 @@ static void bus_reset_tasklet(unsigned long data)
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
-		fw_error("node ID not valid, new bus reset in progress\n");
+		fw_notify("node ID not valid, new bus reset in progress\n");
 		return;
 	}
-	ohci->node_id = reg & 0xffff;
+	if ((reg & OHCI1394_NodeID_nodeNumber) == 63) {
+		fw_notify("malconfigured bus\n");
+		return;
+	}
+	ohci->node_id = reg & (OHCI1394_NodeID_busNumber |
+			       OHCI1394_NodeID_nodeNumber);
 
 	/*
 	 * The count in the SelfIDCount register is the number of
diff --git a/drivers/firewire/fw-ohci.h b/drivers/firewire/fw-ohci.h
index fa15706..dec4f04 100644
--- a/drivers/firewire/fw-ohci.h
+++ b/drivers/firewire/fw-ohci.h
@@ -59,6 +59,8 @@
 #define   OHCI1394_LinkControl_cycleSource	(1 << 22)
 #define OHCI1394_NodeID                       0x0E8
 #define   OHCI1394_NodeID_idValid             0x80000000
+#define   OHCI1394_NodeID_nodeNumber          0x0000003f
+#define   OHCI1394_NodeID_busNumber           0x0000ffc0
 #define OHCI1394_PhyControl                   0x0EC
 #define   OHCI1394_PhyControl_Read(addr)	(((addr) << 8) | 0x00008000)
 #define   OHCI1394_PhyControl_ReadDone		0x80000000

commit ab88ca488b8af66c3defa165874e81e695319a19
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Aug 29 19:40:28 2007 +0200

    firewire: fw-ohci: missing dma_unmap_single
    
    at_context_queue_packet() didn't clean up in an early exit path.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index a333748..ec70c9f 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -680,6 +680,9 @@ at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 
 	/* FIXME: Document how the locking works. */
 	if (ohci->generation != packet->generation) {
+		if (packet->payload_length > 0)
+			dma_unmap_single(ohci->card.device, payload_bus,
+					 packet->payload_length, DMA_TO_DEVICE);
 		packet->ack = RCODE_GENERATION;
 		return -1;
 	}

commit e524f616f59722bc7f93eb1fd79d3bbdcdf4f894
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Aug 20 21:58:30 2007 +0200

    firewire: fw-ohci: log posted write errors
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index c16fcb9..a333748 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
@@ -1049,6 +1050,9 @@ static irqreturn_t irq_handler(int irq, void *data)
 		iso_event &= ~(1 << i);
 	}
 
+	if (unlikely(event & OHCI1394_postedWriteErr))
+		fw_error("PCI posted write error\n");
+
 	if (event & OHCI1394_cycle64Seconds) {
 		cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 		if ((cycle_time & 0x80000000) == 0)
@@ -1122,8 +1126,8 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 		  OHCI1394_RQPkt | OHCI1394_RSPkt |
 		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
 		  OHCI1394_isochRx | OHCI1394_isochTx |
-		  OHCI1394_masterIntEnable |
-		  OHCI1394_cycle64Seconds);
+		  OHCI1394_postedWriteErr | OHCI1394_cycle64Seconds |
+		  OHCI1394_masterIntEnable);
 
 	/* Activate link_on bit and contender bit in our self ID packets.*/
 	if (ohci_update_phy_reg(card, 4, 0,

commit a7fb60db711fce56e372f0bb8a733c0ad1743525
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Aug 20 21:41:22 2007 +0200

    firewire: fw-ohci: reorder includes
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 48768b5..c16fcb9 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -18,22 +18,22 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/pci.h>
 #include <linux/spinlock.h>
 
 #include <asm/page.h>
 #include <asm/system.h>
 
-#include "fw-transaction.h"
 #include "fw-ohci.h"
+#include "fw-transaction.h"
 
 #define DESCRIPTOR_OUTPUT_MORE		0
 #define DESCRIPTOR_OUTPUT_LAST		(1 << 12)

commit c26f02340e89c55390c9044ea65d9aef610b38f5
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Aug 20 21:40:30 2007 +0200

    firewire: fw-ohci: fix includes
    
    Add used includes, remove unused includes.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index a7947ba..48768b5 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -24,12 +24,12 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/poll.h>
 #include <linux/dma-mapping.h>
+#include <linux/gfp.h>
 #include <linux/mm.h>
+#include <linux/spinlock.h>
 
-#include <asm/uaccess.h>
-#include <asm/semaphore.h>
+#include <asm/page.h>
 #include <asm/system.h>
 
 #include "fw-transaction.h"

commit ee71c2f9ee85117e41ef87357ed8f75d29369b98
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 25 14:08:19 2007 +0200

    firewire: fw-ohci: enforce read order for selfID generation
    
    It seems unlikely, but access to self_id_cpu[0] could at least in theory
    be deferred until after the loop over self_id_cpu[1..n] or even after
    the subsequent reg_read.  Enforce the desired order by a read barrier.
    
    Also prevent the reg_read from being reordered relative to the for loop.
    This isn't necessary if the loop's conditional printk counts as an
    implicit barrier, but better make it explicit.
    
    (self_id_cpu[] is a coherent DMA buffer.)
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index e14c1ca..a7947ba 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -30,6 +30,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
+#include <asm/system.h>
 
 #include "fw-transaction.h"
 #include "fw-ohci.h"
@@ -926,12 +927,14 @@ static void bus_reset_tasklet(unsigned long data)
 
 	self_id_count = (reg_read(ohci, OHCI1394_SelfIDCount) >> 3) & 0x3ff;
 	generation = (le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
+	rmb();
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
 		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1])
 			fw_error("inconsistent self IDs\n");
 		ohci->self_id_buffer[j] = le32_to_cpu(ohci->self_id_cpu[i]);
 	}
+	rmb();
 
 	/*
 	 * Check the consistency of the self IDs we just read.  The

commit df8ec2490fed5dd23316bbb2c2e90e59e7d37126
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Aug 12 12:51:18 2007 +0200

    firewire: fw-sbp2: use an own workqueue (fix system responsiveness)
    
    Firewire-sbp2 did very uncooperative things in the kernel's shared
    workqueue:  Sleeping until reception of management status from the
    target for up to 2 seconds, and performing SCSI inquiry and all of the
    setup of SCSI command set drivers via scsi_add_device.  If there were
    transient or permanent error conditions, this caused long blockage of
    the kernel's events process, noticeable e.g. by blocked keyboard input.
    
    We now allocate a workqueue process exclusive to fw-sbp2.  As a side
    effect, this also increases parallelism of fw-sbp2's login and reconnect
    work versus fw-core's device discovery and device update work which is
    performed in the shared workqueue.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index f96f192..5596df6 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -39,6 +39,7 @@
 #include <linux/string.h>
 #include <linux/stringify.h>
 #include <linux/timer.h>
+#include <linux/workqueue.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -625,6 +626,8 @@ static void sbp2_release_target(struct kref *kref)
 	scsi_host_put(shost);
 }
 
+static struct workqueue_struct *sbp2_wq;
+
 static void sbp2_reconnect(struct work_struct *work);
 
 static void sbp2_login(struct work_struct *work)
@@ -647,7 +650,8 @@ static void sbp2_login(struct work_struct *work)
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
 		if (lu->retries++ < 5) {
-			schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
+			queue_delayed_work(sbp2_wq, &lu->work,
+					   DIV_ROUND_UP(HZ, 5));
 		} else {
 			fw_error("failed to login to %s LUN %04x\n",
 				 unit->device.bus_id, lu->lun);
@@ -866,7 +870,7 @@ static int sbp2_probe(struct device *dev)
 	 * work.
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		if (schedule_delayed_work(&lu->work, 0))
+		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
 			kref_get(&tgt->kref);
 	return 0;
 
@@ -910,7 +914,7 @@ static void sbp2_reconnect(struct work_struct *work)
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
+		queue_delayed_work(sbp2_wq, &lu->work, DIV_ROUND_UP(HZ, 5));
 		return;
 	}
 
@@ -940,7 +944,7 @@ static void sbp2_update(struct fw_unit *unit)
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
 		lu->retries = 0;
-		if (schedule_delayed_work(&lu->work, 0))
+		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
 			kref_get(&tgt->kref);
 	}
 }
@@ -1335,12 +1339,17 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
+	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
+	if (!sbp2_wq)
+		return -ENOMEM;
+
 	return driver_register(&sbp2_driver.driver);
 }
 
 static void __exit sbp2_cleanup(void)
 {
 	driver_unregister(&sbp2_driver.driver);
+	destroy_workqueue(sbp2_wq);
 }
 
 module_init(sbp2_init);

commit 2df222b8f8fe9e18c9c9fdfd46f60dad55f5ac14
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Aug 13 17:48:25 2007 +0200

    firewire: fw-sbp2: expose module parameter for workarounds
    
    On rare occasions, the ability to set one of the workaround flags at
    runtime may save the day.
    
    People who experience I/O errors with firewire-sbp2 while the old sbp2
    driver worked for them should try workarounds=1 and report to the devel
    mailinglist whether that improves things.  Firewire-sbp2 defaults to the
    SCSI stack's maximum transfer size per command, while sbp2 limits them
    to 128 kBytes.  Flag 1 accomplishes just that.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 1efc67b..f96f192 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -37,6 +37,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/string.h>
+#include <linux/stringify.h>
 #include <linux/timer.h>
 
 #include <scsi/scsi.h>
@@ -60,6 +61,46 @@ module_param_named(exclusive_login, sbp2_param_exclusive_login, bool, 0644);
 MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
 		 "(default = Y, use N for concurrent initiators)");
 
+/*
+ * Flags for firmware oddities
+ *
+ * - 128kB max transfer
+ *   Limit transfer size. Necessary for some old bridges.
+ *
+ * - 36 byte inquiry
+ *   When scsi_mod probes the device, let the inquiry command look like that
+ *   from MS Windows.
+ *
+ * - skip mode page 8
+ *   Suppress sending of mode_sense for mode page 8 if the device pretends to
+ *   support the SCSI Primary Block commands instead of Reduced Block Commands.
+ *
+ * - fix capacity
+ *   Tell sd_mod to correct the last sector number reported by read_capacity.
+ *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
+ *   Don't use this with devices which don't have this bug.
+ *
+ * - override internal blacklist
+ *   Instead of adding to the built-in blacklist, use only the workarounds
+ *   specified in the module load parameter.
+ *   Useful if a blacklist entry interfered with a non-broken device.
+ */
+#define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
+#define SBP2_WORKAROUND_INQUIRY_36	0x2
+#define SBP2_WORKAROUND_MODE_SENSE_8	0x4
+#define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_OVERRIDE	0x100
+
+static int sbp2_param_workarounds;
+module_param_named(workarounds, sbp2_param_workarounds, int, 0644);
+MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
+	", 128kB max transfer = " __stringify(SBP2_WORKAROUND_128K_MAX_TRANS)
+	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
+	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
+	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
+	", or a combination)");
+
 /* I don't know why the SCSI stack doesn't define something like this... */
 typedef void (*scsi_done_fn_t)(struct scsi_cmnd *);
 
@@ -122,13 +163,6 @@ struct sbp2_target {
 #define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
 #define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
 
-/* Flags for detected oddities and brokeness */
-#define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
-#define SBP2_WORKAROUND_INQUIRY_36	0x2
-#define SBP2_WORKAROUND_MODE_SENSE_8	0x4
-#define SBP2_WORKAROUND_FIX_CAPACITY	0x8
-#define SBP2_WORKAROUND_OVERRIDE	0x100
-
 /* Management orb opcodes */
 #define SBP2_LOGIN_REQUEST		0x0
 #define SBP2_QUERY_LOGINS_REQUEST	0x1
@@ -751,8 +785,15 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 				  u32 firmware_revision)
 {
 	int i;
+	unsigned w = sbp2_param_workarounds;
+
+	if (w)
+		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
+			  "if you need the workarounds parameter for %s\n",
+			  tgt->unit->device.bus_id);
 
-	tgt->workarounds = 0;
+	if (w & SBP2_WORKAROUND_OVERRIDE)
+		goto out;
 
 	for (i = 0; i < ARRAY_SIZE(sbp2_workarounds_table); i++) {
 
@@ -764,15 +805,16 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 		    sbp2_workarounds_table[i].model != ~0)
 			continue;
 
-		tgt->workarounds |= sbp2_workarounds_table[i].workarounds;
+		w |= sbp2_workarounds_table[i].workarounds;
 		break;
 	}
-
-	if (tgt->workarounds)
+ out:
+	if (w)
 		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
 			  tgt->unit->device.bus_id,
-			  tgt->workarounds, firmware_revision, model);
+			  w, firmware_revision, model);
+	tgt->workarounds = w;
 }
 
 static struct scsi_host_template scsi_driver_template;

commit 5a3c2be6c9a5641a06c71c906645d676fa4d3fdc
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 25 14:05:28 2007 +0200

    firewire: fw-sbp2: add support for multiple logical units per target
    
    Fixes "New firewire stack only recognizing half of a chain of drives",
    https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242254
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index d13e6a6..894d4a9 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -102,11 +102,6 @@ fw_unit(struct device *dev)
 #define CSR_INSTANCE		0x18
 #define CSR_DIRECTORY_ID	0x20
 
-#define SBP2_COMMAND_SET_SPECIFIER	0x38
-#define SBP2_COMMAND_SET		0x39
-#define SBP2_COMMAND_SET_REVISION	0x3b
-#define SBP2_FIRMWARE_REVISION		0x3c
-
 struct fw_csr_iterator {
 	u32 *p;
 	u32 *end;
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 7ecc154..1efc67b 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -41,7 +41,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
@@ -66,31 +65,49 @@ typedef void (*scsi_done_fn_t)(struct scsi_cmnd *);
 
 static const char sbp2_driver_name[] = "sbp2";
 
-struct sbp2_device {
-	struct kref kref;
-	struct fw_unit *unit;
+/*
+ * We create one struct sbp2_logical_unit per SBP-2 Logical Unit Number Entry
+ * and one struct scsi_device per sbp2_logical_unit.
+ */
+struct sbp2_logical_unit {
+	struct sbp2_target *tgt;
+	struct list_head link;
+	struct scsi_device *sdev;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
-	u64 management_agent_address;
+
 	u64 command_block_agent_address;
-	u32 workarounds;
+	u16 lun;
 	int login_id;
 
 	/*
-	 * We cache these addresses and only update them once we've
-	 * logged in or reconnected to the sbp2 device.  That way, any
-	 * IO to the device will automatically fail and get retried if
-	 * it happens in a window where the device is not ready to
-	 * handle it (e.g. after a bus reset but before we reconnect).
+	 * The generation is updated once we've logged in or reconnected
+	 * to the logical unit.  Thus, I/O to the device will automatically
+	 * fail and get retried if it happens in a window where the device
+	 * is not ready, e.g. after a bus reset but before we reconnect.
 	 */
-	int node_id;
-	int address_high;
 	int generation;
-
 	int retries;
 	struct delayed_work work;
 };
 
+/*
+ * We create one struct sbp2_target per IEEE 1212 Unit Directory
+ * and one struct Scsi_Host per sbp2_target.
+ */
+struct sbp2_target {
+	struct kref kref;
+	struct fw_unit *unit;
+
+	u64 management_agent_address;
+	int directory_id;
+	int node_id;
+	int address_high;
+
+	unsigned workarounds;
+	struct list_head lu_list;
+};
+
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 #define SBP2_MAX_SECTORS		255	/* Max sectors supported */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
@@ -101,10 +118,9 @@ struct sbp2_device {
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
 
 /* Unit directory keys */
-#define SBP2_COMMAND_SET_SPECIFIER	0x38
-#define SBP2_COMMAND_SET		0x39
-#define SBP2_COMMAND_SET_REVISION	0x3b
-#define SBP2_FIRMWARE_REVISION		0x3c
+#define SBP2_CSR_FIRMWARE_REVISION	0x3c
+#define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
+#define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
 
 /* Flags for detected oddities and brokeness */
 #define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
@@ -219,7 +235,7 @@ struct sbp2_command_orb {
 	} request;
 	struct scsi_cmnd *cmd;
 	scsi_done_fn_t done;
-	struct fw_unit *unit;
+	struct sbp2_logical_unit *lu;
 
 	struct sbp2_pointer page_table[SG_ALL] __attribute__((aligned(8)));
 	dma_addr_t page_table_bus;
@@ -295,7 +311,7 @@ sbp2_status_write(struct fw_card *card, struct fw_request *request,
 		  unsigned long long offset,
 		  void *payload, size_t length, void *callback_data)
 {
-	struct sbp2_device *sd = callback_data;
+	struct sbp2_logical_unit *lu = callback_data;
 	struct sbp2_orb *orb;
 	struct sbp2_status status;
 	size_t header_size;
@@ -319,7 +335,7 @@ sbp2_status_write(struct fw_card *card, struct fw_request *request,
 
 	/* Lookup the orb corresponding to this status write. */
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(orb, &sd->orb_list, link) {
+	list_for_each_entry(orb, &lu->orb_list, link) {
 		if (STATUS_GET_ORB_HIGH(status) == 0 &&
 		    STATUS_GET_ORB_LOW(status) == orb->request_bus) {
 			orb->rcode = RCODE_COMPLETE;
@@ -329,7 +345,7 @@ sbp2_status_write(struct fw_card *card, struct fw_request *request,
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&orb->link != &sd->orb_list)
+	if (&orb->link != &lu->orb_list)
 		orb->callback(orb, &status);
 	else
 		fw_error("status write for unknown orb\n");
@@ -371,11 +387,10 @@ complete_transaction(struct fw_card *card, int rcode,
 }
 
 static void
-sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
+sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
 	      int node_id, int generation, u64 offset)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	unsigned long flags;
 
 	orb->pointer.high = 0;
@@ -383,7 +398,7 @@ sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
 	fw_memcpy_to_be32(&orb->pointer, &orb->pointer, sizeof(orb->pointer));
 
 	spin_lock_irqsave(&device->card->lock, flags);
-	list_add_tail(&orb->link, &sd->orb_list);
+	list_add_tail(&orb->link, &lu->orb_list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	/* Take a ref for the orb list and for the transaction callback. */
@@ -396,10 +411,9 @@ sbp2_send_orb(struct sbp2_orb *orb, struct fw_unit *unit,
 			complete_transaction, orb);
 }
 
-static int sbp2_cancel_orbs(struct fw_unit *unit)
+static int sbp2_cancel_orbs(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_orb *orb, *next;
 	struct list_head list;
 	unsigned long flags;
@@ -407,7 +421,7 @@ static int sbp2_cancel_orbs(struct fw_unit *unit)
 
 	INIT_LIST_HEAD(&list);
 	spin_lock_irqsave(&device->card->lock, flags);
-	list_splice_init(&sd->orb_list, &list);
+	list_splice_init(&lu->orb_list, &list);
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	list_for_each_entry_safe(orb, next, &list, link) {
@@ -434,11 +448,11 @@ complete_management_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 }
 
 static int
-sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
-			 int function, int lun, void *response)
+sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
+			 int generation, int function, int lun_or_login_id,
+			 void *response)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_management_orb *orb;
 	int retval = -ENOMEM;
 
@@ -459,12 +473,12 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	orb->request.misc =
 		MANAGEMENT_ORB_NOTIFY |
 		MANAGEMENT_ORB_FUNCTION(function) |
-		MANAGEMENT_ORB_LUN(lun);
+		MANAGEMENT_ORB_LUN(lun_or_login_id);
 	orb->request.length =
 		MANAGEMENT_ORB_RESPONSE_LENGTH(sizeof(orb->response));
 
-	orb->request.status_fifo.high = sd->address_handler.offset >> 32;
-	orb->request.status_fifo.low  = sd->address_handler.offset;
+	orb->request.status_fifo.high = lu->address_handler.offset >> 32;
+	orb->request.status_fifo.low  = lu->address_handler.offset;
 
 	if (function == SBP2_LOGIN_REQUEST) {
 		orb->request.misc |=
@@ -483,14 +497,14 @@ sbp2_send_management_orb(struct fw_unit *unit, int node_id, int generation,
 	if (dma_mapping_error(orb->base.request_bus))
 		goto fail_mapping_request;
 
-	sbp2_send_orb(&orb->base, unit,
-		      node_id, generation, sd->management_agent_address);
+	sbp2_send_orb(&orb->base, lu, node_id, generation,
+		      lu->tgt->management_agent_address);
 
 	wait_for_completion_timeout(&orb->done,
 				    msecs_to_jiffies(SBP2_ORB_TIMEOUT));
 
 	retval = -EIO;
-	if (sbp2_cancel_orbs(unit) == 0) {
+	if (sbp2_cancel_orbs(lu) == 0) {
 		fw_error("orb reply timed out, rcode=0x%02x\n",
 			 orb->base.rcode);
 		goto out;
@@ -535,10 +549,9 @@ complete_agent_reset_write(struct fw_card *card, int rcode,
 	kfree(t);
 }
 
-static int sbp2_agent_reset(struct fw_unit *unit)
+static int sbp2_agent_reset(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct fw_transaction *t;
 	static u32 zero;
 
@@ -547,181 +560,261 @@ static int sbp2_agent_reset(struct fw_unit *unit)
 		return -ENOMEM;
 
 	fw_send_request(device->card, t, TCODE_WRITE_QUADLET_REQUEST,
-			sd->node_id, sd->generation, device->max_speed,
-			sd->command_block_agent_address + SBP2_AGENT_RESET,
+			lu->tgt->node_id, lu->generation, device->max_speed,
+			lu->command_block_agent_address + SBP2_AGENT_RESET,
 			&zero, sizeof(zero), complete_agent_reset_write, t);
 
 	return 0;
 }
 
-static void sbp2_reconnect(struct work_struct *work);
-static struct scsi_host_template scsi_driver_template;
-
-static void release_sbp2_device(struct kref *kref)
+static void sbp2_release_target(struct kref *kref)
 {
-	struct sbp2_device *sd = container_of(kref, struct sbp2_device, kref);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
-
-	scsi_remove_host(host);
-	sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
-				 SBP2_LOGOUT_REQUEST, sd->login_id, NULL);
-	fw_core_remove_address_handler(&sd->address_handler);
-	fw_notify("removed sbp2 unit %s\n", sd->unit->device.bus_id);
-	put_device(&sd->unit->device);
-	scsi_host_put(host);
+	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
+	struct sbp2_logical_unit *lu, *next;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
+		if (lu->sdev)
+			scsi_remove_device(lu->sdev);
+
+		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+		fw_core_remove_address_handler(&lu->address_handler);
+		list_del(&lu->link);
+		kfree(lu);
+	}
+	scsi_remove_host(shost);
+	fw_notify("released %s\n", tgt->unit->device.bus_id);
+
+	put_device(&tgt->unit->device);
+	scsi_host_put(shost);
 }
 
+static void sbp2_reconnect(struct work_struct *work);
+
 static void sbp2_login(struct work_struct *work)
 {
-	struct sbp2_device *sd =
-		container_of(work, struct sbp2_device, work.work);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu =
+		container_of(work, struct sbp2_logical_unit, work.work);
+	struct Scsi_Host *shost =
+		container_of((void *)lu->tgt, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
+	struct scsi_lun eight_bytes_lun;
+	struct fw_unit *unit = lu->tgt->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
-	int generation, node_id, local_node_id, lun, retval;
-
-	/* FIXME: Make this work for multi-lun devices. */
-	lun = 0;
+	int generation, node_id, local_node_id;
 
 	generation    = device->card->generation;
 	node_id       = device->node->node_id;
 	local_node_id = device->card->local_node->node_id;
 
-	if (sbp2_send_management_orb(unit, node_id, generation,
-				     SBP2_LOGIN_REQUEST, lun, &response) < 0) {
-		if (sd->retries++ < 5) {
-			schedule_delayed_work(&sd->work, DIV_ROUND_UP(HZ, 5));
+	if (sbp2_send_management_orb(lu, node_id, generation,
+				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
+		if (lu->retries++ < 5) {
+			schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
 		} else {
-			fw_error("failed to login to %s\n",
-				 unit->device.bus_id);
-			kref_put(&sd->kref, release_sbp2_device);
+			fw_error("failed to login to %s LUN %04x\n",
+				 unit->device.bus_id, lu->lun);
+			kref_put(&lu->tgt->kref, sbp2_release_target);
 		}
 		return;
 	}
 
-	sd->generation   = generation;
-	sd->node_id      = node_id;
-	sd->address_high = local_node_id << 16;
+	lu->generation        = generation;
+	lu->tgt->node_id      = node_id;
+	lu->tgt->address_high = local_node_id << 16;
 
 	/* Get command block agent offset and login id. */
-	sd->command_block_agent_address =
+	lu->command_block_agent_address =
 		((u64) (response.command_block_agent.high & 0xffff) << 32) |
 		response.command_block_agent.low;
-	sd->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
+	lu->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
 
-	fw_notify("logged in to sbp2 unit %s (%d retries)\n",
-		  unit->device.bus_id, sd->retries);
-	fw_notify(" - management_agent_address:    0x%012llx\n",
-		  (unsigned long long) sd->management_agent_address);
-	fw_notify(" - command_block_agent_address: 0x%012llx\n",
-		  (unsigned long long) sd->command_block_agent_address);
-	fw_notify(" - status write address:        0x%012llx\n",
-		  (unsigned long long) sd->address_handler.offset);
+	fw_notify("logged in to %s LUN %04x (%d retries)\n",
+		  unit->device.bus_id, lu->lun, lu->retries);
 
 #if 0
 	/* FIXME: The linux1394 sbp2 does this last step. */
 	sbp2_set_busy_timeout(scsi_id);
 #endif
 
-	PREPARE_DELAYED_WORK(&sd->work, sbp2_reconnect);
-	sbp2_agent_reset(unit);
+	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
+	sbp2_agent_reset(lu);
+
+	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
+	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
+	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
 
-	/* FIXME: Loop over luns here. */
-	lun = 0;
-	retval = scsi_add_device(host, 0, 0, lun);
-	if (retval < 0) {
-		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
-					 SBP2_LOGOUT_REQUEST, sd->login_id,
-					 NULL);
+	sdev = __scsi_add_device(shost, 0, 0,
+				 scsilun_to_int(&eight_bytes_lun), lu);
+	if (IS_ERR(sdev)) {
+		sbp2_send_management_orb(lu, node_id, generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 		/*
 		 * Set this back to sbp2_login so we fall back and
 		 * retry login on bus reset.
 		 */
-		PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+		PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	} else {
+		lu->sdev = sdev;
+		scsi_device_put(sdev);
 	}
-	kref_put(&sd->kref, release_sbp2_device);
+	kref_put(&lu->tgt->kref, sbp2_release_target);
 }
 
-static int sbp2_probe(struct device *dev)
+static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 {
-	struct fw_unit *unit = fw_unit(dev);
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd;
-	struct fw_csr_iterator ci;
-	struct Scsi_Host *host;
-	int i, key, value, err;
-	u32 model, firmware_revision;
+	struct sbp2_logical_unit *lu;
 
-	err = -ENOMEM;
-	host = scsi_host_alloc(&scsi_driver_template, sizeof(*sd));
-	if (host == NULL)
-		goto fail;
+	lu = kmalloc(sizeof(*lu), GFP_KERNEL);
+	if (!lu)
+		return -ENOMEM;
 
-	sd = (struct sbp2_device *) host->hostdata;
-	unit->device.driver_data = sd;
-	sd->unit = unit;
-	INIT_LIST_HEAD(&sd->orb_list);
-	kref_init(&sd->kref);
+	lu->address_handler.length           = 0x100;
+	lu->address_handler.address_callback = sbp2_status_write;
+	lu->address_handler.callback_data    = lu;
 
-	sd->address_handler.length = 0x100;
-	sd->address_handler.address_callback = sbp2_status_write;
-	sd->address_handler.callback_data = sd;
+	if (fw_core_add_address_handler(&lu->address_handler,
+					&fw_high_memory_region) < 0) {
+		kfree(lu);
+		return -ENOMEM;
+	}
 
-	err = fw_core_add_address_handler(&sd->address_handler,
-					  &fw_high_memory_region);
-	if (err < 0)
-		goto fail_host;
+	lu->tgt  = tgt;
+	lu->sdev = NULL;
+	lu->lun  = lun_entry & 0xffff;
+	lu->retries = 0;
+	INIT_LIST_HEAD(&lu->orb_list);
+	INIT_DELAYED_WORK(&lu->work, sbp2_login);
 
-	err = fw_device_enable_phys_dma(device);
-	if (err < 0)
-		goto fail_address_handler;
+	list_add_tail(&lu->link, &tgt->lu_list);
+	return 0;
+}
 
-	err = scsi_add_host(host, &unit->device);
-	if (err < 0)
-		goto fail_address_handler;
+static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt, u32 *directory)
+{
+	struct fw_csr_iterator ci;
+	int key, value;
 
-	/*
-	 * Scan unit directory to get management agent address,
-	 * firmware revison and model.  Initialize firmware_revision
-	 * and model to values that wont match anything in our table.
-	 */
-	firmware_revision = 0xff000000;
-	model = 0xff000000;
-	fw_csr_iterator_init(&ci, unit->directory);
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value))
+		if (key == SBP2_CSR_LOGICAL_UNIT_NUMBER &&
+		    sbp2_add_logical_unit(tgt, value) < 0)
+			return -ENOMEM;
+	return 0;
+}
+
+static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
+			      u32 *model, u32 *firmware_revision)
+{
+	struct fw_csr_iterator ci;
+	int key, value;
+
+	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
 		switch (key) {
+
 		case CSR_DEPENDENT_INFO | CSR_OFFSET:
-			sd->management_agent_address =
-				0xfffff0000000ULL + 4 * value;
+			tgt->management_agent_address =
+					CSR_REGISTER_BASE + 4 * value;
 			break;
-		case SBP2_FIRMWARE_REVISION:
-			firmware_revision = value;
+
+		case CSR_DIRECTORY_ID:
+			tgt->directory_id = value;
 			break;
+
 		case CSR_MODEL:
-			model = value;
+			*model = value;
+			break;
+
+		case SBP2_CSR_FIRMWARE_REVISION:
+			*firmware_revision = value;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
+			if (sbp2_add_logical_unit(tgt, value) < 0)
+				return -ENOMEM;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
+			if (sbp2_scan_logical_unit_dir(tgt, ci.p + value) < 0)
+				return -ENOMEM;
 			break;
 		}
 	}
+	return 0;
+}
+
+static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
+				  u32 firmware_revision)
+{
+	int i;
+
+	tgt->workarounds = 0;
 
 	for (i = 0; i < ARRAY_SIZE(sbp2_workarounds_table); i++) {
+
 		if (sbp2_workarounds_table[i].firmware_revision !=
 		    (firmware_revision & 0xffffff00))
 			continue;
+
 		if (sbp2_workarounds_table[i].model != model &&
 		    sbp2_workarounds_table[i].model != ~0)
 			continue;
-		sd->workarounds |= sbp2_workarounds_table[i].workarounds;
+
+		tgt->workarounds |= sbp2_workarounds_table[i].workarounds;
 		break;
 	}
 
-	if (sd->workarounds)
-		fw_notify("Workarounds for node %s: 0x%x "
+	if (tgt->workarounds)
+		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
-			  unit->device.bus_id,
-			  sd->workarounds, firmware_revision, model);
+			  tgt->unit->device.bus_id,
+			  tgt->workarounds, firmware_revision, model);
+}
+
+static struct scsi_host_template scsi_driver_template;
+
+static int sbp2_probe(struct device *dev)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_target *tgt;
+	struct sbp2_logical_unit *lu;
+	struct Scsi_Host *shost;
+	u32 model, firmware_revision;
+
+	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
+	if (shost == NULL)
+		return -ENOMEM;
+
+	tgt = (struct sbp2_target *)shost->hostdata;
+	unit->device.driver_data = tgt;
+	tgt->unit = unit;
+	kref_init(&tgt->kref);
+	INIT_LIST_HEAD(&tgt->lu_list);
+
+	if (fw_device_enable_phys_dma(device) < 0)
+		goto fail_shost_put;
+
+	if (scsi_add_host(shost, &unit->device) < 0)
+		goto fail_shost_put;
+
+	/* Initialize to values that won't match anything in our table. */
+	firmware_revision = 0xff000000;
+	model = 0xff000000;
+
+	/* implicit directory ID */
+	tgt->directory_id = ((unit->directory - device->config_rom) * 4
+			     + CSR_CONFIG_ROM) & 0xffffff;
+
+	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
+			       &firmware_revision) < 0)
+		goto fail_tgt_put;
+
+	sbp2_init_workarounds(tgt, model, firmware_revision);
 
 	get_device(&unit->device);
 
@@ -730,35 +823,34 @@ static int sbp2_probe(struct device *dev)
 	 * reschedule retries. Always get the ref before scheduling
 	 * work.
 	 */
-	INIT_DELAYED_WORK(&sd->work, sbp2_login);
-	if (schedule_delayed_work(&sd->work, 0))
-		kref_get(&sd->kref);
-
+	list_for_each_entry(lu, &tgt->lu_list, link)
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
 	return 0;
 
- fail_address_handler:
-	fw_core_remove_address_handler(&sd->address_handler);
- fail_host:
-	scsi_host_put(host);
- fail:
-	return err;
+ fail_tgt_put:
+	kref_put(&tgt->kref, sbp2_release_target);
+	return -ENOMEM;
+
+ fail_shost_put:
+	scsi_host_put(shost);
+	return -ENOMEM;
 }
 
 static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
-	struct sbp2_device *sd = unit->device.driver_data;
-
-	kref_put(&sd->kref, release_sbp2_device);
+	struct sbp2_target *tgt = unit->device.driver_data;
 
+	kref_put(&tgt->kref, sbp2_release_target);
 	return 0;
 }
 
 static void sbp2_reconnect(struct work_struct *work)
 {
-	struct sbp2_device *sd =
-		container_of(work, struct sbp2_device, work.work);
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu =
+		container_of(work, struct sbp2_logical_unit, work.work);
+	struct fw_unit *unit = lu->tgt->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
@@ -766,40 +858,49 @@ static void sbp2_reconnect(struct work_struct *work)
 	node_id       = device->node->node_id;
 	local_node_id = device->card->local_node->node_id;
 
-	if (sbp2_send_management_orb(unit, node_id, generation,
+	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,
-				     sd->login_id, NULL) < 0) {
-		if (sd->retries++ >= 5) {
+				     lu->login_id, NULL) < 0) {
+		if (lu->retries++ >= 5) {
 			fw_error("failed to reconnect to %s\n",
 				 unit->device.bus_id);
 			/* Fall back and try to log in again. */
-			sd->retries = 0;
-			PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+			lu->retries = 0;
+			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		schedule_delayed_work(&sd->work, DIV_ROUND_UP(HZ, 5));
+		schedule_delayed_work(&lu->work, DIV_ROUND_UP(HZ, 5));
 		return;
 	}
 
-	sd->generation   = generation;
-	sd->node_id      = node_id;
-	sd->address_high = local_node_id << 16;
+	lu->generation        = generation;
+	lu->tgt->node_id      = node_id;
+	lu->tgt->address_high = local_node_id << 16;
 
-	fw_notify("reconnected to unit %s (%d retries)\n",
-		  unit->device.bus_id, sd->retries);
-	sbp2_agent_reset(unit);
-	sbp2_cancel_orbs(unit);
-	kref_put(&sd->kref, release_sbp2_device);
+	fw_notify("reconnected to %s LUN %04x (%d retries)\n",
+		  unit->device.bus_id, lu->lun, lu->retries);
+
+	sbp2_agent_reset(lu);
+	sbp2_cancel_orbs(lu);
+
+	kref_put(&lu->tgt->kref, sbp2_release_target);
 }
 
 static void sbp2_update(struct fw_unit *unit)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_device *sd = unit->device.driver_data;
+	struct sbp2_target *tgt = unit->device.driver_data;
+	struct sbp2_logical_unit *lu;
 
-	sd->retries = 0;
-	fw_device_enable_phys_dma(device);
-	if (schedule_delayed_work(&sd->work, 0))
-		kref_get(&sd->kref);
+	fw_device_enable_phys_dma(fw_device(unit->device.parent));
+
+	/*
+	 * Fw-core serializes sbp2_update() against sbp2_remove().
+	 * Iteration over tgt->lu_list is therefore safe here.
+	 */
+	list_for_each_entry(lu, &tgt->lu_list, link) {
+		lu->retries = 0;
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
+	}
 }
 
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e
@@ -869,13 +970,12 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 {
 	struct sbp2_command_orb *orb =
 		container_of(base_orb, struct sbp2_command_orb, base);
-	struct fw_unit *unit = orb->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct fw_device *device = fw_device(orb->lu->tgt->unit->device.parent);
 	int result;
 
 	if (status != NULL) {
 		if (STATUS_GET_DEAD(*status))
-			sbp2_agent_reset(unit);
+			sbp2_agent_reset(orb->lu);
 
 		switch (STATUS_GET_RESPONSE(*status)) {
 		case SBP2_STATUS_REQUEST_COMPLETE:
@@ -919,12 +1019,10 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 	orb->done(orb->cmd);
 }
 
-static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
+static int
+sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
+		     struct sbp2_logical_unit *lu)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)orb->cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
 	int sg_len, l, i, j, count;
 	dma_addr_t sg_addr;
@@ -943,10 +1041,9 @@ static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 	 * tables.
 	 */
 	if (count == 1 && sg_dma_len(sg) < SBP2_MAX_SG_ELEMENT_LENGTH) {
-		orb->request.data_descriptor.high = sd->address_high;
+		orb->request.data_descriptor.high = lu->tgt->address_high;
 		orb->request.data_descriptor.low  = sg_dma_address(sg);
-		orb->request.misc |=
-			COMMAND_ORB_DATA_SIZE(sg_dma_len(sg));
+		orb->request.misc |= COMMAND_ORB_DATA_SIZE(sg_dma_len(sg));
 		return 0;
 	}
 
@@ -990,7 +1087,7 @@ static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 	 * initiator (i.e. us), but data_descriptor can refer to data
 	 * on other nodes so we need to put our ID in descriptor.high.
 	 */
-	orb->request.data_descriptor.high = sd->address_high;
+	orb->request.data_descriptor.high = lu->tgt->address_high;
 	orb->request.data_descriptor.low  = orb->page_table_bus;
 	orb->request.misc |=
 		COMMAND_ORB_PAGE_TABLE_PRESENT |
@@ -1009,12 +1106,11 @@ static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_logical_unit *lu = cmd->device->hostdata;
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
 	unsigned max_payload;
+	int retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
@@ -1030,14 +1126,14 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL) {
 		fw_notify("failed to alloc orb\n");
-		goto fail_alloc;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Initialize rcode to something not RCODE_COMPLETE. */
 	orb->base.rcode = -1;
 	kref_init(&orb->base.kref);
 
-	orb->unit = unit;
+	orb->lu   = lu;
 	orb->done = done;
 	orb->cmd  = cmd;
 
@@ -1063,8 +1159,8 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 		orb->request.misc |=
 			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA);
 
-	if (scsi_sg_count(cmd) && sbp2_command_orb_map_scatterlist(orb) < 0)
-		goto fail_mapping;
+	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
+		goto out;
 
 	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));
 
@@ -1077,49 +1173,47 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
 	if (dma_mapping_error(orb->base.request_bus))
-		goto fail_mapping;
-
-	sbp2_send_orb(&orb->base, unit, sd->node_id, sd->generation,
-		      sd->command_block_agent_address + SBP2_ORB_POINTER);
-
-	kref_put(&orb->base.kref, free_orb);
-	return 0;
+		goto out;
 
- fail_mapping:
+	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, lu->generation,
+		      lu->command_block_agent_address + SBP2_ORB_POINTER);
+	retval = 0;
+ out:
 	kref_put(&orb->base.kref, free_orb);
- fail_alloc:
-	return SCSI_MLQUEUE_HOST_BUSY;
+	return retval;
 }
 
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->allow_restart = 1;
 
-	if (sd->workarounds & SBP2_WORKAROUND_INQUIRY_36)
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
+
 	return 0;
 }
 
 static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->use_10_for_rw = 1;
 
 	if (sdev->type == TYPE_ROM)
 		sdev->use_10_for_ms = 1;
+
 	if (sdev->type == TYPE_DISK &&
-	    sd->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
+	    lu->tgt->workarounds & SBP2_WORKAROUND_MODE_SENSE_8)
 		sdev->skip_ms_page_8 = 1;
-	if (sd->workarounds & SBP2_WORKAROUND_FIX_CAPACITY) {
-		fw_notify("setting fix_capacity for %s\n", unit->device.bus_id);
+
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
-	}
-	if (sd->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
+
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
 		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+
 	return 0;
 }
 
@@ -1129,13 +1223,11 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
  */
 static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
-	struct fw_unit *unit = sd->unit;
+	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 
 	fw_notify("sbp2_scsi_abort\n");
-	sbp2_agent_reset(unit);
-	sbp2_cancel_orbs(unit);
+	sbp2_agent_reset(lu);
+	sbp2_cancel_orbs(lu);
 
 	return SUCCESS;
 }
@@ -1152,37 +1244,18 @@ sbp2_sysfs_ieee1394_id_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct sbp2_device *sd;
-	struct fw_unit *unit;
+	struct sbp2_logical_unit *lu;
 	struct fw_device *device;
-	u32 directory_id;
-	struct fw_csr_iterator ci;
-	int key, value, lun;
 
 	if (!sdev)
 		return 0;
-	sd = (struct sbp2_device *)sdev->host->hostdata;
-	unit = sd->unit;
-	device = fw_device(unit->device.parent);
-
-	/* implicit directory ID */
-	directory_id = ((unit->directory - device->config_rom) * 4
-			+ CSR_CONFIG_ROM) & 0xffffff;
-
-	/* explicit directory ID, overrides implicit ID if present */
-	fw_csr_iterator_init(&ci, unit->directory);
-	while (fw_csr_iterator_next(&ci, &key, &value))
-		if (key == CSR_DIRECTORY_ID) {
-			directory_id = value;
-			break;
-		}
 
-	/* FIXME: Make this work for multi-lun devices. */
-	lun = 0;
+	lu = sdev->hostdata;
+	device = fw_device(lu->tgt->unit->device.parent);
 
 	return sprintf(buf, "%08x%08x:%06x:%04x\n",
 			device->config_rom[3], device->config_rom[4],
-			directory_id, lun);
+			lu->tgt->directory_id, lu->lun);
 }
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);

commit 1b34e97441384d527c438a6ee597bfc800373bce
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 25 10:40:42 2007 +0200

    firewire: fw-sbp2: always enable IRQs before calling command ORB callback
    
    On IOMMU-less noncoherent architectures, orb->callback will memcpy the
    whole SCSI command buffer for READ-like SCSI commands.  It is therefore
    friendlier to enable IRQs before the call, like before patch "Add
    ref-counting for sbp2 orbs".
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Acked-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 238730f..7ecc154 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -361,11 +361,12 @@ complete_transaction(struct fw_card *card, int rcode,
 		orb->rcode = rcode;
 	if (orb->rcode != RCODE_COMPLETE) {
 		list_del(&orb->link);
+		spin_unlock_irqrestore(&card->lock, flags);
 		orb->callback(orb, NULL);
+	} else {
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 
-	spin_unlock_irqrestore(&card->lock, flags);
-
 	kref_put(&orb->kref, free_orb);
 }
 

commit 930e4b7fe3b4e1c4e14b9c22e4c9c74dc8db75f3
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Aug 3 20:56:31 2007 +0200

    firewire: fw-core: local variable shadows a global one
    
    Sparse warned about it although it was apparently harmless:
    
    drivers/firewire/fw-cdev.c:624:23: warning: symbol 'interrupt' shadows an earlier one
    include/asm/hw_irq.h:29:13: originally declared here
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 0647130..b960fd9 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -621,20 +621,19 @@ iso_callback(struct fw_iso_context *context, u32 cycle,
 	     size_t header_length, void *header, void *data)
 {
 	struct client *client = data;
-	struct iso_interrupt *interrupt;
+	struct iso_interrupt *irq;
 
-	interrupt = kzalloc(sizeof(*interrupt) + header_length, GFP_ATOMIC);
-	if (interrupt == NULL)
+	irq = kzalloc(sizeof(*irq) + header_length, GFP_ATOMIC);
+	if (irq == NULL)
 		return;
 
-	interrupt->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
-	interrupt->interrupt.closure   = client->iso_closure;
-	interrupt->interrupt.cycle     = cycle;
-	interrupt->interrupt.header_length = header_length;
-	memcpy(interrupt->interrupt.header, header, header_length);
-	queue_event(client, &interrupt->event,
-		    &interrupt->interrupt,
-		    sizeof(interrupt->interrupt) + header_length, NULL, 0);
+	irq->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
+	irq->interrupt.closure   = client->iso_closure;
+	irq->interrupt.cycle     = cycle;
+	irq->interrupt.header_length = header_length;
+	memcpy(irq->interrupt.header, header, header_length);
+	queue_event(client, &irq->event, &irq->interrupt,
+		    sizeof(irq->interrupt) + header_length, NULL, 0);
 }
 
 static int ioctl_create_iso_context(struct client *client, void *buffer)

commit 1415d9189e8c59aa9c77a3bba419dcea062c145f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Jul 17 02:10:16 2007 +0200

    firewire: optimize fw_core_add_address_handler
    
    Potentially avoids unnecessary loop runs.
    Guarantee quadlet-aligned starts of address regions.
    Document the return values.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 3e1cb12..9959b79 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -410,7 +410,12 @@ EXPORT_SYMBOL(fw_unit_space_region);
  * controller.  When a request is received that falls within the
  * specified address range, the specified callback is invoked.  The
  * parameters passed to the callback give the details of the
- * particular request
+ * particular request.
+ *
+ * Return value:  0 on success, non-zero otherwise.
+ * The start offset of the handler's address region is determined by
+ * fw_core_add_address_handler() and is returned in handler->offset.
+ * The offset is quadlet-aligned.
  */
 int
 fw_core_add_address_handler(struct fw_address_handler *handler,
@@ -422,14 +427,15 @@ fw_core_add_address_handler(struct fw_address_handler *handler,
 
 	spin_lock_irqsave(&address_handler_lock, flags);
 
-	handler->offset = region->start;
+	handler->offset = roundup(region->start, 4);
 	while (handler->offset + handler->length <= region->end) {
 		other =
 		    lookup_overlapping_address_handler(&address_handler_list,
 						       handler->offset,
 						       handler->length);
 		if (other != NULL) {
-			handler->offset += other->length;
+			handler->offset =
+			    roundup(other->offset + other->length, 4);
 		} else {
 			list_add_tail(&handler->link, &address_handler_list);
 			ret = 0;

commit 002a98f14720f90b107e8c44b7733f9bd5dff728
Author: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Date:   Fri Oct 12 19:57:23 2007 +0200

    ieee1394: ieee1394_core.c: use DEFINE_SPINLOCK for spinlock definition
    
    drivers/ieee1394/ieee1394_core.c: Define spinlock using
    DEFINE_SPINLOCK instead of assignment to SPIN_LOCK_UNLOCKED
    
    Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 98fd985..36c747b 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -488,7 +488,7 @@ void hpsb_selfid_complete(struct hpsb_host *host, int phyid, int isroot)
 	highlevel_host_reset(host);
 }
 
-static spinlock_t pending_packets_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(pending_packets_lock);
 
 /**
  * hpsb_packet_sent - notify core of sending a packet

commit 17a19b795e9187d65b6e45cb22797725d50f7edb
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Sep 15 14:50:25 2007 +0200

    ieee1394: csr1212: proper refcounting
    
    At least since nodemgr got rid of coarse global locking, accesses to
    struct csr1212_keyval's reference counter should be atomic and coupled
    with proper barriers.  Also, calls to csr1212_keep_keyval(kv) should
    occur before kv is being used.
    
    (We probably should convert refcnt to struct kref, but how to keep
    csr1212_destroy_keyval's implementation non-recursively then?)
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/csr1212.c b/drivers/ieee1394/csr1212.c
index d08166b..e8122de 100644
--- a/drivers/ieee1394/csr1212.c
+++ b/drivers/ieee1394/csr1212.c
@@ -218,12 +218,10 @@ static struct csr1212_keyval *csr1212_new_keyval(u8 type, u8 key)
 	if (!kv)
 		return NULL;
 
+	atomic_set(&kv->refcnt, 1);
 	kv->key.type = type;
 	kv->key.id = key;
-
 	kv->associate = NULL;
-	kv->refcnt = 1;
-
 	kv->next = NULL;
 	kv->prev = NULL;
 	kv->offset = 0;
@@ -326,12 +324,13 @@ void csr1212_associate_keyval(struct csr1212_keyval *kv,
 	if (kv->associate)
 		csr1212_release_keyval(kv->associate);
 
-	associate->refcnt++;
+	csr1212_keep_keyval(associate);
 	kv->associate = associate;
 }
 
-int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
-				       struct csr1212_keyval *kv)
+static int __csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
+						struct csr1212_keyval *kv,
+						bool keep_keyval)
 {
 	struct csr1212_dentry *dentry;
 
@@ -341,10 +340,10 @@ int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
 	if (!dentry)
 		return -ENOMEM;
 
+	if (keep_keyval)
+		csr1212_keep_keyval(kv);
 	dentry->kv = kv;
 
-	kv->refcnt++;
-
 	dentry->next = NULL;
 	dentry->prev = dir->value.directory.dentries_tail;
 
@@ -358,6 +357,12 @@ int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
 	return CSR1212_SUCCESS;
 }
 
+int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
+				       struct csr1212_keyval *kv)
+{
+	return __csr1212_attach_keyval_to_directory(dir, kv, true);
+}
+
 #define CSR1212_DESCRIPTOR_LEAF_DATA(kv) \
 	(&((kv)->value.leaf.data[1]))
 
@@ -483,15 +488,18 @@ void csr1212_detach_keyval_from_directory(struct csr1212_keyval *dir,
 
 /* This function is used to free the memory taken by a keyval.  If the given
  * keyval is a directory type, then any keyvals contained in that directory
- * will be destroyed as well if their respective refcnts are 0.  By means of
+ * will be destroyed as well if noone holds a reference on them.  By means of
  * list manipulation, this routine will descend a directory structure in a
  * non-recursive manner. */
-static void csr1212_destroy_keyval(struct csr1212_keyval *kv)
+void csr1212_release_keyval(struct csr1212_keyval *kv)
 {
 	struct csr1212_keyval *k, *a;
 	struct csr1212_dentry dentry;
 	struct csr1212_dentry *head, *tail;
 
+	if (!atomic_dec_and_test(&kv->refcnt))
+		return;
+
 	dentry.kv = kv;
 	dentry.next = NULL;
 	dentry.prev = NULL;
@@ -503,9 +511,8 @@ static void csr1212_destroy_keyval(struct csr1212_keyval *kv)
 		k = head->kv;
 
 		while (k) {
-			k->refcnt--;
-
-			if (k->refcnt > 0)
+			/* must not dec_and_test kv->refcnt again */
+			if (k != kv && !atomic_dec_and_test(&k->refcnt))
 				break;
 
 			a = k->associate;
@@ -536,14 +543,6 @@ static void csr1212_destroy_keyval(struct csr1212_keyval *kv)
 	}
 }
 
-void csr1212_release_keyval(struct csr1212_keyval *kv)
-{
-	if (kv->refcnt > 1)
-		kv->refcnt--;
-	else
-		csr1212_destroy_keyval(kv);
-}
-
 void csr1212_destroy_csr(struct csr1212_csr *csr)
 {
 	struct csr1212_csr_rom_cache *c, *oc;
@@ -1126,6 +1125,7 @@ csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
 	int ret = CSR1212_SUCCESS;
 	struct csr1212_keyval *k = NULL;
 	u32 offset;
+	bool keep_keyval = true;
 
 	switch (CSR1212_KV_KEY_TYPE(ki)) {
 	case CSR1212_KV_TYPE_IMMEDIATE:
@@ -1135,8 +1135,8 @@ csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
 			ret = -ENOMEM;
 			goto out;
 		}
-
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
 		break;
 
 	case CSR1212_KV_TYPE_CSR_OFFSET:
@@ -1146,7 +1146,8 @@ csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
 			ret = -ENOMEM;
 			goto out;
 		}
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
 		break;
 
 	default:
@@ -1174,8 +1175,10 @@ csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
 			ret = -ENOMEM;
 			goto out;
 		}
-		k->refcnt = 0;	/* Don't keep local reference when parsing. */
-		k->valid = 0;	/* Contents not read yet so it's not valid. */
+		/* Don't keep local reference when parsing. */
+		keep_keyval = false;
+		/* Contents not read yet so it's not valid. */
+		k->valid = 0;
 		k->offset = offset;
 
 		k->prev = dir;
@@ -1183,7 +1186,7 @@ csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
 		dir->next->prev = k;
 		dir->next = k;
 	}
-	ret = csr1212_attach_keyval_to_directory(dir, k);
+	ret = __csr1212_attach_keyval_to_directory(dir, k, keep_keyval);
 out:
 	if (ret != CSR1212_SUCCESS && k != NULL)
 		free_keyval(k);
diff --git a/drivers/ieee1394/csr1212.h b/drivers/ieee1394/csr1212.h
index df909ce..043039f 100644
--- a/drivers/ieee1394/csr1212.h
+++ b/drivers/ieee1394/csr1212.h
@@ -32,6 +32,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <asm/atomic.h>
 
 #define CSR1212_MALLOC(size)	kmalloc((size), GFP_KERNEL)
 #define CSR1212_FREE(ptr)	kfree(ptr)
@@ -149,7 +150,7 @@ struct csr1212_keyval {
 		struct csr1212_directory directory;
 	} value;
 	struct csr1212_keyval *associate;
-	int refcnt;
+	atomic_t refcnt;
 
 	/* used in generating and/or parsing CSR image */
 	struct csr1212_keyval *next, *prev;	/* flat list of CSR elements */
@@ -350,7 +351,8 @@ csr1212_get_keyval(struct csr1212_csr *csr, struct csr1212_keyval *kv);
  * need for code to retain a keyval that has been parsed. */
 static inline void csr1212_keep_keyval(struct csr1212_keyval *kv)
 {
-	kv->refcnt++;
+	atomic_inc(&kv->refcnt);
+	smp_mb__after_atomic_inc();
 }
 
 
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index ec8edd2..90dc75b 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1014,13 +1014,13 @@ static struct unit_directory *nodemgr_process_unit_directory
 			    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_LANGUAGE(kv) == 0) {
 				switch (last_key_id) {
 				case CSR1212_KV_ID_VENDOR:
-					ud->vendor_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					ud->vendor_name_kv = kv;
 					break;
 
 				case CSR1212_KV_ID_MODEL:
-					ud->model_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					ud->model_name_kv = kv;
 					break;
 
 				}

commit 638d5bb8167c2c88552257d5af23f7f65ab4defd
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Sep 15 14:45:53 2007 +0200

    ieee1394: nodemgr: fix leak of struct csr1212_keyval
    
    csr1212_keep_keyval(kv) in nodemgr_process_root_directory was
    unbalanced if ne->vendor_name_kv already exists.  This happens for
    example if eth1394 or raw1394 modify the local config ROM and it is
    parsed again.
    
    As a bonus, the attempt to add the vendor_name_kv sysfs attribute
    when it already exists is now fixed for good.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 11712a3..ec8edd2 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1112,7 +1112,7 @@ static void nodemgr_process_root_directory(struct host_info *hi, struct node_ent
 {
 	unsigned int ud_id = 0;
 	struct csr1212_dentry *dentry;
-	struct csr1212_keyval *kv;
+	struct csr1212_keyval *kv, *vendor_name_kv = NULL;
 	u8 last_key_id = 0;
 
 	ne->needs_probe = 0;
@@ -1139,8 +1139,8 @@ static void nodemgr_process_root_directory(struct host_info *hi, struct node_ent
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_WIDTH(kv) == 0 &&
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_CHAR_SET(kv) == 0 &&
 				    CSR1212_TEXTUAL_DESCRIPTOR_LEAF_LANGUAGE(kv) == 0) {
-					ne->vendor_name_kv = kv;
 					csr1212_keep_keyval(kv);
+					vendor_name_kv = kv;
 				}
 			}
 			break;
@@ -1149,10 +1149,13 @@ static void nodemgr_process_root_directory(struct host_info *hi, struct node_ent
 	}
 
 	if (ne->vendor_name_kv) {
-		int error = device_create_file(&ne->device,
-					       &dev_attr_ne_vendor_name_kv);
-
-		if (error && error != -EEXIST)
+		kv = ne->vendor_name_kv;
+		ne->vendor_name_kv = vendor_name_kv;
+		csr1212_release_keyval(kv);
+	} else if (vendor_name_kv) {
+		ne->vendor_name_kv = vendor_name_kv;
+		if (device_create_file(&ne->device,
+				       &dev_attr_ne_vendor_name_kv) != 0)
 			HPSB_ERR("Failed to add sysfs attribute");
 	}
 }

commit 745647e7a2ae399f7f70aca47827e62c99c893b5
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sat Sep 8 14:09:19 2007 +0200

    ieee1394: pcilynx: I2C cleanups
    
    * Delete optional and empty i2c client_register and client_unregister
      callbacks.
    * Use the proper i2c adapter ID.
    * Don't use a template to initialize the i2c_adapter structure, it's
      inefficient.
    * Update a misleading comment on why we use i2c_transfer rather than
      higher level i2c functions.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
index 7762e43..8af01ab 100644
--- a/drivers/ieee1394/pcilynx.c
+++ b/drivers/ieee1394/pcilynx.c
@@ -121,16 +121,6 @@ static int bit_getsda(void *data)
 	return reg_read((struct ti_lynx *) data, SERIAL_EEPROM_CONTROL) & 0x00000010;
 }
 
-static int bit_reg(struct i2c_client *client)
-{
-	return 0;
-}
-
-static int bit_unreg(struct i2c_client *client)
-{
-	return 0;
-}
-
 static struct i2c_algo_bit_data bit_data = {
 	.setsda			= bit_setsda,
 	.setscl			= bit_setscl,
@@ -140,14 +130,6 @@ static struct i2c_algo_bit_data bit_data = {
 	.timeout		= 100,
 };
 
-static struct i2c_adapter bit_ops = {
-	.id 			= 0xAA, //FIXME: probably we should get an id in i2c-id.h
-	.client_register	= bit_reg,
-	.client_unregister	= bit_unreg,
-	.name			= "PCILynx I2C",
-};
-
-
 
 /*
  * PCL handling functions.
@@ -1435,9 +1417,11 @@ static int __devinit add_card(struct pci_dev *dev,
         	struct i2c_algo_bit_data i2c_adapter_data;
 
         	error = -ENOMEM;
-		i2c_ad = kmemdup(&bit_ops, sizeof(*i2c_ad), GFP_KERNEL);
+		i2c_ad = kzalloc(sizeof(*i2c_ad), GFP_KERNEL);
         	if (!i2c_ad) FAIL("failed to allocate I2C adapter memory");
 
+		i2c_ad->id = I2C_HW_B_PCILYNX;
+		strlcpy(i2c_ad->name, "PCILynx I2C", sizeof(i2c_ad->name));
                 i2c_adapter_data = bit_data;
                 i2c_ad->algo_data = &i2c_adapter_data;
                 i2c_adapter_data.data = lynx;
@@ -1464,8 +1448,8 @@ static int __devinit add_card(struct pci_dev *dev,
                                                   { 0x50, I2C_M_RD, 20, (unsigned char*) lynx->bus_info_block }
                                                 };
 
-                        /* we use i2c_transfer, because i2c_smbus_read_block_data does not work properly and we
-                           do it more efficiently in one transaction rather then using several reads */
+			/* we use i2c_transfer because we have no i2c_client
+			   at hand */
                         if (i2c_transfer(i2c_ad, msg, 2) < 0) {
                                 PRINT(KERN_ERR, lynx->id, "unable to read bus info block from i2c");
                         } else {

commit 69e2b602966533256edce1ed1b24fec23fe05962
Author: Satyam Sharma <satyam@infradead.org>
Date:   Wed Aug 15 20:05:38 2007 +0530

    ieee1394: Fix kthread stopping in nodemgr_host_thread
    
    The nodemgr host thread can exit on its own even when kthread_should_stop
    is not true, on receiving a signal (might never happen in practice, as
    it ignores signals). But considering kthread_stop() must not be mixed with
    kthreads that can exit on their own, I think changing the code like this
    is clearer. This change means the thread can cut its sleep short when
    receive a signal but looking at the code around, that sounds okay (and
    again, it might never actually recieve a signal in practice).
    
    Signed-off-by: Satyam Sharma <satyam@infradead.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 1939fee..11712a3 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1712,7 +1712,8 @@ static int nodemgr_host_thread(void *__hi)
 		 * to make sure things settle down. */
 		g = get_hpsb_generation(host);
 		for (i = 0; i < 4 ; i++) {
-			if (msleep_interruptible(63) || kthread_should_stop())
+			msleep_interruptible(63);
+			if (kthread_should_stop())
 				goto exit;
 
 			/* Now get the generation in which the node ID's we collect

commit 261b5f664c6c68c5209656a71c41823eda0d938b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 11 11:52:08 2007 +0200

    ieee1394: sbp2: fix unsafe iteration over list of devices
    
    sbp2_host_reset and sbp2_handle_status_write are not serialized against
    sbp2_alloc_device and sbp2_remove_device.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index a81ba8f..1b353b9 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -242,6 +242,8 @@ static int sbp2_max_speed_and_size(struct sbp2_lu *);
 
 static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xA, 0xB, 0xC };
 
+static DEFINE_RWLOCK(sbp2_hi_logical_units_lock);
+
 static struct hpsb_highlevel sbp2_highlevel = {
 	.name		= SBP2_DEVICE_NAME,
 	.host_reset	= sbp2_host_reset,
@@ -732,6 +734,7 @@ static struct sbp2_lu *sbp2_alloc_device(struct unit_directory *ud)
 	struct sbp2_fwhost_info *hi;
 	struct Scsi_Host *shost = NULL;
 	struct sbp2_lu *lu = NULL;
+	unsigned long flags;
 
 	lu = kzalloc(sizeof(*lu), GFP_KERNEL);
 	if (!lu) {
@@ -784,7 +787,9 @@ static struct sbp2_lu *sbp2_alloc_device(struct unit_directory *ud)
 
 	lu->hi = hi;
 
+	write_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_add_tail(&lu->lu_list, &hi->logical_units);
+	write_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 
 	/* Register the status FIFO address range. We could use the same FIFO
 	 * for targets at different nodes. However we need different FIFOs per
@@ -828,16 +833,20 @@ static void sbp2_host_reset(struct hpsb_host *host)
 {
 	struct sbp2_fwhost_info *hi;
 	struct sbp2_lu *lu;
+	unsigned long flags;
 
 	hi = hpsb_get_hostinfo(&sbp2_highlevel, host);
 	if (!hi)
 		return;
+
+	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_for_each_entry(lu, &hi->logical_units, lu_list)
 		if (likely(atomic_read(&lu->state) !=
 			   SBP2LU_STATE_IN_SHUTDOWN)) {
 			atomic_set(&lu->state, SBP2LU_STATE_IN_RESET);
 			scsi_block_requests(lu->shost);
 		}
+	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 }
 
 static int sbp2_start_device(struct sbp2_lu *lu)
@@ -919,6 +928,7 @@ alloc_fail:
 static void sbp2_remove_device(struct sbp2_lu *lu)
 {
 	struct sbp2_fwhost_info *hi;
+	unsigned long flags;
 
 	if (!lu)
 		return;
@@ -933,7 +943,9 @@ static void sbp2_remove_device(struct sbp2_lu *lu)
 	flush_scheduled_work();
 	sbp2util_remove_command_orb_pool(lu, hi->host);
 
+	write_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_del(&lu->lu_list);
+	write_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 
 	if (lu->login_response)
 		dma_free_coherent(hi->host->device.parent,
@@ -1707,6 +1719,7 @@ static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid,
 	}
 
 	/* Find the unit which wrote the status. */
+	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_for_each_entry(lu_tmp, &hi->logical_units, lu_list) {
 		if (lu_tmp->ne->nodeid == nodeid &&
 		    lu_tmp->status_fifo_addr == addr) {
@@ -1714,6 +1727,8 @@ static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid,
 			break;
 		}
 	}
+	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
+
 	if (unlikely(!lu)) {
 		SBP2_ERR("lu is NULL - device is gone?");
 		return RCODE_ADDRESS_ERROR;

commit c4f3d41fed11c9050aa93bbaeed9f7f06bcc93ba
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jul 29 00:01:35 2007 +0200

    ieee1394: pcilynx: superfluous local variables
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
index d1a5bcd..7762e43 100644
--- a/drivers/ieee1394/pcilynx.c
+++ b/drivers/ieee1394/pcilynx.c
@@ -765,7 +765,6 @@ static int lynx_devctl(struct hpsb_host *host, enum devctl_cmd cmd, int arg)
                 } else {
                         struct ti_pcl pcl;
                         u32 ack;
-                        struct hpsb_packet *packet;
 
                         PRINT(KERN_INFO, lynx->id, "cancelling async packet, that was already in PCL");
 
@@ -1470,8 +1469,6 @@ static int __devinit add_card(struct pci_dev *dev,
                         if (i2c_transfer(i2c_ad, msg, 2) < 0) {
                                 PRINT(KERN_ERR, lynx->id, "unable to read bus info block from i2c");
                         } else {
-                                int i;
-
                                 PRINT(KERN_INFO, lynx->id, "got bus info block from serial eeprom");
 				/* FIXME: probably we shoud rewrite the max_rec, max_ROM(1394a),
 				 * generation(1394a) and link_spd(1394a) field and recalculate

commit 661afcae1b6b6493e4ea69f81bae78397c066f25
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jul 28 23:45:03 2007 +0200

    ieee1394: eth1394: fix lock imbalance
    
    bad_proto can be reached from points which did not take priv->lock.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 7aa0bf3..b166b35 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -1220,23 +1220,19 @@ static int ether1394_data_handler(struct net_device *dev, int srcid, int destid,
 		priv->stats.rx_errors++;
 		priv->stats.rx_dropped++;
 		dev_kfree_skb_any(skb);
-		goto bad_proto;
-	}
-
-	if (netif_rx(skb) == NET_RX_DROP) {
+	} else if (netif_rx(skb) == NET_RX_DROP) {
 		priv->stats.rx_errors++;
 		priv->stats.rx_dropped++;
-		goto bad_proto;
+	} else {
+		priv->stats.rx_packets++;
+		priv->stats.rx_bytes += skb->len;
 	}
 
-	/* Statistics */
-	priv->stats.rx_packets++;
-	priv->stats.rx_bytes += skb->len;
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 bad_proto:
 	if (netif_queue_stopped(dev))
 		netif_wake_queue(dev);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
 	dev->last_rx = jiffies;
 

commit 3bd90303f05d24487759e4990c3fed3e7a6b6955
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jul 28 23:44:25 2007 +0200

    ieee1394: eth1394: superfluous local variable
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index dc9dce2..7aa0bf3 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -1153,8 +1153,6 @@ static int ether1394_data_handler(struct net_device *dev, int srcid, int destid,
 			pdg->sz++;
 			lh = find_partial_datagram(pdgl, dgl);
 		} else {
-			struct partial_datagram *pd;
-
 			pd = list_entry(lh, struct partial_datagram, list);
 
 			if (fragment_overlap(&pd->frag_info, fg_off, fg_len)) {

-- 
Stefan Richter
-=====-=-=== =-=- =---=
http://arcgraph.de/sr/

