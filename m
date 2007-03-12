Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbXCLWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbXCLWwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXCLWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:52:37 -0400
Received: from cpe-67-49-92-118.socal.res.rr.com ([67.49.92.118]:36816 "EHLO
	mail.blackbean.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXCLWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:52:36 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 18:52:35 EDT
Date: Mon, 12 Mar 2007 15:42:35 -0700
From: Jim Radford <radford@blackbean.org>
To: Greg KH <greg@kroah.com>
Cc: Mark Lord <lkml@rtr.ca>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression (Oops)  in 2.6.21-rc*
Message-ID: <20070312224235.GB3709@blackbean.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312203331.GA6769@kroah.com>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (mail.blackbean.org [127.0.0.1]); Mon, 12 Mar 2007 15:42:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 01:33:31PM -0700, Greg KH wrote:
> On Mon, Mar 12, 2007 at 04:22:22PM -0400, Mark Lord wrote:
> > Oliver Neukum wrote:
> > >>Mark Lord wrote:
> > >>>Okay, from that part (above), the problem is obvious:
> > >>>in that the "MCT U232 converter now disconnected" appears,
> > >>>and then we continue to try and call the driver's method.. Oops!

> > >IMHO shutdown() is using serial->port[] and bombs.
> > >Could you reverse the order here?

> > Yup.  Fixed.  Tested.  Works.

> > This patch fixes the Oops that otherwise occurs whenever
> > a USB serial adapter is unplugged from a system, as well
> > the Oops seen when one is in use before resume (to RAM).

> Argh, no, this change was done to help the ftdi drivers out.

> Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
> tree from Jim Radford:
> 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
> 
> It makes this change because the usb-serial drivers need the port
> devices when the port_remove() callbacks happen.  Otherwise you get an
> oops that way.

> Jim, can you take a look at this and see if you can figure something
> out?

The problem is really the

   serial->port[i] = NULL;

line after device_unregister() which is used to flag "fake" devices
that don't need legacy cleanup later in the destrol_serial.  That
flagging should be done using a *real* flag, and not by overloading
the ->port[i] pointer since we require it to be non-NULL in
->shutdown() in all drivers that are not converted to new
->port_probe()/->port_remove() framework (currently all except ftdi).

I'll work on a patch to do that, but for now, I think you should apply
Mark's patch to revert the order change since the FTDI driver no
longer requires the correct ordering of device_unregister() and
->shutdown().

-Jim
