Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYAQVLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYAQVLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYAQVLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:11:03 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47134 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbYAQVK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:10:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 17 Jan 2008 22:10:51 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git? - drivers/firewire queue
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.99a95666fea52a5e@s5r6.in-berlin.de>
Message-ID: <tkrat.10cae61e610d9dc4@s5r6.in-berlin.de>
References: <tkrat.99a95666fea52a5e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e1d65076dd7009a35a83b408e8095597a243c447
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jan 12 12:32:44 2008 +0100

    firewire vs. ieee1394: clarify MAINTAINERS
    
    Maintainers like to receive less mail, and submitters like to have to Cc
    less recipients.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/MAINTAINERS b/MAINTAINERS
index f3d7256..974617f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1573,7 +1573,7 @@ P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 S:	Maintained
 
-FIREWIRE SUBSYSTEM
+FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
 P:	Kristian Hoegsberg, Stefan Richter
 M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
@@ -1893,7 +1893,7 @@ L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
-IEEE 1394 SUBSYSTEM
+IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter

commit 6f81353c95c9538371d23964c17338198e38ad3f
Author: David Moore <dcm@MIT.EDU>
Date:   Sun Jan 6 17:21:41 2008 -0500

    firewire: fw-ohci: Dynamically allocate buffers for DMA descriptors
    
    Previously, the fw-ohci driver used fixed-length buffers for storing
    descriptors for isochronous receive DMA programs.  If an application
    (such as libdc1394) generated a DMA program that was too large, fw-ohci
    would reach the limit of its fixed-sized buffer and return an error to
    userspace.
    
    This patch replaces the fixed-length ring-buffer with a linked-list of
    page-sized buffers.  Additional buffers can be dynamically allocated and
    appended to the list when necessary.  For a particular context, buffers
    are kept around after use and reused as necessary, so there is no
    allocation taking place after the DMA program is generated for the first
    time.
    
    In addition, the buffers it uses are coherent for DMA so there is no
    syncing required before and after writes.  This syncing wasn't properly
    done in the previous version of the code.
    
    -
    
    This is the fourth version of my patch that replaces a fixed-length
    buffer for DMA descriptors with a dynamically allocated linked-list of
    buffers.
    
    As we discovered with the last attempt, new context programs are
    sometimes queued from interrupt context, making it unacceptable to call
    tasklet_disable() from context_get_descriptors().
    
    This version of the patch uses ohci->lock for all locking needs instead
    of tasklet_disable/enable.  There is a new requirement that
    context_get_descriptors() be called while holding ohci->lock.  It was
    already held for the AT context, so adding the requirement for the iso
    context did not seem particularly onerous.  In addition, this has the
    side benefit of allowing iso queue to be safely called from concurrent
    user-space threads, which previously was not safe.
    
    Signed-off-by: David Moore <dcm@acm.org>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    
    -
    
    Fixes the following issues:
      - Isochronous reception stopped prematurely if an application used a
        larger buffer.  (Reproduced with coriander.)
      - Isochronous reception stopped after one or a few frames on VT630x
        in OHCI 1.0 mode.  (Fixes reception in coriander, but dvgrab still
        doesn't work with these chips.)
    
    Patch update: struct member alignment, whitespace nits
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 74d5d94..7ebad3c 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -98,17 +98,48 @@ struct context;
 typedef int (*descriptor_callback_t)(struct context *ctx,
 				     struct descriptor *d,
 				     struct descriptor *last);
+
+/*
+ * A buffer that contains a block of DMA-able coherent memory used for
+ * storing a portion of a DMA descriptor program.
+ */
+struct descriptor_buffer {
+	struct list_head list;
+	dma_addr_t buffer_bus;
+	size_t buffer_size;
+	size_t used;
+	struct descriptor buffer[0];
+};
+
 struct context {
 	struct fw_ohci *ohci;
 	u32 regs;
+	int total_allocation;
 
-	struct descriptor *buffer;
-	dma_addr_t buffer_bus;
-	size_t buffer_size;
-	struct descriptor *head_descriptor;
-	struct descriptor *tail_descriptor;
-	struct descriptor *tail_descriptor_last;
-	struct descriptor *prev_descriptor;
+	/*
+	 * List of page-sized buffers for storing DMA descriptors.
+	 * Head of list contains buffers in use and tail of list contains
+	 * free buffers.
+	 */
+	struct list_head buffer_list;
+
+	/*
+	 * Pointer to a buffer inside buffer_list that contains the tail
+	 * end of the current DMA program.
+	 */
+	struct descriptor_buffer *buffer_tail;
+
+	/*
+	 * The descriptor containing the branch address of the first
+	 * descriptor that has not yet been filled by the device.
+	 */
+	struct descriptor *last;
+
+	/*
+	 * The last descriptor in the DMA program.  It contains the branch
+	 * address that must be updated upon appending a new descriptor.
+	 */
+	struct descriptor *prev;
 
 	descriptor_callback_t callback;
 
@@ -198,8 +229,6 @@ static inline struct fw_ohci *fw_ohci(struct fw_card *card)
 #define SELF_ID_BUF_SIZE		0x800
 #define OHCI_TCODE_PHY_PACKET		0x0e
 #define OHCI_VERSION_1_1		0x010010
-#define ISO_BUFFER_SIZE			(64 * 1024)
-#define AT_BUFFER_SIZE			4096
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
@@ -456,71 +485,108 @@ find_branch_descriptor(struct descriptor *d, int z)
 static void context_tasklet(unsigned long data)
 {
 	struct context *ctx = (struct context *) data;
-	struct fw_ohci *ohci = ctx->ohci;
 	struct descriptor *d, *last;
 	u32 address;
 	int z;
+	struct descriptor_buffer *desc;
 
-	dma_sync_single_for_cpu(ohci->card.device, ctx->buffer_bus,
-				ctx->buffer_size, DMA_TO_DEVICE);
-
-	d    = ctx->tail_descriptor;
-	last = ctx->tail_descriptor_last;
-
+	desc = list_entry(ctx->buffer_list.next,
+			struct descriptor_buffer, list);
+	last = ctx->last;
 	while (last->branch_address != 0) {
+		struct descriptor_buffer *old_desc = desc;
 		address = le32_to_cpu(last->branch_address);
 		z = address & 0xf;
-		d = ctx->buffer + (address - ctx->buffer_bus) / sizeof(*d);
+		address &= ~0xf;
+
+		/* If the branch address points to a buffer outside of the
+		 * current buffer, advance to the next buffer. */
+		if (address < desc->buffer_bus ||
+				address >= desc->buffer_bus + desc->used)
+			desc = list_entry(desc->list.next,
+					struct descriptor_buffer, list);
+		d = desc->buffer + (address - desc->buffer_bus) / sizeof(*d);
 		last = find_branch_descriptor(d, z);
 
 		if (!ctx->callback(ctx, d, last))
 			break;
 
-		ctx->tail_descriptor      = d;
-		ctx->tail_descriptor_last = last;
+		if (old_desc != desc) {
+			/* If we've advanced to the next buffer, move the
+			 * previous buffer to the free list. */
+			unsigned long flags;
+			old_desc->used = 0;
+			spin_lock_irqsave(&ctx->ohci->lock, flags);
+			list_move_tail(&old_desc->list, &ctx->buffer_list);
+			spin_unlock_irqrestore(&ctx->ohci->lock, flags);
+		}
+		ctx->last = last;
 	}
 }
 
+/*
+ * Allocate a new buffer and add it to the list of free buffers for this
+ * context.  Must be called with ohci->lock held.
+ */
+static int
+context_add_buffer(struct context *ctx)
+{
+	struct descriptor_buffer *desc;
+	dma_addr_t bus_addr;
+	int offset;
+
+	/*
+	 * 16MB of descriptors should be far more than enough for any DMA
+	 * program.  This will catch run-away userspace or DoS attacks.
+	 */
+	if (ctx->total_allocation >= 16*1024*1024)
+		return -ENOMEM;
+
+	desc = dma_alloc_coherent(ctx->ohci->card.device, PAGE_SIZE,
+			&bus_addr, GFP_ATOMIC);
+	if (!desc)
+		return -ENOMEM;
+
+	offset = (void *)&desc->buffer - (void *)desc;
+	desc->buffer_size = PAGE_SIZE - offset;
+	desc->buffer_bus = bus_addr + offset;
+	desc->used = 0;
+
+	list_add_tail(&desc->list, &ctx->buffer_list);
+	ctx->total_allocation += PAGE_SIZE;
+
+	return 0;
+}
+
 static int
 context_init(struct context *ctx, struct fw_ohci *ohci,
-	     size_t buffer_size, u32 regs,
-	     descriptor_callback_t callback)
+	     u32 regs, descriptor_callback_t callback)
 {
 	ctx->ohci = ohci;
 	ctx->regs = regs;
-	ctx->buffer_size = buffer_size;
-	ctx->buffer = kmalloc(buffer_size, GFP_KERNEL);
-	if (ctx->buffer == NULL)
+	ctx->total_allocation = 0;
+
+	INIT_LIST_HEAD(&ctx->buffer_list);
+	if (context_add_buffer(ctx) < 0)
 		return -ENOMEM;
 
+	ctx->buffer_tail = list_entry(ctx->buffer_list.next,
+			struct descriptor_buffer, list);
+
 	tasklet_init(&ctx->tasklet, context_tasklet, (unsigned long)ctx);
 	ctx->callback = callback;
 
-	ctx->buffer_bus =
-		dma_map_single(ohci->card.device, ctx->buffer,
-			       buffer_size, DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->buffer_bus)) {
-		kfree(ctx->buffer);
-		return -ENOMEM;
-	}
-
-	ctx->head_descriptor      = ctx->buffer;
-	ctx->prev_descriptor      = ctx->buffer;
-	ctx->tail_descriptor      = ctx->buffer;
-	ctx->tail_descriptor_last = ctx->buffer;
-
 	/*
 	 * We put a dummy descriptor in the buffer that has a NULL
 	 * branch address and looks like it's been sent.  That way we
-	 * have a descriptor to append DMA programs to.  Also, the
-	 * ring buffer invariant is that it always has at least one
-	 * element so that head == tail means buffer full.
+	 * have a descriptor to append DMA programs to.
 	 */
-
-	memset(ctx->head_descriptor, 0, sizeof(*ctx->head_descriptor));
-	ctx->head_descriptor->control = cpu_to_le16(DESCRIPTOR_OUTPUT_LAST);
-	ctx->head_descriptor->transfer_status = cpu_to_le16(0x8011);
-	ctx->head_descriptor++;
+	memset(ctx->buffer_tail->buffer, 0, sizeof(*ctx->buffer_tail->buffer));
+	ctx->buffer_tail->buffer->control = cpu_to_le16(DESCRIPTOR_OUTPUT_LAST);
+	ctx->buffer_tail->buffer->transfer_status = cpu_to_le16(0x8011);
+	ctx->buffer_tail->used += sizeof(*ctx->buffer_tail->buffer);
+	ctx->last = ctx->buffer_tail->buffer;
+	ctx->prev = ctx->buffer_tail->buffer;
 
 	return 0;
 }
