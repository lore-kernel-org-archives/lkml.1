Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZGXJGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZGXJGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGXJGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:06:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48456 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZGXJGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:06:41 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: davem@davemloft.net, shemminger@linux-foundation.org
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] net/bridge: use kobject_put to release kobject in br_add_if error path
Date: Fri, 24 Jul 2009 17:06:32 +0800
Message-Id: <1248426392-30777-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_init_and_add will alloc memory for kobj->name, so in br_add_if
error path, simply use kobject_del will not free memory for kobj->name.
Fix by using kobject_put instead, kobject_put will internally calls
kobject_del and frees memory for kobj->name.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 net/bridge/br_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 8a96672..eb404dc 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -424,7 +424,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 err2:
 	br_fdb_delete_by_port(br, p, 1);
 err1:
-	kobject_del(&p->kobj);
+	kobject_put(&p->kobj);
 err0:
 	dev_set_promiscuity(dev, -1);
 put_back:
-- 
1.6.2.5

