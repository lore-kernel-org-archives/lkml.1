Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0BISCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 13:02:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:54239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab0BISCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 13:02:34 -0500
Date: Tue, 9 Feb 2010 18:00:39 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, stable@kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, shaohui.zheng@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stable@kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, shaohui.zheng@intel.com
In-Reply-To: <20100118201256.672679042@sbs-t61.sc.intel.com>
References: <20100118201256.672679042@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs
Message-ID: <tip-418f727639cfc8f03068aae09f473c493c759b9b@git.kernel.org>
Git-Commit-ID: 418f727639cfc8f03068aae09f473c493c759b9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 18:00:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  418f727639cfc8f03068aae09f473c493c759b9b
Gitweb:     http://git.kernel.org/tip/418f727639cfc8f03068aae09f473c493c759b9b
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 9 Feb 2010 09:18:35 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 09:29:17 -0800

x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs

We need to fall back from logical-flat APIC mode to physical-flat mode
when we have more than 8 CPUs.  However, in the presence of CPU
hotplug, we have to consider the number of possible CPUs rather than
the number of current CPUs; otherwise we may cross the 8-CPU boundary
when CPUs are added later.

Reported-by: Shaohui Zheng <shaohui.zheng@intel.com>
Acked-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20100118201256.672679042@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/apic/apic.c     |    2 +-
 arch/x86/kernel/apic/probe_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3987e44..fc1d579 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1892,7 +1892,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	if (num_processors > 8) {
+	if (num_possible_cpus() > 8) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
 			if (!APIC_XAPIC(version)) {
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 450fe20..83e9be4 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -67,7 +67,7 @@ void __init default_setup_apic_routing(void)
 	}
 #endif
 
-	if (apic == &apic_flat && num_processors > 8)
+	if (apic == &apic_flat && num_possible_cpus() > 8)
 			apic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
