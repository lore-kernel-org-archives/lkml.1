Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbXJQL1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbXJQL1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXJQL1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:27:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56132 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754652AbXJQL1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:27:14 -0400
Date: Wed, 17 Oct 2007 04:27:09 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: ego@in.ibm.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, rusty@rustcorp.com.au,
       dipankar@in.ibm.com, oleg@tv-sign.ru, mingo@elte.hu, paulmck@us.ibm.com
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-Id: <20071017042709.02525cbd.pj@sgi.com>
In-Reply-To: <20071017035327.ff1ed622.pj@sgi.com>
References: <20071016103308.GA9907@in.ibm.com>
	<20071016103417.GA16570@in.ibm.com>
	<20071017035327.ff1ed622.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the following patch, the four cpu hotplug patches by
Gautham R Shenoy boot successfully on my sn2_defconfig ia64
SN2 Altix system.

This patch moves the cpu_hotplug_init() code outside of the
#ifdef CONFIG_HOTPLUG_CPU code.

I will confess to being confused however as to the best way
to handle this.  Having "cpu_hotplug_init" be a piece of code
that has to execute whether or not CONFIG_HOTPLUG_CPU is
enabled doesn't seem right.

Signed-off-by: Paul Jackson <pj@sgi.com>

---

 include/linux/cpu.h |    3 +--
 kernel/cpu.c        |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- 2.6.23-mm1.orig/include/linux/cpu.h	2007-10-17 03:59:59.529623639 -0700
+++ 2.6.23-mm1/include/linux/cpu.h	2007-10-17 04:03:56.257223754 -0700
@@ -83,6 +83,7 @@ static inline void unregister_cpu_notifi
 
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
+extern void cpu_hotplug_init(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
@@ -97,7 +98,6 @@ static inline void cpuhotplug_mutex_unlo
 	mutex_unlock(cpu_hp_mutex);
 }
 
-extern void cpu_hotplug_init(void);
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
@@ -117,7 +117,6 @@ static inline void cpuhotplug_mutex_lock
 static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 { }
 
-#define cpu_hotplug_init()		do { } while (0)
 #define get_online_cpus()		do { } while (0)
 #define put_online_cpus()		do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
--- 2.6.23-mm1.orig/kernel/cpu.c	2007-10-17 03:59:59.873628872 -0700
+++ 2.6.23-mm1/kernel/cpu.c	2007-10-17 04:04:52.522079165 -0700
@@ -38,8 +38,6 @@ static struct {
 
 #define writer_exists() (cpu_hotplug.active_writer != NULL)
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
@@ -48,6 +46,8 @@ void __init cpu_hotplug_init(void)
 	init_completion(&cpu_hotplug.readers_done);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 void get_online_cpus(void)
 {
 	might_sleep();


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
