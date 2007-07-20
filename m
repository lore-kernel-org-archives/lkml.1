Return-Path: <linux-kernel-owner+w=401wt.eu-S935392AbXGTBEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392AbXGTBEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbXGTBEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:04:42 -0400
Received: from ozlabs.org ([203.10.76.45]:53522 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbXGTBEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:04:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
Date: Fri, 20 Jul 2007 11:01:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
In-Reply-To: <20070719160025.GA31815@elte.hu>
References: <1184842661.6546.14.camel@localhost.localdomain>
	<469F8342.7060000@goop.org>
	<20070719160025.GA31815@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> CFS does measure time elapsed across task-sleep periods (and does 
> something similar to what the old scheduler's 'sleep average' 
> interactivity mechanism did), but that mechanism measures "time spent 
> running during sleep", not "time spent idling".

PowerPC's sched_clock() currently measures real time.  On POWER5 and
POWER6 machines we could change it to use a register called the "PURR"
(for Processor Utilization of Resources Register), which only measures
time spent while the partition is running.  But the PURR has another
function as well: it measures the distribution of dispatch cycles
between the two hardware threads on each core when running in SMT
mode.  That is, the cpu dispatches instructions from one thread or
the other (not both) on each CPU cycle, and each thread's PURR only
gets incremented on cycles where the cpu dispatches instructions for
that thread.  So the sum of the two threads' PURRs adds up to real
time.

Do you think this makes the PURR more useful for CFS, or less?  To me
it looks like this would mean that CFS can make a more equitable
distribution of CPU time if, for example, you had 3 runnable tasks on
a 2-core x dual-threaded machine (4 virtual CPUs).

BTW, what does "time spent running during sleep" mean?  Does it mean
"time that other tasks are running while this task is sleeping"?

> still, CFS needs time measurement across idle periods as well, for 
> another purpose: to be able to do precise task statistics for /proc. 
> (for top, ps, etc.) So it's still true that sched_clock() should include 
> idle periods too.

As with s390, 64-bit PowerPC also uses CONFIG_VIRT_CPU_ACCOUNTING.
That affects how tsk->utime and tsk->stime are accumulated (we call
account_user_time and account_system_time directly rather than calling
update_process_times) as well as the system hardirq/softirq time, idle
time, and stolen time.

When you say "precise task statistics for /proc", where are they
accumulated?  I don't see any changes to the way that tsk->utime and
ctime are computed.

Paul.
