Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZD3Gzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZD3Gzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZD3Gza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:55:30 -0400
Received: from [158.64.110.167] ([158.64.110.167]:39992 "EHLO
	bonbons.gotdns.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZD3Gz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:55:29 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 02:55:29 EDT
Date: Thu, 30 Apr 2009 08:45:17 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] netconsole: take care of NETDEV_UNREGISTER
 event
Message-ID: <20090430084517.6de15689@pluto.restena.lu>
In-Reply-To: <20090429.144420.262432582.davem@davemloft.net>
References: <20090429223722.62da9dcd@neptune.home>
	<20090429225625.75a016ff@neptune.home>
	<20090429.144420.262432582.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When netconsole is loaded and a network interface fades away (e.g. on
rmmod $interface_driver_module) the rmmod remains stuck and some locks
are taken that prevent any additional module loading/unloading as well
as interface up/down changes.
In addition kernel logs (and console) get flooded at 10s interval with

[  122.464065] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[  132.704059] unregister_netdevice: waiting for eth0 to become free. Usage count = 1

This patch lets netconsole take NETDEV_UNREGISTER event into account
and release the affected interface if it was in use.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index eceadf7..bf4af52 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -664,7 +664,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 	struct netconsole_target *nt;
 	struct net_device *dev = ptr;
 
-	if (!(event == NETDEV_CHANGENAME))
+	if (!(event == NETDEV_CHANGENAME || event == NETDEV_UNREGISTER))
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
@@ -675,6 +675,15 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			case NETDEV_CHANGENAME:
 				strlcpy(nt->np.dev_name, dev->name, IFNAMSIZ);
 				break;
+			case NETDEV_UNREGISTER:
+				if (!nt->enabled)
+					break;
+				netpoll_cleanup(&nt->np);
+				nt->enabled = 0;
+				printk(KERN_INFO "netconsole: network logging stopped"
+					", interface %s unregistered\n",
+					dev->name);
+				break;
 			}
 		}
 		netconsole_target_put(nt);
