Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXHXS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXHXS6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761706AbXHXS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:57:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57147 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760996AbXHXS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:57:54 -0400
Date: Sat, 25 Aug 2007 00:40:49 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs
Message-ID: <alpine.LFD.0.999.0708250037400.19678@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

As discussed just now, please drop:
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
and apply the patch below instead.

Satyam


[PATCH] Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs

The return of the present "do {} while" based stub definition of
register_hotcpu_notifier() cannot be checked. This makes the stub
asymmetric w.r.t. the real HOTPLUG_CPU=y implementation that is
int-returning. So let us redefine this to be consistent with the
full version. Also do the same for unregister_hotcpu_notifier().

We cannot define these as static inline functions due to an existing
GCC bug (#33172). So define as macros that return appropriately
instead (int '0' for the register_hotcpu_notifier case and void for
unregister_hotcpu_notifier).

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/linux/cpu.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 1d5ded0..2ffcef5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -119,8 +119,9 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+/* These aren't inline functions due to a GCC bug. */
+#define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
+#define unregister_hotcpu_notifier(nb)	({ (void)(nb); })
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
