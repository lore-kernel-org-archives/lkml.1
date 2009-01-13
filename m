Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZAMSiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZAMSiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZAMShz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:37:55 -0500
Received: from squawk.glines.org ([72.36.206.66]:50211 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZAMShy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:37:54 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 13:37:54 EST
Message-ID: <496CDDE9.3050008@glines.org>
Date: Tue, 13 Jan 2009 10:31:05 -0800
From: Mark Glines <mark@glines.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: L-K <linux-kernel@vger.kernel.org>
Subject: 2.6.28 has unconfigurable group sched?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got an issue on x86-64 where I can't configure the system to allow
RT tasks for a non-root user.

In 2.6.26.5, I was able to do the following to set things up nicely:
echo 450000 >/sys/kernel/uids/0/cpu_rt_runtime
echo 450000 >/sys/kernel/uids/1000/cpu_rt_runtime

I've searched lkml archives and am unable to figure out what changed.
As far as I can tell, the documentation (sched-rt-group.txt) says this
should work, and indeed, it did work with 2.6.26.

Seems like every value I try to echo into the /sys files returns EINVAL.
 Even when I'm just writing the same value it already had:

chirp uids # pwd
/sys/kernel/uids
chirp uids # cat 0/cpu_rt_period
1000000
chirp uids # cat 0/cpu_rt_runtime
950000
chirp uids # cat 1000/cpu_rt_period
1000000
chirp uids # cat 1000/cpu_rt_runtime
0
chirp uids # echo 450000 >0/cpu_rt_runtime
echo: write error: invalid argument
chirp uids # echo 450000 >1000/cpu_rt_runtime
echo: write error: invalid argument
chirp uids # echo 950000 >0/cpu_rt_runtime
echo: write error: invalid argument
chirp uids # echo 0 >0/cpu_rt_runtime
echo: write error: invalid argument

So it seems rt_schedulable() is never succeeding.  Any ideas?


sched-related snippets from .config:

CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y

# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set


