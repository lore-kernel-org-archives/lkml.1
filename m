Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZIQOtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZIQOtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZIQOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:49:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZIQOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:49:44 -0400
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <adaab0tej5c.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com>  <adaab0tej5c.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 16:49:36 +0200
Message-Id: <1253198976.14935.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 07:32 -0700, Roland Dreier wrote:
> > So getting those events in the kernel is no problem -- we have the MMU
>  > notifier hooks that tell us exactly what we need to know.  The issue is
>  > purely the way userspace registers interest in address ranges, and how
>  > to kernel returns the events.
>  > 
>  > For perf counters it seems that one would have to create a new counter
>  > for each address range... is that correct?  And also I don't know if
>  > perf counter has an analog for the fast path optimization that
>  > ummunotify provides via a mmap'ed generation counter (a quick way for
>  > userspace to see 'nothing happened since last time you checked').
> 
> Oh I forgot... ummunotify also preallocates everything etc. so that
> there is no way for events to be lost.  Which saves userspace from
> having to trash everything cached and start over, which it would have to
> do if it misses an invalidate event.
> 
> And AFAIK, pref counters does have the possibility of overflowing a
> buffer and losing an event, right?

Well, you cannot pre-allocate everything, either you get back-logged
evens in kernel space leading to a kernel DoS, or you loose events.

Perf counters have two modes, a RO mmap() and a RW mmap(). The RO mode
will automagically overwrite its tail data without regard for userspace
having observed it.

In the RW mode userspace has to advance the tail, the kernel will drop
events when full and insert a PERF_EVENT_LOST event once there is room
again.

Hmm, or are you saying you can only get 1 event per registered range and
allocate the thing on registration? That'd need some registration limit
to avoid DoS scenarios.

