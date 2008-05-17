Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbYEQXYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbYEQXYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYEQXYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:24:43 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:44633 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYEQXYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:24:42 -0400
Date: Sun, 18 May 2008 01:24:11 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: hibernate event order question
Message-ID: <20080517232411.GA8792@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
References: <20080517175046.GA9032@yamamaya.is-a-geek.org> <200805172156.12686.rjw@sisk.pl> <20080517223622.GA2668@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080517223622.GA2668@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> > > Shouldn't there be a 'prepare for poweroff'-callback, which gets
> > > called
> > > before the system is powered off for real?
> > 
> > Yes, it should and it's called in recent kernels.
> 
> For what values of 'recent'?
> I'm running 2.6.26-rc2 here. :)
> How do I hook into this callback?
> (suspend_late maybe? Going to try that one next...)

Ok, this patch fixes the 'regression' introduced by the previous
patch (at least for me ;)):

Index: linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.26-rc2.forcedwol.orig/drivers/net/forcedeth.c	2008-05-18 01:10:18.000000000 +0200
+++ linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c	2008-05-18 01:11:33.000000000 +0200
@@ -5828,8 +5828,24 @@
 out:
 	return rc;
 }
+
+static void nv_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
+	u8 __iomem *base = get_hwbase(dev);
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
 
@@ -6000,6 +6016,7 @@
 	.remove		= __devexit_p(nv_remove),
 	.suspend	= nv_suspend,
 	.resume		= nv_resume,
+	.shutdown	= nv_shutdown,
 };
 
 static int __init init_nic(void)

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
