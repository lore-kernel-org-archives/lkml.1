Return-Path: <linux-kernel-owner+w=401wt.eu-S1161612AbXECJyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161612AbXECJyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161601AbXECJx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:53:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161429AbXECJxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:53:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] AFS: Adjust the new netdevice scanning code
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net, dhowells@redhat.com
Date: Thu, 03 May 2007 10:53:36 +0100
Message-ID: <20070503095336.26912.55434.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the new netdevice scanning code provided by Patrick McHardy:

 (1) Restore the function banner comments that were dropped.

 (2) Rather than using an array size of 6 in some places and an array size of
     ETH_ALEN in others, pass a pointer instead and pass the array size
     through so that we can actually check it.

 (3) Do the buffer fill count check before checking the for_primary_ifa
     condition again.  This permits us to skip that check should maxbufs be
     reached before we run out of interfaces.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h   |    2 +-
 fs/afs/main.c       |    2 +-
 fs/afs/netdevices.c |   24 +++++++++++++++++++-----
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 551db89..d90c158 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -563,7 +563,7 @@ extern void afs_fs_exit(void);
  * use-rtnetlink.c
  */
 extern int afs_get_ipv4_interfaces(struct afs_interface *, size_t, bool);
-extern int afs_get_MAC_address(u8 [6]);
+extern int afs_get_MAC_address(u8 *, size_t);
 
 /*
  * vlclient.c
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 40c2704..80ec6fd 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -54,7 +54,7 @@ static int __init afs_get_client_UUID(void)
 
 	/* read the MAC address of one of the external interfaces and construct
 	 * a UUID from it */
-	ret = afs_get_MAC_address(afs_uuid.node);
+	ret = afs_get_MAC_address(afs_uuid.node, sizeof(afs_uuid.node));
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/afs/netdevices.c b/fs/afs/netdevices.c
index 2b30873..ce08977 100644
--- a/fs/afs/netdevices.c
+++ b/fs/afs/netdevices.c
@@ -10,21 +10,33 @@
 #include <linux/if_arp.h>
 #include "internal.h"
 
-int afs_get_MAC_address(u8 mac[ETH_ALEN])
+/*
+ * get a MAC address from a random ethernet interface that has a real one
+ * - the buffer will normally be 6 bytes in size
+ */
+int afs_get_MAC_address(u8 *mac, size_t maclen)
 {
 	struct net_device *dev;
 	int ret = -ENODEV;
 
+	if (maclen != ETH_ALEN)
+		BUG();
+
 	rtnl_lock();
 	dev = __dev_getfirstbyhwtype(ARPHRD_ETHER);
 	if (dev) {
-		memcpy(mac, dev->dev_addr, ETH_ALEN);
+		memcpy(mac, dev->dev_addr, maclen);
 		ret = 0;
 	}
 	rtnl_unlock();
 	return ret;
 }
 
+/*
+ * get a list of this system's interface IPv4 addresses, netmasks and MTUs
+ * - maxbufs must be at least 1
+ * - returns the number of interface records in the buffer
+ */
 int afs_get_ipv4_interfaces(struct afs_interface *bufs, size_t maxbufs,
 			    bool wantloopback)
 {
@@ -32,6 +44,8 @@ int afs_get_ipv4_interfaces(struct afs_interface *bufs, size_t maxbufs,
 	struct in_device *idev;
 	int n = 0;
 
+	ASSERT(maxbufs > 0);
+
 	rtnl_lock();
 	for (dev = dev_base; dev; dev = dev->next) {
 		if (dev->type == ARPHRD_LOOPBACK && !wantloopback)
@@ -40,13 +54,13 @@ int afs_get_ipv4_interfaces(struct afs_interface *bufs, size_t maxbufs,
 		if (!idev)
 			continue;
 		for_primary_ifa(idev) {
-			if (n == maxbufs)
-				goto out;
 			bufs[n].address.s_addr = ifa->ifa_address;
 			bufs[n].netmask.s_addr = ifa->ifa_mask;
 			bufs[n].mtu = dev->mtu;
 			n++;
-		} endfor_ifa(idev)
+			if (n >= maxbufs)
+				goto out;
+		} endfor_ifa(idev);
 	}
 out:
 	rtnl_unlock();

