Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXGIRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXGIRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbXGIRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:10:42 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13344 "EHLO
	oblu.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754308AbXGIRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:10:36 -0400
Date: Mon, 09 Jul 2007 11:10:44 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 4/8] drivers edac fix leaf sysfs attribute 
Message-ID: <46926c14.5aWjSME5nIUW8I1W%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

This patch fixes and enhances the driver level set of sysfs attributes
that can be added to the 'block' level of an edac_device type
of driver.

There is a controller information structure, which contains
one or more instances of device. Each instance will have one
or more blocks of device specific counters. This patch
fixes the ability to have more detailed attributes/controls
for each of the 'blocks', providing for the addition of 
controls/attributes from the low level driver to user space
via sysfs.

CC:             Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 edac_core.h         |   67 +++++++++++++++++---------------------
 edac_device.c       |   91 ++++++++++++++++++++++++++++++++++------------------
 edac_device_sysfs.c |   22 ++++++++++++
 3 files changed, 112 insertions(+), 68 deletions(-)

Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_core.h
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_core.h
@@ -468,32 +468,34 @@ struct edac_device_counter {
 	u32 ce_count;
 };
 
-/*
- * An array of these is passed to the alloc() function
- * to specify attributes of the edac_block
- */
-struct edac_attrib_spec {
-	char name[EDAC_DEVICE_NAME_LEN + 1];
+/* forward reference */
+struct edac_device_ctl_info;
+struct edac_device_block;
 
-	int type;
-#define	EDAC_ATTR_INT		0x01
-#define EDAC_ATTR_CHAR		0x02
+/* edac_dev_sysfs_attribute structure
+ *	used for driver sysfs attributes in mem_ctl_info
+ *	for extra controls and attributes:
+ *		like high level error Injection controls
+ */
+struct edac_dev_sysfs_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct edac_device_ctl_info *, char *);
+	ssize_t (*store)(struct edac_device_ctl_info *, const char *, size_t);
 };
 
-/* Attribute control structure
- * In this structure is a pointer to the driver's edac_attrib_spec
- * The life of this pointer is inclusive in the life of the driver's
- * life cycle.
+/* edac_dev_sysfs_block_attribute structure
+ *	used in leaf 'block' nodes for adding controls/attributes
  */
-struct edac_attrib {
-	struct edac_device_block *block;	/* Up Pointer */
-
-	struct edac_attrib_spec *spec;	/* ptr to module spec entry */
-
-	union {			/* actual value */
-		int edac_attrib_int_value;
-		char edac_attrib_char_value[EDAC_ATTRIB_VALUE_LEN + 1];
-	} edac_attrib_value;
+struct edac_dev_sysfs_block_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct kobject *, struct attribute *, char *);
+	ssize_t (*store)(struct kobject *, struct attribute *,
+			const char *, size_t);
+	struct edac_device_block *block;
+
+	/* low driver use */
+	void *arg;
+	unsigned int value;
 };
 
 /* device block control structure */
@@ -504,7 +506,9 @@ struct edac_device_block {
 	struct edac_device_counter counters;	/* basic UE and CE counters */
 
 	int nr_attribs;		/* how many attributes */
-	struct edac_attrib *attribs;	/* this block's attributes */
+
+	/* this block's attributes, could be NULL */
+	struct edac_dev_sysfs_block_attribute *block_attributes;
 
 	/* edac sysfs device control */
 	struct kobject kobj;
@@ -526,15 +530,6 @@ struct edac_device_instance {
 	struct completion kobj_complete;
 };
 
-/* edac_dev_sysfs_attribute structure
- *     used for driver sysfs attributes and in mem_ctl_info
- *     sysfs top level entries
- */
-struct edac_dev_sysfs_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct edac_device_ctl_info *,char *);
-	ssize_t (*store)(struct edac_device_ctl_info *, const char *,size_t);
-};
 
 /*
  * Abstract edac_device control info structure
@@ -635,12 +630,10 @@ struct edac_device_ctl_info {
  */
 extern struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 		unsigned sizeof_private,
