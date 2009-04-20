Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZDTXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZDTXXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZDTXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:23:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:14308 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDTXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:23:28 -0400
X-IronPort-AV: E=Sophos;i="4.40,219,1238976000"; 
   d="scan'208";a="289717486"
Date: Mon, 20 Apr 2009 16:23:27 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-ID: <20090420232327.GA25424@cuplxvomd02.corp.sa.net>
References: <20090420143010.697c7380.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org> <20090420151400.11afd62a.akpm@linux-foundation.org> <20090420223500.GB11068@cuplxvomd02.corp.sa.net> <20090420155033.a89ad4a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420155033.a89ad4a0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:50:33PM -0700, Andrew Morton wrote:
> On Mon, 20 Apr 2009 15:35:00 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
> 
> > On Mon, Apr 20, 2009 at 03:14:00PM -0700, Andrew Morton wrote:
> > > On Mon, 20 Apr 2009 17:51:16 -0400 (EDT)
> > > Alan Stern <stern@rowland.harvard.edu> wrote:
> > ...
> > > > What if a subsystem simply doesn't know in advance whether or not it's 
> > > > going to register a console?  Or doesn't know when it has finished 
> > > > probing all devices (since a new device could be plugged in at any 
> > > > time)?
> > > 
> > > Fix it.  It's trivial to make a sub-driver call back into a higher
> > > layer to tell it that it registered a console.  Or just do the
> > > i_will_be_adding_a_console_soon()/oops_im_not_adding_a_console_after_all()
> > > calls from the layer which _does_ know.
> > 
> > In the case of the console, we already have register_console(), which is
> > what I'm using. I think your proposal will require adding code all over
> > the place. And buses such as USB simply have no way of knowing whether they
> > are done enumerating devices. A new device could take hours to come on line.
> 
> Add a timeout parameter to i_will_be_adding_a_console_soon().  (This
> means that the how-long-to-wait-for policy is probably ahrd-coded into
> the kernel which might be a problem).

Yes, it breaks one problem into a host of smaller problems.
> 
> > > Yes, a boot parameter is "simple" to inplement.  But it's ghastly from
> > > a usability POV.  Especially if you care about boot times.  For how
> > > long do you delay?  The user has to experiment with different delays
> > > until he finds the magic number.  Then he adds 10% and waits for the
> > > inevitable failure reports to come in.
> > > 
> > > It's much better to just get it right, even if that makes it more
> > > "complex".
> > 
> > With USB, you just can't *ever* get it right. There is no limit on how
> > long a device has to tell you its there. I wish this weren't the case,
> > but our good friends in the USB world tell us that we have been lucky
> > to have had USB consoles work as long as they have.
> 
> Sigh, OK, I appreciate the problem better.  But the proposed "solution"
> is really quite fragile.  I expect that it will only prove usable in
> highly controlled hardware setups.
> 
> Is my option a) any use?

I thought about option a). The problem is, given that it might take a very
long time for the console device to appear, you either have to buffer an
arbitrarily large amount of output or simply drop data on the floor. Dropping
log buffer output from printk is one issue, but what's more scary is that
you'll eventually lose data from innocent programs that you start running
from init.

I just don't see any great solutions here; what I've offered is one pragmatic
approach to coming to grips with the Great Unknowns of USB. As Greg KH says,
we're lucky it worked at all. My USB console broke a few months ago and my
primary focus has been to get things back to where, if we are as lucky as
we used to be, things will be no broken than they were. Hey, I'm an engineer,
not a miracle worker!
--
David VomLehn
