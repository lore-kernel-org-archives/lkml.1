Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZFDRql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZFDRql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZFDRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:46:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZFDRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:46:32 -0400
Date: Thu, 4 Jun 2009 10:46:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Michael S. Zick" <lkml@morethan.org>
cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
In-Reply-To: <200906041227.10529.lkml@morethan.org>
Message-ID: <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Michael S. Zick wrote:
>
> Yes, I build test cases with and without - -
> It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> I just reposted that build today (the -09143lk).
> 
> > Features like that easily put a huge stress on power regulators etc, if 
> > they result in sudden changes in current draw.  Underspecced capacitors 
> > etc can cause CPU "brown-outs", which in turn can easily cause total 
> > failure. 
> 
> There is also a possible thermal issue with these machines - -
> I doubt that VIA runs their qualification testing in bake ovens;
> which is what NetBook cases amount too.  ;)

If the fixed-speed case runs for longer, it's not likely to be a thermal 
issue. The fixed speed case should be the higher-power one.

So it can easily be a weak power setup (insufficient grounding, bad 
capacitors etc). But it could also be external bus issues, in case VIA 
power management also impact the external bus (eg "stopclock" like 
behavior on the CPU<->chipset bus).

One thing you could try is to avoid using the "halt" instruction. It will 
obviously increase power use (and thus higher temperatures), but again, 
current fluctuations are much more likely to cause problems than higher, 
but fairly constant, power draw.

Think about all the light-bulbs you've seen that burn out just when you 
turn them on. 

Use "idle=poll" on the kernel command line to avoid the idle loop using 
the "halt" or "mwait" instructions to save power.

(That polling idle loop can also end up hiding cache coherency issues with 
DMA, so if that works better, it doesn't necessarily prove it's 
power-related. Shutting down the CPU core can have interesting 
implications for external events, and you can have various races - maybe 
you shut down the core just as a chipset event happened, and the chipset 
_thinks_ the core is now awake, but the core went to sleep. End result: 
hung machine).

		Linus
