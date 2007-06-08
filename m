Return-Path: <linux-kernel-owner+w=401wt.eu-S968319AbXFHHlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968319AbXFHHlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967760AbXFHHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:23 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55181 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938270AbXFHHYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:22 -0400
Message-Id: <20070608072233.592004000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 46/54] NET: Fix race condition about network device name allocation.
Content-Disposition: inline; filename=net-fix-race-condition-about-network-device-name-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

Kenji Kaneshige found this race between device removal and
registration.  On unregister it is possible for the old device to
exist, because sysfs file is still open.  A new device with 'eth%d'
will select the same name, but sysfs kobject register will fial.

The following changes the shutdown order slightly. It hold a removes
the sysfs entries earlier (on unregister_netdevice), but holds a
kobject reference.  Then when todo runs the actual last put free
happens.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c       |   10 ++++++----
 net/core/net-sysfs.c |    8 +++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

--- linux-2.6.21.4.orig/net/core/dev.c
+++ linux-2.6.21.4/net/core/dev.c
@@ -3135,7 +3135,6 @@ void netdev_run_todo(void)
 			continue;
 		}
 
-		netdev_unregister_sysfs(dev);
 		dev->reg_state = NETREG_UNREGISTERED;
 
 		netdev_wait_allrefs(dev);
@@ -3146,11 +3145,11 @@ void netdev_run_todo(void)
 		BUG_TRAP(!dev->ip6_ptr);
 		BUG_TRAP(!dev->dn_ptr);
 
-		/* It must be the very last action,
-		 * after this 'dev' may point to freed up memory.
-		 */
 		if (dev->destructor)
 			dev->destructor(dev);
+
+		/* Free network device */
+		kobject_put(&dev->dev.kobj);
 	}
 
 out:
@@ -3305,6 +3304,9 @@ void unregister_netdevice(struct net_dev
 	/* Notifier chain MUST detach us from master device. */
 	BUG_TRAP(!dev->master);
 
+	/* Remove entries from sysfs */
+	netdev_unregister_sysfs(dev);
+
 	/* Finish processing unregister after unlock */
 	net_set_todo(dev);
 
--- linux-2.6.21.4.orig/net/core/net-sysfs.c
+++ linux-2.6.21.4/net/core/net-sysfs.c
@@ -451,9 +451,15 @@ static struct class net_class = {
 #endif
 };
 
+/* Delete sysfs entries but hold kobject reference until after all
+ * netdev references are gone.
+ */
 void netdev_unregister_sysfs(struct net_device * net)
 {
-	device_del(&(net->dev));
+	struct device *dev = &(net->dev);
+
+	kobject_get(&dev->kobj);
+	device_del(dev);
 }
 
 /* Create sysfs entries for network device. */

-- 