-		char *edac_device_name,
-		unsigned nr_instances,
-		char *edac_block_name,
-		unsigned nr_blocks,
+		char *edac_device_name, unsigned nr_instances,
+		char *edac_block_name, unsigned nr_blocks,
 		unsigned offset_value,
-		struct edac_attrib_spec *attrib_spec,
+		struct edac_dev_sysfs_block_attribute *block_attributes,
 		unsigned nr_attribs);
 
 /* The offset value can be:
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_device.c
@@ -67,12 +67,12 @@ struct edac_device_ctl_info *edac_device
 	char *edac_device_name, unsigned nr_instances,
 	char *edac_block_name, unsigned nr_blocks,
 	unsigned offset_value,		/* zero, 1, or other based offset */
-	struct edac_attrib_spec *attrib_spec, unsigned nr_attribs)
+	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib)
 {
 	struct edac_device_ctl_info *dev_ctl;
 	struct edac_device_instance *dev_inst, *inst;
 	struct edac_device_block *dev_blk, *blk_p, *blk;
-	struct edac_attrib *dev_attrib, *attrib_p, *attrib;
+	struct edac_dev_sysfs_block_attribute *dev_attrib, *attrib_p, *attrib;
 	unsigned total_size;
 	unsigned count;
 	unsigned instance, block, attr;
@@ -81,29 +81,47 @@ struct edac_device_ctl_info *edac_device
 	debugf1("%s() instances=%d blocks=%d\n",
 		__func__, nr_instances, nr_blocks);
 
-	/* Figure out the offsets of the various items from the start of an
-	 * ctl_info structure.  We want the alignment of each item
+	/* Calculate the size of memory we need to allocate AND
+	 * determine the offsets of the various item arrays
+	 * (instance,block,attrib) from the start of an  allocated structure.
+	 * We want the alignment of each item  (instance,block,attrib)
 	 * to be at least as stringent as what the compiler would
 	 * provide if we could simply hardcode everything into a single struct.
 	 */
 	dev_ctl = (struct edac_device_ctl_info *)NULL;
 
-	/* Calc the 'end' offset past the ctl_info structure */
+	/* Calc the 'end' offset past end of ONE ctl_info structure
+	 * which will become the start of the 'instance' array
+	 */
 	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
-	/* Calc the 'end' offset past the instance array */
+	/* Calc the 'end' offset past the instance array within the ctl_info
+	 * which will become the start of the block array
+	 */
 	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
-	/* Calc the 'end' offset past the dev_blk array */
+	/* Calc the 'end' offset past the dev_blk array
+	 * which will become the start of the attrib array, if any.
+	 */
 	count = nr_instances * nr_blocks;
 	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
-	/* Check for case of NO attributes specified */
-	if (nr_attribs > 0)
-		count *= nr_attribs;
+	/* Check for case of when an attribute array is specified */
+	if (nr_attrib > 0) {
+		/* calc how many nr_attrib we need */
+		count *= nr_attrib;
+
+		/* Calc the 'end' offset past the attributes array */
+		pvt = edac_align_ptr(&dev_attrib[count], sz_private);
+	} else {
+		/* no attribute array specificed */
+		pvt = edac_align_ptr(dev_attrib, sz_private);
+	}
 
-	/* Calc the 'end' offset past the attributes array */
-	pvt = edac_align_ptr(&dev_attrib[count], sz_private);
+	/* 'pvt' now points to where the private data area is.
+	 * At this point 'pvt' (like dev_inst,dev_blk and dev_attrib)
+	 * is baselined at ZERO
+	 */
 	total_size = ((unsigned long)pvt) + sz_private;
 
 	/* Allocate the amount of memory for the set of control structures */
@@ -111,17 +129,22 @@ struct edac_device_ctl_info *edac_device
 	if (dev_ctl == NULL)
 		return NULL;
 
-	/* Adjust pointers so they point within the memory we just allocated
-	 * rather than an imaginary chunk of memory located at address 0.
+	/* Adjust pointers so they point within the actual memory we
+	 * just allocated rather than an imaginary chunk of memory
+	 * located at address 0.
+	 * 'dev_ctl' points to REAL memory, while the others are
+	 * ZERO based and thus need to be adjusted to point within
+	 * the allocated memory.
 	 */
 	dev_inst = (struct edac_device_instance *)
 		(((char *)dev_ctl) + ((unsigned long)dev_inst));
 	dev_blk = (struct edac_device_block *)
 		(((char *)dev_ctl) + ((unsigned long)dev_blk));
-	dev_attrib = (struct edac_attrib *)
+	dev_attrib = (struct edac_dev_sysfs_block_attribute *)
 		(((char *)dev_ctl) + ((unsigned long)dev_attrib));
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
+	/* Begin storing the information into the control info structure */
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
@@ -145,28 +168,34 @@ struct edac_device_ctl_info *edac_device
 		for (block = 0; block < nr_blocks; block++) {
 			blk = &blk_p[block];
 			blk->instance = inst;
-			blk->nr_attribs = nr_attribs;
-			attrib_p = &dev_attrib[block * nr_attribs];
-			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
 				 "%s%d", edac_block_name, block+offset_value);
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
 				__func__, instance, block, blk->name);
 
