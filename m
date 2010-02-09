Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0BIJTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:19:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab0BIJTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:19:20 -0500
Message-ID: <4B712888.4040004@cn.fujitsu.com>
Date: Tue, 09 Feb 2010 17:19:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 03/13] net: x25: use seq_hlist_foo() helpers
References: <4B712849.9040400@cn.fujitsu.com>
In-Reply-To: <4B712849.9040400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify seq_file code.

Signed-off-by: Li Zefan <lizf@cn.fujtisu.com>
---
 net/x25/x25_proc.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 0a04e62..c4cd322 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -93,40 +93,16 @@ out:
 	return 0;
 }
 
-static __inline__ struct sock *x25_get_socket_idx(loff_t pos)
-{
-	struct sock *s;
-	struct hlist_node *node;
-
-	sk_for_each(s, node, &x25_list)
-		if (!pos--)
-			goto found;
-	s = NULL;
-found:
-	return s;
-}
-
 static void *x25_seq_socket_start(struct seq_file *seq, loff_t *pos)
 	__acquires(x25_list_lock)
 {
-	loff_t l = *pos;
-
 	read_lock_bh(&x25_list_lock);
-	return l ? x25_get_socket_idx(--l) : SEQ_START_TOKEN;
+	return seq_hlist_start_head(&x25_list, *pos);
 }
 
 static void *x25_seq_socket_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct sock *s;
-
-	++*pos;
-	if (v == SEQ_START_TOKEN) {
-		s = sk_head(&x25_list);
-		goto out;
-	}
-	s = sk_next(v);
-out:
-	return s;
+	return seq_hlist_next(v, &x25_list, pos);
 }
 
 static void x25_seq_socket_stop(struct seq_file *seq, void *v)
@@ -148,7 +124,7 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 		goto out;
 	}
 
-	s = v;
+	s = sk_entry(v);
 	x25 = x25_sk(s);
 
 	if (!x25->neighbour || (dev = x25->neighbour->dev) == NULL)
-- 
1.6.3

