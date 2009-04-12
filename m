Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZDLS64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZDLS64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDLS6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:58:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42859 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZDLS6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:58:46 -0400
Message-ID: <49E2398A.3050405@redhat.com>
Date: Sun, 12 Apr 2009 21:57:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu>
In-Reply-To: <20090412163356.GA2392@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Sure, go ahead and wrap them in some kind of "save and restore all 
>> registers" wrapping, but nothing fancier than that. It would just 
>> be overkill, and likely to break more than it fixes.
>>     
>
> Yeah. I only brought up the virtualization thing as a hypothetical: 
> "if" corrupting the main OS ever became a widespread problem. Then i 
> made the argument that this is unlikely to happen, because Windows 
> will be affected by it just as much. (while register state 
> corruptions might go unnoticed much more easily, just via the random 
> call-environment clobbering of registers by Windows itself.)
>
> The only case where i could see virtualization to be useful is the 
> low memory RAM corruption pattern that some people have observed. 
>   

You could easily check that by checksumming pages (or actually copying 
them to high memory) before the call, and verifying after the call.

> The problem with it, it happens on s2ram transitions, and that is 
> driven by SMM mainly - which is a hypervisor sitting on top of all 
> the other would-be-hypervisors and thus not virtualizable.
>   

AMD in fact has a chapter called "Containerizing Platform SMM" or words 
to the effect, which describes how to take a running system and drop its 
SMM mode into a virtualization container.  I made a point of skipping 
over those pages with my eyes closed so I can't tell you how incredibly 
complex it is.

It's probably even doable on Intel, though much more difficult, due to 
Intel not supporting big real mode in a guest, and most SMM code using 
it to access memory.  You'd end up running most of the code in the 
emulator, and performing the transitions by hand.

Of course, the VMM has to be careful not to trigger SMM itself, or much 
merriment ensues.

> Which leaves us without a single practical case. So it's not going 
> to happen.
>   

I don't think the effort is worth the benefit in this case, but there 
actually is an interesting use case for this.  SMM is known to be 
harmful to deterministic replay games and to real time response.  If we 
can virtualize SMM, we can increase the range of hardware on which the 
real time kernel is able to deliver real time guarantees.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

