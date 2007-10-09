Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbXJIRkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbXJIRkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXJIRj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:39:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXJIRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:39:55 -0400
Date: Tue, 9 Oct 2007 10:39:25 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Miller <davem@davemloft.net>, David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB users list <linux-usb-users@lists.sourceforge.net>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Message-ID: <20071009173925.GA6062@kroah.com>
References: <20071008.201653.43030513.davem@davemloft.net> <Pine.LNX.4.44L0.0710091156100.4783-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710091156100.4783-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 12:01:54PM -0400, Alan Stern wrote:
> On Mon, 8 Oct 2007, David Miller wrote:
> 
> > As coicidence would have it I finally found a recipe for triggering
> > the issue, and it ties into what you're talking about here.
> > 
> > It happens only if I make sure OHCI gets loaded first and then EHCI
> > right afterwards.
> > 
> > It seems that indeed it is important for EHCI to get loaded first,
> > and in-kernel this is ensured by the link ordering.
> > 
> > However, when both OHCI and EHCI are built as modules (or, similarly
> > I guess, OHCI is built-in and EHCI is modular) there appears to be
> > nothing in userspace which makes sure EHCI gets loaded first.
> > 
> > When this triggers, in OHCI's root_port_reset(), the port status
> > register reads 0x111 in that inner-loop and the value never changes.
> > It stays like this forever.
> 
> I agree with Ben; the best way to solve this is in the kernel.  Even if 
> you did manage to make sure that modules were loaded in the right order 
> initially, that wouldn't help if somebody starts unloading and loading 
> modules by hand.
> 
> The underlying cause of the problem appears to be related to the fact
> that it is impossible in principle to detect a disconnect while a
> full/low-speed reset is in progress.  However the hardware shouldn't
> rely on this, and it should fail gracefully when an unexpected
> disconnect does occur.
> 
> For example, what would the controller do if the user unplugged the USB 
> cable right in the middle of a reset?
> 
> Anyway, it certainly would be easy enough to make port resets mutually
> exclusive with EHCI initialization.  That would work on any platform,
> PCI or not.

That's a good idea, any thoughts as to how to do this?  I think I can
find some Intel and Dell people who would be glad to test this out if
you have a proposed patch.

thanks,

greg k-h
