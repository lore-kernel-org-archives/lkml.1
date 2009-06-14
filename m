Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZFNUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZFNUN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZFNUNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:13:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZFNUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UP3b0Y/vrPic2YetG900vJrX8fERNh4OiofurcE3bs/oHcEQ5Vgsn6VEiRDlxGFZa2
         CqRZgiwnAMnLjjQeR2SuILfXHadTSoGavj9ZZzaRkYv/am7MOuUfbHku4WhU/aqmUGio
         ZwTrGEyhYtC6mkwS4OJz51NRcx5VGWChzzM5I=
Date: Mon, 15 Jun 2009 00:06:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Subject: Re: apic: native_apic_write_dummy warning
Message-ID: <20090614200620.GB24604@lenovo>
References: <1245006351.5912.174.camel@odie.local> <20090614192220.GB4851@lenovo> <20090614194017.GA24604@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090614194017.GA24604@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Jun 14, 2009 at 11:40:17PM +0400]
... 
| Neither thermal interrupts nor mce will be functional if apic
| is not properly set up (even having kernel compiled that way
| it support both). So you may try to pass "lapic" boot option
| and check if we're lucky in attempt to enable apic via force
| push. Anyway this warn show that the code is to be fixed
| (and native_apic_write_dummy done its work great catching
|  useless apic->write operation). I'll handle it but a bit later.
| 
| Andi CC'ed since he is involved in MCE handling just for the
| record.
| 
| 	-- Cyrill

Simon here is a patch I would appreciate if you test.

	-- Cyrill

---
[PATCH -tip] x86: mce intel -- don't touch THERMAL_APIC_VECTOR if no active APIC

If APIC was disabled for some reason and not even mapped
we should not try to enable thermal interrupts at all.

Reported-by: Simon Holm Thøgersen <odie@cs.aau.dk>
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