@@ -529,35 +595,42 @@ static void
 context_release(struct context *ctx)
 {
 	struct fw_card *card = &ctx->ohci->card;
+	struct descriptor_buffer *desc, *tmp;
 
-	dma_unmap_single(card->device, ctx->buffer_bus,
-			 ctx->buffer_size, DMA_TO_DEVICE);
-	kfree(ctx->buffer);
+	list_for_each_entry_safe(desc, tmp, &ctx->buffer_list, list)
+		dma_free_coherent(card->device, PAGE_SIZE, desc,
+			desc->buffer_bus -
+			((void *)&desc->buffer - (void *)desc));
 }
 
+/* Must be called with ohci->lock held */
 static struct descriptor *
 context_get_descriptors(struct context *ctx, int z, dma_addr_t *d_bus)
 {
-	struct descriptor *d, *tail, *end;
-
-	d = ctx->head_descriptor;
-	tail = ctx->tail_descriptor;
-	end = ctx->buffer + ctx->buffer_size / sizeof(*d);
-
-	if (d + z <= tail) {
-		goto has_space;
-	} else if (d > tail && d + z <= end) {
-		goto has_space;
-	} else if (d > tail && ctx->buffer + z <= tail) {
-		d = ctx->buffer;
-		goto has_space;
-	}
+	struct descriptor *d = NULL;
+	struct descriptor_buffer *desc = ctx->buffer_tail;
+
+	if (z * sizeof(*d) > desc->buffer_size)
+		return NULL;
+
+	if (z * sizeof(*d) > desc->buffer_size - desc->used) {
+		/* No room for the descriptor in this buffer, so advance to the
+		 * next one. */
 
-	return NULL;
+		if (desc->list.next == &ctx->buffer_list) {
+			/* If there is no free buffer next in the list,
+			 * allocate one. */
+			if (context_add_buffer(ctx) < 0)
+				return NULL;
+		}
+		desc = list_entry(desc->list.next,
+				struct descriptor_buffer, list);
+		ctx->buffer_tail = desc;
+	}
 
- has_space:
+	d = desc->buffer + desc->used / sizeof(*d);
 	memset(d, 0, z * sizeof(*d));
-	*d_bus = ctx->buffer_bus + (d - ctx->buffer) * sizeof(*d);
+	*d_bus = desc->buffer_bus + desc->used;
 
 	return d;
 }
