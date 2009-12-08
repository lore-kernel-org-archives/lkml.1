Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZLHP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZLHP4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZLHP4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:56:00 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43775 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZLHPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=jo6MZd8AwjwuQrJWk/Lxg8FEhyiNXGLQhiVR+k9tfZN1b1xkotUQHIfPCtz6GeiITh
         GJSYtdkBRGOI1XiDA5K6A5dtmZb+fwNbHpK2RNHf8Z5IFNxte/00qiNi2P49HTt5go6A
         H9C7QiYWW5lnqodQ1gKxJfv4i3C6c3ZFwZnlo=
Message-Id: <20091208155557.148499355@openvz.org>
User-Agent: quilt/0.47-1
Date: Tue, 08 Dec 2009 18:53:17 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Cc: macro@linux-mips.org, yinghai@kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/2] x86,mcheck: Thermal monitoring depends on APIC being enabled
References: <20091208155316.561853924@openvz.org>
Content-Disposition: inline; filename=x86-thermal-mon
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add check if APIC is not disabled since thermal
monitoring depends on it. As only apic gets disabled
we should not try to install "thermal monitor" vector,
print out that thermal monitoring is enabled and etc...

Note that "Intel Correct Machine Check Interrupts" already
has such a check as well.

Also I decided to not add cpu_has_apic check into mcheck_intel_therm_init
since even if it'll call apic_read on disabled apic -- it's safe
here and allow us to save a few code bytes.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review. This should close a number of WARNs triggered
by intel_init_thermal when apic gets disabled state.

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

