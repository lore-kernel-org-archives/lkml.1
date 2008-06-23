Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYFWSPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYFWSPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbYFWSO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:14:57 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56440 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbYFWSOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:14:55 -0400
Date: Mon, 23 Jun 2008 20:14:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/macintosh/smu.c: improve error handling
Message-ID: <Pine.LNX.4.64.0806232014190.942@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This patch makes two changes:
* As noted by Akinobu Mita in patch
b1fceac2b9e04d278316b2faddf276015fc06e3b, alloc_bootmem never returns NULL
and always returns a zeroed region of memory.  Thus the error checking code
and memset after the call to alloc_bootmem are not necessary.
* The old error handling code consisted of setting a global variable to
NULL and returning an error code, which could cause previously allocated
resources never to be freed.  The patch adds calls to appropriate resource
deallocation functions.

 drivers/macintosh/smu.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -474,6 +474,7 @@ int __init smu_init (void)
 {
 	struct device_node *np;
 	const u32 *data;
+	int ret = 0;
 
         np = of_find_node_by_type(NULL, "smu");
         if (np == NULL)
@@ -483,16 +484,11 @@ int __init smu_init (void)
 
 	if (smu_cmdbuf_abs == 0) {
 		printk(KERN_ERR "SMU: Command buffer not allocated !\n");
-		of_node_put(np);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail_np;
 	}
 
 	smu = alloc_bootmem(sizeof(struct smu_device));
-	if (smu == NULL) {
-		of_node_put(np);
-		return -ENOMEM;
-	}
-	memset(smu, 0, sizeof(*smu));
 
 	spin_lock_init(&smu->lock);
 	INIT_LIST_HEAD(&smu->cmd_list);
@@ -510,14 +506,14 @@ int __init smu_init (void)
 	smu->db_node = of_find_node_by_name(NULL, "smu-doorbell");
 	if (smu->db_node == NULL) {
 		printk(KERN_ERR "SMU: Can't find doorbell GPIO !\n");
-		goto fail;
+		ret = -ENXIO;
+		goto fail_bootmem;
 	}
 	data = of_get_property(smu->db_node, "reg", NULL);
 	if (data == NULL) {
-		of_node_put(smu->db_node);
-		smu->db_node = NULL;
 		printk(KERN_ERR "SMU: Can't find doorbell GPIO address !\n");
-		goto fail;
+		ret = -ENXIO;
+		goto fail_db_node;
 	}
 
 	/* Current setup has one doorbell GPIO that does both doorbell
@@ -551,7 +547,8 @@ int __init smu_init (void)
 	smu->db_buf = ioremap(0x8000860c, 0x1000);
 	if (smu->db_buf == NULL) {
 		printk(KERN_ERR "SMU: Can't map doorbell buffer pointer !\n");
-		goto fail;
+		ret = -ENXIO;
+		goto fail_msg_node;
 	}
 
 	/* U3 has an issue with NAP mode when issuing SMU commands */
@@ -562,10 +559,17 @@ int __init smu_init (void)
 	sys_ctrler = SYS_CTRLER_SMU;
 	return 0;
 
- fail:
+fail_msg_node:
+	if (smu->msg_node)
+		of_node_put(smu->msg_node);
+fail_db_node:
+	of_node_put(smu->db_node);
+fail_bootmem:
+	free_bootmem((unsigned long)smu, sizeof(struct smu_device));
 	smu = NULL;
-	return -ENXIO;
-
+fail_np:
+	of_node_put(np);
+	return ret;
 }
 
 
