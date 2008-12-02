Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYLBEhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYLBEhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLBEh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:37:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbYLBEh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:37:26 -0500
Date: Mon, 1 Dec 2008 20:36:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812020513.42243.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812012026520.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org> <200812020513.42243.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Frans Pop wrote:
> 
> Your debug patch gives me on boot (hp 2510p; x86_64; current git head):
> 
> ! pci 0000:02:06.0: BAR 9 0-3ffffff wrong alignment flags 21200 4000000 (0)
> ! pci 0000:02:06.0: BAR 9 bad alignment 0: [0x000000-0x3ffffff]

Hmm. flags 21200 means that IORESOURCE_SIZEALIGN is set, and 'align' is 
_correct_ (0x4000000==size), while 'expected_align' is total crap (0).

So at least on your machine, using the expected_align value (which is 
effectively what Rafael's patch does) would definitely be the wrong thing.

Of course, it might then happen to work (because the thing doesn't 
actually need that big alignment at all).

Also:

> From lspci -vv:
> 02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
>         Subsystem: Hewlett-Packard Company Device 30c9
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 168
>         Interrupt: pin A routed to IRQ 18
>         Region 0: Memory at e0100000 (32-bit, non-prefetchable) [size=4K]
>         Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
>         Memory window 0: 84400000-847ff000 (prefetchable)
>         Memory window 1: 80000000-83fff000
>         I/O window 0: 00003000-000030ff
>         I/O window 1: 00003400-000034ff

the above all looks fine, and it apparently works for you.

I'd like to see what Rafael's machine does.

Of course, the thing to keep in mind here is that resource alignment is 
one of those things that changes how PCI resources get laid out, and two 
different layouts may well _both_ be correct - but then one of them may 
not work, because there is some hidden SMI resource that we don't know 
about, or some other stupid BIOS issue where the BIOS is unhappy about how 
we laid things out.

We've had many of those before. And they can easily result in "innocent" 
changes (including real fixes) just then exposing problems that were 
hidden before due to just a subtly different layout.

That's why I'd like to see what the layout differences are for Rafael with 
and without his patch (and also both before and after hibernate/resume). 
Maybe both layouts are "correct", but the non-working one can give us a 
clue about what may be triggering the problem.

			Linus
