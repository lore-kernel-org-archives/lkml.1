Return-Path: <linux-kernel-owner+w=401wt.eu-S1030905AbXAZQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905AbXAZQ4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030870AbXAZQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:56:17 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25722 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030786AbXAZQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:55:45 -0500
Date: Fri, 26 Jan 2007 17:55:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] Add crypto support for 3592 tape devices
Message-ID: <20070126165540.GZ11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] Add crypto support for 3592 tape devices

3592 tape devices are able to write data encrpyted on tape mediums.
This z/Linux device driver support includes the following functions:
 * ioctl to switch on/off encryption
 * ioctl to query encryption status of drive
 * ioctls to set and query key encrypting keys (kekls)
 * long busy interrupt handling

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/tape.h      |   22 +
 drivers/s390/char/tape_3590.c |  479 ++++++++++++++++++++++++++++++++++++++++--
 drivers/s390/char/tape_3590.h |   53 ++++
 drivers/s390/char/tape_char.c |    2 
 drivers/s390/char/tape_core.c |   53 ++++
 include/asm-s390/tape390.h    |   72 +++++-
 6 files changed, 645 insertions(+), 36 deletions(-)

diff -urpN linux-2.6/drivers/s390/char/tape_3590.c linux-2.6-patched/drivers/s390/char/tape_3590.c
--- linux-2.6/drivers/s390/char/tape_3590.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_3590.c	2007-01-26 17:29:34.000000000 +0100
@@ -2,7 +2,7 @@
  *  drivers/s390/char/tape_3590.c
  *    tape device discipline for 3590 tapes.
  *
- *    Copyright (C) IBM Corp. 2001,2006
+ *    Copyright IBM Corp. 2001,2006
  *    Author(s): Stefan Bader <shbader@de.ibm.com>
  *		 Michael Holzheu <holzheu@de.ibm.com>
  *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/bio.h>
+#include <asm/ebcdic.h>
 
 #define TAPE_DBF_AREA	tape_3590_dbf
 
@@ -30,7 +31,7 @@ EXPORT_SYMBOL(TAPE_DBF_AREA);
  * - Read Device (buffered) log: BRA
  * - Read Library log:		 BRA
  * - Swap Devices:		 BRA
- * - Long Busy:			 BRA
+ * - Long Busy:			 implemented
  * - Special Intercept:		 BRA
  * - Read Alternate:		 implemented
  *******************************************************************/
@@ -94,6 +95,332 @@ static const char *tape_3590_msg[TAPE_35
 	[0xae] = "Subsystem environmental alert",
 };
 
