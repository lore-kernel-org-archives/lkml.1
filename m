Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbYETPU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbYETPU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbYETPUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:20:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47111 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932524AbYETPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:20:12 -0400
Date: Tue, 20 May 2008 11:20:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>
Subject: Re: your mail
In-Reply-To: <20080520123423.GA4764@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0805201117430.2114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Lukas Hejtmanek wrote:

> <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
> Bcc: 
> Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
> 	until reload of ehci-hcd
> Reply-To: 
> In-Reply-To: <200805201327.34678.oliver@neukum.org>
> X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
> 
> On Tue, May 20, 2008 at 01:27:34PM +0200, Oliver Neukum wrote:
> > > done.
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> > 
> > Aha. Thanks.
> > Please recompile without CONFIG_USB_SUSPEND
> 
> Hm, without USB_SUSPEND it works. So what next, considered fixed or any
> further investigation is needed?

No further investigation is needed.  I tried doing essentially the same 
thing on my system and the same problem occurred.

It is caused by the way ehci-hcd "auto-clears" the port
change-suspend feature.  This patch should fix the problem.  Please 
try it out and let us know if it works.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci.h
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci.h
+++ usb-2.6/drivers/usb/host/ehci.h
@@ -97,6 +97,8 @@ struct ehci_hcd {			/* one per controlle
 			dedicated to the companion controller */
 	unsigned long		owned_ports;		/* which ports are
 			owned by the companion during a bus suspend */
+	unsigned long		port_c_suspend;		/* which ports have
+			the change-suspend feature turned on */
 
 	/* per-HC memory pools (could be per-bus, but ...) */
 	struct dma_pool		*qh_pool;	/* qh per active urb */
Index: usb-2.6/drivers/usb/host/ehci-hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hub.c
+++ usb-2.6/drivers/usb/host/ehci-hub.c
@@ -609,7 +609,7 @@ static int ehci_hub_control (
 			}
 			break;
 		case USB_PORT_FEAT_C_SUSPEND:
-			/* we auto-clear this feature */
+			clear_bit(wIndex, &ehci->port_c_suspend);
 			break;
 		case USB_PORT_FEAT_POWER:
 			if (HCS_PPC (ehci->hcs_params))
@@ -688,7 +688,7 @@ static int ehci_hub_control (
 			/* resume completed? */
 			else if (time_after_eq(jiffies,
 					ehci->reset_done[wIndex])) {
-				status |= 1 << USB_PORT_FEAT_C_SUSPEND;
+				set_bit(wIndex, &ehci->port_c_suspend);
 				ehci->reset_done[wIndex] = 0;
 
 				/* stop resume signaling */
@@ -765,6 +765,8 @@ static int ehci_hub_control (
 			status |= 1 << USB_PORT_FEAT_RESET;
 		if (temp & PORT_POWER)
 			status |= 1 << USB_PORT_FEAT_POWER;
+		if (test_bit(wIndex, &ehci->port_c_suspend))
+			status |= 1 << USB_PORT_FEAT_C_SUSPEND;
 
 #ifndef	VERBOSE_DEBUG
 	if (status & ~0xffff)	/* only if wPortChange is interesting */

