Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZAIIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZAIIXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZAIIW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:22:56 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:25158 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZAIIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:22:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMuWZkl5LDnl/2dsb2JhbADPWIV0
X-IronPort-AV: E=Sophos;i="4.37,238,1231075800"; 
   d="scan'208";a="289736074"
Date: Fri, 9 Jan 2009 19:22:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
	while holding sb_lock
Message-ID: <20090109082250.GQ9448@disturbed>
Mail-Followup-To: Arjan van de Ven <arjan@linux.intel.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4966D652.4070105@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 08:45:06PM -0800, Arjan van de Ven wrote:
> Dave Chinner wrote:
>
>>
>> So, given the potential impact of this change, what testing have
>> you done in terms of:
>>
>> 	- performance impact
>
> I tested this on my machines and it gave a real performance
> improvement (11 to 8 seconds for a full kernel tree unlink, and
> cutting out latency for normal applications)

Not really waht I'd call a significant performance test. What
happens under serious sustained I/O load? On multiple different
filesystems?

FWIW, my current kernel tree is:

$ find . -print | wc -l
30082

Which is just under the async operation limit you set so this
probably didn't even stress the mixing of sync and async deletes at
the same time...

>> 	- sync() safety
> that was exactly the synchronization point that's discussed here.

Right - how many fs developers did you discuss the impact of this
with? Did you crash test any filesystems? Did you run any fs QA
suites to check for regressions? How many different filesystems
did you even test?

We already know that sync is busted and doesn't provide the
guarantees it is supposed so on some filesystems. I'm extremely
concerned that changing unlink behaviour in this manner subtly
breaks sync even more than it already is....

>> 	- removing a million files and queuing all of the
>> 	  deletes in the async queues....
>
> the async code throttles at 32k outstanding.
> Yes 32K is arbitrary, but if you delete  a million files fast, all
> but the first few thousand are synchronous.

No, after the first 32k you get a mix of synchronous and async as
the async queue gets processed in parallel. This means you are
screwing up the temporal locality of the unlink of inodes. i.e. some
unlinks are being done immediately, others are being delayed until
another 32k inodes have been processed of the unlink list.

If we've been careful about allocation locality during untar so
that inodes that are allocated sequentially by untar will be
deleted sequential by rm -rf, then this new pattern will break those
optimisations because the unlink locality is being broken by
the some sync/some async behaviour that this queuing mechanism
creates.

Hmmmm - I suspect that rm -rf will also trigger lots of kernel
threads to be created. We do not want 256 kernel threads to
be spawned to bang on the serialised regions of filesystem
journals (generating lock contention) when one thread would
be sufficient....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
