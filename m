Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0BWTRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:17:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:25440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab0BWTRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:17:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,527,1262592000"; 
   d="scan'208";a="494965055"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Feb 2010 11:17:07 -0800
Subject: RE: [PATCH net-next 6/7] drivers/net/e1000e: Use pr_<level> and
 netdev_<level>
Thread-Topic: [PATCH net-next 6/7] drivers/net/e1000e: Use pr_<level> and
 netdev_<level>
Thread-Index: Acq0M++BHBZDEoeeTG+/j1Lry5WNRwAgH4ig
Message-ID: <8DD2590731AB5D4C9DBF71A877482A90614784CF@orsmsx509.amr.corp.intel.com>
References: <cover.1266893507.git.joe@perches.com>
 <78b154eab5d37da22dda3bf3e77fe32013009fa3.1266893508.git.joe@perches.com>
In-Reply-To: <78b154eab5d37da22dda3bf3e77fe32013009fa3.1266893508.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 22, 2010 6:57 PM, Joe Perches wrote:
> Convert e_<level> to netdev_<level>
> Remove #define PFX
> Use #define pr_fmt
> Convert a few printks to pr_<level>
> Coalesce long formats
> Typo spelling fix
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/e1000e/82571.c   |   57 +++++++++++-------
>  drivers/net/e1000e/e1000.h   |   21 -------
>  drivers/net/e1000e/es2lan.c  |   27 +++++----
>  drivers/net/e1000e/ethtool.c |   37 ++++++------
>  drivers/net/e1000e/ich8lan.c |   90 +++++++++++++++++------------
>  drivers/net/e1000e/lib.c     |  131
>  +++++++++++++++++++++---------------------
>  drivers/net/e1000e/netdev.c  |   95 +++++++++++++++---------------
>  drivers/net/e1000e/param.c   |   20 +++--- drivers/net/e1000e/phy.c 
>  |  114 ++++++++++++++++++------------------ 9 files changed, 302
> insertions(+), 290 deletions(-) 
> 

As an alternative to Joe's large patch to e1000e, I would like to suggest the following much less intrusive patch.  Compile-tested only.
  
Convert e_<level> to netdev_<level>
Use #define pr_fmt
Convert a few printks to pr_<level>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/e1000e/e1000.h  |   19 +++++--------------
 drivers/net/e1000e/netdev.c |    9 +++++----
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index c2ec095..ecd817f 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -42,25 +42,16 @@
 
 struct e1000_info;
 
-#define e_printk(level, adapter, format, arg...) \
-	printk(level "%s: %s: " format, pci_name(adapter->pdev), \
-	       adapter->netdev->name, ## arg)
-
-#ifdef DEBUG
 #define e_dbg(format, arg...) \
-	e_printk(KERN_DEBUG , hw->adapter, format, ## arg)
-#else
-#define e_dbg(format, arg...) do { (void)(hw); } while (0)
-#endif
-
+	netdev_dbg(hw->adapter->netdev, format, ## arg)
 #define e_err(format, arg...) \
-	e_printk(KERN_ERR, adapter, format, ## arg)
+	netdev_err(adapter->netdev, format, ## arg)
 #define e_info(format, arg...) \
-	e_printk(KERN_INFO, adapter, format, ## arg)
+	netdev_info(adapter->netdev, format, ## arg)
 #define e_warn(format, arg...) \
-	e_printk(KERN_WARNING, adapter, format, ## arg)
+	netdev_warn(adapter->netdev, format, ## arg)
 #define e_notice(format, arg...) \
-	e_printk(KERN_NOTICE, adapter, format, ## arg)
+	netdev_notice(adapter->netdev, format, ## arg)
 
 
 /* Interrupt modes, as used by the IntMode parameter */
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 88d54d3..d83c3cf 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -26,6 +26,8 @@
 
 *******************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -5403,10 +5405,9 @@ static struct pci_driver e1000_driver = {
 static int __init e1000_init_module(void)
 {
 	int ret;
-	printk(KERN_INFO "%s: Intel(R) PRO/1000 Network Driver - %s\n",
-	       e1000e_driver_name, e1000e_driver_version);
-	printk(KERN_INFO "%s: Copyright (c) 1999 - 2009 Intel Corporation.\n",
-	       e1000e_driver_name);
+	pr_info("Intel(R) PRO/1000 Network Driver - %s\n",
+	       e1000e_driver_version);
+	pr_info("Copyright (c) 1999 - 2009 Intel Corporation.\n");
 	ret = pci_register_driver(&e1000_driver);
 
 	return ret;
