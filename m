Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXDBFv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXDBFv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXDBFv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:51:27 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41466 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbXDBFvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:51:25 -0400
Date: Mon, 2 Apr 2007 11:04:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402053457.GA9076@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everybody, 

This is another attempt towards process-freezer based cpu-hotplug.
This patchset covers just about everything that was discussed on
the LKML with respect to the freezer-based cpu-hotplug.

Following are new features from the version I last posted:

- Enhancements to the freezer interface so that
  it can be used for events other than Software suspend.

- A reentrant process freezer. Software suspend needs since it uses
  cpu-hotplug.

- All non-singlethreaded workqueues freezeable by default.

And yes, this time around, I have some numbers to give an idea 
of the performance.

Test m/c configuration: 4-way i386 Xeon Box with 2.5G Memory.
Test case: 'make -jN' running parallely with cpu-offline/online operations
	    in a tight loop.

With N=256.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Kernel: linux-2.6.21-rc5-mm3 vanilla
---------------------------------------------------------
Maximum time taken for a hotplug operation	:  1m5.357s
Minimum time taken for a hotplug operation	:  0m0.288s
Average number of attempts to offline AND Online
cpu1, cpu2 and cpu3				: 6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Kernel: linux-2.6.21-rc5-mm3 + the patchset.
---------------------------------------------------------
Maximum time taken for a hotplug operation	: 0m1s.261s
Minimum time taken for a hotplug operation	: 0m0s.808s
Average number of attempts to offline and online
cpu1, cpu2 and cpu3				: 14
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The numbers look ok.

However, on an average it took around 14 attempts to offline AND online
cpu1,cpu2, cpu3 when otherwise it should have taken only 6.

The failures were due to the freezer failing to freeze all the tasks
within the timeout period (20sec).

As N increased (512, 1024, 2048 and 8192), even the average number
of attempts to online AND offline the 3 cpus increased.

At this point of time, I worked towards ensuring that cpu-hotplug works
reliably with process freezer. The patchset has behaved reliably 
(no oopses/hangs/freezes) whenever the process freezer has successfully frozen 
all the tasks in the system, thereby resulting in a successful cpu-hotplug
operation.

The tasks which failed to freeze, in each of the failed cases, were all
'make' tasks which had been forked out by the make -jN test case.

I believe that the reasons for freezer failing as N increases are :
- 'make -jN' keeps forking new tasks every now and then, thereby resulting
  in a never-ending catching up game in the do_while loop inside
  try_to_freeze_tasks (kernel/power/process.c)

- Many of the threads might be sleeping on some mutex/semaphore and thus
  never calling try_to_freeze() within the timeout period.

Instead of waiting for all the tasks to call try_to_freeze 
in the above mentioned do_while loop, I wonder if we can put some hooks in 
sched.c so asto not schedule the task marked PF_FREEZING/PF_FROZEN. 
That way we would only have to wait for the currently running thread to call 
try_to_freeze for each online cpu. 

I'm sure there are better explainations/solutions to this problem.

And yeah, trying a cpu-hotplug operation with a plain 'make -j' might be a 
little too ambitious at this point of time. Atleast in my case it was :-)

The patchset is against 2.6.21-rc5-mm3.

Awaiting your feedback.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
