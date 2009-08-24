Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZHXR4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZHXR4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZHXR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:56:05 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55681 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZHXR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=xEqhey9KJrAIXlo60yMgdy6vm9I9xfEu5JWHMZlvaAVBX47ly2unlrMI69lrtaOiip
         3aSIYG1FnvM1ue0HPsQkEKxPOSK8BRGIbZJVT2FUE/VJDC2RYF/qjgkAxisFtUiQjJhz
         fgbq2RMTmlfgaey1O/1jPYrghW7I5yI15u4Dw=
Message-Id: <20090824175551.322214127@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 24 Aug 2009 21:53:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [rfc -tip 3/4] x86,apic: fix missed handling of discrete apics
References: <20090824175335.186713800@openvz.org>
Content-Disposition: inline; filename=x86-apic-discrete-fixups-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of discrete (pretty old) apics we may have
cpu_has_apic bit not set but have to check if
smp_found_config (MP spec) is there and apic was
not disabled. So in case of discrete apic we need
to proceed apic handling.

Also don't forget to print apic/io-apic for such
case as well.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>
---

Perhaps this smp_found_config,disable_apic (which are
useful for insoectation in x86-32 only apart of cpu_has_apic)
are good candidate for helper function, say lapic_from_mp.
Dunno.Please comment.

 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -978,7 +978,7 @@ void lapic_shutdown(void)
 {
 	unsigned long flags;
 
-	if (!cpu_has_apic)
+	if (!cpu_has_apic && (!smp_found_config || disable_apic))
 		return;
 
 	local_irq_save(flags);
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -1860,7 +1860,7 @@ __apicdebuginit(int) print_all_ICs(void)
 	print_PIC();
 
 	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (!cpu_has_apic && (!smp_found_config || disable_apic))
 		return 0;
 
 	print_all_local_APICs();
@@ -1978,7 +1978,7 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	if (cpu_has_apic)
+	if (cpu_has_apic || (smp_found_config && !disable_apic))
 		disconnect_bsp_APIC(!intr_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }

