Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbYD2LQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbYD2LQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760584AbYD2LNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24518 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbYD2LN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:28 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 9/12] ipv4: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:19 +0400
Message-Id: <1209467602-20001-9-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for PDE->data != NULL becomes useless after the replacement
of proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_ipv4.c |   10 +++-------
 net/ipv4/udp.c      |    7 +++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7766151..4d97b28 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *inode, struct file *file)
 	struct tcp_iter_state *s;
 	int err;
 
-	if (unlikely(afinfo == NULL))
-		return -EINVAL;
-
 	err = seq_open_net(inode, file, &afinfo->seq_ops,
 			  sizeof(struct tcp_iter_state));
 	if (err < 0)
@@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, struct tcp_seq_afinfo *afinfo)
 	afinfo->seq_ops.next		= tcp_seq_next;
 	afinfo->seq_ops.stop		= tcp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b053ac7..c19c491 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1605,10 +1605,9 @@ int udp_proc_register(struct net *net, struct udp_seq_afinfo *afinfo)
 	afinfo->seq_ops.next		= udp_seq_next;
 	afinfo->seq_ops.stop		= udp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
-- 
1.5.3.rc5

