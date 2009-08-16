Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZHPT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZHPT5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZHPT5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:57:38 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65134 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZHPT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xO+iUXbZ8TShcFQWmYR7AEMH6QLz9pokJUJven4HeCAWstjcoYTsdd1/pD3JpdxRfB
         4Vwy9QReDd+FcgmF5S+zicjd7S28ZlhIXAlRtZAvF005ol4xaLgLse3rYsAJu1Vj9L6/
         /L3YWBRMSOO4taEWVLT43uqJ0GMCVJntdIzWU=
Date: Sun, 16 Aug 2009 23:57:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86,apic: set cpu_has_apic manually for discrete apic
Message-ID: <20090816195736.GB4788@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of discrete apic (due to hardware or firmware reason)
cpuid may not retrieve cpu_has_apic bit. But we rely on this
bit in SMP compiled kernels. So instead of long condition checking
we set cpu_has_apic bit manually and check it only in further
code flow.

Note that the case is applied to x86-32 pretty old machines only.
Also verify_local_APIC is the only place where such a trick
could be done. We can't do it earlier since there could be
a BIOS bug and other checks which we are to pass to ensure
that APIC is functional.

The patch also make lapic_shutdown, disable_IO_APIC callable
which should take place even on discrete apics.

As a side effect it makes lapic sysfs device available
for such machines so lets check for apic being integrated
since we don't support suspend/resume for disrete apics.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review carefully. I've tested it with manually disabled
cpu_has_apic and apic was set to "discrete" state as well
under qemu.

Actually this "two-line" patch could be more dangerous
then it looks like and need more wide range _long_ testing.

Or, perhaps, we could just fix lapic_shutdown and disable_IO_APIC
instead since old machines already that rare to find out.

Anyway if someone has 486DX machine please give the patch a try.

 arch/x86/kernel/apic/apic.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1004,6 +1004,25 @@ int __init verify_local_APIC(void)
 	unsigned int reg0, reg1;
 
 	/*
+	 * For discrete APIC cpu_has_apic bit may not
+	 * be retrieved via cpuid instruction. Same time
+	 * we rely on this bit (mostly for SMP compiled
+	 * kernel) and instead of checking the long condition
+	 * (as shown below) all the time we may check for
+	 * plain cpu_has_apic further in code.
+	 *
+	 * At this moment all the checks are passed and we've
+	 * already complained if there was a BIOS bug.
+	 * This place is safe for such a trick. --cvg
+	 */
+#ifdef CONFIG_X86_32
+	if (smp_found_config && !cpu_has_apic && !disable_apic) {
+		set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+		pr_info("APIC: cpu_has_apic being set manually\n");
+	}
+#endif
+
+	/*
 	 * The version register is read-only in a real APIC.
 	 */
 	reg0 = apic_read(APIC_LVR);
@@ -2145,7 +2164,7 @@ static int __init init_lapic_sysfs(void)
 {
 	int error;
 
-	if (!cpu_has_apic)
+	if (!cpu_has_apic || !lapic_is_integrated())
 		return 0;
 	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
 
