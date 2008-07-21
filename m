Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYGUVfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYGUVfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYGUVff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:35:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:48678 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYGUVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:35:34 -0400
Message-ID: <48850121.9090106@trash.net>
Date: Mon, 21 Jul 2008 23:35:29 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Larry.Finger@lwfinger.net, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4884F3D7.4070604@lwfinger.net>	<20080721.134608.75595942.davem@davemloft.net>	<4884F6E9.6090809@trash.net> <20080721.140120.135667045.davem@davemloft.net> <4884FA3F.70109@trash.net>
In-Reply-To: <4884FA3F.70109@trash.net>
Content-Type: multipart/mixed;
 boundary="------------020507030800020103000303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020507030800020103000303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> David Miller wrote:
>> Maybe something like the following should do it?
> 
> 
> It looks correct in any case. I'm not sure whether it fixes
> this lockdep warning though, according to the backtrace and
> module list its b43 and dev_mc_sync in net/mac80211/main.c
> that are causing the error, which don't seem to be included
> in your patch. I'm unable to find where it previously
> initialized the xmit_lock lockdep class though, so I must
> be missing something :)

This is what I was missing, we're setting a lockdep class
by default depending on dev->type. This patch combined
with yours should fix all addr_list_lock warnings.



--------------020507030800020103000303
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

net: set lockdep class for dev->addr_list_lock

Initialize dev->addr_list_lock lockdep classes equally to dev->_xmit_lock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/core/dev.c b/net/core/dev.c
index 2eed17b..9cfed90 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -299,6 +299,7 @@ static const char *netdev_lock_name[] =
 	 "_xmit_NONE"};
 
 static struct lock_class_key netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
+static struct lock_class_key netdev_addr_lock_key[ARRAY_SIZE(netdev_lock_type)];
 
 static inline unsigned short netdev_lock_pos(unsigned short dev_type)
 {
@@ -311,8 +312,8 @@ static inline unsigned short netdev_lock_pos(unsigned short dev_type)
 	return ARRAY_SIZE(netdev_lock_type) - 1;
 }
 
-static inline void netdev_set_lockdep_class(spinlock_t *lock,
-					    unsigned short dev_type)
+static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
+						 unsigned short dev_type)
 {
 	int i;
 
@@ -320,9 +321,23 @@ static inline void netdev_set_lockdep_class(spinlock_t *lock,
 	lockdep_set_class_and_name(lock, &netdev_xmit_lock_key[i],
 				   netdev_lock_name[i]);
 }
+
+static inline void netdev_set_addr_lockdep_class(spinlock_t *lock,
+						 unsigned short dev_type)
+{
+	int i;
+
+	i = netdev_lock_pos(dev_type);
+	lockdep_set_class_and_name(lock, &netdev_addr_lock_key[i],
+				   netdev_lock_name[i]);
+}
 #else
-static inline void netdev_set_lockdep_class(spinlock_t *lock,
-					    unsigned short dev_type)
+static inline void netdev_set_xmit_lockdep_class(spinlock_t *lock,
+						 unsigned short dev_type)
+{
+}
+static inline void netdev_set_addr_lockdep_class(spinlock_t *lock,
+						 unsigned short dev_type)
 {
 }
 #endif
@@ -3843,14 +3858,15 @@ static void __netdev_init_queue_locks_one(struct net_device *dev,
 					  void *_unused)
 {
 	spin_lock_init(&dev_queue->_xmit_lock);
-	netdev_set_lockdep_class(&dev_queue->_xmit_lock, dev->type);
+	netdev_set_xmit_lockdep_class(&dev_queue->_xmit_lock, dev->type);
 	dev_queue->xmit_lock_owner = -1;
 }
 
-static void netdev_init_queue_locks(struct net_device *dev)
+static void netdev_init_locks(struct net_device *dev)
 {
 	netdev_for_each_tx_queue(dev, __netdev_init_queue_locks_one, NULL);
 	__netdev_init_queue_locks_one(dev, &dev->rx_queue, NULL);
+	netdev_set_addr_lockdep_class(&dev->addr_list_lock, dev->type);
 }
 
 /**
@@ -3888,7 +3904,7 @@ int register_netdevice(struct net_device *dev)
 	net = dev_net(dev);
 
 	spin_lock_init(&dev->addr_list_lock);
-	netdev_init_queue_locks(dev);
+	netdev_init_locks(dev);
 
 	dev->iflink = -1;
 

--------------020507030800020103000303--
