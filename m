Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbXL3HMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbXL3HMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXL3HKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:59470 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbXL3HKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 04/52] KVM: Replace 'light_exits' stat with 'host_state_reload'
Date: Sun, 30 Dec 2007 09:09:50 +0200
Message-Id: <1198998638-22713-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a little more accurate (since it counts actual reloads, not potential
reloads), and reverses the sense of the statistic to measure a bad event like
most of the other stats (e.g. we want to minimize all counters).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 +-
 drivers/kvm/svm.c |    1 +
 drivers/kvm/vmx.c |    1 +
 drivers/kvm/x86.c |    6 ++----
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 59e001c..04efe88 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -246,7 +246,7 @@ struct kvm_stat {
 	u32 halt_wakeup;
 	u32 request_irq_exits;
 	u32 irq_exits;
-	u32 light_exits;
+	u32 host_state_reload;
 	u32 efer_reload;
 };
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 762302a..94c51a0 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -654,6 +654,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int i;
 
+	++vcpu->stat.host_state_reload;
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 30220ea..4e60cf9 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -463,6 +463,7 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
 	if (!vmx->host_state.loaded)
 		return;
 
+	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
 	if (vmx->host_state.fs_reload_needed)
 		load_fs(vmx->host_state.fs_sel);
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index b7c72ac..923dfd4 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -60,7 +60,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "halt_wakeup", STAT_OFFSET(halt_wakeup) },
 	{ "request_irq", STAT_OFFSET(request_irq_exits) },
 	{ "irq_exits", STAT_OFFSET(irq_exits) },
-	{ "light_exits", STAT_OFFSET(light_exits) },
+	{ "host_state_reload", STAT_OFFSET(host_state_reload) },
 	{ "efer_reload", STAT_OFFSET(efer_reload) },
 	{ NULL }
 };
@@ -1988,10 +1988,8 @@ again:
 			++vcpu->stat.request_irq_exits;
 			goto out;
 		}
-		if (!need_resched()) {
-			++vcpu->stat.light_exits;
+		if (!need_resched())
 			goto again;
-		}
 	}
 
 out:
-- 
1.5.3.7

