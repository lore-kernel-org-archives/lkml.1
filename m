Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYGHXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYGHXRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYGHXOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:44 -0400
Received: from gw.goop.org ([64.81.55.164]:51209 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 55] xen: add xen_arch_resume()/xen_timer_resume hook for
	ia64 support
X-Mercurial-Node: 254bec52511004d2b948c3999b5eeb16cf4f80c6
Message-Id: <254bec52511004d2b948.1215554792@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

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
 include/xen/xen-ops.h  |    4 +++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -38,8 +38,11 @@
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
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -37,7 +37,6 @@
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
-void xen_timer_resume(void);
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -68,6 +68,7 @@
 	if (!*cancelled) {
 		xen_irq_resume();
 		xen_console_resume();
+		xen_timer_resume();
 	}
 
 	return 0;
@@ -107,9 +108,10 @@
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
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -11,4 +11,7 @@
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 
+void xen_timer_resume(void);
+void xen_arch_resume(void);
+
 #endif /* INCLUDE_XEN_OPS_H */


