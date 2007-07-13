Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbXGMQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbXGMQs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXGMQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:47:56 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:12955 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762901AbXGMQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:47:54 -0400
Date: Fri, 13 Jul 2007 10:54:10 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 6/8] drivers edac fix edac_device init apis 
Message-ID: <4697ae32.bPoMUirk9o5iwdUe%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:   Doug Thompson <dougthompson@xmission.com>

Refactoring of sysfs code necessitated the refactoring of
the edac_device_alloc() and edac_device_add_device() apis, of moving
the index value to the alloc() function. This patch
alters the in tree drivers to utilize this new api signature.

Having the index value performed later created a chicken-and-the-egg
issue. Moving it to the alloc() function allows for creating the
necessary sysfs entries with the proper index number

CC:             Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
---
 edac_core.h   |    6 +++---
 edac_device.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_core.h
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_core.h
@@ -634,7 +634,8 @@ extern struct edac_device_ctl_info *edac
 		char *edac_block_name, unsigned nr_blocks,
 		unsigned offset_value,
 		struct edac_dev_sysfs_block_attribute *block_attributes,
-		unsigned nr_attribs);
+		unsigned nr_attribs,
+		int device_index);
 
 /* The offset value can be:
  *	-1 indicating no offset value
@@ -806,8 +807,7 @@ extern void edac_mc_handle_fbd_ce(struct
 /*
  * edac_device APIs
  */
-extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev,
-				int dev_idx);
+extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev);
 extern struct edac_device_ctl_info *edac_device_del_device(struct device *dev);
 extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_device.c
@@ -67,7 +67,8 @@ struct edac_device_ctl_info *edac_device
 	char *edac_device_name, unsigned nr_instances,
 	char *edac_block_name, unsigned nr_blocks,
 	unsigned offset_value,		/* zero, 1, or other based offset */
-	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib)
+	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib,
+	int device_index)
 {
 	struct edac_device_ctl_info *dev_ctl;
 	struct edac_device_instance *dev_inst, *inst;
@@ -145,6 +146,7 @@ struct edac_device_ctl_info *edac_device
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
 	/* Begin storing the information into the control info structure */
+	dev_ctl->dev_idx = device_index;
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
@@ -441,18 +443,16 @@ void edac_device_reset_delay_period(stru
  * edac_device global list and create sysfs entries associated with
  * edac_device structure.
  * @edac_device: pointer to the edac_device structure to be added to the list
- * @edac_idx: A unique numeric identifier to be assigned to the
  * 'edac_device' structure.
  *
  * Return:
  *	0	Success
  *	!0	Failure
  */
-int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx)
+int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 
-	edac_dev->dev_idx = edac_idx;
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_device_dump_device(edac_dev);
