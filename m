Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbZHZIQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbZHZIQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZHZIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:16:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:41062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZHZIQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:16:38 -0400
Date: Wed, 26 Aug 2009 08:15:59 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org, shai@scalex86.org,
       gorcunov@gmail.com, kiran@scalex86.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org, gorcunov@gmail.com,
       shai@scalex86.org, kiran@scalex86.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A944D3C.5030100@kernel.org>
References: <4A944D3C.5030100@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix vSMP boot crash
Message-ID: <tip-295594e9cf6ae2efd73371777aa8feba0f87f42f@git.kernel.org>
Git-Commit-ID: 295594e9cf6ae2efd73371777aa8feba0f87f42f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 08:16:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  295594e9cf6ae2efd73371777aa8feba0f87f42f
Gitweb:     http://git.kernel.org/tip/295594e9cf6ae2efd73371777aa8feba0f87f42f
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 25 Aug 2009 13:44:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 10:13:17 +0200

x86: Fix vSMP boot crash

2.6.31-rc7 does not boot on vSMP systems:

[    8.501108] CPU31: Thermal monitoring enabled (TM1)
[    8.501127] CPU 31 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    8.650254] CPU31: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 04
[    8.710324] Brought up 32 CPUs
[    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
[    8.721489] ERROR: parent span is not a superset of domain->span
[    8.727686] ERROR: domain->groups does not contain CPU0
[    8.733091] ERROR: groups don't span domain->span
[    8.737975] ERROR: domain->cpu_power not set
[    8.742416]

Ravikiran Thirumalai bisected it to:

| commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c
| x86: don't call read_apic_id if !cpu_has_apic

The problem is that on vSMP systems the CPUID derived
initial-APICIDs are overlapping - so we need to fall
back on hard_smp_processor_id() which reads the local
APIC.

Both come from the hardware (influenced by firmware
though) so it's a tough call which one to trust.

Doing the quirk expresses the vSMP property properly
and also does not affect other systems, so we go for
this solution instead of a revert.

Reported-and-Tested-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shai Fultheim <shai@scalex86.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4A944D3C.5030100@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index bc3e880..fcec2f1 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initdata = {
 	NULL,
 };
 
+static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
@@ -69,6 +74,11 @@ void __init default_setup_apic_routing(void)
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
+	if (is_vsmp_box()) {
+		/* need to update phys_pkg_id */
+		apic->phys_pkg_id = apicid_phys_pkg_id;
+	}
+
 	/*
 	 * Now that apic routing model is selected, configure the
 	 * fault handling for intr remapping.
