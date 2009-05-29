Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZE2Icz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZE2Icz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZE2Ics
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:32:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZE2Icr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:32:47 -0400
Message-ID: <4A1F9CEE.5090305@cn.fujitsu.com>
Date: Fri, 29 May 2009 16:29:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cpuhotplug: introduce try_get_online_cpus()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


get_online_cpus() is a typically coarsely granular lock.
It's a source of ABBA deadlock.

Thanks to the CPU notifiers, Some subsystem's global lock will
be required after cpu_hotplug.rwlock. Subsystem's global lock
is coarsely granular lock too, thus a lot's of lock in kernel
should be required after cpu_hotplug.rwlock(if we need
cpu_hotplug.rwlock held too)

Otherwise it may come to a ABBA deadlock like this:

thread 1                                      |        thread 2
_cpu_down()                                   |  Lock a-kernel-lock.
  cpu_hotplug_begin()                         |
    down_write(&cpu_hotplug.rwlock)           |
  __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
------------------------------------------------------------------------
    Lock a-kernel-lock.(wait thread2)         |    down_read(&cpu_hotplug.rwlock)
                                                   (wait thread 1)

But CPU online/offline are happened very rarely, get_online_cpus()
returns success quickly in all probability.
So it's an asinine behavior that get_online_cpus() is not allowed
to be required after we had held "a-kernel-lock".

To dispel the ABBA deadlock, this patch introduces
try_get_online_cpus(). It returns fail very rarely. It gives the
caller a chance to select an alternative way to finish works,
instead of sleeping or deadlock.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2643d84..98f5c4b 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -104,6 +104,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern int try_get_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -117,6 +118,7 @@ int cpu_down(unsigned int cpu);
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define try_get_online_cpus()	(1)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 62198ec..e948f19 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -66,6 +66,15 @@ void put_online_cpus(void)
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
+int try_get_online_cpus(void)
+{
+	might_sleep();
+	if (cpu_hotplug.active_writer == current)
+		return 1;
+	return down_read_trylock(&cpu_hotplug.rwlock);
+
+}
+EXPORT_SYMBOL_GPL(try_get_online_cpus);
 #endif	/* CONFIG_HOTPLUG_CPU */
 
 /*





