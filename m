Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYH2AVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYH2AVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYH2AVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:21:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYH2AVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:21:45 -0400
Message-ID: <48B740F5.5060903@zytor.com>
Date: Thu, 28 Aug 2008 17:21:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
References: <1219955655-18357-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281339250.3300@nehalem.linux-foundation.org> <86802c440808281352y1371f437vf3409d9e104d1a51@mail.gmail.com> <20080828211647.GA32431@elte.hu>
In-Reply-To: <20080828211647.GA32431@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Here we have the problem of overlap i outlined earlier: if there's a 
> partial overlap at this stage (as i think it can happen in the hpet case 
> on David's box), we wont insert the E820_RESERVED resource.
> 
> The hpet hang will be solved, because we dont reprogram the BAR, but we 
> now keep the formerly e820-reserved area as 'free' - which the PCI code 
> could allocate new resources into - which could cause other problems 
> (hangs, non-working devices, etc.) down the line.
> 
> Which most likely wont happen currently in practice (there's enough free 
> space elsewhere), but it's still a not truly 'free' area and it would be 
> nice to have a complete and correct picture, based on all sources of 
> information we have.
> 

This may be a rehash of things previously discussed in this thread; my 
email seems to be a bit flakey to the point that I don't know if I have 
gotten all the messages.

Either way, Ingo mentioned in a private messages four steps, basically 
summarizing the above email:

1 - first we allocate the absolute essentials (e820 RAM and a few low
     RAM specials)
2 - then we register all existing PCI resources - but do not reallocate
     any PCI resources that conflict with existing step #1 resources
3 - then we allocate e820 reserved entries (and whatever special non-PCI
     resources we might know about in general) - these are less trusted
     than any of the existing PCI resources but still it can hurt us
     badly if the PCI code allocates new resources on them.
4 - then the PCI code can run and allocate free resources to all the
     zero, not yet allocated BARs, and can reallocate any resources that
     might conflict with existing [step #1 or step #3] registered
     resources.

I agree that this is almost certainly what we should be doing; there is 
a difference between claiming resources already allocated and allocating 
resources to new address space, in which case we want to be as 
conservative as possible.

The key, of course, is that nothing goes in #1 unless we are bloody 
damned sure that if a BAR points there, that BAR is unconditionally 
broken and pointing into hyperspace.  Something claiming RAM or, say, 
the legacy KBC might fall in this area.

	-hpa
