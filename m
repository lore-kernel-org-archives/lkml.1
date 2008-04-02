Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYDBT0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYDBT0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYDBT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:26:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37368 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752902AbYDBT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:26:45 -0400
Date: Wed, 2 Apr 2008 15:26:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Pavel Machek <pavel@ucw.cz>, <linux-usb@vger.kernel.org>,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core
 Duo
In-Reply-To: <20080401210617.GA7346@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0804021521260.11421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Tino Keitel wrote:

> On Tue, Apr 01, 2008 at 17:02:36 -0400, Alan Stern wrote:
> > On Tue, 1 Apr 2008, Tino Keitel wrote:
> > 
> > > On Tue, Apr 01, 2008 at 15:06:51 -0400, Alan Stern wrote:
> > > 
> > > [...]
> > > 
> > > > Can you get any information out of the computer after the hang?  It 
> > > > would help to see the dmesg log (with CONFIG_USB_DEBUG enabled) and an 
> > > > Alt-SysRq-T stack dump.
> > > 
> > > Looks difficult. The text console stays black after resume, and there
> > > is no serial interface.
> > 
> > Network console?  SSH?  Or even telnet?
> 
> Network is dead, too.

Tino, try this patch.  It fixed Mark Lord's problem, which looked the 
same as yours.

Alan Stern



--- rc8/drivers/usb/host/ehci-hub.c	2008-03-11 11:18:40.000000000 -0400
+++ linux/drivers/usb/host/ehci-hub.c	2008-04-02 13:28:50.000000000 -0400
@@ -135,8 +135,6 @@
 		hcd->state = HC_STATE_QUIESCING;
 	}
 	ehci->command = ehci_readl(ehci, &ehci->regs->command);
-	if (ehci->reclaim)
-		end_unlink_async(ehci);
 	ehci_work(ehci);
 
 	/* Unlike other USB host controller types, EHCI doesn't have
@@ -180,6 +178,9 @@
 	ehci_halt (ehci);
 	hcd->state = HC_STATE_SUSPENDED;
 
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
 	/* allow remote wakeup */
 	mask = INTR_MASK;
 	if (!device_may_wakeup(&hcd->self.root_hub->dev))



