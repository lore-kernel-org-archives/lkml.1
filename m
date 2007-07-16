Return-Path: <linux-kernel-owner+w=401wt.eu-S1764549AbXGPVl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764549AbXGPVl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXGPVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:41:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbXGPVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:41:46 -0400
Date: Mon, 16 Jul 2007 14:40:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
In-Reply-To: <20070716.042640.18306462.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
References: <20070716091236.GA10718@elte.hu>
 <20070716.042640.18306462.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, David Miller wrote:
> 
> Well, let's figure out why before we revert because it
> is attempting to fix a legitimate bug.

I'm reverting it. I don't think there is any excuse for not reverting 
something that provably breaks somebody's machine. I don't want this to be 
on the regression list - if you figure out why it broke, you can always 
just resubmit a fixed patch.

Keeping a known broken patch around just because you want to figure out 
why it's broken seems pointless.

Just looking at the patch I see two options:

 - The change seems to always set the LIST_FROZEN bit when calling 
   ->poll(), and at least on e1000, the NAPI poll() routine ends up doing 
   that netif_rx_complete(), so we're *guaranteed* to always take the 
   early exit and not do anything.

   Looks fundamentally broken to me, and not worth saving. But maybe I'm 
   missing something (and it doesn't really seem to explain the write 
   timeout per se).

 - The early return from netif_rx_complete() ends up meaning that an 
   edge-triggered interrupt isn't handled properly, and will this never 
   happen again, since it never goes away.

   With MSI, edge-triggered interrupts are making a comeback in a big way, 
   and yeah, e1000 is one of the drivers that do MSI. Ingo might want to 
   confirm whether it's actually enabled for him, and whether turning it 
   off might hide the problem, but if that's it, then the whole patch is 
   fundamentally broken, and not worth saving.

but in either case (or, indeed, even if I didn't see any problem at all), 
I think reverting a patch that isn't needed is _always_ the right choice. 

If we don't know what caused a problem in the first place, or if the fix 
is known to be required for something else and reverting it would cause 
*another* regression, it would be another issue. But as it is, reverting 
it would seem to unquestionably get rid of a regression, and is thus a 
no-brainer.

No?

		Linus
