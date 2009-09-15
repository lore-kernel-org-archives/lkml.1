Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZIOHMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZIOHMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbZIOHMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:12:31 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43242 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbZIOHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XMH9mfgZocsU5Zj+cuiHntuEc1bznt5CDFG6Qbt1Kumh0xqpSuIMtKA8q2RmSv5ili
         MZUilhdToalzLMp2IgBT/KSSThCAnu5FYXjLE8u+zTi5HD/33+YnIhHR4LY6wqsyhtE9
         sf+qA9YQ7rYxtwGt/0uGdUrxVwiRy3vupWFpY=
Date: Tue, 15 Sep 2009 11:12:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip resend] x86,apic: fix missed handling of discrete apics
Message-ID: <20090915071230.GA10604@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of discrete (pretty old) apics we may have
cpu_has_apic bit not set but have to check if
smp_found_config (MP spec) is there and apic was
not disabled.

Also don't forget to print apic/io-apic for such
case as well.

CC: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I thought about use plain (smp_found_config & disable_apic)
but it would look fishy and fragile.

Also I don't use #ifdef (yes, this helper make sense
for x86-32 mostly since on 64bit we rely on cpuid
and additional checking is not needed, but since
the helper is called only three times and mostly
during shutdown procedure -- a few ticks would not
hurt much but save us from code deformation and
make the helper more "general" in sense like
just checking two flags at once).

Note as well that cpu_has_config is not incorporated
into the helper by purpose. Lets leave this bit
being cheking explicitly. One day we would not
need this helper (it's already that hard to find
discrete apic systems not reporting apic bit via
cpuid (amdk5 which uses this bit for PGE support
is not taken into account :)

Please review. Comments are appreciated.

 arch/x86/include/asm/apic.h    |   13 +++++++++++++
 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -66,6 +66,19 @@ static inline void default_inquire_remot
 }
 
 /*
+ * With 82489DX we can't rely on apic feature bit
+ * retrieved via cpuid but still have to deal with
+ * such an apic chip so we assume that SMP configuration
+ * is found from MP table (64bit case uses ACPI mostly
+ * which set smp presence flag as well so we are safe
+ * to use this helper too). --cvg
+ */
+static inline bool apic_from_smp_config(void)
+{
+	return (smp_found_config && !disable_apic);
+}
+
+/*
  * Basic functions accessing APICs.
  */
 #ifdef CONFIG_PARAVIRT
Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -979,7 +979,7 @@ void lapic_shutdown(void)
 {
 	unsigned long flags;
 
-	if (!cpu_has_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return;
 
 	local_irq_save(flags);
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -1874,7 +1874,7 @@ __apicdebuginit(int) print_all_ICs(void)
 	print_PIC();
 
 	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
 	print_all_local_APICs();
@@ -1999,7 +1999,7 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	if (cpu_has_apic)
+	if (cpu_has_apic || apic_from_smp_config())
 		disconnect_bsp_APIC(!intr_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
