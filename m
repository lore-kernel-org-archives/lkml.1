Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYLBPrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYLBPrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYLBPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:47:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbYLBPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:47:31 -0500
Date: Tue, 2 Dec 2008 07:46:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812020629.26714.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812020531.53175.elendil@planet.nl> <alpine.LFD.2.00.0812012037320.3256@nehalem.linux-foundation.org> <200812020629.26714.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Frans Pop wrote:
> 
> Attached is a full diff between dmesg from -rc3 and -rc6 with your debug 
> patch.
> 
> I've cleaned up the diff a bit to make it more readable (mostly removal of 
> changes that I always get due to random USB load order changes - UHCI 
> still frequently loads before EHCI).
> 
> The most interesting points are probably at lines 298-346 and 639-649.

So, it looks like you have MSI enabled in -rc6, and not in -rc3. And yes, 
for some reason -rc3 will create the prefetchable memory range windows, 
but -rc6 won't.

I have to admit that I'm not seeing _why_ to that latter one. I don't 
think we've done any resource allocation changes since -rc3 (the "clean up 
late e820 resource allocation" thing happened just _before_ -rc3), so I'm 
really not seeing why -rc3 would act differently from -rc6..

> At the bottom there's a fairly long addition from the few suspend/resume 
> cycles I did (again, running with the debug patch).

Sure. Quite frankly, from these messages, I'm not seeing anything really 
even remotely wrong. And apparently it does actually work for you.

It would perhaps be more interesting to see if there is some dmesg 
difference in a boot that then ends up _not_ able to resume from 
hibernation? But apparently that hasn't happened to you lately?

I don't like not knowing why you have prefetchable windows in one, and not 
in the other, but it is indeed a transparent bridge and so that difference 
really shouldn't even matter.

Do you perhaps dual-boot that laptop? What can sometimes happen is that 
PCI resources do not get totally reset over a warm-boot.

We've (very occasionally) had situations where PCI resource bugs only 
happen when you warm-boot from another OS (generally Windows), or when you 
warm-boot from an earlier version of Linux. Exactly because some firmware 
didn't fully re-initialize the state of the PCI bus, and because Linux 
will try to honor everything that the firmware set up..

		Linus
