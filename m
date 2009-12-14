Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZLNJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZLNJt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZLNJtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:49:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:48393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbZLNJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:49:53 -0500
Date: Mon, 14 Dec 2009 09:49:16 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B25FDC2.3020401@jp.fujitsu.com>
References: <4B25FDC2.3020401@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce: Thermal monitoring depends on APIC being enabled
Message-ID: <tip-485a2e1973fd9f98c2c6776e66ac4721882b69e0@git.kernel.org>
Git-Commit-ID: 485a2e1973fd9f98c2c6776e66ac4721882b69e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  485a2e1973fd9f98c2c6776e66ac4721882b69e0
Gitweb:     http://git.kernel.org/tip/485a2e1973fd9f98c2c6776e66ac4721882b69e0
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 14 Dec 2009 17:56:34 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 10:38:41 +0100

x86, mce: Thermal monitoring depends on APIC being enabled

Add check if APIC is not disabled since thermal
monitoring depends on it. As only apic gets disabled
we should not try to install "thermal monitor" vector,
print out that thermal monitoring is enabled and etc...

Note that "Intel Correct Machine Check Interrupts" already
has such a check.

Also I decided to not add cpu_has_apic check into
mcheck_intel_therm_init since even if it'll call apic_read on
disabled apic -- it's safe here and allow us to save a few code
bytes.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: <4B25FDC2.3020401@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 1003ed4..0a9b577 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -274,8 +274,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	int tm2 = 0;
 	u32 l, h;
 
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+	/* Thermal monitoring depends on APIC, ACPI and clock modulation */
+	if (!cpu_has_apic || !cpu_has(c, X86_FEATURE_ACPI) ||
+		!cpu_has(c, X86_FEATURE_ACC))
 		return;
 
 	/*
