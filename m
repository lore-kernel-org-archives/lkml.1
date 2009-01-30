Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZA3BlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZA3BlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZA3Bk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:40:56 -0500
Received: from ozlabs.org ([203.10.76.45]:60422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZA3Bkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:40:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/powernow: fix cpus_allowed brokage when acpi=off
Date: Fri, 30 Jan 2009 12:10:47 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Mike Travis <travis@sgi.com>
References: <498136FC.2020206@kernel.org>
In-Reply-To: <498136FC.2020206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301210.48352.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 15:26:28 Yinghai Lu wrote:
> 
> Impact: fix current->cpus_allowed overwriting.
...
> caused by
> | commit 2fdf66b491ac706657946442789ec644cc317e1a
> | Author: Rusty Russell <rusty@rustcorp.com.au>
> | Date:   Wed Dec 31 18:08:47 2008 -0800
> |
> |    cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t

Hi Yinghai!

   Indeed; Mike, that contained a bad conversion of 
arch/x86/kernel/cpu/cpufreq/powernow-k8.c.

   This patch reverts the bad change (this code should still be converted
to work_on_cpu of course, but that's a bigger change).

   Yinghai, as far as I can tell your other fixes are independent (and
were a problem before this commit, yes?).  Can you re-submit them on top
of this patch (which is for Ingo, but against latest Linus).

Subject: cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a

Impact: fix powernow-k8 when acpi=off (or other error).

There was a spurious change introduced into powernow-k8 in this patch:
the cause if that we try to "restore" the cpus_allowed we never saved.

See lkml "[PATCH] x86/powernow: fix cpus_allowed brokage when
acpi=off" from Yinghai for the bug report.

Cc: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
 
