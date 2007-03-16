Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXCPNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXCPNec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXCPNec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:34:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44280 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511AbXCPNeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:34:31 -0400
Date: Fri, 16 Mar 2007 09:34:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: stable@kernel.org
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] EHCI: add delay to bus_resume before accessing ports
Message-ID: <Pine.LNX.4.44L0.0703160928380.3039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as870) adds a delay to ehci-hcd's bus_resume routine.
Apparently there are controllers and/or BIOSes out there which need
such a delay to get the ports back into their correct state.  This
fixes Bugzilla #8190.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This is for 2.6.20-stable.  Earlier kernels aren't so eager to suspend 
EHCI buses and so don't need this fix.


Index: 2.6.20/drivers/usb/host/ehci-hub.c
===================================================================
--- 2.6.20.orig/drivers/usb/host/ehci-hub.c
+++ 2.6.20/drivers/usb/host/ehci-hub.c
@@ -134,6 +134,10 @@ static int ehci_bus_resume (struct usb_h
 	/* restore CMD_RUN, framelist size, and irq threshold */
 	writel (ehci->command, &ehci->regs->command);
 
+	/* Some controller/firmware combinations need a delay during which
+	 * they set up the port statuses.  See Bugzilla #8190. */
+	mdelay(8);
+
 	/* manually resume the ports we suspended during bus_suspend() */
 	i = HCS_N_PORTS (ehci->hcs_params);
 	while (i--) {

