Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYKAXTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYKAXTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 19:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKAXTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 19:19:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYKAXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 19:19:22 -0400
Date: Sat, 1 Nov 2008 16:18:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <20081101164509.5e53762c@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0811011609050.3483@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
 <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net> <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org> <20081101090154.3d014f57@bike.lwn.net>
 <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org> <86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com> <20081101164509.5e53762c@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Nov 2008, Jonathan Corbet wrote:
>
> Looks to me like Linus's patch is the way to go, at least for now...

I'll make an -rc3 tomorrow. However, I suspect that if we have lots more 
regressions, we'll just have to revert the resource handling back to the
2.6.27 state.

The problem with resource handling is that even when we can write code 
that "makes sense", in the end firmware can always do odd things. For 
example, in your case it really does make sense to keep the already 
allocated PCI resources in the reserved region, because the firmware 
obviously did both the reserved region _and_ the PCI BAR allocation.

At the same time, I'm worried that what Windows does is something totally 
different, probably odd, and possibly even dependent on some HAL layer 
motherboard driver or other.  And it's really the case that every single 
time we change resource allocation - never mind how subtly, or how much 
sense it makes - it will break some odd setup somewhere.

And I would not be surprised if we end up finding some machine that really 
had totally _broken_ PCI BAR setup, where it set up some PCI decode to 
overlap with a reserved region and then depended on the OS re-allocating 
the resource. 

As usual, the right answer doesn't necessarily end up being the one that 
makes most sense, but probably the one that matches what Windows ends up 
doing most closely - just because that's the one that was tested against. 
And windows behaviour can in turn easily depend on some internal Windows 
implementation detail, rather than any "thought out" solution.

The good news here is that the particular behavior wrt e820 reserved 
resources and various PCI BAR's should be totally irrelevant for 99.9% of 
all hardware, and we _only_ have to worry about the really odd cases. But 
even just a couple of odd BIOS versions are enough to cause a lot of pain.

So let's see how it turns out in -rc3. It works for _you_, and it looks 
sane to me, but ...

			Linus
