Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYD2LPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYD2LPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYD2LN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10646 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbYD2LNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:25 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 11/12] netfilter: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:21 +0400
Message-Id: <1209467602-20001-11-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/x_tables.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f52f7f8..c3aa45b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -936,25 +936,24 @@ int xt_proto_init(struct net *net, int af)
 #ifdef CONFIG_PROC_FS
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_table_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
-	proc->data = (void *)(unsigned long)af;
-
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_match_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_match_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_tables;
-	proc->data = (void *)(unsigned long)af;
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_target_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_target_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_matches;
-	proc->data = (void *)(unsigned long)af;
 #endif
 
 	return 0;
-- 
1.5.3.rc5

