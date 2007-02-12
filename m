Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXBLJJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXBLJJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbXBLJJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:09:00 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:37988 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:40:12 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 08/10] nfnetlink_log: shorten instances_lock holding time
Message-ID: <20070212004012.GI8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten instances_lock window at the cost of doing unnecessary work
on the failure case. I don't know if it makes sense actually. ;>

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.6	2007-02-11 22:31:19.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:41:18.000000000 +0100
@@ -149,18 +149,14 @@ instance_create(u_int16_t group_num, int
 
 	if (!try_module_get(THIS_MODULE)) {
 		UDEBUG("aborting, could not reference own module (module unloading?)\n");
-		goto out_modunload;
-	}
-
-	write_lock_bh(&instances_lock);	
-	if (__instance_lookup(group_num)) {
-		UDEBUG("aborting, instance already exists\n");
-		goto out_unlock;
+		return NULL;
 	}
 
 	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst)
-		goto out_unlock;
+	if (!inst) {
+		module_put(THIS_MODULE);
+		return NULL;
+	}
 
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
@@ -181,21 +177,25 @@ instance_create(u_int16_t group_num, int
 	inst->copy_mode 	= NFULNL_COPY_PACKET;
 	inst->copy_range 	= 0xffff;
 
-	hlist_add_head(&inst->hlist, 
+	write_lock_bh(&instances_lock);	
+
+	if (!__instance_lookup(group_num)) {
+		hlist_add_head(&inst->hlist, 
 		       &instance_table[instance_hashfn(group_num)]);
 
-	UDEBUG("newly added node: %p, next=%p\n", &inst->hlist, 
-		inst->hlist.next);
+		UDEBUG("newly added node: %p, next=%p\n", &inst->hlist, 
+			inst->hlist.next);
+	} else {
+		UDEBUG("aborting, instance already exists\n");
+
+		kfree(inst);
+		module_put(THIS_MODULE);
+		inst = NULL;
+	}
 
 	write_unlock_bh(&instances_lock);
 
 	return inst;
-
-out_unlock:
-	write_unlock_bh(&instances_lock);
-	module_put(THIS_MODULE);
-out_modunload:
-	return NULL;
 }
 
 static int __nfulnl_send(struct nfulnl_instance *inst);
