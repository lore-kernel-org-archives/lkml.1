Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZFRGvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZFRGvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbZFRGu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:50:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33246 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476AbZFRGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:50:57 -0400
Message-ID: <4A39E3C9.2040906@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 15:50:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: [PATCH 5/7] ia64, kdump: Mask INIT first in panic-kdump path
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for races on Panic and INIT.

Asserting INIT might not invoke 2nd kdump if the system is going to start
1st kdump via panic and some of cpus are already playing dead with INIT
masked.  It can be assumed that an internal agent decides to panic the
unstable system while another external agent decides to send an INIT to
the system at same time.

So mask INIT first in panic path to take the initiative on kdump.
All INITs later should be used only for freezing all other cpus.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/kernel/crash.c |   47 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index eacedfc..1440445 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -23,6 +23,7 @@
 int kdump_status[NR_CPUS];
 static atomic_t kdump_cpu_frozen;
 atomic_t kdump_in_progress;
+static int kdump_freeze_monarch;
 static int kdump_on_init = 1;
 static int kdump_on_fatal_mca = 1;
 
@@ -110,6 +111,33 @@ machine_crash_shutdown(struct pt_regs *pt)
 	 */
 	kexec_disable_iosapic();
 #ifdef CONFIG_SMP
+	/*
+	 * If kdump_on_init is set and an INIT is assered here, kdump will
+	 * be started again via INIT monarch.
+	 */
+	local_irq_disable();
+	ia64_set_psr_mc();	/* mask MCA/INIT */
+	if (atomic_inc_return(&kdump_in_progress) != 1)
+		unw_init_running(kdump_cpu_freeze, NULL);		
+
+	/*
+	 * Now this cpu is ready for kdump.
+	 * Stop all others by IPI or INIT.  They could receive INIT from
+	 * outside and might be INIT monarch, but only thing they have to
+	 * do is falling into kdump_cpu_freeze().
+	 *
+	 * If an INIT is asserted here:
+	 * - All receivers might be slaves, since some of cpus could already
+	 *   be frozen and INIT might be masked on monarch.  In this case,
+	 *   all slaves will park in while (monarch_cpu == -1) loop before
+	 *   DIE_INIT_SLAVE_ENTER that for waiting monarch enters.
+	 *	=> TBD: freeze all slaves
+	 * - One might be a monarch, but INIT rendezvous will fail since
+	 *   at least this cpu already have INIT masked so it never join
+	 *   to the rendezvous.  In this case, all slaves and monarch will
+	 *   be frozen after timeout of the INIT rendezvous.
+	 *	=> TBD: freeze them without waiting timeout
+	 */
 	kdump_smp_send_stop();
 	/* not all cpu response to IPI, send INIT to freeze them */
 	if (kdump_wait_cpu_freeze() && kdump_on_init) 	{
@@ -179,13 +207,18 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 	switch (val) {
 	case DIE_INIT_MONARCH_PROCESS:
 		if (kdump_on_init) {
-			atomic_set(&kdump_in_progress, 1);
+			if (atomic_inc_return(&kdump_in_progress) != 1)
+				kdump_freeze_monarch = 1;
 			*(nd->monarch_cpu) = -1;
 		}
 		break;
 	case DIE_INIT_MONARCH_LEAVE:
-		if (kdump_on_init)
-			machine_kdump_on_init();
+		if (kdump_on_init) {
+			if (kdump_freeze_monarch)
+				unw_init_running(kdump_cpu_freeze, NULL);
+			else
+				machine_kdump_on_init();
+		}
 		break;
 	case DIE_INIT_SLAVE_LEAVE:
 		if (atomic_read(&kdump_in_progress))
@@ -198,9 +231,11 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 	case DIE_MCA_MONARCH_LEAVE:
 		/* *(nd->data) indicate if MCA is recoverable */
 		if (kdump_on_fatal_mca && !(*(nd->data))) {
-			atomic_set(&kdump_in_progress, 1);
-			*(nd->monarch_cpu) = -1;
-			machine_kdump_on_init();
+			if (atomic_inc_return(&kdump_in_progress) == 1) {
+				*(nd->monarch_cpu) = -1;
+				machine_kdump_on_init();
+			}
+			/* We got fatal MCA while kdump!? No way!! */
 		}
 		break;
 	}
-- 
1.6.0


