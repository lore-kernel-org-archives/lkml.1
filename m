Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbYAWJGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbYAWJGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYAWJFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:05:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:55242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYAWJFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:05:49 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de>
	<20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de>
	<alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de>
	<20080122132355.GA24320@wotan.suse.de>
	<alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de>
	<20080122142147.GD19936@wotan.suse.de>
	<20080123000017.GA16576@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 10:05:47 +0100
In-Reply-To: <20080123000017.GA16576@elte.hu>
Message-ID: <p7363xknc7o.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> that is (yet another) major misconception on your part. "Drivers" are an 
> easy to blame target (i guess because there's no one out there to defend 
> a vague "drivers" accusation), and they are not the problem here _at 
> all_.

In this case the problem is that drivers ask for different caching mode
on overlapping IO mappings. That only gets resolved by the underlying
MTRRs, but PAT aware code has to fail.

> 
> Drivers tell the architecture code which physical pages they'd like to 
> have access to (or which page range they'd like to see different cache 
> attributes on) and that's it. They are plain users of the ioremap() and 
> change_page_attr() APIs. Nothing more, nothing less.

That's true, but the problem is that they give different conflicting 
requests (cached and uncached).

 
> It is the utmost duty of architecture code to make those APIs 
> fool-proof.

Well if they ask for conflicting requirements what can you do? 

> Hardware _will_ mess up the physical parameters that get 
> passed in every possible way

Does it?

 - and drivers just try to use what the 
> hardware tells them to use. So robustness is key and there's just no 
> "driver reason" why these APIs cannot be robust.

ioremap as an ABI is robust I believe, but still it has some basic 
requirements like nobody passing in conflicting requests.

Are you saying the underlying ioremap() interface should silently
change the caching mode if the driver passes in a conflicting one?

I have my doubts that would be a good strategy. Better probably 
to fail and complain and fix the drivers after some code review.

> oh, and due to that i'll probably revert these two patches of yours:
> 
>   Subject: x86: c_p_a(), change kernel_map_pages to not use c_p_a()
>   Subject: x86: c_p_a(), change 32-bit back to init_mm semaphore locking
> 
> as with these changes you've removed _the_ most important stress-tester 
> for the c_p_a() code: DEBUG_PAGEALLOC.

Point of that being? I added a separate stress tester instead
that actually tests far more cases and actually verifies that it 
works.

My take is rather that with my changes DEBUG_PAGEALLOC is significantly
cheaper than it was before (e.g. it runs lockless now) so actually
more people can use it for debugging.

And after all we have millions of lines of code who can benefit
from DEBUG_PAGEALLOC and will benefit from it being cheaper, while cpa 
is just a few hundred lines of code that we will hopefully eventually
get right anyways.

-Andi
