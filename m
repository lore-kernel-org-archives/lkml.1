Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZEVE56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZEVE56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZEVEzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZEVEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gtpKpnGzwcTm1WnuY6xM4yAnW/CxAriRo39SdExv1WSZpEsL2ExfX7116jwCjdAOfO
         452FacY3EajWpqjIo7zTYxLh10ZM6dhYQDb1PMJnxk3Adc+dIpe7qZrKo0BjsLRiy1Mo
         6h4py+CY+FNTMBiDy327g5sUrAsJrTgKHLpbY=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 10/38] netns 2/2: extract net_create()
Date: Fri, 22 May 2009 08:55:04 +0400
Message-Id: <1242968132-1044-10-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_create() will be used by C/R to create fresh netns on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 net/core/net_namespace.c |   44 ++++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 4488010..6b3edc9 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -115,38 +115,34 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }
 
-struct net *copy_net_ns(unsigned long flags, struct net *old_net)
+static struct net *net_create(void)
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
-- 
1.5.6.5

