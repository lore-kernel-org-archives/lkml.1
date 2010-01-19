Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388Ab0ASIee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0ASIee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821Ab0ASIed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:34:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:2898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0ASIeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,302,1262592000"; 
   d="scan'208";a="588344765"
Date: Tue, 19 Jan 2010 16:31:31 +0800
From: alek du <alek.du@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>
CC: Julia Lawall <julia@diku.dk>, Andreas Mohr <andi@lisas.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] ehci: phy low power mode bug fixing
Message-ID: <20100119163131.0af9f540@dxy2>
In-Reply-To: <201001182325.11201.arnd@arndb.de>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
	<201001182223.49764.arnd@arndb.de>
	<Pine.LNX.4.64.1001182235050.30446@ask.diku.dk>
	<201001182325.11201.arnd@arndb.de>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should fix the bug and I tested it with Moorestown platform...
But the strange thing is that even the original code does not trigger the
"scheduling while atomic" issue...

>From ca7833d854867e91d6aa6bccf1f3224862b3a25c Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Tue, 19 Jan 2010 16:05:15 +0800
Subject: [PATCH] ehci: phy low power mode bug fixing

1. There are two msleep calls inside two spin lock sections, need to unlock
   and lock again after msleep.
2. Save a extra status reg setting.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/usb/host/ehci-hub.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 2c6571c..7d77fbb 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -178,7 +178,9 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 			if (hostpc_reg) {
 				u32	t3;
 
+				spin_unlock_irq(&ehci->lock);
 				msleep(5);/* 5ms for HCD enter low pwr mode */
+				spin_lock_irq(&ehci->lock);
 				t3 = ehci_readl(ehci, hostpc_reg);
 				ehci_writel(ehci, t3 | HOSTPC_PHCD, hostpc_reg);
 				t3 = ehci_readl(ehci, hostpc_reg);
@@ -886,17 +888,18 @@ static int ehci_hub_control (
 			if ((temp & PORT_PE) == 0
 					|| (temp & PORT_RESET) != 0)
 				goto error;
-			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
+
 			/* After above check the port must be connected.
 			 * Set appropriate bit thus could put phy into low power
 			 * mode if we have hostpc feature
 			 */
+			temp &= ~PORT_WKCONN_E;
+			temp |= PORT_WKDISC_E | PORT_WKOC_E;
+			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
 			if (hostpc_reg) {
-				temp &= ~PORT_WKCONN_E;
-				temp |= (PORT_WKDISC_E | PORT_WKOC_E);
-				ehci_writel(ehci, temp | PORT_SUSPEND,
-							status_reg);
+				spin_unlock_irqrestore(&ehci->lock, flags);
 				msleep(5);/* 5ms for HCD enter low pwr mode */
+				spin_lock_irqsave(&ehci->lock, flags);
 				temp1 = ehci_readl(ehci, hostpc_reg);
 				ehci_writel(ehci, temp1 | HOSTPC_PHCD,
 					hostpc_reg);
-- 
1.6.3.3


On Tue, 19 Jan 2010 06:25:10 +0800
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 18 January 2010, Julia Lawall wrote:
> > > That code looks indeed broken as was added las July as part of
> > > 331ac6b288d9 "USB: EHCI: Add Intel Moorestown EHCI controller
> > > HOSTPCx extensions and support phy low power mode". The reason
> > > that this hasn't triggered is probably the lack of Moorestown
> > > machines in the field.
> > 
> > The fix is just msleep -> mdelay?
> 
> No, that would just kill the warning but still leave horrible code.
> There should really be some way to move the sleeping operation
> outside of the spinlock.
> 
> From a brief look at the code, I think the sequence could be converted
> from
> 
> lock();
> suspend();
> sleep();
> clock_disable();
> unlock();
> 
> to
> 
> lock();
> again:
> suspend();
> unlock();
> sleep();
> lock();
> if (!suspended())
>    goto again;
> clock_disable();
> unlock();
> 
> 	Arnd

