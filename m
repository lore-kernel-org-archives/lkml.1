Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYCCRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYCCRaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYCCRQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbYCCRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:08 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 18/52] provide __smp_call_function
Date: Mon,  3 Mar 2008 14:12:46 -0300
Message-Id: <1204564400-17636-19-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-18-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used in smp_send_stop(). It's like
smp_call_function_mask, but always go to all online cpus,
and does not take any locks.

It is added to x86_64, but will soon be unified in a common file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 1d8b863..aa2edb7 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -322,6 +322,38 @@ void unlock_ipi_call_lock(void)
 	spin_unlock_irq(&call_lock);
 }
 
+static void __smp_call_function(void (*func) (void *info), void *info,
+				int nonatomic, int wait)
+{
+	struct call_data_struct data;
+	int cpus = num_online_cpus() - 1;
+
+	if (!cpus)
+		return;
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+}
+
+
 /*
  * this function sends a 'generic call function' IPI to all other CPU
  * of the system defined in the mask.
@@ -424,7 +456,7 @@ void smp_send_stop(void)
 	/* Don't deadlock on the call lock in panic */
 	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
-	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
+	__smp_call_function(stop_this_cpu, NULL, 0, 0);
 	if (!nolock)
 		spin_unlock(&call_lock);
 	disable_local_APIC();
-- 
1.5.0.6

