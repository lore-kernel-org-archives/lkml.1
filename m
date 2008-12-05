Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYLERuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYLERuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYLERum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:50:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYLERul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:50:41 -0500
Message-ID: <493969B5.3050308@zytor.com>
Date: Fri, 05 Dec 2008 09:49:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       greg@kroah.com, jbarnes@virtuousgeek.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org, tiwai@suse.de, akpm@linux-foundation.org,
       ink@jurassic.park.msu.ru, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: MSI changes in .28
References: <200812020320.31876.rjw@sisk.pl> <200812020629.26714.elendil@planet.nl> <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org> <200812050953.12238.elendil@planet.nl> <20081205122005.GC28662@elte.hu>
In-Reply-To: <20081205122005.GC28662@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> The MSI IRQ number is a pure software detail that was already non-stable 
> due to device detection ordering, etc. It's counted back from NR_IRQS, 
> and the sizing of NR_IRQS changed (upwards) in 2.6.28 - that's what you 
> see.
> 
> The fact that MSI numbers goes back from NR_IRQs i consider a (minor) 
> misbehavior: it should not count down but should count up - and it should 
> not go to unreasonably high numbers if possible - that is confusing to 
> users when the sizing of NR_IRQS changes to to a higher NR_CPUS for 
> example.
> 
> A better (because more human-compatible) numbering scheme is to start 
> counting upwards from the high end of physical interrupt lines. We've 
> done that in the for-.29 sparseirq tree - there we'll start counting from 
> 256 upwards in essence. (the first 256 IRQs are GSI interrupts)
> 

Although it's kind of broken to limit the number of GSI interrupts to
256, at least for HyperTransport systems where you can have MSIs that
look like IOAPICs (although discovered using a slightly different
mechanism.)

This also means, at least in theory, that IOAPICs could be discovered at
runtime!

> Maybe it should be counted starting at 1000? That might be an even more 
> human-friendly numbering scheme.

Personally I think we should just fix the legacy PIC and southbridge
IOAPIC at zero, and let everything grow up from there.  We'll assign
IOAPIC numbers first just by virtue of them being discovered first, but
I don't really see a huge need to partition the space.

Assigning them numbers starting with 1000 does stand out, of course;
however, if we do that then we really need to make sure we don't run
into ugly surprises on HT systems.  On the other hand, perhaps none will
ever be built, since newer HT silicon is likely to use MSI-X rather than
MSI-HT just for compatiblity.

	-hpa

