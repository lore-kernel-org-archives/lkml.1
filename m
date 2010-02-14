Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab0BNKMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:12:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0BNKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:22 -0500
Subject: Re: [RFC] perf_events: how to add Intel LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:01 +0100
Message-ID: <1266142321.5273.409.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 12:31 +0100, Stephane Eranian wrote:

> Intel Last Branch Record (LBR) is a cyclic taken branch buffer hosted
> in registers. It is present in Core 2, Atom, and Nehalem processors. Each
> one adding some nice improvements over its predecessor.
> 
> LBR is very useful to capture the path that leads to an event. Although
> the number of recorded branches is limited (4 on Core2 but 16 in Nehalem)
> it is very valuable information.
>
> One nice feature of LBR, unlike BTS, is that it can be set to freeze on PMU
> interrupt. This is the way one can capture a path that leads to an event or
> more precisely to a PMU interrupt.

Right, it allows to compute the actual IP for the IP+1 PEBS things among
other things, although that requires using a PEBS threshold of 1 record
I figure.

> The usage model is that you always couple LBR with sampling on an event.
> You want the LBR state dumped into the sample on overflow. When you resume,
> after an overflow, you clear LBR and you restart it.
> 
> One obvious implementation would be to add a new sample type such as
> PERF_SAMPLE_TAKEN_BRANCHES. That would generate a sample with
> a body containing an array of 4x2 up to 16x2 u64 addresses. Internally, the
> hw_perf_event_structure would have to store the LBR state so it could be
> saved and restored on context switch in per-thread mode.

x3 actually (like the BTS record), because we cannot keep the flags in
the from address like the hardware does, we need to split them out into
a separate word, otherwise we'll run into trouble the moment someone
makes a machine with 64bit virtual space.

> There is one problem with this approach. On Nehalem, the LBR can be configured
> to capture only certain types of branches + priv levels. That is about
> 8 config bits + priv levels. Where do we pass those config options?

Right, this config stuff really messes things up on various levels.

> One solution would have to provide as many PERF_SAMPLE bits as the hardware
> OR provide some config field for it in perf_event_attr. All of this
> would have to remain very generic.

The problem with this LBR config stuff is that is creates inter-counter
constraints, because each counter wanting LBR samples needs to have the
same config.

Dealing with context switches is also going to be tricky, where we have
to safe and 'restore' LBR stacks for per-task counters.

FWIW, I'm tempted to stick with the !config variant, that's going to be
interesting enough to implement. Also, I'd really like to see a sensible
use case for these config bits that would justify their complexity.

> An alternative approach is to define a new type of (pseudo)-event, e.g.,
> PERF_TYPE_HW_BRANCH and provide variations very much like this is
> done for the generic cache events. That event would be associated with a
> new fixed-purpose counter (similar to BTS). It would go through scheduling
> via a specific constraint (similar to BTS). The hw_perf_event structure
> would provide the storage area for dumping LBR state.
> 
> To sample on LBR with the event approach, the LBR event would have to
> be in the same event group. The sampling event would then simply add
> sample_type = PERF_SAMPLE_GROUP.
> 
> The second approach looks more extensible, flexible than the first one. But
> it runs into a major problem with the current perf_event API/ABI and
> implementation. The current assumption is that all events never return more
> than 64-bit worth of data. In the case of LBR, we would need to return way
> more than this.

Agreed, that is also not a very attractive model.


