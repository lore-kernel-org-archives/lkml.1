Return-Path: <linux-kernel-owner+w=401wt.eu-S1030254AbXDCOVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbXDCOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXDCOVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:21:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54092 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254AbXDCOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:21:09 -0400
Date: Tue, 3 Apr 2007 19:31:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070403140150.GA14900@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402061612.GA7072@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 08:16:12AM +0200, Ingo Molnar wrote:
> i'm wondering about how TASK_UNINTERRUPTIBLE tasks are handled by the 
> freezer: are they assumed frozen immediately, or do we wait until they 
> notice their PF_FREEZING and go into try_to_freeze()? I'd expect 
> TASK_UNINTERRUPTIBLE to be the largest source of latency. (and hence be 
> the primary source for freezing 'failures')

Ok, are some luck. I panic()ed on freezer fail and checked
the stacktrace of the unfrozen tasks. The stacktrace of each one looks
like:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PID: 7697   TASK: cc354a70  CPU: 7   COMMAND: "make"
#0 [cc37fe50] schedule at c0431752
#1 [cc37fec4] wait_for_completion at c04318d0
#2 [cc37ff24] do_fork at c01249a6
#3 [cc37ff94] sys_vfork at c0103c1f
#4 [cc37ffb4] system_call at c0104d8d
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rafael had sent out a patch to fix the vfork race, which can be found at
http://lkml.org/lkml/2007/3/1/212

However, the following hunk seems to be missing from the latest -mm.

@@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
		tracehook_report_clone_complete(clone_flags, nr, p);
		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
			wait_for_completion(&vfork);
+			freezer_count();
			tracehook_report_vfork_done(p, nr);
		}
		} else {



Rafael / Andrew,
        Any reasons for leaving this hunk out?

I reran my tests with this hunk applied, and it work just fine.
Even 'make -j' the maximum time taken to hotplug a cpu was 0m2.16s.

> 
> 	Ingo

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
