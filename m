Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXDQJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXDQJ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXDQJ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:58:17 -0400
Received: from holomorphy.com ([66.93.40.71]:56889 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbXDQJ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:58:16 -0400
Date: Tue, 17 Apr 2007 02:57:49 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417095749.GN2986@holomorphy.com>
References: <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417092422.GA19414@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Also, given the general comments it appears clear that some 
>> statistical metric of deviation from the intended behavior furthermore 
>> qualified by timescale is necessary, so this appears to be headed 
>> toward a sort of performance metric as opposed to a pass/fail test 
[...]

On Tue, Apr 17, 2007 at 11:24:22AM +0200, Ingo Molnar wrote:
> yeah. If you could come up with a sane definition that also translates 
> into low overhead on the algorithm side that would be great! The only 
> good generic definition i could come up with (nice levels are isolated 
> buckets with a constant maximum relative percentage of CPU time 
> available to every active bucket) resulted in having a per-nice-level 
> array of rbtree roots, which did not look worth the hassle at first 
> sight :-)

Interesting! That's what vdls did, except its fundamental data structure
was more like a circular buffer data structure (resembling Davide
Libenzi's timer ring in concept, but with all the details different).
I'm not entirely sure how that would've turned out performancewise if
I'd done any tuning at all. I was mostly interested in doing something
like what I heard Bob Mullens did in 1976 for basic pedagogical value
about schedulers to prepare for writing patches for gang scheduling as
opposed to creating a viable replacement for the mainline scheduler.

I'm relatively certain a different key calculation will suffice, but
it may disturb other desired semantics since they really need to be
nonnegative for multiplying by a scaling factor corresponding to its
nice number to work properly. Well, as the cfs code now stands, it
would correspond to negative keys. Dividing positive keys by the nice
scaling factor is my first thought of how to extend the method to the
current key semantics. Or such are my thoughts on the subject.

I expect that all that's needed is to fiddle with those numbers a bit.
There's quite some capacity for expression there given the precision.


On Tue, Apr 17, 2007 at 11:24:22AM +0200, Ingo Molnar wrote:
> until now the main approach for nice levels in Linux was always: 
> "implement your main scheduling logic for nice 0 and then look for some 
> low-overhead method that can be glued to it that does something that 
> behaves like nice levels". Feel free to turn that around into a more 
> natural approach, but the algorithm should remain fairly simple i think.

Part of my insistence was because it seemed to be relatively close to a
one-liner, though I'm not entirely sure what particular computation to
use to handle the signedness of the keys. I guess I could pick some
particular nice semantics myself and then sweep the extant schedulers
to use them after getting a testcase hammered out.


-- wli
