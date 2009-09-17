Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZIQOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZIQOnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZIQOnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:43:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZIQOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:43:21 -0400
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <adafxalejiq.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 16:43:13 +0200
Message-Id: <1253198593.14935.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 07:24 -0700, Roland Dreier wrote:
> > Anton Blanchard suggested a while back that this might be integrated
>  > with perf-counters, since perf-counters already does mmap() tracking and
>  > also provides events through an mmap()'ed buffer.
>  > 
>  > Has anybody looked into this?
> 
> I didn't see the original suggestion.  Certainly hooking in to existing
> infrastructure for user/kernel communication would be good.
> 
> The fit doesn't seem great to me, although I am rather naive about perf
> counters.  The problem that ummunotify is trying to solve is to let an
> app say 'for these 1000 address ranges (that possibly only cover a small
> part of my total address space), please let me know when the mappings
> are invalidated for any reason'.
> 
> So getting those events in the kernel is no problem -- we have the MMU
> notifier hooks that tell us exactly what we need to know.  The issue is
> purely the way userspace registers interest in address ranges, and how
> to kernel returns the events.
> 
> For perf counters it seems that one would have to create a new counter
> for each address range... is that correct?  And also I don't know if
> perf counter has an analog for the fast path optimization that
> ummunotify provides via a mmap'ed generation counter (a quick way for
> userspace to see 'nothing happened since last time you checked').

You're right in that perf-counter currently doesn't provide a way to
specify these ranges, we simply track all mmap() traffic.

The thing is that mmap() data is basically a side channel. For your
usage you'd basically have to open a NOP counter and only observe the
mmap data.

We could look at ways of adding ranges..

We do have a means of detecting if new data is available, we keep a data
head index. If that moves, you've got new stuff.



