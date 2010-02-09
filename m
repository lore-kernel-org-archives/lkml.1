Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0BIJUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:20:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0BIJT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:19:58 -0500
Message-ID: <4B7128BF.1040608@cn.fujitsu.com>
Date: Tue, 09 Feb 2010 17:19:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 07/13] net: ax25: use seq_hlist_foo() helpers
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
 net/ax25/af_ax25.c  |   18 +++---------------
 net/ax25/ax25_uid.c |   25 ++++---------------------
 2 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 5588ba6..a5beedf 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1863,25 +1863,13 @@ static int ax25_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 static void *ax25_info_start(struct seq_file *seq, loff_t *pos)
 	__acquires(ax25_list_lock)
 {
-	struct ax25_cb *ax25;
-	struct hlist_node *node;
-	int i = 0;
-
 	spin_lock_bh(&ax25_list_lock);
-	ax25_for_each(ax25, node, &ax25_list) {
-		if (i == *pos)
-			return ax25;
-		++i;
-	}
-	return NULL;
+	return seq_hlist_start(&ax25_list, *pos);
 }
 
 static void *ax25_info_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	++*pos;
-
-	return hlist_entry( ((struct ax25_cb *)v)->ax25_node.next,
-			    struct ax25_cb, ax25_node);
+	return seq_hlist_next(v, &ax25_list, pos);
 }
 
 static void ax25_info_stop(struct seq_file *seq, void *v)
@@ -1892,7 +1880,7 @@ static void ax25_info_stop(struct seq_file *seq, void *v)
 
 static int ax25_info_show(struct seq_file *seq, void *v)
 {
-	ax25_cb *ax25 = v;
+	ax25_cb *ax25 = hlist_entry(v, struct ax25_cb, ax25_node);
 	char buf[11];
 	int k;
 
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index 832bcf0..9f13f6e 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -146,31 +146,13 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 static void *ax25_uid_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(ax25_uid_lock)
 {
-	struct ax25_uid_assoc *pt;
-	struct hlist_node *node;
-	int i = 1;
-
 	read_lock(&ax25_uid_lock);
-
-	if (*pos == 0)
-		return SEQ_START_TOKEN;
-
-	ax25_uid_for_each(pt, node, &ax25_uid_list) {
-		if (i == *pos)
-			return pt;
-		++i;
-	}
-	return NULL;
+	return seq_hlist_start_head(&ax25_uid_list, *pos);
 }
 
 static void *ax25_uid_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	++*pos;
-	if (v == SEQ_START_TOKEN)
-		return ax25_uid_list.first;
-	else
-		return hlist_entry(((ax25_uid_assoc *)v)->uid_node.next,
-			   ax25_uid_assoc, uid_node);
+	return seq_hlist_next(v, &ax25_uid_list, pos);
 }
 
 static void ax25_uid_seq_stop(struct seq_file *seq, void *v)
@@ -186,8 +168,9 @@ static int ax25_uid_seq_show(struct seq_file *seq, void *v)
 	if (v == SEQ_START_TOKEN)
 		seq_printf(seq, "Policy: %d\n", ax25_uid_policy);
 	else {
-		struct ax25_uid_assoc *pt = v;
+		struct ax25_uid_assoc *pt;
 
+		pt = hlist_entry(v, struct ax25_uid_assoc, uid_node);
 		seq_printf(seq, "%6d %s\n", pt->uid, ax2asc(buf, &pt->call));
 	}
 	return 0;
-- 
1.6.3

