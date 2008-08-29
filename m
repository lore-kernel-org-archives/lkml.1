Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYH2Oyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYH2Oyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYH2Oy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:54:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYH2Oy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:54:28 -0400
Date: Fri, 29 Aug 2008 07:54:07 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829145407.GB18423@kroah.com>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com> <20080829144354.GD1968@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829144354.GD1968@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 08:43:54AM -0600, Matthew Wilcox wrote:
> On Fri, Aug 29, 2008 at 07:30:17AM -0700, Greg KH wrote:
> > On Fri, Aug 29, 2008 at 08:02:24AM -0600, Matthew Wilcox wrote:
> > > 
> > > I'm in the middle of implementing a userspace client for usbip and I
> > > strongly feel that the protocol needs to be changed before it is merged.
> > > 
> > >  - I'm unconvinced that TCP is the correct protocol to be running this over.
> > >    I understand the reluctance to use UDP, but the protocol is fundamentally
> > >    packet-based.  If TCP is used, the delimitation of packets within the
> > >    stream needs to be much more robust.  I've managed to wedge the VHCI driver
> > >    a number of times in ways that just wouldn't be possible if we were using
> > >    a packet protocol instead of a stream protocol.
> > 
> > USB is fundamentally packet-based, so it kind of fits very well.
> 
> Erm, did you not read what I wrote?  USB is packet based.  TCP isn't.
> We shouldn't be using TCP here.

Sorry, early morning, no coffee yet...

I think in the end, we should still use TCP otherwise you just end up
reinventing it with UDP :)

> > >  - Endianness.  This is a mess.  The usbip protocol is big-endian, but the
> > >    encapsulated usb protocol is little-endian.  This doesn't matter to the
> > >    people who are just tunnelling usb from one computer to another, but for
> > >    someone implementing a usbip client, it's very confusing.
> > 
> > Then just document it, no big deal.
> > Yeah, the current code isn't the cleanest here (sparse throws up some
> > warnings), but it's not that much work to fix it up, it's on my todo
> > list.
> 
> I'm not talking about the code.  I'm talking about the protocol.  It's a
> mess to have two different endiannesses within the same packet.

Ok, switch it all to be little endian, not a bit deal.

> > >  - There are actually two completely different protocols in use.  First,
> > >    the usbipd daemon listens on port 3240, and handles device discovery.
> > >    When usbip successfully attaches to usbipd, both sides of the connection
> > >    pass the socket fd into the kernel and the protocol changes.
> > >  - The protocol sends a 48-byte packet header for every command (and every
> > >    response).  It's cunningly hidden as a union.
> > 
> > Is that a real problem?
> 
> Yes, it really is.  It complicates the protocol, complicates the
> implementation, introduces unnecessary state, and makes it impossible to
> renegotiate on the same connection.

Fair enough, patches welcome :)

> > Windows has had this for years, no need for a RFC there, and if we just
> > document this well, no need for one here either.
> 
> Yes, and as a result we can't interoperate with Windows.

That is because (see below)

> By the way, is this actually built into Windows or just available as
> several mutually incompatible and pay-for products?  I did some
> searching a few months ago and didn't come up with anything official
> from Microsoft.

There is nothing official, there are various incompatible and pay-for
products in this area.

> Even if we don't go through the RFC process, just writing down the
> on-wire protocol should be mandatory for taking this kind of thing into
> the kernel.

Why, isn't the actual implementation better than a document?  :)

thanks,

greg k-h
