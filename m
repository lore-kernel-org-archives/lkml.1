Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYERNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYERNDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYERNDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 09:03:11 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:39373 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYERNDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 09:03:10 -0400
Date: Sun, 18 May 2008 15:02:37 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 2/4] setup wake-on-lan before shutting down
Message-ID: <20080518130236.GB21417@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518125715.GA19229@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

When hibernating in 'shutdown' mode, after saving the image the suspend hook
is not called again.
However, if the device is in promiscous mode, wake-on-lan will not work.
This adds a shutdown hook to setup wake-on-lan before the final shutdown.

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

Index: linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.26-rc2.forcedwol.orig/drivers/net/forcedeth.c	2008-05-18 13:53:02.000000000 +0200
+++ linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c	2008-05-18 13:53:06.000000000 +0200
@@ -5827,8 +5827,23 @@
 out:
 	return rc;
 }
+
+static void nv_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
+
+	if (netif_running(dev))
+		nv_close(dev);
+
+	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
+	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+}
 #else
 #define nv_suspend NULL
+#define nv_shutdown NULL
 #define nv_resume NULL
 #endif /* CONFIG_PM */
 
@@ -5999,6 +6014,7 @@
 	.remove		= __devexit_p(nv_remove),
 	.suspend	= nv_suspend,
 	.resume		= nv_resume,
+	.shutdown	= nv_shutdown,
 };
 
 static int __init init_nic(void)
