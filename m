Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZBGHkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZBGHkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZBGHjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:39:49 -0500
Received: from ozlabs.org ([203.10.76.45]:48289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZBGHjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:39:48 -0500
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Yinghai Lu <yinghai@kernel.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 7 Feb 2009 18:09:38 +1030
Subject: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
Cc: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071809.39175.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix powernow-k8 when acpi=off (or other error).

There was a spurious change introduced into powernow-k8 in this patch:
the cause if that we try to "restore" the cpus_allowed we never saved.

See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
acpi=off" from Yinghai for the bug report.

Cc: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1142,8 +1142,7 @@ static int __cpuinit powernowk8_cpu_init
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
 
-	rc = powernow_k8_cpu_init_acpi(data);
-	if (rc) {
+	if (powernow_k8_cpu_init_acpi(data)) {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
@@ -1161,17 +1160,20 @@ static int __cpuinit powernowk8_cpu_init
 			       "ACPI maintainers and complain to your BIOS "
 			       "vendor.\n");
 #endif
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		if (pol->cpu != 0) {
 			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
 			       "CPU other than CPU0. Complain to your BIOS "
 			       "vendor.\n");
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		rc = find_psb_table(data);
 		if (rc) {
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 	}
 

