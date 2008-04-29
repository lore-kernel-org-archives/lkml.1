Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbYD2LOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbYD2LOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYD2LN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7959 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbYD2LNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:25 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/12] netfilter: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:12 +0400
Message-Id: <1209467602-20001-2-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 +++---
 net/netfilter/xt_hashlimit.c       |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 22d8e7c..1819ad7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -169,14 +169,14 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 
 		/* create proc dir entry */
 		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
-		c->pde = proc_create(buffer, S_IWUSR|S_IRUSR,
-				     clusterip_procdir, &clusterip_proc_fops);
+		c->pde = proc_create_data(buffer, S_IWUSR|S_IRUSR,
+					  clusterip_procdir,
+					  &clusterip_proc_fops, c);
 		if (!c->pde) {
 			kfree(c);
 			return NULL;
 		}
 	}
-	c->pde->data = c;
 #endif
 
 	write_lock_bh(&clusterip_lock);
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 40d344b..6809af5 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -237,15 +237,15 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, int family)
 	hinfo->family = family;
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (!hinfo->pde) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long )hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
@@ -301,15 +301,15 @@ static int htable_create(struct xt_hashlimit_mtinfo1 *minfo,
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (hinfo->pde == NULL) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long)hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
-- 
1.5.3.rc5

