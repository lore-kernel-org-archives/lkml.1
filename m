Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYFRPbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYFRPbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYFRPbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:31:24 -0400
Received: from in.cluded.net ([195.159.98.120]:58174 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbYFRPbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:31:23 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <48592A4D.2090100@uw.no>
Date: Wed, 18 Jun 2008 17:31:25 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Starvation of one RT task when the runtime of another exceeds period.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will demonstrate how to get an RT task stuck, and not rescheduled by
(ab)using cgroups and RT scheduling. This is on a 4 core system running
2.6.26-rc6 with two patches applied to make it work at all.

http://marc.info/?i=1213732878.3223.95.camel@lappy.programming.kicks-ass.net
http://marc.info/?i=1213789854.16944.216.camel@twins

mkdir /dev/cgroup
mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup

# Set up cgroup 0
mkdir /dev/cgroup/0
echo 3 > /dev/cgroup/0/cpuset.cpus
echo 0 > /dev/cgroup/0/cpuset.mems
echo 100000 > /dev/cgroup/0/cpu.rt_period_us
echo   5000 > /dev/cgroup/0/cpu.rt_runtime_us

# Set up cgroup 1
mkdir /dev/cgroup/1
echo 3 > /dev/cgroup/1/cpuset.cpus
echo 0 > /dev/cgroup/1/cpuset.mems
echo 100000 > /dev/cgroup/1/cpu.rt_period_us
echo   5000 > /dev/cgroup/1/cpu.rt_runtime_us

# Start task 1, and assign it to cgroup 0
schedtool -R -p 1 -e burnP6 &
[1] 3309
echo 3309 > /dev/cgroup/0/tasks

At this point task 1 use 20% CPU.

# Start task 2, and assign it to cgroup 1
schedtool -R -p 1 -e burnP6 &
[2] 3313
echo 3313 > /dev/cgroup/1/tasks

At this point task 2 use 20% CPU.
Both tasks use 40% of CPU core#3 in total.

# Assign an insane amount of runtime (over 100%, ref. my other mail)
echo 30000  > /dev/cgroup/1/cpu.rt_runtime_us

Now, task 2 use 100% of the CPU, and completely starves task 1, which
ceases to get scheduled.

# Cut down on the insanity
echo  5000 > /dev/cgroup/1/cpu.rt_runtime_us

Now task 2 use only 20% of the CPU again, task 1 does still not get
scheduled.

Let's call this state 'stuck'

I can make task 1 get unstuck by assigning its PID to another cgroup.

# Kick task 1, so it gets scheduled again.
echo 3309 > /dev/cgroup/1/tasks

Assuming we go back to state 'stuck', a 'killall burnP6' will only kill
task 2, task 1 is still waiting for someone to come and kick it in the
butt. As soon as that happens, it will get killed as well.

One time even both tasks got stuck and did not get scheduled, and I
needed to kick both tasks to get them going again.

Well, this wasn't really a question, but I'm sure this is not how it's
supposed to behave?


Daniel K.
