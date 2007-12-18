Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXLRVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXLRVLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXLRVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:11:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbXLRVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:11:45 -0500
Date: Tue, 18 Dec 2007 13:09:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071218202234.GA24525@twiddle.net>
Message-ID: <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Richard Henderson wrote:
> 
> I've added dmesg, /proc/iomem, and lspci -v output to that bug.
> 
> Basically, we have
> 
> 	c0000000-cfffffff : free
> 	ddf00000-dfefffff : PCI Bus #04
> 	e0000000-efffffff : pnp 00:0b
> 	f0000000-fedfffff : less than 256MB

Gaah. 

That really is very unlucky. That 256M only goes at one point in the low 
4GB, but the thing is, it fits perfectly well above it, and dammit, that 
resource is explicitly a 64-bit resource or a really good reason. 

However, I wonder about that

	e0000000-efffffff : pnp 00:0b

thing. I actually suspect that that whole allocation is literally *meant* 
for that 256MB graphics aperture, but the kernel explicitly avoids it 
because it's listed in the PnP tables.

I wonder what the heck is the point of that pnp entry. Just for fun, can 
you try to just disable CONFIG_PNP, and see if it all works then?

Björn Helgaas added to Cc to clarify what those pnp entries tend to mean, 
and whether there is possibly some way to match up a specific pnp entry 
with the PCI device that might want to use it. Because that is a nice 
256MB region that really doesn't seem to make sense for anything else than 
the graphics buffer - there's nothing else in your system that seems 
likely (although I guess it could be for some docking port, but even then 
I'd have expected one of the PCI bridges to map it!)

But apart from the question about that pnp 00:0b device, the kernel 
resource allocation really does look perfectly fine, and while we could 
shoe-horn it into the low 4GB in this case by just hoping that there is 
nothing undocumented there (and there probably isn't), it's really 
annoying considering that big graphics areas are a hell of a good reason 
to use those 64-bit resources.

It's not like 256MB is even as large as they come, half-gig graphics cards 
are getting to be fairly common at the high end, and X absolutely _has_ to 
be able to handle a 64-bit address for those. 

Also, I'm surprised it doesn't work with X already: the ChangeLog for X 
says that there are "Minor fixes to the handling of 64-bit PCI BARs [..]" 
in 4.6.99.18, so I'd have assumed that XFree86-4.7.0 should be able to 
handle this perfectly well.

I'll add Keithp to the cc too, to see if the X issues can be clarified. 
Maybe he can set us right. But maybe you just have an old X server? If so, 
considering the situation, I really think the kernel has done a good job 
already, and I'd be *very* nervous about making the kernel allocate new 
PCI resources right after the end-of-memory thing.

I bet it would work in this case, but as mentioned, we definitely know of 
cases where the BIOS did *not* document the magic memory region that was 
stolen for UMA graphics, and trying to put PCI devices just after the top 
of reserved memory in the e820 list causes machines to not work at all 
because the address decoding will clash.

Of course, we could also make the minimum address more of a *hint*, and 
only make the resource allocator only abut the top-of-known-memory when it 
absolutely has to, but on the other hand, in this case it really doesn't 
have to, since there's just _tons_ of space for 64-bit resources. So the 
correct thing really does seem to be to just use the 64-bit hw that is 
there.

> That would have been an excellent comment to add to that code then,
> rather than just "rounding up to the next 1MB area", because purely
> as rounding code it is erroneous.

Patches to add comments are welcome. There are few enough people who 
actually work on the PCI resource allocation code these days (I wish there 
were more), and it's very rare that anybody else than me or Ivan ends up 
even *looking* at it. So it's not been a big issue.

				Linus
