Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXEOXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXEOXBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbXEOXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:01:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49576 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbXEOXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:01:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 May 2007 01:01:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] ieee1394: raw1394: Fix write() for 32bit userland on
 64bit kernel
To: Petr Vandrovec <petr@vandrovec.name>
cc: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.0e3c053d4bae6087@s5r6.in-berlin.de>
Message-ID: <tkrat.35349e18fd1db577@s5r6.in-berlin.de>
References: <20070507021447.GA22197@vana.vc.cvut.cz>
 <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
 <tkrat.0e3c053d4bae6087@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 7 May 2007 04:14:47 +0200
From: Petr Vandrovec <petr@vandrovec.name>

* write(fd, buf, 52) from 32bit app was returning 56.  Most of callers did not
  care, but some (arm registration) did, and anyway it looks bad if request for
  writing 52 bytes returns 56.  And returning sizeof anything in 'int' is not
  good as well.  So all functions now return '0' instead of
  sizeof(struct raw1394_request) on success, and write() itself provides correct
  return value (it just returns value it was asked to write on success as raw1394
  does not do any partial writes at all).

* Related to this was problem that write() could have returned 0 when kernel
  state would become corrupted and moved to different state than
  opened/initialized/connected.  Now it returns -EBADFD which seemed appropriate.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Acked-by: Dan Dennedy <dan@dennedy.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (split into 3 patches)
---
 drivers/ieee1394/raw1394.c |   65 +++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

