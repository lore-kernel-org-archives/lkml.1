Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbXEHGDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbXEHGDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXEHGDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:03:09 -0400
Received: from holomorphy.com ([66.93.40.71]:59473 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbXEHGDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:03:08 -0400
Date: Mon, 7 May 2007 23:03:42 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-ID: <20070508060342.GH19966@holomorphy.com>
References: <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org> <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org> <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org> <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org> <20070508053132.GZ31925@holomorphy.com> <20070507223738.57d763da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507223738.57d763da.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 22:31:32 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> I think Andi's handling the mergework on those patches, but I'll check
>> in to see if I should rediff vs. -mm or what if you want them.
>> Andi, what's the verdict on those stack patches?

On Mon, May 07, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> Whoa. The verdict is usually "don't use so much stack".
> Do we know what has gone wrong here?
> Last week Jens said he was picking up the ancient
> md-dm-reduce-stack-usage-with-stacked-block-devices.patch, but he doesn't
> seem to have done so yet.
> XFS is frequently implicated.

Well, the culmination of those patches is a patch to use vmallocspace
to establish guard pages for stacks so overflows are immediately trapped
and the potential for silent corruption greatly reduced. That would be
where I suspect it's most relevant, as that's the focal point of the
series. The bit about unconditional IRQ stacks arose as part of review.

It started life as a set of patches intended to help with debugging
stack overflows, which is how the only tangentially-related unconditional
IRQ stacks came about: originally they were optional as a debug option
for differential diagnosis of interrupt-time overflows. For mainline, hch
suggested that they should rather be made unconditional.

The third part of the series that survived review was dynamic boot-time
allocation of IRQ stacks, which was originally motivated by the need
for indirection when remapping IRQ stacks into vmallocspace, but also
served the purpose of mitigating space overhead when using IRQ stacks
because cpu_possible_map is not set up as it should be to avoid the
allocation via per_cpu array variables' dynamic boot-time allocation
on i386 and (AFAIK) x86-64.


-- wli
