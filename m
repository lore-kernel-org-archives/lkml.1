Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbZLHP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbZLHP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbZLHPz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:55:58 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36980 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbZLHPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=cAGPe2Gt1p3cST7754Hi6XmnORDvp6T+Iv+q5rDVY5Cpa5KLClwqKqvs2IpkCtpFDt
         +K2xN5GdhA37DLCcRnmxQ4HR9hbBBn6Q7L96LKrJIB2wI1kHLm3Jxff6pL6kRCihTypp
         dCgbdtmGJDewdlE1MRip/DcdNX2lmxlQO9M+4=
Message-Id: <20091208155557.326359748@openvz.org>
User-Agent: quilt/0.47-1
Date: Tue, 08 Dec 2009 18:53:18 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Cc: macro@linux-mips.org, yinghai@kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/2] x86,apic: Use logical OR in noop-write operation
References: <20091208155316.561853924@openvz.org>
Content-Disposition: inline; filename=x86-apic-noop-read-write
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For apic noop'ified we have to use logical OR statement,
otherwise any write on systems shipped with 82489DX
(where apic presence bit can't be retrieved via cpuid)
will not trigger the warning which is not desired.

In turn noop'ified read operation remains using logical
AND statement. This will catch _only_ future code bugs
since:

1) The old 32bit systems without apic presence bit use
   disable_apic only as a flag that chip was turned off
   via boot option but not due to MP-table (BIOS) bug where
   we may try to re-enable apic via MSR registers. The further
   SMP setup code already prepared for a such situation
   (ie it disables SMP support) and do not issue write
   operations but still needs to issue apic_read. So instead
   of deforming code with "if" we just allow reads until
   SMP support gets disabled. But even then we still need
   apic_read issued on a such machine at shutdown procedure.

2) x86-64 at moment properly uses cpu_has_apic and turn
   this feature off as only chip is disabled together
   with disable_apic flag.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review, I hope this explanation is more or less good
though I would be glad to hear complains a well :)

 arch/x86/kernel/apic/apic_noop.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -119,15 +119,41 @@ int noop_apicid_to_node(int logical_apic
 	return 0;
 }
 
+/*
+ * we use logical AND here just to suppress a
+ * number of WARNs which would take place all
+ * over the code if the kernel is SMP compatible
+ * and we would need to deform code with a lot
+ * of "if" statements then (especially on x86-32
+ * with discrete apic chip)
+ *
+ * note that even if apic was not disabled via
+ * boot option we still may have apic broken
+ * due to buggy BIOS/MP-table/ACPI so we allow
+ * any read operation on a such systems in a sake
+ * of callers code simplicity
+ */
 static u32 noop_apic_read(u32 reg)
 {
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
+	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 	return 0;
 }
 
+/*
+ * we don't use logical AND here because otherwise
+ * any writes on 486DXSL (which has no apic presence
+ * bit retrieved via cpuid) will never trigger
+ * this WARN allowing a (possible buggy) code to
+ * continue executing, so consider this WARN as
+ * a strict guard against unpredicted/inaccurate
+ * apic code modifications or/and buggy callers
+ *
+ * in short -- warn every write on enabled apic
+ * (both 82489DX and integrated LAPICs)
+ */
 static void noop_apic_write(u32 reg, u32 v)
 {
-	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
+	WARN_ON_ONCE(cpu_has_apic || !disable_apic);
 }
 
 struct apic apic_noop = {

