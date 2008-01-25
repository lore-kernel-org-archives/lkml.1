Return-Path: <linux-kernel-owner+w=401wt.eu-S1765538AbYAYISl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765538AbYAYISl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764047AbYAYIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:49 -0500
Received: from ns.suse.de ([195.135.220.2]:59453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764078AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 136/196] Kobject: convert net/bridge/br_if.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:45 -0800
Message-Id: <1201246425-5058-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_if.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index dadec94..298e0f4 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -258,12 +258,6 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	p->state = BR_STATE_DISABLED;
 	br_stp_port_timer_init(p);
 
-	kobject_init(&p->kobj);
-	kobject_set_name(&p->kobj, SYSFS_BRIDGE_PORT_ATTR);
-	p->kobj.ktype = &brport_ktype;
-	p->kobj.parent = &(dev->dev.kobj);
-	p->kobj.kset = NULL;
-
 	return p;
 }
 
@@ -379,7 +373,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
-	err = kobject_add(&p->kobj);
+	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
+				   SYSFS_BRIDGE_PORT_ATTR);
 	if (err)
 		goto err0;
 
@@ -416,6 +411,7 @@ err2:
 	br_fdb_delete_by_port(br, p, 1);
 err1:
 	kobject_del(&p->kobj);
+	return err;
 err0:
 	kobject_put(&p->kobj);
 	return err;
-- 
1.5.3.8

