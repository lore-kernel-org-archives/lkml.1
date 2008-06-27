Return-Path: <linux-kernel-owner+w=401wt.eu-S1764539AbYF0Vkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764539AbYF0Vkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764195AbYF0Vha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764208AbYF0VhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:16 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 04/39] explicitly use edx in const delay function.
Date: Fri, 27 Jun 2008 18:34:11 -0300
Message-Id: <1214602486-17080-5-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-4-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86_64, we can't just use %0, as it would
generate a mul against rdx, which is not really what we
want (note the ">> 32" in x86_64 version).

Using a u64 variable with a shift in i386 generates bad code,
so the solution is to explicitly use %%edx in inline assembly
for both.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/delay_32.c |    2 +-
 arch/x86/lib/delay_64.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index bf6de05..0b659a3 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -114,7 +114,7 @@ inline void __const_udelay(unsigned long xloops)
 	int d0;
 
 	xloops *= 4;
-	__asm__("mull %0"
+	__asm__("mull %%edx"
 		:"=d" (xloops), "=&a" (d0)
 		:"1" (xloops), "0"
 		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
index d0326d0..ff3dfec 100644
--- a/arch/x86/lib/delay_64.c
+++ b/arch/x86/lib/delay_64.c
@@ -103,9 +103,16 @@ EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
 {
-	__delay(((xloops * HZ *
-		cpu_data(raw_smp_processor_id()).loops_per_jiffy) >> 32) + 1);
+	int d0;
+	xloops *= 4;
+	__asm__("mull %%edx"
+		:"=d" (xloops), "=&a" (d0)
+		:"1" (xloops), "0"
+		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
+
+	__delay(++xloops);
 }
+
 EXPORT_SYMBOL(__const_udelay);
 
 void __udelay(unsigned long usecs)
-- 
1.5.5.1

