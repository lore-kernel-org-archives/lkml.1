Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbYD2LNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbYD2LNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYD2LNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26430 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbYD2LNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:22 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 1/12] sunrpc: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:11 +0400
Message-Id: <1209467602-20001-1-git-send-email-den@openvz.org>
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
---
 net/sunrpc/cache.c |   15 ++++++---------
 net/sunrpc/stats.c |    8 +-------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index d75530f..c996671 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -316,31 +316,28 @@ static int create_cache_proc_entries(struct cache_detail *cd)
 	cd->proc_ent->owner = cd->owner;
 	cd->channel_ent = cd->content_ent = NULL;
 
-	p = proc_create("flush", S_IFREG|S_IRUSR|S_IWUSR,
-			cd->proc_ent, &cache_flush_operations);
+	p = proc_create_data("flush", S_IFREG|S_IRUSR|S_IWUSR,
+			     cd->proc_ent, &cache_flush_operations, cd);
 	cd->flush_ent = p;
 	if (p == NULL)
 		goto out_nomem;
 	p->owner = cd->owner;
-	p->data = cd;
 
 	if (cd->cache_request || cd->cache_parse) {
-		p = proc_create("channel", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &cache_file_operations);
+		p = proc_create_data("channel", S_IFREG|S_IRUSR|S_IWUSR,
+				     cd->proc_ent, &cache_file_operations, cd);
 		cd->channel_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	if (cd->cache_show) {
-		p = proc_create("content", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &content_file_operations);
+		p = proc_create_data("content", S_IFREG|S_IRUSR|S_IWUSR,
+				cd->proc_ent, &content_file_operations, cd);
 		cd->content_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	return 0;
 out_nomem:
diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index c6061a4..50b049c 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -224,16 +224,10 @@ EXPORT_SYMBOL_GPL(rpc_print_iostats);
 static inline struct proc_dir_entry *
 do_register(const char *name, void *data, const struct file_operations *fops)
 {
-	struct proc_dir_entry *ent;
-
 	rpc_proc_init();
 	dprintk("RPC:       registering /proc/net/rpc/%s\n", name);
 
-	ent = proc_create(name, 0, proc_net_rpc, fops);
-	if (ent) {
-		ent->data = data;
-	}
-	return ent;
+	return proc_create_data(name, 0, proc_net_rpc, fops, data);
 }
 
 struct proc_dir_entry *
-- 
1.5.3.rc5

