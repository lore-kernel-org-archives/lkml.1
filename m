Return-Path: <linux-kernel-owner+w=401wt.eu-S934574AbYEUON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbYEUON4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYEUONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:13:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753836AbYEUONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:13:47 -0400
Date: Wed, 21 May 2008 10:13:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <lchiquitto@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <200805211547.46399.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Oliver Neukum wrote:

> Am Mittwoch 21 Mai 2008 15:36:49 schrieb Jiri Kosina:
> > On Wed, 21 May 2008, Oliver Neukum wrote:
> > 
> > > This turns out not to be the case. Interrupts are disabled.
> > 
> > You're right, this callchain can't cause the deadlock indeed. I'll go 
> > through the other possibilities.

The functions you are worried about (usb_hcd_link_urb_to_ep and 
usb_hcd_unlink_urb_from_ep) are documented as requiring that interrupts 
be disabled by their callers.  This patch isn't needed.

(Of course, other patches may be needed to insure that the callers do 
indeed disable interrupts.  But I'm not aware of any such need.)

> usb_hcd_flush_endpoint() is an obvious case.

It's not obvious to me.  Where does usb_hcd_flush_endpoint() acquire 
hcd_urb_list_lock with interrupts enabled?

> Used in the suspend code.
> Your patch is indeed correct, but I fear there might be a second bug caused
> by wrong calling conditions.

The problem in the Novell bugzilla entry was caused by the fact that 
the OHCI irq routine was invoked with interrupts enabled, owing to a 
missing IRQF_DISABLED flag.  That bug has already been fixed in 2.6.25.

Alan Stern

