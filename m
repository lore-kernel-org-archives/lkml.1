Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXIGTjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXIGTjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXIGTjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:39:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbXIGTjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:39:32 -0400
Message-ID: <46E1A8ED.8090104@redhat.com>
Date: Fri, 07 Sep 2007 15:39:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       jakub@redhat.com, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070829161545.9fde1a5c.akpm@linux-foundation.org> <46D6F0C1.9080404@redhat.com> <200709011207.58201.ak@suse.de>
In-Reply-To: <200709011207.58201.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2007 06:07 AM, Andi Kleen wrote:
>>         write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
>>         /* copy vsyscall data */
>>         vsyscall_gtod_data.clock.vread = clock->vread;
>>         vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
>>         vsyscall_gtod_data.clock.mask = clock->mask;
>>         vsyscall_gtod_data.clock.mult = clock->mult;
>>         vsyscall_gtod_data.clock.shift = clock->shift;
>>         vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
>>         vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===
>>         vsyscall_gtod_data.sys_tz = sys_tz;
>>         vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===
> 
> Must have been a (harmless) merging mistake, but I bet gcc optimizes it out
> anyways.
> 

I did find this after some digging:


In the vdso code:

static inline long vgetns(void)
{
        cycles_t (*vread)(void);
        vread = gtod->clock.vread;
        return ((vread() - gtod->clock.cycle_last) * gtod->clock.mult) >>
                gtod->clock.shift;
}


Looks like an open-coded version of this in the kernel timekeeping code:

static inline s64 __get_nsec_offset(void)
{
        cycle_t cycle_now, cycle_delta;
        s64 ns_offset;

        /* read clocksource: */
        cycle_now = clocksource_read(clock);

        /* calculate the delta since the last update_wall_time: */
        cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;

        /* convert to nanoseconds: */
        ns_offset = cyc2ns(clock, cycle_delta);

        return ns_offset;
}

But the vdso version isn't doing any masking. And the mask is different for
different clocksources, so it has to track the underlying kernel's clocksource
when it gets changed.

