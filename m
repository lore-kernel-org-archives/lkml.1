Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZFGO0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZFGO0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZFGO01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:26:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZFGO00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:26:26 -0400
Date: Sun, 7 Jun 2009 14:24:31 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090607124840.GD4547@lenovo>
References: <20090607124840.GD4547@lenovo>
Subject: [tip:irq/numa] x86, apic: Fix dummy apic read operation together with broken MP handling
Message-ID: <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org>
Git-Commit-ID: 103428e57be323c3c5545db8ad12667099bc6005
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 14:24:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  103428e57be323c3c5545db8ad12667099bc6005
Gitweb:     http://git.kernel.org/tip/103428e57be323c3c5545db8ad12667099bc6005
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 7 Jun 2009 16:48:40 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 16:08:05 +0200

x86, apic: Fix dummy apic read operation together with broken MP handling

Ingo Molnar reported that read_apic is buggy novadays:

[    0.000000] Using APIC driver default
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] APIC: disable apic facility
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
[    0.000000] Hardware name: HP OmniBook PC

Indeed we still rely on apic->read operation for SMP compiled
kernel. And instead of disfigure the SMP code with #ifdef we
allow to call apic->read. To capture any unexpected results
we check for apic->read being called for sane reason via
WARN_ON_ONCE but(!) instead of OR we should use AND logical
operation (thanks Yinghai for spotting the root of the problem).

Along with that we could be have bad MP table and we are
to fix it that way no SMP started and no complains about
BIOS bug if apic was just disabled via command line.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090607124840.GD4547@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    9 ++++++++-
 arch/x86/kernel/smpboot.c   |    8 +++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e82488d..a4c9cf0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -249,7 +249,7 @@ static void native_apic_write_dummy(u32 reg, u32 v)
 
 static u32 native_apic_read_dummy(u32 reg)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 	return 0;
 }
 
@@ -1609,6 +1609,13 @@ void __init init_apic_mappings(void)
 	new_apicid = read_apic_id();
 	if (boot_cpu_physical_apicid != new_apicid) {
 		boot_cpu_physical_apicid = new_apicid;
+		/*
+		 * yeah -- we lie about apic_version
+		 * in case if apic was disabled via boot option
+		 * but it's not a problem for SMP compiled kernel
+		 * since smp_sanity_check is prepared for such a case
+		 * and disable smp mode
+		 */
 		apic_version[new_apicid] =
 			 GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d2e8de9..7c80007 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -992,10 +992,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
 	    !cpu_has_apic) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_physical_apicid);
-		printk(KERN_ERR "... forcing use of dummy APIC emulation."
+		if (!disable_apic) {
+			pr_err("BIOS bug, local APIC #%d not detected!...\n",
+				boot_cpu_physical_apicid);
+			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
+		}
 		smpboot_clear_io_apic();
 		arch_disable_smp_support();
 		return -1;
