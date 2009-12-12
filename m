Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZLMCJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZLMCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZLMCJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:09:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45475 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752293AbZLMCJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WsSWg0cQs27oBcvvrFX9UcHNFEKAo4aI+Mx4VQjhJUtvb+4mI1F/NwUT0/56Z1Q1KT
         A3e2nilWlJKhSTXRwWtB8/9fyskV/w2BCNKm3xbVCLfavERovURLo/0ErMtw/djh9HVw
         cSFg8hPF0eo1UqVvjBJa4cb1eDL52J6OOnAu4=
Date: Sat, 12 Dec 2009 17:31:55 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH resend -tip] x86,mcheck: Thermal monitoring depends on APIC
	being enabled
Message-ID: <20091212143155.GB15467@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add check if APIC is not disabled since thermal
monitoring depends on it. As only apic gets disabled
we should not try to install "thermal monitor" vector,
print out that thermal monitoring is enabled and etc...

Note that "Intel Correct Machine Check Interrupts" already
has such a check.

Also I decided to not add cpu_has_apic check into mcheck_intel_therm_init
since even if it'll call apic_read on disabled apic -- it's safe
here and allow us to save a few code bytes.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review. This should close a number of WARNs triggered
by intel_init_thermal when apic gets disabled state.

Ie the WARNs like

	http://kerneloops.org/oops.php?number=974702

 arch/x86/kernel/cpu/mcheck/therm_throt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/mcheck/therm_throt.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ linux-2.6.git/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -274,8 +274,9 @@ void intel_init_thermal(struct cpuinfo_x
 	int tm2 = 0;
 	u32 l, h;
 
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+	/* Thermal monitoring depends on APIC, ACPI and clock modulation */
+	if (!cpu_has_apic || !cpu_has(c, X86_FEATURE_ACPI) ||
+		!cpu_has(c, X86_FEATURE_ACC))
 		return;
 
 	/*

