Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZHUNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZHUNvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZHUNvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:51:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZHUNvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:51:24 -0400
Date: Fri, 21 Aug 2009 15:50:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shane Wang <shane.wang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH] txt: fix the build errors on non-X86 platforms
Message-ID: <20090821135050.GA30346@elte.hu>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com> <20090820161038.GA29994@basil.fritz.box> <4A8E9B3C.5070604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8E9B3C.5070604@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shane Wang <shane.wang@intel.com> wrote:

> This patch moves tboot.h from asm to linux to fix the build errors 
> on non-X86 platforms.
>
> Signed-off-by: Shane Wang <shane.wang@intel.com>
>
>
> diff -r 04f249f00303 arch/x86/include/asm/tboot.h

[ small nit: please always generate diffstat information for your 
  patches as well, so that one can see which files are changed and 
  by how much. ]

This patch looks better, but i have to question why tboot modifies 
generic code at all.

i've attached those generic-code changes below. The init/main.c one 
could sure be done in x86 arch init code, or via an initcall, right? 

Regarding kernel/cpu.c. Tthis code in tboot_wait_for_aps() looks 
suspicious:

int tboot_wait_for_aps(int num_aps)
{
        unsigned long timeout;

        if (!tboot_enabled())
                return 0;

        timeout = jiffies + AP_WAIT_TIMEOUT*HZ;
        while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
               time_before(jiffies, timeout))
                cpu_relax();

        return time_before(jiffies, timeout) ? 0 : 1;
}

the return code looks a bit racy - what if an AP came back just in 
the final moment. It should return whether num_in_wfs == num_aps.

But more importantly, why does this have to be done in generic code 
in kernel/smp.c? Why doesnt the x86 arch level bit of _cpu_down() 
check whether the CPU goes down. (or, if there's no proper 
signalling for that one in the tboot protocol - the _cpu_down() code 
in x86 could call tboot_wait_for_aps() if num_online_cpus() == 1 - 
no need to change generic code here.

Also, as i pointed it out in prior review, this depends on line:

+config INTEL_TXT
+       bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
+       depends on EXPERIMENTAL && X86 && DMAR && ACPI

should be turned into the standard:

	depends on HAVE_INTEL_TXT 

line, where arch/x86/Kconfig selects HAVE_INTEL_TXT. As we do it for 
other options as well.

	Ingo

---------------->

 init/main.c  |    3 +++
 kernel/cpu.c |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 2d9d6bd..f8e9124 100644
--- a/init/main.c
+++ b/init/main.c
@@ -73,6 +73,7 @@
 #include <asm/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
+#include <asm/tboot.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
@@ -715,6 +716,8 @@ asmlinkage void __init start_kernel(void)
 
 	ftrace_init();
 
+	tboot_create_trampoline();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8ce1004..ff071e0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <asm/tboot.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -376,7 +377,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error;
+	int cpu, first_cpu, error, num_cpus = 0;
 
 	error = stop_machine_create();
 	if (error)
@@ -391,6 +392,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
+		num_cpus++;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpumask_set_cpu(cpu, frozen_cpus);
@@ -401,6 +403,9 @@ int disable_nonboot_cpus(void)
 			break;
 		}
 	}
+	/* ensure all CPUs have gone into wait-for-SIPI */
+	error |= tboot_wait_for_aps(num_cpus);
+
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */
