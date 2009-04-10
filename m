Return-Path: <linux-kernel-owner+w=401wt.eu-S934571AbZDJCfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbZDJCfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbZDJCeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:34:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58520 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986AbZDJCep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Qk7sORUmcgwf8tMU0WoFHKBai/eOmkBGT0JesvDgtCooqURJ5UleoSzPOXSRcWnH2o
         R4mRHIPYTTaz3TOrSAPrhIo7daJP0CH48bQZxkXNCAsotL/HFeBiSqJEOROvHPW9RK0W
         x+Lyhwj0xrpatv+XcZmI5TeK3XnLaECDlpmec=
Date: Fri, 10 Apr 2009 06:34:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/30] netns: extract net_create()
Message-ID: <20090410023448.GH27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_create() will be used by C/R code to create fresh netns on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/net_namespace.h |    1 +
 net/core/net_namespace.c    |   44 ++++++++++++++++++++------------------------
 2 files changed, 21 insertions(+), 24 deletions(-)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -107,6 +107,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 extern struct list_head net_namespace_list;
 
 #ifdef CONFIG_NET_NS
+struct net *net_create(void);
 extern void __put_net(struct net *net);
 
 static inline struct net *get_net(struct net *net)
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -115,38 +115,34 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }
 
-struct net *copy_net_ns(unsigned long flags, struct net *old_net)
+struct net *net_create(void)
 {
-	struct net *new_net = NULL;
-	int err;
-
-	if (!(flags & CLONE_NEWNET))
-		return get_net(old_net);
-
-	err = -ENOMEM;
-	new_net = net_alloc();
-	if (!new_net)
-		goto out_err;
+	struct net *net;
+	int rv;
 
+	net = net_alloc();
+	if (!net)
+		return ERR_PTR(-ENOMEM);
 	mutex_lock(&net_mutex);
-	err = setup_net(new_net);
-	if (!err) {
+	rv = setup_net(net);
+	if (rv == 0) {
 		rtnl_lock();
-		list_add_tail(&new_net->list, &net_namespace_list);
+		list_add_tail(&net->list, &net_namespace_list);
 		rtnl_unlock();
 	}
 	mutex_unlock(&net_mutex);
+	if (rv < 0) {
+		net_free(net);
+		return ERR_PTR(rv);
+	}
+	return net;
+}
 
-	if (err)
-		goto out_free;
-out:
-	return new_net;
-
-out_free:
-	net_free(new_net);
-out_err:
-	new_net = ERR_PTR(err);
-	goto out;
+struct net *copy_net_ns(unsigned long flags, struct net *old_net)
+{
+	if (!(flags & CLONE_NEWNET))
+		return get_net(old_net);
+	return net_create();
 }
 
 static void cleanup_net(struct work_struct *work)
