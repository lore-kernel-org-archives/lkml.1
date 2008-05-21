Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbYEUOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbYEUOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYEUOqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:46:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755285AbYEUOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:46:45 -0400
Date: Wed, 21 May 2008 10:46:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <lchiquitto@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <Pine.LNX.4.64.0805211620270.6718@jikos.suse.cz>
Message-ID: <Pine.LNX.4.44L0.0805211042070.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Jiri Kosina wrote:

> On Wed, 21 May 2008, Alan Stern wrote:
> 
> > > Used in the suspend code. Your patch is indeed correct, but I fear 
> > > there might be a second bug caused by wrong calling conditions.
> > The problem in the Novell bugzilla entry was caused by the fact that the 
> > OHCI irq routine was invoked with interrupts enabled, owing to a missing 
> > IRQF_DISABLED flag.  That bug has already been fixed in 2.6.25.
> 
> That indeed is 2.6.25 kernel. I guess you are talking about commit 
> 442258e2ff69 here.

Yes.

> If so, the reporter is definitely using the kernel 
> containing this commit, and the lockups still trigger.
> 
> Seems that my patch is papering over the real bug (someone enabling 
> interrupts somewhere) indeed, but I can't seem to be able to find such 
> codepath.

You could try testing the interrupt-enable flag at various places 
in ohci-hcd (start with finish_urb) and printing an error message if 
interrupts are enabled.

One possibility is that in an earlier call to finish_urb,
usb_hcd_giveback_urb was called with interrupts disabled and returned 
with interrupts enabled.  In other words, some driver's callback 
routine may have enabled interrupts incorrectly.

Alan Stern

