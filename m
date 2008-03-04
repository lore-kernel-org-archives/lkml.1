Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbYCDSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbYCDSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764704AbYCDSxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:53:48 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:57649 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760382AbYCDSxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:53:47 -0500
Date: Tue, 4 Mar 2008 19:53:33 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Alan Stern <stern@rowland.harvard.edu>
cc: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       0x0007@gmail.com, USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <Pine.LNX.4.44L0.0803041118100.4039-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.1.00.0803041948230.5974@sheep.housecafe.de>
References: <Pine.LNX.4.44L0.0803041118100.4039-100000@iolanthe.rowland.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Alan Stern wrote:
> How about replacing the
>
> 	WARN_ON(!ehci->reclaim);
>
> line in ehci_iaa_watchdog() with
>
> 	if (unlikely(!ehci->reclaim ||
> 			!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) ||
> 			timer_pending(&ehci->iaa_watchdog))
> 		goto done;
>
> where "done:" is added just before the spin_unlock_irqrestore?

I'm not sure, but do you mean:

--- linux-2.6/drivers/usb/host/ehci-hcd.c	2008-02-24 22:25:54.000000000 +0100
+++ linux-2.6/drivers/usb/host/ehci-hcd.c.edited	2008-03-04 19:46:13.000000000 +0100
@@ -284,7 +284,10 @@ static void ehci_iaa_watchdog(unsigned l
  	u32			status, cmd;

  	spin_lock_irqsave (&ehci->lock, flags);
-	WARN_ON(!ehci->reclaim);
+	if (unlikely(!ehci->reclaim ||
+			!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) ||
+			timer_pending(&ehci->iaa_watchdog))
+	goto done;

  	status = ehci_readl(ehci, &ehci->regs->status);
  	cmd = ehci_readl(ehci, &ehci->regs->command);


Thanks,
Christian.
-- 
BOFH excuse #189:

SCSI's too wide.
