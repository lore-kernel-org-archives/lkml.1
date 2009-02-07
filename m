Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZBGM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZBGM1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZBGM1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:27:03 -0500
Received: from lazybastard.de ([212.112.238.170]:44342 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZBGM1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:27:01 -0500
Date: Sat, 7 Feb 2009 13:26:18 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090207122618.GA17222@logfs.org>
References: <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110220135.GF20611@logfs.org> <20090110142330.295a8847.akpm@linux-foundation.org> <1231631840.13420.24.camel@twins> <1233793066.7390.34.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1233793066.7390.34.camel@johannes.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 February 2009 01:17:46 +0100, Johannes Berg wrote:
> 
> Joern may need arbitrary key lengths, don't. But I've just looked around
> a little:
> 
>  * radix trees are completely unsuitable for use as a sort of hash table
>    because of their behaviour when keys are not at last mostly
>    contiguous
>  * rbtrees require lots of boilerplate code, and have much worse cache
>    behaviour

I did some testing as well.  And I didn't like the results very much.
In my test harness, rbtrees performed roughly twice as good as btrees.

Something clearly is wrong with my theory.  To spell it out, the theory
assumes that 1) CPUs get continuously faster at computations while
memory latency stays roughly constant and as a result 2) current CPUs
are sufficiently fast that memory latency is more important than a large
amount of computation.  And maybe 3) L1 cache latency can be ignored,
while DRAM latency most definitely can not.

At least one of the above must be wrong.  Another interesting data point
is that after hacking up binary search within nodes, btrees performed
roughly 10% better than before.  Binary search means we mispredict every
other branch, yet this still improved performance.  So on my test CPU
(Pentium M), branch mispredictions must be relatively cheap compared to
either calculations or L1 cache latency.

I also tried to rig the tests to favor btrees over rbtrees.  Since the
rb_node is embedded in an object, I grew those objects beyond cacheline
size, so no two rb_nodes would ever share a cacheline while all the
pointers in btrees still do.  And still btrees lost.  Well - if the
dataset is large enough that all the object padding is comsuming half a
gigabyte of memory, swapping will make the rbtree load go slow, but
given enough free memory and no swapping (i.e. second run) it beats
btrees.

So there are two results I can see from all this.  Rbtrees are still a
good choice an semi-current machines and the kernel doesn't need much
rework yet.  Whether my assumption 2) above will match reality better in
the future and the scales will tip to the other side I don't know.  The
other is that my assumptions are wrong somewhere and I don't yet
understand where.  If anyone has an idea, I'd be glad to hear about it.

Jörn

-- 
Science is like sex: sometimes something useful comes out,
but that is not the reason we are doing it.
-- Richard Feynman
