Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYERLXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYERLXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYERLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:23:23 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:48151 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbYERLXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:23:21 -0400
Date: Sun, 18 May 2008 13:22:48 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: hibernate event order question
Message-ID: <20080518112247.GA10502@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
References: <20080517175046.GA9032@yamamaya.is-a-geek.org> <20080517223622.GA2668@yamamaya.is-a-geek.org> <20080517232411.GA8792@yamamaya.is-a-geek.org> <200805181245.13899.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805181245.13899.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 18 of May 2008, Tobias Diedrich wrote:
> > Tobias Diedrich wrote:
> > > > > Shouldn't there be a 'prepare for poweroff'-callback, which gets
> > > > > called
> > > > > before the system is powered off for real?
> > > > 
> > > > Yes, it should and it's called in recent kernels.
> > > 
> > > For what values of 'recent'?
> > > I'm running 2.6.26-rc2 here. :)
> > > How do I hook into this callback?
> > > (suspend_late maybe? Going to try that one next...)
> > 
> > Ok, this patch fixes the 'regression' introduced by the previous
> > patch (at least for me ;)):
> 
> Well, what exactly do you do to hibernate the box?

/usr/local/bin/s2disk:
|#!/bin/sh
|
|SYSPRINTK=/proc/sys/kernel/printk
|OLDPRINTK=$(cat $SYSPRINTK)
|chvt 1
|# work around forcedeth wake-on-lan bug
|#rmmod forcedeth
|echo 9 > $SYSPRINTK
|# shutdown/reboot/platform
|echo shutdown > /sys/power/disk
|echo disk > /sys/power/state
|echo "$OLDPRINTK" > $SYSPRINTK
|# work around forcedeth wake-on-lan bug
|#modprobe forcedeth
|#brctl addif br0 eth0
|#brctl addif br0 eth1
|#ifconfig eth0 up
|#ifconfig eth1 up

I now also now why I get the 'swapped mac' problem:

In my case (DEV_HAS_CORRECT_MACADDR unset and
NVREG_TRANSMITPOLL_MAC_ADDR_REV unset on probe)
nv_probe() reads the original macaddress in reversed order to
correct it and sets NVREG_TRANSMITPOLL_MAC_ADDR_REV.

However the suspend/resume path does not touch the mac address at
all, so after a cold boot and resume from disk the macaddress is
again in 'BIOS order' and NVREG_TRANSMITPOLL_MAC_ADDR_REV is unset,
but NVREG_TRANSMITPOLL_MAC_ADDR_REV gets set unconditionally in
nv_resume(), so the net effect is that the MAC is now reversed.

With the promisc fix this is hidden for my brige setup and only
noticeable at the next hibernate, where I now have to use a reversed
MAC to wakeup the device.

The following patch (on top of the other two) fixes this by saving
and restoring the memory mapped device configuration space in
suspend/resume.  The shutdown hook is still needed since the promisc
mode seems to be incompatible with wake on lan.

It also reorders the code in suspend/resume to match that in e100/e1000e.
(configuration space is also saved for devices that are not running)

Index: linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.26-rc2.forcedwol.orig/drivers/net/forcedeth.c	2008-05-18 11:26:12.000000000 +0200
+++ linux-2.6.26-rc2.forcedwol/drivers/net/forcedeth.c	2008-05-18 13:00:23.000000000 +0200
@@ -426,6 +426,7 @@
 #define NV_PCI_REGSZ_VER1      	0x270
 #define NV_PCI_REGSZ_VER2      	0x2d4
 #define NV_PCI_REGSZ_VER3      	0x604
+#define NV_PCI_REGSZ_MAX       	0x604
 
 /* various timeout delays: all in usec */
 #define NV_TXRX_RESET_DELAY	4
@@ -784,6 +785,9 @@
 
 	/* flow control */
 	u32 pause_flags;
+
+	/* power saved state */
+	u32 saved_config_space[NV_PCI_REGSZ_MAX/4];
 };
 
 /*
@@ -5785,19 +5789,24 @@
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct fe_priv *np = netdev_priv(dev);
-
-	if (!netif_running(dev))
-		goto out;
+	u8 __iomem *base = get_hwbase(dev);
+	int i;
 
 	netif_device_detach(dev);
 
-	// Gross.
-	nv_close(dev);
+	if (netif_running(dev)) {
+		// Gross.
+		nv_close(dev);
+	}
+
+	/* save non-pci configuration space */
+	for (i = 0;i <= np->register_size/sizeof(u32); i++)
+		np->saved_config_space[i] = readl(base + i*sizeof(u32));
 
 	pci_save_state(pdev);
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), np->wolenabled);
+	pci_disable_device(pdev);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-out:
 
 	return 0;
 }
@@ -5805,27 +5814,25 @@
 static int nv_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	int rc = 0;
-	u32 txreg;
-
-	if (!netif_running(dev))
-		goto out;
-
-	netif_device_attach(dev);
+	int i, rc = 0;
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	/* restore mac address reverse flag */
-	txreg = readl(base + NvRegTransmitPoll);
-	txreg |= NVREG_TRANSMITPOLL_MAC_ADDR_REV;
-	writel(txreg, base + NvRegTransmitPoll);
+	/* restore non-pci configuration space */
+	for (i = 0;i <= np->register_size/sizeof(u32); i++)
+		writel(np->saved_config_space[i], base+i*sizeof(u32));
+
+	netif_device_attach(dev);
+	if (netif_running(dev)) {
+		rc = nv_open(dev);
+		nv_set_multicast(dev);
+	}
 
-	rc = nv_open(dev);
-	nv_set_multicast(dev);
-out:
 	return rc;
 }
 
@@ -5833,7 +5840,6 @@
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct fe_priv *np = netdev_priv(dev);
-	u8 __iomem *base = get_hwbase(dev);
 
 	if (netif_running(dev))
 		nv_close(dev);
@@ -5841,7 +5847,9 @@
 	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
 	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
 	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
+	if (np->wolenabled) 
+		pci_set_power_state(pdev, PCI_D3hot);
+	else pci_set_power_state(pdev, PCI_D3cold);
 }
 #else
 #define nv_suspend NULL

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
