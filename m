Return-Path: <linux-kernel-owner+w=401wt.eu-S934741AbXGKXIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbXGKXIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbXGKXIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:08:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409AbXGKXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:08:43 -0400
Date: Wed, 11 Jul 2007 16:07:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <1184194219.12353.170.camel@chaos>
Message-ID: <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> 
 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> 
 <1184191488.12353.160.camel@chaos>  <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
 <1184194219.12353.170.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jul 2007, Thomas Gleixner wrote:
>
> The HPET change, which is the larger part of the conversion set simply
> because we now share the code with i386, might be split out by disabling
> HPET in the first step, doing the PIT / APIC conversion and then the
> HPET one in a separate step.

But that misses the point. It means that the commit that actually 
*changes* the code never actually gets tested on its own

Why not just fix up the HPET code so that it can be shared *first*. 
Without the other conversion? Really - What's so wrong with the hpet.c 
changes in the *absense* of conversion to clockevents? Those changes seem 
to be totally independent - just abstracting ou tthe 
"hpet_get_virt_address()" stuff etc.

None of that has anything to do with clockevents, as far as I can see.

In other words, you now change a i386-only file, and maybe it breaks 
subtly on i386 as a result. Wouldn't it be nicer to see that breakage as a 
separate event?

Then, the x86-64 clockevents code will switch over entirely, but now it 
switches over to something we can say has gotten testing, and we know the 
switch-over won't break any 32-bit code, because the switch-over literally 
didn't change anything at all for that case.

See? THAT is what I mean by "gradual". Bugs happen, but if we can make 
_independent_ bugs show up in _independent_ commits, that will make it 
much easier to figure out what happened.

The same is true of a lot of the APIC timer code. Sure, that patch has the 
actual conversion in it, and you don't have the cross-architecture issues, 
but more than 50% of the patch seems to be just cleanup that is 
independent of the actual switch-over, no?

Again, if it was done as a "one patch for cleanup, and another patch that 
actually switches the higher-level interfaces around", then the two mostly 
independent issues (of "hardware access/initialization" vs "higher-level 
changes in how it got called") get done as two independent commits.

And no, I really probably wouldn't ask for this, but 2.6.21 showed 
*exactly* this problem. Trivial debugging helps like "git bisect" didn't 
help at all, because all the problems started when the new code was 
"activated", not when it was actually brought in.

		Linus
