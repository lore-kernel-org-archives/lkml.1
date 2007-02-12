Return-Path: <linux-kernel-owner+w=401wt.eu-S964797AbXBLJJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbXBLJJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBLJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:59 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:41871 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:39:56 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 07/10] nfnetlink_log: fix module reference counting
Message-ID: <20070212003956.GH8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count module references correctly: after instance_destroy() there
might be timer pending and holding a reference for this netlink instance.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.5	2007-02-11 22:24:56.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:31:19.000000000 +0100
@@ -133,6 +133,7 @@ instance_put(struct nfulnl_instance *ins
 	if (inst && atomic_dec_and_test(&inst->use)) {
 		UDEBUG("kfree(inst=%p)\n", inst);
 		kfree(inst);
+		module_put(THIS_MODULE);
 	}
 }
 
@@ -146,9 +147,13 @@ instance_create(u_int16_t group_num, int
 	UDEBUG("entering (group_num=%u, pid=%d)\n", group_num,
 		pid);
 
+	if (!try_module_get(THIS_MODULE)) {
+		UDEBUG("aborting, could not reference own module (module unloading?)\n");
+		goto out_modunload;
+	}
+
 	write_lock_bh(&instances_lock);	
 	if (__instance_lookup(group_num)) {
-		inst = NULL;
 		UDEBUG("aborting, instance already exists\n");
 		goto out_unlock;
 	}
@@ -176,9 +181,6 @@ instance_create(u_int16_t group_num, int
 	inst->copy_mode 	= NFULNL_COPY_PACKET;
 	inst->copy_range 	= 0xffff;
 
-	if (!try_module_get(THIS_MODULE))
-		goto out_free;
-
 	hlist_add_head(&inst->hlist, 
 		       &instance_table[instance_hashfn(group_num)]);
 
@@ -189,10 +191,10 @@ instance_create(u_int16_t group_num, int
 
 	return inst;
 
-out_free:
-	instance_put(inst);
 out_unlock:
 	write_unlock_bh(&instances_lock);
+	module_put(THIS_MODULE);
+out_modunload:
 	return NULL;
 }
 
@@ -228,8 +230,6 @@ _instance_destroy2(struct nfulnl_instanc
 
 	/* and finally put the refcount */
 	instance_put(inst);
-
-	module_put(THIS_MODULE);
 }
 
 static inline void
