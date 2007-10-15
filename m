Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbXJOSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbXJOSgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXJOSds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:33:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:47750 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933877AbXJOSdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:33:46 -0400
Message-ID: <4713B251.7000400@windriver.com>
Date: Mon, 15 Oct 2007 13:32:49 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mpm@selenic.com
Subject: [PATCH 5/21] KGDB: Pass skb via NET_POLL rx routine
Content-Type: multipart/mixed;
 boundary="------------070806080405030006010104"
X-OriginalArrivalTime: 15 Oct 2007 18:33:34.0343 (UTC) FILETIME=[E4B1E970:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070806080405030006010104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------070806080405030006010104
Content-Type: text/x-patch;
 name="netpoll_pass_skb_to_rx_hook.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netpoll_pass_skb_to_rx_hook.patch"

netpoll_pass_skb_to_rx_hook.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: mpm@selenic.com
Subject: [PATCH] Pass skb via NET_POLL rx routine

This patch is a chane to the NET POLL api so that the MAC address or
IP frame information can be parsed by the driver that wishes to use
it.  Speficially for kgdboe, it is used to automatically collect the
MAC address of the GDB host.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/netpoll.h |    2 +-
 net/core/netpoll.c      |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.21.1/include/linux/netpoll.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/netpoll.h
+++ linux-2.6.21.1/include/linux/netpoll.h
@@ -16,7 +16,7 @@ struct netpoll {
 	struct net_device *dev;
 	char dev_name[IFNAMSIZ];
 	const char *name;
-	void (*rx_hook)(struct netpoll *, int, char *, int);
+	void (*rx_hook)(struct netpoll *, int, char *, int, struct sk_buff *);
 
 	u32 local_ip, remote_ip;
 	u16 local_port, remote_port;
Index: linux-2.6.21.1/net/core/netpoll.c
===================================================================
--- linux-2.6.21.1.orig/net/core/netpoll.c
+++ linux-2.6.21.1/net/core/netpoll.c
@@ -498,7 +498,8 @@ int __netpoll_rx(struct sk_buff *skb)
 
 	np->rx_hook(np, ntohs(uh->source),
 		    (char *)(uh+1),
-		    ulen - sizeof(struct udphdr));
+		    ulen - sizeof(struct udphdr),
+		    skb);
 
 	kfree_skb(skb);
 	return 1;

--------------070806080405030006010104--
