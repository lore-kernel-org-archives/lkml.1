Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394Ab0AKVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0AKVa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285Ab0AKVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:30:54 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0AKV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SV94dHWoxT7CxwHabvD9Df+oHG3w2eAkSF7qqglwno99mQP+eJuAUUbiFeO8B8+8uX
         /+WgqSAjSCRbmio6R4NwKmwIglfZpGtxg4wLU+G6N10UWtR2KQXZxBmFDNvlFt+2tv5u
         42FVro3Np+d2cMcFi4s1atmqyxJ8zVIvwGevI=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 10/26] ACPI: Convert c3_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:40 +0100
Message-Id: <1263245216-14754-11-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-10-git-send-email-jkacur@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep under preempt-rt to raw_spinlocks

See also 50fee3b3ad7cd773f0b50739bb0ed9ac43561c7d

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/acpi/processor_idle.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d1676b1..42b30d0 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -929,7 +929,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 }
 
 static int c3_cpu_count;
-static DEFINE_SPINLOCK(c3_lock);
+static DEFINE_RAW_SPINLOCK(c3_lock);
 
 /**
  * acpi_idle_enter_bm - enters C3 with proper BM handling
@@ -1004,12 +1004,12 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 * without doing anything.
 	 */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
-		spin_lock(&c3_lock);
+		raw_spin_lock(&c3_lock);
 		c3_cpu_count++;
 		/* Disable bus master arbitration when all CPUs are in C3 */
 		if (c3_cpu_count == num_online_cpus())
 			acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 1);
-		spin_unlock(&c3_lock);
+		raw_spin_unlock(&c3_lock);
 	} else if (!pr->flags.bm_check) {
 		ACPI_FLUSH_CPU_CACHE();
 	}
@@ -1018,10 +1018,10 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	/* Re-enable bus master arbitration */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
-		spin_lock(&c3_lock);
+		raw_spin_lock(&c3_lock);
 		acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 0);
 		c3_cpu_count--;
-		spin_unlock(&c3_lock);
+		raw_spin_unlock(&c3_lock);
 	}
 	kt2 = ktime_get_real();
 	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
-- 
1.6.5.2

