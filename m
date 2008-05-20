Return-Path: <linux-kernel-owner+w=401wt.eu-S1765091AbYETMlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765091AbYETMlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYETMky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:40:54 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:37571 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYETMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:40:53 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re:
Date: Tue, 20 May 2008 14:40:46 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, greg@kroah.com, linux-usb@vger.kernel.org
References: <20080520123423.GA4764@ics.muni.cz>
In-Reply-To: <20080520123423.GA4764@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201440.47217.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 20 Mai 2008 14:34:23 schrieb Lukas Hejtmanek:
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

It is by no means fixed!

Now we find out what exactly doesn't work. Please apply this patch
and provide "dmesg -c" before you plug in the device and after that.

	Regards
		Oliver

---

--- linux-2.6.25/drivers/usb/host/ehci-hcd.c	2008-05-20 10:07:45.585199135 +0200
+++ alt/drivers/usb/host/ehci-hcd.c	2008-05-20 11:11:53.614580823 +0200
@@ -712,11 +712,15 @@ static irqreturn_t ehci_irq (struct usb_
 		unsigned	i = HCS_N_PORTS (ehci->hcs_params);
 		pcd_status = status;
 
+		printk(KERN_ERR"Detected PCD bit set\n");
 		/* resume root hub? */
-		if (!(ehci_readl(ehci, &ehci->regs->command) & CMD_RUN))
+		if (!(ehci_readl(ehci, &ehci->regs->command) & CMD_RUN)) {
+			printk(KERN_ERR"About to resume root hub due to PCD\n");
 			usb_hcd_resume_root_hub(hcd);
+		}
 
 		while (i--) {
+			printk(KERN_ERR"Checking motherboard port %d\n", i);
 			int pstatus = ehci_readl(ehci,
 						 &ehci->regs->port_status [i]);
 
@@ -730,6 +734,7 @@ static irqreturn_t ehci_irq (struct usb_
 			 * and make khubd collect PORT_STAT_C_SUSPEND to
 			 * stop that signaling.
 			 */
+			printk(KERN_ERR"Starting timer for port %d\n", i);
 			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
 			ehci_dbg (ehci, "port %d remote wakeup\n", i + 1);
 			mod_timer(&hcd->rh_timer, ehci->reset_done[i]);
--- linux-2.6.25/drivers/usb/core/hcd.c	2008-05-20 10:07:45.583199804 +0200
+++ alt/drivers/usb/core/hcd.c	2008-05-20 11:12:23.506597140 +0200
@@ -589,6 +589,8 @@ void usb_hcd_poll_rh_status(struct usb_h
 			hcd->poll_pending = 1;
 		}
 		spin_unlock_irqrestore(&hcd_root_hub_lock, flags);
+	} else {
+		printk(KERN_ERR"hub_status_data() returned 0\n");
 	}
 
 	/* The USB 2.0 spec says 256 ms.  This is close enough and won't
