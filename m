Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZJGWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZJGWf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZJGWf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:35:28 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:65396 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbZJGWfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:35:25 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=pass (signature verified [TEST]) header.i=rdreier@cisco.com
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADe0zEqrR7PD/2dsb2JhbAC/F4hjAY88BoQq
X-IronPort-AV: E=Sophos;i="4.44,521,1249257600"; 
   d="scan'208";a="252501253"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
	<adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
	<20090930094456.GD24621@elte.hu> <ada3a61rc3j.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 Oct 2009 15:34:47 -0700
In-Reply-To: <ada3a61rc3j.fsf@cisco.com> (Roland Dreier's message of "Fri, 02
	Oct 2009 09:32:00 -0700")
Message-ID: <ada3a5uq1dk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Oct 2009 22:34:47.0755 (UTC) FILETIME=[602E91B0:01CA479E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > So I looked a little deeper into this, and I don't think (even with the
 > filtering extensions) that perf events are directly applicable to this
 > problem.  The first issue is that, assuming I'm understanding the
 > comment in perf_event.c:
 > 
 >         /*
 >          * Raw tracepoint data is a severe data leak, only allow root to
 >          * have these.
 >          */
 > 
 > currently tracepoints can only be used by privileged processes.  A key
 > feature of ummunotify is that ordinary unprivileged processes can use it.
 > 
 > So would it be acceptable to add something like PERF_TYPE_MMU_NOTIFIER
 > as a way of letting unprivileged userspace get access to just MMU events
 > for their own process?  Clearly this touches core infrastructure and is
 > not as simple as just adding two tracepoints.
 > 
 > Then, assuming we have some way to create an "MMU notifier" perf event,
 > we need a way for userspace to specify which address ranges it would
 > like events for (I don't think the string filter expression used by
 > existing trace filtering works, because if userspace is looking at a few
 > hundred regions, then the size of the filtering expression explodes, and
 > adding or removing a single range becomes a pain).  So I guess a new
 > ioctl() to add/remove ranges for MMU_NOTIFIER perf events?
 > 
 > I think filtering is needed, because otherwise events for ranges that
 > are not of interest are just a waste of resources to generate and
 > process, and make losing good events because of overflow much more
 > likely.
 > 
 > We still have the problem of lost events if the mmap buffer overflows,
 > but userspace should be able to size the buffer so that such events are
 > rare I guess.
 > 
 > In the end this seems to just take the ummunotify code I have, and make
 > it be a new type of perf counter instead of a character special device.
 > I'd actually be OK with that, since having an oddball new char dev
 > interface is not particularly nice.  But on the other hand just
 > multiplexing a new type of thing under perf events is not all that much
 > better.  What do you think?

Ingo/Peter/<anyone suggesting perf events> -- can you comment on this
plan of creating PERF_TYPE_MMU_NOTIFIER for perf events to implement
ummunotify?  To me it looks like a wash -- the main difference is how
userspace gets the magic ummunotify file descriptor, either by
open("/dev/ummunotify") or by perf_event_open(...PERF_TYPE_MMU_NOTIFIER...),
but pretty much everything else stays pretty much the same in terms of
how much kernel code is involved.  We do reuse the perf events mmap
buffer code but I think that ends up being more complicated than
returning events via read().

Anyway, before I spend the time converting over to the new
infrastructure and causing the MPI guys to churn their code, I'd like to
make sure that this is what you guys have in mind.

(By the way, after thinking about this more, I really do think that
filtering events by address range is a must-have -- with filtering,
userspace can map sufficient buffer space to avoid losing events for a
given number of regions; without filtering, events might get lost just
because of invalidate events for ranges userspace didn't even care about)

Thanks,
  Roland
