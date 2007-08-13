Return-Path: <linux-kernel-owner+w=401wt.eu-S940434AbXHMVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940434AbXHMVdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939745AbXHMVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:32:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:54044 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935108AbXHMVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=jx12DGpvcG5iyXrZgB8PaU/XZn0+uceqN0U1IXCLd4FxO1c6aq7MaEjYIn3+Qx6pEA+QBimkHhSJE/3s6jdeinJRYlNkjzuwGDU300r+BRa2DTcRxbcgISWeW/Ac16UKRQQMNr0E3VvbcyMQZ+SA1vmFS6ABrknzWBaLQu6DZW4=
Date: Mon, 13 Aug 2007 18:32:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Brad Campbell <brad@wasp.net.au>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Advice on a userspace tty serial driver
Message-ID: <20070813213200.GG20665@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Brad Campbell <brad@wasp.net.au>,
	lkml <linux-kernel@vger.kernel.org>
References: <46BC59E3.2010402@wasp.net.au> <20070813205523.GA9412@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813205523.GA9412@csclub.uwaterloo.ca>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 13, 2007 at 04:55:23PM -0400, Lennart Sorensen escreveu:
> On Fri, Aug 10, 2007 at 04:28:19PM +0400, Brad Campbell wrote:
> > I'm building a bit of hardware. It's basically a serial multiplexer that 
> > communicates to the PC using a single usb-serial port. It has the ability 
> > to run between 2 and 8 standard async ports over this single interface.
> > 
> > I'd rather not write a kernel driverif possible as I figure this would be a 
> > perfect application for a userspace daemon to do the control and mux/demux. 
> > I'd prefer to present standard serial style devices (/dev/ttySxx) to 
> > userspace giving me the ability to run unmodified software to talk to the 
> > multiplexed ports.
> > 
> > I think tty/pty pairs looks roughly what I'm after, but will they allow me 
> > to use standard IOCTLS for conveying baud rate and other standard serial 
> > parameters to the daemon?
> > 
> > I've spotted several userspace serial driver projects in the last 7 or so 
> > years, but I can't seem to find any that made it into the kernel.
> > 
> > Am I on the right track with tty/pty or is there a better way?
> 
> I don't think you can do any serial specific stuff, like parity and stop
> bits and the like across a pty.  You might have to actually write a

Well, the mux could check this next time select/poll indicates there is
something to read from the pty and use the GSM0710 modem bits setting
packet type to communicate that to the hardware that has the async
ports.

This is just handwaving tho, haven't checked if TCSETS works well on a
pty and if afterwards a TCGETS will retrieve the changed values. Check
if that is the case and try to find a way to avoid doing a TCGETS for
every read from the pty, perhaps with a flag that starts at zero and at
first read you set it to one, then after you detect that the pty was
closed you set it back to zero.

> serial driver to present the devices and handle the ioctls, even if you
> have a user space process handle the mux/demux between the real serial
> port and the fake ports.
> 
> I am curious how you are going to pass the data to the external device,
> and indicate which port the data should go through.  What will you do

Look at GSM 07/10. I implemented a userland multiplexer for a customer,
that decided to keep it closed, but I think that Harald Welte has
written an open source implementation in the open moko project, haven't
checked this tho.

No need to implement it all on the hardware with the async ports side,
just the type 0 (if my memory serves me 8) will be enough for what you
want.

> when there is too much data being sent for the real serial port to
> handle?  I guess if you had a single high speed port, that would be a
> start.

Well, just use a select look on the pty and the real serial device and
mux/demux using GSM0710, apps will be throttled by the pty code, etc.

- Arnaldo
