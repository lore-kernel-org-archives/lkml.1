Return-Path: <linux-kernel-owner+w=401wt.eu-S1765431AbZFOS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765431AbZFOS0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765218AbZFOS0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:26:35 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:40064 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765358AbZFOS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:26:34 -0400
X-Greylist: delayed 80416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 14:26:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=V5n9zccv0Vkrcpp7J5wS6yqChQWJ0hncVl2O9o3buDqiOLStz+tSO/x2ST5H+WGMx1
         qfNrVA3oMZa84/LXAiIYuAlEvT7YJ4Sy2m+6cn/2r5v3in8j/qUN7Digyg0fj8m/8rrB
         Ffrh6SZsIWvlbQEwrIGX+A1hgaIItTuHbNYnA=
Date: Mon, 15 Jun 2009 22:26:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: [PATCH -tip] x86: mce intel -- don't touch THERMAL_APIC_VECTOR if
	no active APIC present
Message-ID: <20090615182633.GA7606@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If APIC was disabled (for some reason) and as result
it's not even mapped we should not try to enable thermal
interrupts at all.

Reported-by: Simon Holm Thøgersen <odie@cs.aau.dk>
Tested-by: Simon Holm Thøgersen <odie@cs.aau.dk>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/mcheck/mce_intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -21,9 +21,15 @@ void intel_init_thermal(struct cpuinfo_x
 	int tm2 = 0;
 	u32 l, h;
 
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+	/*
+	 * Thermal monitoring depends on ACPI, clock modulation
+	 * and APIC as well
+	 */
+	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC) ||
+		!cpu_has(c, X86_FEATURE_APIC)) {
+		pr_debug("Thermal monitoring disabled\n");
 		return;
+	}
 
 	/*
 	 * First check if its enabled already, in which case there might

