Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZJ0WEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZJ0WEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbZJ0WEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:04:42 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38974 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbZJ0WEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:04:41 -0400
Date: Tue, 27 Oct 2009 15:04:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       opurdila@ixiacom.com, viro@zeniv.linux.org.uk
Subject: [PATCH] net: fold network name hash (v2)
Message-ID: <20091027150436.56e673cd@nehalam>
In-Reply-To: <20091027102251.244ee681@nehalam>
References: <9986527.24561256620662709.JavaMail.root@tahiti.vyatta.com>
	<19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
	<20091026.222428.80364204.davem@davemloft.net>
	<20091027102251.244ee681@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full_name_hash does not produce a value that is evenly distributed
over the lower 8 bits. This causes name hash to be unbalanced with large
number of names. There is a standard function to fold in upper bits
so use that.

This is independent of possible improvements to full_name_hash()
in future.
 
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/core/dev.c	2009-10-27 14:54:21.922563076 -0700
+++ b/net/core/dev.c	2009-10-27 15:04:16.733813459 -0700
@@ -86,6 +86,7 @@
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/errno.h>
+#include <linux/hash.h>
 #include <linux/interrupt.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
@@ -199,7 +200,7 @@ EXPORT_SYMBOL(dev_base_lock);
 static inline struct hlist_head *dev_name_hash(struct net *net, const char *name)
 {
 	unsigned hash = full_name_hash(name, strnlen(name, IFNAMSIZ));
-	return &net->dev_name_head[hash & ((1 << NETDEV_HASHBITS) - 1)];
+	return &net->dev_name_head[hash_long(hash, NETDEV_HASHBITS)];
 }
 
 static inline struct hlist_head *dev_index_hash(struct net *net, int ifindex)
