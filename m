Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab0BDTPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:15:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52975 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757891Ab0BDTPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:15:11 -0500
Date: Thu, 4 Feb 2010 14:15:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Corey Wright <undefined@pobox.com>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
In-Reply-To: <20100204014653.1ed6b9e3.undefined@pobox.com>
Message-ID: <Pine.LNX.4.44L0.1002041407151.1261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Corey Wright wrote:

> after applying the patch the system suspended successfully three times in a
> row (before i got tired of watching it resume, which takes minutes due to
> bios hardware initialization).
> 
> i looked in dmesg after a suspend and all the usb debug messages looked
> innocuous.
> 
> the patch appears to have fixed the problem.  i need to rebuild the
> netbook's kernel with the new patch and see if that fixes it, too.  if it
> doesn't fix the netboot suspending, then i'll follow-up.
> 
> thanks for your time debugging the problem and for the patch!

Below is a slightly improved version of the patch.  It's what I intend 
to submit for 2.6.27.stable.  I'd appreciate your testing it to make 
sure that it behaves properly on both machines.

Be sure to set CONFIG_USB_DEBUG in the netbook's kernel too.  If the 
reason for its failure turns out to be different, we'll need the extra 
information.

Alan Stern


-----------------------------------------------------------------------

This patch fixes a bug caused by backporting commit
cec3a53c7fe794237b582e8e77fc0e48465e65ee (USB: EHCI & UHCI: fix race
between root-hub suspend and port resume) to 2.6.27.stable without
also backporting commit eafe5b99f2135488b21cf17a262c54997c44f784 (USB:
EHCI: fix remote-wakeup support for ARC/TDI core).  This extracts the
necessary changes from the earlier patch and backports them.

The symptom of the bug is that the system will fail to suspend more
than once.  The problem is caused by setting ehci->reset_done[i] but
never clearing it.  When ehci_bus_suspend() sees a nonzero value
there, it assumes this means the port is in the middle of resuming so
it aborts the bus suspend.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: 2.6.27.45/drivers/usb/host/ehci-hub.c
===================================================================
--- 2.6.27.45.orig/drivers/usb/host/ehci-hub.c
+++ 2.6.27.45/drivers/usb/host/ehci-hub.c
@@ -254,10 +254,8 @@ static int ehci_bus_resume (struct usb_h
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+				(temp & PORT_SUSPEND))
 			temp |= PORT_RESUME;
-		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
 	i = HCS_N_PORTS (ehci->hcs_params);
@@ -752,6 +750,9 @@ static int ehci_hub_control (
 					ehci_readl(ehci, status_reg));
 		}
 
+		if (!(temp & (PORT_RESUME|PORT_RESET)))
+			ehci->reset_done[wIndex] = 0;
+
 		/* transfer dedicated ports to the companion hc */
 		if ((temp & PORT_CONNECT) &&
 				test_bit(wIndex, &ehci->companion_ports)) {

