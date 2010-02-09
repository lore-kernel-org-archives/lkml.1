Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0BIJTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:19:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0BIJTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:19:25 -0500
Message-ID: <4B7128A1.9030906@cn.fujitsu.com>
Date: Tue, 09 Feb 2010 17:19:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 05/13] net: packet: use seq_hlist_foo() helpers
References: <4B712849.9040400@cn.fujitsu.com>
In-Reply-To: <4B712849.9040400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify seq_file code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/packet/af_packet.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0f6bf59..256de26 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2374,33 +2374,19 @@ static struct notifier_block packet_netdev_notifier = {
 };
 
 #ifdef CONFIG_PROC_FS
-static inline struct sock *packet_seq_idx(struct net *net, loff_t off)
-{
-	struct sock *s;
-	struct hlist_node *node;
-
-	sk_for_each(s, node, &net->packet.sklist) {
-		if (!off--)
-			return s;
-	}
-	return NULL;
-}
 
 static void *packet_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(seq_file_net(seq)->packet.sklist_lock)
 {
 	struct net *net = seq_file_net(seq);
 	read_lock(&net->packet.sklist_lock);
-	return *pos ? packet_seq_idx(net, *pos - 1) : SEQ_START_TOKEN;
+	return seq_hlist_start_head(&net->packet.sklist, *pos);
 }
 
 static void *packet_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
-	++*pos;
-	return  (v == SEQ_START_TOKEN)
-		? sk_head(&net->packet.sklist)
-		: sk_next((struct sock *)v) ;
+	return seq_hlist_next(v, &net->packet.sklist, pos);
 }
 
 static void packet_seq_stop(struct seq_file *seq, void *v)
@@ -2415,7 +2401,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "sk       RefCnt Type Proto  Iface R Rmem   User   Inode\n");
 	else {
-		struct sock *s = v;
+		struct sock *s = sk_entry(v);
 		const struct packet_sock *po = pkt_sk(s);
 
 		seq_printf(seq,
-- 
1.6.3

