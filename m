Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYADF5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYADF5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYADF5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:57:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50396 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbYADF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:57:09 -0500
Message-ID: <477DC9B2.6070608@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:52:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] CONNECTOR: clean up {,__}cn_rx_skb()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- __cn_rx_skb() does nothing but calls cn_call_callback(), it doesn't
check skb and msg sizes as the comment suggests, but cn_rx_skb() checks
those sizes.

- In cn_rx_skb() Local variable 'len' is not used. 'len' is probably
intended to be passed to skb_pull(), but here skb_pull() is not needed,
instead skb_free() is called.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/connector.c |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 6e70963..865303b 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -180,33 +180,14 @@ static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), v
 }
 
 /*
- * Skb receive helper - checks skb and msg size and calls callback
- * helper.
- */
-static int __cn_rx_skb(struct sk_buff *skb, struct nlmsghdr *nlh)
-{
-	u32 pid, uid, seq, group;
-	struct cn_msg *msg;
-
-	pid = NETLINK_CREDS(skb)->pid;
-	uid = NETLINK_CREDS(skb)->uid;
-	seq = nlh->nlmsg_seq;
-	group = NETLINK_CB((skb)).dst_group;
-	msg = NLMSG_DATA(nlh);
-
-	return cn_call_callback(msg, (void (*)(void *))kfree_skb, skb);
-}
-
-/*
  * Main netlink receiving function.
  *
- * It checks skb and netlink header sizes and calls the skb receive
- * helper with a shared skb.
+ * It checks skb, netlink header and msg sizes, and calls callback helper.
  */
 static void cn_rx_skb(struct sk_buff *__skb)
 {
+	struct cn_msg *msg;
 	struct nlmsghdr *nlh;
-	u32 len;
 	int err;
 	struct sk_buff *skb;
 
@@ -222,11 +203,8 @@ static void cn_rx_skb(struct sk_buff *__skb)
 			return;
 		}
 
-		len = NLMSG_ALIGN(nlh->nlmsg_len);
-		if (len > skb->len)
-			len = skb->len;
-
-		err = __cn_rx_skb(skb, nlh);
+		msg = NLMSG_DATA(nlh);
+		err = cn_call_callback(msg, (void (*)(void *))kfree_skb, skb);
 		if (err < 0)
 			kfree_skb(skb);
 	}
-- 
1.5.3.rc7

