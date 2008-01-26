Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYAZWMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYAZWMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYAZWLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41513 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbYAZWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in acpi/boot.c
Date: Sat, 26 Jan 2008 23:11:51 +0100
Message-Id: <1201385513-26885-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/built-in.o(.text+0x10ea0): Section mismatch: reference to .cpuinit.data:num_processors in 'acpi_unmap_lsapic'

The exported function acpi_unmap_lsapic() references
the variable num_processors that is annotated __cpuinitdata.

Remove the annotation of num_processors as we never know
when an exported function are called.
And drop the needless initialsation to 0.

Warning was seen on 64 bit but similar pattern were seen
in 32 bit - so fix it up there too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/mpparse_32.c |    2 +-
 arch/x86/kernel/mpparse_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index cc06eae..67009cd 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -68,7 +68,7 @@ unsigned int def_to_bigsmp = 0;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 /* Internal processor count */
-unsigned int __cpuinitdata num_processors;
+unsigned int num_processors;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
diff --git a/arch/x86/kernel/mpparse_64.c b/arch/x86/kernel/mpparse_64.c
index d3260f8..72ab140 100644
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -60,7 +60,7 @@ unsigned int boot_cpu_id = -1U;
 EXPORT_SYMBOL(boot_cpu_id);
 
 /* Internal processor count */
-unsigned int num_processors __cpuinitdata = 0;
+unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
 
-- 
1.5.4.rc3.14.g44397

