Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZFGMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZFGMsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZFGMsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:48:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33684 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbZFGMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cgVcI860AW1Mh43FKTjAtzihdxTmHg7qFIWo9e9WYJ1/f0uWLQXaYoiEpK+MAXghOx
         dfeRLYipDtz9AO7NT+IOx+qr/OA38CKad6I4MWvuxfnwsEINQYqL3b2XNmbR/j4iJC/s
         Nuh0voRk9Bm07XjWl7g+9yb1gsuvhJCcwtYoo=
Date: Sun, 7 Jun 2009 16:48:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: apic - fix dummy apic read operation together
	with broken MP handling
Message-ID: <20090607124840.GD4547@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar reported that read_apic is screwed up novadays

[    0.000000] Using APIC driver default
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] APIC: disable apic facility
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
[    0.000000] Hardware name: HP OmniBook PC

Indeed we still rely on apic->read operation for SMP compiled
kernel. And instead of disfigure the SMP code with #ifdef we
allow to call apic->read. To capture any unexpected results
we check for apic->read being called for sane reason via
WARN_ON_ONCE but(!) instead of OR we should use AND logical
operation (thanks Yinghai for spotting the root of the problem).

Along with that we could be having screwed MP table and we are
to fix it that way no Symmetric I/O started and no complains
about BIOS bug if apic was just disabled via command line.

CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please check carefully! Complains are welcome :)

 arch/x86/kernel/apic/apic.c |    9 ++++++++-
 arch/x86/kernel/smpboot.c   |    8 +++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -251,7 +251,7 @@ static void native_apic_write_dummy(u32 
 
 static u32 native_apic_read_dummy(u32 reg)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 	return 0;
 }
 
@@ -1612,6 +1612,13 @@ void __init init_apic_mappings(void)
 	new_apicid = read_apic_id();
 	if (boot_cpu_physical_apicid != new_apicid) {
 		boot_cpu_physical_apicid = new_apicid;
+		/*
+		 * yeah -- we lie about apic_version
+		 * in case if apic was disabled via boot option
+		 * but it's not a problem for SMP compiled kernel
+		 * since smp_sanity_check is prepared for such a case
+		 * and disable smp mode
+		 */
 		apic_version[new_apicid] =
 			 GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
Index: linux-2.6.git/arch/x86/kernel/smpboot.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.git/arch/x86/kernel/smpboot.c
@@ -994,10 +994,12 @@ static int __init smp_sanity_check(unsig
 	 */
 	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
 	    !cpu_has_apic) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_physical_apicid);
-		printk(KERN_ERR "... forcing use of dummy APIC emulation."
+		if (!disable_apic) {
+			pr_err("BIOS bug, local APIC #%d not detected!...\n",
+				boot_cpu_physical_apicid);
+			pr_err("... forcing use of dummy APIC emulation."
 				"(tell your hw vendor)\n");
+		}
 		smpboot_clear_io_apic();
 		arch_disable_smp_support();
 		return -1;
