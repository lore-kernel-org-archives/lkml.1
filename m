Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab0BEBqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:46:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0BEBqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:46:39 -0500
Message-ID: <4B6B788F.7070500@cn.fujitsu.com>
Date: Fri, 05 Feb 2010 09:46:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 09/13] net: af_key: use seq_hlist_foo() helpers
References: <4B6B77FE.5000104@cn.fujitsu.com>
In-Reply-To: <4B6B77FE.5000104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify seq_file code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/key/af_key.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 76fa6fe..cb006b6 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3655,9 +3655,8 @@ static const struct net_proto_family pfkey_family_ops = {
 #ifdef CONFIG_PROC_FS
 static int pfkey_seq_show(struct seq_file *f, void *v)
 {
-	struct sock *s;
+	struct sock *s = sk_entry(v);
 
-	s = (struct sock *)v;
 	if (v == SEQ_START_TOKEN)
 		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
 	else
@@ -3676,19 +3675,9 @@ static void *pfkey_seq_start(struct seq_file *f, loff_t *ppos)
 {
 	struct net *net = seq_file_net(f);
 	struct netns_pfkey *net_pfkey = net_generic(net, pfkey_net_id);
-	struct sock *s;
-	struct hlist_node *node;
-	loff_t pos = *ppos;
 
 	read_lock(&pfkey_table_lock);
-	if (pos == 0)
-		return SEQ_START_TOKEN;
-
-	sk_for_each(s, node, &net_pfkey->table)
-		if (pos-- == 1)
-			return s;
-
-	return NULL;
+	return seq_hlist_start_head(&net_pfkey->table, *ppos);
 }
 
 static void *pfkey_seq_next(struct seq_file *f, void *v, loff_t *ppos)
@@ -3696,10 +3685,7 @@ static void *pfkey_seq_next(struct seq_file *f, void *v, loff_t *ppos)
 	struct net *net = seq_file_net(f);
 	struct netns_pfkey *net_pfkey = net_generic(net, pfkey_net_id);
 
-	++*ppos;
-	return (v == SEQ_START_TOKEN) ?
-		sk_head(&net_pfkey->table) :
-			sk_next((struct sock *)v);
+	return seq_hlist_next(v, &net_pfkey->table, ppos);
 }
 
 static void pfkey_seq_stop(struct seq_file *f, void *v)
-- 
1.6.3

