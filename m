Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYAYI2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYAYI2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761413AbYAYIBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:14 -0500
Received: from mx1.suse.de ([195.135.220.2]:59482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762392AbYAYH76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "Kyle A. Lucke" <klucke@us.ibm.com>,
       David Gibson <dwg@au1.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 131/196] Kobject: convert drivers/net/iseries_veth.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:40 -0800
Message-Id: <1201246425-5058-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kyle A. Lucke <klucke@us.ibm.com>
Cc: David Gibson <dwg@au1.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/iseries_veth.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index 97bd9dc..90ff4ec 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -815,7 +815,7 @@ static int veth_init_connection(u8 rlp)
 {
 	struct veth_lpar_connection *cnx;
 	struct veth_msg *msgs;
-	int i, rc;
+	int i;
 
 	if ( (rlp == this_lp)
 	     || ! HvLpConfig_doLpsCommunicateOnVirtualLan(this_lp, rlp) )
@@ -844,11 +844,7 @@ static int veth_init_connection(u8 rlp)
 
 	/* This gets us 1 reference, which is held on behalf of the driver
 	 * infrastructure. It's released at module unload. */
-	kobject_init(&cnx->kobject);
-	cnx->kobject.ktype = &veth_lpar_connection_ktype;
-	rc = kobject_set_name(&cnx->kobject, "cnx%.2d", rlp);
-	if (rc != 0)
-		return rc;
+	kobject_init_ng(&cnx->kobject, &veth_lpar_connection_ktype);
 
 	msgs = kcalloc(VETH_NUMBUFFERS, sizeof(struct veth_msg), GFP_KERNEL);
 	if (! msgs) {
@@ -1087,11 +1083,8 @@ static struct net_device * __init veth_probe_one(int vlan,
 		return NULL;
 	}
 
-	kobject_init(&port->kobject);
-	port->kobject.parent = &dev->dev.kobj;
-	port->kobject.ktype  = &veth_port_ktype;
-	kobject_set_name(&port->kobject, "veth_port");
-	if (0 != kobject_add(&port->kobject))
+	kobject_init_ng(&port->kobject, &veth_port_ktype);
+	if (0 != kobject_add_ng(&port->kobject, &dev->dev.kobj, "veth_port"))
 		veth_error("Failed adding port for %s to sysfs.\n", dev->name);
 
 	veth_info("%s attached to iSeries vlan %d (LPAR map = 0x%.4X)\n",
@@ -1711,9 +1704,9 @@ static int __init veth_module_init(void)
 			continue;
 
 		kobj = &veth_cnx[i]->kobject;
-		kobj->parent = &veth_driver.driver.kobj;
 		/* If the add failes, complain but otherwise continue */
-		if (0 != kobject_add(kobj))
+		if (0 != kobject_add_ng(kobj, &veth_driver.driver.kobj,
+					"cnx%.2d", veth_cnx[i]->remote_lp))
 			veth_error("cnx %d: Failed adding to sysfs.\n", i);
 	}
 
-- 
1.5.3.8

