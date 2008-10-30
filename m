Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYJ3SQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYJ3SQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYJ3SP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:15:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:47885 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbYJ3SP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:15:58 -0400
Subject: sgi: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 19:15:59 +0100
Message-Id: <1225390559.21973.33.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: SGI: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Jack Steiner <steiner@sgi.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index e11e1ac..3d2fc21 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -29,7 +29,7 @@ static struct device_driver gru_driver = {
 };
 
 static struct device gru_device = {
-	.bus_id = {0},
+	.init_name = "",
 	.driver = &gru_driver,
 };
 
diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 66a1d19..5bd6d44 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -25,7 +25,7 @@ struct device_driver xp_dbg_name = {
 };
 
 struct device xp_dbg_subname = {
-	.bus_id = {0},		/* set to "" */
+	.init_name = "",		/* set to "" */
 	.driver = &xp_dbg_name
 };
 
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 46325fc..bc4620f 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -59,12 +59,12 @@ struct device_driver xpc_dbg_name = {
 };
 
 struct device xpc_part_dbg_subname = {
-	.bus_id = {0},		/* set to "part" at xpc_init() time */
+	.init_name = "",	/* set to "part" at xpc_init() time */
 	.driver = &xpc_dbg_name
 };
 
 struct device xpc_chan_dbg_subname = {
-	.bus_id = {0},		/* set to "chan" at xpc_init() time */
+	.init_name = "",	/* set to "chan" at xpc_init() time */
 	.driver = &xpc_dbg_name
 };
 
@@ -1258,8 +1258,8 @@ xpc_init(void)
 	int ret;
 	struct task_struct *kthread;
 
-	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
-	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
+	dev_set_name(xpc_part, "part");
+	dev_set_name(xpc_chan, "chan");
 
 	if (is_shub()) {
 		/*
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 71513b3..234d7be 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -138,7 +138,7 @@ struct device_driver xpnet_dbg_name = {
 };
 
 struct device xpnet_dbg_subname = {
-	.bus_id = {0},		/* set to "" */
+	.init_name = "",	/* set to "" */
 	.driver = &xpnet_dbg_name
 };
 

