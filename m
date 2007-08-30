Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbXH3QbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbXH3QbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXH3QbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:31:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbXH3QbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:31:04 -0400
Message-ID: <46D6F0C1.9080404@redhat.com>
Date: Thu, 30 Aug 2007 12:30:57 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<23252.1188396273@turing-police.cc.vt.edu>	<3909.1188409058@turing-police.cc.vt.edu> <20070829161545.9fde1a5c.akpm@linux-foundation.org>
In-Reply-To: <20070829161545.9fde1a5c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2007 07:15 PM, Andrew Morton wrote:
> 
> So it's an interaction between the x86_64 vdso patches in Andi's tree and 
> newer glibc, and we don't know which one is getting it wrong yet?
> 

Just found this duplicated code in 2.6.23-rc4, maybe it was supposed
to be something else? The second one was added in the x86_64 vdso patch.

arch/x86_64/kernel/vsyscall.c:

void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
{
        unsigned long flags;

        write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
        /* copy vsyscall data */
        vsyscall_gtod_data.clock.vread = clock->vread;
        vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
        vsyscall_gtod_data.clock.mask = clock->mask;
        vsyscall_gtod_data.clock.mult = clock->mult;
        vsyscall_gtod_data.clock.shift = clock->shift;
        vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
        vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===
        vsyscall_gtod_data.sys_tz = sys_tz;
        vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===
        vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
        write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
}