+static int crypt_supported(struct tape_device *device)
+{
+	return TAPE390_CRYPT_SUPPORTED(TAPE_3590_CRYPT_INFO(device));
+}
+
+static int crypt_enabled(struct tape_device *device)
+{
+	return TAPE390_CRYPT_ON(TAPE_3590_CRYPT_INFO(device));
+}
+
+static void ext_to_int_kekl(struct tape390_kekl *in,
+			    struct tape3592_kekl *out)
+{
+	int i;
+
+	memset(out, 0, sizeof(*out));
+	if (in->type == TAPE390_KEKL_TYPE_HASH)
+		out->flags |= 0x40;
+	if (in->type_on_tape == TAPE390_KEKL_TYPE_HASH)
+		out->flags |= 0x80;
+	strncpy(out->label, in->label, 64);
+	for (i = strlen(in->label); i < sizeof(out->label); i++)
+		out->label[i] = ' ';
+	ASCEBC(out->label, sizeof(out->label));
+}
+
+static void int_to_ext_kekl(struct tape3592_kekl *in,
+			    struct tape390_kekl *out)
+{
+	memset(out, 0, sizeof(*out));
+	if(in->flags & 0x40)
+		out->type = TAPE390_KEKL_TYPE_HASH;
+	else
+		out->type = TAPE390_KEKL_TYPE_LABEL;
+	if(in->flags & 0x80)
+		out->type_on_tape = TAPE390_KEKL_TYPE_HASH;
+	else
+		out->type_on_tape = TAPE390_KEKL_TYPE_LABEL;
+	memcpy(out->label, in->label, sizeof(in->label));
+	EBCASC(out->label, sizeof(in->label));
+	strstrip(out->label);
+}
+
+static void int_to_ext_kekl_pair(struct tape3592_kekl_pair *in,
+				 struct tape390_kekl_pair *out)
+{
+	if (in->count == 0) {
+		out->kekl[0].type = TAPE390_KEKL_TYPE_NONE;
+		out->kekl[0].type_on_tape = TAPE390_KEKL_TYPE_NONE;
+		out->kekl[1].type = TAPE390_KEKL_TYPE_NONE;
+		out->kekl[1].type_on_tape = TAPE390_KEKL_TYPE_NONE;
+	} else if (in->count == 1) {
+		int_to_ext_kekl(&in->kekl[0], &out->kekl[0]);
+		out->kekl[1].type = TAPE390_KEKL_TYPE_NONE;
+		out->kekl[1].type_on_tape = TAPE390_KEKL_TYPE_NONE;
+	} else if (in->count == 2) {
+		int_to_ext_kekl(&in->kekl[0], &out->kekl[0]);
+		int_to_ext_kekl(&in->kekl[1], &out->kekl[1]);
+	} else {
+		printk("Invalid KEKL number: %d\n", in->count);
+		BUG();
+	}
+}
+
+static int check_ext_kekl(struct tape390_kekl *kekl)
+{
+	if (kekl->type == TAPE390_KEKL_TYPE_NONE)
+		goto invalid;
+	if (kekl->type > TAPE390_KEKL_TYPE_HASH)
+		goto invalid;
+	if (kekl->type_on_tape == TAPE390_KEKL_TYPE_NONE)
+		goto invalid;
+	if (kekl->type_on_tape > TAPE390_KEKL_TYPE_HASH)
+		goto invalid;
+	if ((kekl->type == TAPE390_KEKL_TYPE_HASH) &&
+	    (kekl->type_on_tape == TAPE390_KEKL_TYPE_LABEL))
+		goto invalid;
+
+	return 0;
+invalid:
+	return -EINVAL;
+}
+
+static int check_ext_kekl_pair(struct tape390_kekl_pair *kekls)
+{
+	if (check_ext_kekl(&kekls->kekl[0]))
+		goto invalid;
+	if (check_ext_kekl(&kekls->kekl[1]))
+		goto invalid;
+
+	return 0;
+invalid:
+	return -EINVAL;
+}
+
+/*
+ * Query KEKLs
+ */
+static int tape_3592_kekl_query(struct tape_device *device,
+				struct tape390_kekl_pair *ext_kekls)
+{
+	struct tape_request *request;
+	struct tape3592_kekl_query_order *order;
+	struct tape3592_kekl_query_data *int_kekls;
+	int rc;
+
+	DBF_EVENT(6, "tape3592_kekl_query\n");
+	int_kekls = kmalloc(sizeof(*int_kekls), GFP_KERNEL|GFP_DMA);
+	if (!int_kekls)
+		return -ENOMEM;
+	request = tape_alloc_request(2, sizeof(*order));
+	if (IS_ERR(request)) {
+		rc = PTR_ERR(request);
+		goto fail_malloc;
+	}
+	order = request->cpdata;
+	memset(order,0,sizeof(*order));
+	order->code = 0xe2;
+	order->max_count = 2;
+	request->op = TO_KEKL_QUERY;
+	tape_ccw_cc(request->cpaddr, PERF_SUBSYS_FUNC, sizeof(*order), order);
+	tape_ccw_end(request->cpaddr + 1, READ_SS_DATA, sizeof(*int_kekls),
+		     int_kekls);
+	rc = tape_do_io(device, request);
+	if (rc)
+		goto fail_request;
+	int_to_ext_kekl_pair(&int_kekls->kekls, ext_kekls);
+
+	rc = 0;
+fail_request:
+	tape_free_request(request);
+fail_malloc:
+	kfree(int_kekls);
+	return rc;
+}
+
+/*
+ * IOCTL: Query KEKLs
+ */
+static int tape_3592_ioctl_kekl_query(struct tape_device *device,
+				      unsigned long arg)
+{
+	int rc;
+	struct tape390_kekl_pair *ext_kekls;
+
+	DBF_EVENT(6, "tape_3592_ioctl_kekl_query\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	if (!crypt_enabled(device))
+		return -EUNATCH;
+	ext_kekls = kmalloc(sizeof(*ext_kekls), GFP_KERNEL);
+	if (!ext_kekls)
+		return -ENOMEM;
+	rc = tape_3592_kekl_query(device, ext_kekls);
+	if (rc != 0)
+		goto fail;
+	if (copy_to_user((char __user *) arg, ext_kekls, sizeof(*ext_kekls))) {
+		rc = -EFAULT;
+		goto fail;
+	}
+	rc = 0;
+fail:
+	kfree(ext_kekls);
+	return rc;
+}
+
+static int tape_3590_mttell(struct tape_device *device, int mt_count);
+
+/*
+ * Set KEKLs
+ */
+static int tape_3592_kekl_set(struct tape_device *device,
+			      struct tape390_kekl_pair *ext_kekls)
+{
+	struct tape_request *request;
+	struct tape3592_kekl_set_order *order;
+
+	DBF_EVENT(6, "tape3592_kekl_set\n");
+	if (check_ext_kekl_pair(ext_kekls)) {
+		DBF_EVENT(6, "invalid kekls\n");
+		return -EINVAL;
+	}
+	if (tape_3590_mttell(device, 0) != 0)
+		return -EBADSLT;
+	request = tape_alloc_request(1, sizeof(*order));
+	if (IS_ERR(request))
+		return PTR_ERR(request);
+	order = request->cpdata;
+	memset(order, 0, sizeof(*order));
+	order->code = 0xe3;
+	order->kekls.count = 2;
+	ext_to_int_kekl(&ext_kekls->kekl[0], &order->kekls.kekl[0]);
+	ext_to_int_kekl(&ext_kekls->kekl[1], &order->kekls.kekl[1]);
+	request->op = TO_KEKL_SET;
+	tape_ccw_end(request->cpaddr, PERF_SUBSYS_FUNC, sizeof(*order), order);
+
+	return tape_do_io_free(device, request);
+}
+
+/*
+ * IOCTL: Set KEKLs
+ */
+static int tape_3592_ioctl_kekl_set(struct tape_device *device,
+				    unsigned long arg)
+{
+	int rc;
+	struct tape390_kekl_pair *ext_kekls;
+
+	DBF_EVENT(6, "tape_3592_ioctl_kekl_set\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	if (!crypt_enabled(device))
+		return -EUNATCH;
+	ext_kekls = kmalloc(sizeof(*ext_kekls), GFP_KERNEL);
+	if (!ext_kekls)
+		return -ENOMEM;
+	if (copy_from_user(ext_kekls, (char __user *)arg, sizeof(*ext_kekls))) {
+		rc = -EFAULT;
+		goto out;
+	}
+	rc = tape_3592_kekl_set(device, ext_kekls);
+out:
+	kfree(ext_kekls);
+	return rc;
+}
+
+/*
+ * Enable encryption
+ */
+static int tape_3592_enable_crypt(struct tape_device *device)
+{
+	struct tape_request *request;
+	char *data;
+
+	DBF_EVENT(6, "tape_3592_enable_crypt\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	request = tape_alloc_request(2, 72);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
+	data = request->cpdata;
+	memset(data,0,72);
+
+	data[0]       = 0x05;
+	data[36 + 0]  = 0x03;
+	data[36 + 1]  = 0x03;
+	data[36 + 4]  = 0x40;
+	data[36 + 6]  = 0x01;
+	data[36 + 14] = 0x2f;
+	data[36 + 18] = 0xc3;
+	data[36 + 35] = 0x72;
+	request->op = TO_CRYPT_ON;
+	tape_ccw_cc(request->cpaddr, MODE_SET_CB, 36, data);
+	tape_ccw_end(request->cpaddr + 1, MODE_SET_CB, 36, data + 36);
+	return tape_do_io_free(device, request);
+}
+
+/*
+ * Disable encryption
+ */
+static int tape_3592_disable_crypt(struct tape_device *device)
+{
+	struct tape_request *request;
+	char *data;
+
+	DBF_EVENT(6, "tape_3592_disable_crypt\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	request = tape_alloc_request(2, 72);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
+	data = request->cpdata;
+	memset(data,0,72);
+
+	data[0]       = 0x05;
+	data[36 + 0]  = 0x03;
+	data[36 + 1]  = 0x03;
+	data[36 + 35] = 0x32;
+
+	request->op = TO_CRYPT_OFF;
+	tape_ccw_cc(request->cpaddr, MODE_SET_CB, 36, data);
+	tape_ccw_end(request->cpaddr + 1, MODE_SET_CB, 36, data + 36);
+
+	return tape_do_io_free(device, request);
+}
+
+/*
+ * IOCTL: Set encryption status
+ */
+static int tape_3592_ioctl_crypt_set(struct tape_device *device,
+				     unsigned long arg)
+{
+	struct tape390_crypt_info info;
+
+	DBF_EVENT(6, "tape_3592_ioctl_crypt_set\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	if (copy_from_user(&info, (char __user *)arg, sizeof(info)))
+		return -EFAULT;
+	if (info.status & ~TAPE390_CRYPT_ON_MASK)
+		return -EINVAL;
+	if (info.status & TAPE390_CRYPT_ON_MASK)
+		return tape_3592_enable_crypt(device);
+	else
+		return tape_3592_disable_crypt(device);
+}
+
+static int tape_3590_sense_medium(struct tape_device *device);
+
+/*
+ * IOCTL: Query enryption status
+ */
+static int tape_3592_ioctl_crypt_query(struct tape_device *device,
+				       unsigned long arg)
+{
+	DBF_EVENT(6, "tape_3592_ioctl_crypt_query\n");
+	if (!crypt_supported(device))
+		return -ENOSYS;
+	tape_3590_sense_medium(device);
+	if (copy_to_user((char __user *) arg, &TAPE_3590_CRYPT_INFO(device),
+		sizeof(TAPE_3590_CRYPT_INFO(device))))
+		return -EFAULT;
+	else
+		return 0;
+}
+
 /*
  * 3590 IOCTL Overload
  */
@@ -109,6 +436,14 @@ tape_3590_ioctl(struct tape_device *devi
 
 		return tape_std_display(device, &disp);
 	}
+	case TAPE390_KEKL_SET:
+		return tape_3592_ioctl_kekl_set(device, arg);
+	case TAPE390_KEKL_QUERY:
+		return tape_3592_ioctl_kekl_query(device, arg);
+	case TAPE390_CRYPT_SET:
+		return tape_3592_ioctl_crypt_set(device, arg);
+	case TAPE390_CRYPT_QUERY:
+		return tape_3592_ioctl_crypt_query(device, arg);
 	default:
 		return -EINVAL;	/* no additional ioctls */
 	}
@@ -248,6 +583,12 @@ tape_3590_work_handler(struct work_struc
 	case TO_READ_ATTMSG:
 		tape_3590_read_attmsg(p->device);
 		break;
+	case TO_CRYPT_ON:
+		tape_3592_enable_crypt(p->device);
+		break;
+	case TO_CRYPT_OFF:
+		tape_3592_disable_crypt(p->device);
+		break;
 	default:
 		DBF_EVENT(3, "T3590: work handler undefined for "
 			  "operation 0x%02x\n", p->op);
@@ -365,6 +706,33 @@ tape_3590_check_locate(struct tape_devic
 }
 #endif
 
+static void tape_3590_med_state_set(struct tape_device *device,
+				    struct tape_3590_med_sense *sense)
+{
+	struct tape390_crypt_info *c_info;
+
+	c_info = &TAPE_3590_CRYPT_INFO(device);
+
+	if (sense->masst == MSENSE_UNASSOCIATED) {
+		tape_med_state_set(device, MS_UNLOADED);
+		TAPE_3590_CRYPT_INFO(device).medium_status = 0;
+		return;
+	}
+	if (sense->masst != MSENSE_ASSOCIATED_MOUNT) {
+		PRINT_ERR("Unknown medium state: %x\n", sense->masst);
+		return;
+	}
+	tape_med_state_set(device, MS_LOADED);
+	c_info->medium_status |= TAPE390_MEDIUM_LOADED_MASK;
+	if (sense->flags & MSENSE_CRYPT_MASK) {
+		PRINT_INFO("Medium is encrypted (%04x)\n", sense->flags);
+		c_info->medium_status |= TAPE390_MEDIUM_ENCRYPTED_MASK;
+	} else	{
+		DBF_EVENT(6, "Medium is not encrypted %04x\n", sense->flags);
+		c_info->medium_status &= ~TAPE390_MEDIUM_ENCRYPTED_MASK;
+	}
+}
+
 /*
  * The done handler is called at device/channel end and wakes up the sleeping
  * process
@@ -372,9 +740,10 @@ tape_3590_check_locate(struct tape_devic
 static int
 tape_3590_done(struct tape_device *device, struct tape_request *request)
 {
-	struct tape_3590_med_sense *sense;
+	struct tape_3590_disc_data *disc_data;
 
 	DBF_EVENT(6, "%s done\n", tape_op_verbose[request->op]);
+	disc_data = device->discdata;
 
 	switch (request->op) {
 	case TO_BSB:
@@ -394,13 +763,20 @@ tape_3590_done(struct tape_device *devic
 		break;
 	case TO_RUN:
 		tape_med_state_set(device, MS_UNLOADED);
+		tape_3590_schedule_work(device, TO_CRYPT_OFF);
 		break;
 	case TO_MSEN:
-		sense = (struct tape_3590_med_sense *) request->cpdata;
-		if (sense->masst == MSENSE_UNASSOCIATED)
-			tape_med_state_set(device, MS_UNLOADED);
-		if (sense->masst == MSENSE_ASSOCIATED_MOUNT)
-			tape_med_state_set(device, MS_LOADED);
+		tape_3590_med_state_set(device, request->cpdata);
+		break;
+	case TO_CRYPT_ON:
+		TAPE_3590_CRYPT_INFO(device).status
+			|= TAPE390_CRYPT_ON_MASK;
+		*(device->modeset_byte) |= 0x03;
+		break;
+	case TO_CRYPT_OFF:
+		TAPE_3590_CRYPT_INFO(device).status
+			&= ~TAPE390_CRYPT_ON_MASK;
+		*(device->modeset_byte) &= ~0x03;
 		break;
 	case TO_RBI:	/* RBI seems to succeed even without medium loaded. */
 	case TO_NOP:	/* Same to NOP. */
@@ -409,8 +785,9 @@ tape_3590_done(struct tape_device *devic
 	case TO_DIS:
 	case TO_ASSIGN:
 	case TO_UNASSIGN:
-		break;
 	case TO_SIZE:
+	case TO_KEKL_SET:
+	case TO_KEKL_QUERY:
 		break;
 	}
 	return TAPE_IO_SUCCESS;
@@ -540,10 +917,8 @@ static int
 tape_3590_erp_long_busy(struct tape_device *device,
 			struct tape_request *request, struct irb *irb)
 {
-	/* FIXME: how about WAITING for a minute ? */
-	PRINT_WARN("(%s): Device is busy! Please wait a minute!\n",
-		   device->cdev->dev.bus_id);
-	return tape_3590_erp_basic(device, request, irb, -EBUSY);
+	DBF_EVENT(6, "Device is busy\n");
+	return TAPE_IO_LONG_BUSY;
 }
 
 /*
@@ -951,6 +1326,34 @@ tape_3590_print_era_msg(struct tape_devi
 		   device->cdev->dev.bus_id, sense->mc);
 }
 
+static int tape_3590_crypt_error(struct tape_device *device,
+				 struct tape_request *request, struct irb *irb)
+{
+	u8 cu_rc, ekm_rc1;
+	u16 ekm_rc2;
+	u32 drv_rc;
+	char *bus_id, *sense;
+
+	sense = ((struct tape_3590_sense *) irb->ecw)->fmt.data;
+	bus_id = device->cdev->dev.bus_id;
+	cu_rc = sense[0];
+	drv_rc = *((u32*) &sense[5]) & 0xffffff;
+	ekm_rc1 = sense[9];
+	ekm_rc2 = *((u16*) &sense[10]);
+	if ((cu_rc == 0) && (ekm_rc2 == 0xee31))
+		/* key not defined on EKM */
+		return tape_3590_erp_basic(device, request, irb, -EKEYREJECTED);
+	if ((cu_rc == 1) || (cu_rc == 2))
+		/* No connection to EKM */
+		return tape_3590_erp_basic(device, request, irb, -ENOTCONN);
+
+	PRINT_ERR("(%s): Unable to get encryption key from EKM\n", bus_id);
+	PRINT_ERR("(%s): CU=%02X DRIVE=%06X EKM=%02X:%04X\n", bus_id, cu_rc,
+		drv_rc, ekm_rc1, ekm_rc2);
+
+	return tape_3590_erp_basic(device, request, irb, -ENOKEY);
+}
+
 /*
  *  3590 error Recovery routine:
  *  If possible, it tries to recover from the error. If this is not possible,
@@ -979,6 +1382,8 @@ tape_3590_unit_check(struct tape_device 
 
 	sense = (struct tape_3590_sense *) irb->ecw;
 
+	DBF_EVENT(6, "Unit Check: RQC = %x\n", sense->rc_rqc);
+
 	/*
 	 * First check all RC-QRCs where we want to do something special
 	 *   - "break":     basic error recovery is done
@@ -999,6 +1404,8 @@ tape_3590_unit_check(struct tape_device 
 	case 0x2231:
 		tape_3590_print_era_msg(device, irb);
 		return tape_3590_erp_special_interrupt(device, request, irb);
+	case 0x2240:
+		return tape_3590_crypt_error(device, request, irb);
 
 	case 0x3010:
 		DBF_EVENT(2, "(%08x): Backward at Beginning of Partition\n",
@@ -1020,6 +1427,7 @@ tape_3590_unit_check(struct tape_device 
 		DBF_EVENT(2, "(%08x): Rewind Unload complete\n",
 			  device->cdev_id);
 		tape_med_state_set(device, MS_UNLOADED);
+		tape_3590_schedule_work(device, TO_CRYPT_OFF);
 		return tape_3590_erp_basic(device, request, irb, 0);
 
 	case 0x4010:
@@ -1030,9 +1438,15 @@ tape_3590_unit_check(struct tape_device 
 		PRINT_WARN("(%s): Tape operation when medium not loaded\n",
 			   device->cdev->dev.bus_id);
 		tape_med_state_set(device, MS_UNLOADED);
+		tape_3590_schedule_work(device, TO_CRYPT_OFF);
 		return tape_3590_erp_basic(device, request, irb, -ENOMEDIUM);
 	case 0x4012:		/* Device Long Busy */
+		/* XXX: Also use long busy handling here? */
+		DBF_EVENT(6, "(%08x): LONG BUSY\n", device->cdev_id);
 		tape_3590_print_era_msg(device, irb);
+		return tape_3590_erp_basic(device, request, irb, -EBUSY);
+	case 0x4014:
+		DBF_EVENT(6, "(%08x): Crypto LONG BUSY\n", device->cdev_id);
 		return tape_3590_erp_long_busy(device, request, irb);
 
 	case 0x5010:
@@ -1064,6 +1478,7 @@ tape_3590_unit_check(struct tape_device 
 	case 0x5120:
 	case 0x1120:
 		tape_med_state_set(device, MS_UNLOADED);
+		tape_3590_schedule_work(device, TO_CRYPT_OFF);
 		return tape_3590_erp_basic(device, request, irb, -ENOMEDIUM);
 
 	case 0x6020:
@@ -1142,21 +1557,47 @@ tape_3590_setup_device(struct tape_devic
 {
 	int rc;
 	struct tape_3590_disc_data *data;
+	char *rdc_data;
 
 	DBF_EVENT(6, "3590 device setup\n");
-	data = kmalloc(sizeof(struct tape_3590_disc_data),
-		       GFP_KERNEL | GFP_DMA);
+	data = kzalloc(sizeof(struct tape_3590_disc_data), GFP_KERNEL | GFP_DMA);
 	if (data == NULL)
 		return -ENOMEM;
 	data->read_back_op = READ_PREVIOUS;
 	device->discdata = data;
 
-	if ((rc = tape_std_assign(device)) == 0) {
-		/* Try to find out if medium is loaded */
-		if ((rc = tape_3590_sense_medium(device)) != 0)
-			DBF_LH(3, "3590 medium sense returned %d\n", rc);
+	rdc_data = kmalloc(64, GFP_KERNEL | GFP_DMA);
+	if (!rdc_data) {
+		rc = -ENOMEM;
+		goto fail_kmalloc;
+	}
+	rc = read_dev_chars(device->cdev, (void**)&rdc_data, 64);
+	if (rc) {
+		DBF_LH(3, "Read device characteristics failed!\n");
+		goto fail_kmalloc;
+	}
+	rc = tape_std_assign(device);
+	if (rc)
+		goto fail_rdc_data;
+	if (rdc_data[31] == 0x13) {
+		PRINT_INFO("Device has crypto support\n");
+		data->crypt_info.capability |= TAPE390_CRYPT_SUPPORTED_MASK;
+		tape_3592_disable_crypt(device);
+	} else {
+		DBF_EVENT(6, "Device has NO crypto support\n");
 	}
+	/* Try to find out if medium is loaded */
+	rc = tape_3590_sense_medium(device);
+	if (rc) {
+		DBF_LH(3, "3590 medium sense returned %d\n", rc);
+		goto fail_rdc_data;
+	}
+	return 0;
 
+fail_rdc_data:
+	kfree(rdc_data);
+fail_kmalloc:
+	kfree(data);
 	return rc;
 }
 
diff -urpN linux-2.6/drivers/s390/char/tape_3590.h linux-2.6-patched/drivers/s390/char/tape_3590.h
--- linux-2.6/drivers/s390/char/tape_3590.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_3590.h	2007-01-26 17:29:34.000000000 +0100
@@ -2,7 +2,7 @@
  *  drivers/s390/char/tape_3590.h
  *    tape device discipline for 3590 tapes.
  *
- *    Copyright (C) IBM Corp. 2001,2006
+ *    Copyright IBM Corp. 2001,2006
  *    Author(s): Stefan Bader <shbader@de.ibm.com>
  *		 Michael Holzheu <holzheu@de.ibm.com>
  *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
@@ -38,16 +38,22 @@
 #define MSENSE_UNASSOCIATED	 0x00
 #define MSENSE_ASSOCIATED_MOUNT	 0x01
 #define MSENSE_ASSOCIATED_UMOUNT 0x02
+#define MSENSE_CRYPT_MASK	 0x00000010
 
 #define TAPE_3590_MAX_MSG	 0xb0
 
 /* Datatypes */
 
 struct tape_3590_disc_data {
-	unsigned char modeset_byte;
+	struct tape390_crypt_info crypt_info;
 	int read_back_op;
 };
 
+#define TAPE_3590_CRYPT_INFO(device) \
+	((struct tape_3590_disc_data*)(device->discdata))->crypt_info
+#define TAPE_3590_READ_BACK_OP(device) \
+	((struct tape_3590_disc_data*)(device->discdata))->read_back_op
+
 struct tape_3590_sense {
 
 	unsigned int command_rej:1;
@@ -118,7 +124,48 @@ struct tape_3590_sense {
 struct tape_3590_med_sense {
 	unsigned int macst:4;
 	unsigned int masst:4;
-	char pad[127];
+	char pad1[7];
+	unsigned int flags;
+	char pad2[116];
+} __attribute__ ((packed));
+
+/* Datastructures for 3592 encryption support */
+
+struct tape3592_kekl {
+	__u8 flags;
+	char label[64];
+} __attribute__ ((packed));
+
+struct tape3592_kekl_pair {
+	__u8 count;
+	struct tape3592_kekl kekl[2];
+} __attribute__ ((packed));
+
+struct tape3592_kekl_query_data {
+	__u16 len;
+	__u8  fmt;
+	__u8  mc;
+	__u32 id;
+	__u8  flags;
+	struct tape3592_kekl_pair kekls;
+	char reserved[116];
+} __attribute__ ((packed));
+
+struct tape3592_kekl_query_order {
+	__u8 code;
+	__u8 flags;
+	char reserved1[2];
+	__u8 max_count;
+	char reserved2[35];
+} __attribute__ ((packed));
+
+struct tape3592_kekl_set_order {
+	__u8 code;
+	__u8 flags;
+	char reserved1[2];
+	__u8 op;
+	struct tape3592_kekl_pair kekls;
+	char reserved2[120];
 } __attribute__ ((packed));
 
 #endif /* _TAPE_3590_H */
diff -urpN linux-2.6/drivers/s390/char/tape_char.c linux-2.6-patched/drivers/s390/char/tape_char.c
--- linux-2.6/drivers/s390/char/tape_char.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_char.c	2007-01-26 17:29:34.000000000 +0100
@@ -3,7 +3,7 @@
  *    character device frontend for tape device driver
  *
  *  S390 and zSeries version
- *    Copyright (C) 2001,2002 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 2001,2006
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *		 Michael Holzheu <holzheu@de.ibm.com>
  *		 Tuan Ngo-Anh <ngoanh@de.ibm.com>
diff -urpN linux-2.6/drivers/s390/char/tape_core.c linux-2.6-patched/drivers/s390/char/tape_core.c
--- linux-2.6/drivers/s390/char/tape_core.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_core.c	2007-01-26 17:29:34.000000000 +0100
@@ -3,7 +3,7 @@
  *    basic function of the tape device driver
  *
  *  S390 and zSeries version
- *    Copyright (C) 2001,2005 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 2001,2006
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *		 Michael Holzheu <holzheu@de.ibm.com>
  *		 Tuan Ngo-Anh <ngoanh@de.ibm.com>
@@ -26,9 +26,11 @@
 #include "tape_std.h"
 
 #define PRINTK_HEADER "TAPE_CORE: "
+#define LONG_BUSY_TIMEOUT 180 /* seconds */
 
 static void __tape_do_irq (struct ccw_device *, unsigned long, struct irb *);
 static void tape_delayed_next_request(struct work_struct *);
+static void tape_long_busy_timeout(unsigned long data);
 
 /*
  * One list to contain all tape devices of all disciplines, so
@@ -69,7 +71,9 @@ const char *tape_op_verbose[TO_SIZE] =
 	[TO_LOAD] = "LOA",	[TO_READ_CONFIG] = "RCF",
 	[TO_READ_ATTMSG] = "RAT",
 	[TO_DIS] = "DIS",	[TO_ASSIGN] = "ASS",
-	[TO_UNASSIGN] = "UAS"
+	[TO_UNASSIGN] = "UAS",  [TO_CRYPT_ON] = "CON",
+	[TO_CRYPT_OFF] = "COF",	[TO_KEKL_SET] = "KLS",
+	[TO_KEKL_QUERY] = "KLQ",
 };
 
 static inline int
@@ -346,6 +350,9 @@ tape_generic_online(struct tape_device *
 		return -EINVAL;
 	}
 
+	init_timer(&device->lb_timeout);
+	device->lb_timeout.function = tape_long_busy_timeout;
+
 	/* Let the discipline have a go at the device. */
 	device->discipline = discipline;
 	if (!try_module_get(discipline->owner)) {
@@ -801,6 +808,22 @@ tape_delayed_next_request(struct work_st
 	spin_unlock_irq(get_ccwdev_lock(device->cdev));
 }
 
+static void tape_long_busy_timeout(unsigned long data)
+{
+	struct tape_request *request;
+	struct tape_device *device;
+
+	device = (struct tape_device *) data;
+	spin_lock_irq(get_ccwdev_lock(device->cdev));
+	request = list_entry(device->req_queue.next, struct tape_request, list);
+	if (request->status != TAPE_REQUEST_LONG_BUSY)
+		BUG();
+	DBF_LH(6, "%08x: Long busy timeout.\n", device->cdev_id);
+	__tape_start_next_request(device);
+	device->lb_timeout.data = (unsigned long) tape_put_device(device);
+	spin_unlock_irq(get_ccwdev_lock(device->cdev));
+}
+
 static inline void
 __tape_end_request(
 	struct tape_device *	device,
@@ -1094,7 +1117,22 @@ __tape_do_irq (struct ccw_device *cdev, 
 	/* May be an unsolicited irq */
 	if(request != NULL)
 		request->rescnt = irb->scsw.count;
-
+	else if ((irb->scsw.dstat == 0x85 || irb->scsw.dstat == 0x80) &&
+		 !list_empty(&device->req_queue)) {
+		/* Not Ready to Ready after long busy ? */
+		struct tape_request *req;
+		req = list_entry(device->req_queue.next,
+				 struct tape_request, list);
+		if (req->status == TAPE_REQUEST_LONG_BUSY) {
+			DBF_EVENT(3, "(%08x): del timer\n", device->cdev_id);
+			if (del_timer(&device->lb_timeout)) {
+				device->lb_timeout.data = (unsigned long)
+					tape_put_device(device);
+				__tape_start_next_request(device);
+			}
+			return;
+		}
+	}
 	if (irb->scsw.dstat != 0x0c) {
 		/* Set the 'ONLINE' flag depending on sense byte 1 */
 		if(*(((__u8 *) irb->ecw) + 1) & SENSE_DRIVE_ONLINE)
@@ -1142,6 +1180,15 @@ __tape_do_irq (struct ccw_device *cdev, 
 			break;
 		case TAPE_IO_PENDING:
 			break;
+		case TAPE_IO_LONG_BUSY:
+			device->lb_timeout.data =
+				(unsigned long)tape_get_device_reference(device);
+			device->lb_timeout.expires = jiffies +
+				LONG_BUSY_TIMEOUT * HZ;
+			DBF_EVENT(3, "(%08x): add timer\n", device->cdev_id);
+			add_timer(&device->lb_timeout);
+			request->status = TAPE_REQUEST_LONG_BUSY;
+			break;
 		case TAPE_IO_RETRY:
 			rc = __tape_start_io(device, request);
 			if (rc)
diff -urpN linux-2.6/drivers/s390/char/tape.h linux-2.6-patched/drivers/s390/char/tape.h
--- linux-2.6/drivers/s390/char/tape.h	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape.h	2007-01-26 17:29:34.000000000 +0100
@@ -3,7 +3,7 @@
  *    tape device driver for 3480/3490E/3590 tapes.
  *
  *  S390 and zSeries version
- *    Copyright (C) 2001,2005 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 2001,2006
  *    Author(s): Carsten Otte <cotte@de.ibm.com>
  *		 Tuan Ngo-Anh <ngoanh@de.ibm.com>
  *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
@@ -99,7 +99,11 @@ enum tape_op {
 	TO_DIS,		/* Tape display */
 	TO_ASSIGN,	/* Assign tape to channel path */
 	TO_UNASSIGN,	/* Unassign tape from channel path */
-	TO_SIZE		/* #entries in tape_op_t */
+	TO_CRYPT_ON,	/* Enable encrpytion */
+	TO_CRYPT_OFF,	/* Disable encrpytion */
+	TO_KEKL_SET,	/* Set KEK label */
+	TO_KEKL_QUERY,	/* Query KEK label */
+	TO_SIZE,	/* #entries in tape_op_t */
 };
 
 /* Forward declaration */
@@ -112,6 +116,7 @@ enum tape_request_status {
 	TAPE_REQUEST_IN_IO,	/* request is currently in IO */
 	TAPE_REQUEST_DONE,	/* request is completed. */
 	TAPE_REQUEST_CANCEL,	/* request should be canceled. */
+	TAPE_REQUEST_LONG_BUSY, /* request has to be restarted after long busy */
 };
 
 /* Tape CCW request */
@@ -164,10 +169,11 @@ struct tape_discipline {
  * The discipline irq function either returns an error code (<0) which
  * means that the request has failed with an error or one of the following:
  */
-#define TAPE_IO_SUCCESS 0	/* request successful */
-#define TAPE_IO_PENDING 1	/* request still running */
-#define TAPE_IO_RETRY	2	/* retry to current request */
-#define TAPE_IO_STOP	3	/* stop the running request */
+#define TAPE_IO_SUCCESS		0	/* request successful */
+#define TAPE_IO_PENDING		1	/* request still running */
+#define TAPE_IO_RETRY		2	/* retry to current request */
+#define TAPE_IO_STOP		3	/* stop the running request */
+#define TAPE_IO_LONG_BUSY	4	/* delay the running request */
 
 /* Char Frontend Data */
 struct tape_char_data {
@@ -242,6 +248,10 @@ struct tape_device {
 
 	/* Function to start or stop the next request later. */
 	struct delayed_work		tape_dnr;
+
+	/* Timer for long busy */
+	struct timer_list		lb_timeout;
+
 };
 
 /* Externals from tape_core.c */
diff -urpN linux-2.6/include/asm-s390/tape390.h linux-2.6-patched/include/asm-s390/tape390.h
--- linux-2.6/include/asm-s390/tape390.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/tape390.h	2007-01-26 17:29:34.000000000 +0100
@@ -1,11 +1,11 @@
 /*************************************************************************
  *
  * tape390.h
- *         enables user programs to display messages on the tape device
+ *	   enables user programs to display messages and control encryption
+ *	   on s390 tape devices
  *
- *  S390 and zSeries version
- *         Copyright (C) 2001 IBM Corporation
- *         Author(s): Despina Papadopoulou <despina_p@de.ibm.com>
+ *	   Copyright IBM Corp. 2001,2006
+ *	   Author(s): Michael Holzheu <holzheu@de.ibm.com>
  *
  *************************************************************************/
 
@@ -36,4 +36,68 @@ typedef struct display_struct {
         char message2[8];
 } display_struct;
 
+/*
+ * Tape encryption support
+ */
+
+struct tape390_crypt_info {
+	char capability;
+	char status;
+	char medium_status;
+} __attribute__ ((packed));
+
+
+/* Macros for "capable" field */
+#define TAPE390_CRYPT_SUPPORTED_MASK 0x01
+#define TAPE390_CRYPT_SUPPORTED(x) \
+	((x.capability & TAPE390_CRYPT_SUPPORTED_MASK))
+
+/* Macros for "status" field */
+#define TAPE390_CRYPT_ON_MASK 0x01
+#define TAPE390_CRYPT_ON(x) (((x.status) & TAPE390_CRYPT_ON_MASK))
+
+/* Macros for "medium status" field */
+#define TAPE390_MEDIUM_LOADED_MASK 0x01
+#define TAPE390_MEDIUM_ENCRYPTED_MASK 0x02
+#define TAPE390_MEDIUM_ENCRYPTED(x) \
+	(((x.medium_status) & TAPE390_MEDIUM_ENCRYPTED_MASK))
+#define TAPE390_MEDIUM_LOADED(x) \
+	(((x.medium_status) & TAPE390_MEDIUM_LOADED_MASK))
+
+/*
+ * The TAPE390_CRYPT_SET ioctl is used to switch on/off encryption.
+ * The "encryption_capable" and "tape_status" fields are ignored for this ioctl!
+ */
+#define TAPE390_CRYPT_SET _IOW('d', 2, struct tape390_crypt_info)
+
+/*
+ * The TAPE390_CRYPT_QUERY ioctl is used to query the encryption state.
+ */
+#define TAPE390_CRYPT_QUERY _IOR('d', 3, struct tape390_crypt_info)
+
+/* Values for "kekl1/2_type" and "kekl1/2_type_on_tape" fields */
+#define TAPE390_KEKL_TYPE_NONE 0
+#define TAPE390_KEKL_TYPE_LABEL 1
+#define TAPE390_KEKL_TYPE_HASH 2
+
+struct tape390_kekl {
+	unsigned char type;
+	unsigned char type_on_tape;
+	char label[65];
+} __attribute__ ((packed));
+
+struct tape390_kekl_pair {
+	struct tape390_kekl kekl[2];
+} __attribute__ ((packed));
+
+/*
+ * The TAPE390_KEKL_SET ioctl is used to set Key Encrypting Key labels.
+ */
+#define TAPE390_KEKL_SET _IOW('d', 4, struct tape390_kekl_pair)
+
+/*
+ * The TAPE390_KEKL_QUERY ioctl is used to query Key Encrypting Key labels.
+ */
+#define TAPE390_KEKL_QUERY _IOR('d', 5, struct tape390_kekl_pair)
+
 #endif 
