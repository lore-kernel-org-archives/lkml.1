Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXJLQry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXJLQry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbXJLQr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:47:29 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:62427 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXJLQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:47:28 -0400
Date: Fri, 12 Oct 2007 11:44:18 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 7/7] IPMI: add 0.9 support
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Stian Jordet <liste@jordet.net>
Reply-to: minyard@acm.org
Message-id: <20071012164418.GG22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

Add support for IPMI 0.9 systems to the IPMI driver.  Just handle
a shorter get device ID command with less information.

Not needed for the stable kernel.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Stian Jordet <liste@jordet.net>

Index: linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.22.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
@@ -2378,20 +2378,9 @@ static int try_get_dev_id(struct smi_inf
 	/* Otherwise, we got some data. */
 	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
 						  resp, IPMI_MAX_MSG_LENGTH);
-	if (resp_len < 14) {
-		/* That's odd, it should be longer. */
-		rv = -EINVAL;
-		goto out;
-	}
-
-	if ((resp[1] != IPMI_GET_DEVICE_ID_CMD) || (resp[2] != 0)) {
-		/* That's odd, it shouldn't be able to fail. */
-		rv = -EINVAL;
-		goto out;
-	}
 
-	/* Record info from the get device id, in case we need it. */
-	ipmi_demangle_device_id(resp+3, resp_len-3, &smi_info->device_id);
+	/* Check and record info from the get device id, in case we need it. */
+	rv = ipmi_demangle_device_id(resp, resp_len, &smi_info->device_id);
 
  out:
 	kfree(resp);
Index: linux-2.6.22/include/linux/ipmi_smi.h
===================================================================
--- linux-2.6.22.orig/include/linux/ipmi_smi.h
+++ linux-2.6.22/include/linux/ipmi_smi.h
@@ -148,26 +148,46 @@ struct ipmi_device_id {
 
 /* Take a pointer to a raw data buffer and a length and extract device
    id information from it.  The first byte of data must point to the
-   byte from the get device id response after the completion code.
-   The caller is responsible for making sure the length is at least
-   11 and the command completed without error. */
-static inline void ipmi_demangle_device_id(unsigned char *data,
-					   unsigned int  data_len,
-					   struct ipmi_device_id *id)
+   netfn << 2, the data should be of the format:
+      netfn << 2, cmd, completion code, data
+   as normally comes from a device interface. */
+static inline int ipmi_demangle_device_id(const unsigned char *data,
+					  unsigned int data_len,
+					  struct ipmi_device_id *id)
 {
+	if (data_len < 9)
+		return -EINVAL;
+	if (data[0] != IPMI_NETFN_APP_RESPONSE << 2 ||
+	    data[1] != IPMI_GET_DEVICE_ID_CMD)
+		/* Strange, didn't get the response we expected. */
+		return -EINVAL;
+	if (data[2] != 0)
+		/* That's odd, it shouldn't be able to fail. */
+		return -EINVAL;
+
+	data += 3;
+	data_len -= 3;
 	id->device_id = data[0];
 	id->device_revision = data[1];
 	id->firmware_revision_1 = data[2];
 	id->firmware_revision_2 = data[3];
 	id->ipmi_version = data[4];
 	id->additional_device_support = data[5];
-	id->manufacturer_id = data[6] | (data[7] << 8) | (data[8] << 16);
-	id->product_id = data[9] | (data[10] << 8);
+	if (data_len >= 6) {
+		id->manufacturer_id = (data[6] | (data[7] << 8) |
+				       (data[8] << 16));
+		id->product_id = data[9] | (data[10] << 8);
+	} else {
+		id->manufacturer_id = 0;
+		id->product_id = 0;
+	}
 	if (data_len >= 15) {
 		memcpy(id->aux_firmware_revision, data+11, 4);
 		id->aux_firmware_revision_set = 1;
 	} else
 		id->aux_firmware_revision_set = 0;
+
+	return 0;
 }
 
 /* Add a low-level interface to the IPMI driver.  Note that if the
