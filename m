Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZFWCaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZFWCaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZFWC3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:29:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbZFWC3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:29:49 -0400
Date: Mon, 22 Jun 2009 19:29:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
In-Reply-To: <1245717089.4017.18.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0906221927280.3240@localhost.localdomain>
References: <1245717089.4017.18.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:

> +	/*
> +	 * This initializes the mutex used by get/put_online_cpus()
> +	 * which is used by SLAB
> +	 */
> +	cpu_hotplug_init();

Oh fudge it.

Why not get rid of that stupid thing, rather than have that subtle 
dependency and a comment for it.

IOW, does this simpler alternative also work?

When given the choice of simplifying and removing code, always do so. 

Static initializers are much nicer than having to worry about when 
something gets initialized, no?

		Linus

---
 include/linux/cpu.h |    5 -----
 init/main.c         |    1 -
 kernel/cpu.c        |   13 +++++--------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2643d84..4d668e0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -69,7 +69,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
-extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
@@ -84,10 +83,6 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
 
-static inline void cpu_hotplug_init(void)
-{
-}
-
 static inline void cpu_maps_update_begin(void)
 {
 }
diff --git a/init/main.c b/init/main.c
index 09131ec..4870dfe 100644
--- a/init/main.c
+++ b/init/main.c
@@ -678,7 +678,6 @@ asmlinkage void __init start_kernel(void)
 #endif
 	page_cgroup_init();
 	enable_debug_pagealloc();
-	cpu_hotplug_init();
 	kmemtrace_init();
 	kmemleak_init();
 	debug_objects_mem_init();
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 395b697..8ce1004 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -34,14 +34,11 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-} cpu_hotplug;
-
-void __init cpu_hotplug_init(void)
-{
-	cpu_hotplug.active_writer = NULL;
-	mutex_init(&cpu_hotplug.lock);
-	cpu_hotplug.refcount = 0;
-}
+} cpu_hotplug = {
+	.active_writer = NULL,
+	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
+	.refcount = 0,
+};
 
 #ifdef CONFIG_HOTPLUG_CPU
 
