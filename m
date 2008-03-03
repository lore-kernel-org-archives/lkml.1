Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYCCR3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYCCR3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYCCRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760019AbYCCRQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:03 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 23/52] unify smp_send_stop
Date: Mon,  3 Mar 2008 14:12:51 -0300
Message-Id: <1204564400-17636-24-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-23-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function definition is moved to common header.
x86_64 version is now called native_smp_send_stop

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |    3 ++-
 include/asm-x86/smp.h    |    5 +++++
 include/asm-x86/smp_32.h |    5 -----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 4e1e2bc..ad11ef0 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -421,7 +421,7 @@ static void stop_this_cpu(void *dummy)
 	for (;;);
 }
 
-void smp_send_stop(void)
+void native_smp_send_stop(void)
 {
 	int nolock;
 	unsigned long flags;
@@ -482,6 +482,7 @@ struct smp_ops smp_ops = {
 	.smp_prepare_cpus = native_smp_prepare_cpus,
 	.smp_cpus_done = native_smp_cpus_done,
 
+	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 	.cpu_up = native_cpu_up,
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 28cb1f8..2ab8ed4 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -25,6 +25,11 @@ struct smp_ops {
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
+static inline void smp_send_stop(void)
+{
+	smp_ops.smp_send_stop();
+}
+
 static inline void smp_prepare_boot_cpu(void)
 {
 	smp_ops.smp_prepare_boot_cpu();
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index bc90a4e..41b58e0 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -39,11 +39,6 @@ extern void remove_siblinginfo(int cpu);
 extern void set_cpu_sibling_map(int cpu);
 
 #ifdef CONFIG_SMP
-static inline void smp_send_stop(void)
-{
-	smp_ops.smp_send_stop();
-}
-
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
 #endif
-- 
1.5.0.6

