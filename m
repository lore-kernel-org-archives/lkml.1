Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYHaEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYHaEOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYHaEOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 00:14:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbYHaEOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 00:14:10 -0400
Date: Sat, 30 Aug 2008 21:12:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jordan Crouse <jordan.crouse@amd.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <alpine.LFD.1.10.0808302055040.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808302100490.12958@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>  <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>  <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
  <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>  <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>  <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>  <86802c440808301727k3e86c816j323eca0fb5e3f4fc@mail.gmail.com>
  <86802c440808301750w6655bbek557e6a23b8036654@mail.gmail.com>  <alpine.LFD.1.10.0808301949100.3290@nehalem.linux-foundation.org> <86802c440808302053r46256f68mf356797a259ad164@mail.gmail.com>
 <alpine.LFD.1.10.0808302055040.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Linus Torvalds wrote:
> 
> Short recap:
> 
>  - we need to populate the resource map with as much possible information 
>    about the system as we can..
> 
>  - .. because when we assign _dynamic_ resources, we need to make sure 
>    that they don't clash with random system resources that we don't really 
>    otherwise have a lot of visibility into.
> 
> So the resource tree is not just about resources we control, it's also 
> about resources that others control(led) and we don't necessarily know a 
> lot about.

Btw, this is a problem that we seldom actually have on most desktops, 
because the BIOS will normally set up just about _all_ the resources, and 
we seldom have to worry about anything but just enumerating them (and the 
occasional buggy setup).

The problems with resource allocation mostly happen on laptops, and 
especially with cardbus controllers. Now, that's obviously going away 
(people mostly use USB for most things that Cardbus/PCMCIA was used for a 
few years ago), but it still exists and with docking stations etc it can 
actually be even worse (although that's mainly because access to docking 
stations is much more limited, I suspect).

So what used to happen _all_ the time was that cardbus worked fine on 99% 
of all machines, but then some machines would lock up when you inserted a 
card in them, or the card just wouldn't work. And the reason was that some 
stupid motherboard resource (like the ACPI sleeping registers or the LPC 
control regs) were not done as a normal BAR, so the kernel wouldn't know 
about them, and the BIOS didn't necessarily even list it because it never 
mattered with Windows (since Windows has a different algorithm for laying 
out the bus resources, and wouldn't hit the magic resource).

So this is why we populate the resources with everything we can _possibly_ 
try to find, including hardware-specific quirks (see things like 
quirk_ali7101_acpi or all the quirk_ich4_lpc_acpi things etc) for finding 
resources that aren't done by BAR's.

And the hardware quirks have generally worked pretty well. I'd love to add 
some quirk for the RD790 chipset, but I'd like to know what the rules are 
for it. I know we have some AMD contacts, I wonder if they could give docs 
(I don't personally do NDA's, but I can do "gentleman's agreements" where 
I just say I won't spread things further, as long as I can write code 
based on them. I know other kernel developers do similar things).

Jordan?

			Linus