@@ -567,7 +640,7 @@ static void context_run(struct context *ctx, u32 extra)
 	struct fw_ohci *ohci = ctx->ohci;
 
 	reg_write(ohci, COMMAND_PTR(ctx->regs),
-		  le32_to_cpu(ctx->tail_descriptor_last->branch_address));
+		  le32_to_cpu(ctx->last->branch_address));
 	reg_write(ohci, CONTROL_CLEAR(ctx->regs), ~0);
 	reg_write(ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN | extra);
 	flush_writes(ohci);
@@ -577,15 +650,13 @@ static void context_append(struct context *ctx,
 			   struct descriptor *d, int z, int extra)
 {
 	dma_addr_t d_bus;
+	struct descriptor_buffer *desc = ctx->buffer_tail;
 
-	d_bus = ctx->buffer_bus + (d - ctx->buffer) * sizeof(*d);
+	d_bus = desc->buffer_bus + (d - desc->buffer) * sizeof(*d);
 
-	ctx->head_descriptor = d + z + extra;
-	ctx->prev_descriptor->branch_address = cpu_to_le32(d_bus | z);
-	ctx->prev_descriptor = find_branch_descriptor(d, z);
-
-	dma_sync_single_for_device(ctx->ohci->card.device, ctx->buffer_bus,
-				   ctx->buffer_size, DMA_TO_DEVICE);
+	desc->used += (z + extra) * sizeof(*d);
+	ctx->prev->branch_address = cpu_to_le32(d_bus | z);
+	ctx->prev = find_branch_descriptor(d, z);
 
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_WAKE);
 	flush_writes(ctx->ohci);
