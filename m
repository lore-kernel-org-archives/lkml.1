Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXEBMS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXEBMS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993080AbXEBMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:18:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58888 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993078AbXEBMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:18:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 May 2007 14:15:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/6] firewire: handling of cards, buses, nodes
To: linux-kernel@vger.kernel.org
cc: Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <tkrat.087ee29add656926@s5r6.in-berlin.de>
Message-ID: <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
 <20070502090007.GA28174@infradead.org>
 <tkrat.087ee29add656926@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c     |  544 ++++++++++++++++++++++
 drivers/firewire/fw-device.c   |  782 +++++++++++++++++++++++++++++++++
 drivers/firewire/fw-device.h   |  149 ++++++
 drivers/firewire/fw-topology.c |  519 +++++++++++++++++++++
 drivers/firewire/fw-topology.h |   94 +++
 5 files changed, 2088 insertions(+)

Index: linux_juju/drivers/firewire/fw-card.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-card.c
@@ -0,0 +1,544 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-card.c - card level functions
+ *
+ * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/rwsem.h>
+#include "fw-transaction.h"
+#include "fw-topology.h"
+#include "fw-device.h"
+
+/* The lib/crc16.c implementation uses the standard (0x8005)
+ * polynomial, but we need the ITU-T (or CCITT) polynomial (0x1021).
+ * The implementation below works on an array of host-endian u32
+ * words, assuming they'll be transmited msb first. */
+u16
+crc16_itu_t(const u32 *buffer, size_t length)
+{
+	int shift, i;
+	u32 data;
+	u16 sum, crc = 0;
+
+	for (i = 0; i < length; i++) {
+		data = *buffer++;
+		for (shift = 28; shift >= 0; shift -= 4 ) {
+			sum = ((crc >> 12) ^ (data >> shift)) & 0xf;
+			crc = (crc << 4) ^ (sum << 12) ^ (sum << 5) ^ (sum);
+		}
+		crc &= 0xffff;
+	}
+
+	return crc;
+}
+
+static DECLARE_RWSEM(card_rwsem);
+static LIST_HEAD(card_list);
+
+static LIST_HEAD(descriptor_list);
+static int descriptor_count;
+
+#define bib_crc(v)		((v) <<  0)
+#define bib_crc_length(v)	((v) << 16)
+#define bib_info_length(v)	((v) << 24)
+
+#define bib_link_speed(v)	((v) <<  0)
+#define bib_generation(v)	((v) <<  4)
+#define bib_max_rom(v)		((v) <<  8)
+#define bib_max_receive(v)	((v) << 12)
+#define bib_cyc_clk_acc(v)	((v) << 16)
+#define bib_pmc			((1) << 27)
+#define bib_bmc			((1) << 28)
+#define bib_isc			((1) << 29)
+#define bib_cmc			((1) << 30)
+#define bib_imc			((1) << 31)
+
+static u32 *
+generate_config_rom (struct fw_card *card, size_t *config_rom_length)
+{
+	struct fw_descriptor *desc;
+	static u32 config_rom[256];
+	int i, j, length;
+
+	/* Initialize contents of config rom buffer.  On the OHCI
+	 * controller, block reads to the config rom accesses the host
+	 * memory, but quadlet read access the hardware bus info block
+	 * registers.  That's just crack, but it means we should make
+	 * sure the contents of bus info block in host memory mathces
+	 * the version stored in the OHCI registers. */
+
+	memset(config_rom, 0, sizeof config_rom);
+	config_rom[0] = bib_crc_length(4) | bib_info_length(4) | bib_crc(0);
+	config_rom[1] = 0x31333934;
+
+	config_rom[2] =
+		bib_link_speed(card->link_speed) |
+		bib_generation(card->config_rom_generation++ % 14 + 2) |
+		bib_max_rom(2) |
+		bib_max_receive(card->max_receive) |
+		bib_bmc | bib_isc | bib_cmc | bib_imc;
+	config_rom[3] = card->guid >> 32;
+	config_rom[4] = card->guid;
+
+	/* Generate root directory. */
+	i = 5;
+	config_rom[i++] = 0;
+	config_rom[i++] = 0x0c0083c0; /* node capabilities */
+	j = i + descriptor_count;
+
+	/* Generate root directory entries for descriptors. */
+	list_for_each_entry (desc, &descriptor_list, link) {
+		if (desc->immediate > 0)
+			config_rom[i++] = desc->immediate;
+		config_rom[i] = desc->key | (j - i);
+		i++;
+		j += desc->length;
+	}
+
+	/* Update root directory length. */
+	config_rom[5] = (i - 5 - 1) << 16;
+
+	/* End of root directory, now copy in descriptors. */
+	list_for_each_entry (desc, &descriptor_list, link) {
+		memcpy(&config_rom[i], desc->data, desc->length * 4);
+		i += desc->length;
+	}
+
+	/* Calculate CRCs for all blocks in the config rom.  This
+	 * assumes that CRC length and info length are identical for
+	 * the bus info block, which is always the case for this
+	 * implementation. */
+	for (i = 0; i < j; i += length + 1) {
+		length = (config_rom[i] >> 16) & 0xff;
+		config_rom[i] |= crc16_itu_t(&config_rom[i + 1], length);
+	}
+
+	*config_rom_length = j;
+
+	return config_rom;
+}
+
+static void
+update_config_roms (void)
+{
+	struct fw_card *card;
+	u32 *config_rom;
+	size_t length;
+
+	list_for_each_entry (card, &card_list, link) {
+		config_rom = generate_config_rom(card, &length);
+		card->driver->set_config_rom(card, config_rom, length);
+	}
+}
+
+int
+fw_core_add_descriptor (struct fw_descriptor *desc)
+{
+	size_t i;
+
+	/* Check descriptor is valid; the length of all blocks in the
+	 * descriptor has to add up to exactly the length of the
+	 * block. */
+	i = 0;
+	while (i < desc->length)
+		i += (desc->data[i] >> 16) + 1;
+
+	if (i != desc->length)
+		return -EINVAL;
+
+	down_write(&card_rwsem);
+
+	list_add_tail (&desc->link, &descriptor_list);
+	descriptor_count++;
+	if (desc->immediate > 0)
+		descriptor_count++;
+	update_config_roms();
+
+	up_write(&card_rwsem);
+
+	return 0;
+}
+EXPORT_SYMBOL(fw_core_add_descriptor);
+
+void
+fw_core_remove_descriptor (struct fw_descriptor *desc)
+{
+	down_write(&card_rwsem);
+
+	list_del(&desc->link);
+	descriptor_count--;
+	if (desc->immediate > 0)
+		descriptor_count--;
+	update_config_roms();
+
+	up_write(&card_rwsem);
+}
+EXPORT_SYMBOL(fw_core_remove_descriptor);
+
+static const char gap_count_table[] = {
+	63, 5, 7, 8, 10, 13, 16, 18, 21, 24, 26, 29, 32, 35, 37, 40
+};
+
+struct bm_data {
+	struct fw_transaction t;
+	struct {
+		__be32 arg;
+		__be32 data;
+	} lock;
+	u32 old;
+	int rcode;
+	struct completion done;
+};
+
+static void
+complete_bm_lock(struct fw_card *card, int rcode,
+		 void *payload, size_t length, void *data)
+{
+	struct bm_data *bmd = data;
+
+	if (rcode == RCODE_COMPLETE)
+		bmd->old = be32_to_cpu(*(__be32 *) payload);
+	bmd->rcode = rcode;
+	complete(&bmd->done);
+}
+
+static void
+fw_card_bm_work(struct work_struct *work)
+{
+	struct fw_card *card = container_of(work, struct fw_card, work.work);
+	struct fw_device *root;
+	struct bm_data bmd;
+	unsigned long flags;
+	int root_id, new_root_id, irm_id, gap_count, generation, grace;
+	int do_reset = 0;
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	generation = card->generation;
+	root = card->root_node->data;
+	root_id = card->root_node->node_id;
+	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
+
+	if (card->bm_generation + 1 == generation ||
+	    (card->bm_generation != generation && grace)) {
+		/* This first step is to figure out who is IRM and
+		 * then try to become bus manager.  If the IRM is not
+		 * well defined (e.g. does not have an active link
+		 * layer or does not responds to our lock request, we
+		 * will have to do a little vigilante bus management.
+		 * In that case, we do a goto into the gap count logic
+		 * so that when we do the reset, we still optimize the
+		 * gap count.  That could well save a reset in the
+		 * next generation. */
+
+		irm_id = card->irm_node->node_id;
+		if (!card->irm_node->link_on) {
+			new_root_id = card->local_node->node_id;
+			fw_notify("IRM has link off, making local node (%02x) root.\n",
+				  new_root_id);
+			goto pick_me;
+		}
+
+		bmd.lock.arg = cpu_to_be32(0x3f);
+		bmd.lock.data = cpu_to_be32(card->local_node->node_id);
+
+		spin_unlock_irqrestore(&card->lock, flags);
+
+		init_completion(&bmd.done);
+		fw_send_request(card, &bmd.t, TCODE_LOCK_COMPARE_SWAP,
+				irm_id, generation,
+				SCODE_100, CSR_REGISTER_BASE + CSR_BUS_MANAGER_ID,
+				&bmd.lock, sizeof bmd.lock,
+				complete_bm_lock, &bmd);
+		wait_for_completion(&bmd.done);
+
+		if (bmd.rcode == RCODE_GENERATION) {
+			/* Another bus reset happened. Just return,
+			 * the BM work has been rescheduled. */
+			return;
+		}
+
+		if (bmd.rcode == RCODE_COMPLETE && bmd.old != 0x3f)
+			/* Somebody else is BM, let them do the work. */
+			return;
+
+		spin_lock_irqsave(&card->lock, flags);
+		if (bmd.rcode != RCODE_COMPLETE) {
+			/* The lock request failed, maybe the IRM
+			 * isn't really IRM capable after all. Let's
+			 * do a bus reset and pick the local node as
+			 * root, and thus, IRM. */
+			new_root_id = card->local_node->node_id;
+			fw_notify("BM lock failed, making local node (%02x) root.\n",
+				  new_root_id);
+			goto pick_me;
+		}
+	} else if (card->bm_generation != generation) {
+		/* OK, we weren't BM in the last generation, and it's
+		 * less than 100ms since last bus reset. Reschedule
+		 * this task 100ms from now. */
+		spin_unlock_irqrestore(&card->lock, flags);
+		schedule_delayed_work(&card->work, DIV_ROUND_UP(HZ, 10));
+		return;
+	}
+
+	/* We're bus manager for this generation, so next step is to
+	 * make sure we have an active cycle master and do gap count
+	 * optimization. */
+	card->bm_generation = generation;
+
+	if (root == NULL) {
+		/* Either link_on is false, or we failed to read the
+		 * config rom.  In either case, pick another root. */
+		new_root_id = card->local_node->node_id;
+	} else if (atomic_read(&root->state) != FW_DEVICE_RUNNING) {
+		/* If we haven't probed this device yet, bail out now
+		 * and let's try again once that's done. */
+		spin_unlock_irqrestore(&card->lock, flags);
+		return;
+	} else if (root->config_rom[2] & bib_cmc) {
+		/* FIXME: I suppose we should set the cmstr bit in the
+		 * STATE_CLEAR register of this node, as described in
+		 * 1394-1995, 8.4.2.6.  Also, send out a force root
+		 * packet for this node. */
+		new_root_id = root_id;
+	} else {
+		/* Current root has an active link layer and we
+		 * successfully read the config rom, but it's not
+		 * cycle master capable. */
+		new_root_id = card->local_node->node_id;
+	}
+
+ pick_me:
+	/* Now figure out what gap count to set. */
+	if (card->topology_type == FW_TOPOLOGY_A &&
+	    card->root_node->max_hops < ARRAY_SIZE(gap_count_table))
+		gap_count = gap_count_table[card->root_node->max_hops];
+	else
+		gap_count = 63;
+
+	/* Finally, figure out if we should do a reset or not.  If we've
+	 * done less that 5 resets with the same physical topology and we
+	 * have either a new root or a new gap count setting, let's do it. */
+
+	if (card->bm_retries++ < 5 &&
+	    (card->gap_count != gap_count || new_root_id != root_id))
+		do_reset = 1;
+
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	if (do_reset) {
+		fw_notify("phy config: card %d, new root=%x, gap_count=%d\n",
+			  card->index, new_root_id, gap_count);
+		fw_send_phy_config(card, new_root_id, generation, gap_count);
+		fw_core_initiate_bus_reset(card, 1);
+	}
+}
+
+static void
+flush_timer_callback(unsigned long data)
+{
+	struct fw_card *card = (struct fw_card *)data;
+
+	fw_flush_transactions(card);
+}
+
+void
+fw_card_initialize(struct fw_card *card, const struct fw_card_driver *driver,
+		   struct device *device)
+{
+	static atomic_t index = ATOMIC_INIT(-1);
+
+	kref_init(&card->kref);
+	card->index = atomic_inc_return(&index);
+	card->driver = driver;
+	card->device = device;
+	card->current_tlabel = 0;
+	card->tlabel_mask = 0;
+	card->color = 0;
+
+	INIT_LIST_HEAD(&card->transaction_list);
+	spin_lock_init(&card->lock);
+	setup_timer(&card->flush_timer,
+		    flush_timer_callback, (unsigned long)card);
+
+	card->local_node = NULL;
+
+	INIT_DELAYED_WORK(&card->work, fw_card_bm_work);
+}
+EXPORT_SYMBOL(fw_card_initialize);
+
+int
+fw_card_add(struct fw_card *card,
+	    u32 max_receive, u32 link_speed, u64 guid)
+{
+	u32 *config_rom;
+	size_t length;
+
+	card->max_receive = max_receive;
+	card->link_speed = link_speed;
+	card->guid = guid;
+
+	/* Activate link_on bit and contender bit in our self ID packets.*/
+	if (card->driver->update_phy_reg(card, 4, 0,
+					 PHY_LINK_ACTIVE | PHY_CONTENDER) < 0)
+		return -EIO;
+
+	/* The subsystem grabs a reference when the card is added and
+	 * drops it when the driver calls fw_core_remove_card. */
+	fw_card_get(card);
+
+	down_write(&card_rwsem);
+	config_rom = generate_config_rom (card, &length);
+	list_add_tail(&card->link, &card_list);
+	up_write(&card_rwsem);
+
+	return card->driver->enable(card, config_rom, length);
+}
+EXPORT_SYMBOL(fw_card_add);
+
+
+/* The next few functions implements a dummy driver that use once a
+ * card driver shuts down an fw_card.  This allows the driver to
+ * cleanly unload, as all IO to the card will be handled by the dummy
+ * driver instead of calling into the (possibly) unloaded module.  The
+ * dummy driver just fails all IO. */
+
+static int
+dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
+{
+	BUG();
+	return -1;
+}
+
+static int
+dummy_update_phy_reg(struct fw_card *card, int address,
+		     int clear_bits, int set_bits)
+{
+	return -ENODEV;
+}
+
+static int
+dummy_set_config_rom(struct fw_card *card,
+		     u32 *config_rom, size_t length)
+{
+	/* We take the card out of card_list before setting the dummy
+	 * driver, so this should never get called. */
+	BUG();
+	return -1;
+}
+
+static void
+dummy_send_request(struct fw_card *card, struct fw_packet *packet)
+{
+	packet->callback(packet, card, -ENODEV);
+}
+
+static void
+dummy_send_response(struct fw_card *card, struct fw_packet *packet)
+{
+	packet->callback(packet, card, -ENODEV);
+}
+
+static int
+dummy_cancel_packet(struct fw_card *card, struct fw_packet *packet)
+{
+	return -ENOENT;
+}
+
+static int
+dummy_enable_phys_dma(struct fw_card *card,
+		      int node_id, int generation)
+{
+	return -ENODEV;
+}
+
+static struct fw_card_driver dummy_driver = {
+	.name            = "dummy",
+	.enable          = dummy_enable,
+	.update_phy_reg  = dummy_update_phy_reg,
+	.set_config_rom  = dummy_set_config_rom,
+	.send_request    = dummy_send_request,
+	.cancel_packet   = dummy_cancel_packet,
+	.send_response   = dummy_send_response,
+	.enable_phys_dma = dummy_enable_phys_dma,
+};
+
+void
+fw_core_remove_card(struct fw_card *card)
+{
+	card->driver->update_phy_reg(card, 4,
+				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
+	fw_core_initiate_bus_reset(card, 1);
+
+	down_write(&card_rwsem);
+	list_del(&card->link);
+	up_write(&card_rwsem);
+
+	/* Set up the dummy driver. */
+	card->driver = &dummy_driver;
+
+	fw_flush_transactions(card);
+
+	fw_destroy_nodes(card);
+
+	fw_card_put(card);
+}
+EXPORT_SYMBOL(fw_core_remove_card);
+
+struct fw_card *
+fw_card_get(struct fw_card *card)
+{
+	kref_get(&card->kref);
+
+	return card;
+}
+EXPORT_SYMBOL(fw_card_get);
+
+static void
+release_card(struct kref *kref)
+{
+	struct fw_card *card = container_of(kref, struct fw_card, kref);
+
+	kfree(card);
+}
+
+/* An assumption for fw_card_put() is that the card driver allocates
+ * the fw_card struct with kalloc and that it has been shut down
+ * before the last ref is dropped. */
+void
+fw_card_put(struct fw_card *card)
+{
+	kref_put(&card->kref, release_card);
+}
+EXPORT_SYMBOL(fw_card_put);
+
+int
+fw_core_initiate_bus_reset(struct fw_card *card, int short_reset)
+{
+	int reg = short_reset ? 5 : 1;
+	/* The following values happen to be the same bit. However be
+	 * explicit for clarity. */
+	int bit = short_reset ? PHY_BUS_SHORT_RESET : PHY_BUS_RESET;
+
+	return card->driver->update_phy_reg(card, reg, 0, bit);
+}
+EXPORT_SYMBOL(fw_core_initiate_bus_reset);
Index: linux_juju/drivers/firewire/fw-device.h
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-device.h
@@ -0,0 +1,149 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-device.h - Device probing and sysfs code.
+ *
+ * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __fw_device_h
+#define __fw_device_h
+
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <asm/atomic.h>
+
+enum fw_device_state {
+	FW_DEVICE_INITIALIZING,
+	FW_DEVICE_RUNNING,
+	FW_DEVICE_SHUTDOWN,
+};
+
+struct fw_attribute_group {
+	struct attribute_group *groups[2];
+	struct attribute_group group;
+	struct attribute *attrs[11];
+};
+
+struct fw_device {
+	atomic_t state;
+	struct fw_node *node;
+	int node_id;
+	int generation;
+	struct fw_card *card;
+	struct device device;
+	struct list_head link;
+	struct list_head client_list;
+	u32 *config_rom;
+	size_t config_rom_length;
+	int config_rom_retries;
+	struct delayed_work work;
+	struct fw_attribute_group attribute_group;
+};
+
+static inline struct fw_device *
+fw_device(struct device *dev)
+{
+	return container_of(dev, struct fw_device, device);
+}
+
+static inline int
+fw_device_is_shutdown(struct fw_device *device)
+{
+	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
+}
+
+struct fw_device *fw_device_get(struct fw_device *device);
+void fw_device_put(struct fw_device *device);
+int fw_device_enable_phys_dma(struct fw_device *device);
+
+void fw_device_cdev_update(struct fw_device *device);
+void fw_device_cdev_remove(struct fw_device *device);
+
+struct fw_device *fw_device_from_devt(dev_t devt);
+extern int fw_cdev_major;
+
+struct fw_unit {
+	struct device device;
+	u32 *directory;
+	struct fw_attribute_group attribute_group;
+};
+
+static inline struct fw_unit *
+fw_unit(struct device *dev)
+{
+	return container_of(dev, struct fw_unit, device);
+}
+
+#define CSR_OFFSET	0x40
+#define CSR_LEAF	0x80
+#define CSR_DIRECTORY	0xc0
+
+#define CSR_DESCRIPTOR		0x01
+#define CSR_VENDOR		0x03
+#define CSR_HARDWARE_VERSION	0x04
+#define CSR_NODE_CAPABILITIES	0x0c
+#define CSR_UNIT		0x11
+#define CSR_SPECIFIER_ID	0x12
+#define CSR_VERSION		0x13
+#define CSR_DEPENDENT_INFO	0x14
+#define CSR_MODEL		0x17
+#define CSR_INSTANCE		0x18
+
+#define SBP2_COMMAND_SET_SPECIFIER	0x38
+#define SBP2_COMMAND_SET		0x39
+#define SBP2_COMMAND_SET_REVISION	0x3b
+#define SBP2_FIRMWARE_REVISION		0x3c
+
+struct fw_csr_iterator {
+	u32 *p;
+	u32 *end;
+};
+
+void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
+int fw_csr_iterator_next(struct fw_csr_iterator *ci,
+			 int *key, int *value);
+
+#define FW_MATCH_VENDOR		0x0001
+#define FW_MATCH_MODEL		0x0002
+#define FW_MATCH_SPECIFIER_ID	0x0004
+#define FW_MATCH_VERSION	0x0008
+
+struct fw_device_id {
+	u32 match_flags;
+	u32 vendor;
+	u32 model;
+	u32 specifier_id;
+	u32 version;
+	void *driver_data;
+};
+
+struct fw_driver {
+	struct device_driver driver;
+	/* Called when the parent device sits through a bus reset. */
+	void (*update) (struct fw_unit *unit);
+	const struct fw_device_id *id_table;
+};
+
+static inline struct fw_driver *
+fw_driver(struct device_driver *drv)
+{
+	return container_of(drv, struct fw_driver, driver);
+}
+
+extern const struct file_operations fw_device_ops;
+
+#endif /* __fw_device_h */
Index: linux_juju/drivers/firewire/fw-device.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-device.c
@@ -0,0 +1,782 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-device.c - Device probing and sysfs code.
+ *
+ * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/errno.h>
+#include <linux/kthread.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/idr.h>
+#include <linux/rwsem.h>
+#include <asm/semaphore.h>
+#include <linux/ctype.h>
+#include "fw-transaction.h"
+#include "fw-topology.h"
+#include "fw-device.h"
+
+void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 * p)
+{
+	ci->p = p + 1;
+	ci->end = ci->p + (p[0] >> 16);
+}
+EXPORT_SYMBOL(fw_csr_iterator_init);
+
+int fw_csr_iterator_next(struct fw_csr_iterator *ci, int *key, int *value)
+{
+	*key = *ci->p >> 24;
+	*value = *ci->p & 0xffffff;
+
+	return ci->p++ < ci->end;
+}
+EXPORT_SYMBOL(fw_csr_iterator_next);
+
+static int is_fw_unit(struct device *dev);
+
+static int match_unit_directory(u32 * directory, const struct fw_device_id *id)
+{
+	struct fw_csr_iterator ci;
+	int key, value, match;
+
+	match = 0;
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (key == CSR_VENDOR && value == id->vendor)
+			match |= FW_MATCH_VENDOR;
+		if (key == CSR_MODEL && value == id->model)
+			match |= FW_MATCH_MODEL;
+		if (key == CSR_SPECIFIER_ID && value == id->specifier_id)
+			match |= FW_MATCH_SPECIFIER_ID;
+		if (key == CSR_VERSION && value == id->version)
+			match |= FW_MATCH_VERSION;
+	}
+
+	return (match & id->match_flags) == id->match_flags;
+}
+
+static int fw_unit_match(struct device *dev, struct device_driver *drv)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_driver *driver = fw_driver(drv);
+	int i;
+
+	/* We only allow binding to fw_units. */
+	if (!is_fw_unit(dev))
+		return 0;
+
+	for (i = 0; driver->id_table[i].match_flags != 0; i++) {
+		if (match_unit_directory(unit->directory, &driver->id_table[i]))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
+{
+	struct fw_device *device = fw_device(unit->device.parent);
+	struct fw_csr_iterator ci;
+
+	int key, value;
+	int vendor = 0;
+	int model = 0;
+	int specifier_id = 0;
+	int version = 0;
+
+	fw_csr_iterator_init(&ci, &device->config_rom[5]);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		switch (key) {
+		case CSR_VENDOR:
+			vendor = value;
+			break;
+		case CSR_MODEL:
+			model = value;
+			break;
+		}
+	}
+
+	fw_csr_iterator_init(&ci, unit->directory);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		switch (key) {
+		case CSR_SPECIFIER_ID:
+			specifier_id = value;
+			break;
+		case CSR_VERSION:
+			version = value;
+			break;
+		}
+	}
+
+	return snprintf(buffer, buffer_size,
+			"ieee1394:ven%08Xmo%08Xsp%08Xver%08X",
+			vendor, model, specifier_id, version);
+}
+
+static int
+fw_unit_uevent(struct device *dev, char **envp, int num_envp,
+	       char *buffer, int buffer_size)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	char modalias[64];
+	int length = 0;
+	int i = 0;
+
+	get_modalias(unit, modalias, sizeof modalias);
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "MODALIAS=%s", modalias))
+		return -ENOMEM;
+
+	envp[i] = NULL;
+
+	return 0;
+}
+
+struct bus_type fw_bus_type = {
+	.name = "firewire",
+	.match = fw_unit_match,
+};
+EXPORT_SYMBOL(fw_bus_type);
+
+struct fw_device *fw_device_get(struct fw_device *device)
+{
+	get_device(&device->device);
+
+	return device;
+}
+
+void fw_device_put(struct fw_device *device)
+{
+	put_device(&device->device);
+}
+
+static void fw_device_release(struct device *dev)
+{
+	struct fw_device *device = fw_device(dev);
+	unsigned long flags;
+
+	/* Take the card lock so we don't set this to NULL while a
+	 * FW_NODE_UPDATED callback is being handled. */
+	spin_lock_irqsave(&device->card->lock, flags);
+	device->node->data = NULL;
+	spin_unlock_irqrestore(&device->card->lock, flags);
+
+	fw_node_put(device->node);
+	fw_card_put(device->card);
+	kfree(device->config_rom);
+	kfree(device);
+}
+
+int fw_device_enable_phys_dma(struct fw_device *device)
+{
+	return device->card->driver->enable_phys_dma(device->card,
+						     device->node_id,
+						     device->generation);
+}
+EXPORT_SYMBOL(fw_device_enable_phys_dma);
+
+struct config_rom_attribute {
+	struct device_attribute attr;
+	u32 key;
+};
+
+static ssize_t
+show_immediate(struct device *dev, struct device_attribute *dattr, char *buf)
+{
+	struct config_rom_attribute *attr =
+		container_of(dattr, struct config_rom_attribute, attr);
+	struct fw_csr_iterator ci;
+	u32 *dir;
+	int key, value;
+
+	if (is_fw_unit(dev))
+		dir = fw_unit(dev)->directory;
+	else
+		dir = fw_device(dev)->config_rom + 5;
+
+	fw_csr_iterator_init(&ci, dir);
+	while (fw_csr_iterator_next(&ci, &key, &value))
+		if (attr->key == key)
+			return snprintf(buf, buf ? PAGE_SIZE : 0,
+					"0x%06x\n", value);
+
+	return -ENOENT;
+}
+
+#define IMMEDIATE_ATTR(name, key)				\
+	{ __ATTR(name, S_IRUGO, show_immediate, NULL), key }
+
+static ssize_t
+show_text_leaf(struct device *dev, struct device_attribute *dattr, char *buf)
+{
+	struct config_rom_attribute *attr =
+		container_of(dattr, struct config_rom_attribute, attr);
+	struct fw_csr_iterator ci;
+	u32 *dir, *block = NULL, *p, *end;
+	int length, key, value, last_key = 0;
+	char *b;
+
+	if (is_fw_unit(dev))
+		dir = fw_unit(dev)->directory;
+	else
+		dir = fw_device(dev)->config_rom + 5;
+
+	fw_csr_iterator_init(&ci, dir);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (attr->key == last_key &&
+		    key == (CSR_DESCRIPTOR | CSR_LEAF))
+			block = ci.p - 1 + value;
+		last_key = key;
+	}
+
+	if (block == NULL)
+		return -ENOENT;
+
+	length = min(block[0] >> 16, 256U);
+	if (length < 3)
+		return -ENOENT;
+
+	if (block[1] != 0 || block[2] != 0)
+		/* Unknown encoding. */
+		return -ENOENT;
+
+	if (buf == NULL)
+		return length * 4;
+
+	b = buf;
+	end = &block[length + 1];
+	for (p = &block[3]; p < end; p++, b += 4)
+		* (u32 *) b = (__force u32) __cpu_to_be32(*p);
+
+	/* Strip trailing whitespace and add newline. */
+	while (b--, (isspace(*b) || *b == '\0') && b > buf);
+	strcpy(b + 1, "\n");
+
+	return b + 2 - buf;
+}
+
+#define TEXT_LEAF_ATTR(name, key)				\
+	{ __ATTR(name, S_IRUGO, show_text_leaf, NULL), key }
+
+static struct config_rom_attribute config_rom_attributes[] = {
+	IMMEDIATE_ATTR(vendor, CSR_VENDOR),
+	IMMEDIATE_ATTR(hardware_version, CSR_HARDWARE_VERSION),
+	IMMEDIATE_ATTR(specifier_id, CSR_SPECIFIER_ID),
+	IMMEDIATE_ATTR(version, CSR_VERSION),
+	IMMEDIATE_ATTR(model, CSR_MODEL),
+	TEXT_LEAF_ATTR(vendor_name, CSR_VENDOR),
+	TEXT_LEAF_ATTR(model_name, CSR_MODEL),
+	TEXT_LEAF_ATTR(hardware_version_name, CSR_HARDWARE_VERSION),
+};
+
+static void
+init_fw_attribute_group(struct device *dev,
+			struct device_attribute *attrs,
+			struct fw_attribute_group *group)
+{
+	struct device_attribute *attr;
+	int i, j;
+
+	for (j = 0; attrs[j].attr.name != NULL; j++)
+		group->attrs[j] = &attrs[j].attr;
+
+	for (i = 0; i < ARRAY_SIZE(config_rom_attributes); i++) {
+		attr = &config_rom_attributes[i].attr;
+		if (attr->show(dev, attr, NULL) < 0)
+			continue;
+		group->attrs[j++] = &attr->attr;
+	}
+
+	BUG_ON(j >= ARRAY_SIZE(group->attrs));
+	group->attrs[j++] = NULL;
+	group->groups[0] = &group->group;
+	group->groups[1] = NULL;
+	group->group.attrs = group->attrs;
+	dev->groups = group->groups;
+}
+
+static ssize_t
+modalias_show(struct device *dev,
+	      struct device_attribute *attr, char *buf)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	int length;
+
+	length = get_modalias(unit, buf, PAGE_SIZE);
+	strcpy(buf + length, "\n");
+
+	return length + 1;
+}
+
+static ssize_t
+rom_index_show(struct device *dev,
+	       struct device_attribute *attr, char *buf)
+{
+	struct fw_device *device = fw_device(dev->parent);
+	struct fw_unit *unit = fw_unit(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			(int)(unit->directory - device->config_rom));
+}
+
+static struct device_attribute fw_unit_attributes[] = {
+	__ATTR_RO(modalias),
+	__ATTR_RO(rom_index),
+	__ATTR_NULL,
+};
+
+static ssize_t
+config_rom_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct fw_device *device = fw_device(dev);
+
+	memcpy(buf, device->config_rom, device->config_rom_length * 4);
+
+	return device->config_rom_length * 4;
+}
+
+static ssize_t
+guid_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct fw_device *device = fw_device(dev);
+	u64 guid;
+
+	guid = ((u64)device->config_rom[3] << 32) | device->config_rom[4];
+
+	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
+			(unsigned long long)guid);
+}
+
+static struct device_attribute fw_device_attributes[] = {
+	__ATTR_RO(config_rom),
+	__ATTR_RO(guid),
+	__ATTR_NULL,
+};
+
+struct read_quadlet_callback_data {
+	struct completion done;
+	int rcode;
+	u32 data;
+};
+
+static void
+complete_transaction(struct fw_card *card, int rcode,
+		     void *payload, size_t length, void *data)
+{
+	struct read_quadlet_callback_data *callback_data = data;
+
+	if (rcode == RCODE_COMPLETE)
+		callback_data->data = be32_to_cpu(*(__be32 *)payload);
+	callback_data->rcode = rcode;
+	complete(&callback_data->done);
+}
+
+static int read_rom(struct fw_device *device, int index, u32 * data)
+{
+	struct read_quadlet_callback_data callback_data;
+	struct fw_transaction t;
+	u64 offset;
+
+	init_completion(&callback_data.done);
+
+	offset = 0xfffff0000400ULL + index * 4;
+	fw_send_request(device->card, &t, TCODE_READ_QUADLET_REQUEST,
+			device->node_id,
+			device->generation, SCODE_100,
+			offset, NULL, 4, complete_transaction, &callback_data);
+
+	wait_for_completion(&callback_data.done);
+
+	*data = callback_data.data;
+
+	return callback_data.rcode;
+}
+
+static int read_bus_info_block(struct fw_device *device)
+{
+	static u32 rom[256];
+	u32 stack[16], sp, key;
+	int i, end, length;
+
+	/* First read the bus info block. */
+	for (i = 0; i < 5; i++) {
+		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+			return -1;
+		/* As per IEEE1212 7.2, during power-up, devices can
+		 * reply with a 0 for the first quadlet of the config
+		 * rom to indicate that they are booting (for example,
+		 * if the firmware is on the disk of a external
+		 * harddisk).  In that case we just fail, and the
+		 * retry mechanism will try again later. */
+		if (i == 0 && rom[i] == 0)
+			return -1;
+	}
+
+	/* Now parse the config rom.  The config rom is a recursive
+	 * directory structure so we parse it using a stack of
+	 * references to the blocks that make up the structure.  We
+	 * push a reference to the root directory on the stack to
+	 * start things off. */
+	length = i;
+	sp = 0;
+	stack[sp++] = 0xc0000005;
+	while (sp > 0) {
+		/* Pop the next block reference of the stack.  The
+		 * lower 24 bits is the offset into the config rom,
+		 * the upper 8 bits are the type of the reference the
+		 * block. */
+		key = stack[--sp];
+		i = key & 0xffffff;
+		if (i >= ARRAY_SIZE(rom))
+			/* The reference points outside the standard
+			 * config rom area, something's fishy. */
+			return -1;
+
+		/* Read header quadlet for the block to get the length. */
+		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+			return -1;
+		end = i + (rom[i] >> 16) + 1;
+		i++;
+		if (end > ARRAY_SIZE(rom))
+			/* This block extends outside standard config
+			 * area (and the array we're reading it
+			 * into).  That's broken, so ignore this
+			 * device. */
+			return -1;
+
+		/* Now read in the block.  If this is a directory
+		 * block, check the entries as we read them to see if
+		 * it references another block, and push it in that case. */
+		while (i < end) {
+			if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+				return -1;
+			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
+			    sp < ARRAY_SIZE(stack))
+				stack[sp++] = i + rom[i];
+			i++;
+		}
+		if (length < i)
+			length = i;
+	}
+
+	device->config_rom = kmalloc(length * 4, GFP_KERNEL);
+	if (device->config_rom == NULL)
+		return -1;
+	memcpy(device->config_rom, rom, length * 4);
+	device->config_rom_length = length;
+
+	return 0;
+}
+
+static void fw_unit_release(struct device *dev)
+{
+	struct fw_unit *unit = fw_unit(dev);
+
+	kfree(unit);
+}
+
+static struct device_type fw_unit_type = {
+	.uevent		= fw_unit_uevent,
+	.release	= fw_unit_release,
+};
+
+static int is_fw_unit(struct device *dev)
+{
+	return dev->type == &fw_unit_type;
+}
+
+static void create_units(struct fw_device *device)
+{
+	struct fw_csr_iterator ci;
+	struct fw_unit *unit;
+	int key, value, i;
+
+	i = 0;
+	fw_csr_iterator_init(&ci, &device->config_rom[5]);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (key != (CSR_UNIT | CSR_DIRECTORY))
+			continue;
+
+		/* Get the address of the unit directory and try to
+		 * match the drivers id_tables against it. */
+		unit = kzalloc(sizeof *unit, GFP_KERNEL);
+		if (unit == NULL) {
+			fw_error("failed to allocate memory for unit\n");
+			continue;
+		}
+
+		unit->directory = ci.p + value - 1;
+		unit->device.bus = &fw_bus_type;
+		unit->device.type = &fw_unit_type;
+		unit->device.parent = &device->device;
+		snprintf(unit->device.bus_id, sizeof unit->device.bus_id,
+			 "%s.%d", device->device.bus_id, i++);
+
+		init_fw_attribute_group(&unit->device,
+					fw_unit_attributes,
+					&unit->attribute_group);
+		if (device_register(&unit->device) < 0)
+			goto skip_unit;
+
+		continue;
+
+	skip_unit:
+		kfree(unit);
+	}
+}
+
+static int shutdown_unit(struct device *device, void *data)
+{
+	device_unregister(device);
+
+	return 0;
+}
+
+static DECLARE_RWSEM(idr_rwsem);
+static DEFINE_IDR(fw_device_idr);
+int fw_cdev_major;
+
+struct fw_device *fw_device_from_devt(dev_t devt)
+{
+	struct fw_device *device;
+
+	down_read(&idr_rwsem);
+	device = idr_find(&fw_device_idr, MINOR(devt));
+	up_read(&idr_rwsem);
+
+	return device;
+}
+
+static void fw_device_shutdown(struct work_struct *work)
+{
+	struct fw_device *device =
+		container_of(work, struct fw_device, work.work);
+	int minor = MINOR(device->device.devt);
+
+	down_write(&idr_rwsem);
+	idr_remove(&fw_device_idr, minor);
+	up_write(&idr_rwsem);
+
+	fw_device_cdev_remove(device);
+	device_for_each_child(&device->device, NULL, shutdown_unit);
+	device_unregister(&device->device);
+}
+
+static struct device_type fw_device_type = {
+	.release	= fw_device_release,
+};
+
+/* These defines control the retry behavior for reading the config
+ * rom.  It shouldn't be necessary to tweak these; if the device
+ * doesn't respond to a config rom read within 10 seconds, it's not
+ * going to respond at all.  As for the initial delay, a lot of
+ * devices will be able to respond within half a second after bus
+ * reset.  On the other hand, it's not really worth being more
+ * aggressive than that, since it scales pretty well; if 10 devices
+ * are plugged in, they're all getting read within one second. */
+
+#define MAX_RETRIES	10
+#define RETRY_DELAY	(3 * HZ)
+#define INITIAL_DELAY	(HZ / 2)
+
+static void fw_device_init(struct work_struct *work)
+{
+	struct fw_device *device =
+		container_of(work, struct fw_device, work.work);
+	int minor, err;
+
+	/* All failure paths here set node->data to NULL, so that we
+	 * don't try to do device_for_each_child() on a kfree()'d
+	 * device. */
+
+	if (read_bus_info_block(device) < 0) {
+		if (device->config_rom_retries < MAX_RETRIES) {
+			device->config_rom_retries++;
+			schedule_delayed_work(&device->work, RETRY_DELAY);
+		} else {
+			fw_notify("giving up on config rom for node id %x\n",
+				  device->node_id);
+			if (device->node == device->card->root_node)
+				schedule_delayed_work(&device->card->work, 0);
+			fw_device_release(&device->device);
+		}
+		return;
+	}
+
+	err = -ENOMEM;
+	down_write(&idr_rwsem);
+	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
+		err = idr_get_new(&fw_device_idr, device, &minor);
+	up_write(&idr_rwsem);
+	if (err < 0)
+		goto error;
+
+	device->device.bus = &fw_bus_type;
+	device->device.type = &fw_device_type;
+	device->device.parent = device->card->device;
+	device->device.devt = MKDEV(fw_cdev_major, minor);
+	snprintf(device->device.bus_id, sizeof device->device.bus_id,
+		 "fw%d", minor);
+
+	init_fw_attribute_group(&device->device,
+				fw_device_attributes,
+				&device->attribute_group);
+	if (device_add(&device->device)) {
+		fw_error("Failed to add device.\n");
+		goto error_with_cdev;
+	}
+
+	create_units(device);
+
+	/* Transition the device to running state.  If it got pulled
+	 * out from under us while we did the intialization work, we
+	 * have to shut down the device again here.  Normally, though,
+	 * fw_node_event will be responsible for shutting it down when
+	 * necessary.  We have to use the atomic cmpxchg here to avoid
+	 * racing with the FW_NODE_DESTROYED case in
+	 * fw_node_event(). */
+	if (atomic_cmpxchg(&device->state,
+		    FW_DEVICE_INITIALIZING,
+		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+		fw_device_shutdown(&device->work.work);
+	else
+		fw_notify("created new fw device %s (%d config rom retries)\n",
+			  device->device.bus_id, device->config_rom_retries);
+
+	/* Reschedule the IRM work if we just finished reading the
+	 * root node config rom.  If this races with a bus reset we
+	 * just end up running the IRM work a couple of extra times -
+	 * pretty harmless. */
+	if (device->node == device->card->root_node)
+		schedule_delayed_work(&device->card->work, 0);
+
+	return;
+
+ error_with_cdev:
+	down_write(&idr_rwsem);
+	idr_remove(&fw_device_idr, minor);
+	up_write(&idr_rwsem);
+ error:
+	put_device(&device->device);
+}
+
+static int update_unit(struct device *dev, void *data)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_driver *driver = (struct fw_driver *)dev->driver;
+
+	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
+		down(&dev->sem);
+		driver->update(unit);
+		up(&dev->sem);
+	}
+
+	return 0;
+}
+
+static void fw_device_update(struct work_struct *work)
+{
+	struct fw_device *device =
+		container_of(work, struct fw_device, work.work);
+
+	fw_device_cdev_update(device);
+	device_for_each_child(&device->device, NULL, update_unit);
+}
+
+void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
+{
+	struct fw_device *device;
+
+	switch (event) {
+	case FW_NODE_CREATED:
+	case FW_NODE_LINK_ON:
+		if (!node->link_on)
+			break;
+
+		device = kzalloc(sizeof(*device), GFP_ATOMIC);
+		if (device == NULL)
+			break;
+
+		/* Do minimal intialization of the device here, the
+		 * rest will happen in fw_device_init().  We need the
+		 * card and node so we can read the config rom and we
+		 * need to do device_initialize() now so
+		 * device_for_each_child() in FW_NODE_UPDATED is
+		 * doesn't freak out. */
+		device_initialize(&device->device);
+		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
+		device->card = fw_card_get(card);
+		device->node = fw_node_get(node);
+		device->node_id = node->node_id;
+		device->generation = card->generation;
+		INIT_LIST_HEAD(&device->client_list);
+
+		/* Set the node data to point back to this device so
+		 * FW_NODE_UPDATED callbacks can update the node_id
+		 * and generation for the device. */
+		node->data = device;
+
+		/* Many devices are slow to respond after bus resets,
+		 * especially if they are bus powered and go through
+		 * power-up after getting plugged in.  We schedule the
+		 * first config rom scan half a second after bus reset. */
+		INIT_DELAYED_WORK(&device->work, fw_device_init);
+		schedule_delayed_work(&device->work, INITIAL_DELAY);
+		break;
+
+	case FW_NODE_UPDATED:
+		if (!node->link_on || node->data == NULL)
+			break;
+
+		device = node->data;
+		device->node_id = node->node_id;
+		device->generation = card->generation;
+		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
+			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
+			schedule_delayed_work(&device->work, 0);
+		}
+		break;
+
+	case FW_NODE_DESTROYED:
+	case FW_NODE_LINK_OFF:
+		if (!node->data)
+			break;
+
+		/* Destroy the device associated with the node.  There
+		 * are two cases here: either the device is fully
+		 * initialized (FW_DEVICE_RUNNING) or we're in the
+		 * process of reading its config rom
+		 * (FW_DEVICE_INITIALIZING).  If it is fully
+		 * initialized we can reuse device->work to schedule a
+		 * full fw_device_shutdown().  If not, there's work
+		 * scheduled to read it's config rom, and we just put
+		 * the device in shutdown state to have that code fail
+		 * to create the device. */
+		device = node->data;
+		if (atomic_xchg(&device->state,
+				FW_DEVICE_SHUTDOWN) == FW_DEVICE_RUNNING) {
+			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+			schedule_delayed_work(&device->work, 0);
+		}
+		break;
+	}
+}
Index: linux_juju/drivers/firewire/fw-topology.h
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-topology.h
@@ -0,0 +1,94 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-topology.h -- Incremental bus scan, based on bus topology
+ *
+ * Copyright (C) 2003-2006 Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __fw_topology_h
+#define __fw_topology_h
+
+enum {
+	FW_TOPOLOGY_A =		0x01,
+	FW_TOPOLOGY_B =		0x02,
+	FW_TOPOLOGY_MIXED =	0x03,
+};
+
+enum {
+	FW_NODE_CREATED =   0x00,
+	FW_NODE_UPDATED =   0x01,
+	FW_NODE_DESTROYED = 0x02,
+	FW_NODE_LINK_ON =   0x03,
+	FW_NODE_LINK_OFF =  0x04,
+};
+
+struct fw_port {
+	struct fw_node *node;
+	unsigned speed : 3; /* S100, S200, ... S3200 */
+};
+
+struct fw_node {
+	u16 node_id;
+	u8 color;
+	u8 port_count;
+	unsigned link_on : 1;
+	unsigned initiated_reset : 1;
+	unsigned b_path : 1;
+	u8 phy_speed : 3; /* As in the self ID packet. */
+	u8 max_speed : 5; /* Minimum of all phy-speeds and port speeds on
+			   * the path from the local node to this node. */
+	u8 max_depth : 4; /* Maximum depth to any leaf node */
+	u8 max_hops : 4;  /* Max hops in this sub tree */
+	atomic_t ref_count;
+
+	/* For serializing node topology into a list. */
+	struct list_head link;
+
+	/* Upper layer specific data. */
+	void *data;
+
+	struct fw_port ports[0];
+};
+
+static inline struct fw_node *
+fw_node(struct list_head *l)
+{
+	return list_entry (l, struct fw_node, link);
+}
+
+static inline struct fw_node *
+fw_node_get(struct fw_node *node)
+{
+	atomic_inc(&node->ref_count);
+
+	return node;
+}
+
+static inline void
+fw_node_put(struct fw_node *node)
+{
+	if (atomic_dec_and_test(&node->ref_count))
+		kfree(node);
+}
+
+void
+fw_destroy_nodes(struct fw_card *card);
+
+u16
+crc16_itu_t(const u32 *buffer, size_t length);
+
+#endif /* __fw_topology_h */
Index: linux_juju/drivers/firewire/fw-topology.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-topology.c
@@ -0,0 +1,519 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-topology.c - Incremental bus scan, based on bus topology
+ *
+ * Copyright (C) 2004-2006 Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/errno.h>
+#include "fw-transaction.h"
+#include "fw-topology.h"
+
+#define self_id_phy_id(q)		(((q) >> 24) & 0x3f)
+#define self_id_extended(q)		(((q) >> 23) & 0x01)
+#define self_id_link_on(q)		(((q) >> 22) & 0x01)
+#define self_id_gap_count(q)		(((q) >> 16) & 0x3f)
+#define self_id_phy_speed(q)		(((q) >> 14) & 0x03)
+#define self_id_contender(q)		(((q) >> 11) & 0x01)
+#define self_id_phy_initiator(q)	(((q) >>  1) & 0x01)
+#define self_id_more_packets(q)		(((q) >>  0) & 0x01)
+
+#define self_id_ext_sequence(q)		(((q) >> 20) & 0x07)
+
+static u32 *count_ports(u32 *sid, int *total_port_count, int *child_port_count)
+{
+	u32 q;
+	int port_type, shift, seq;
+
+	*total_port_count = 0;
+	*child_port_count = 0;
+
+	shift = 6;
+	q = *sid;
+	seq = 0;
+
+	while (1) {
+		port_type = (q >> shift) & 0x03;
+		switch (port_type) {
+		case SELFID_PORT_CHILD:
+			(*child_port_count)++;
+		case SELFID_PORT_PARENT:
+		case SELFID_PORT_NCONN:
+			(*total_port_count)++;
+		case SELFID_PORT_NONE:
+			break;
+		}
+
+		shift -= 2;
+		if (shift == 0) {
+			if (!self_id_more_packets(q))
+				return sid + 1;
+
+			shift = 16;
+			sid++;
+			q = *sid;
+
+			/* Check that the extra packets actually are
+			 * extended self ID packets and that the
+			 * sequence numbers in the extended self ID
+			 * packets increase as expected. */
+
+			if (!self_id_extended(q) ||
+			    seq != self_id_ext_sequence(q))
+				return NULL;
+
+			seq++;
+		}
+	}
+}
+
+static int get_port_type(u32 *sid, int port_index)
+{
+	int index, shift;
+
+	index = (port_index + 5) / 8;
+	shift = 16 - ((port_index + 5) & 7) * 2;
+	return (sid[index] >> shift) & 0x03;
+}
+
+static struct fw_node *fw_node_create(u32 sid, int port_count, int color)
+{
+	struct fw_node *node;
+
+	node = kzalloc(sizeof *node + port_count * sizeof node->ports[0],
+		       GFP_ATOMIC);
+	if (node == NULL)
+		return NULL;
+
+	node->color = color;
+	node->node_id = LOCAL_BUS | self_id_phy_id(sid);
+	node->link_on = self_id_link_on(sid);
+	node->phy_speed = self_id_phy_speed(sid);
+	node->port_count = port_count;
+
+	atomic_set(&node->ref_count, 1);
+	INIT_LIST_HEAD(&node->link);
+
+	return node;
+}
+
+/* Compute the maximum hop count for this node and it's children.  The
+ * maximum hop count is the maximum number of connections between any
+ * two nodes in the subtree rooted at this node.  We need this for
+ * setting the gap count.  As we build the tree bottom up in
+ * build_tree() below, this is fairly easy to do: for each node we
+ * maintain the max hop count and the max depth, ie the number of hops
+ * to the furthest leaf.  Computing the max hop count breaks down into
+ * two cases: either the path goes through this node, in which case
+ * the hop count is the sum of the two biggest child depths plus 2.
+ * Or it could be the case that the max hop path is entirely
+ * containted in a child tree, in which case the max hop count is just
+ * the max hop count of this child.
+ */
+static void update_hop_count(struct fw_node *node)
+{
+	int depths[2] = { -1, -1 };
+	int max_child_hops = 0;
+	int i;
+
+	for (i = 0; i < node->port_count; i++) {
+		if (node->ports[i].node == NULL)
+			continue;
+
+		if (node->ports[i].node->max_hops > max_child_hops)
+			max_child_hops = node->ports[i].node->max_hops;
+
+		if (node->ports[i].node->max_depth > depths[0]) {
+			depths[1] = depths[0];
+			depths[0] = node->ports[i].node->max_depth;
+		} else if (node->ports[i].node->max_depth > depths[1])
+			depths[1] = node->ports[i].node->max_depth;
+	}
+
+	node->max_depth = depths[0] + 1;
+	node->max_hops = max(max_child_hops, depths[0] + depths[1] + 2);
+}
+
+
+/**
+ * build_tree - Build the tree representation of the topology
+ * @self_ids: array of self IDs to create the tree from
+ * @self_id_count: the length of the self_ids array
+ * @local_id: the node ID of the local node
+ *
+ * This function builds the tree representation of the topology given
+ * by the self IDs from the latest bus reset.  During the construction
+ * of the tree, the function checks that the self IDs are valid and
+ * internally consistent.  On succcess this funtions returns the
+ * fw_node corresponding to the local card otherwise NULL.
+ */
+static struct fw_node *build_tree(struct fw_card *card,
+				  u32 *sid, int self_id_count)
+{
+	struct fw_node *node, *child, *local_node, *irm_node;
+	struct list_head stack, *h;
+	u32 *next_sid, *end, q;
+	int i, port_count, child_port_count, phy_id, parent_count, stack_depth;
+	int gap_count, topology_type;
+
+	local_node = NULL;
+	node = NULL;
+	INIT_LIST_HEAD(&stack);
+	stack_depth = 0;
+	end = sid + self_id_count;
+	phy_id = 0;
+	irm_node = NULL;
+	gap_count = self_id_gap_count(*sid);
+	topology_type = 0;
+
+	while (sid < end) {
+		next_sid = count_ports(sid, &port_count, &child_port_count);
+
+		if (next_sid == NULL) {
+			fw_error("Inconsistent extended self IDs.\n");
+			return NULL;
+		}
+
+		q = *sid;
+		if (phy_id != self_id_phy_id(q)) {
+			fw_error("PHY ID mismatch in self ID: %d != %d.\n",
+				 phy_id, self_id_phy_id(q));
+			return NULL;
+		}
+
+		if (child_port_count > stack_depth) {
+			fw_error("Topology stack underflow\n");
+			return NULL;
+		}
+
+		/* Seek back from the top of our stack to find the
+		 * start of the child nodes for this node. */
+		for (i = 0, h = &stack; i < child_port_count; i++)
+			h = h->prev;
+		child = fw_node(h);
+
+		node = fw_node_create(q, port_count, card->color);
+		if (node == NULL) {
+			fw_error("Out of memory while building topology.");
+			return NULL;
+		}
+
+		if (phy_id == (card->node_id & 0x3f))
+			local_node = node;
+
+		if (self_id_contender(q))
+			irm_node = node;
+
+		if (node->phy_speed == SCODE_BETA)
+			topology_type |= FW_TOPOLOGY_B;
+		else
+			topology_type |= FW_TOPOLOGY_A;
+
+		parent_count = 0;
+
+		for (i = 0; i < port_count; i++) {
+			switch (get_port_type(sid, i)) {
+			case SELFID_PORT_PARENT:
+				/* Who's your daddy?  We dont know the
+				 * parent node at this time, so we
+				 * temporarily abuse node->color for
+				 * remembering the entry in the
+				 * node->ports array where the parent
+				 * node should be.  Later, when we
+				 * handle the parent node, we fix up
+				 * the reference.
+				 */
+				parent_count++;
+				node->color = i;
+				break;
+
+			case SELFID_PORT_CHILD:
+				node->ports[i].node = child;
+				/* Fix up parent reference for this
+				 * child node. */
+				child->ports[child->color].node = node;
+				child->color = card->color;
+				child = fw_node(child->link.next);
+				break;
+			}
+		}
+
+		/* Check that the node reports exactly one parent
+		 * port, except for the root, which of course should
+		 * have no parents. */
+		if ((next_sid == end && parent_count != 0) ||
+		    (next_sid < end && parent_count != 1)) {
+			fw_error("Parent port inconsistency for node %d: "
+				 "parent_count=%d\n", phy_id, parent_count);
+			return NULL;
+		}
+
+		/* Pop the child nodes off the stack and push the new node. */
+		__list_del(h->prev, &stack);
+		list_add_tail(&node->link, &stack);
+		stack_depth += 1 - child_port_count;
+
+		/* If all PHYs does not report the same gap count
+		 * setting, we fall back to 63 which will force a gap
+		 * count reconfiguration and a reset. */
+		if (self_id_gap_count(q) != gap_count)
+			gap_count = 63;
+
+		update_hop_count(node);
+
+		sid = next_sid;
+		phy_id++;
+	}
+
+	card->root_node = node;
+	card->irm_node = irm_node;
+	card->gap_count = gap_count;
+	card->topology_type = topology_type;
+
+	return local_node;
+}
+
+typedef void (*fw_node_callback_t) (struct fw_card * card,
+				    struct fw_node * node,
+				    struct fw_node * parent);
+
+static void
+for_each_fw_node(struct fw_card *card, struct fw_node *root,
+		 fw_node_callback_t callback)
+{
+	struct list_head list;
+	struct fw_node *node, *next, *child, *parent;
+	int i;
+
+	INIT_LIST_HEAD(&list);
+
+	fw_node_get(root);
+	list_add_tail(&root->link, &list);
+	parent = NULL;
+	list_for_each_entry(node, &list, link) {
+		node->color = card->color;
+
+		for (i = 0; i < node->port_count; i++) {
+			child = node->ports[i].node;
+			if (!child)
+				continue;
+			if (child->color == card->color)
+				parent = child;
+			else {
+				fw_node_get(child);
+				list_add_tail(&child->link, &list);
+			}
+		}
+
+		callback(card, node, parent);
+	}
+
+	list_for_each_entry_safe(node, next, &list, link)
+		fw_node_put(node);
+}
+
+static void
+report_lost_node(struct fw_card *card,
+		 struct fw_node *node, struct fw_node *parent)
+{
+	fw_node_event(card, node, FW_NODE_DESTROYED);
+	fw_node_put(node);
+}
+
+static void
+report_found_node(struct fw_card *card,
+		  struct fw_node *node, struct fw_node *parent)
+{
+	int b_path = (node->phy_speed == SCODE_BETA);
+
+	if (parent != NULL) {
+		/* min() macro doesn't work here with gcc 3.4 */
+		node->max_speed = parent->max_speed < node->phy_speed ?
+					parent->max_speed : node->phy_speed;
+		node->b_path = parent->b_path && b_path;
+	} else {
+		node->max_speed = node->phy_speed;
+		node->b_path = b_path;
+	}
+
+	fw_node_event(card, node, FW_NODE_CREATED);
+}
+
+void fw_destroy_nodes(struct fw_card *card)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+	card->color++;
+	if (card->local_node != NULL)
+		for_each_fw_node(card, card->local_node, report_lost_node);
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
+static void move_tree(struct fw_node *node0, struct fw_node *node1, int port)
+{
+	struct fw_node *tree;
+	int i;
+
+	tree = node1->ports[port].node;
+	node0->ports[port].node = tree;
+	for (i = 0; i < tree->port_count; i++) {
+		if (tree->ports[i].node == node1) {
+			tree->ports[i].node = node0;
+			break;
+		}
+	}
+}
+
+/**
+ * update_tree - compare the old topology tree for card with the new
+ * one specified by root.  Queue the nodes and mark them as either
+ * found, lost or updated.  Update the nodes in the card topology tree
+ * as we go.
+ */
+static void
+update_tree(struct fw_card *card, struct fw_node *root)
+{
+	struct list_head list0, list1;
+	struct fw_node *node0, *node1;
+	int i, event;
+
+	INIT_LIST_HEAD(&list0);
+	list_add_tail(&card->local_node->link, &list0);
+	INIT_LIST_HEAD(&list1);
+	list_add_tail(&root->link, &list1);
+
+	node0 = fw_node(list0.next);
+	node1 = fw_node(list1.next);
+
+	while (&node0->link != &list0) {
+
+		/* assert(node0->port_count == node1->port_count); */
+		if (node0->link_on && !node1->link_on)
+			event = FW_NODE_LINK_OFF;
+		else if (!node0->link_on && node1->link_on)
+			event = FW_NODE_LINK_ON;
+		else
+			event = FW_NODE_UPDATED;
+
+		node0->node_id = node1->node_id;
+		node0->color = card->color;
+		node0->link_on = node1->link_on;
+		node0->initiated_reset = node1->initiated_reset;
+		node0->max_hops = node1->max_hops;
+		node1->color = card->color;
+		fw_node_event(card, node0, event);
+
+		if (card->root_node == node1)
+			card->root_node = node0;
+		if (card->irm_node == node1)
+			card->irm_node = node0;
+
+		for (i = 0; i < node0->port_count; i++) {
+			if (node0->ports[i].node && node1->ports[i].node) {
+				/* This port didn't change, queue the
+				 * connected node for further
+				 * investigation. */
+				if (node0->ports[i].node->color == card->color)
+					continue;
+				list_add_tail(&node0->ports[i].node->link,
+					      &list0);
+				list_add_tail(&node1->ports[i].node->link,
+					      &list1);
+			} else if (node0->ports[i].node) {
+				/* The nodes connected here were
+				 * unplugged; unref the lost nodes and
+				 * queue FW_NODE_LOST callbacks for
+				 * them. */
+
+				for_each_fw_node(card, node0->ports[i].node,
+						 report_lost_node);
+				node0->ports[i].node = NULL;
+			} else if (node1->ports[i].node) {
+				/* One or more node were connected to
+				 * this port. Move the new nodes into
+				 * the tree and queue FW_NODE_CREATED
+				 * callbacks for them. */
+				move_tree(node0, node1, i);
+				for_each_fw_node(card, node0->ports[i].node,
+						 report_found_node);
+			}
+		}
+
+		node0 = fw_node(node0->link.next);
+		node1 = fw_node(node1->link.next);
+	}
+}
+
+static void
+update_topology_map(struct fw_card *card, u32 *self_ids, int self_id_count)
+{
+	int node_count;
+	u32 crc;
+
+	card->topology_map[1]++;
+	node_count = (card->root_node->node_id & 0x3f) + 1;
+	card->topology_map[2] = (node_count << 16) | self_id_count;
+	crc = crc16_itu_t(card->topology_map + 1, self_id_count + 2);
+	card->topology_map[0] = ((self_id_count + 2) << 16) | crc;
+	memcpy(&card->topology_map[3], self_ids, self_id_count * 4);
+}
+
+void
+fw_core_handle_bus_reset(struct fw_card *card,
+			 int node_id, int generation,
+			 int self_id_count, u32 * self_ids)
+{
+	struct fw_node *local_node;
+	unsigned long flags;
+
+	fw_flush_transactions(card);
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	/* If the new topology has a different self_id_count the topology
+	 * changed, either nodes were added or removed. In that case we
+	 * reset the IRM reset counter. */
+	if (card->self_id_count != self_id_count)
+		card->bm_retries = 0;
+
+	card->node_id = node_id;
+	card->generation = generation;
+	card->reset_jiffies = jiffies;
+	schedule_delayed_work(&card->work, 0);
+
+	local_node = build_tree(card, self_ids, self_id_count);
+
+	update_topology_map(card, self_ids, self_id_count);
+
+	card->color++;
+
+	if (local_node == NULL) {
+		fw_error("topology build failed\n");
+		/* FIXME: We need to issue a bus reset in this case. */
+	} else if (card->local_node == NULL) {
+		card->local_node = local_node;
+		for_each_fw_node(card, local_node, report_found_node);
+	} else {
+		update_tree(card, local_node);
+	}
+
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+EXPORT_SYMBOL(fw_core_handle_bus_reset);

-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

