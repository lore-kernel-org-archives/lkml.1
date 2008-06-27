Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbYF0QK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbYF0QK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYF0QKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:10:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3185 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757035AbYF0QKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:10:11 -0400
Date: Fri, 27 Jun 2008 12:10:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <48641325.2020903@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806271200190.25362-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Stefan Becker wrote:

> Yes, the initial try was misleading. I tinkered around a little bit more 
> and finally figured out that it is usb_hcd_unlink_urb_from_ep() itself 
> that is called with interrupts enabled!
> 
> 
> So with this code in place the error disappears:
> 
> void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
> {
> 	/* clear all state linking urb to this dev (and hcd) */
> 	unsigned int flags;
> 	spin_lock_irqsave(&hcd_urb_list_lock, flags);
> 	list_del_init(&urb->urb_list);
> 	spin_unlock_irqrestore(&hcd_urb_list_lock, flags);
> }
> 
> This seems to impact USB performance though. In 2.6.23 (without the 
> problem) I get 21MB/s with dd, but with the above "fix" only 14MB/s. But 
>   I'll recheck once we have a real error fix in place.
> 
> 
> After that I added the following code
> 
>          if (!raw_irqs_disabled()) {
> 	  printk(KERN_CRIT "usb_hcd_unlink_urb_from_ep called with interrupts 
> enabled!\n");
> 	  dump_stack();
> 	}
> 
> and collected the attached kernel messages. I checked the messages 
> briefly and it seems that the following code paths have the interrupts 
> enabled when calling usb_hcd_unlink_urb_from_ep():
> 
>    [<c0574d9d>] usb_hcd_unlink_urb_from_ep+0x25/0x6b
>    [<de850559>] uhci_giveback_urb+0xcd/0x1e3 [uhci_hcd]
>    [<de850e02>] uhci_scan_schedule+0x511/0x720 [uhci_hcd]
> ...
>    [<de8529c3>] uhci_irq+0x131/0x142 [uhci_hcd]
>    [<c05750cb>] usb_hcd_irq+0x23/0x51
> 
> and
> 
>    [<c0574d9d>] usb_hcd_unlink_urb_from_ep+0x25/0x6b
>    [<de839d55>] ehci_urb_done+0x73/0x92 [ehci_hcd]
>    [<de83a92f>] qh_completions+0x373/0x3eb [ehci_hcd]
>    [<de83aa43>] ehci_work+0x9c/0x6a9 [ehci_hcd]
> ...
>    [<de83ec3c>] ehci_irq+0x241/0x265 [ehci_hcd]
> ...
>    [<c05750cb>] usb_hcd_irq+0x23/0x51
> 
> 
> Is that enough information to fix the problem?

I don't know, but it's a good start.  The IRQs for uhci-hcd and
ehci-hcd are registered using the IRQF_DISABLED flag, which means that
the handler routines uhci_irq() and ehci_irq() should always be called
with interrupts disabled.

So that's the next thing to test.  Put a raw_irqs_disabled() test at
the start of those two routines, just to make sure that interrupts
don't somehow get enabled by mistake while the routine is running.  If 
interrupts are already enabled when the routines are called then the 
bug is somewhere else in the kernel.

(To make things simpler, you could concentrate on uhci_irq() and
unload ehci-hcd before running the test.)

Alan Stern

