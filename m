Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387Ab0AKV1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0AKV1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0AKV1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:45 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35385 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0AKV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=xjsspNgIMc26b8swAnJBIvBMSZAYf2Ici+KJNg572KaOqUUNthwFEN3oIulxKtfQAK
         WifzgatZSxXBVbhsStTYduFbGmbyT8Pqris/5wSL3VGnfDtGvlpl3IICFCFpDMwv0tXv
         vqiQz2p2jzlKdjEJOzdRWvzfChkGb1WKAIRLc=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 22/26] oprofile: Convert to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:52 +0100
Message-Id: <1263245216-14754-23-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-22-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
 <1263245216-14754-21-git-send-email-jkacur@redhat.com>
 <1263245216-14754-22-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks.

See also 0ef0a8e3224c0edfce698beee0ecfc9fca07e9a8

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/arm/oprofile/common.c      |    4 ++--
 arch/x86/oprofile/nmi_int.c     |    4 ++--
 drivers/oprofile/event_buffer.c |    4 ++--
 drivers/oprofile/oprofilefs.c   |    6 +++---
 include/linux/oprofile.h        |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 3fcd752..54a182b 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -48,9 +48,9 @@ static int op_arm_setup(void)
 {
 	int ret;
 
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	ret = op_arm_model->setup_ctrs();
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	return ret;
 }
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cb88b1a..b5796ce 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -321,10 +321,10 @@ static void nmi_cpu_setup(void *dummy)
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 	nmi_cpu_save_registers(msrs);
-	spin_lock(&oprofilefs_lock);
+	raw_spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
 	nmi_cpu_setup_mux(cpu, msrs);
-	spin_unlock(&oprofilefs_lock);
+	raw_spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 5df60a6..9a60ccc 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -82,10 +82,10 @@ int alloc_event_buffer(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	buffer_size = oprofile_buffer_size;
 	buffer_watershed = oprofile_buffer_watershed;
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 2766a6d..049ab37 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -21,7 +21,7 @@
 
 #define OPROFILEFS_MAGIC 0x6f70726f
 
-DEFINE_SPINLOCK(oprofilefs_lock);
+DEFINE_RAW_SPINLOCK(oprofilefs_lock);
 
 static struct inode *oprofilefs_get_inode(struct super_block *sb, int mode)
 {
@@ -75,9 +75,9 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
 	if (copy_from_user(tmpbuf, buf, count))
 		return -EFAULT;
 
-	spin_lock_irqsave(&oprofilefs_lock, flags);
+	raw_spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
-	spin_unlock_irqrestore(&oprofilefs_lock, flags);
+	raw_spin_unlock_irqrestore(&oprofilefs_lock, flags);
 	return 0;
 }
 
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5171639..7d4ed4d 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -156,7 +156,7 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user * buf, size_t co
 int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count);
 
 /** lock for read/write safety */
-extern spinlock_t oprofilefs_lock;
+extern raw_spinlock_t oprofilefs_lock;
 
 /**
  * Add the contents of a circular buffer to the event buffer.
-- 
1.6.5.2

