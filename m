Return-Path: <linux-kernel-owner+w=401wt.eu-S970434AbXFHQeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970434AbXFHQeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968696AbXFHQe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:34:28 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56632 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966574AbXFHQe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:34:27 -0400
Date: Fri, 8 Jun 2007 09:34:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: koan <koan00@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       shemminger@linux-foundation.org
Subject: Re: [patch 29/32] NET: Fix race condition about network device
	name allocation.
Message-ID: <20070608163407.GB3457@sequoia.sous-sol.org>
References: <64d833020706080734n282940fey7081481745af3765@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64d833020706080734n282940fey7081481745af3765@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* koan (koan00@gmail.com) wrote:
> I get a compilation failure from the patch:
> 
>  CC      net/core/stream.o
>  CC      net/core/scm.o
>  CC      net/core/gen_stats.o
>  CC      net/core/gen_estimator.o
>  CC      net/core/sysctl_net_core.o
>  CC      net/core/dev.o
> net/core/dev.c: In function 'netdev_run_todo':
> net/core/dev.c:3155: error: 'struct net_device' has no member named 'dev'
> make[2]: *** [net/core/dev.o] Error 1
> make[1]: *** [net/core] Error 2
> make: *** [net] Error 2

Yes, that's a terrible backport from me.  I'm testing this one now,
and may simply drop it.
--

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
[chrisw: backport to 2.6.20]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/core/dev.c       |   10 ++++++----
 net/core/net-sysfs.c |    8 +++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

--- linux-2.6.20.13.orig/net/core/dev.c
+++ linux-2.6.20.13/net/core/dev.c
@@ -3138,7 +3138,6 @@ void netdev_run_todo(void)
 			continue;
 		}
 
-		netdev_unregister_sysfs(dev);
 		dev->reg_state = NETREG_UNREGISTERED;
 
 		netdev_wait_allrefs(dev);
@@ -3149,11 +3148,11 @@ void netdev_run_todo(void)
 		BUG_TRAP(!dev->ip6_ptr);
 		BUG_TRAP(!dev->dn_ptr);
 
-		/* It must be the very last action,
-		 * after this 'dev' may point to freed up memory.
-		 */
 		if (dev->destructor)
 			dev->destructor(dev);
+
+		/* Free network device */
+		kobject_put(&dev->class_dev.kobj);
 	}
 
 out:
@@ -3310,6 +3309,9 @@ int unregister_netdevice(struct net_devi
 	/* Notifier chain MUST detach us from master device. */
 	BUG_TRAP(!dev->master);
 
+	/* Remove entries from sysfs */
+	netdev_unregister_sysfs(dev);
+
 	/* Finish processing unregister after unlock */
 	net_set_todo(dev);
 
--- linux-2.6.20.13.orig/net/core/net-sysfs.c
+++ linux-2.6.20.13/net/core/net-sysfs.c
@@ -440,9 +440,15 @@ static struct class net_class = {
 #endif
 };
 
+/* Delete sysfs entries but hold kobject reference until after all
+ * netdev references are gone.
+ */
 void netdev_unregister_sysfs(struct net_device * net)
 {
-	class_device_del(&(net->class_dev));
+	struct class_device *dev = &(net->class_dev);
+
+	kobject_get(&dev->kobj);
+	class_device_del(dev);
 }
 
 /* Create sysfs entries for network device. */
