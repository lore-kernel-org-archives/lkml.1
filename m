Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYGBIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYGBIeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYGBIeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:34:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbYGBIeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:34:09 -0400
Date: Wed, 2 Jul 2008 01:31:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: make get_online_cpus() useable for
 work->func()
Message-Id: <20080702013147.126feb34.akpm@linux-foundation.org>
In-Reply-To: <20080629165131.GA11215@tv-sign.ru>
References: <20080629165131.GA11215@tv-sign.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 20:51:31 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:

> workqueue_cpu_callback(CPU_DEAD) flushes cwq->thread under
> cpu_maps_update_begin(). This means that the multithreaded workqueues can't
> use get_online_cpus() due to the possible deadlock, very bad and very old
> problem.
> 
> Introduce the new state, CPU_POST_DEAD, which is called after
> cpu_hotplug_done() but before cpu_maps_update_done().
> 
> Change workqueue_cpu_callback() to use CPU_POST_DEAD instead of CPU_DEAD.
> This means that create/destroy functions can't rely on get_online_cpus()
> any longer and should take cpu_add_remove_lock instead.

I know that Document/SubmitChecklist has a lot of stuff.  But a basic
allnoconfig only takes seconds and it's often the thing which breaks.

 include/linux/cpu.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix include/linux/cpu.h
--- a/include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix
+++ a/include/linux/cpu.h
@@ -69,10 +69,11 @@ static inline void unregister_cpu_notifi
 #endif
 
 int cpu_up(unsigned int cpu);
-
 extern void cpu_hotplug_init(void);
+extern void cpu_maps_update_begin(void);
+extern void cpu_maps_update_done(void);
 
-#else
+#else	/* CONFIG_SMP */
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
@@ -87,10 +88,16 @@ static inline void cpu_hotplug_init(void
 {
 }
 
+static inline void cpu_maps_update_begin(void)
+{
+}
+
+static inline void cpu_maps_update_done(void)
+{
+}
+
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
-extern void cpu_maps_update_begin(void);
-extern void cpu_maps_update_done(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
_

