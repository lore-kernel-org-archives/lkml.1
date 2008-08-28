Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYH1UG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYH1UG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYH1UGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:06:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175AbYH1UGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:06:01 -0400
Date: Thu, 28 Aug 2008 13:05:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late
In-Reply-To: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org>
References: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Yinghai Lu wrote:
>
> so could let BAR res register at first, or even pnp?

Well, I'm not sure whether PnP or e820 should be first, as long as any 
"real hardware" probing takes precedence over either. I _suspect_ that 
e820 is more trustworthy, which implies that PnP should probably be added 
last. It would be good to have some idea what Windows does, since usually 
all the firmware bugs are essentially hidden by whatever that other OS 
happens to do.

The basic rule really should be: "What do we trust most?" and probe things 
in that order. 

So e820 is fairly trustworthy, but we know that it will have various 
random things marked as reserved because they are special in some way (but 
we don't know _how_ they are special - they may well be real BAR's that 
just have a fixed meaning to ACPI or whatever).

But we obviously trust _part_ of it (the RAM stuff) more than we trust 
other parts. So it does make sense to consider that separately.

PnP I personally wouldn't trust at all, except as a way to keep dynamic 
resources away from those things, which is why I'd put it last. But that's 
just my personal gut feeling.

Hardware we generally trust more than any firmware, but even hardware can 
have bugs. And some classes of hardware tends to be less buggy than others 
(ie I'd trust some on-die APIC base pointer before I would trust a Cardbus 
controller BAR, for example).

But yes, I think your patch looks like it is definitely moving in the 
right direction. If this means that we can now do PCI probing without 
having the BAR's move around because they also happened to be covered by 
an e820 map, then that sounds like a good thing.

Of course, I bet there will be cases where this causes problems. It feels 
like we have _never_ worked around some PCI BAR allocation problem without 
hitting another unexpected one..

		Linus
