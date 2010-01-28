Return-Path: <linux-kernel-owner+w=401wt.eu-S932262Ab0A1RGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0A1RGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037Ab0A1RGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:06:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43011 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab0A1RGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:06:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Jan 2010 18:05:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.c0cd1d998becca89@s5r6.in-berlin.de>
Message-ID: <tkrat.9722581233c899cf@s5r6.in-berlin.de>
References: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
 <tkrat.c98ccacd8716c278@s5r6.in-berlin.de>
 <tkrat.c0cd1d998becca89@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates to the FireWire subsystem.
Thanks.

Stefan Richter (4):
      firewire: core: add_descriptor size check
      firewire: cdev: add_descriptor documentation fix
      firewire: core: fix use-after-free regression in FCP handler
      firewire: ohci: fix crashes with TSB43AB23 on 64bit systems

 drivers/firewire/core-card.c  |   41 ++++++++++++++++++--------
 drivers/firewire/core-cdev.c  |   50 +++++++++++++++++++++++---------
 drivers/firewire/ohci.c       |    4 ++-
 include/linux/firewire-cdev.h |    4 ++-
 4 files changed, 70 insertions(+), 29 deletions(-)


commit 7a481436787cbc932af6c407b317ac603969a242
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Jan 26 21:39:07 2010 +0100

    firewire: ohci: fix crashes with TSB43AB23 on 64bit systems
    
    Unsurprisingly, Texas Instruments TSB43AB23 exhibits the same behaviour
    as TSB43AB22/A in dual buffer IR DMA mode:  If descriptors are located
    at physical addresses above the 31 bit address range (2 GB), the
    controller will overwrite random memory.  With luck, this merely
    prevents video reception.  With only a little less luck, the machine
    crashes.
    
    We use the same workaround here as with TSB43AB22/A:  Switch off the
    dual buffer capability flag and use packet-per-buffer IR DMA instead.
    Another possible workaround would be to limit the coherent DMA mask to
    31 bits.
    
    In Linux 2.6.33, this change serves effectively only as documentation
    since dual buffer mode is not used for any controller anymore.  But
    somebody might want to re-enable it in the future to make use of
    features of dual buffer DMA that are not available in packet-per-buffer
    mode.
    
    In Linux 2.6.32 and older, this update is vital for anyone with this
    controller, more than 2 GB RAM, a 64 bit kernel, and FireWire video or
    audio applications.
    
    We have at least four reports:
    http://bugzilla.kernel.org/show_bug.cgi?id=13808
    http://marc.info/?l=linux1394-user&m=126154279004083
    https://bugzilla.redhat.com/show_bug.cgi?id=552142
    http://marc.info/?l=linux1394-user&m=126432246128386
    
    Reported-by: Paul Johnson
    Reported-by: Ronneil Camara
    Reported-by: G Zornetzer
    Reported-by: Mark Thompson
    Cc: stable@kernel.org
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index a61571c..2345d41 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2420,6 +2420,7 @@ static void ohci_pmac_off(struct pci_dev *dev)
 
 #define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
+#define PCI_DEVICE_ID_TI_TSB43AB23	0x8024
 
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
@@ -2488,7 +2489,8 @@ static int __devinit pci_probe(struct pci_dev *dev,
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */
 	if (dev->vendor == PCI_VENDOR_ID_TI &&
-	    dev->device == PCI_DEVICE_ID_TI_TSB43AB22)
+	    (dev->device == PCI_DEVICE_ID_TI_TSB43AB22 ||
+	     dev->device == PCI_DEVICE_ID_TI_TSB43AB23))
 		ohci->use_dualbuffer = false;
 #endif
 

commit 281e20323ab72180137824a298ee9e21e6f9acf6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 24 16:45:03 2010 +0100

    firewire: core: fix use-after-free regression in FCP handler
    
    Commit db5d247a "firewire: fix use of multiple AV/C devices, allow
    multiple FCP listeners" introduced a regression into 2.6.33-rc3:
    The core freed payloads of incoming requests to FCP_Request or
    FCP_Response before a userspace driver accessed them.
    
    We need to copy such payloads for each registered userspace client
    and free the copies according to the lifetime rules of non-FCP client
    request resources.
    
    (This could possibly be optimized by reference counts instead of
    copies.)
    
    The presently only kernelspace driver which listens for FCP requests,
    firedtv, was not affected because it already copies FCP frames into an
    own buffer before returning to firewire-core's FCP handler dispatcher.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index e6d6384..4eeaed5 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -35,6 +35,7 @@
 #include <linux/preempt.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
