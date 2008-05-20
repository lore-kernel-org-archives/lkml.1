Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbYETQqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbYETQqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYETQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:46:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51363 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYETQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:46:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 May 2008 18:46:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.119dc7959532de1f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.

Jay Fenlason (1):
      firewire: prevent userspace from accessing shut down devices

Stefan Richter (1):
      ieee1394: sbp2: use correct size of command descriptor block

 drivers/firewire/fw-cdev.c |   14 ++++++++++++++
 drivers/ieee1394/sbp2.c    |   20 ++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)


commit 551f4cb9de716ffcdaf968c99a450c22ff12e8c3
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Fri May 16 11:15:23 2008 -0400

    firewire: prevent userspace from accessing shut down devices
    
    If userspace ignores the POLLERR bit from poll(), and only attempts to
    read() the device when POLLIN is set, it can still make ioctl() calls on
    a device that has been removed from the system.  The node_id and
    generation returned by GET_INFO will be outdated, but INITIATE_BUS_RESET
    would still cause a bus reset, and GET_CYCLE_TIMER will return data.
    And if you guess the correct generation to use, you can send requests to
    a different device on the bus, and get responses back.
    
    This patch prevents open, ioctl, compat_ioctl, and mmap against shutdown
    devices.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 4a54192..dda1401 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -113,6 +113,11 @@ static int fw_device_op_open(struct inode *inode, struct file *file)
 	if (device == NULL)
 		return -ENODEV;
 
+	if (fw_device_is_shutdown(device)) {
+		fw_device_put(device);
+		return -ENODEV;
+	}
+
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (client == NULL) {
 		fw_device_put(device);
@@ -901,6 +906,9 @@ fw_device_op_ioctl(struct file *file,
 {
 	struct client *client = file->private_data;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	return dispatch_ioctl(client, cmd, (void __user *) arg);
 }
 
@@ -911,6 +919,9 @@ fw_device_op_compat_ioctl(struct file *file,
 {
 	struct client *client = file->private_data;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	return dispatch_ioctl(client, cmd, compat_ptr(arg));
 }
 #endif
@@ -922,6 +933,9 @@ static int fw_device_op_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long size;
 	int page_count, retval;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	/* FIXME: We could support multiple buffers, but we don't. */
 	if (client->buffer.pages != NULL)
 		return -EBUSY;


commit 93c596f7d611b379302bbdd26f31acdf72f4859a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun May 4 16:54:14 2008 +0200

    ieee1394: sbp2: use correct size of command descriptor block
    
    Boaz Harrosh wrote:
    > cmd->cmd_len is now guarantied to be set properly at all cases.
    > And some commands you want to support will not be set correctly
    > by COMMAND_SIZE().
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 16b9d0a..a5ceff2 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1539,15 +1539,13 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 
 static void sbp2_create_command_orb(struct sbp2_lu *lu,
 				    struct sbp2_command_info *cmd,
-				    unchar *scsi_cmd,
-				    unsigned int scsi_use_sg,
-				    unsigned int scsi_request_bufflen,
-				    struct scatterlist *sg,
-				    enum dma_data_direction dma_dir)
+				    struct scsi_cmnd *SCpnt)
 {
 	struct sbp2_fwhost_info *hi = lu->hi;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
 	u32 orb_direction;
+	unsigned int scsi_request_bufflen = scsi_bufflen(SCpnt);
+	enum dma_data_direction dma_dir = SCpnt->sc_data_direction;
 
 	/*
 	 * Set-up our command ORB.
@@ -1580,13 +1578,14 @@ static void sbp2_create_command_orb(struct sbp2_lu *lu,
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
 	} else
-		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sg,
+		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_sg_count(SCpnt),
+					 scsi_sglist(SCpnt),
 					 orb_direction, dma_dir);
 
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
 
-	memset(orb->cdb, 0, 12);
-	memcpy(orb->cdb, scsi_cmd, COMMAND_SIZE(*scsi_cmd));
+	memset(orb->cdb, 0, sizeof(orb->cdb));
+	memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
 }
 
 static void sbp2_link_orb_command(struct sbp2_lu *lu,
@@ -1669,16 +1668,13 @@ static void sbp2_link_orb_command(struct sbp2_lu *lu,
 static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
 			     void (*done)(struct scsi_cmnd *))
 {
-	unchar *scsi_cmd = (unchar *)SCpnt->cmnd;
 	struct sbp2_command_info *cmd;
 
 	cmd = sbp2util_allocate_command_orb(lu, SCpnt, done);
 	if (!cmd)
 		return -EIO;
 
-	sbp2_create_command_orb(lu, cmd, scsi_cmd, scsi_sg_count(SCpnt),
-				scsi_bufflen(SCpnt), scsi_sglist(SCpnt),
-				SCpnt->sc_data_direction);
+	sbp2_create_command_orb(lu, cmd, SCpnt);
 	sbp2_link_orb_command(lu, cmd);
 
 	return 0;


Thanks,
-- 
Stefan Richter
-=====-==--- -=-= =-=--
http://arcgraph.de/sr/

