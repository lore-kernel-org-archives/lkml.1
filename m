Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYCNSKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYCNSKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYCNSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:10:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45579 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbYCNSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:10:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Mar 2008 19:08:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
Message-ID: <tkrat.78d4e32f12b662de@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
 <tkrat.948f418ebe464164@s5r6.in-berlin.de>
 <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates for the firewire subsystem and one
> regression fix for the ieee1394 subsystem.
...
>  drivers/firewire/Kconfig          |   50 +++++--------
>  drivers/firewire/fw-ohci.c        |  108 +++++++++++++++++++++-------
>  drivers/firewire/fw-sbp2.c        |   36 +++++++++-
>  drivers/firewire/fw-topology.c    |    3 +-
>  drivers/firewire/fw-transaction.c |    2 +-
>  drivers/firewire/fw-transaction.h |    6 +-
>  drivers/ieee1394/sbp2.c           |    5 ++
>  7 files changed, 143 insertions(+), 67 deletions(-)
> 
> Jarod Wilson (2):
>       firewire: fw-sbp2: set single-phase retry_limit
>       firewire: fw-ohci: use dma_alloc_coherent for ar_buffer
> 
> Stefan Richter (9):
>       firewire: endianess fix
>       firewire: endianess annotations
>       firewire: fw-ohci: PPC PMac platform code
>       firewire: fw-ohci: Apple UniNorth 1st generation support
>       firewire: warn on fatal condition in topology code
>       firewire: update Kconfig help text
>       firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
>       ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
>       firewire: fw-ohci: shut up false compiler warning on PPC32


