Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0BEBqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:46:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0BEBqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:46:25 -0500
Message-ID: <4B6B7881.6070608@cn.fujitsu.com>
Date: Fri, 05 Feb 2010 09:46:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 08/13] net: appletalk: use seq_hlist_foo() helpers
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
 net/appletalk/atalk_proc.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 80caad1..6ef0e76 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -144,40 +144,16 @@ out:
 	return 0;
 }
 
-static __inline__ struct sock *atalk_get_socket_idx(loff_t pos)
-{
-	struct sock *s;
-	struct hlist_node *node;
-
-	sk_for_each(s, node, &atalk_sockets)
-		if (!pos--)
-			goto found;
-	s = NULL;
-found:
-	return s;
-}
-
 static void *atalk_seq_socket_start(struct seq_file *seq, loff_t *pos)
 	__acquires(atalk_sockets_lock)
 {
-	loff_t l = *pos;
-
 	read_lock_bh(&atalk_sockets_lock);
-	return l ? atalk_get_socket_idx(--l) : SEQ_START_TOKEN;
+	return seq_hlist_start_head(&atalk_sockets, *pos);
 }
 
 static void *atalk_seq_socket_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct sock *i;
-
-	++*pos;
-	if (v == SEQ_START_TOKEN) {
-		i = sk_head(&atalk_sockets);
-		goto out;
-	}
-	i = sk_next(v);
-out:
-	return i;
+	return seq_hlist_next(v, &atalk_sockets, pos);
 }
 
 static void atalk_seq_socket_stop(struct seq_file *seq, void *v)
@@ -197,7 +173,7 @@ static int atalk_seq_socket_show(struct seq_file *seq, void *v)
 		goto out;
 	}
 
-	s = v;
+	s = sk_entry(v);
 	at = at_sk(s);
 
 	seq_printf(seq, "%02X   %04X:%02X:%02X  %04X:%02X:%02X  %08X:%08X "
-- 
1.6.3

