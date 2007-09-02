Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXIBUFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXIBUFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIBUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:05:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbXIBUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:05:45 -0400
Date: Mon, 3 Sep 2007 01:48:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vvs@sw.ru>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [PATCH -mm] I2O: Fix "defined but not used" build warnings
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030146330.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1918062821-1188764335=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1918062821-1188764335=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/message/i2o/exec-osm.c:539: warning: ‘i2o_exec_lct_notify’ defined but not used

comes when CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=n, because its only callsite
is #ifdef'ed as such. So let's #ifdef the function definition also. Also
move the definition to before the callsite, to get rid of forward prototype.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

I have no clue who owns this subsystem, and recent git history is all
over the place.

 drivers/message/i2o/exec-osm.c |   94 ++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

--- linux-2.6.23-rc4-mm1/drivers/message/i2o/exec-osm.c~fix	2007-09-02 19:25:55.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/message/i2o/exec-osm.c	2007-09-02 19:25:07.000000000 +0530
@@ -41,8 +41,6 @@
 
 struct i2o_driver i2o_exec_driver;
 
-static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind);
-
 /* global wait list for POST WAIT */
 static LIST_HEAD(i2o_exec_wait_list);
 
@@ -369,6 +367,53 @@ static int i2o_exec_remove(struct device
 	return 0;
 };
 
+#ifdef CONFIG_I2O_LCT_NOTIFY_ON_CHANGES
+/**
+ *	i2o_exec_lct_notify - Send a asynchronus LCT NOTIFY request
+ *	@c: I2O controller to which the request should be send
+ *	@change_ind: change indicator
+ *
+ *	This function sends a LCT NOTIFY request to the I2O controller with
+ *	the change indicator change_ind. If the change_ind == 0 the controller
+ *	replies immediately after the request. If change_ind > 0 the reply is
+ *	send after change indicator of the LCT is > change_ind.
+ */
+static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
+{
+	i2o_status_block *sb = c->status_block.virt;
+	struct device *dev;
+	struct i2o_message *msg;
+
+	mutex_lock(&c->lct_lock);
+
+	dev = &c->pdev->dev;
+
+	if (i2o_dma_realloc
+	    (dev, &c->dlct, le32_to_cpu(sb->expected_lct_size), GFP_KERNEL))
+		return -ENOMEM;
+
+	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
+	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
+				     ADAPTER_TID);
+	msg->u.s.icntxt = cpu_to_le32(i2o_exec_driver.context);
+	msg->u.s.tcntxt = cpu_to_le32(0x00000000);
+	msg->body[0] = cpu_to_le32(0xffffffff);
+	msg->body[1] = cpu_to_le32(change_ind);
+	msg->body[2] = cpu_to_le32(0xd0000000 | c->dlct.len);
+	msg->body[3] = cpu_to_le32(c->dlct.phys);
+
+	i2o_msg_post(c, msg);
+
+	mutex_unlock(&c->lct_lock);
+
+	return 0;
+};
+#endif
+
 /**
  *	i2o_exec_lct_modified - Called on LCT NOTIFY reply
  *	@_work: work struct for a specific controller
@@ -525,51 +570,6 @@ int i2o_exec_lct_get(struct i2o_controll
 	return rc;
 }
 
-/**
- *	i2o_exec_lct_notify - Send a asynchronus LCT NOTIFY request
- *	@c: I2O controller to which the request should be send
- *	@change_ind: change indicator
- *
- *	This function sends a LCT NOTIFY request to the I2O controller with
- *	the change indicator change_ind. If the change_ind == 0 the controller
- *	replies immediately after the request. If change_ind > 0 the reply is
- *	send after change indicator of the LCT is > change_ind.
- */
-static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
-{
-	i2o_status_block *sb = c->status_block.virt;
-	struct device *dev;
-	struct i2o_message *msg;
-
-	mutex_lock(&c->lct_lock);
-
-	dev = &c->pdev->dev;
-
-	if (i2o_dma_realloc
-	    (dev, &c->dlct, le32_to_cpu(sb->expected_lct_size), GFP_KERNEL))
-		return -ENOMEM;
-
-	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
-	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
-				     ADAPTER_TID);
-	msg->u.s.icntxt = cpu_to_le32(i2o_exec_driver.context);
-	msg->u.s.tcntxt = cpu_to_le32(0x00000000);
-	msg->body[0] = cpu_to_le32(0xffffffff);
-	msg->body[1] = cpu_to_le32(change_ind);
-	msg->body[2] = cpu_to_le32(0xd0000000 | c->dlct.len);
-	msg->body[3] = cpu_to_le32(c->dlct.phys);
-
-	i2o_msg_post(c, msg);
-
-	mutex_unlock(&c->lct_lock);
-
-	return 0;
-};
-
 /* Exec OSM driver struct */
 struct i2o_driver i2o_exec_driver = {
 	.name = OSM_NAME,
--464262402-1918062821-1188764335=:29617--
