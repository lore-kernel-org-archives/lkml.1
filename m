Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYAPTq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYAPTq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYAPTqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:46:21 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:42780 "EHLO
	mail8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYAPTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:46:20 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 16 Jan 2008 20:46:06 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: [PATCH] x86: fix detection of CONSTANT_TSC bit for AMD CPUs
Message-ID: <20080116194606.GB11244@alberich.amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Jan 2008 19:45:56.0966 (UTC)
 FILETIME=[69845860:01C85878]
X-WSS-ID: 6B90817207S8212559-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits
 - c52f61fcbdb2aa84f0e4d831ef07f375e6b99b2c 
  (x86: allow TSC clock source on AMD Fam10h and some cleanup)
 - e30436f05d456efaff77611e4494f607b14c2782
  (x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection)

are supposed to fix the detection of contant TSC for AMD CPUs.
Unfortunately on x86_64 it does still not work with current x86/mm.
For a Phenom I still get:

  ...
  TSC calibrated against PM_TIMER 
  Marking TSC unstable due to TSCs unsynchronized
  time.c: Detected 2288.366 MHz processor.
  ...

We have to set c->x86_power in early_identify_cpu to properly detect
the CONSTANT_TSC bit in early_init_amd.

Attached patch fixes this issue. Following the relevant boot
messages when the fix is used:

  ...
  TSC calibrated against PM_TIMER
  time.c: Detected 2288.279 MHz processor.
  ...
  Initializing CPU#1
  ...
  checking TSC synchronization [CPU#0 -> CPU#1]: passed.
  ...
  Initializing CPU#2
  ...
  checking TSC synchronization [CPU#0 -> CPU#2]: passed.
  ...
  Booting processor 3/4 APIC 0x3
  ...
  checking TSC synchronization [CPU#0 -> CPU#3]: passed.
  Brought up 4 CPUs
  ...

Patch is against x86/mm (v2.6.24-rc8-672-ga9f7faa).
Please apply.


Regards,

Andreas

---
x86_64: fix detection of CONSTANT_TSC bit for AMD CPUs

Set c->x86_power in early_identify_cpu. This ensures that
X86_FEATURE_CONSTANT_TSC can properly be set in early_init_amd.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c8dcdd2..aeaa17d 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1021,6 +1021,10 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
+	c->extended_cpuid_level = cpuid_eax(0x80000000);
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
@@ -1091,11 +1095,6 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	numa_add_cpu(smp_processor_id());
 #endif
 
-	c->extended_cpuid_level = cpuid_eax(0x80000000);
-
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);



