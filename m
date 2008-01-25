Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYAYIJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYAYIJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbYAYIAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:59404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763985AbYAYH7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Dave Larson <larson1@us.ibm.com>,
       Santiago Leon <santil@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 122/196] Kobject: change drivers/net/ibmveth.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:31 -0800
Message-Id: <1201246425-5058-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Dave Larson <larson1@us.ibm.com>
Cc: Santiago Leon <santil@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ibmveth.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 7d7758f..bee3037 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1179,13 +1179,15 @@ static int __devinit ibmveth_probe(struct vio_dev *dev, const struct vio_device_
 
 	for(i = 0; i<IbmVethNumBufferPools; i++) {
 		struct kobject *kobj = &adapter->rx_buff_pool[i].kobj;
+		int error;
+
 		ibmveth_init_buffer_pool(&adapter->rx_buff_pool[i], i,
 					 pool_count[i], pool_size[i],
 					 pool_active[i]);
-		kobj->parent = &dev->dev.kobj;
-		kobject_set_name(kobj, "pool%d", i);
-		kobj->ktype = &ktype_veth_pool;
-		kobject_register(kobj);
+		error = kobject_init_and_add(kobj, &ktype_veth_pool,
+					     &dev->dev.kobj, "pool%d", i);
+		if (!error)
+			kobject_uevent(kobj, KOBJ_ADD);
 	}
 
 	ibmveth_debug_printk("adapter @ 0x%p\n", adapter);
-- 
1.5.3.8