@@ -595,13 +596,20 @@ static int ioctl_send_request(struct client *client, void *buffer)
 			    client->device->max_speed);
 }
 
+static inline bool is_fcp_request(struct fw_request *request)
+{
+	return request == NULL;
+}
+
 static void release_request(struct client *client,
 			    struct client_resource *resource)
 {
 	struct inbound_transaction_resource *r = container_of(resource,
 			struct inbound_transaction_resource, resource);
 
-	if (r->request)
+	if (is_fcp_request(r->request))
+		kfree(r->data);
+	else
 		fw_send_response(client->device->card, r->request,
 				 RCODE_CONFLICT_ERROR);
 	kfree(r);
@@ -616,6 +624,7 @@ static void handle_request(struct fw_card *card, struct fw_request *request,
 	struct address_handler_resource *handler = callback_data;
 	struct inbound_transaction_resource *r;
 	struct inbound_transaction_event *e;
+	void *fcp_frame = NULL;
 	int ret;
 
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
@@ -627,6 +636,18 @@ static void handle_request(struct fw_card *card, struct fw_request *request,
 	r->data    = payload;
 	r->length  = length;
 
+	if (is_fcp_request(request)) {
+		/*
+		 * FIXME: Let core-transaction.c manage a
+		 * single reference-counted copy?
+		 */
+		fcp_frame = kmemdup(payload, length, GFP_ATOMIC);
+		if (fcp_frame == NULL)
+			goto failed;
+
+		r->data = fcp_frame;
+	}
+
 	r->resource.release = release_request;
 	ret = add_client_resource(handler->client, &r->resource, GFP_ATOMIC);
 	if (ret < 0)
@@ -640,13 +661,15 @@ static void handle_request(struct fw_card *card, struct fw_request *request,
 	e->request.closure = handler->closure;
 
 	queue_event(handler->client, &e->event,
-		    &e->request, sizeof(e->request), payload, length);
+		    &e->request, sizeof(e->request), r->data, length);
 	return;
 
  failed:
 	kfree(r);
 	kfree(e);
-	if (request)
+	kfree(fcp_frame);
+
+	if (!is_fcp_request(request))
 		fw_send_response(card, request, RCODE_CONFLICT_ERROR);
 }
 
@@ -717,18 +740,17 @@ static int ioctl_send_response(struct client *client, void *buffer)
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (r->request) {
-		if (request->length < r->length)
-			r->length = request->length;
-		if (copy_from_user(r->data, u64_to_uptr(request->data),
-				   r->length)) {
-			ret = -EFAULT;
-			kfree(r->request);
-			goto out;
-		}
-		fw_send_response(client->device->card, r->request,
-				 request->rcode);
+	if (is_fcp_request(r->request))
+		goto out;
+
+	if (request->length < r->length)
+		r->length = request->length;
+	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length)) {
+		ret = -EFAULT;
+		kfree(r->request);
+		goto out;
 	}
+	fw_send_response(client->device->card, r->request, request->rcode);
  out:
 	kfree(r);
 

commit 6d3faf6f431bafb25f4b9926c50a7e5c267738c6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 24 14:48:00 2010 +0100

    firewire: cdev: add_descriptor documentation fix
    
    struct fw_cdev_add_descriptor.length is in quadlets, not in bytes.
    Also remove any doubts about the endianess of descriptor data.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 1f716d9..520ecf8 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -380,7 +380,7 @@ struct fw_cdev_initiate_bus_reset {
  * @immediate:	If non-zero, immediate key to insert before pointer
  * @key:	Upper 8 bits of root directory pointer
  * @data:	Userspace pointer to contents of descriptor block
- * @length:	Length of descriptor block data, in bytes
+ * @length:	Length of descriptor block data, in quadlets
  * @handle:	Handle to the descriptor, written by the kernel
  *
  * Add a descriptor block and optionally a preceding immediate key to the local
@@ -394,6 +394,8 @@ struct fw_cdev_initiate_bus_reset {
  * If not 0, the @immediate field specifies an immediate key which will be
  * inserted before the root directory pointer.
  *
+ * @immediate, @key, and @data array elements are CPU-endian quadlets.
+ *
  * If successful, the kernel adds the descriptor and writes back a handle to the
  * kernel-side object to be used for later removal of the descriptor block and
  * immediate key.

commit e300839da40e99581581c5d053a95a172651fec8
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 24 14:47:02 2010 +0100

    firewire: core: add_descriptor size check
    
    Presently, firewire-core only checks whether descriptors that are to be
    added by userspace drivers to the local node's config ROM do not exceed
    a size of 256 quadlets.  However, the sum of the bare minimum ROM plus
    all descriptors (from firewire-core, from firewire-net, from userspace)
    must not exceed 256 quadlets.
    
    Otherwise, the bounds of a statically allocated buffer will be
    overwritten.  If the kernel survives that, firewire-core will
    subsequently be unable to parse the local node's config ROM.
    
    (Note, userspace drivers can add descriptors only through device files
    of local nodes.  These are usually only accessible by root, unlike
    device files of remote nodes which may be accessible to lesser
    privileged users.)
    
    Therefore add a test which takes the actual present and required ROM
    size into account for all descriptors of kernelspace and userspace
    drivers.
    
    Cc: stable@kernel.org
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 7083bcc..5045156 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -57,6 +57,8 @@ static LIST_HEAD(descriptor_list);
 static int descriptor_count;
 
 static __be32 tmp_config_rom[256];
+/* ROM header, bus info block, root dir header, capabilities = 7 quadlets */
+static size_t config_rom_length = 1 + 4 + 1 + 1;
 
 #define BIB_CRC(v)		((v) <<  0)
 #define BIB_CRC_LENGTH(v)	((v) << 16)
@@ -73,7 +75,7 @@ static __be32 tmp_config_rom[256];
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static size_t generate_config_rom(struct fw_card *card, __be32 *config_rom)
+static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
 	int i, j, k, length;
@@ -130,23 +132,30 @@ static size_t generate_config_rom(struct fw_card *card, __be32 *config_rom)
 	for (i = 0; i < j; i += length + 1)
 		length = fw_compute_block_crc(config_rom + i);
 
-	return j;
+	WARN_ON(j != config_rom_length);
 }
 
 static void update_config_roms(void)
 {
 	struct fw_card *card;
-	size_t length;
 
 	list_for_each_entry (card, &card_list, link) {
-		length = generate_config_rom(card, tmp_config_rom);
-		card->driver->set_config_rom(card, tmp_config_rom, length);
+		generate_config_rom(card, tmp_config_rom);
+		card->driver->set_config_rom(card, tmp_config_rom,
+					     config_rom_length);
 	}
 }
 
+static size_t required_space(struct fw_descriptor *desc)
+{
+	/* descriptor + entry into root dir + optional immediate entry */
+	return desc->length + 1 + (desc->immediate > 0 ? 1 : 0);
+}
+
 int fw_core_add_descriptor(struct fw_descriptor *desc)
 {
 	size_t i;
+	int ret;
 
 	/*
 	 * Check descriptor is valid; the length of all blocks in the
@@ -162,15 +171,21 @@ int fw_core_add_descriptor(struct fw_descriptor *desc)
 
 	mutex_lock(&card_mutex);
 
-	list_add_tail(&desc->link, &descriptor_list);
-	descriptor_count++;
-	if (desc->immediate > 0)
+	if (config_rom_length + required_space(desc) > 256) {
+		ret = -EBUSY;
+	} else {
+		list_add_tail(&desc->link, &descriptor_list);
+		config_rom_length += required_space(desc);
 		descriptor_count++;
-	update_config_roms();
+		if (desc->immediate > 0)
+			descriptor_count++;
+		update_config_roms();
+		ret = 0;
+	}
 
 	mutex_unlock(&card_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(fw_core_add_descriptor);
 
@@ -179,6 +194,7 @@ void fw_core_remove_descriptor(struct fw_descriptor *desc)
 	mutex_lock(&card_mutex);
 
 	list_del(&desc->link);
+	config_rom_length -= required_space(desc);
 	descriptor_count--;
 	if (desc->immediate > 0)
 		descriptor_count--;
@@ -428,7 +444,6 @@ EXPORT_SYMBOL(fw_card_initialize);
 int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid)
 {
-	size_t length;
 	int ret;
 
 	card->max_receive = max_receive;
@@ -437,8 +452,8 @@ int fw_card_add(struct fw_card *card,
 
 	mutex_lock(&card_mutex);
 
-	length = generate_config_rom(card, tmp_config_rom);
-	ret = card->driver->enable(card, tmp_config_rom, length);
+	generate_config_rom(card, tmp_config_rom);
+	ret = card->driver->enable(card, tmp_config_rom, config_rom_length);
 	if (ret == 0)
 		list_add_tail(&card->link, &card_list);
 
-- 
Stefan Richter
-=====-==-=- ---= ===--
http://arcgraph.de/sr/