-			if (attrib_spec != NULL) {
-				/* when there is an attrib_spec passed int then
-				 * Initialize every attrib of each block
-				 */
-				for (attr = 0; attr < nr_attribs; attr++) {
-					attrib = &attrib_p[attr];
-					attrib->block = blk;
-
-					/* Link each attribute to the caller's
-					 * spec entry, for name and type
-					 */
-					attrib->spec = &attrib_spec[attr];
-				}
+			/* if there are NO attributes OR no attribute pointer
+			 * then continue on to next block iteration
+			 */
+			if ((nr_attrib == 0) || (attrib_spec == NULL))
+				continue;
+
+			/* setup the attribute array for this block */
+			blk->nr_attribs = nr_attrib;
+			attrib_p = &dev_attrib[block*nr_instances*nr_attrib];
+			blk->block_attributes = attrib_p;
+
+			/* Initialize every user specified attribute in this
+			 * block with the data the caller passed in
+			 */
+			for (attr = 0; attr < nr_attrib; attr++) {
+				attrib = &attrib_p[attr];
+				attrib->attr = attrib_spec->attr;
+				attrib->show = attrib_spec->show;
+				attrib->store = attrib_spec->store;
+
+				/* up reference this block */
+				attrib->block = blk;
 			}
 		}
 	}
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_device_sysfs.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_device_sysfs.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_device_sysfs.c
@@ -456,8 +456,10 @@ static int edac_device_create_block(stru
 				struct edac_device_instance *instance,
 				int idx)
 {
+	int i;
 	int err;
 	struct edac_device_block *block;
+	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
 
 	block = &instance->blocks[idx];
 
@@ -480,7 +482,27 @@ static int edac_device_create_block(stru
 		return err;
 	}
 
+	/* If there are driver level block attributes, then added them
+	 * to the block kobject
+	 */
+	sysfs_attrib = block->block_attributes;
+	if (sysfs_attrib != NULL) {
+		for (i = 0; i < block->nr_attribs; i++) {
+			err = sysfs_create_file(&block->kobj,
+				(struct attribute *) &sysfs_attrib[i]);
+			if (err)
+				goto err_on_attrib;
+
+			sysfs_attrib++;
+		}
+	}
+
 	return 0;
+
+err_on_attrib:
+	kobject_unregister(&block->kobj);
+
+	return err;
 }
 
 /*
