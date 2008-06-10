Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYFJHkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYFJHkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYFJHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:40:44 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54504 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750859AbYFJHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:40:44 -0400
Date: Tue, 10 Jun 2008 16:40:42 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com, xen-devel@lists.xensource.com
Subject: [PATCH] xen: add xen_arch_resume()/xen_timer_resume hook for ia64 support.
Message-ID: <20080610074042.GI24381%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add xen_timer_resume() hook.
Timer resume should be done after event channel is resumed.
add xen_arch_resume() hook when ipi becomes usable after resume.
After resume, some cpu specific resource must be reinitialized
on ia64 that can't be set by another cpu.
However available hooks is run once on only one cpu so that ipi has
to be used.
During stop_machine_run() ipi can't be used because interrupt is masked.
So add another hook after stop_machine_run().
Another approach might be use resume hook which is run by
device_resume(). However device_resume() may be executed on
suspend error recovery path. So it is necessary to determine
whether it is executed on real resume path or error recovery path.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/suspend.c |    5 ++++-
 arch/x86/xen/xen-ops.h |    1 -
 drivers/xen/manage.c   |    6 ++++--
 include/xen/xen-ops.h  |    3 +++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 251669a..2a234db 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -38,8 +38,11 @@ void xen_post_suspend(int suspend_cancelled)
 		xen_cpu_initialized_map = cpu_online_map;
 #endif
 		xen_vcpu_restore();
-		xen_timer_resume();
 	}
 
 }
 
+void xen_arch_resume(void)
+{
+	/* nothing */
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9a05559..a457e03 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -37,7 +37,6 @@ void __init xen_time_init(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
-void xen_timer_resume(void);
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index db3c4bd..e8db90c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -66,6 +66,7 @@ static int xen_suspend(void *data)
 	if (!*cancelled) {
 		xen_irq_resume();
 		xen_console_resume();
+		xen_timer_resume();
 	}
 
 	return 0;
@@ -105,9 +106,10 @@ static void do_suspend(void)
 		goto out;
 	}
 
-	if (!cancelled)
+	if (!cancelled) {
+		xen_arch_resume();
 		xenbus_resume();
-	else
+	} else
 		xenbus_suspend_cancel();
 
 	device_resume();
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index a706d6a..883a21b 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -11,4 +11,7 @@ void xen_post_suspend(int suspend_cancelled);
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 
+void xen_timer_resume(void);
+void xen_arch_resume(void);
+
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.5.3