Index: linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/ieee1394/raw1394.c
+++ linux-2.6.22-rc1/drivers/ieee1394/raw1394.c
@@ -587,7 +587,7 @@ static int state_opened(struct file_info
 
 	req->req.length = 0;
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int state_initialized(struct file_info *fi, struct pending_request *req)
@@ -601,7 +601,7 @@ static int state_initialized(struct file
 		req->req.generation = atomic_read(&internal_generation);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -673,7 +673,7 @@ out_set_card:
 	}
 
 	queue_complete_req(req);
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static void handle_iso_listen(struct file_info *fi, struct pending_request *req)
@@ -865,7 +865,7 @@ static int handle_async_request(struct f
 	if (req->req.error) {
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	hpsb_set_packet_complete_task(packet,
@@ -883,7 +883,7 @@ static int handle_async_request(struct f
 		hpsb_free_tlabel(packet);
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_iso_send(struct file_info *fi, struct pending_request *req,
@@ -907,7 +907,7 @@ static int handle_iso_send(struct file_i
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	req->req.length = 0;
@@ -927,7 +927,7 @@ static int handle_iso_send(struct file_i
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int handle_async_send(struct file_info *fi, struct pending_request *req)
@@ -942,7 +942,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	packet = hpsb_alloc_packet(req->req.length - header_length);
@@ -955,7 +955,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	if (copy_from_user
@@ -964,7 +964,7 @@ static int handle_async_send(struct file
 		req->req.error = RAW1394_ERROR_MEMFAULT;
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	packet->type = hpsb_async;
@@ -992,7 +992,7 @@ static int handle_async_send(struct file
 		queue_complete_req(req);
 	}
 
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
@@ -1867,7 +1867,7 @@ static int arm_register(struct file_info
 		spin_lock_irqsave(&host_info_lock, flags);
 		list_add_tail(&addr->addr_list, &fi->addr_list);
 		spin_unlock_irqrestore(&host_info_lock, flags);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_register_addrspace(&raw1394_highlevel, fi->host, &arm_ops,
@@ -1885,7 +1885,7 @@ static int arm_register(struct file_info
 		return (-EALREADY);
 	}
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int arm_unregister(struct file_info *fi, struct pending_request *req)
@@ -1953,7 +1953,7 @@ static int arm_unregister(struct file_in
 		vfree(addr->addr_space_buffer);
 		kfree(addr);
 		free_pending_request(req);	/* immediate success or fail */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	retval =
 	    hpsb_unregister_addrspace(&raw1394_highlevel, fi->host,
@@ -1969,7 +1969,7 @@ static int arm_unregister(struct file_in
 	vfree(addr->addr_space_buffer);
 	kfree(addr);
 	free_pending_request(req);	/* immediate success or fail */
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 /* Copy data from ARM buffer(s) to user buffer. */
@@ -2011,7 +2011,7 @@ static int arm_get_buf(struct file_info 
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_get_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2063,7 +2063,7 @@ static int arm_set_buf(struct file_info 
 				 * queue no response, and therefore nobody
 				 * will free it. */
 				free_pending_request(req);
-				return sizeof(struct raw1394_request);
+				return 0;
 			} else {
 				DBGMSG("arm_set_buf request exceeded mapping");
 				spin_unlock_irqrestore(&host_info_lock, flags);
@@ -2084,7 +2084,7 @@ static int reset_notification(struct fil
 	    (req->req.misc == RAW1394_NOTIFY_ON)) {
 		fi->notification = (u8) req->req.misc;
 		free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 	/* error EINVAL (22) invalid argument */
 	return (-EINVAL);
@@ -2117,12 +2117,12 @@ static int write_phypacket(struct file_i
 		req->req.length = 0;
 		queue_complete_req(req);
 	}
-	return sizeof(struct raw1394_request);
+	return 0;
 }
 
 static int get_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	int status;
 
@@ -2152,7 +2152,7 @@ static int get_config_rom(struct file_in
 
 static int update_config_rom(struct file_info *fi, struct pending_request *req)
 {
-	int ret = sizeof(struct raw1394_request);
+	int ret = 0;
 	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -2219,7 +2219,7 @@ static int modify_config_rom(struct file
 
 			hpsb_update_config_rom_image(fi->host);
 			free_pending_request(req);
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 	}
 
@@ -2284,7 +2284,7 @@ static int modify_config_rom(struct file
 		/* we have to free the request, because we queue no response,
 		 * and therefore nobody will free it */
 		free_pending_request(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	} else {
 		for (dentry =
 		     fi->csr1212_dirs[dr]->value.directory.dentries_head;
@@ -2309,7 +2309,7 @@ static int state_connected(struct file_i
 
 	case RAW1394_REQ_ECHO:
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_ISO_SEND:
 		print_old_iso_deprecation();
@@ -2333,24 +2333,24 @@ static int state_connected(struct file_i
 	case RAW1394_REQ_ISO_LISTEN:
 		print_old_iso_deprecation();
 		handle_iso_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_FCP_LISTEN:
 		handle_fcp_listen(fi, req);
-		return sizeof(struct raw1394_request);
+		return 0;
 
 	case RAW1394_REQ_RESET_BUS:
 		if (req->req.misc == RAW1394_LONG_RESET) {
 			DBGMSG("busreset called (type: LONG)");
 			hpsb_reset_bus(fi->host, LONG_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		if (req->req.misc == RAW1394_SHORT_RESET) {
 			DBGMSG("busreset called (type: SHORT)");
 			hpsb_reset_bus(fi->host, SHORT_RESET);
 			free_pending_request(req);	/* we have to free the request, because we queue no response, and therefore nobody will free it */
-			return sizeof(struct raw1394_request);
+			return 0;
 		}
 		/* error EINVAL (22) invalid argument */
 		return (-EINVAL);
@@ -2369,7 +2369,7 @@ static int state_connected(struct file_i
 		req->req.generation = get_hpsb_generation(fi->host);
 		req->req.length = 0;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	switch (req->req.type) {
@@ -2382,7 +2382,7 @@ static int state_connected(struct file_i
 	if (req->req.length == 0) {
 		req->req.error = RAW1394_ERROR_INVALID_ARG;
 		queue_complete_req(req);
-		return sizeof(struct raw1394_request);
+		return 0;
 	}
 
 	return handle_async_request(fi, req, node);
@@ -2393,7 +2393,7 @@ static ssize_t raw1394_write(struct file
 {
 	struct file_info *fi = (struct file_info *)file->private_data;
 	struct pending_request *req;
-	ssize_t retval = 0;
+	ssize_t retval = -EBADFD;
 
 #ifdef CONFIG_COMPAT
 	if (count == sizeof(struct compat_raw1394_req) &&
@@ -2435,6 +2435,9 @@ static ssize_t raw1394_write(struct file
 
 	if (retval < 0) {
 		free_pending_request(req);
+	} else {
+		BUG_ON(retval);
+		retval = count;
 	}
 
 	return retval;

-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/

