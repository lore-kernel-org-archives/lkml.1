Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZCJUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZCJUBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZCJUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:01:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48121 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZCJUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:01:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:00:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5] firewire: cdev: secure add_descriptor ioctl
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
Message-ID: <tkrat.f5124eaf43051e6a@s5r6.in-berlin.de>
References: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access permissions and ownership or ACL of /dev/fw* character device
files will typically be set based on the device type of the respective
nodes, as obtained by firewire-core from descriptors in the device's
configuration ROM.  An example policy is to deny write permission by
default but grant write permission to files of AV/C video and audio
devices and IIDC video devices.

The FW_CDEV_IOC_ADD_DESCRIPTOR ioctl could be used to partly subvert
such a policy:  Find a device file with relaxed permissions, use the
ioctl to add a descriptor with AV/C marker to the local node's ROM, thus
gain access to the local node's character device file.  (This is only
possible if there are udev scripts installed which actively relax
permissions for known device types and if there is a device of such a
type connected.)

Accessibility of the local node's device file is relevant to host
security if the host contains two or more IEEE 1394 link layer
controllers which are plugged into a single bus.

Therefore change the ABI to deny FW_CDEV_IOC_ADD_DESCRIPTOR if the file
belongs to a remote node.  (This change has no impact on known
implementers of the ABI:  None of them uses the ioctl yet.)

Also clarify the documentation:  The ioctl affects all local nodes, not
just one local node.

Cc: stable@kernel.org
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |    8 ++++++++
 include/linux/firewire-cdev.h |    5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -742,9 +742,17 @@ static void release_descriptor(struct cl
 static int ioctl_add_descriptor(struct client *client, void *buffer)
 {
 	struct fw_cdev_add_descriptor *request = buffer;
+	struct fw_card *card = client->device->card;
 	struct descriptor_resource *r;
 	int ret;
 
+	/* Access policy: Allow this ioctl only on local nodes' device files. */
+	spin_lock_irq(&card->lock);
+	ret = client->device->node_id != card->local_node->node_id;
+	spin_unlock_irq(&card->lock);
+	if (ret)
+		return -ENOSYS;
+
 	if (request->length > 256)
 		return -EINVAL;
 
Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -394,6 +394,9 @@ struct fw_cdev_initiate_bus_reset {
  * If successful, the kernel adds the descriptor and writes back a handle to the
  * kernel-side object to be used for later removal of the descriptor block and
  * immediate key.
+ *
+ * This ioctl affects the configuration ROMs of all local nodes.
+ * The ioctl only succeeds on device files which represent a local node.
  */
 struct fw_cdev_add_descriptor {
 	__u32 immediate;
@@ -409,7 +412,7 @@ struct fw_cdev_add_descriptor {
  *		descriptor was added
  *
  * Remove a descriptor block and accompanying immediate key from the local
- * node's configuration ROM.
+ * nodes' configuration ROMs.
  */
 struct fw_cdev_remove_descriptor {
 	__u32 handle;

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

