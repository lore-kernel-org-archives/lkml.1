Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZCYOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZCYOHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZCYOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:07:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48221 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZCYOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:07:20 -0400
From: Subrata Modak <tosubrata@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Sachin Sant <sachinp@in.ibm.com>, Subrata Modak <tosubrata@gmail.com>,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Mar 2009 19:37:13 +0530
Message-Id: <20090325140713.4919.64147.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Re: Next March 25: staging/epl build break.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>Today's next x86 randconfig build failed with
>
>drivers/staging/epl/VirtualEthernetLinux.c: In function VEthAddInstance:
>drivers/staging/epl/VirtualEthernetLinux.c:302: error: struct net_device has no member named open
>drivers/staging/epl/VirtualEthernetLinux.c:303: error: struct net_device has no member named stop
>drivers/staging/epl/VirtualEthernetLinux.c:304: error: struct net_device has no member named get_stats
>drivers/staging/epl/VirtualEthernetLinux.c:305: error: struct net_device has no member named hard_start_xmit
>drivers/staging/epl/VirtualEthernetLinux.c:306: error: struct net_device has no member named tx_timeout
>

The above build problem reported by Sachin can be fixed with the
patch below. However, it still will leave with the following
warnings, which i think can be ignored:

drivers/staging/epl/VirtualEthernetLinux.c:164: warning: ‘VEthOpen’ defined but not used
drivers/staging/epl/VirtualEthernetLinux.c:183: warning: ‘VEthClose’ defined but not used
drivers/staging/epl/VirtualEthernetLinux.c:196: warning: ‘VEthXmit’ defined but not used
drivers/staging/epl/VirtualEthernetLinux.c:231: warning: ‘VEthGetStats’ defined but not used
drivers/staging/epl/VirtualEthernetLinux.c:238: warning: ‘VEthTimeout’ defined but not used

>.config attached.
>
>Thanks
>-Sachin

Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>
---

--- a/linux-2.6.29/drivers/staging/epl/Kconfig	2009-03-24 04:42:14.000000000 +0530
+++ b/linux-2.6.29/drivers/staging/epl/Kconfig	2009-03-25 19:01:18.000000000 +0530
@@ -1,6 +1,7 @@
 config EPL
 	tristate "openPOWERLINK protocol stack"
 	depends on NET && HIGH_RES_TIMERS && X86
+        depends on COMPAT_NET_DEV_OPS
 	default N
 	---help---
 	  Enable support for the openPOWERLINK network protocol stack.
--- a/linux-2.6.29/drivers/staging/epl/VirtualEthernetLinux.c	2009-03-25 18:38:06.000000000 +0530
+++ b/linux-2.6.29/drivers/staging/epl/VirtualEthernetLinux.c	2009-03-25 19:03:16.000000000 +0530
@@ -299,11 +299,13 @@ tEplKernel VEthAddInstance(tEplDllkInitP
 		goto Exit;
 	}
 
+#ifdef CONFIG_COMPAT_NET_DEV_OPS
 	pVEthNetDevice_g->open = VEthOpen;
 	pVEthNetDevice_g->stop = VEthClose;
 	pVEthNetDevice_g->get_stats = VEthGetStats;
 	pVEthNetDevice_g->hard_start_xmit = VEthXmit;
 	pVEthNetDevice_g->tx_timeout = VEthTimeout;
+#endif
 	pVEthNetDevice_g->watchdog_timeo = EPL_VETH_TX_TIMEOUT;
 	pVEthNetDevice_g->destructor = free_netdev;

--
Regards--
Subrata
 
