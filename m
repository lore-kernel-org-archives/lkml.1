Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYH3C2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYH3C2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYH3C2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:28:00 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:39469 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbYH3C17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:27:59 -0400
Date: Fri, 29 Aug 2008 21:27:49 -0500
From: David Fries <david@fries.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, netdev@vger.kerne.org
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
Message-ID: <20080830022749.GF17528@spacedout.fries.net>
References: <20080828041110.GA9404@spacedout.fries.net> <20080830.002215.128620618.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830.002215.128620618.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 29 Aug 2008 21:27:52 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:22:15AM +0900, Atsushi Nemoto wrote:
> On Wed, 27 Aug 2008 23:11:15 -0500, David Fries <david@fries.net> wrote:
> > do_ne_probe uses dev->mem_end special value 0xbad as a flag to deal
> > specially when some bad, but usable devices.  The io port platform
> > resource has a start and end, but if start is 0x300 and end is 0xbad,
> > it will just fail with io ports in use and not probe the device.  Is
> > using the flag IORESOURCE_DISABLED acceptable?  There doesn't seem to
> > be any good way to pass some extra driver dependent data through to
> > the platform probe function.
> > 
> > +	/* Bad, crippled, how about disabled?
> > +	 * Any other suggestions for passing this through?
> > +	 */
> > +	if (dev->mem_end == BAD)
> > +		r[0].flags |= IORESOURCE_DISABLED;
> 
> I'm not sure IORESOURCE_DISABLED is OK, but (ab)using r[0].name might
> be safer. Something like this:
> 
> 	if (dev->mem_end == BAD)
> 		r[0].name = "bad";

Works for me, thanks for the suggestion, it was just what I was
looking for.

> With your patch, cleanup_module() and ne_exit() is exactly same.  How
> about unifying them?

They didn't use to be the same, with all the cleanup I didn't notice
that they became the same.  ne_exit is no more, cleanup_module for
both module and built in.

> >     mdelay(10) replaced by msleep(10) to give up the CPU.
> 
> I think this part is worth to do by separate patch.

Now that you mention it, it really doesn't have anything to do with
the rest of the changes.  I suppose.  

> > +	struct resource r[2] = {
> > +		{
> > +			.name = "io_port",
> > +			.flags = IORESOURCE_IO},
> > +		{
> > +			.name = "irq",
> > +			.flags = IORESOURCE_IRQ} };
> 
> This .name initialization seems a bit redundant for me.  They can be
> left NULL.

Changed.

Thanks for the feedback, I'll submit round two shortly.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
