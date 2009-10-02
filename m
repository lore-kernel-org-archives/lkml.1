Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZJBQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZJBQes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZJBQer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:34:47 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:4949 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZJBQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:34:45 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=pass (signature verified [TEST]) header.i=rdreier@cisco.com
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAN7HxUqrR7MV/2dsb2JhbADAT4hbAY8nBoQs
X-IronPort-AV: E=Sophos;i="4.44,495,1249257600"; 
   d="scan'208";a="193976062"
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
	<20090930094456.GD24621@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 Oct 2009 09:32:00 -0700
In-Reply-To: <20090930094456.GD24621@elte.hu> (Ingo Molnar's message of "Wed,
	30 Sep 2009 11:44:56 +0200")
Message-ID: <ada3a61rc3j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Oct 2009 16:32:01.0451 (UTC) FILETIME=[DE6367B0:01CA437D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Per tracepoint filtering is possible via the perf event patches Li Zefan 
 > has posted to lkml recently, under this subject:
 > 
 >    [PATCH 0/6] perf trace: Add filter support
 > 
 > They are still being worked on but it's very clear that flexible 
 > in-kernel filtering support will be a natural part of the perf event 
 > design in the very near future, so if that alone is your reason not to 
 > use it it would be better if you helped us complete/test the filter 
 > support and use that, instead of a parallel framework.
 > 
 > Or if that's not desirable or not possible, or if there's any other 
 > technical roadblock, i'd like to know the particulars of that.

So I looked a little deeper into this, and I don't think (even with the
filtering extensions) that perf events are directly applicable to this
problem.  The first issue is that, assuming I'm understanding the
comment in perf_event.c:

        /*
         * Raw tracepoint data is a severe data leak, only allow root to
         * have these.
         */

currently tracepoints can only be used by privileged processes.  A key
feature of ummunotify is that ordinary unprivileged processes can use it.

So would it be acceptable to add something like PERF_TYPE_MMU_NOTIFIER
as a way of letting unprivileged userspace get access to just MMU events
for their own process?  Clearly this touches core infrastructure and is
not as simple as just adding two tracepoints.

Then, assuming we have some way to create an "MMU notifier" perf event,
we need a way for userspace to specify which address ranges it would
like events for (I don't think the string filter expression used by
existing trace filtering works, because if userspace is looking at a few
hundred regions, then the size of the filtering expression explodes, and
adding or removing a single range becomes a pain).  So I guess a new
ioctl() to add/remove ranges for MMU_NOTIFIER perf events?

I think filtering is needed, because otherwise events for ranges that
are not of interest are just a waste of resources to generate and
process, and make losing good events because of overflow much more
likely.

We still have the problem of lost events if the mmap buffer overflows,
but userspace should be able to size the buffer so that such events are
rare I guess.

In the end this seems to just take the ummunotify code I have, and make
it be a new type of perf counter instead of a character special device.
I'd actually be OK with that, since having an oddball new char dev
interface is not particularly nice.  But on the other hand just
multiplexing a new type of thing under perf events is not all that much
better.  What do you think?

Thanks,
  Roland
