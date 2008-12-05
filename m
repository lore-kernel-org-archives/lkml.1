Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYLEADn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYLEADn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYLEADd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:03:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYLEADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:03:32 -0500
Date: Thu, 4 Dec 2008 16:03:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812050031.27287.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812042309.11540.rjw@sisk.pl> <alpine.LFD.2.00.0812041415020.3543@nehalem.linux-foundation.org> <200812050031.27287.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Not very interesting. It just does the same thing your previous patches 
> > have done - ignores the cardbus slot for sizing. It just does it 
> > differently and more explicitly.
> 
> There's a difference, though.  It doesn't cause the resources flags to be
> cleared for the cardbus bridge and the cardbus bridge gets the correct sizes
> of both prefetchable and non-prefetchable windows (64 MB).

Yes, true. In that sense, it minimizes the differences between the 
"working" and "nonworking" case. 

Which is interesting in the sense that it makes it even less likely that 
it's an actual resource clash. 

> I know that. :-)  Still, I find it important to notice that the memory windows
> of the cardbus bridge can be 64 MB-wide and things work in that case too.
> Also, I like it more than the previous patch. ;-)
> 
> Moreover, I _think_ it would work for Frans too, because I _suspect_ the
> problem is related to a cardbus bridge being located behind that "transparent"
> thing somehow.

Well, I suspect that on Frans' machine, there will be no difference at all 
between your patch and my previous patch, since he already had a bridge 
window allocated by the BIOS. And he also had just that firewire and mmc 
thing that only needed that memory window, so he'd end up with the exact 
same resource allocation, methinks.

> > Can you send "lspci -vv" and "dmesg" output for that kernel?
> 
> No prob, both attached along with the contents of /proc/iomem .

It all looks very sane. Too bad it apparently doesn't work.

> > Even if it failed the suspend/resume, it's interesting, because I would
> > actually have expected that one to have the same layout as the successful
> > ones. 
> 
> Well, not exactly.  Actually, with this patch the graphics and "ICH HD audio"
> get their memory ranges before the ranges of _all_ devices behind the
> transparent bridge, while in the "working" case their memory ranges are located
> _after_ the memory ranges of devices behind the transparent bridge _except_
> for the cardbus bridge's memory windows.

Yes, however, it shouldn't matter.

Except in cae the audio driver (for example) were to access past its MMIO 
window, and we'd have a situation where we care what was just before it or 
after it. That doesn't seem very likely, though.

		Linus
