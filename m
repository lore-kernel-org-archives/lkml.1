Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbXGWSFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbXGWSFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763278AbXGWSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:04:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57296 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763105AbXGWSE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:04:57 -0400
Subject: Re: Possible clocksource wrapping issues w/ new vdso
	clock_gettime() code?
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1185213583.8850.12.camel@localhost>
References: <1185213583.8850.12.camel@localhost>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 11:04:55 -0700
Message-Id: <1185213895.8850.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 10:59 -0700, john stultz wrote:
> Hey Andi,
> 	I've not been able to review the new vdso code very carefully yet, but
> I noticed one thing right off: the offset calculation is not masked, so
> its possible w/ counters less then 64bits wide to have wrapping issues.

Here's another minor cleanup. Looks like wall_time_nsec is being set
twice.

diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 06c3494..fc62608 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -80,7 +80,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }


Also, is there a reason why with the new __vdso_gettimeofday
implementation, the old do_vgettimeofday has not been removed?

thanks
-john


