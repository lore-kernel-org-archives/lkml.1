Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbXLMXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbXLMXGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXLMXGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:06:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:47879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbXLMXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:06:03 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Miller <davem@davemloft.net>, bunk@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: RFC: remove __read_mostly
From: Andi Kleen <andi@firstfloor.org>
References: <20071213222044.GH21616@stusta.de>
	<20071213.143246.175833292.davem@davemloft.net>
	<1197585855.898.33.camel@brick>
Date: Fri, 14 Dec 2007 00:06:02 +0100
In-Reply-To: <1197585855.898.33.camel@brick> (Harvey Harrison's message of "Thu\, 13 Dec 2007 14\:44\:15 -0800")
Message-ID: <p733au6gpph.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> writes:

> On Thu, 2007-12-13 at 14:32 -0800, David Miller wrote:
>> From: Adrian Bunk <bunk@kernel.org>
>> Date: Thu, 13 Dec 2007 23:20:44 +0100
>> 
>> > My question is:
>> > Is there anywhere in the kernel a case where __read_mostly brings a 
>> > measurable improvement or can it be removed?
>> 
>> Yes, on SMP when read-mostly objects share cache lines
>> with other objects which are frequently written to.
>> 
>> That is the whole reason we created __read_mostly
>
> I'm curious if anyone has been looking into replacing the __read_mostly
> approach with Mathieu's immediate values patchset.  Wouldn't they solve
> the cacheline sharing as well

Yes it would in most cases.  This means the writing case is much
more expensive with them, so if there is anything which is still
relatively frequently written (just not "mostly") it would be 
probably not a good idea. It should be only done for settings
that practically never change.

The other problem is that you have to change all accesses to the new
accessor macros which is potentially a lot. Also you have to add
sync calls for the writing case, which means that sysctl etc. setup
will be more complicated because you need "strategy" functions now.

Also for things that are not that critical the uglification in
the source is likely not worth it.

I would suggest to only do it after looking at oprofile cache miss
profiles.

> (perhaps more eficiently even with trading
> some icache for dcache)?

It should be more efficient because there will be less dcache misses.
icache is typically already prefetched by the CPU. This is especially
useful for the kernel because it often runs cache cold because user
space used all the cache.

-Andi