commit f5101d58afc528c1d0c863fe03cd2d607766c4a1
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Mar 14 00:27:49 2008 +0100

    firewire: fw-ohci: shut up false compiler warning on PPC32
    
    Shut up "may be used uninitialised in this function" warnings due to
    PPC32's implementation of dma_alloc_coherent().
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index fcf59fc..996d61f 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -281,7 +281,7 @@ static int ar_context_add_page(struct ar_context *ctx)
 {
 	struct device *dev = ctx->ohci->card.device;
 	struct ar_buffer *ab;
-	dma_addr_t ab_bus;
+	dma_addr_t uninitialized_var(ab_bus);
 	size_t offset;
 
 	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
@@ -536,7 +536,7 @@ static int
 context_add_buffer(struct context *ctx)
 {
 	struct descriptor_buffer *desc;
-	dma_addr_t bus_addr;
+	dma_addr_t uninitialized_var(bus_addr);
 	int offset;
 
 	/*
@@ -1321,7 +1321,7 @@ ohci_set_config_rom(struct fw_card *card, u32 *config_rom, size_t length)
 	unsigned long flags;
 	int retval = -EBUSY;
 	__be32 *next_config_rom;
-	dma_addr_t next_config_rom_bus;
+	dma_addr_t uninitialized_var(next_config_rom_bus);
 
 	ohci = fw_ohci(card);
 

commit bde1709aaa98f5004ab1580842c422be18eb4bc3
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Wed Mar 12 17:43:26 2008 -0400

    firewire: fw-ohci: use dma_alloc_coherent for ar_buffer
    
    Currently, we do nothing to guarantee we have a consistent DMA buffer for
    asynchronous receive packets. Rather than doing several sync's following a
    dma_map_single() to get consistent buffers, just switch to using
    dma_alloc_coherent().
    
    Resolves constant buffer failures on my own x86_64 laptop w/4GB of RAM and
    likely to fix a number of other failures witnessed on x86_64 systems with
    4GB of RAM or more.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index eaa213e..fcf59fc 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -284,16 +284,10 @@ static int ar_context_add_page(struct ar_context *ctx)
 	dma_addr_t ab_bus;
 	size_t offset;
 
-	ab = (struct ar_buffer *) __get_free_page(GFP_ATOMIC);
+	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
 	if (ab == NULL)
 		return -ENOMEM;
 
-	ab_bus = dma_map_single(dev, ab, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(ab_bus)) {
-		free_page((unsigned long) ab);
-		return -ENOMEM;
-	}
-
 	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
 						    DESCRIPTOR_STATUS |
@@ -304,8 +298,6 @@ static int ar_context_add_page(struct ar_context *ctx)
 	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
 	ab->descriptor.branch_address = 0;
 
-	dma_sync_single_for_device(dev, ab_bus, PAGE_SIZE, DMA_BIDIRECTIONAL);
-
 	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
 	ctx->last_buffer->next = ab;
 	ctx->last_buffer = ab;
@@ -409,6 +401,7 @@ static void ar_context_tasklet(unsigned long data)
 
 	if (d->res_count == 0) {
 		size_t size, rest, offset;
+		dma_addr_t buffer_bus;
 
 		/*
 		 * This descriptor is finished and we may have a
@@ -417,9 +410,7 @@ static void ar_context_tasklet(unsigned long data)
 		 */
 
 		offset = offsetof(struct ar_buffer, data);
-		dma_unmap_single(ohci->card.device,
-			le32_to_cpu(ab->descriptor.data_address) - offset,
-			PAGE_SIZE, DMA_BIDIRECTIONAL);
+		buffer_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
 
 		buffer = ab;
 		ab = ab->next;
@@ -435,7 +426,8 @@ static void ar_context_tasklet(unsigned long data)
 		while (buffer < end)
 			buffer = handle_ar_packet(ctx, buffer);
 
-		free_page((unsigned long)buffer);
+		dma_free_coherent(ohci->card.device, PAGE_SIZE,
+				  buffer, buffer_bus);
 		ar_context_add_page(ctx);
 	} else {
 		buffer = ctx->pointer;

commit 6e45ef4c7aeefbf97df748866cd1b24f73b86160
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Mar 11 22:32:52 2008 +0100

    ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
    
    Fix I/O errors due to SYM13FW500's inability to handle larger request
    sizes.  Reported by Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> for
    firewire-sbp2 in https://bugzilla.redhat.com/show_bug.cgi?id=436879
    
    This fix is necessary because sbp2's default request size limit has been
    lifted since 2.6.25-rc1.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 9e2b196..f53f72d 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -376,6 +376,11 @@ static const struct {
 		.model_id		= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
+		.firmware_revision	= 0x002600,
+		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model_id		= 0x000021,

commit 2aa9ff7fc5bc41d4b77c2da02086259a86f3d472
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Mar 11 22:32:03 2008 +0100

    firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
    
    Fix I/O errors due to SYM13FW500's inability to handle larger request
    sizes.  Reported by Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> in
    https://bugzilla.redhat.com/show_bug.cgi?id=436879
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 8bce569..62b4e47 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -331,6 +331,11 @@ static const struct {
 		.model			= ~0,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
+		.firmware_revision	= 0x002600,
+		.model			= ~0,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
+	},
 
 	/*
 	 * There are iPods (2nd gen, 3rd gen) with model_id == 0, but

commit 0a8da30dc7bd6828f42d9f0585367731f634a0c8
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Mar 9 00:27:20 2008 +0100

    firewire: update Kconfig help text
    
    Remove some less necessary information, point out that video1394 and
    dv1394 should be blacklisted along with ohci1394.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index fe9e768..25bdc2d 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,5 +1,3 @@
-# -*- shell-script -*-
-
 comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
 	depends on EXPERIMENTAL=n
 
@@ -21,27 +19,7 @@ config FIREWIRE
           NOTE:
 
 	  You should only build ONE of the stacks, unless you REALLY know what
-	  you are doing.  If you install both, you should configure them only as
-	  modules rather than link them statically, and you should blacklist one
-	  of the concurrent low-level drivers in /etc/modprobe.conf.  Add either
-
-	      blacklist firewire-ohci
-	  or
-	      blacklist ohci1394
-
-	  there depending on which driver you DON'T want to have auto-loaded.
-	  You can optionally do the same with the other IEEE 1394/ FireWire
-	  drivers.
-
-	  If you have an old modprobe which doesn't implement the blacklist
-	  directive, use either
-
-	       install firewire-ohci /bin/true
-	  or
-	       install ohci1394 /bin/true
-
-	  and so on, depending on which modules you DON't want to have
-	  auto-loaded.
+	  you are doing.
 
 config FIREWIRE_OHCI
 	tristate "Support for OHCI FireWire host controllers"
@@ -57,8 +35,24 @@ config FIREWIRE_OHCI
 
           NOTE:
 
-	  If you also build ohci1394 of the classic stack, blacklist either
-	  ohci1394 or firewire-ohci to let hotplug load only the desired driver.
+	  You should only build ohci1394 or firewire-ohci, but not both.
+	  If you nevertheless want to install both, you should configure them
+	  only as modules and blacklist the driver(s) which you don't want to
+	  have auto-loaded.  Add either
+
+	      blacklist firewire-ohci
+	  or
+	      blacklist ohci1394
+	      blacklist video1394
+	      blacklist dv1394
+
+	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
+	  depending on your distribution.  The latter two modules should be
+	  blacklisted together with ohci1394 because they depend on ohci1394.
+
+	  If you have an old modprobe which doesn't implement the blacklist
+	  directive, use "install modulename /bin/true" for the modules to be
+	  blacklisted.
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -75,9 +69,3 @@ config FIREWIRE_SBP2
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
-
-          NOTE:
-
-	  If you also build sbp2 of the classic stack, blacklist either sbp2
-	  or firewire-sbp2 to let hotplug load only the desired driver.
-

commit a2cdebe33f4c40a1bc7f66522303df89d5026cb4
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Mar 8 22:38:16 2008 +0100

    firewire: warn on fatal condition in topology code
    
    If this ever happens to anybody, we want to have it in his log.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index e47bb04..d2c7a3d 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
+#include <asm/bug.h>
 #include <asm/system.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -424,8 +425,8 @@ update_tree(struct fw_card *card, struct fw_node *root)
 	node1 = fw_node(list1.next);
 
 	while (&node0->link != &list0) {
+		WARN_ON(node0->port_count != node1->port_count);
 
-		/* assert(node0->port_count == node1->port_count); */
 		if (node0->link_on && !node1->link_on)
 			event = FW_NODE_LINK_OFF;
 		else if (!node0->link_on && node1->link_on)

commit 51f9dbef5be41f3ff6000c874741a3a357f9bad7
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Fri Mar 7 01:43:01 2008 -0500

    firewire: fw-sbp2: set single-phase retry_limit
    
    Per the SBP-2 specification, all SBP-2 target devices must have a BUSY_TIMEOUT
    register. Per the 1394-1995 specification, the retry_limt portion of the
    register should be set to 0x0 initially, and set on the target by a logged in
    initiator (i.e., a Linux host w/firewire controller(s)).
    
    Well, as it turns out, lots of devices these days have actually moved on to
    starting to implement SBP-3 compliance, which says that retry_limit should
    default to 0xf instead (yes, SBP-3 stomps directly on 1394-1995, oops).
    
    Prior to this change, the firewire driver stack didn't touch retry_limit, and
    any SBP-3 compliant device worked fine, while SBP-2 compliant ones were unable
    to retransmit when the host returned an ack_busy_X, which resulted in stalled
    out I/O, eventually causing the SCSI layer to give up and offline the device.
    
    The simple fix is for us to set retry_limit to 0xf in the register for all
    devices (which actually matches what the old ieee1394 stack did).
    
    Prior to this change, a hard disk behind an SBP-2 Prolific PL-3507 bridge chip
    would routinely encounter buffer I/O errors and wind up offlined by the SCSI
    layer. With this change, I've encountered zero I/O failures moving tens of GB
    of data around.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 03069a4..8bce569 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -173,6 +173,7 @@ struct sbp2_target {
 #define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
+#define SBP2_RETRY_LIMIT		0xf	/* 15 retries */
 
 #define SBP2_DIRECTION_TO_MEDIA		0x0
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
@@ -812,6 +813,30 @@ static void sbp2_target_put(struct sbp2_target *tgt)
 	kref_put(&tgt->kref, sbp2_release_target);
 }
 
+static void
+complete_set_busy_timeout(struct fw_card *card, int rcode,
+			  void *payload, size_t length, void *done)
+{
+	complete(done);
+}
+
+static void sbp2_set_busy_timeout(struct sbp2_logical_unit *lu)
+{
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct fw_transaction t;
+	static __be32 busy_timeout;
+
+	/* FIXME: we should try to set dual-phase cycle_limit too */
+	busy_timeout = cpu_to_be32(SBP2_RETRY_LIMIT);
+
+	fw_send_request(device->card, &t, TCODE_WRITE_QUADLET_REQUEST,
+			lu->tgt->node_id, lu->generation, device->max_speed,
+			CSR_REGISTER_BASE + CSR_BUSY_TIMEOUT, &busy_timeout,
+			sizeof(busy_timeout), complete_set_busy_timeout, &done);
+	wait_for_completion(&done);
+}
+
 static void sbp2_reconnect(struct work_struct *work);
 
 static void sbp2_login(struct work_struct *work)
@@ -864,10 +889,8 @@ static void sbp2_login(struct work_struct *work)
 	fw_notify("%s: logged in to LUN %04x (%d retries)\n",
 		  tgt->bus_id, lu->lun, lu->retries);
 
-#if 0
-	/* FIXME: The linux1394 sbp2 does this last step. */
-	sbp2_set_busy_timeout(scsi_id);
-#endif
+	/* set appropriate retry limit(s) in BUSY_TIMEOUT register */
+	sbp2_set_busy_timeout(lu);
 
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
 	sbp2_agent_reset(lu);

commit 11bf20ad028880a56689f086bfbabfd88b2af38b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Mar 1 02:47:15 2008 +0100

    firewire: fw-ohci: Apple UniNorth 1st generation support
    
    Mostly copied from ohci1394.c.  Necessary for some older Macs, e.g.
    PowerBook G3 Pismo and early PowerBook G4 Titanium.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 182be86..eaa213e 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -179,6 +179,7 @@ struct fw_ohci {
 	int generation;
 	int request_generation;
 	u32 bus_seconds;
+	bool old_uninorth;
 
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
@@ -315,15 +316,22 @@ static int ar_context_add_page(struct ar_context *ctx)
 	return 0;
 }
 
+#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
+#define cond_le32_to_cpu(v) \
+	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
+#else
+#define cond_le32_to_cpu(v) le32_to_cpu(v)
+#endif
+
 static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 {
 	struct fw_ohci *ohci = ctx->ohci;
 	struct fw_packet p;
 	u32 status, length, tcode;
 
-	p.header[0] = le32_to_cpu(buffer[0]);
-	p.header[1] = le32_to_cpu(buffer[1]);
-	p.header[2] = le32_to_cpu(buffer[2]);
+	p.header[0] = cond_le32_to_cpu(buffer[0]);
+	p.header[1] = cond_le32_to_cpu(buffer[1]);
+	p.header[2] = cond_le32_to_cpu(buffer[2]);
 
 	tcode = (p.header[0] >> 4) & 0x0f;
 	switch (tcode) {
@@ -335,7 +343,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 		break;
 
 	case TCODE_READ_BLOCK_REQUEST :
-		p.header[3] = le32_to_cpu(buffer[3]);
+		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = 0;
 		break;
@@ -344,7 +352,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 	case TCODE_READ_BLOCK_RESPONSE:
 	case TCODE_LOCK_REQUEST:
 	case TCODE_LOCK_RESPONSE:
-		p.header[3] = le32_to_cpu(buffer[3]);
+		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = p.header[3] >> 16;
 		break;
@@ -361,7 +369,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 
 	/* FIXME: What to do about evt_* errors? */
 	length = (p.header_length + p.payload_length + 3) / 4;
-	status = le32_to_cpu(buffer[length]);
+	status = cond_le32_to_cpu(buffer[length]);
 
 	p.ack        = ((status >> 16) & 0x1f) - 16;
 	p.speed      = (status >> 21) & 0x7;
@@ -1026,13 +1034,14 @@ static void bus_reset_tasklet(unsigned long data)
 	 */
 
 	self_id_count = (reg_read(ohci, OHCI1394_SelfIDCount) >> 3) & 0x3ff;
-	generation = (le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
+	generation = (cond_le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
 	rmb();
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
 		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1])
 			fw_error("inconsistent self IDs\n");
-		ohci->self_id_buffer[j] = le32_to_cpu(ohci->self_id_cpu[i]);
+		ohci->self_id_buffer[j] =
+				cond_le32_to_cpu(ohci->self_id_cpu[i]);
 	}
 	rmb();
 
@@ -2082,6 +2091,10 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	pci_write_config_dword(dev, OHCI1394_PCI_HCI_Control, 0);
 	pci_set_drvdata(dev, ohci);
 
+#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
+	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
+			     dev->device == PCI_DEVICE_ID_APPLE_UNI_N_FW;
+#endif
 	spin_lock_init(&ohci->lock);
 
 	tasklet_init(&ohci->bus_reset_tasklet,

commit ea8d006b91ac58ec5a0862d09e0b629db399517f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Mar 1 02:42:56 2008 +0100

    firewire: fw-ohci: PPC PMac platform code
    
    Copied from ohci1394.c.  This code is necessary to prevent machine check
    exceptions when reloading or resuming the driver.
    
    Tested on a 1st generation PowerBook G4 Titanium, which also needs the
    pci_probe() hunk.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    
    I was able to reproduce the system exception on resume with a 3rd-gen
    Titanium PowerBook G4 667, and this patch does let the system resume
    successfully now.
    
    Not quite clear if there was possibly an updated version coming using
    pci_enable_device() instead of the pair of pmac_call_feature() calls,
    but either way, this is a definite must-have, at least for older ppc
    macs -- my Aluminum PowerBook G4/1.67 suspends and resumes without this
    patch just fine.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index f9440a7..182be86 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -33,6 +33,10 @@
 #include <asm/page.h>
 #include <asm/system.h>
 
+#ifdef CONFIG_PPC_PMAC
+#include <asm/pmac_feature.h>
+#endif
+
 #include "fw-ohci.h"
 #include "fw-transaction.h"
 
@@ -2048,6 +2052,18 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	int err;
 	size_t size;
 
+#ifdef CONFIG_PPC_PMAC
+	/* Necessary on some machines if fw-ohci was loaded/ unloaded before */
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(dev);
+
+		if (ofn) {
+			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 1);
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
+		}
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		fw_error("Could not malloc fw_ohci data.\n");
@@ -2182,6 +2198,19 @@ static void pci_remove(struct pci_dev *dev)
 	pci_disable_device(dev);
 	fw_card_put(&ohci->card);
 
+#ifdef CONFIG_PPC_PMAC
+	/* On UniNorth, power down the cable and turn off the chip clock
+	 * to save power on laptops */
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(dev);
+
+		if (ofn) {
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
+			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
+		}
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	fw_notify("Removed fw-ohci device.\n");
 }
 
@@ -2202,6 +2231,16 @@ static int pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (err)
 		fw_error("pci_set_power_state failed with %d\n", err);
 
+/* PowerMac suspend code comes last */
+#ifdef CONFIG_PPC_PMAC
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(pdev);
+
+		if (ofn)
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	return 0;
 }
 
@@ -2210,6 +2249,16 @@ static int pci_resume(struct pci_dev *pdev)
 	struct fw_ohci *ohci = pci_get_drvdata(pdev);
 	int err;
 
+/* PowerMac resume code comes first */
+#ifdef CONFIG_PPC_PMAC
+	if (machine_is(powermac)) {
+		struct device_node *ofn = pci_device_to_OF_node(pdev);
+
+		if (ofn)
+			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
+	}
+#endif /* CONFIG_PPC_PMAC */
+
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	err = pci_enable_device(pdev);

commit efbf390a2d940315efff174455243e61f23c03b9
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Feb 23 12:24:57 2008 +0100

    firewire: endianess annotations
    
    Kills warnings from 'make C=1 CHECKFLAGS="-D__CHECK_ENDIAN__" modules':
    
    drivers/firewire/fw-transaction.c:771:10: warning: incorrect type in assignment (different base types)
    drivers/firewire/fw-transaction.c:771:10:    expected unsigned int [unsigned] [usertype] <noident>
    drivers/firewire/fw-transaction.c:771:10:    got restricted unsigned int [usertype] <noident>
    drivers/firewire/fw-transaction.h:93:10: warning: incorrect type in assignment (different base types)
    drivers/firewire/fw-transaction.h:93:10:    expected unsigned int [unsigned] [usertype] <noident>
    drivers/firewire/fw-transaction.h:93:10:    got restricted unsigned int [usertype] <noident>
    drivers/firewire/fw-ohci.c:1490:8: warning: restricted degrades to integer
    drivers/firewire/fw-ohci.c:1490:35: warning: restricted degrades to integer
    drivers/firewire/fw-ohci.c:1516:5: warning: cast to restricted type
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index ed4e357..f9440a7 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1487,7 +1487,7 @@ static int handle_ir_dualbuffer_packet(struct context *context,
 	void *p, *end;
 	int i;
 
-	if (db->first_res_count > 0 && db->second_res_count > 0) {
+	if (db->first_res_count != 0 && db->second_res_count != 0) {
 		if (ctx->excess_bytes <= le16_to_cpu(db->second_req_count)) {
 			/* This descriptor isn't done yet, stop iteration. */
 			return 0;
@@ -1513,7 +1513,7 @@ static int handle_ir_dualbuffer_packet(struct context *context,
 		memcpy(ctx->header + i + 4, p + 8, ctx->base.header_size - 4);
 		i += ctx->base.header_size;
 		ctx->excess_bytes +=
-			(le32_to_cpu(*(u32 *)(p + 4)) >> 16) & 0xffff;
+			(le32_to_cpu(*(__le32 *)(p + 4)) >> 16) & 0xffff;
 		p += ctx->base.header_size + 4;
 	}
 	ctx->header_length = i;
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 7fcc59d..99529e5 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -751,7 +751,7 @@ handle_topology_map(struct fw_card *card, struct fw_request *request,
 		    void *payload, size_t length, void *callback_data)
 {
 	int i, start, end;
-	u32 *map;
+	__be32 *map;
 
 	if (!TCODE_IS_READ_REQUEST(tcode)) {
 		fw_send_response(card, request, RCODE_TYPE_ERROR);
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index 09cb728..a43bb22 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -86,12 +86,12 @@
 static inline void
 fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
 {
-	u32 *dst = _dst;
-	u32 *src = _src;
+	u32    *dst = _dst;
+	__be32 *src = _src;
 	int i;
 
 	for (i = 0; i < size / 4; i++)
-		dst[i] = cpu_to_be32(src[i]);
+		dst[i] = be32_to_cpu(src[i]);
 }
 
 static inline void

commit 25df287dc7434edf8dda10ce85e43f88e834a494
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Feb 23 12:24:17 2008 +0100

    firewire: endianess fix
    
    The generation of incoming requests was filled in in wrong byte order on
    machines with big endian CPU.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 7ebad3c..ed4e357 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -375,7 +375,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 	 */
 
 	if (p.ack + 16 == 0x09)
-		ohci->request_generation = (buffer[2] >> 16) & 0xff;
+		ohci->request_generation = (p.header[2] >> 16) & 0xff;
 	else if (ctx == &ohci->ar_request_ctx)
 		fw_core_handle_request(&ohci->card, &p);
 	else


-- 
Stefan Richter
-=====-==--- --== -===-
http://arcgraph.de/sr/

