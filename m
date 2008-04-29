Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYD2NES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYD2NES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYD2NEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:04:05 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58657 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYD2NEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:04:02 -0400
Date: Tue, 29 Apr 2008 18:33:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH 7/8] cpu_hotplug: Introduce try_get_online_cpus()
Message-ID: <20080429130357.GH23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_hotplug: Introduce try_get_online_cpus()

From: Gautham R Shenoy <ego@in.ibm.com>

Subsystems such as workqueues currently cannot use get_online_cpus()
since they deadlock with the workqueue CPU-Hotplug callback code.

For such cases, introduce a new API try_get_online_cpus() which
returns 0 when a cpu-hotplug operation is in progress. It behaves
like get_online_cpus() and returns 1 otherwise.

Based on the status of CPU-Hotplug, the subsystems can take appropriate
action.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/cpu.h |    2 ++
 kernel/cpu.c        |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..d0be341 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -107,6 +107,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 }
 
 extern void get_online_cpus(void);
+extern int try_get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
@@ -126,6 +127,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+static inline int try_get_online_cpus(void) { return 1; }
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8f1718f..52c1e4e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -57,7 +57,29 @@ void __init cpu_hotplug_init(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+int try_get_online_cpus(void)
+{
+	spin_lock(&cpu_hotplug.lock);
+	if (cpu_hotplug.active_writer == current)
+		goto out_unlock;
+
+	if (likely(!cpu_hotplug.active_writer))
+		goto out_success;
+
+	if (cpu_hotplug.refcount)
+		goto out_success;
+
+	spin_unlock(&cpu_hotplug.lock);
+	return 0;
+
+out_success:
+	cpu_hotplug.refcount++;
+out_unlock:
+	spin_unlock(&cpu_hotplug.lock);
+	cpu_hotplug_acquire_read(&cpu_hotplug.dep_map, 0, 1, _THIS_IP_);
+	return 1;
 
+}
 void get_online_cpus(void)
 {
 	might_sleep();
-- 
Thanks and Regards
gautham
