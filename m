Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYJBTbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYJBTbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYJBTbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:31:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYJBTbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:31:16 -0400
Date: Thu, 2 Oct 2008 15:30:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch x86/core] x86: allow number of additional hotplug CPUs to be
 set at compile time, V2
Message-ID: <20081002153007.2e031232@redhat.com>
In-Reply-To: <20081002081231.GC17695@elte.hu>
References: <20081001191945.4182d0be@redhat.com>
	<20081002081231.GC17695@elte.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

x86: allow number of additional hotplug CPUs to be set at compile time, V2

The default number of additional CPU IDs for hotplugging is determined
by asking ACPI or mptables how many "disabled" CPUs there are in the
system, but many systems get this wrong so that e.g. a uniprocessor
machine gets an extra CPU allocated and never switches to single CPU
mode.

And sometimes CPU hotplugging is enabled only for suspend/hibernate
anyway, so the additional CPU IDs are not wanted. Allow the number
to be set to zero at compile time.

Also, force the number of extra CPUs to zero if hotplugging is disabled
which allows removing some conditional code.

Tested on uniprocessor x86_64 that ACPI claims has a disabled processor,
with CPU hotplugging configured.

("After" has the number of additional CPUs set to 0)
Before: NR_CPUS: 512, nr_cpu_ids: 2, nr_node_ids 1
After: NR_CPUS: 512, nr_cpu_ids: 1, nr_node_ids 1

[Changed the name of the option and the prompt according to Ingo's
 suggestion.]

---

Index: linux-2.6.26.noarch/arch/x86/Kconfig
===================================================================
--- linux-2.6.26.noarch.orig/arch/x86/Kconfig
+++ linux-2.6.26.noarch/arch/x86/Kconfig
@@ -1366,6 +1366,24 @@ config HOTPLUG_CPU
 	  Say N if you want to disable CPU hotplug and don't need to
 	  suspend.
 
+config HOTPLUG_RESTRICT_TO_BOOTUP_CPUS
+	def_bool n
+	prompt "Restrict CPU hotplugging to processors found during boot" if HOTPLUG_CPU
+	---help---
+	  Say no here to use the default, which allows as many CPUs as are marked
+	  "disabled" by ACPI or MPTABLES to be hotplugged after bootup.
+
+	  Say yes if you do not want to allow CPUs to be added after booting, for
+	  example if you only need CPU hotplugging enabled for suspend/resume.
+
+	  If CPU_HOTPLUG is enabled this value may be overridden at boot time
+	  with the "additional_cpus" kernel parameter.
+
+config HOTPLUG_ADDITIONAL_CPUS
+	int
+	default  0 if !HOTPLUG_CPU || HOTPLUG_RESTRICT_TO_BOOTUP_CPUS
+	default -1
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
Index: linux-2.6.26.noarch/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.26.noarch.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.26.noarch/arch/x86/kernel/smpboot.c
@@ -1254,7 +1254,7 @@ void __init native_smp_cpus_done(unsigne
 	check_nmi_watchdog();
 }
 
-static int additional_cpus __initdata = -1;
+static int additional_cpus __initdata = CONFIG_HOTPLUG_ADDITIONAL_CPUS;
 
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
@@ -1282,16 +1282,13 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-#ifdef CONFIG_HOTPLUG_CPU
 	if (additional_cpus == -1) {
 		if (disabled_cpus > 0)
 			additional_cpus = disabled_cpus;
 		else
 			additional_cpus = 0;
 	}
-#else
-	additional_cpus = 0;
-#endif
+
 	possible = num_processors + additional_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
