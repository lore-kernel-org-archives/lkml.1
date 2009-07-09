Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZGIHRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZGIHRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZGIHRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:17:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60386 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZGIHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:17:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A55997E.8020903@jp.fujitsu.com>
Date: Thu, 09 Jul 2009 16:17:18 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org, "Luck, Tony" <tony.luck@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: [PATCH v2 6/7] ia64, kdump: Try INIT regardless of kdump_on_init
References: <4A39E247.4030908@jp.fujitsu.com> <4A5595F3.2050609@jp.fujitsu.com>
In-Reply-To: <4A5595F3.2050609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUs should be frozen if possible, otherwise it might hinder kdump.
So if there are CPUs not respond to IPI, try INIT to stop them.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: kexec@lists.infradead.org
---
 arch/ia64/kernel/crash.c |   43 +++++++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 9c851b7..0995fdc 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -138,8 +138,10 @@ machine_crash_shutdown(struct pt_regs *pt)
 	 */
 	kdump_smp_send_stop();
 	/* not all cpu response to IPI, send INIT to freeze them */
-	if (kdump_wait_cpu_freeze() && kdump_on_init) 	{
+	if (kdump_wait_cpu_freeze()) {
 		kdump_smp_send_init();
+		/* wait again, don't go ahead if possible */
+		kdump_wait_cpu_freeze();
 	}
 #endif
 }
@@ -178,6 +180,19 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 	struct ia64_mca_notify_die *nd;
 	struct die_args *args = data;
 
+	if (atomic_read(&kdump_in_progress)) {
+		switch (val) {
+		case DIE_INIT_MONARCH_LEAVE:
+			if (!kdump_freeze_monarch)
+				break;
+			/* fall through */
+		case DIE_INIT_SLAVE_LEAVE:
+		case DIE_MCA_RENDZVOUS_LEAVE:
+			unw_init_running(kdump_cpu_freeze, NULL);
+			break;
+		}
+	}
+
 	if (!kdump_on_init && !kdump_on_fatal_mca)
 		return NOTIFY_DONE;
 
@@ -190,41 +205,25 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 	}
 
 	if (val != DIE_INIT_MONARCH_LEAVE &&
-	    val != DIE_INIT_SLAVE_LEAVE &&
 	    val != DIE_INIT_MONARCH_PROCESS &&
-	    val != DIE_MCA_RENDZVOUS_LEAVE &&
 	    val != DIE_MCA_MONARCH_LEAVE)
 		return NOTIFY_DONE;
 
 	nd = (struct ia64_mca_notify_die *)args->err;
-	/* Reason code 1 means machine check rendezvous*/
-	if ((val == DIE_INIT_MONARCH_LEAVE || val == DIE_INIT_SLAVE_LEAVE
-	    || val == DIE_INIT_MONARCH_PROCESS) && nd->sos->rv_rc == 1)
-		return NOTIFY_DONE;
 
 	switch (val) {
 	case DIE_INIT_MONARCH_PROCESS:
-		if (kdump_on_init) {
+		/* Reason code 1 means machine check rendezvous*/
+		if (kdump_on_init && (nd->sos->rv_rc != 1)) {
 			if (atomic_inc_return(&kdump_in_progress) != 1)
 				kdump_freeze_monarch = 1;
 			*(nd->monarch_cpu) = -1;
 		}
 		break;
 	case DIE_INIT_MONARCH_LEAVE:
-		if (kdump_on_init) {
-			if (kdump_freeze_monarch)
-				unw_init_running(kdump_cpu_freeze, NULL);
-			else
-				machine_kdump_on_init();
-		}
-		break;
-	case DIE_INIT_SLAVE_LEAVE:
-		if (atomic_read(&kdump_in_progress))
-			unw_init_running(kdump_cpu_freeze, NULL);
-		break;
-	case DIE_MCA_RENDZVOUS_LEAVE:
-		if (atomic_read(&kdump_in_progress))
-			unw_init_running(kdump_cpu_freeze, NULL);
+		/* Reason code 1 means machine check rendezvous*/
+		if (kdump_on_init && (nd->sos->rv_rc != 1))
+			machine_kdump_on_init();
 		break;
 	case DIE_MCA_MONARCH_LEAVE:
 		/* *(nd->data) indicate if MCA is recoverable */
-- 
1.6.0


