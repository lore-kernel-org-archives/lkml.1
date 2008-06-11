Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYFKAbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYFKAbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYFKAaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:30:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15952 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYFKAay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:30:54 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3829774"
Message-ID: <484F1CE1.3010701@qualcomm.com>
Date: Tue, 10 Jun 2008 17:31:29 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-rt-users@vger.kernel.org
Subject: linux v2.6.25.6.cpuisol1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest version of my CPU isolation tree.
Git tree is available at:
   git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.25.y.git
   http://www.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.25.y.git

Full patch is at:
http://kernel.org/pub/linux/kernel/people/maxk/cpuisol/patches/v2.6.25.6.cpuisol1.patch

In order to simplify overall system setup I wrote a simple tool for system
partitioning - "syspart". You can get the latest version from here
   http://kernel.org/pub/linux/kernel/people/maxk/cpuisol/syspart/
   git://git.kernel.org/pub/scm/linux/kernel/git/maxk/syspart.git

This tool takes care of setting up IRQ affinities and cpusets, moving kernel
and user space tasks, bring CPUs off/online, etc. Please note that you want to
disable daemons like "irqbalance" to avoid resource partitioning conflicts.
For more info see syspart/README.

--
I also have some sample kernel configs that have been tested and are know to
work. You can pick one of them as base for your kernel:
   http://kernel.org/pub/linux/kernel/people/maxk/cpuisol/configs/

Required kernel features:
   CONFIG_CGROUP
   CONFIG_CPUSETS
   CONFIG_CPU_HOTPLUG

Following features are required if you intend on chewing ~100% in the user
space SCHED_FIFO threads running on the isolated CPUs (note that OPROFILE is
known to not work for this use case):
   CONFIG_SLUB or CONFIG_SLOB

You may also want to disable the following features in order to achieve the
lowest possible latency:
   !CONFIG_HIGH_RES_TIMERS
   !CONFIG_NO_HZ
   !CONFIG_CPU_FREQ
And of course you want to refer to
   http://rt.wiki.kernel.org/index.php/HOWTO:_Build_an_RT-application
for general guidelines on how to build RT applications.

---
This version is based on a completely different approach (compared to previous
cpuisol tree releases). Instead of the centralized cpu_isolation_map it's now
based on the existing kernel features like cpusets. The number of changes is
therefor very small.

Shortlog:
Max Krasnyansky (6):
      sched: Fix memory leak in the cpu hotplug handing logic
      sched: CPU hotplug events must not destroy scheduler domains created by
	     the cpusets
      genirq: Expose default irq affinity mask (take 3)
      sysctl: Add generic cpumask parser for sysctls
      stopmachine: Introduce stopmachine_cpus sysctl
      Linux 2.6.25.6.cpuisol1

sched: changes are simple bug fixes and are on their way into the mainline.
genirq: stuff has been ACKed in general is pending final ACK from genirq
maintainer.
stopmachine change is a temporary hack to allow for module insertion and removal.

Diffstat:
 Documentation/IRQ-affinity.txt     |   37 ++++++++++++++----
 Documentation/filesystems/proc.txt |   29 +++++++++-----
 Makefile                           |    2 -
 arch/alpha/kernel/irq.c            |    5 +-
 include/linux/irq.h                |   14 ++-----
 include/linux/sysctl.h             |    2 +
 kernel/cpuset.c                    |    6 +++
 kernel/irq/manage.c                |   28 +++++++++++++-
 kernel/irq/proc.c                  |   59 +++++++++++++++++++++++++++--
 kernel/sched.c                     |   23 +++++++++++
 kernel/stop_machine.c              |    5 ++
 kernel/sysctl.c                    |   73 +++++++++++++++++++++++++++++++++++
 12 files changed, 244 insertions(+), 39 deletions(-)

Comments, questions, suggestions and bug reports are welcome.
Max
