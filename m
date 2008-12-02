Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYLBSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYLBSSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYLBSSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:18:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbYLBSSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:18:22 -0500
Date: Tue, 2 Dec 2008 10:17:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812021846.51479.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812020956440.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812020629.26714.elendil@planet.nl> <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org> <200812021846.51479.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Frans Pop wrote:
> 
> I could reinstall some intermediate versions and check when that change 
> got introduced if that would help, or revert to the kernel I was using 
> before I did the pull today and applied the debug patch (which was plain 
> rc6 + a few selected bug fix patches that had not yet been merged).

It might be interesting, but probably not very relevant. I don't really 
think that the resume problem is related to this.

> It did happen once a few days ago, but with the workarounds I had resume 
> failures were extremely rare. I'll see if I can work out which boot it 
> was, but that could well be very tricky as a failed resume leaves no 
> trace.

If you just save the dmesg before each resume try, you'd have at least the 
dmesg of the bootup that leads to failure. It's _likely_ exactly the same 
as the ones that don't lead to failures, but..

> The way I "see" the failure is that the wireless led does not come on

Quite frankly, from everything I hear, I personally strongly suspect that 
it's something timing-related to some driver, and most likely totally 
unrelated to any PCI resource allocation in any other way. IOW, _if_ the 
resource allocation makes a difference, it's more likely through just 
mattering from a timing standpoint.

For example, the bad alignment you get from picking the alignment from the 
wrong place (with Rafael's patch or with my debugging patch) results in 
this:

 - PCI init time:

	+pci 0000:02:06.0: BAR 9 0-3ffffff wrong alignment flags 21200 4000000 (0)
	+pci 0000:02:06.0: BAR 9 bad alignment 0: [0x000000-0x3ffffff]

 - CardBus init time:

	+yenta_cardbus 0000:02:06.0: CardBus bridge, secondary bus 0000:03
	+yenta_cardbus 0000:02:06.0:   IO window: 0x003000-0x0030ff
	+yenta_cardbus 0000:02:06.0:   IO window: 0x003400-0x0034ff
	+yenta_cardbus 0000:02:06.0:   PREFETCH window: 0x84400000-0x847fffff
	+yenta_cardbus 0000:02:06.0:   MEM window: 0x80000000-0x83ffffff

ie what happened is that when using the wrong alignment, the PCI bus setup 
code would fail to set up the memory windows (bar 9), but then the cardbus 
init which happens later will fix that, since it re-does the setup (see 
"yenta_allocate_resources()": it will re-do "pci_setup_cardbus()" if the 
resources didn't get set up earlier)

End result? There should be no real difference, but timing does change.

Now, there are _some_ subtle issues that change depending on whether we do 
the "failure case" in yenta_allocate_resources() or not: for example, the 
code in yenta_allocate_res() actually knows about the fact that CardBus 
memory resources have a 4kB granularity, while the generic PCI code uses 
the resource size as the alignment.

The yenta code also tries to potentially find a smaller resource than the 
generic PCI resource code did (the generic PCI code just tries to use 
2*pci_cardbus_io_size and 2*pci_cardbus_mem_size for sizing, while the 
Yenta code tries to aim for BRIDGE_IO/MEM_MAX but knows to try to make 
them smaller if it cannot fit.

So the resources can end up being laid out at different points as a 
result, and again, that can lead to totally independent bugs showing up 
(overlap with random unknown motherboard resources set up by firmware). 
But more relevantly, it can simply just cause some timing differences.

Anyway, I'm not at all sure that you and Rafael even necessarily see 
exactly the same thing. It doesn't look like my debug patch (which tries 
to emulate Rafael's patch in behavior, in addition to adding the debug 
printouts) really even matters for you. Because you seemed to be 
hibernating ok even without that "break alignment in PCI layer" thing.

			Linus
