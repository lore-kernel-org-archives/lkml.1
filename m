Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYJ3VI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYJ3VI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYJ3VIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:08:40 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55878 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbYJ3VIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:08:39 -0400
Subject: [PATCH] fix boot breakage caused by x86: boot secondary cpus
	through initial_code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Glauber Costa <gcosta@redhat.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:08:38 -0500
Message-Id: <1225400918.19324.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 01d1cd30acbcdab745ebc90c73d5fa4a27ce1d5c Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 14:50:04 -0500
Subject: [VOYAGER] make non boot CPUs work again

This commit:

commit 3e9704739daf46a8ba6593d749c67b5f7cd633d2
Author: Glauber Costa <gcosta@redhat.com>
Date:   Wed May 28 13:01:54 2008 -0300

    x86: boot secondary cpus through initial_code

removed the use of initialize_secondary.  However, it didn't update
voyager, so the secondary cpus no longer boot.  Fix this by adding the
initial_code switch to voyager as well.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 0f6e8a6..9cd327a 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -90,6 +90,7 @@ static void ack_vic_irq(unsigned int irq);
 static void vic_enable_cpi(void);
 static void do_boot_cpu(__u8 cpuid);
 static void do_quad_bootstrap(void);
+static void initialize_secondary(void);
 
 int hard_smp_processor_id(void);
 int safe_smp_processor_id(void);
@@ -650,6 +651,8 @@ void __init smp_boot_cpus(void)
 	 smp_tune_scheduling();
 	 */
 	smp_store_cpu_info(boot_cpu_id);
+	/* setup the jump vector */
+	initial_code = (unsigned long)initialize_secondary;
 	printk("CPU%d: ", boot_cpu_id);
 	print_cpu_info(&cpu_data(boot_cpu_id));
 
@@ -702,7 +705,7 @@ void __init smp_boot_cpus(void)
 
 /* Reload the secondary CPUs task structure (this function does not
  * return ) */
-void __init initialize_secondary(void)
+static void __init initialize_secondary(void)
 {
 #if 0
 	// AC kernels only
-- 
1.5.6.5



