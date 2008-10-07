Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbYJGAvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYJGAvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbYJGAoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:60605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbYJGAoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:07 -0400
Date: Mon, 6 Oct 2008 17:38:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Subject: [patch 30/71] x86: fix oprofile + hibernation badness
Message-ID: <20081007003843.GE3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-oprofile-hibernation-badness.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andi Kleen <ak@linux.intel.com>

commit 80a8c9fffa78f57d7d4351af2f15a56386805ceb upstream

Vegard Nossum reported oprofile + hibernation problems:

> Now some warnings:
>
> ------------[ cut here ]------------
> WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328 s
> mp_call_function_mask+0x194/0x1a0()

The usual problem: the suspend function when interrupts are
already disabled calls smp_call_function which is not allowed with
interrupt off. But at this point all the other CPUs should be already
down anyways, so it should be enough to just drop that.

This patch should fix that problem at least by fixing cpu hotplug&
suspend support.

[ mingo@elte.hu: fixed 5 coding style errors. ]

Backported by Chuck Ebbert

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
+#include <linux/cpu.h>
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -28,23 +29,48 @@ static DEFINE_PER_CPU(unsigned long, sav
 
 static int nmi_start(void);
 static void nmi_stop(void);
+static void nmi_cpu_start(void *dummy);
+static void nmi_cpu_stop(void *dummy);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+#ifdef CONFIG_SMP
+static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
+				 void *data)
+{
+	int cpu = (unsigned long)data;
+	switch (action) {
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0, 0);
+		break;
+	case CPU_DOWN_PREPARE:
+		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 0, 1);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block oprofile_cpu_nb = {
+	.notifier_call = oprofile_cpu_notifier
+};
+#endif
+
 #ifdef CONFIG_PM
 
 static int nmi_suspend(struct sys_device *dev, pm_message_t state)
 {
+	/* Only one CPU left, just stop that one */
 	if (nmi_enabled == 1)
-		nmi_stop();
+		nmi_cpu_stop(NULL);
 	return 0;
 }
 
 static int nmi_resume(struct sys_device *dev)
 {
 	if (nmi_enabled == 1)
-		nmi_start();
+		nmi_cpu_start(NULL);
 	return 0;
 }
 
@@ -448,6 +474,9 @@ int __init op_nmi_init(struct oprofile_o
 	}
 
 	init_sysfs();
+#ifdef CONFIG_SMP
+	register_cpu_notifier(&oprofile_cpu_nb);
+#endif
 	using_nmi = 1;
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
@@ -461,6 +490,10 @@ int __init op_nmi_init(struct oprofile_o
 
 void op_nmi_exit(void)
 {
-	if (using_nmi)
+	if (using_nmi) {
 		exit_sysfs();
+#ifdef CONFIG_SMP
+		unregister_cpu_notifier(&oprofile_cpu_nb);
+#endif
+	}
 }

-- 
