Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYGTGEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYGTGEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGTGE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:04:28 -0400
Received: from mail.vyatta.com ([216.93.170.194]:55223 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYGTGE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:04:27 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.67
Date: Sat, 19 Jul 2008 23:04:24 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [RFC] netdev: debugging option
Message-ID: <20080719230424.190957a3@extreme>
In-Reply-To: <48821DEF.1040306@candelatech.com>
References: <20080718073724.GA5802@disturbed>
	<4880BA7A.3020909@candelatech.com>
	<20080719011709.GA5947@disturbed>
	<48821DEF.1040306@candelatech.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a debugging option for network devices. It could grow to add other
uses, but for now just add some messages about device reference counting.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/include/linux/netdevice.h	2008-07-19 15:04:59.000000000 -0700
+++ b/include/linux/netdevice.h	2008-07-19 22:09:21.000000000 -0700
@@ -1236,6 +1236,14 @@ extern int		netdev_budget;
 /* Called by rtnetlink.c:rtnl_unlock() */
 extern void netdev_run_todo(void);
 
+#ifdef CONFIG_DEBUG_NETDEV
+extern int netdev_debug;
+extern void __dev_hold(struct net_device *, const char *);
+extern void __dev_put(struct net_device *, const char *);
+
+#define dev_hold(dev)	__dev_hold(dev, __FUNCTION__)
+#define dev_put(dev)	__dev_put(dev, __FUNCTION__)
+#else
 /**
  *	dev_put - release reference to device
  *	@dev: network device
@@ -1257,6 +1265,8 @@ static inline void dev_hold(struct net_d
 {
 	atomic_inc(&dev->refcnt);
 }
+#endif
+
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
--- a/lib/Kconfig.debug	2008-07-19 15:03:14.000000000 -0700
+++ b/lib/Kconfig.debug	2008-07-19 15:04:50.000000000 -0700
@@ -428,6 +428,13 @@ config DEBUG_KOBJECT
 	  If you say Y here, some extra kobject debugging messages will be sent
 	  to the syslog. 
 
+config DEBUG_NETDEV
+       bool "network device debugging"
+       depends on DEBUG_KERNEL
+       help
+	  This option enables extra checking on usage and reference counting
+	  of network devices.
+
 config DEBUG_HIGHMEM
 	bool "Highmem debugging"
 	depends on DEBUG_KERNEL && HIGHMEM
--- a/net/core/dev.c	2008-07-19 15:12:06.000000000 -0700
+++ b/net/core/dev.c	2008-07-19 22:12:06.000000000 -0700
@@ -4091,6 +4091,30 @@ static void netdev_wait_allrefs(struct n
 	}
 }
 
+#ifdef CONFIG_DEBUG_NETDEV
+/* This is for debugging reference counting of devices */
+int netdev_debug __read_mostly;
+
+void __dev_hold(struct net_device *dev, const char *func)
+{
+	atomic_inc(&dev->refcnt);
+	if (unlikely(netdev_debug))
+		printk(KERN_DEBUG "%s: dev_hold %d %s\n",
+		       dev->name, atomic_read(&dev->refcnt), func);
+}
+EXPORT_SYMBOL(__dev_hold);
+
+void __dev_put(struct net_device *dev, const char *func)
+{
+	BUG_ON(atomic_read(&dev->refcnt) == 0);
+	if (unlikely(netdev_debug))
+		printk(KERN_DEBUG "%s: dev_put %d %s\n",
+		       dev->name, atomic_read(&dev->refcnt), func);
+	atomic_dec(&dev->refcnt);
+}
+EXPORT_SYMBOL(__dev_put);
+#endif
+
 /* The sequence is:
  *
  *	rtnl_lock();
--- a/net/core/sysctl_net_core.c	2008-07-19 15:12:21.000000000 -0700
+++ b/net/core/sysctl_net_core.c	2008-07-19 15:29:53.000000000 -0700
@@ -140,6 +140,17 @@ static struct ctl_table net_core_table[]
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec
 	},
+#ifdef CONFIG_DEBUG_NETDEV
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "netdev_debug",
+		.data		= &netdev_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+
+#endif
 	{ .ctl_name = 0 }
 };
 
