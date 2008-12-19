Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYLSXPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYLSXPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYLSXPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:15:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:4776 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYLSXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=a0IB/mWu8PbYFfkVoNK2dPJMpA8ErLBatmRJLq9a1kc03XVIHTho8yZI2jJEQn7PqT
         PSo61iVyFkVe3Jv/zrqF5KipVnhYMhvVkvsX2dP27NL/r+ZWlvt/59Zo7DrU+Qh8bVPu
         9PRQjSECPwayIg7L2K7iv4uefvjY+5VQdOgEU=
Subject: [patch] Re: [Bug #12100] resume (S2R) broken by Intel microcode
	module, on A110L
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Mohr <andi@lisas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 00:15:24 +0100
Message-Id: <1229728524.5122.13.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


This is in response to the following bug report:

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12100
Subject         : resume (S2R) broken by Intel microcode module, on A110L
Submitter       : Andreas Mohr <andi@lisas.de>
Date            : 2008-11-25 08:48 (19 days old)
Handled-By      : Dmitry Adamushko <dmitry.adamushko@gmail.com>


---

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [microcode] fix a deadlock in microcode_resume_cpu()

[ The deadlock scenario has been discovered by Andreas Mohr ]

I think I might have a logical explanation why the system 
(http://bugzilla.kernel.org/show_bug.cgi?id=12100)
might hang upon resuming, OTOH it should have likely hanged each and every time.

(1) possible deadlock in microcode_resume_cpu() if either 'if' section is
taken;

(2) now, I don't see it in spec. and can't experimentally verify it (newer
ucodes don't seem to be available for my Core2duo)... but logically-wise, I'd
think that when read upon resuming, the 'microcode revision' (MSR 0x8B) should
be back to its original one (we need to reload ucode anyway so it doesn't seem
logical if a cpu doesn't drop the version)... if so, the comparison with
memcmp() for the full 'struct cpu_signature' is wrong... and that's how one of
the aforementioned 'if' sections might have been triggered - leading to a
deadlock.

Obviously, in my tests I simulated loading/resuming with the ucode of the same
version (just to see that the file is loaded/re-loaded upon resuming) so this
issue has never popped up.

I'd appreciate if someone with an appropriate system might give a try to the
2nd patch (titled "fix a comparison && deadlock...").


In any case, the deadlock situation is a must-have fix.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Info Molnar <mingo@elte.hu>
CC: Andreas Mohr <andi@lisas.de>


---

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 82fb280..c4b5b24 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -272,13 +272,18 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static void microcode_fini_cpu(int cpu)
+static void __microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	mutex_lock(&microcode_mutex);
 	microcode_ops->microcode_fini_cpu(cpu);
 	uci->valid = 0;
+}
+
+static void microcode_fini_cpu(int cpu)
+{
+	mutex_lock(&microcode_mutex);
+	__microcode_fini_cpu(cpu);
 	mutex_unlock(&microcode_mutex);
 }
 
@@ -306,12 +311,16 @@ static int microcode_resume_cpu(int cpu)
 	 * to this cpu (a bit of paranoia):
 	 */
 	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		microcode_fini_cpu(cpu);
+		__microcode_fini_cpu(cpu);
+		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
+				cpu);
 		return -1;
 	}
 
-	if (memcmp(&nsig, &uci->cpu_sig, sizeof(nsig))) {
-		microcode_fini_cpu(cpu);
+	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
+		__microcode_fini_cpu(cpu);
+		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
+				cpu);
 		/* Should we look for a new ucode here? */
 		return 1;
 	}
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 622dc4a..a8e6279 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -155,6 +155,7 @@ static DEFINE_SPINLOCK(microcode_update_lock);
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
+	unsigned long flags;
 	unsigned int val[2];
 
 	memset(csig, 0, sizeof(*csig));
@@ -174,11 +175,16 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
+	/* serialize access to the physical write to MSR 0x79 */
+	spin_lock_irqsave(&microcode_update_lock, flags);
+
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 	/* see notes above for revision 1.07.  Apparent chip bug */
 	sync_core();
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
+	spin_unlock_irqrestore(&microcode_update_lock, flags);
+
 	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
 			csig->sig, csig->pf, csig->rev);
 


