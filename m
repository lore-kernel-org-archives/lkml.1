Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbXD2Kxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbXD2Kxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXD2Kxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:52151 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbXD2KxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:18 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Thierry Vignaud <tvignaud@mandriva.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [28/48] i386: prevent ACPI quirk warning mass spamming in logs
Message-Id: <20070429105317.8672E15108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thierry Vignaud <tvignaud@mandriva.com>

The following patch prevent this warning to be displayed again & again (eg:
nine times on my NForce2 motherboard) and thus improve signal to noise
ratio in logs.

The ATI quirk below probably needs a similar "fix" but I don't have
the hardware to test.

Btw arch/x86_64/kernel/early-quirks.c::nvidia_bugs() would probably need to
be synced (but I don't have an x86_64 NVidia motherboard to boot test it). 
Still it shows the usefullity of the recent x86 merge thread.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Thierry Vignaud <tvignaud@mandriva.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/earlyquirk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/acpi/earlyquirk.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/earlyquirk.c
+++ linux/arch/i386/kernel/acpi/earlyquirk.c
@@ -21,11 +21,14 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
+	static int warned;
 #ifdef CONFIG_ACPI
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		if (!warned && acpi_table_parse(ACPI_SIG_HPET,
+						nvidia_hpet_check)) {
+			warned = 1;
 			acpi_skip_timer_override = 1;
 			  printk(KERN_INFO "Nvidia board "
                        "detected. Ignoring ACPI "
