Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYHATIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYHATIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYHATIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:08:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55240 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbYHATIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:08:12 -0400
Subject: Re: [PATCH 2/6] Container Freezer: Make refrigerator always
	available
From: Matt Helsley <matthltc@us.ibm.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Michael Opdenacker <michael@free-electrons.com>,
       linux-embedded@vger.kernel.org
In-Reply-To: <20080801162712.63721e8c@surf>
References: <20080801050659.924495279@us.ibm.com>
	 <20080801050700.528446138@us.ibm.com>  <20080801162712.63721e8c@surf>
Content-Type: text/plain; charset=UTF-7
Organization: IBM Linux Technology Center
Date: Fri, 01 Aug 2008 12:08:09 -0700
Message-Id: <1217617689.25300.213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-01 at 16:27 +-0200, Thomas Petazzoni wrote:
+AD4 Hi,
+AD4 
+AD4 Le Thu, 31 Jul 2008 22:07:01 -0700,
+AD4 Matt Helsley +ADw-matthltc+AEA-us.ibm.com+AD4 a +AOk-crit :
+AD4 
+AD4 +AD4 --- a/kernel/Makefile
+AD4 +AD4 +-+-+- b/kernel/Makefile
+AD4 +AD4 +AEAAQA -5,7 +-5,7 +AEAAQA
+AD4 +AD4  obj-y     +AD0 sched.o fork.o exec+AF8-domain.o panic.o printk.o +AFw
+AD4 +AD4  	    cpu.o exit.o itimer.o time.o softirq.o resource.o +AFw
+AD4 +AD4  	    sysctl.o capability.o ptrace.o timer.o user.o +AFw
+AD4 +AD4 -	    signal.o sys.o kmod.o workqueue.o pid.o +AFw
+AD4 +AD4 +-	    signal.o sys.o kmod.o workqueue.o pid.o freezer.o +AFw
+AD4 
+AD4 I have the impression that the code in kernel/power/process.c was
+AD4 compiled only if CONFIG+AF8-PM+AF8-SLEEP was set. Now that the code has been
+AD4 moved to kernel/freezer.c, it is unconditionnaly compiled in every
+AD4 kernel. Is that correct ?
+AD4
+AD4 If so, is it possible to put this new feature under some
+AD4 CONFIG+AF8-SOMETHING option, for people who care about the kernel size ?

	How about making it depend on a combination of CONFIG variables?
Here's an RFC PATCH. Completely untested.

Signed-off-by: Matt Helsley +ADw-matthltc+AEA-us.ibm.com+AD4
---
 kernel/Makefile      +AHw    3 +-+--
 kernel/power/Kconfig +AHw    3 +-+-+-
 2 files changed, 5 insertions(+-), 1 deletion(-)

Index: linux-2.6.27-rc1-mm1/kernel/Makefile
+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0
--- linux-2.6.27-rc1-mm1.orig/kernel/Makefile
+-+-+- linux-2.6.27-rc1-mm1/kernel/Makefile
+AEAAQA -5,7 +-5,7 +AEAAQA
 obj-y     +AD0 sched.o fork.o exec+AF8-domain.o panic.o printk.o +AFw
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o +AFw
 	    sysctl.o capability.o ptrace.o timer.o user.o +AFw
-	    signal.o sys.o kmod.o workqueue.o pid.o freezer.o +AFw
+-	    signal.o sys.o kmod.o workqueue.o pid.o +AFw
 	    rcupdate.o extable.o params.o posix-timers.o +AFw
 	    kthread.o wait.o kfifo.o sys+AF8-ni.o posix-cpu-timers.o mutex.o +AFw
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o +AFw
+AEAAQA -24,6 +-24,7 +AEAAQA CFLAGS+AF8-REMOVE+AF8-sched+AF8-clock.o +AD0 -pg
 CFLAGS+AF8-REMOVE+AF8-sched.o +AD0 -mno-spe -pg
 endif
 
+-obj-+ACQ(CONFIG+AF8-FREEZER) +-+AD0 freezer.o
 obj-+ACQ(CONFIG+AF8-PROFILING) +-+AD0 profile.o
 obj-+ACQ(CONFIG+AF8-SYSCTL+AF8-SYSCALL+AF8-CHECK) +-+AD0 sysctl+AF8-check.o
 obj-+ACQ(CONFIG+AF8-STACKTRACE) +-+AD0 stacktrace.o
Index: linux-2.6.27-rc1-mm1/kernel/power/Kconfig
+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0
--- linux-2.6.27-rc1-mm1.orig/kernel/power/Kconfig
+-+-+- linux-2.6.27-rc1-mm1/kernel/power/Kconfig
+AEAAQA -85,6 +-85,9 +AEAAQA config PM+AF8-SLEEP
 	depends on SUSPEND +AHwAfA HIBERNATION +AHwAfA XEN+AF8-SAVE+AF8-RESTORE
 	default y
 
+-config FREEZER
+-	def+AF8-bool PM+AF8-SLEEP +AHwAfA CGROUP+AF8-FREEZER
+-
 config SUSPEND
 	bool +ACI-Suspend to RAM and standby+ACI
 	depends on PM +ACYAJg ARCH+AF8-SUSPEND+AF8-POSSIBLE