@@ -1571,8 +1642,7 @@ ohci_allocate_iso_context(struct fw_card *card, int type, size_t header_size)
 	if (ctx->header == NULL)
 		goto out;
 
-	retval = context_init(&ctx->context, ohci, ISO_BUFFER_SIZE,
-			      regs, callback);
+	retval = context_init(&ctx->context, ohci, regs, callback);
 	if (retval < 0)
 		goto out_with_header;
 
@@ -1933,16 +2003,22 @@ ohci_queue_iso(struct fw_iso_context *base,
 	       unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
+	unsigned long flags;
+	int retval;
 
+	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
 	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
-		return ohci_queue_iso_transmit(base, packet, buffer, payload);
+		retval = ohci_queue_iso_transmit(base, packet, buffer, payload);
 	else if (ctx->context.ohci->version >= OHCI_VERSION_1_1)
-		return ohci_queue_iso_receive_dualbuffer(base, packet,
+		retval = ohci_queue_iso_receive_dualbuffer(base, packet,
 							 buffer, payload);
 	else
-		return ohci_queue_iso_receive_packet_per_buffer(base, packet,
+		retval = ohci_queue_iso_receive_packet_per_buffer(base, packet,
 								buffer,
 								payload);
+	spin_unlock_irqrestore(&ctx->context.ohci->lock, flags);
+
+	return retval;
 }
 
 static const struct fw_card_driver ohci_driver = {
@@ -2014,10 +2090,10 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	ar_context_init(&ohci->ar_response_ctx, ohci,
 			OHCI1394_AsRspRcvContextControlSet);
 
-	context_init(&ohci->at_request_ctx, ohci, AT_BUFFER_SIZE,
+	context_init(&ohci->at_request_ctx, ohci,
 		     OHCI1394_AsReqTrContextControlSet, handle_at_packet);
 
-	context_init(&ohci->at_response_ctx, ohci, AT_BUFFER_SIZE,
+	context_init(&ohci->at_response_ctx, ohci,
 		     OHCI1394_AsRspTrContextControlSet, handle_at_packet);
 
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, ~0);

commit 5f22f2ebc5bd28c6a5501b1c0e47c0eda5b1c9db
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Dec 22 22:14:52 2007 +0100

    firewire: fw-ohci: CycleTooLong interrupt management
    
    The firewire-ohci driver so far lacked the ability to resume cycle
    master duty after that condition happened, as added to ohci1394 in Linux
    2.6.18 by commit 57fdb58fa5a140bdd52cf4c4ffc30df73676f0a5.  This ports
    this patch to fw-ohci.
    
    The "cycle too long" condition has been seen in practice
      - with IIDC cameras if a mode with packets too large for a speed is
        chosen,
      - sporadically when capturing DV on a VIA VT6306 card with ohci1394/
        ieee1394/ raw1394/ dvgrab 2.
        https://bugzilla.redhat.com/show_bug.cgi?id=415841#c7
    (This does not fix Fedora bug 415841.)
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index a9f2d07..74d5d94 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1079,6 +1079,13 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (unlikely(event & OHCI1394_postedWriteErr))
 		fw_error("PCI posted write error\n");
 
+	if (unlikely(event & OHCI1394_cycleTooLong)) {
+		if (printk_ratelimit())
+			fw_notify("isochronous cycle too long\n");
+		reg_write(ohci, OHCI1394_LinkControlSet,
+			  OHCI1394_LinkControl_cycleMaster);
+	}
+
 	if (event & OHCI1394_cycle64Seconds) {
 		cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 		if ((cycle_time & 0x80000000) == 0)
@@ -1152,8 +1159,8 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 		  OHCI1394_RQPkt | OHCI1394_RSPkt |
 		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
 		  OHCI1394_isochRx | OHCI1394_isochTx |
-		  OHCI1394_postedWriteErr | OHCI1394_cycle64Seconds |
-		  OHCI1394_masterIntEnable);
+		  OHCI1394_postedWriteErr | OHCI1394_cycleTooLong |
+		  OHCI1394_cycle64Seconds | OHCI1394_masterIntEnable);
 
 	/* Activate link_on bit and contender bit in our self ID packets.*/
 	if (ohci_update_phy_reg(card, 4, 0,

commit c31a331aa8e073f15578423217fec270a0060ddc
Author: Rabin Vincent <rabin@rab.in>
Date:   Fri Dec 21 23:02:15 2007 +0530

    firewire: Fix extraction of source node id
    
    Fix extraction of the source node id from the packet header.
    
    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index c00d4a9..8018c3b 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -650,7 +650,7 @@ fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
 		 HEADER_GET_OFFSET_HIGH(p->header[1]) << 32) | p->header[2];
 	tcode       = HEADER_GET_TCODE(p->header[0]);
 	destination = HEADER_GET_DESTINATION(p->header[0]);
-	source      = HEADER_GET_SOURCE(p->header[0]);
+	source      = HEADER_GET_SOURCE(p->header[1]);
 
 	spin_lock_irqsave(&address_handler_lock, flags);
 	handler = lookup_enclosing_address_handler(&address_handler_list,

commit 3fa7597d1ee9a616ca39acb38f23fdc88168be80
Author: David Moore <dcm@MIT.EDU>
Date:   Wed Dec 19 15:26:38 2007 -0500

    firewire: fw-ohci: Bug fixes for packet-per-buffer support
    
    This patch corrects a number of bugs in the current OHCI 1.0
    packet-per-buffer support:
    
    1. Correctly deal with payloads that cross a page boundary.  The
    previous version would not split the descriptor at such a boundary,
    potentially corrupting unrelated memory.
    
    2. Allow user-space to specify multiple packets per struct
    fw_cdev_iso_packet in the same way that dual-buffer allows.  This is
    signaled by header_length being a multiple of header_size.  This
    multiple determines the number of packets.  The payload size allocated
    per packet is determined by dividing the total payload size by the
    number of packets.
    
    3. Make sync support work properly for packet-per-buffer.
    
    I have tested this patch with libdc1394 by forcing my OHCI 1.1
    controller to use the packet-per-buffer support instead of dual-buffer.
    
    I would greatly appreciate testing by those who have a DV devices and
    other types of iso streamers to make sure I didn't cause any
    regressions.
    
    Stefan, with this patch, I'm hoping that libdc1394 will work with all
    your OHCI 1.0 controllers now.
    
    The one bit of future work that remains for packet-per-buffer support is
    the automatic compaction of short payloads that I discussed with
    Kristian.
    
    Signed-off-by: David Moore <dcm@acm.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index a44d16d..a9f2d07 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1461,24 +1461,24 @@ static int handle_ir_packet_per_buffer(struct context *context,
 {
 	struct iso_context *ctx =
 		container_of(context, struct iso_context, context);
-	struct descriptor *pd = d + 1;
+	struct descriptor *pd;
 	__le32 *ir_header;
-	size_t header_length;
-	void *p, *end;
-	int i, z;
+	void *p;
+	int i;
 
-	if (pd->res_count == pd->req_count)
+	for (pd = d; pd <= last; pd++) {
+		if (pd->transfer_status)
+			break;
+	}
+	if (pd > last)
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
-	header_length = le16_to_cpu(d->req_count);
-
 	i   = ctx->header_length;
-	z   = le32_to_cpu(pd->branch_address) & 0xf;
-	p   = d + z;
-	end = p + header_length;
+	p   = last + 1;
 
-	while (p < end && i + ctx->base.header_size <= PAGE_SIZE) {
+	if (ctx->base.header_size > 0 &&
+			i + ctx->base.header_size <= PAGE_SIZE) {
 		/*
 		 * The iso header is byteswapped to little endian by
 		 * the controller, but the remaining header quadlets
@@ -1487,14 +1487,11 @@ static int handle_ir_packet_per_buffer(struct context *context,
 		 */
 		*(u32 *) (ctx->header + i) = __swab32(*(u32 *) (p + 4));
 		memcpy(ctx->header + i + 4, p + 8, ctx->base.header_size - 4);
-		i += ctx->base.header_size;
-		p += ctx->base.header_size + 4;
+		ctx->header_length += ctx->base.header_size;
 	}
 
-	ctx->header_length = i;
-
-	if (le16_to_cpu(pd->control) & DESCRIPTOR_IRQ_ALWAYS) {
-		ir_header = (__le32 *) (d + z);
+	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS) {
+		ir_header = (__le32 *) p;
 		ctx->base.callback(&ctx->base,
 				   le32_to_cpu(ir_header[0]) & 0xffff,
 				   ctx->header_length, ctx->header,
@@ -1502,7 +1499,6 @@ static int handle_ir_packet_per_buffer(struct context *context,
 		ctx->header_length = 0;
 	}
 
-
 	return 1;
 }
 
@@ -1853,67 +1849,70 @@ ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct descriptor *d = NULL, *pd = NULL;
-	struct fw_iso_packet *p;
+	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
-	int i, page, offset, packet_count, header_size;
-
-	if (packet->skip) {
-		d = context_get_descriptors(&ctx->context, 1, &d_bus);
-		if (d == NULL)
-			return -ENOMEM;
-
-		d->control = cpu_to_le16(DESCRIPTOR_STATUS |
-					 DESCRIPTOR_INPUT_LAST |
-					 DESCRIPTOR_BRANCH_ALWAYS |
-					 DESCRIPTOR_WAIT);
-		context_append(&ctx->context, d, 1, 0);
-	}
-
-	/* one descriptor for header, one for payload */
-	/* FIXME: handle cases where we need multiple desc. for payload */
-	z = 2;
-	p = packet;
+	int i, j, length;
+	int page, offset, packet_count, header_size, payload_per_buffer;
 
 	/*
 	 * The OHCI controller puts the status word in the
 	 * buffer too, so we need 4 extra bytes per packet.
 	 */
 	packet_count = p->header_length / ctx->base.header_size;
-	header_size  = packet_count * (ctx->base.header_size + 4);
+	header_size  = ctx->base.header_size + 4;
 
 	/* Get header size in number of descriptors. */
 	header_z = DIV_ROUND_UP(header_size, sizeof(*d));
 	page     = payload >> PAGE_SHIFT;
 	offset   = payload & ~PAGE_MASK;
-	rest     = p->payload_length;
+	payload_per_buffer = p->payload_length / packet_count;
 
 	for (i = 0; i < packet_count; i++) {
 		/* d points to the header descriptor */
+		z = DIV_ROUND_UP(payload_per_buffer + offset, PAGE_SIZE) + 1;
 		d = context_get_descriptors(&ctx->context,
-					    z + header_z, &d_bus);
+				z + header_z, &d_bus);
 		if (d == NULL)
 			return -ENOMEM;
 
-		d->control      = cpu_to_le16(DESCRIPTOR_INPUT_MORE);
+		d->control      = cpu_to_le16(DESCRIPTOR_STATUS |
+					      DESCRIPTOR_INPUT_MORE);
+		if (p->skip && i == 0)
+			d->control |= cpu_to_le16(DESCRIPTOR_WAIT);
 		d->req_count    = cpu_to_le16(header_size);
 		d->res_count    = d->req_count;
+		d->transfer_status = 0;
 		d->data_address = cpu_to_le32(d_bus + (z * sizeof(*d)));
 
-		/* pd points to the payload descriptor */
-		pd = d + 1;
+		rest = payload_per_buffer;
+		for (j = 1; j < z; j++) {
+			pd = d + j;
+			pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
+						  DESCRIPTOR_INPUT_MORE);
+
+			if (offset + rest < PAGE_SIZE)
+				length = rest;
+			else
+				length = PAGE_SIZE - offset;
+			pd->req_count = cpu_to_le16(length);
+			pd->res_count = pd->req_count;
+			pd->transfer_status = 0;
+
+			page_bus = page_private(buffer->pages[page]);
+			pd->data_address = cpu_to_le32(page_bus + offset);
+
+			offset = (offset + length) & ~PAGE_MASK;
+			rest -= length;
+			if (offset == 0)
+				page++;
+		}
 		pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 					  DESCRIPTOR_INPUT_LAST |
 					  DESCRIPTOR_BRANCH_ALWAYS);
-		if (p->interrupt)
+		if (p->interrupt && i == packet_count - 1)
 			pd->control |= cpu_to_le16(DESCRIPTOR_IRQ_ALWAYS);
 
-		pd->req_count = cpu_to_le16(rest);
-		pd->res_count = pd->req_count;
-
-		page_bus = page_private(buffer->pages[page]);
-		pd->data_address = cpu_to_le32(page_bus + offset);
-
 		context_append(&ctx->context, d, z, header_z);
 	}
 

commit 736287c63aa037b675150d4e13af8f4d11912434
Author: David Moore <dcm@MIT.EDU>
Date:   Wed Dec 19 03:09:18 2007 -0500

    firewire: fw-ohci: Fix for dualbuffer three-or-more buffers
    
    This patch fixes the problem where different OHCI 1.1 controllers behave
    differently when a received iso packet straddles three or more buffers
    when using the dual-buffer receive mode.  Two changes are made in order
    to handle this situation:
    
    1. The packet sync DMA descriptor is given a non-zero header length and
    non-zero payload length.  This is because zero-payload descriptors are
    not discussed in the OHCI 1.1 specs and their behavior is thus
    undefined.  Instead we use a header size just large enough for a single
    header and a payload length of 4 bytes for this first descriptor.
    
    2. As we process received packets in the context's tasklet, read the
    packet length out of the headers.  Keep track of the running total of
    the packet length as "excess_bytes", so we can ignore any descriptors
    where no packet starts or ends.  These descriptors may not have had
    their first_res_count or second_res_count fields updated by the
    controller so we cannot rely on those values.
    
    The main drawback of this patch is that the excess_bytes value might get
    "out of sync" with the packet descriptors if something strange happens
    to the DMA program.  I'm not if such a thing could ever happen, but I
    appreciate any suggestions in making it more robust.
    
    Also, the packet-per-buffer support may need a similar fix to deal with
    issue 1, but I haven't done any work on that yet.
    
    Stefan, I'm hoping that with this patch, all your OHCI 1.1 controllers
    will work properly with an unmodified version of libdc1394.
    
    Signed-off-by: David Moore <dcm@acm.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 436a855..a44d16d 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -125,6 +125,7 @@ struct context {
 struct iso_context {
 	struct fw_iso_context base;
 	struct context context;
+	int excess_bytes;
 	void *header;
 	size_t header_length;
 };
@@ -1408,9 +1409,13 @@ static int handle_ir_dualbuffer_packet(struct context *context,
 	void *p, *end;
 	int i;
 
-	if (db->first_res_count > 0 && db->second_res_count > 0)
-		/* This descriptor isn't done yet, stop iteration. */
-		return 0;
+	if (db->first_res_count > 0 && db->second_res_count > 0) {
+		if (ctx->excess_bytes <= le16_to_cpu(db->second_req_count)) {
+			/* This descriptor isn't done yet, stop iteration. */
+			return 0;
+		}
+		ctx->excess_bytes -= le16_to_cpu(db->second_req_count);
+	}
 
 	header_length = le16_to_cpu(db->first_req_count) -
 		le16_to_cpu(db->first_res_count);
@@ -1429,11 +1434,15 @@ static int handle_ir_dualbuffer_packet(struct context *context,
 		*(u32 *) (ctx->header + i) = __swab32(*(u32 *) (p + 4));
 		memcpy(ctx->header + i + 4, p + 8, ctx->base.header_size - 4);
 		i += ctx->base.header_size;
+		ctx->excess_bytes +=
+			(le32_to_cpu(*(u32 *)(p + 4)) >> 16) & 0xffff;
 		p += ctx->base.header_size + 4;
 	}
-
 	ctx->header_length = i;
 
+	ctx->excess_bytes -= le16_to_cpu(db->second_req_count) -
+		le16_to_cpu(db->second_res_count);
+
 	if (le16_to_cpu(db->control) & DESCRIPTOR_IRQ_ALWAYS) {
 		ir_header = (__le32 *) (db + 1);
 		ctx->base.callback(&ctx->base,
@@ -1775,19 +1784,6 @@ ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
 	 * packet, retransmit or terminate..
 	 */
 
-	if (packet->skip) {
-		d = context_get_descriptors(&ctx->context, 2, &d_bus);
-		if (d == NULL)
-			return -ENOMEM;
-
-		db = (struct db_descriptor *) d;
-		db->control = cpu_to_le16(DESCRIPTOR_STATUS |
-					  DESCRIPTOR_BRANCH_ALWAYS |
-					  DESCRIPTOR_WAIT);
-		db->first_size = cpu_to_le16(ctx->base.header_size + 4);
-		context_append(&ctx->context, d, 2, 0);
-	}
-
 	p = packet;
 	z = 2;
 
@@ -1815,11 +1811,18 @@ ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
 		db->control = cpu_to_le16(DESCRIPTOR_STATUS |
 					  DESCRIPTOR_BRANCH_ALWAYS);
 		db->first_size = cpu_to_le16(ctx->base.header_size + 4);
-		db->first_req_count = cpu_to_le16(header_size);
+		if (p->skip && rest == p->payload_length) {
+			db->control |= cpu_to_le16(DESCRIPTOR_WAIT);
+			db->first_req_count = db->first_size;
+		} else {
+			db->first_req_count = cpu_to_le16(header_size);
+		}
 		db->first_res_count = db->first_req_count;
 		db->first_buffer = cpu_to_le32(d_bus + sizeof(*db));
 
-		if (offset + rest < PAGE_SIZE)
+		if (p->skip && rest == p->payload_length)
+			length = 4;
+		else if (offset + rest < PAGE_SIZE)
 			length = rest;
 		else
 			length = PAGE_SIZE - offset;
@@ -1835,7 +1838,8 @@ ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
 		context_append(&ctx->context, d, z, header_z);
 		offset = (offset + length) & ~PAGE_MASK;
 		rest -= length;
-		page++;
+		if (offset == 0)
+			page++;
 	}
 
 	return 0;

commit 485c755abaec14690375eaf2697d187cc7d39903
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Dec 16 17:32:11 2007 +0100

    firewire: fw-sbp2: remove unused misleading macro
    
    SBP2_MAX_SECTORS is nowhere used in fw-sbp2.
    It merely got copied over from sbp2 where it played a role in the past.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 0b458e2..6064c6e 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -151,9 +151,7 @@ struct sbp2_target {
 };
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
-#define SBP2_MAX_SECTORS		255	/* Max sectors supported */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
-
 #define SBP2_ORB_NULL			0x80000000
 
 #define SBP2_DIRECTION_TO_MEDIA		0x0

commit 1cc5d8ba2bcafe54fa17337d299fa474685eda89
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Wed Nov 7 17:39:00 2007 -0500

    firewire: fw-sbp2: quiet logout errors on device removal
    
    This suppresses both reply timed out and management write failed
    errors on LOGOUT requests.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index aa0e89c..0b458e2 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -540,14 +540,26 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 
 	retval = -EIO;
 	if (sbp2_cancel_orbs(lu) == 0) {
-		fw_error("orb reply timed out, rcode=0x%02x\n",
-			 orb->base.rcode);
+		/*
+		 * Logout requests frequently get sent to devices that aren't
+		 * there any more, resulting in extraneous error messages in
+		 * the logs.  Unfortunately, this means logout requests that
+		 * actually fail don't get logged.
+		 */
+		if (function != SBP2_LOGOUT_REQUEST)
+			fw_error("orb reply timed out, rcode=0x%02x\n",
+				 orb->base.rcode);
 		goto out;
 	}
 
 	if (orb->base.rcode != RCODE_COMPLETE) {
-		fw_error("management write failed, rcode 0x%02x\n",
-			 orb->base.rcode);
+		/*
+		 * On device removal from the bus, sometimes the logout
+		 * request times out, sometimes it just fails.
+		 */
+		if (function != SBP2_LOGOUT_REQUEST)
+			fw_error("management write failed, rcode 0x%02x\n",
+				 orb->base.rcode);
 		goto out;
 	}
 

commit 2f0b83b7b1d9f304e8d2805a2922168848f56d8f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Jan 15 21:10:50 2008 +0100

    firewire: fw-sbp2: prepare for s/g chaining
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 35f47a2..aa0e89c 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1107,9 +1107,9 @@ sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
 	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
 	 * during DMA mapping, and Linux currently doesn't prevent this.
 	 */
-	for (i = 0, j = 0; i < count; i++) {
-		sg_len = sg_dma_len(sg + i);
-		sg_addr = sg_dma_address(sg + i);
+	for (i = 0, j = 0; i < count; i++, sg = sg_next(sg)) {
+		sg_len = sg_dma_len(sg);
+		sg_addr = sg_dma_address(sg);
 		while (sg_len) {
 			/* FIXME: This won't get us out of the pinch. */
 			if (unlikely(j >= ARRAY_SIZE(orb->page_table))) {

commit aa982a37874003320f2399395a6839e74553f5e3
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Nov 7 01:12:51 2007 +0100

    firewire: fw-sbp2: refactor workq and kref handling
    
    This somewhat reduces the size of firewire-sbp2.ko.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 624ff3e..35f47a2 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -628,6 +628,21 @@ static void sbp2_release_target(struct kref *kref)
 
 static struct workqueue_struct *sbp2_wq;
 
+/*
+ * Always get the target's kref when scheduling work on one its units.
+ * Each workqueue job is responsible to call sbp2_target_put() upon return.
+ */
+static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
+{
+	if (queue_delayed_work(sbp2_wq, &lu->work, delay))
+		kref_get(&lu->tgt->kref);
+}
+
+static void sbp2_target_put(struct sbp2_target *tgt)
+{
+	kref_put(&tgt->kref, sbp2_release_target);
+}
+
 static void sbp2_reconnect(struct work_struct *work);
 
 static void sbp2_login(struct work_struct *work)
@@ -649,16 +664,12 @@ static void sbp2_login(struct work_struct *work)
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
-		if (lu->retries++ < 5) {
-			if (queue_delayed_work(sbp2_wq, &lu->work,
-					       DIV_ROUND_UP(HZ, 5)))
-				kref_get(&lu->tgt->kref);
-		} else {
+		if (lu->retries++ < 5)
+			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+		else
 			fw_error("failed to login to %s LUN %04x\n",
 				 unit->device.bus_id, lu->lun);
-		}
-		kref_put(&lu->tgt->kref, sbp2_release_target);
-		return;
+		goto out;
 	}
 
 	lu->generation        = generation;
@@ -700,7 +711,8 @@ static void sbp2_login(struct work_struct *work)
 		lu->sdev = sdev;
 		scsi_device_put(sdev);
 	}
-	kref_put(&lu->tgt->kref, sbp2_release_target);
+ out:
+	sbp2_target_put(lu->tgt);
 }
 
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
@@ -865,18 +877,13 @@ static int sbp2_probe(struct device *dev)
 
 	get_device(&unit->device);
 
-	/*
-	 * We schedule work to do the login so we can easily
-	 * reschedule retries. Always get the ref before scheduling
-	 * work.
-	 */
+	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
-			kref_get(&tgt->kref);
+		sbp2_queue_work(lu, 0);
 	return 0;
 
  fail_tgt_put:
-	kref_put(&tgt->kref, sbp2_release_target);
+	sbp2_target_put(tgt);
 	return -ENOMEM;
 
  fail_shost_put:
@@ -889,7 +896,7 @@ static int sbp2_remove(struct device *dev)
 	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = unit->device.driver_data;
 
-	kref_put(&tgt->kref, sbp2_release_target);
+	sbp2_target_put(tgt);
 	return 0;
 }
 
@@ -915,10 +922,8 @@ static void sbp2_reconnect(struct work_struct *work)
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
-		if (queue_delayed_work(sbp2_wq, &lu->work, DIV_ROUND_UP(HZ, 5)))
-			kref_get(&lu->tgt->kref);
-		kref_put(&lu->tgt->kref, sbp2_release_target);
-		return;
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+		goto out;
 	}
 
 	lu->generation        = generation;
@@ -930,8 +935,8 @@ static void sbp2_reconnect(struct work_struct *work)
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
-
-	kref_put(&lu->tgt->kref, sbp2_release_target);
+ out:
+	sbp2_target_put(lu->tgt);
 }
 
 static void sbp2_update(struct fw_unit *unit)
@@ -947,8 +952,7 @@ static void sbp2_update(struct fw_unit *unit)
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
 		lu->retries = 0;
-		if (queue_delayed_work(sbp2_wq, &lu->work, 0))
-			kref_get(&tgt->kref);
+		sbp2_queue_work(lu, 0);
 	}
 }
 

-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/

