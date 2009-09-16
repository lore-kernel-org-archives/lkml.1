Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZIPFVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZIPFVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZIPFVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:21:17 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51488 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZIPFVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XJHAXbVrhWXBQicloYNQmIB4gtSVU6vnQzEczZbIqEqwnUdimJtP3zwjt6gbw8LqAf
         F0kyN9iA18SWrTRY3P0zbeGAqVyaYHZO3VrWqCabJUY4AVhaopi4ujhW7DF5H/32Sz5R
         usodsbvDtRdTdoeznOKQDqzLg1a1hP4/MGhyY=
Subject: [PATCH] arm: Make kprobes unregistration SMP safe
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nico@fluxnic.net, Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 07:21:16 +0200
Message-Id: <1253078476.5021.65.camel@funkybook>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM kprobes use an illegal instruction to trigger kprobes. In the
current implementation, there's a race between the unregistration of a
kprobe and the illegal instruction exception handler if they run at the
same time on different cores. 

When reading the value of the undefined instruction, the exception
handler might get the original legal instruction as just patched
concurrently by arch_disarm_kprobe(). When this happen the kprobe
handler won't run, and thus the exception handler will oops because it
believe it just hit an undefined instruction in kernel space.

The following patch synchronizes the code patching in the kprobes
unregistration using stop_machine and thus avoids the above race.

Signed-off-by: Frederic RISS <frederic.riss@gmail.com>

---

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index d28513f..6ada87d 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/module.h>
+#include <linux/stop_machine.h>
 #include <linux/stringify.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
@@ -83,10 +84,24 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
 	flush_insns(p->addr, 1);
 }
 
+/*
+ * The actual disarming is done here on each CPU and synchronized using
+ * stop_machine. This synchronization is necessary on SMP to avoid removing
+ * a probe between the moment the 'Undefined Instruction' exception is raised
+ * and the moment the exception handler reads the faulting instruction from
+ * memory.
+ */
+int __kprobes __arch_disarm_kprobe(void *p)
+{
+	struct kprobe *kp = p;
+	*kp->addr = kp->opcode;
+	flush_insns(kp->addr, 1);
+	return 0;
+}
+
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	*p->addr = p->opcode;
-	flush_insns(p->addr, 1);
+	stop_machine(__arch_disarm_kprobe, p, &cpu_online_map);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)


