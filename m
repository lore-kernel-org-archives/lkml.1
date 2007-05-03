Return-Path: <linux-kernel-owner+w=401wt.eu-S1161216AbXECJxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161216AbXECJxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031113AbXECJxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:53:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031000AbXECJxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:53:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] [NET]: Add __dev_getfirstbyhwtype
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net, dhowells@redhat.com
Date: Thu, 03 May 2007 10:53:26 +0100
Message-ID: <20070503095325.26912.37429.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add __dev_getfirstbyhwtype for callers that don't want a reference but
some data from the device and thus need to take the rtnl anyway.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/netdevice.h |    1 +
 net/core/dev.c            |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac0c92b..4428f1c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -582,6 +582,7 @@ extern int 			netdev_boot_setup_check(struct net_device *dev);
 extern unsigned long		netdev_boot_base(const char *prefix, int unit);
 extern struct net_device    *dev_getbyhwaddr(unsigned short type, char *hwaddr);
 extern struct net_device *dev_getfirstbyhwtype(unsigned short type);
+extern struct net_device *__dev_getfirstbyhwtype(unsigned short type);
 extern void		dev_add_pack(struct packet_type *pt);
 extern void		dev_remove_pack(struct packet_type *pt);
 extern void		__dev_remove_pack(struct packet_type *pt);
diff --git a/net/core/dev.c b/net/core/dev.c
index eb99900..c305819 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -576,17 +576,28 @@ struct net_device *dev_getbyhwaddr(unsigned short type, char *ha)
 
 EXPORT_SYMBOL(dev_getbyhwaddr);
 
-struct net_device *dev_getfirstbyhwtype(unsigned short type)
+struct net_device *__dev_getfirstbyhwtype(unsigned short type)
 {
 	struct net_device *dev;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 	for (dev = dev_base; dev; dev = dev->next) {
-		if (dev->type == type) {
-			dev_hold(dev);
+		if (dev->type == type)
 			break;
-		}
 	}
+	return dev;
+}
+
+EXPORT_SYMBOL(__dev_getfirstbyhwtype);
+
+struct net_device *dev_getfirstbyhwtype(unsigned short type)
+{
+	struct net_device *dev;
+
+	rtnl_lock();
+	dev = __dev_getfirstbyhwtype(type);
+	if (dev)
+		dev_hold(dev);
 	rtnl_unlock();
 	return dev;
 }

