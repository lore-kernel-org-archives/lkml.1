Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZGKV3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZGKV3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZGKV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:29:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZGKV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QJ1n4LeiMp1IpvkWovLSkZCGQRfNIlQLGCyrBwJCRe3GO9/AOwXdWZT//nqljbT5FV
         cCtjTmYomPwsMQms1BBdUGN3w78Ro0VtBoPasZDQm29R+VUt3tJYE6aABND7AqtX99OQ
         FufulPgwtG6uk7LjpRff3XoGQIY2bFNecDHVU=
Date: Sun, 12 Jul 2009 01:29:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86,apic - set cpu_has_apic for discrete apic
Message-ID: <20090711212929.GG5325@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of discrete apic (due to hardware or firmware reason)
cpuid may not retrieve cpu_has_apic bit. So for SMP
compiled kernels instead of long check we may set "fake"
cpu_has_apic bit and check only the bit in further code
flow.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review carefully.

 arch/x86/kernel/apic/apic.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1003,6 +1003,20 @@ int __init verify_local_APIC(void)
 	unsigned int reg0, reg1;
 
 	/*
+	 * For discrete APIC case cpu_has_apic bit could not
+	 * be retrieved via cpuid instruction. Same time
+	 * we rely on this bit (mostly for SMP compiled
+	 * kernel) and instead of checking the long condition
+	 * below all the time we do check for plain cpu_has_apic.
+	 *
+	 * At this moment all the checks are passed and we've
+	 * already complained if there was a BIOS bug. This place
+	 * should be safe for such a trick. --cvg
+	 */
+	if (smp_found_config && !cpu_has_apic && !disable_apic)
+		set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+
+	/*
 	 * The version register is read-only in a real APIC.
 	 */
 	reg0 = apic_read(APIC_LVR);
