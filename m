Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYLBXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYLBXic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYLBXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:38:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbYLBXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:38:22 -0500
Date: Tue, 2 Dec 2008 15:37:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812022338.51284.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812020513.42243.elendil@planet.nl> <alpine.LFD.2.00.0812012026520.3256@nehalem.linux-foundation.org> <200812022338.51284.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Rafael J. Wysocki wrote:
> 
> * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 with the
>   debug patch (appended for completness):
> 
>   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-patched-prep.log
> 
> * dmesg output including one hibernation-resume cycle from 2.6.28-rc7 without
>   the debug patch:
> 
>   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7-nopatch-prep.log

As with Frans, the debug patch seems to make no difference what-so-ever. 
Yes, the cardbus regions get allocated differently, but they're fine in 
either case, and arguably (exactly as with Frans) the debug patch actually 
makes things uglier by actively getting the alignment wrong, and skipping 
cardbus setup until later.

That's what your patch (without debugging) should have resulted in too, 
except you'd not have seen the "bad alignment flags" printout, of course 
(but you probably would have seen the "bad alignment 0: [...]" one).

In fact, I'm starting to think I know why we set up the prefetch window 
without the patch, and why we don't with it - because with the patch, the 
PCI code ends up never seeing any valid prefetchable region for the 
cardbus controller at all, so it never even bothers to try to set up a 
prefetchable window.

So in many ways, the debug patch that gets the alignment wrong (on 
purpose) is really the inferior one. Plain -rc7 seems to do everything 
right.

> * diff between the two:
> 
>   http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/dmesg-rc7_nopatch-rc7_patched.diff

Gaah. Using "-U 0" is likely the least readable form of diffs there 
exists, even if it makes the diff smaller.

> This part of the diff  (+ is the patched one) seems to be particularly
> interesting to me, especially the overlapping MEM windows for 0000:00:1e.0 and
> 0000:03:0b.0 (may that be the reason for the observed failures?):

No, those are very much on purpose. 

Device 0000:00:1e.0 is the PCI bridge that bridges to PCI bus#3, so the 
MEM window is very much intentional - exactly because MMIO goes through 
that PCI bridge bus to get to bus#3, which is where the cardbus controller 
is.

IOW, the topology is as follows: 
 - CPU is on the root bus (bus #0)
 - device 00:1e.0 is the PCI bridge to bus #3
 - device 03:0b.0 is the CardBus bridge (to bus #4)
and any actual cardbus cards (if you had any) would be on that bus #4, so 
they'd be named "04:xx.y".

Now, that PCI bridge 00:1e.0 is a transparent bridge (aka "[Subtractive 
decode]" in your lspci output - as compared to the other bridges that say 
"[Normal decode]"), which means that you don't actually _have_ to set up 
any MMIO window on them, since the bridge will forward _any_ PCI cycles 
that don't get responded to by any other PCI device.

But having an explicit window is still generally a good idea, since it 
should allow the PCI bridge to pick up the PCI cycles earlier (no need to 
wait to see if others respond to it), and possibly allows for better 
prefetching behavior. So again, the dmesg and the PCI layout actually 
looks _better_ without the hacky patch.

So are you saying that the unpatched kernel still reliably doesn't 
hibernate for you, while the (arguably _incorrect_) patched kernel 
reliably does hibernate? 

			Linus
