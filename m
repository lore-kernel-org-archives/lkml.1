Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYH2OoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYH2OoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYH2OoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:44:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54633 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYH2OoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:44:10 -0400
Date: Fri, 29 Aug 2008 08:43:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829144354.GD1968@parisc-linux.org>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829143017.GB18086@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 07:30:17AM -0700, Greg KH wrote:
> On Fri, Aug 29, 2008 at 08:02:24AM -0600, Matthew Wilcox wrote:
> > 
> > I'm in the middle of implementing a userspace client for usbip and I
> > strongly feel that the protocol needs to be changed before it is merged.
> > 
> >  - I'm unconvinced that TCP is the correct protocol to be running this over.
> >    I understand the reluctance to use UDP, but the protocol is fundamentally
> >    packet-based.  If TCP is used, the delimitation of packets within the
> >    stream needs to be much more robust.  I've managed to wedge the VHCI driver
> >    a number of times in ways that just wouldn't be possible if we were using
> >    a packet protocol instead of a stream protocol.
> 
> USB is fundamentally packet-based, so it kind of fits very well.

Erm, did you not read what I wrote?  USB is packet based.  TCP isn't.
We shouldn't be using TCP here.

> >  - Endianness.  This is a mess.  The usbip protocol is big-endian, but the
> >    encapsulated usb protocol is little-endian.  This doesn't matter to the
> >    people who are just tunnelling usb from one computer to another, but for
> >    someone implementing a usbip client, it's very confusing.
> 
> Then just document it, no big deal.
> Yeah, the current code isn't the cleanest here (sparse throws up some
> warnings), but it's not that much work to fix it up, it's on my todo
> list.

I'm not talking about the code.  I'm talking about the protocol.  It's a
mess to have two different endiannesses within the same packet.

> >  - There are actually two completely different protocols in use.  First,
> >    the usbipd daemon listens on port 3240, and handles device discovery.
> >    When usbip successfully attaches to usbipd, both sides of the connection
> >    pass the socket fd into the kernel and the protocol changes.
> >  - The protocol sends a 48-byte packet header for every command (and every
> >    response).  It's cunningly hidden as a union.
> 
> Is that a real problem?

Yes, it really is.  It complicates the protocol, complicates the
implementation, introduces unnecessary state, and makes it impossible to
renegotiate on the same connection.

> > I think the protocol would be immeasurably improved by going through the
> > IETF RFC process and getting feedback from networking experts.  Failing
> > that, I have some suggestions about how to improve it.  I was hoping to
> > get my client finished before I started mucking with the protocol though.
> 
> Why mess with the RFC process, is that really necessary for something
> like this?

It helps clarify the odd corners of any protocol.  I don't have the
impression that it's a terribly heavy-weight process -- though we can
ask the netlink guys how it went for them.

> Windows has had this for years, no need for a RFC there, and if we just
> document this well, no need for one here either.

Yes, and as a result we can't interoperate with Windows.

By the way, is this actually built into Windows or just available as
several mutually incompatible and pay-for products?  I did some
searching a few months ago and didn't come up with anything official
from Microsoft.

Even if we don't go through the RFC process, just writing down the
on-wire protocol should be mandatory for taking this kind of thing into
the kernel.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
